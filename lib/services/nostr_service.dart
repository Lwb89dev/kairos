import 'dart:async';
import 'dart:convert';

import 'package:amberflutter/amberflutter.dart';
import 'package:dart_nostr/dart_nostr.dart';
import 'package:flutter/services.dart' show MissingPluginException;

import '../models/profile.dart';
import '../models/task_model.dart';
import '../models/user_model.dart';
import '../utils/constants.dart';
import '../utils/crypto.dart';
import '../utils/logger.dart';

/// Wraps all interaction with the Nostr protocol: key generation/import,
/// npub/nsec conversion (NIP-19 bech32), login (local key or Amber), event
/// signing + NIP-44 encryption, relay transport, and the REQ that pulls the
/// user's encrypted tasks.
///
/// Uses the same audited identity and relay patterns as Echoes and Astraea,
/// with the event payload specialized for
/// Kairos tasks: kind 30789 with the stable legacy wire namespace
/// `checkmarks:<uuid>` so existing relay data remains reachable.
///
/// Two identity modes:
///  - Local key ([LoginMethod.importedKey]/[LoginMethod.generatedKey]): the
///    private key is held on-device; signing and NIP-44 crypto happen locally
///    (via `dart_nostr` + [CryptoUtils]).
///  - Amber ([LoginMethod.amber], NIP-55, Android only): the private key never
///    enters the app; signing and NIP-44 encrypt/decrypt are delegated to
///    Amber over intents.
class NostrService {
  final Nostr _nostr = Nostr.instance;
  final Amberflutter _amber = Amberflutter();

  NostrService() {
    // dart_nostr enables verbose logs by default and may include complete
    // hostile relay frames, signatures and public identity material. Keep
    // the transport silent in every build; Kairos' own redacted diagnostics
    // are sufficient in debug mode.
    _nostr.disableLogs();
  }

  // -------------------------------------------------------------------
  // Identity / login
  // -------------------------------------------------------------------

  /// Converts a hex public key to its bech32 `npub` form (NIP-19).
  String publicKeyToNpub(String publicKeyHex) {
    return _nostr.services.bech32.encodePublicKeyToNpub(publicKeyHex);
  }

  /// Converts a hex private key to its bech32 `nsec` — shown once to a user
  /// who just generated an account so they can back it up. Never logged or
  /// persisted in this form.
  String privateKeyToNsec(String privateKeyHex) {
    return _nostr.services.bech32.encodePrivateKeyToNsec(privateKeyHex);
  }

  /// Generates a brand-new keypair for a first-time user
  /// ([LoginMethod.generatedKey]).
  Future<User> generateAccount() async {
    debugLog('NostrService.generateAccount called', name: 'NostrService');
    final keyPair = _nostr.services.keys.generateKeyPair();
    return User(
      publicKeyHex: keyPair.public,
      npub: publicKeyToNpub(keyPair.public),
      loginMethod: LoginMethod.generatedKey,
      privateKeyHex: keyPair.private,
    );
  }

  /// Imports an existing account from an nsec (bech32) or raw hex private key.
  /// Throws [InvalidPrivateKeyException] (detail-free) if it can't be decoded.
  Future<User> importAccount(String privateKey) async {
    debugLog('NostrService.importAccount called', name: 'NostrService');
    final trimmed = privateKey.trim();
    try {
      final privateKeyHex = trimmed.startsWith('nsec1')
          ? _nostr.services.bech32.decodeNsecKeyToPrivateKey(trimmed)
          : trimmed.toLowerCase();
      if (!_nostr.services.keys.isValidPrivateKey(privateKeyHex)) {
        throw const InvalidPrivateKeyException();
      }
      return _userFromPrivateKey(privateKeyHex, LoginMethod.importedKey);
    } on InvalidPrivateKeyException {
      rethrow;
    } catch (_) {
      throw const InvalidPrivateKeyException();
    }
  }

  /// Rebuilds a local-key session from a stored private key on app restart
  /// from secure storage. [method] is the persisted
  /// [LoginMethod], so a generated account doesn't silently turn into an
  /// "imported" one across restarts.
  Future<User> login(
    String privateKeyHex, {
    LoginMethod method = LoginMethod.importedKey,
  }) async {
    debugLog('NostrService.login called', name: 'NostrService');
    return _userFromPrivateKey(privateKeyHex, method);
  }

