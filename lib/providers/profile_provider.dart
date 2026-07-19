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
  const maxAvatarBytes = 5 * 1024 * 1024;
  final cacheService = ref.watch(fileCacheServiceProvider);
  final key = sha256.convert(utf8.encode(url)).toString();

  final cached = await cacheService.get(key);
  if (cached != null) return cached;

  // The URL comes from a relay-supplied profile event, i.e. it's untrusted
  // input: https only (no cleartext fetch announcing the user's IP to an
  // arbitrary host), and a hard timeout so a slow host can't pin the request.
  final initialUri = Uri.tryParse(url);
  if (url.length > 2048 || !_isSafeAvatarUri(initialUri)) return null;

  try {
    var uri = initialUri!;
    const maxRedirects = 3;
    for (
      var redirectCount = 0;
      redirectCount <= maxRedirects;
      redirectCount++
    ) {
      final client = http.Client();
      try {
        final request = http.Request('GET', uri)..followRedirects = false;
        final response = await client
            .send(request)
            .timeout(const Duration(seconds: 15));
        if (_isRedirect(response.statusCode)) {
          if (redirectCount == maxRedirects) return null;
          final location = response.headers['location'];
          if (location == null) return null;
          final next = uri.resolve(location);
          if (!_isSafeAvatarUri(next)) return null;
          uri = next;
          continue;
        }
        if (response.statusCode != 200) return null;
        final contentType = response.headers['content-type']
            ?.split(';')
            .first
            .trim()
            .toLowerCase();
        if (!const {
          'image/png',
          'image/jpeg',
          'image/webp',
          'image/gif',
        }.contains(contentType)) {
          return null;
        }
        final declaredLength = response.contentLength;
        if (declaredLength != null && declaredLength > maxAvatarBytes) {
          return null;
        }
        final builder = await response.stream
            .fold<BytesBuilder>(BytesBuilder(copy: false), (bytes, chunk) {
              if (bytes.length + chunk.length > maxAvatarBytes) {
                throw const FormatException('Avatar exceeds size limit.');
              }
              bytes.add(chunk);
              return bytes;
            })
            .timeout(const Duration(seconds: 15));
        return await cacheService.put(
          key,
          Uint8List.fromList(builder.takeBytes()),
        );
      } finally {
        client.close();
      }
    }
  } catch (_) {
    debugLog('Could not download profile avatar', name: 'avatarFileProvider');
    return null;
  }
  return null;
});

bool _isSafeAvatarUri(Uri? uri) {
  return uri != null &&
      uri.toString().length <= 2048 &&
      uri.scheme == 'https' &&
      uri.host.isNotEmpty &&
      uri.userInfo.isEmpty &&
      !uri.hasFragment;
}

bool _isRedirect(int statusCode) {
  return statusCode == 301 ||
      statusCode == 302 ||
      statusCode == 303 ||
      statusCode == 307 ||
      statusCode == 308;
}
