import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:kairos/models/reminder_model.dart';
import 'package:kairos/models/sync_config_model.dart';
import 'package:kairos/models/task_model.dart';
import 'package:kairos/models/user_model.dart';
import 'package:kairos/services/astraea_calendar_mirror.dart';
import 'package:kairos/services/nostr_service.dart';
import 'package:kairos/utils/constants.dart';
import 'package:kairos/utils/task_colors.dart';

/// Records what would have gone to the relays instead of dialing one.
class _RecordingNostrService implements NostrService {
  final published = <({int kind, String dTag, String content})>[];
  final retracted = <String>[];

  @override
  Future<String> publishRawEvent({
    required User author,
    required int kind,
    required String dTag,
    required String plaintextContent,
    required DateTime createdAt,
    required List<String> relayUrls,
  }) async {
    published.add((kind: kind, dTag: dTag, content: plaintextContent));
    return 'event-${published.length}';
  }

  @override
  Future<void> publishDeletion({
    required User author,
    required String nostrEventId,
    required List<String> relayUrls,
  }) async {
    retracted.add(nostrEventId);
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late _RecordingNostrService nostr;
  late AstraeaCalendarMirror mirror;

  // Not const: string repetition is not a constant expression in Dart.
  final author = User(
    publicKeyHex: 'a' * 64,
    npub: 'npub1test',
    loginMethod: LoginMethod.importedKey,
    privateKeyHex: 'b' * 64,
  );
  const config = SyncConfig(relays: ['wss://relay.example']);

  final dueDate = DateTime.utc(2026, 9, 15, 14, 30);
  final createdAt = DateTime.utc(2026, 8, 1, 9);

  Task task({
    bool mirrorToCalendar = true,
    bool localOnly = false,
    bool deleted = false,
    DateTime? due,
    String? description,
    TaskColor? color,
    List<Reminder> reminders = const [],
  }) {
    return Task(
      id: 'task-uuid',
      title: 'Pay the electricity bill',
      description: description,
      dueDateUtc: due ?? dueDate,
      color: color,
      createdAt: createdAt,
      updatedAt: createdAt,
      deleted: deleted,
      localOnly: localOnly,
      reminders: reminders,
      mirrorToCalendar: mirrorToCalendar,
    );
  }

  setUp(() {
    nostr = _RecordingNostrService();
    mirror = AstraeaCalendarMirror(nostrService: nostr);
  });

  group('what gets mirrored', () {
    test('a dated, syncable task the user opted in for', () {
      expect(AstraeaCalendarMirror.shouldMirror(task()), isTrue);
    });

    test('not one the user did not opt in for', () {
      expect(
        AstraeaCalendarMirror.shouldMirror(task(mirrorToCalendar: false)),
        isFalse,
      );
    });

    test('never a local-only task', () {
      // The whole point of local-only is that it does not reach a relay;
      // mirroring it would publish exactly what the user kept off the network.
      expect(
        AstraeaCalendarMirror.shouldMirror(task(localOnly: true)),
        isFalse,
      );
    });

    test('never a deleted task', () {
      expect(AstraeaCalendarMirror.shouldMirror(task(deleted: true)), isFalse);
    });

    test('publishing one that must not be mirrored is refused outright', () {
      expect(
        () => mirror.publish(
          task: task(localOnly: true),
          config: config,
          author: author,
        ),
        throwsStateError,
      );
    });
  });

  group('the published event is one Astraea can read', () {
    test('kind and coordinate are Astraea\'s, not ours', () async {
      await mirror.publish(task: task(), config: config, author: author);

      final event = nostr.published.single;
      expect(event.kind, AppConstants.astraeaCalendarEventKind);
      expect(event.kind, 30078, reason: 'NIP-78 application-specific data');
      expect(event.dTag, 'epochs:task-uuid');
      expect(event.dTag, startsWith(AppConstants.astraeaDTagPrefix));
    });

    test('the coordinate is derived from the task, so edits replace', () async {
      final subject = task();
      await mirror.publish(task: subject, config: config, author: author);
      await mirror.publish(
        task: subject.copyWith(title: 'Renamed'),
        config: config,
        author: author,
      );

      expect(nostr.published, hasLength(2));
      expect(
        nostr.published.first.dTag,
        nostr.published.last.dTag,
        reason: 'a replaceable coordinate, not a second calendar entry',
      );
    });

    test('carries every field Astraea\'s Event.fromJson requires', () async {
      await mirror.publish(task: task(), config: config, author: author);
      final json =
          jsonDecode(nostr.published.single.content) as Map<String, dynamic>;

      // Mirrors the required reads in Astraea's Event.fromJson.
      expect(json['id'], 'task-uuid');
      expect(json['title'], 'Pay the electricity bill');
      expect(json['startTimeUtc'], isA<String>());
      expect(json['endTimeUtc'], isA<String>());
      expect(json['timezone'], isA<String>());
      expect(json['isAllDay'], isA<bool>());
      expect(json['reminders'], isA<List<dynamic>>());
      expect(json['color'], isA<String>());
      expect(json['deleted'], isFalse);
      expect(json['createdAt'], isA<int>());
      expect(json['updatedAt'], isA<int>());
      expect(DateTime.parse(json['startTimeUtc'] as String).isUtc, isTrue);
    });

    test(
      'a deadline is visually a point but remains visible at midnight',
      () async {
        await mirror.publish(task: task(), config: config, author: author);
        final json =
            jsonDecode(nostr.published.single.content) as Map<String, dynamic>;
        final start = DateTime.parse(json['startTimeUtc'] as String);
        final end = DateTime.parse(json['endTimeUtc'] as String);
        expect(end.difference(start), const Duration(milliseconds: 1));
        expect(start, dueDate, reason: 'the event lands on the task deadline');
      },
    );

    test('a midnight deadline still has a visible calendar day', () async {
      await mirror.publish(
        task: task(due: DateTime.utc(2026, 9, 15)),
        config: config,
        author: author,
      );
      final json =
          jsonDecode(nostr.published.single.content) as Map<String, dynamic>;
      final start = DateTime.parse(json['startTimeUtc'] as String);
      final end = DateTime.parse(json['endTimeUtc'] as String);
      expect(start.hour, 0);
      expect(end.isAfter(start), isTrue);
    });

    test('reminders travel with it', () async {
      await mirror.publish(
        task: task(reminders: const [Reminder(minutesBefore: 60)]),
        config: config,
        author: author,
      );
      final json =
          jsonDecode(nostr.published.single.content) as Map<String, dynamic>;
      expect(json['reminders'], [
        {'minutesBefore': 60},
      ]);
    });

    test('the description says where the entry came from', () async {
      await mirror.publish(
        task: task(description: 'Account 12345'),
        config: config,
        author: author,
      );
      final json =
          jsonDecode(nostr.published.single.content) as Map<String, dynamic>;
      expect(json['description'], contains('Kairos task'));
      expect(json['description'], contains('Account 12345'));
    });

    test('colour is Astraea\'s ARGB string form', () async {
      await mirror.publish(
        task: task(color: TaskColor.blue),
        config: config,
        author: author,
      );
      final coloured =
          jsonDecode(nostr.published.single.content) as Map<String, dynamic>;
      expect(coloured['color'], matches(RegExp(r'^0x[0-9A-F]{8}$')));

      nostr.published.clear();
      await mirror.publish(task: task(), config: config, author: author);
      final plain =
          jsonDecode(nostr.published.single.content) as Map<String, dynamic>;
      expect(plain['color'], AppConstants.astraeaDefaultEventColor);
    });

    test('makes no claim about Astraea\'s own sync state', () async {
      await mirror.publish(task: task(), config: config, author: author);
      final json =
          jsonDecode(nostr.published.single.content) as Map<String, dynamic>;
      expect(json['synced'], isFalse);
      expect(json['nostrEventId'], isNull);
      expect(json['syncOwnerPubkey'], isNull);
    });
  });

  test(
    'retracting publishes an Astraea tombstone and asks relays to clean up',
    () async {
      final subject = task().copyWith(calendarNostrEventId: 'previous-event');
      await mirror.retract(task: subject, config: config, author: author);
      final tombstone = nostr.published.single;
      final json = jsonDecode(tombstone.content) as Map<String, dynamic>;
      expect(tombstone.kind, AppConstants.astraeaCalendarEventKind);
      expect(tombstone.dTag, 'epochs:task-uuid');
      expect(json['deleted'], isTrue);
      expect(nostr.retracted, ['previous-event']);
    },
  );

  test('the mirror never collides with the Kairos task itself', () {
    final subject = task();
    expect(
      AstraeaCalendarMirror.calendarDTagFor(subject.id),
      isNot(subject.dTag),
    );
    expect(subject.dTag, startsWith(AppConstants.dTagPrefix));
  });
}