  /// Rebuilds an Amber session from the saved public key on app restart (no
  /// private key involved).
  User amberSession(String publicKeyHex) {
    if (!_isValidPublicKeyHex(publicKeyHex)) {
      throw StateError('Stored Nostr public key is invalid.');
    }
    return User(
      publicKeyHex: publicKeyHex,
      npub: publicKeyToNpub(publicKeyHex),
      loginMethod: LoginMethod.amber,
    );
  }

  User _userFromPrivateKey(String privateKeyHex, LoginMethod method) {
    final keyPair = _nostr.services.keys.generateKeyPairFromExistingPrivateKey(
      privateKeyHex,
    );
    return User(
      publicKeyHex: keyPair.public,
      npub: publicKeyToNpub(keyPair.public),
      loginMethod: method,
      privateKeyHex: privateKeyHex,
    );
  }

  /// true if the Amber app (NIP-55 signer) is installed. Android only: other
  /// platforms don't implement the plugin method, so treat that as "not
  /// available" rather than crashing.
  Future<bool> isAmberInstalled() async {
    debugLog('NostrService.isAmberInstalled called', name: 'NostrService');
    try {
      return await _amber.isAppInstalled();
    } on MissingPluginException {
      return false;
    }
  }

  /// Opens a [LoginMethod.amber] session by asking Amber for the active
  /// account's public key (NIP-55 intent). Requests every permission
  /// Kairos will need up front — `sign_event` plus `nip44_encrypt`/
  /// `nip44_decrypt` — so Amber grants them once instead of prompting on
  /// every publish/fetch. Handles a hex or already-bech32 npub reply.
  Future<User> loginWithAmber() async {
    debugLog('NostrService.loginWithAmber called', name: 'NostrService');
    if (!await isAmberInstalled()) {
      throw StateError(
        'Amber does not appear to be installed on this device. '
        'Install Amber (NIP-55 signer) and try again.',
      );
    }

    final result = await _awaitAmber(
      _amber.getPublicKey(
        permissions: const [
          Permission(type: 'sign_event'),
          Permission(type: 'nip44_encrypt'),
          Permission(type: 'nip44_decrypt'),
        ],
      ),
    );
    final raw = (result['signature'] as String?)?.trim() ?? '';
    if (raw.isEmpty) {
      throw StateError('Amber did not return a public key.');
    }

    final String publicKeyHex;
    final String npub;
    if (raw.startsWith('npub1')) {
      npub = raw;
      publicKeyHex = _nostr.services.bech32.decodeNpubKeyToPublicKey(raw);
    } else {
      publicKeyHex = raw.toLowerCase();
      npub = publicKeyToNpub(publicKeyHex);
    }
    if (!_isValidPublicKeyHex(publicKeyHex)) {
      throw StateError('Amber returned an invalid public key.');
    }
    return User(
      publicKeyHex: publicKeyHex,
      npub: npub,
      loginMethod: LoginMethod.amber,
    );
  }

  // -------------------------------------------------------------------
  // Relay transport + task events (kind 30789)
  // -------------------------------------------------------------------

  /// Opens (and keeps) websocket connections to [relayUrls]. Safe to call
  /// repeatedly. `lazyListeningToRelays: false` (the default) is required, or
  /// OK/EVENT frames are never dispatched (same note as Echoes/Astraea).
  ///
  /// [homeRelayUrl], when given, is the one URL in [relayUrls] allowed to use
  /// a plaintext `ws://` scheme — the personal home-relay exception (see
  /// `normalizeSecureRelayUrl`). Every other relay must still be `wss://`.
  Future<void> connectToRelays(
    List<String> relayUrls, {
    String? homeRelayUrl,
  }) async {
    debugLog(
      'NostrService.connectToRelays called (${relayUrls.length} relays)',
      name: 'NostrService',
    );
    if (relayUrls.isEmpty) return;
    _validateRelayUrls(relayUrls, insecureAllowedUrl: homeRelayUrl);
    await _nostr.services.relays.init(
      relaysUrl: relayUrls,
      // A manual/foreground sync will reconnect. Disabling library-level
      // infinite reconnects prevents an unavailable or hostile relay from
      // keeping the app in an uncontrolled retry loop.
      retryOnError: false,
      retryOnClose: false,
    );
  }

