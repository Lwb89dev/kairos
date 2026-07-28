import 'dart:async';
import 'dart:convert';

import 'package:amberflutter/amberflutter.dart';
import 'package:dart_nostr/dart_nostr.dart';
import 'package:flutter/services.dart' show MissingPluginException;
import 'package:meta/meta.dart' show visibleForTesting;

import '../models/profile.dart';
import '../models/task_model.dart';
import '../models/user_model.dart';
import '../utils/constants.dart';
import '../utils/crypto.dart';
import '../utils/logger.dart';
import '../utils/relay_url.dart';

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
  static const _maxDependencyEventCache = 64;
  static bool _dependencyEventGuardInstalled = false;

  final Nostr _nostr = Nostr.instance;
  final Amberflutter _amber = Amberflutter();

  /// The relay set the current websockets were opened for, so a change in
  /// the user's selection can close the ones that are no longer wanted.
  Set<String> _connectedRelays = const {};

  NostrService() {
    // dart_nostr enables verbose logs by default and may include complete
    // hostile relay frames, signatures and public identity material. Keep
    // the transport silent in every build; Kairos' own redacted diagnostics
    // are sufficient in debug mode.
    _nostr.disableLogs();
    _installDependencyEventGuard();
  }

  /// dart_nostr keeps receiving and registering events even after a REQ is
  /// closed if a relay ignores CLOSE. Install one process-wide guard so that
  /// its global event cache cannot become an unbounded retention sink.
  void _installDependencyEventGuard() {
    if (_dependencyEventGuardInstalled) return;
    _dependencyEventGuardInstalled = true;
    _nostr.services.relays.streamsController.events.listen((_) {
      final registry = _nostr.services.relays.eventsRegistry;
      if (registry.length > _maxDependencyEventCache) registry.clear();
    });
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
  Future<void> connectToRelays(List<String> relayUrls) async {
    debugLog(
      'NostrService.connectToRelays called (${relayUrls.length} relays)',
      name: 'NostrService',
    );
    if (relayUrls.isEmpty) return;
    _validateRelayUrls(relayUrls);

    await _nostr.services.relays.init(
      relaysUrl: relayUrls,
      // A manual/foreground sync will reconnect. Disabling library-level
      // infinite reconnects prevents an unavailable or hostile relay from
      // keeping the app in an uncontrolled retry loop.
      retryOnError: false,
      retryOnClose: false,
    );
    // Union, not assignment: the library's registry is append-only (see
    // [dropDeselectedRelays]), so a socket opened by an earlier call is still
    // open even if this call didn't ask for it.
    _connectedRelays = {..._connectedRelays, ...relayUrls};
  }

  /// Closes every open websocket if any of them is no longer in
  /// [stillSelected]. Call this when the user's relay configuration changes,
  /// not on every sync.
  ///
  /// `dart_nostr`'s registry is append-only in practice: `init()` accepts an
  /// `ensureToClearRegistriesBeforeStarting` flag but never forwards it to
  /// the function that does the connecting, so the flag has no effect, and
  /// `_registerNewRelays` only ever adds. Without this, a relay the user
  /// deleted in Settings kept an open connection — and kept seeing the user's
  /// IP — until the app was restarted.
  ///
  /// `disconnectFromRelays()` is all-or-nothing (it clears the whole
  /// registry), so the next sync transparently reconnects whatever is still
  /// selected. Doing this only on a real configuration change is what keeps
  /// it from churning connections: the profile lookup and the task sync
  /// legitimately connect to different subsets of the same selection.
  Future<void> dropDeselectedRelays(Set<String> stillSelected) async {
    if (_connectedRelays.difference(stillSelected).isEmpty) return;

    debugLog('Closing sockets to deselected relays', name: 'NostrService');
    try {
      await _nostr.services.relays.disconnectFromRelays();
    } catch (_) {
      // A socket that is already gone must not block reconnecting.
      debugLog('Relay disconnect reported an error', name: 'NostrService');
    }
    _connectedRelays = const {};
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
    // Relays don't have to enforce "one kind-0 per author" or return results
    // in order — sort by recency and verify candidates from the newest down,
    // rather than verifying the whole reply. Signature verification is the
    // expensive step, so a relay answering a `limit: 1` profile request with
    // thousands of events must not buy thousands of secp256k1 operations.
    final epoch = DateTime.fromMillisecondsSinceEpoch(0);
    final candidates =
        events
            .where((event) => event.pubkey == publicKeyHex && event.kind == 0)
            .toList()
          ..sort(
            (a, b) => (b.createdAt ?? epoch).compareTo(a.createdAt ?? epoch),
          );

    final latest = await _firstAuthentic(
      candidates.take(AppConstants.maxProfileCandidates),
      expectedAuthor: publicKeyHex,
      expectedKind: 0,
    );
    if (latest == null) return null;

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
  // `async` matters here: the guard below has to surface as a failed Future,
  // not a synchronous throw, or every caller awaiting this would have to
  // wrap it in its own try/catch instead.
  Future<String> publishTask({
    required User author,
    required Task task,
    required List<String> relayUrls,
  }) async {
    debugLog('NostrService.publishTask called', name: 'NostrService');
    // Last barrier before the network: a task the user pinned to the device
    // must never be encrypted-and-published, whatever the caller got wrong.
    if (task.localOnly) {
      throw StateError('A local-only task must never be published.');
    }
    return publishRawEvent(
      author: author,
      kind: AppConstants.taskEventKind,
      dTag: task.dTag,
      plaintextContent: jsonEncode(task.toSyncJson()),
      createdAt: task.updatedAt,
      relayUrls: relayUrls,
    );
  }

  /// NIP-44 self-encrypts [plaintextContent], signs it as a parameterized
  /// replaceable event of [kind] under [dTag], publishes it to [relayUrls] and
  /// returns the relay-confirmed event id.
  ///
  /// The kind and `d` tag are parameters because Kairos writes two different
  /// document types with the same identity: its own kind-30789 tasks, and the
  /// kind-30078 `epochs:` calendar events that make a dated task visible in
  /// Astraea (see [AstraeaCalendarMirror]). Everything else — encryption,
  /// signing via local key or Amber, the acknowledgement requirement — is
  /// identical, and duplicating it per document type is how the two would
  /// drift apart.
  ///
  /// Nothing but the `d` tag is ever in cleartext: no title, date or status
  /// tags, or the relay operator could read the user's whole list.
  Future<String> publishRawEvent({
    required User author,
    required int kind,
    required String dTag,
    required String plaintextContent,
    required DateTime createdAt,
    required List<String> relayUrls,
  }) async {
    if (relayUrls.isEmpty) throw StateError('No relay configured.');
    await connectToRelays(relayUrls);

    final content = await _encrypt(author, plaintextContent);
    final signed = await _signEvent(
      author: author,
      kind: kind,
      tags: [
        ['d', dTag],
      ],
      content: content,
      createdAt: createdAt,
    );

    // `relays:` is always passed explicitly: dart_nostr's registry keeps every
    // socket ever opened this session, and a null `relays` broadcasts to ALL
    // of them — which would hand the user's encrypted data to relays they
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
  ///
  /// The reply is reduced *before* any cryptography runs (see
  /// [_selectNewestPerCoordinate]): signature verification and NIP-44
  /// decryption are the expensive operations, and a relay is free to answer
  /// with thousands of events carrying the requested pubkey and a junk
  /// signature. Only the newest event per `d` tag can ever matter for a
  /// replaceable kind, so deduplicating first turns that flood into one
  /// verification per real task.
  Future<List<Task>> fetchTasks({
    required User author,
    required List<String> relayUrls,
  }) async {
    debugLog('NostrService.fetchTasks called', name: 'NostrService');
    if (relayUrls.isEmpty) return const [];
    await connectToRelays(relayUrls);

    final events = await _fetchFromRelays(
      request: NostrRequest(
        filters: [
          NostrFilter(
            authors: [author.publicKeyHex],
            kinds: const [AppConstants.taskEventKind],
          ),
        ],
      ),
      relayUrls: relayUrls,
    );

    final candidates = _selectNewestPerCoordinate(events, author);
    final result = <Task>[];
    var processed = 0;
    for (final entry in candidates.entries) {
      await _yieldPeriodically(processed++);
      final raw = entry.value;
      if (!_isAuthenticEvent(
        raw,
        expectedAuthor: author.publicKeyHex,
        expectedKind: AppConstants.taskEventKind,
      )) {
        continue;
      }
      final task = await _decryptTask(author, raw.content!, raw.id!);
      if (task != null && task.dTag == entry.key) result.add(task);
    }
    return result;
  }

  /// Cheap (string-comparison only) pre-filter over an untrusted relay reply:
  /// keeps at most one event per `checkmarks:` `d` tag — the one with the
  /// newest `created_at`, which is the only revision a parameterized
  /// replaceable kind can meaningfully have — and stops at
  /// [AppConstants.maxVerifiedEventsPerFetch] distinct tags.
  ///
  /// Nothing here is a security check. It is purely a work limiter placed in
  /// front of the real authentication; every surviving event still has to
  /// pass [_isAuthenticEvent].
  Map<String, NostrEvent> _selectNewestPerCoordinate(
    List<NostrEvent> events,
    User author,
  ) {
    final epoch = DateTime.fromMillisecondsSinceEpoch(0);
    final newest = <String, NostrEvent>{};
    for (final event in events) {
      if (event.pubkey != author.publicKeyHex) continue;
      if (event.kind != AppConstants.taskEventKind) continue;
      if (event.id == null) continue;
      final content = event.content;
      if (content == null || content.isEmpty) continue;
      final dTag = _dTagOf(event);
      if (dTag == null || !dTag.startsWith(AppConstants.dTagPrefix)) continue;

      final existing = newest[dTag];
      if (existing == null &&
          newest.length >= AppConstants.maxVerifiedEventsPerFetch) {
        continue;
      }
      final incomingAt = event.createdAt ?? epoch;
      if (existing == null || incomingAt.isAfter(existing.createdAt ?? epoch)) {
        newest[dTag] = event;
      }
    }
    return newest;
  }

  // -------------------------------------------------------------------
  // Test-only hooks — the untrusted-relay handling is the part worth
  // exercising directly, without standing up a websocket.
  // -------------------------------------------------------------------

  @visibleForTesting
  Map<String, NostrEvent> debugSelectNewestPerCoordinate(
    List<NostrEvent> events,
    User author,
  ) => _selectNewestPerCoordinate(events, author);

  @visibleForTesting
  bool debugIsAuthenticEvent(
    NostrEvent event, {
    required String expectedAuthor,
    required int expectedKind,
  }) => _isAuthenticEvent(
    event,
    expectedAuthor: expectedAuthor,
    expectedKind: expectedKind,
  );

  /// Returns the first event in [candidates] that passes full authentication,
  /// or null. Bounded by construction: callers pass an already-truncated
  /// iterable.
  Future<NostrEvent?> _firstAuthentic(
    Iterable<NostrEvent> candidates, {
    required String expectedAuthor,
    required int expectedKind,
  }) async {
    var index = 0;
    for (final event in candidates) {
      await _yieldPeriodically(index++);
      if (_isAuthenticEvent(
        event,
        expectedAuthor: expectedAuthor,
        expectedKind: expectedKind,
      )) {
        return event;
      }
    }
    return null;
  }

  /// Hands the event loop a turn every [AppConstants.cryptoYieldInterval]
  /// items so a long verify/decrypt run renders frames instead of freezing
  /// the app until it finishes.
  Future<void> _yieldPeriodically(int index) async {
    if (index > 0 && index % AppConstants.cryptoYieldInterval == 0) {
      await Future<void>.delayed(Duration.zero);
    }
  }

  /// Publishes a NIP-09 deletion request retracting one previous concrete
  /// version. The replaceable coordinate is deliberately not deleted because
  /// its newest version is the encrypted tombstone other devices need.
  Future<void> publishDeletion({
    required User author,
    required String nostrEventId,
    required List<String> relayUrls,
  }) async {
    debugLog('NostrService.publishDeletion called', name: 'NostrService');
    if (relayUrls.isEmpty) return;
    await connectToRelays(relayUrls);

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
  }) {
    final sign = author.loginMethod.isLocalKey
        ? _signWithLocalKey
        : _signWithAmber;
    return sign(
      author: author,
      kind: kind,
      tags: tags,
      content: content,
      createdAt: createdAt,
    );
  }

  Future<NostrEvent> _signWithLocalKey({
    required User author,
    required int kind,
    required List<List<String>> tags,
    required String content,
    required DateTime createdAt,
  }) async {
    final keyPair = _nostr.services.keys.generateKeyPairFromExistingPrivateKey(
      _requireLocalKey(author),
    );
    return NostrEvent.fromPartialData(
      kind: kind,
      content: content,
      keyPairs: keyPair,
      tags: tags,
      createdAt: createdAt,
    );
  }

  /// Delegates signing to Amber (NIP-55) and then checks that what came back
  /// is the event we asked for. Amber is a separate app: its reply is data
  /// crossing a trust boundary, not a return value.
  Future<NostrEvent> _signWithAmber({
    required User author,
    required int kind,
    required List<List<String>> tags,
    required String content,
    required DateTime createdAt,
  }) async {
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
    if (!_matchesSigningRequest(
      signed,
      author: author,
      kind: kind,
      tags: tags,
      content: content,
      createdAt: createdAt,
    )) {
      throw StateError(
        'Amber returned a signed event that does not match the request.',
      );
    }
    return signed;
  }

  bool _matchesSigningRequest(
    NostrEvent signed, {
    required User author,
    required int kind,
    required List<List<String>> tags,
    required String content,
    required DateTime createdAt,
  }) {
    final signedCreatedAt = signed.createdAt;
    if (signedCreatedAt == null) return false;
    // Nostr timestamps are whole seconds, so compare at that resolution.
    if (signedCreatedAt.millisecondsSinceEpoch ~/ 1000 !=
        createdAt.millisecondsSinceEpoch ~/ 1000) {
      return false;
    }
    if (signed.content != content) return false;
    if (jsonEncode(signed.tags) != jsonEncode(tags)) return false;
    return _isAuthenticEvent(
      signed,
      expectedAuthor: author.publicKeyHex,
      expectedKind: kind,
    );
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
  }) async {
    if (relayUrls.isEmpty) return const [];
    _validateRelayUrls(relayUrls);

    final expectedEose = relayUrls.toSet().length;
    final eoseRelays = <String>{};
    final finished = Completer<void>();
    final events = <NostrEvent>[];
    var totalContentBytes = 0;
    const maxEvents = AppConstants.maxBufferedEventsPerFetch;
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
        final canBuffer =
            events.length < maxEvents &&
            contentLength <= maxEventContentBytes &&
            totalContentBytes + contentLength <= maxAggregateContentBytes;
        if (canBuffer && _hasAcceptableEventShape(event)) {
          totalContentBytes += contentLength;
          events.add(event);
        }
        // dart_nostr retains every unique event in a process-wide registry,
        // even after the subscription is closed. Keep that dependency cache
        // bounded; the app does its own bounded collection above.
        final registry = _nostr.services.relays.eventsRegistry;
        if (registry.length > _maxDependencyEventCache) registry.clear();
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
      _nostr.services.relays.eventsRegistry.clear();
    }
    return events;
  }

  /// Requires an acknowledgement from every configured target before a task
  /// is marked synchronized. Partial success is retried idempotently later.
  ///
  /// Each per-relay send carries its own outer [Future.timeout] on top of the
  /// timeout passed to `dart_nostr`: when a relay in [relayUrls] never got
  /// registered (its websocket connection failed — e.g. an unreachable
  /// personal home relay), `sendEventToRelaysAsync` builds an empty completer
  /// list and its `Future.any([])` NEVER completes, ignoring its own timeout
  /// parameter entirely. Without this outer bound one dead relay would hang
  /// the publish forever, permanently wedging the app's single-flight sync.
  Future<void> _sendToEveryRelay(
    NostrEvent event,
    List<String> relayUrls,
  ) async {
    final outerTimeout =
        AppConstants.syncEoseTimeout + const Duration(seconds: 2);
    final acknowledgements = await Future.wait([
      for (final relayUrl in relayUrls.toSet())
        _nostr.services.relays
            .sendEventToRelaysAsync(
              event,
              timeout: AppConstants.syncEoseTimeout,
              relays: [relayUrl],
            )
            .timeout(
              outerTimeout,
              onTimeout: () => throw StateError(
                'A configured relay did not respond to the publish.',
              ),
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
      if (!_hasAcceptableEventShape(event)) return false;
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

  /// Rejects malformed/oversized event structure before it can reach crypto.
  /// The Nostr dependency parses and retains relay events before this service
  /// sees them, so this is paired with the bounded registry cleanup in
  /// [_fetchFromRelays].
  bool _hasAcceptableEventShape(NostrEvent event) {
    if (event.id?.length != 64 ||
        event.pubkey.length != 64 ||
        event.sig?.length != 128) {
      return false;
    }
    final tags = event.tags;
    if (tags == null || tags.length > 64) return false;

    var tagCharacters = 0;
    for (final tag in tags) {
      if (tag.length > 16) return false;
      for (final value in tag) {
        if (value.length > 1024) return false;
        tagCharacters += value.length;
        if (tagCharacters > 16384) return false;
      }
    }
    return true;
  }

  /// Last barrier before a socket is opened. Re-applies
  /// [normalizeSecureRelayUrl] — plaintext only towards the local network —
  /// so a tampered or hand-edited relay list cannot smuggle a cleartext
  /// connection to a public host through this layer, and caps the fan-out.
  void _validateRelayUrls(Iterable<String> relayUrls) {
    final unique = relayUrls.toSet();
    if (unique.length > AppConstants.maxRelayConnections) {
      throw ArgumentError(
        'Too many relay connections '
        '(maximum ${AppConstants.maxRelayConnections}).',
      );
    }
    for (final raw in unique) {
      if (normalizeSecureRelayUrl(raw) == null) {
        throw ArgumentError.value(raw, 'relayUrls', 'Invalid relay URL.');
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
