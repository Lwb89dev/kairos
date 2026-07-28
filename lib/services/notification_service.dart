import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../models/task_model.dart';
import '../utils/constants.dart';
import '../utils/logger.dart';
import 'local_storage_service.dart';

/// Task reminders, handed to the OS when a task is saved and delivered by it —
/// no polling, no background service, nothing running while the app is closed.
///
/// Each [Reminder] on a task becomes one `zonedSchedule()` at
/// `dueDate - minutesBefore`, converted to a [tz.TZDateTime] so the OS fires
/// it at the intended wall-clock moment even if a DST change falls between
/// scheduling and delivery.
///
/// Android drops all alarms on reboot; the plugin's own
/// `ScheduledNotificationBootReceiver` (declared in AndroidManifest.xml)
/// restores them, so there is no BOOT_COMPLETED path to write here.
///
/// Everything is best-effort by design: a task must always save, whether or
/// not the OS agreed to schedule anything. A denied permission costs the user
/// a notification, never their data.
class NotificationService {
  NotificationService({required LocalStorageService localStorageService})
    : _localStorage = localStorageService;

  final LocalStorageService _localStorage;
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;
  bool _available = false;

  /// One-time setup: initializes the plugin, creates the Android channel and
  /// asks for the permissions scheduling needs. Called from `main()` before
  /// the first frame.
  ///
  /// Never throws. On a platform without the plugin (Linux desktop builds)
  /// this leaves the service inert and every other method becomes a no-op.
  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
    debugLog('NotificationService.init called', name: 'NotificationService');