  /// Fetches [publicKeyHex]'s public profile card (kind 0), if any relay has
  /// one. Unlike tasks this is plain public data by design — no NIP-44
  /// involved — so a missing or malformed profile is not an error, just
  /// `null` / best-effort field parsing.
  ///
  /// Queries only relays explicitly selected by the user. Profile decoration
  /// is not a reason to leak the user's IP/public key to hidden endpoints.
  Future<NostrProfile?> fetchProfileMetadata({
    required String publicKeyHex,
    required List<String> relayUrls,
  }) async {
    debugLog('NostrService.fetchProfileMetadata called', name: 'NostrService');
    final urls = relayUrls.toSet().toList(growable: false);
    if (urls.isEmpty) return null;
    await connectToRelays(urls);

    final events = await _fetchFromRelays(
      request: NostrRequest(
        filters: [
          NostrFilter(authors: [publicKeyHex], kinds: const [0], limit: 1),
        ],
      ),
      relayUrls: urls,
    );
    final authentic = events
        .where(
          (event) => _isAuthenticEvent(
            event,
            expectedAuthor: publicKeyHex,
            expectedKind: 0,
          ),
        )
        .toList();
    if (authentic.isEmpty) return null;

    // Relays don't have to enforce "one kind-0 per author" or return results
    // in order — pick the most recent event actually received. `createdAt` is
    // nullable; treat a missing timestamp as oldest rather than crashing.
    final epoch = DateTime.fromMillisecondsSinceEpoch(0);
    final latest = authentic.reduce(
      (a, b) => (a.createdAt ?? epoch).isAfter(b.createdAt ?? epoch) ? a : b,
    );
    final content = latest.content;
    if (content == null || content.isEmpty || content.length > 65536) {
      return null;
    }

    try {
      final json = jsonDecode(content) as Map<String, dynamic>;
      return NostrProfile.fromMetadataJson(publicKeyHex, json);
    } catch (_) {
      debugLog('Could not parse profile metadata', name: 'NostrService');
      return null;
    }
  }

  /// Encrypts [task]'s JSON (NIP-44 self-encryption), signs it as a
  /// kind-30789 event under the `d` tag `checkmarks:<id>` (parameterized
  /// replaceable), publishes it to [relayUrls], and returns the
  /// relay-confirmed event id. Encryption + signing branch on
  /// [author.loginMethod] (local key vs Amber).
  ///
  /// Everything task-specific stays inside the encrypted content: no title /
  /// due-date / status tags in cleartext, or the relay operator could read
  /// the user's whole task list. Other Kairos devices decrypt the content
  /// with the same identity and get every field from the JSON body.
  Future<String> publishTask({
    required User author,
    required Task task,
    required List<String> relayUrls,
    String? homeRelayUrl,
  }) async {
    debugLog('NostrService.publishTask called', name: 'NostrService');
    if (relayUrls.isEmpty) throw StateError('No relay configured.');
    await connectToRelays(relayUrls, homeRelayUrl: homeRelayUrl);

    final content = await _encrypt(author, jsonEncode(task.toSyncJson()));
    final signed = await _signEvent(
      author: author,
      kind: AppConstants.taskEventKind,
      tags: [
        ['d', task.dTag],
      ],
      content: content,
      createdAt: task.updatedAt,
    );

    // `relays:` is always passed explicitly: dart_nostr's registry keeps every
    // socket ever opened this session, and a null `relays` broadcasts to ALL
    // of them — which would hand the user's encrypted tasks to relays they
    // never chose.
    await _sendToEveryRelay(signed, relayUrls);
    return signed.id!;
  }

