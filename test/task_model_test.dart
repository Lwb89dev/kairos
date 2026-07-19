import 'package:kairos/main.dart';
import 'package:kairos/models/task_model.dart';
import 'package:kairos/models/sync_config_model.dart';
import 'package:kairos/utils/relay_url.dart';
import 'package:kairos/utils/task_colors.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Importing main.dart pulls the whole lib/ tree into this test's
  // compilation, so `flutter test` doubles as a full compile check even on
  // machines without a platform toolchain.
  test('app widget type exists', () {
    expect(KairosApp, isNotNull);
  });

  group('Task', () {
    final created = DateTime.utc(2026, 7, 1, 10);
    final due = DateTime.utc(2026, 7, 31, 23, 59, 59);

    Task buildTask() => Task(
      id: 'abc-123',
      title: 'Finire Echoes',
      description: 'ultimo step',
      dueDateUtc: due,
      tags: const ['work', 'priority-high'],
      priority: 4,
      color: TaskColor.blue,
      createdAt: created,
      updatedAt: created,
    );

    test('round-trips through JSON', () {
      final task = buildTask();
      final restored = Task.fromJson(task.toJson());

      expect(restored.id, task.id);
      expect(restored.title, task.title);
      expect(restored.description, task.description);
      expect(restored.dueDateUtc, task.dueDateUtc);
      expect(restored.status, TaskStatus.pending);
      expect(restored.tags, task.tags);
      expect(restored.priority, task.priority);
      expect(restored.color, TaskColor.blue);
      expect(restored.createdAt, task.createdAt);
      expect(restored.updatedAt, task.updatedAt);
      expect(restored.synced, isFalse);
      expect(restored.deleted, isFalse);
    });

    test('sync JSON excludes device-local bookkeeping', () {
      final task = buildTask().copyWith(
        synced: true,
        nostrEventId: 'event-id',
        syncOwnerPubkey: List.filled(64, 'a').join(),
        deletionRequestPending: true,
      );
      final wire = task.toSyncJson();
      expect(wire, isNot(contains('synced')));
      expect(wire, isNot(contains('nostrEventId')));
      expect(wire, isNot(contains('syncOwnerPubkey')));
      expect(wire, isNot(contains('deletionRequestPending')));
    });

    test('d tag is checkmarks-prefixed and stable', () {
      expect(buildTask().dTag, 'checkmarks:abc-123');
    });

    test('copyWith can clear the due date and priority', () {
      final cleared = buildTask().copyWith(
        clearDueDate: true,
        clearPriority: true,
      );
      expect(cleared.dueDateUtc, isNull);
      expect(cleared.priority, isNull);
      // And a plain copyWith must NOT clear them.
      final kept = buildTask().copyWith(title: 'x');
      expect(kept.dueDateUtc, due);
      expect(kept.priority, 4);
    });

    test('unknown status falls back to pending', () {
      final json = buildTask().toJson()..['status'] = 'garbage';
      expect(Task.fromJson(json).status, TaskStatus.pending);
    });

    test('copyWith can clear the color, plain copyWith keeps it', () {
      expect(buildTask().copyWith(clearColor: true).color, isNull);
      expect(buildTask().copyWith(title: 'x').color, TaskColor.blue);
    });

    test('unknown or missing color deserializes as null', () {
      final json = buildTask().toJson()..['color'] = 'garbage';
      expect(Task.fromJson(json).color, isNull);
      final noColor = buildTask().toJson()..remove('color');
      expect(Task.fromJson(noColor).color, isNull);
    });

    test('rejects oversized and invalid untrusted payload fields', () {
      final longTitle = buildTask().toJson()
        ..['title'] = List.filled(513, 'x').join();
      expect(() => Task.fromJson(longTitle), throwsFormatException);

      final invalidPriority = buildTask().toJson()..['priority'] = 99;
      expect(() => Task.fromJson(invalidPriority), throwsFormatException);

      final longTag = buildTask().toJson()
        ..['tags'] = [List.filled(65, 'x').join()];
      expect(() => Task.fromJson(longTag), throwsFormatException);
    });
  });

  group('SyncConfig', () {
    test('allSyncRelays appends the home relay, de-duplicated', () {
      const config = SyncConfig(
        relays: ['wss://a', 'wss://b'],
        homeRelayUrl: 'wss://home',
      );
      expect(config.allSyncRelays, ['wss://a', 'wss://b', 'wss://home']);

      const dup = SyncConfig(relays: ['wss://a'], homeRelayUrl: 'wss://a');
      expect(dup.allSyncRelays, ['wss://a']);

      const none = SyncConfig(relays: ['wss://a']);
      expect(none.allSyncRelays, ['wss://a']);
    });

    test('copyWith can clear the home relay', () {
      const config = SyncConfig(homeRelayUrl: 'wss://home');
      expect(config.copyWith(clearHomeRelay: true).homeRelayUrl, isNull);
      expect(
        config.copyWith(relays: const ['wss://b']).homeRelayUrl,
        'wss://home',
      );
    });
  });

  test('relay URLs require encrypted transport and normalize host casing', () {
    expect(normalizeSecureRelayUrl(' WSS://NOS.LOL '), 'wss://nos.lol');
    expect(normalizeSecureRelayUrl('ws://nos.lol'), isNull);
    expect(normalizeSecureRelayUrl('https://nos.lol'), isNull);
    expect(normalizeSecureRelayUrl('wss://user@nos.lol'), isNull);
    expect(normalizeSecureRelayUrl('wss://nos.lol/#fragment'), isNull);
  });

  test('relay URLs strip a trailing slash so lookalikes dedupe', () {
    expect(normalizeSecureRelayUrl('wss://nos.lol/'), 'wss://nos.lol');
    expect(
      normalizeSecureRelayUrl('wss://relay.example.com/nostr/'),
      'wss://relay.example.com/nostr',
    );
  });

  test('public relay slot rejects loopback/private/link-local hosts', () {
    expect(normalizeSecureRelayUrl('wss://127.0.0.1'), isNull);
    expect(normalizeSecureRelayUrl('wss://localhost'), isNull);
    expect(normalizeSecureRelayUrl('wss://10.0.0.5'), isNull);
    expect(normalizeSecureRelayUrl('wss://172.16.0.5'), isNull);
    expect(normalizeSecureRelayUrl('wss://192.168.1.1'), isNull);
    expect(normalizeSecureRelayUrl('wss://169.254.169.254'), isNull);
    expect(normalizeSecureRelayUrl('wss://[::1]'), isNull);
    expect(normalizeSecureRelayUrl('wss://relay.damus.io'), isNotNull);
  });

  test(
    'home relay slot (allowInsecureLocal) accepts ws:// and private hosts',
    () {
      expect(
        normalizeSecureRelayUrl(
          'ws://192.168.1.50:4848',
          allowInsecureLocal: true,
        ),
        'ws://192.168.1.50:4848',
      );
      expect(
        normalizeSecureRelayUrl(
          'ws://relay.example.com',
          allowInsecureLocal: true,
        ),
        'ws://relay.example.com',
      );
      // Still no other scheme, userinfo or fragment, even with the exception.
      expect(
        normalizeSecureRelayUrl('http://nos.lol', allowInsecureLocal: true),
        isNull,
      );
      expect(
        normalizeSecureRelayUrl('ws://user@nos.lol', allowInsecureLocal: true),
        isNull,
      );
    },
  );
}