    try {
      const settings = InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      );
      await _plugin.initialize(settings);
      await _configureAndroid();
      _available = true;
    } catch (_) {
      debugLog('Notifications unavailable on this platform', name: 'NS');
      _available = false;
    }
  }

  Future<void> _configureAndroid() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android == null) return;

    await android.createNotificationChannel(
      const AndroidNotificationChannel(
        AppConstants.reminderChannelId,
        AppConstants.reminderChannelName,
        description: AppConstants.reminderChannelDescription,
        importance: Importance.high,
      ),
    );
    // POST_NOTIFICATIONS (Android 13+) and exact alarms (Android 12+). A
    // refusal must not break startup — it only means reminders won't show, or
    // will be delivered inexactly, until the user grants them.
    await android.requestNotificationsPermission();
    await android.requestExactAlarmsPermission();
  }

  /// (Re)schedules every reminder for [task]. Idempotent: whatever was
  /// scheduled for this task before is cancelled first, so editing a task
  /// never leaves a stale notification behind.
  ///
  /// No-op when reminders are off in Settings, or when the task is completed,
  /// deleted, has no due date or has no reminders.
  Future<void> scheduleForTask(Task task) async {
    await cancelForTask(task.id);
    if (!_available) return;
    if (!_shouldNotify(task)) return;
    if (!await _localStorage.loadNotificationsEnabled()) return;

    final dueDate = task.dueDateUtc!;
    final now = DateTime.now().toUtc();
    final pending = <({DateTime fireAt, int minutesBefore})>[];
    for (final reminder in task.reminders) {
      final fireAt = dueDate.subtract(
        Duration(minutes: reminder.minutesBefore),
      );
      // A reminder whose moment has already passed is silently skipped rather
      // than fired immediately: a notification for something the user set up
      // days ago is noise, not a reminder.
      if (fireAt.isAfter(now)) {
        pending.add((fireAt: fireAt, minutesBefore: reminder.minutesBefore));
      }
    }
    if (pending.isEmpty) return;

    debugLog(
      'Scheduling ${pending.length} reminder(s)',
      name: 'NotificationService',
    );
    final ids = await _localStorage.allocateNotificationIds(pending.length);
    final scheduled = <int>[];
    for (var i = 0; i < pending.length; i++) {
      if (await _scheduleOne(ids[i], task, pending[i])) scheduled.add(ids[i]);
    }
    await _localStorage.saveNotificationIds(task.id, scheduled);
  }

  /// Returns whether the alarm was accepted. A single failure (typically a
  /// denied exact-alarm permission) must not abort the rest, and only what
  /// actually got through is recorded, so cancellation stays accurate.
  Future<bool> _scheduleOne(
    int id,
    Task task,
    ({DateTime fireAt, int minutesBefore}) pending,
  ) async {
    try {
      await _plugin.zonedSchedule(
        id,
        task.title,
        _bodyFor(pending.minutesBefore),
        tz.TZDateTime.from(pending.fireAt, tz.local),
        _details(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        // The instant is already absolute (a UTC due date projected into the
        // device's zone); it must not be reinterpreted as a wall-clock time.
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: task.id,
      );
      return true;
    } catch (_) {
      debugLog('Could not schedule one reminder', name: 'NotificationService');
      return false;
    }
  }

  /// A task only deserves a notification while it is still something the user
  /// has to do.
  bool _shouldNotify(Task task) {
    if (task.deleted || task.isDone) return false;
    if (task.dueDateUtc == null) return false;
    return task.reminders.isNotEmpty;
  }

  /// Cancels every notification scheduled for [taskId] — on delete, on
  /// completion, and before re-scheduling on edit.
  Future<void> cancelForTask(String taskId) async {
    final ids = await _localStorage.loadNotificationIds(taskId);
    if (ids.isEmpty) return;
    for (final id in ids) {
      await _cancel(id);
    }
    await _localStorage.clearNotificationIds(taskId);
  }

  /// Re-schedules reminders for all [tasks]. Called on app open, because an
  /// alarm the OS dropped (app updated, storage cleared, permission granted
  /// after the fact) is only noticed by rebuilding the whole set.
  Future<void> rescheduleAll(List<Task> tasks) async {
    if (!_initialized) return;
    debugLog(
      'NotificationService.rescheduleAll: ${tasks.length} task(s)',
      name: 'NotificationService',
    );
    for (final task in tasks) {
      await scheduleForTask(task);
    }
  }

  /// Cancels everything Kairos has scheduled — used when the reminders switch
  /// is turned off.
  ///
  /// Only ids we know are ours, rather than the plugin's `cancelAll()`, which
  /// would also drop notifications posted by anything else in the app.
  Future<void> cancelAll() async {
    debugLog(
      'NotificationService.cancelAll called',
      name: 'NotificationService',
    );
    for (final id in await _localStorage.loadAllNotificationIds()) {
      await _cancel(id);
    }
    await _localStorage.clearAllNotificationIds();
  }

  Future<void> _cancel(int id) async {
    if (!_available) return;
    try {
      await _plugin.cancel(id);
    } catch (_) {
      // Cancelling something the OS already forgot is not an error.
    }
  }

  NotificationDetails _details() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        AppConstants.reminderChannelId,
        AppConstants.reminderChannelName,
        channelDescription: AppConstants.reminderChannelDescription,
        importance: Importance.high,
        priority: Priority.high,
        category: AndroidNotificationCategory.reminder,
        // The task title is already the notification title; keep the body off
        // a locked screen, where a shoulder-surfer would read it for free.
        visibility: NotificationVisibility.private,
      ),
    );
  }

  /// "Due in 15 min" / "Due now", derived from the reminder's own offset.
  ///
  /// Deliberately not localized: this string is produced when the alarm is
  /// *scheduled*, which can be weeks before it is shown, and the plugin stores
  /// it verbatim. Localizing it here would freeze whatever language was active
  /// at save time, which is worse than a consistent English body — the task
  /// title next to it is the user's own text.
  String _bodyFor(int minutesBefore) {
    if (minutesBefore <= 0) return 'Due now';
    if (minutesBefore < 60) return 'Due in $minutesBefore min';
    if (minutesBefore % 1440 == 0) {
      final days = minutesBefore ~/ 1440;
      return days == 1 ? 'Due tomorrow' : 'Due in $days days';
    }
    if (minutesBefore % 60 == 0) {
      final hours = minutesBefore ~/ 60;
      return hours == 1 ? 'Due in 1 hour' : 'Due in $hours hours';
    }
    return 'Due in $minutesBefore min';
  }
}