  /// Fetches every Kairos task (kind 30789, stable `d` tag prefixed
  /// `checkmarks:`) authored by [author] from [relayUrls], decrypts each and
  /// returns them as [Task]s (marked synced). Events that fail to decrypt or
  /// parse are skipped rather than failing the whole fetch.
  ///
  /// Relays can only match exact `#d` values, not a prefix, so we request all
  /// of the author's kind-30789 events and filter to `checkmarks:` client-side.
  Future<List<Task>> fetchTasks({
    required User author,
    required List<String> relayUrls,
    DateTime? since,
    String? homeRelayUrl,
  }) async {
    debugLog('NostrService.fetchTasks called', name: 'NostrService');
    if (relayUrls.isEmpty) return const [];
    await connectToRelays(relayUrls, homeRelayUrl: homeRelayUrl);

    final events = await _fetchFromRelays(
      request: NostrRequest(
        filters: [
          NostrFilter(
            authors: [author.publicKeyHex],
            kinds: const [AppConstants.taskEventKind],
            since: since,
          ),
        ],
      ),
      relayUrls: relayUrls,
      homeRelayUrl: homeRelayUrl,
    );

    final result = <Task>[];
    for (final raw in events) {
      if (!_isAuthenticEvent(
        raw,
        expectedAuthor: author.publicKeyHex,
        expectedKind: AppConstants.taskEventKind,
      )) {
        continue;
      }
      final content = raw.content;
      final id = raw.id;
      if (content == null || content.isEmpty || id == null) continue;
      final dTag = _dTagOf(raw);
      if (dTag == null || !dTag.startsWith(AppConstants.dTagPrefix)) continue;
      final task = await _decryptTask(author, content, id);
      if (task != null && task.dTag == dTag) result.add(task);
    }
    return result;
  }

  /// Publishes a NIP-09 deletion request retracting one previous concrete
  /// version. The replaceable coordinate is deliberately not deleted because
  /// its newest version is the encrypted tombstone other devices need.
  Future<void> publishDeletion({
    required User author,
    required String nostrEventId,
    required List<String> relayUrls,
    String? homeRelayUrl,
  }) async {
    debugLog('NostrService.publishDeletion called', name: 'NostrService');
    if (relayUrls.isEmpty) return;
    await connectToRelays(relayUrls, homeRelayUrl: homeRelayUrl);

    final signed = await _signEvent(
      author: author,
      kind: AppConstants.deletionEventKind,
      tags: <List<String>>[
        ['e', nostrEventId],
      ],
      content: '',
      createdAt: DateTime.now(),
    );
    await _sendToEveryRelay(signed, relayUrls);
  }

  // -------------------------------------------------------------------
  // Encryption / signing (local key vs Amber)
  // -------------------------------------------------------------------

  Future<String> _encrypt(User author, String plaintext) async {
    if (author.loginMethod.isLocalKey) {
      final privateKeyHex = _requireLocalKey(author);
      return CryptoUtils.encryptNip44(
        plaintext: plaintext,
        privateKeyHex: privateKeyHex,
        recipientPublicKeyHex: author.publicKeyHex,
      );
    }
    final result = await _awaitAmber(
      _amber.nip44Encrypt(
        plaintext: plaintext,
        currentUser: author.npub,
        pubKey: author.publicKeyHex,
      ),
    );
    final encrypted = (result['signature'] as String?) ?? '';
    if (encrypted.isEmpty) {
      throw StateError('Amber returned no encrypted content.');
    }
    return encrypted;
  }

  Future<Task?> _decryptTask(
    User author,
    String ciphertext,
    String eventId,
  ) async {
    try {
      final String plaintext;
      if (author.loginMethod.isLocalKey) {
        final privateKeyHex = _requireLocalKey(author);
        plaintext = CryptoUtils.decryptNip44(
          ciphertext: ciphertext,
          privateKeyHex: privateKeyHex,
          senderPublicKeyHex: author.publicKeyHex,
        );
      } else {
        final result = await _awaitAmber(
          _amber.nip44Decrypt(
            ciphertext: ciphertext,
            currentUser: author.npub,
            pubKey: author.publicKeyHex,
          ),
        );
        final decrypted = result['signature'] as String?;
        if (decrypted == null) return null;
        plaintext = decrypted;
      }
      final json = jsonDecode(plaintext) as Map<String, dynamic>;
      return Task.fromJson(json).copyWith(
        synced: true,
        nostrEventId: eventId,
        syncOwnerPubkey: author.publicKeyHex,
        clearDeletionRequestPending: true,
      );
    } catch (_) {
      // Parser exceptions can contain decrypted snippets. Never log them.
      debugLog('Could not decrypt/parse one task event', name: 'NostrService');
      return null;
    }
  }

