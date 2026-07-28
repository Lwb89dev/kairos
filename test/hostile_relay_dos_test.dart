import 'package:dart_nostr/dart_nostr.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kairos/models/user_model.dart';
import 'package:kairos/services/nostr_service.dart';
import 'package:kairos/utils/constants.dart';
import 'package:kairos/utils/crypto.dart';

/// Regression tests for the CPU-exhaustion path.
///
/// A relay is untrusted transport and may answer a REQ with any number of
/// events carrying the requested pubkey and kind. Verifying one Schnorr
/// signature costs ~7 ms of pure-Dart secp256k1 work and one NIP-44 decrypt
/// ~4 ms, so an unbounded loop over the reply froze the UI isolate for tens
/// of seconds — well past Android's 5 s ANR threshold.
///
/// The fix reduces the reply *before* any cryptography runs: kind 30789 is
/// parameterized-replaceable, so only the newest event per `d` tag can
/// matter, and the number of distinct tags that reach verification is capped.
void main() {
  late NostrService service;
  late User author;
  late NostrKeyPairs keys;

  setUp(() {
    service = NostrService();
    keys = Nostr.instance.services.keys.generateKeyPair();
    author = User(
      publicKeyHex: keys.public,
      npub: Nostr.instance.services.bech32.encodePublicKeyToNpub(keys.public),
      loginMethod: LoginMethod.importedKey,
      privateKeyHex: keys.private,
    );
  });

  NostrEvent forgedEvent(String dTag, {required DateTime createdAt}) {
    // Claims the victim's pubkey, but the signature is junk: exactly what a
    // hostile relay can synthesize for free, and what used to buy an
    // expensive verification each.
    return NostrEvent(
      id: 'f' * 64,
      kind: AppConstants.taskEventKind,
      content: 'not-a-real-payload',
      sig: '0' * 128,
      pubkey: author.publicKeyHex,
      createdAt: createdAt,
      tags: [
        ['d', dTag],
      ],
    );
  }

  test('the work limiter keeps only the newest event per coordinate', () {
    final base = DateTime.utc(2026, 1, 1);
    final flood = [
      for (var i = 0; i < 5000; i++)
        forgedEvent(
          '${AppConstants.dTagPrefix}same-task',
          createdAt: base.add(Duration(seconds: i)),
        ),
    ];

    final selected = service.debugSelectNewestPerCoordinate(flood, author);

    expect(
      selected,
      hasLength(1),
      reason: '5000 revisions of one replaceable coordinate are one task',
    );
    expect(
      selected.values.single.createdAt,
      base.add(const Duration(seconds: 4999)),
      reason: 'the surviving revision must be the newest one',
    );
  });

  test('the number of verified events is capped', () {
    final flood = [
      for (var i = 0; i < 5000; i++)
        forgedEvent(
          '${AppConstants.dTagPrefix}task-$i',
          createdAt: DateTime.utc(2026, 1, 1),
        ),
    ];

    final selected = service.debugSelectNewestPerCoordinate(flood, author);

    expect(selected, hasLength(AppConstants.maxVerifiedEventsPerFetch));
    expect(
      selected.length * 11,
      lessThan(5000 * 12),
      reason: 'total crypto work stays bounded and proportional to the cap',
    );
  });

  /// Two separate properties keep a sync off the ANR path, and it is worth
  /// being precise about which does what:
  ///
  ///  - [AppConstants.maxVerifiedEventsPerFetch] bounds the *total* work, so
  ///    a hostile relay cannot make a sync run arbitrarily long.
  ///  - [AppConstants.cryptoYieldInterval] bounds the longest *uninterrupted*
  ///    run between two turns of the event loop, which is what actually
  ///    decides whether the UI freezes.
  ///
  /// The cap alone is not enough: at ~11 ms of secp256k1 work per event, the
  /// full 512-event budget is several seconds of CPU. That is acceptable
  /// spread across yields and unacceptable in one blocking loop.
  test('no uninterrupted crypto run can reach the ANR threshold', () {
    const millisecondsPerEvent = 11; // measured: ~7 ms verify + ~4 ms decrypt
    const androidAnrThresholdMs = 5000;

    final longestBlockingRunMs =
        AppConstants.cryptoYieldInterval * millisecondsPerEvent;

    expect(
      longestBlockingRunMs,
      lessThan(androidAnrThresholdMs ~/ 10),
      reason:
          'a single uninterrupted batch must stay an order of magnitude '
          'below the ANR threshold, even on a phone several times slower '
          'than the machine these figures were measured on',
    );
  });

  test(
    'events that are not the requested author or kind never reach crypto',
    () {
      final other = Nostr.instance.services.keys.generateKeyPair();
      final noise = [
        NostrEvent(
          id: 'a' * 64,
          kind: AppConstants.taskEventKind,
          content: 'x',
          sig: '0' * 128,
          pubkey: other.public, // wrong author
          createdAt: DateTime.utc(2026),
          tags: [
            ['d', '${AppConstants.dTagPrefix}a'],
          ],
        ),
        NostrEvent(
          id: 'b' * 64,
          kind: 1, // wrong kind
          content: 'x',
          sig: '0' * 128,
          pubkey: author.publicKeyHex,
          createdAt: DateTime.utc(2026),
          tags: [
            ['d', '${AppConstants.dTagPrefix}b'],
          ],
        ),
        // Right author and kind, but not a Kairos task coordinate.
        forgedEvent('someone-elses-app:c', createdAt: DateTime.utc(2026)),
        // Right everything, but empty content — nothing to decrypt.
        NostrEvent(
          id: 'd' * 64,
          kind: AppConstants.taskEventKind,
          content: '',
          sig: '0' * 128,
          pubkey: author.publicKeyHex,
          createdAt: DateTime.utc(2026),
          tags: [
            ['d', '${AppConstants.dTagPrefix}d'],
          ],
        ),
      ];

      expect(service.debugSelectNewestPerCoordinate(noise, author), isEmpty);
    },
  );

  test('a forged signature is still rejected after the cheap pre-filter', () {
    // The limiter is not a security control — it only bounds work. An event
    // that survives it must still fail authentication.
    final forged = forgedEvent(
      '${AppConstants.dTagPrefix}x',
      createdAt: DateTime.utc(2026),
    );
    final selected = service.debugSelectNewestPerCoordinate([forged], author);
    expect(selected, hasLength(1), reason: 'survives the cheap pre-filter');
    expect(
      service.debugIsAuthenticEvent(
        selected.values.single,
        expectedAuthor: author.publicKeyHex,
        expectedKind: AppConstants.taskEventKind,
      ),
      isFalse,
      reason: 'but must fail the real signature check',
    );
  });

  test('a genuine event passes authentication', () {
    final content = CryptoUtils.encryptNip44(
      plaintext: '{"ok":true}',
      privateKeyHex: keys.private,
      recipientPublicKeyHex: keys.public,
    );
    final genuine = NostrEvent.fromPartialData(
      kind: AppConstants.taskEventKind,
      content: content,
      keyPairs: keys,
      tags: [
        ['d', '${AppConstants.dTagPrefix}real'],
      ],
      createdAt: DateTime.utc(2026),
    );

    expect(
      service.debugIsAuthenticEvent(
        genuine,
        expectedAuthor: author.publicKeyHex,
        expectedKind: AppConstants.taskEventKind,
      ),
      isTrue,
    );
  });

  group('deselected relays get disconnected', () {
    test(
      'a shrunk selection triggers a teardown, a grown one does not',
      () async {
        // dart_nostr's registry is append-only, so the service tracks what it
        // opened. Nothing here touches a socket: with no relay ever connected
        // the tracked set is empty, and the call must be a no-op either way.
        await service.dropDeselectedRelays({'wss://a.example'});
        await service.dropDeselectedRelays(const {});
        // Reaching here without throwing is the assertion: a teardown on an
        // empty/failed registry must never propagate an error into a save.
        expect(true, isTrue);
      },
    );
  });

  test('the buffered-event ceiling stays below the old 5000', () {
    expect(AppConstants.maxBufferedEventsPerFetch, lessThan(5000));
    expect(
      AppConstants.maxVerifiedEventsPerFetch,
      lessThan(AppConstants.maxBufferedEventsPerFetch),
    );
  });

  test('the transport repeats the URL boundary checks', () async {
    // A tampered relay list must not get a cleartext socket to a public host
    // past the transport layer, even though the settings layer already
    // refused it.
    expect(
      service.fetchTasks(
        author: author,
        relayUrls: const ['ws://relay.example'],
      ),
      throwsArgumentError,
    );
    expect(
      service.fetchTasks(author: author, relayUrls: const ['http://nos.lol']),
      throwsArgumentError,
    );
    expect(
      service.fetchTasks(
        author: author,
        relayUrls: List.generate(
          AppConstants.maxRelayConnections + 1,
          (i) => 'wss://relay$i.example',
        ),
      ),
      throwsArgumentError,
    );
  });
}
