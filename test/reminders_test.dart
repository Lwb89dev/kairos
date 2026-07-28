import 'package:flutter_test/flutter_test.dart';
import 'package:kairos/models/reminder_model.dart';
import 'package:kairos/models/task_model.dart';
import 'package:kairos/services/local_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

Task taskWith({
  DateTime? dueDateUtc,
  List<Reminder> reminders = const [],
  bool mirrorToCalendar = false,
}) {
  final now = DateTime.utc(2026, 8, 1, 9);
  return Task(
    id: 'task-1',
    title: 'Pay the bill',
    dueDateUtc: dueDateUtc,
    createdAt: now,
    updatedAt: now,
    reminders: reminders,
    mirrorToCalendar: mirrorToCalendar,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Reminder parsing', () {
    test('accepts a well-formed offset', () {
      expect(Reminder.fromJson({'minutesBefore': 60}).minutesBefore, 60);
      expect(Reminder.fromJson({'minutesBefore': 0}).minutesBefore, 0);
    });

    test('refuses offsets that could never produce a sane fire instant', () {
      expect(
        () => Reminder.fromJson({'minutesBefore': -1}),
        throwsFormatException,
      );
      expect(
        () =>
            Reminder.fromJson({'minutesBefore': Reminder.maxMinutesBefore + 1}),
        throwsFormatException,
      );
      expect(
        () => Reminder.fromJson({'minutesBefore': 'soon'}),
        throwsFormatException,
      );
      expect(() => Reminder.fromJson({}), throwsFormatException);
    });

    test('a malformed entry is dropped, not fatal to the whole list', () {
      final parsed = Reminder.listFromJson([
        {'minutesBefore': 15},
        {'minutesBefore': 'nonsense'},
        {'minutesBefore': 60},
      ]);
      expect(parsed.map((r) => r.minutesBefore), [60, 15]);
    });

    test('duplicate offsets collapse — they would fire twice otherwise', () {
      final parsed = Reminder.listFromJson([
        {'minutesBefore': 15},
        {'minutesBefore': 15},
        {'minutesBefore': 15},
      ]);
      expect(parsed, hasLength(1));
    });

    test('the per-task ceiling is enforced on parse', () {
      final parsed = Reminder.listFromJson([
        for (var i = 1; i <= 50; i++) {'minutesBefore': i},
      ]);
      expect(parsed.length, lessThanOrEqualTo(Reminder.maxPerTask));
    });

    test('a non-list is a corrupt record', () {
      expect(() => Reminder.listFromJson('15'), throwsFormatException);
      expect(Reminder.listFromJson(null), isEmpty);
    });
  });

  group('reminders cannot outlive the due date they count back from', () {
    test('fromJson drops them when no due date is stored', () {
      final json = taskWith(
        dueDateUtc: DateTime.utc(2026, 9, 1),
        reminders: const [Reminder(minutesBefore: 60)],
        mirrorToCalendar: true,
      ).toJson()..['dueDate'] = null;

      final parsed = Task.fromJson(json);
      expect(parsed.reminders, isEmpty);
      expect(parsed.mirrorToCalendar, isFalse);
    });

    test('copyWith drops them when the due date is cleared', () {
      final task = taskWith(
        dueDateUtc: DateTime.utc(2026, 9, 1),
        reminders: const [Reminder(minutesBefore: 60)],
        mirrorToCalendar: true,
      );
      final cleared = task.copyWith(clearDueDate: true);
      expect(cleared.reminders, isEmpty);
      expect(cleared.mirrorToCalendar, isFalse);
    });

    test('copyWith refuses to attach them to an undated task', () {
      final undated = taskWith();
      final attempted = undated.copyWith(
        reminders: const [Reminder(minutesBefore: 60)],
        mirrorToCalendar: true,
      );
      expect(attempted.reminders, isEmpty);
      expect(attempted.mirrorToCalendar, isFalse);
    });

    test('they survive an ordinary edit', () {
      final task = taskWith(
        dueDateUtc: DateTime.utc(2026, 9, 1),
        reminders: const [Reminder(minutesBefore: 60)],
        mirrorToCalendar: true,
      );
      final edited = task.copyWith(title: 'Renamed');
      expect(edited.reminders, task.reminders);
      expect(edited.mirrorToCalendar, isTrue);
    });
  });

  group('what travels to the relays', () {
    final task = taskWith(
      dueDateUtc: DateTime.utc(2026, 9, 1),
      reminders: const [Reminder(minutesBefore: 60)],
      mirrorToCalendar: true,
    );

    test('reminders and the calendar choice sync across devices', () {
      final sync = task.toSyncJson();
      expect(sync['reminders'], [
        {'minutesBefore': 60},
      ]);
      expect(sync['mirrorToCalendar'], isTrue);
    });

    test('per-publish bookkeeping stays on the device', () {
      final sync = task
          .copyWith(
            calendarNostrEventId: 'abc',
            calendarMirrorRetractionPending: true,
            synced: true,
          )
          .toSyncJson();
      expect(sync.containsKey('calendarNostrEventId'), isFalse);
      expect(sync.containsKey('calendarMirrorRetractionPending'), isFalse);
      expect(sync.containsKey('nostrEventId'), isFalse);
      expect(sync.containsKey('localOnly'), isFalse);
    });

    test('a full round trip preserves them', () {
      final restored = Task.fromJson(task.toJson());
      expect(restored.reminders, task.reminders);
      expect(restored.mirrorToCalendar, isTrue);
    });

    test('a pending mirror retraction survives local persistence only', () {
      final pending = task.copyWith(calendarMirrorRetractionPending: true);
      final restored = Task.fromJson(pending.toJson());
      expect(restored.calendarMirrorRetractionPending, isTrue);
      expect(
        restored.toSyncJson(),
        isNot(contains('calendarMirrorRetractionPending')),
      );
    });
  });

  group('notification id bookkeeping', () {
    setUp(() => SharedPreferences.setMockInitialValues({}));

    test('ids are never handed out twice', () async {
      final storage = LocalStorageService();
      final first = await storage.allocateNotificationIds(3);
      final second = await storage.allocateNotificationIds(3);
      expect(first.toSet().intersection(second.toSet()), isEmpty);
      expect(first, hasLength(3));
    });

    test('ids stay inside the 32-bit range Android requires', () async {
      final storage = LocalStorageService();
      final ids = await storage.allocateNotificationIds(5);
      for (final id in ids) {
        expect(id, greaterThanOrEqualTo(0));
        expect(id, lessThan(0x7FFFFFFF));
      }
    });

    test('a task cancels exactly its own alarms', () async {
      final storage = LocalStorageService();
      await storage.saveNotificationIds('a', [1, 2]);
      await storage.saveNotificationIds('b', [3]);

      expect(await storage.loadNotificationIds('a'), [1, 2]);
      expect((await storage.loadAllNotificationIds()).toSet(), {1, 2, 3});

      await storage.clearNotificationIds('a');
      expect(await storage.loadNotificationIds('a'), isEmpty);
      expect(await storage.loadNotificationIds('b'), [3]);
    });

    test('corrupt bookkeeping degrades to empty instead of throwing', () async {
      SharedPreferences.setMockInitialValues({
        'kairos.notification_ids': 'not json at all',
      });
      expect(await LocalStorageService().loadAllNotificationIds(), isEmpty);
    });

    test('the master switch defaults to on', () async {
      expect(await LocalStorageService().loadNotificationsEnabled(), isTrue);
    });

    test('the master switch round-trips', () async {
      final storage = LocalStorageService();
      await storage.saveNotificationsEnabled(false);
      expect(await storage.loadNotificationsEnabled(), isFalse);
    });
  });
}