  Future<NostrEvent> _signEvent({
    required User author,
    required int kind,
    required List<List<String>> tags,
    required String content,
    required DateTime createdAt,
  }) async {
    if (author.loginMethod.isLocalKey) {
      final privateKeyHex = _requireLocalKey(author);
      final keyPair = _nostr.services.keys
          .generateKeyPairFromExistingPrivateKey(privateKeyHex);
      return NostrEvent.fromPartialData(
        kind: kind,
        content: content,
        keyPairs: keyPair,
        tags: tags,
        createdAt: createdAt,
      );
    }
    final unsigned = {
      'pubkey': author.publicKeyHex,
      'created_at': createdAt.millisecondsSinceEpoch ~/ 1000,
      'kind': kind,
      'tags': tags,
      'content': content,
    };
    final result = await _awaitAmber(
      _amber.signEvent(
        currentUser: author.npub,
        eventJson: jsonEncode(unsigned),
      ),
    );
    final signedJson = result['event'] as String?;
    if (signedJson == null) throw StateError('Amber returned no signed event.');
    final signed = _nostrEventFromMap(
      jsonDecode(signedJson) as Map<String, dynamic>,
    );
    final signedCreatedAt = signed.createdAt;
    final sameCreatedSecond =
        signedCreatedAt != null &&
        signedCreatedAt.millisecondsSinceEpoch ~/ 1000 ==
            createdAt.millisecondsSinceEpoch ~/ 1000;
    if (!_isAuthenticEvent(
          signed,
          expectedAuthor: author.publicKeyHex,
          expectedKind: kind,
        ) ||
        signed.content != content ||
        jsonEncode(signed.tags) != jsonEncode(tags) ||
        !sameCreatedSecond) {
      throw StateError(
        'Amber returned a signed event that does not match the request.',
      );
    }
    return signed;
  }

  // -------------------------------------------------------------------
  // Helpers
  // -------------------------------------------------------------------

  String _requireLocalKey(User author) {
    final privateKeyHex = author.privateKeyHex;
    if (privateKeyHex == null) {
      throw StateError('Missing private key for a local-key session.');
    }
    return privateKeyHex;
  }

  /// Bounds how long we wait for an Amber intent to return (see
  /// [AppConstants.amberInteractionTimeout]).
  Future<T> _awaitAmber<T>(Future<T> future) {
    return future.timeout(
      AppConstants.amberInteractionTimeout,
      onTimeout: () => throw StateError(
        'Amber did not respond in time. If you cancelled the request in Amber, please try again.',
      ),
    );
  }

  /// Collects a bounded REQ only from [relayUrls], waits for every target's
  /// EOSE (or timeout), and always closes both stream resources. The package's
  /// async convenience helper currently loses its relay filter internally and
  /// completes on the first EOSE.
  Future<List<NostrEvent>> _fetchFromRelays({
    required NostrRequest request,
    required List<String> relayUrls,
    String? homeRelayUrl,
  }) async {
    if (relayUrls.isEmpty) return const [];
    _validateRelayUrls(relayUrls, insecureAllowedUrl: homeRelayUrl);

    final expectedEose = relayUrls.toSet().length;
    final eoseRelays = <String>{};
    final finished = Completer<void>();
    final events = <NostrEvent>[];
    var totalContentBytes = 0;
    const maxEvents = 5000;
    const maxAggregateContentBytes = 16 * 1024 * 1024;
    const maxEventContentBytes = 90000;

    final subscription = _nostr.services.relays.startEventsSubscription(
      request: request,
      relays: relayUrls,
      onEose: (relay, _) {
        eoseRelays.add(relay);
        if (eoseRelays.length >= expectedEose && !finished.isCompleted) {
          finished.complete();
        }
      },
    );
    final listener = subscription.stream.listen(
      (event) {
        final contentLength = event.content?.length ?? 0;
        if (events.length >= maxEvents ||
            contentLength > maxEventContentBytes ||
            totalContentBytes + contentLength > maxAggregateContentBytes) {
          return;
        }
        totalContentBytes += contentLength;
        events.add(event);
      },
      onError: (_, _) {
        if (!finished.isCompleted) finished.complete();
      },
    );
    try {
      await finished.future.timeout(
        AppConstants.syncEoseTimeout,
        onTimeout: () {},
      );
    } finally {
      await listener.cancel();
      subscription.close();
    }
    return events;
  }

