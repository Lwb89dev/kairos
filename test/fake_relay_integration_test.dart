import 'dart:convert';
import 'dart:io';

import 'package:dart_nostr/dart_nostr.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kairos/models/task_model.dart';
import 'package:kairos/models/user_model.dart';
import 'package:kairos/services/nostr_service.dart';
import 'package:kairos/utils/constants.dart';
import 'package:kairos/utils/crypto.dart';

/// A minimal in-process NIP-01 relay: stores EVENTs, answers REQ with the
/// matching stored events followed by EOSE, and ACKs publishes with OK.
/// Runs on a loopback `ws://` port — which is exactly the "personal home
/// relay" shape Kairos permits — so these tests exercise the complete
/// production stack (NostrService + dart_nostr transport) without touching
/// the network.
class FakeRelay {
  final HttpServer _server;
  final List<Map<String, dynamic>> storedEvents = [];
  int reqCount = 0;

  FakeRelay._(this._server);

  String get url => 'ws://127.0.0.1:${_server.port}';

  static Future<FakeRelay> start() async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    final relay = FakeRelay._(server);
    server.listen((HttpRequest request) async {
      final socket = await WebSocketTransformer.upgrade(request);
      socket.listen((dynamic data) {
        final frame = jsonDecode(data as String) as List<dynamic>;
        final type = frame.first as String;
        if (type == 'EVENT') {
          final event = frame[1] as Map<String, dynamic>;
          // Parameterized-replaceable semantics: latest event per (kind,
          // pubkey, d-tag) replaces the previous one, like a real relay.
          String? dTagOf(Map<String, dynamic> e) {
            for (final tag in (e['tags'] as List<dynamic>)) {
              final t = tag as List<dynamic>;
              if (t.length >= 2 && t[0] == 'd') return t[1] as String;
            }
            return null;
          }

          relay.storedEvents.removeWhere(
            (e) =>
                e['kind'] == event['kind'] &&
                e['pubkey'] == event['pubkey'] &&
                dTagOf(e) != null &&
                dTagOf(e) == dTagOf(event),
          );
          relay.storedEvents.add(event);
          socket.add(jsonEncode(['OK', event['id'], true, '']));
        } else if (type == 'REQ') {
          relay.reqCount++;
          final subId = frame[1] as String;
          final filter = frame[2] as Map<String, dynamic>;
          final authors = (filter['authors'] as List<dynamic>?)?.cast<String>();
          final kinds = (filter['kinds'] as List<dynamic>?)?.cast<int>();
          for (final event in relay.storedEvents) {
            final authorOk =
                authors == null || authors.contains(event['pubkey']);
            final kindOk = kinds == null || kinds.contains(event['kind']);
            if (authorOk && kindOk) {
              socket.add(jsonEncode(['EVENT', subId, event]));
            }
          }
          socket.add(jsonEncode(['EOSE', subId]));
        }
        // CLOSE frames need no reply.
      });
    });
    return relay;
  }

  Future<void> stop() => _server.close(force: true);
}

