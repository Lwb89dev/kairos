import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/profile.dart';
import '../utils/constants.dart';
import '../utils/logger.dart';
import '../utils/relay_url.dart';
import 'auth_provider.dart';
import 'service_providers.dart';
import 'sync_mode_provider.dart';

/// The signed-in account's public Nostr profile (display name + avatar),
/// re-fetched whenever [authProvider] resolves to a (possibly new) user.
///
/// Emits the last-cached profile (SharedPreferences) immediately, if any, then
/// replaces it with a freshly-fetched one once the relay round-trip completes,
/// so the UI never shows a blank state on launch. A failed/empty fetch keeps
/// whatever was cached rather than clearing it: a stale name/avatar is better
/// than none for this decorative, non-critical feature.
class ProfileNotifier extends AsyncNotifier<NostrProfile?> {
  @override
  Future<NostrProfile?> build() async {
    debugLog('ProfileNotifier.build called', name: 'ProfileNotifier');
    final author = ref.watch(authProvider).value;
    if (author == null) return null; // Offline/local-only: no profile to show.

    final cached = await _loadCached(author.publicKeyHex);
    if (cached != null) state = AsyncData(cached);

    NostrProfile? fetched;
    try {
      final relays = ref.read(syncConfigProvider).value?.relays ?? const [];
      if (relays.isEmpty) return cached;
      fetched = await ref
          .read(nostrServiceProvider)
          .fetchProfileMetadata(
            publicKeyHex: author.publicKeyHex,
            relayUrls: relays,
          );
    } catch (_) {
      debugLog('Could not refresh profile metadata', name: 'ProfileNotifier');
    }
    if (fetched == null) return cached;

    await _saveCached(fetched);
    return fetched;
  }

  Future<NostrProfile?> _loadCached(String publicKeyHex) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(AppConstants.prefsProfileCacheKey);
    if (raw == null) return null;
    try {
      final profile = NostrProfile.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
      // Guards against showing a previous account's cached name/avatar right
      // after switching accounts.
      return profile.publicKeyHex == publicKeyHex ? profile : null;
    } catch (_) {
      return null;
    }
  }

  Future<void> _saveCached(NostrProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      AppConstants.prefsProfileCacheKey,
      jsonEncode(profile.toJson()),
    );
  }
}

final profileProvider = AsyncNotifierProvider<ProfileNotifier, NostrProfile?>(
  ProfileNotifier.new,
);

/// Downloads and disk-caches the avatar at [url] (a profile's public `picture`
/// field — not encrypted, the same image any other Nostr client shows), keyed
/// by the URL's sha256 so re-fetching the same profile never re-downloads it.
/// Returns null on any failure (missing image, network error, non-200): the
/// account row falls back to a plain icon, same as "no avatar set".
final avatarFileProvider = FutureProvider.family<File?, String>((
  ref,
  url,
) async {
  final cacheService = ref.watch(fileCacheServiceProvider);
  final key = sha256.convert(utf8.encode(url)).toString();

  final cached = await cacheService.get(key);
  if (cached != null) return cached;

  final uri = _safeAvatarUri(url);
  if (uri == null) return null;

  try {
    final bytes = await _downloadAvatar(uri);
    return bytes == null ? null : await cacheService.put(key, bytes);
  } catch (_) {
    debugLog('Could not download profile avatar', name: 'avatarFileProvider');
    return null;
  }
});

const int _maxAvatarBytes = 5 * 1024 * 1024;
const int _maxAvatarRedirects = 3;
const Duration _avatarTimeout = Duration(seconds: 15);

const Set<String> _allowedAvatarTypes = {
  'image/png',
  'image/jpeg',
  'image/webp',
  'image/gif',
};

/// Follows up to [_maxAvatarRedirects] hops manually — `followRedirects` is
/// off so every hop is re-validated by [_safeAvatarUri] instead of trusting
/// the client to stay on a safe host — and returns the image bytes, or null
/// if any hop is unusable.
Future<Uint8List?> _downloadAvatar(Uri start) async {
  var uri = start;
  for (var hop = 0; hop <= _maxAvatarRedirects; hop++) {
    final client = http.Client();
    try {
      final request = http.Request('GET', uri)..followRedirects = false;
      final response = await client.send(request).timeout(_avatarTimeout);
      // Await the body before closing the client. Returning the Future here
      // would run the finally block immediately and cancel the response
      // stream before the avatar had been read.
      if (!_isRedirect(response.statusCode)) {
        return await _readImageBody(response);
      }

      final next = _redirectTarget(response, uri);
      if (next == null) return null;
      uri = next;
    } finally {
      client.close();
    }
  }
  return null; // Redirect budget exhausted.
}

/// The validated target of a redirect response, or null when the hop is
/// missing a `Location` or points somewhere we refuse to follow.
Uri? _redirectTarget(http.StreamedResponse response, Uri current) {
  final location = response.headers['location'];
  if (location == null) return null;
  return _safeAvatarUri(current.resolve(location).toString());
}

/// Reads a non-redirect response into memory, enforcing the status, the
/// raster MIME allowlist and the size ceiling both from the declared
/// `Content-Length` and while streaming (a lying header must not get past).
Future<Uint8List?> _readImageBody(http.StreamedResponse response) async {
  if (response.statusCode != 200) return null;

  final contentType = response.headers['content-type']
      ?.split(';')
      .first
      .trim()
      .toLowerCase();
  if (!_allowedAvatarTypes.contains(contentType)) return null;

  final declaredLength = response.contentLength;
  if (declaredLength != null && declaredLength > _maxAvatarBytes) return null;

  final builder = await response.stream
      .fold<BytesBuilder>(BytesBuilder(copy: false), _accumulateBounded)
      .timeout(_avatarTimeout);
  return Uint8List.fromList(builder.takeBytes());
}

BytesBuilder _accumulateBounded(BytesBuilder bytes, List<int> chunk) {
  if (bytes.length + chunk.length > _maxAvatarBytes) {
    throw const FormatException('Avatar exceeds size limit.');
  }
  bytes.add(chunk);
  return bytes;
}

/// Parses and validates an avatar URL, returning null unless it is one this
/// app is willing to dial.
///
/// The URL originates in a relay-supplied profile event and every redirect
/// hop is chosen by a remote host, so this is the app's only untrusted-
/// destination fetch: https only (no cleartext request announcing the user's
/// IP), and — crucially — the same loopback/private-address refusal the relay
/// list uses. Without that check a cooperating avatar host could bounce the
/// request onto the user's LAN or a cloud metadata endpoint.
Uri? _safeAvatarUri(String url) {
  if (url.length > kMaxUrlLength) return null;
  final uri = Uri.tryParse(url);
  if (uri == null || uri.toString().length > kMaxUrlLength) return null;
  if (uri.scheme != 'https' || uri.host.isEmpty) return null;
  if (uri.userInfo.isNotEmpty || uri.hasFragment) return null;
  if (uri.port < 0 || uri.port > 65535) return null;
  if (isPrivateOrLoopbackHost(uri.host)) return null;
  return uri;
}

bool _isRedirect(int statusCode) {
  return statusCode == 301 ||
      statusCode == 302 ||
      statusCode == 303 ||
      statusCode == 307 ||
      statusCode == 308;
}