  /// Requires an acknowledgement from every configured target before a task
  /// is marked synchronized. Partial success is retried idempotently later.
  Future<void> _sendToEveryRelay(
    NostrEvent event,
    List<String> relayUrls,
  ) async {
    final acknowledgements = await Future.wait([
      for (final relayUrl in relayUrls.toSet())
        _nostr.services.relays.sendEventToRelaysAsync(
          event,
          timeout: AppConstants.syncEoseTimeout,
          relays: [relayUrl],
        ),
    ]);
    final rejected = acknowledgements.where((ok) => ok.isEventAccepted != true);
    if (rejected.isNotEmpty) {
      throw StateError('A configured relay did not accept the event.');
    }
  }

  /// Relays are untrusted transport. Verify both the NIP-01 event id and its
  /// Schnorr signature, in addition to the author and kind requested.
  bool _isAuthenticEvent(
    NostrEvent event, {
    required String expectedAuthor,
    required int expectedKind,
  }) {
    try {
      final id = event.id;
      final content = event.content;
      final createdAt = event.createdAt;
      final tags = event.tags;
      if (id == null ||
          content == null ||
          createdAt == null ||
          tags == null ||
          event.pubkey != expectedAuthor ||
          event.kind != expectedKind) {
        return false;
      }
      final computedId = NostrEvent.getEventId(
        kind: expectedKind,
        content: content,
        createdAt: createdAt,
        tags: tags,
        pubkey: event.pubkey,
      );
      return computedId == id && event.isVerified();
    } catch (_) {
      return false;
    }
  }

  /// [insecureAllowedUrl], when given, is the one URL allowed to use `ws://`
  /// instead of `wss://` — the personal home-relay exception. Every other
  /// relay must still be `wss://`; this mirrors `normalizeSecureRelayUrl`'s
  /// `allowInsecureLocal` rule so a tampered/hand-edited relay list can never
  /// smuggle an extra plaintext connection through this layer.
  void _validateRelayUrls(
    Iterable<String> relayUrls, {
    String? insecureAllowedUrl,
  }) {
    final unique = relayUrls.toSet();
    if (unique.length > AppConstants.maxRelayConnections) {
      throw ArgumentError(
        'Too many relay connections (maximum ${AppConstants.maxRelayConnections}).',
      );
    }
    for (final raw in unique) {
      final uri = Uri.tryParse(raw);
      final schemeOk =
          uri?.scheme == 'wss' ||
          (raw == insecureAllowedUrl && uri?.scheme == 'ws');
      if (uri == null ||
          !schemeOk ||
          uri.host.isEmpty ||
          uri.userInfo.isNotEmpty ||
          uri.hasFragment ||
          raw.length > 2048) {
        throw ArgumentError.value(
          raw,
          'relayUrls',
          'Invalid secure relay URL.',
        );
      }
    }
  }

  bool _isValidPublicKeyHex(String value) {
    return RegExp(r'^[0-9a-fA-F]{64}$').hasMatch(value);
  }

  String? _dTagOf(NostrEvent event) {
    final tags = event.tags;
    if (tags == null) return null;
    for (final tag in tags) {
      if (tag.length >= 2 && tag[0] == 'd') return tag[1];
    }
    return null;
  }

  NostrEvent _nostrEventFromMap(Map<String, dynamic> map) {
    return NostrEvent(
      id: map['id'] as String,
      kind: map['kind'] as int,
      content: map['content'] as String? ?? '',
      sig: map['sig'] as String,
      pubkey: map['pubkey'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        (map['created_at'] as int) * 1000,
      ),
      tags: (map['tags'] as List<dynamic>)
          .map(
            (tag) => (tag as List<dynamic>).map((e) => e.toString()).toList(),
          )
          .toList(),
    );
  }
}

/// Thrown by [NostrService.importAccount] when the entered key can't be
/// decoded/validated. Carries no detail — never the key the user typed.
class InvalidPrivateKeyException implements Exception {
  const InvalidPrivateKeyException();

  @override
  String toString() => 'Invalid private key';
}