void main() {
  late FakeRelay relay;
  late NostrService service;
  late User author;

  setUp(() async {
    relay = await FakeRelay.start();
    service = NostrService();
    final keyPair = Nostr.instance.services.keys.generateKeyPair();
    author = User(
      publicKeyHex: keyPair.public,
      npub: Nostr.instance.services.bech32.encodePublicKeyToNpub(
        keyPair.public,
      ),
      loginMethod: LoginMethod.importedKey,
      privateKeyHex: keyPair.private,
    );
  });

  tearDown(() async {
    await relay.stop();
  });

  Task buildTask() => Task(
    id: 'f3b1c2d3-0000-4000-8000-abcdefabcdef',
    title: 'Survive the restart',
    description: 'published in session one, fetched in session two',
    tags: const ['sync'],
    priority: 2,
    createdAt: DateTime.utc(2026, 7, 19, 9),
    updatedAt: DateTime.utc(2026, 7, 19, 9, 30),
  );

  test('publish then fetch through a real websocket round trip', () async {
    final task = buildTask();
    final relays = [relay.url];

    final eventId = await service.publishTask(
      author: author,
      task: task,
      relayUrls: relays,
    );
    expect(eventId, isNotEmpty);
    expect(relay.storedEvents, hasLength(1));

    final fetched = await service.fetchTasks(author: author, relayUrls: relays);
    expect(fetched, hasLength(1));
    expect(fetched.single.id, task.id);
    expect(fetched.single.title, task.title);
    expect(fetched.single.synced, isTrue);
    expect(fetched.single.nostrEventId, eventId);
    expect(
      Nostr.instance.services.relays.eventsRegistry,
      isEmpty,
      reason: 'relay event cache must not retain fetched payloads',
    );
  });

  test('cold start: fetch-only session restores a pre-existing event', () async {
    // Simulates "the app was restarted": the relay already holds the event
    // (published by a previous session / another device) and the only thing
    // this session does is fetch. Build the stored event exactly as
    // publishTask would have.
    final task = buildTask();
    final content = CryptoUtils.encryptNip44(
      plaintext: jsonEncode(task.toSyncJson()),
      privateKeyHex: author.privateKeyHex!,
      recipientPublicKeyHex: author.publicKeyHex,
    );
    final keyPair = Nostr.instance.services.keys
        .generateKeyPairFromExistingPrivateKey(author.privateKeyHex!);
    final signed = NostrEvent.fromPartialData(
      kind: AppConstants.taskEventKind,
      content: content,
      keyPairs: keyPair,
      tags: [
        ['d', task.dTag],
      ],
      createdAt: task.updatedAt,
    );
    relay.storedEvents.add(
      (jsonDecode(signed.serialized()) as List<dynamic>).last
          as Map<String, dynamic>,
    );

    final fetched = await service.fetchTasks(
      author: author,
      relayUrls: [relay.url],
    );
    expect(
      fetched,
      hasLength(1),
      reason:
          'a task already on the relay must be restored by a fetch-only session',
    );
    expect(fetched.single.id, task.id);
    expect(fetched.single.updatedAt, task.updatedAt);
  });

  test('two consecutive fetches both return the event', () async {
    // Guards against subscription/registry state in dart_nostr leaking
    // between sync cycles: the on-entry sync and a later manual sync must
    // both see the stored event.
    final task = buildTask();
    await service.publishTask(
      author: author,
      task: task,
      relayUrls: [relay.url],
    );

    final first = await service.fetchTasks(
      author: author,
      relayUrls: [relay.url],
    );
    final second = await service.fetchTasks(
      author: author,
      relayUrls: [relay.url],
    );
    expect(first, hasLength(1));
    expect(
      second,
      hasLength(1),
      reason: 'a second sync cycle in the same session must also see the event',
    );
  });

  test(
    'publish with an unreachable relay fails bounded instead of hanging',
    () async {
      // Regression test: dart_nostr's sendEventToRelaysAsync builds an empty
      // completer list for a relay whose websocket never connected (its
      // registration is silently skipped), and `Future.any([])` then ignores
      // the library timeout and never completes. Without NostrService's outer
      // per-relay timeout this publish would hang forever, permanently
      // wedging the app's single-flight sync until the next restart.
      const deadRelay = 'ws://127.0.0.1:1'; // Nothing listens on port 1.
      final task = buildTask();

      // The dead relay is the (only) configured home relay: its websocket
      // connection fails, it never enters dart_nostr's registry, and the
      // publish would previously wait on `Future.any([])` forever.
      await expectLater(
        service
            .publishTask(
              author: author,
              task: task,
              relayUrls: const [deadRelay],
            )
            .timeout(const Duration(seconds: 25)),
        throwsA(isA<StateError>()),
        reason:
            'an unreachable relay must produce a bounded failure, never an '
            'indefinite hang',
      );
    },
  );

  test('a local-only task is refused by the publish path', () async {
    final pinned = buildTask().copyWith(localOnly: true);
    await expectLater(
      service.publishTask(author: author, task: pinned, relayUrls: [relay.url]),
      throwsA(isA<StateError>()),
      reason: 'Task.localOnly must never reach a relay, not even by mistake',
    );
    expect(relay.storedEvents, isEmpty);
  });
}
