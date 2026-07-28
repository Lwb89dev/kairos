import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../models/reminder_model.dart';
import '../models/task_model.dart';
import '../models/sync_config_model.dart';
import '../models/user_model.dart';
import '../utils/nostr_timestamp.dart';
import '../utils/task_colors.dart';
import '../utils/logger.dart';
import 'auth_provider.dart';
import 'service_providers.dart';
import 'sync_mode_provider.dart';

/// True while [TasksNotifier.syncNow] has a relay round-trip in flight —
/// drives the progress indicator on the home screen so the on-entry sync is
/// visible to the user instead of silent.
class SyncActivityNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void set(bool syncing) => state = syncing;
}

final syncActivityProvider = NotifierProvider<SyncActivityNotifier, bool>(
  SyncActivityNotifier.new,
);

/// The source-of-truth list of the user's tasks (local tombstones excluded
/// from the exposed state). Offline-first: every mutation writes to Hive
/// first, then best-effort publishes to explicitly selected Nostr relays.
class TasksNotifier extends AsyncNotifier<List<Task>> {
  static const _uuid = Uuid();
  Future<void>? _syncInFlight;
  DateTime? _lastAutomaticSync;

  @override
  Future<List<Task>> build() async {
    debugLog('TasksNotifier.build called', name: 'TasksNotifier');
    final tasks = await ref.read(taskLocalStorageServiceProvider).loadTasks();
    return tasks.where((t) => !t.deleted).toList();
  }

  /// Creates a new task from the editor form and syncs it out — unless
  /// [localOnly] is set, in which case the task is pinned to this device and
  /// the sync layer never touches it (see [Task.localOnly]).
  Future<Task> createTask({
    required String title,
    String? description,
    DateTime? dueDateUtc,
    List<String> tags = const [],
    int? priority,
    TaskColor? color,
    String? linkedEventId,
    bool localOnly = false,
    List<Reminder> reminders = const [],
    bool mirrorToCalendar = false,
  }) async {
    final normalizedTitle = title.trim();
    if (normalizedTitle.isEmpty ||
        normalizedTitle.length > Task.maxTitleLength) {
      throw ArgumentError('Task title is invalid.');
    }
    final normalizedDescription = description?.trim();
    if (normalizedDescription != null &&
        normalizedDescription.length > Task.maxDescriptionLength) {
      throw ArgumentError('Task description is too long.');
    }
    if (tags.length > Task.maxTags ||
        tags.any((tag) => tag.trim().length > Task.maxTagLength)) {
      throw ArgumentError('Task tags are invalid.');
    }
    if (priority != null && (priority < 1 || priority > 5)) {
      throw ArgumentError('Task priority is invalid.');
    }
    if (linkedEventId != null && linkedEventId.trim().length > 128) {
      throw ArgumentError('Linked event id is too long.');
    }
    if (reminders.length > Reminder.maxPerTask) {
      throw ArgumentError('Too many reminders.');
    }
    final now = DateTime.now().toUtc();
    final task = Task(
      id: _uuid.v4(),
      title: normalizedTitle,
      description: (normalizedDescription?.isEmpty ?? true)
          ? null
          : normalizedDescription,
      dueDateUtc: dueDateUtc,
      tags: tags,
      priority: priority,
      color: color,
      linkedEventId: linkedEventId,
      createdAt: now,
      updatedAt: now,
      localOnly: localOnly,
      // Both are meaningless without a deadline to count back from, and the
      // Task constructor is const so it cannot enforce that itself.
      reminders: dueDateUtc == null ? const [] : reminders,
      mirrorToCalendar: dueDateUtc != null && mirrorToCalendar,
    );
    debugLog('TasksNotifier.createTask called', name: 'TasksNotifier');
    await ref.read(taskLocalStorageServiceProvider).saveTask(task);
    await ref.read(notificationServiceProvider).scheduleForTask(task);
    await _refresh();
    unawaited(_publishAndRefresh(task));
    return task;
  }

  /// Updates an existing task (editor save): local save → re-sync.
  Future<void> upsert(Task task) async {
    debugLog('TasksNotifier.upsert called', name: 'TasksNotifier');
    final current = ref.read(taskLocalStorageServiceProvider).getTask(task.id);
    final previousTimestamp =
        current != null && current.updatedAt.isAfter(task.updatedAt)
        ? current.updatedAt
        : task.updatedAt;
    final stamped = task.copyWith(
      synced: false,
      syncOwnerPubkey: current?.syncOwnerPubkey,
      nostrEventId: current?.nostrEventId,
      calendarMirrorRetractionPending:
          current?.calendarMirrorRetractionPending == true ||
          (current?.mirrorToCalendar == true && !task.mirrorToCalendar),
      updatedAt: nextNostrTimestamp(previousTimestamp),
    );
    await ref.read(taskLocalStorageServiceProvider).saveTask(stamped);
    // Re-scheduled on every save: the due date, the reminder list or the
    // completion state may all have changed, and scheduleForTask cancels
    // whatever this task had before, so a stale alarm can never survive.
    await ref.read(notificationServiceProvider).scheduleForTask(stamped);
    await _refresh();
    unawaited(_publishAndRefresh(stamped));
  }

  /// Applies fields controlled by the editor while preserving changes that
  /// can happen concurrently elsewhere (checkbox state, sync ownership and
  /// deletion). In particular, a stale open editor must never resurrect a
  /// task that another device deleted.
  ///
  /// [enableSync] is the editor's "Sync task" action for a task that was
  /// created local-only: it clears [Task.localOnly] so this save (and every
  /// future revision) publishes to the configured relays.
  Future<void> updateFromEditor(Task edited, {bool enableSync = false}) async {
    final current = ref
        .read(taskLocalStorageServiceProvider)
        .getTask(edited.id);
    if (current == null || current.deleted) {
      throw StateError('Task no longer exists.');
    }
    await upsert(
      edited.copyWith(
        status: current.status,
        linkedEventId: current.linkedEventId,
        clearLinkedEvent: current.linkedEventId == null,
        syncOwnerPubkey: current.syncOwnerPubkey,
        nostrEventId: current.nostrEventId,
        deleted: current.deleted,
        deletionRequestPending: current.deletionRequestPending,
        localOnly: enableSync ? false : current.localOnly,
        calendarNostrEventId: current.calendarNostrEventId,
        calendarMirrorRetractionPending:
            current.calendarMirrorRetractionPending,
      ),
    );
  }

  /// Inline checkbox: flips pending ↔ done and re-syncs (same `d` tag, so
  /// the relay just replaces the previous revision).
  Future<void> toggleStatus(Task task) async {
    final current =
        ref.read(taskLocalStorageServiceProvider).getTask(task.id) ?? task;
    if (current.deleted) return;
    final next = current.isDone ? TaskStatus.pending : TaskStatus.done;
    debugLog('TasksNotifier.toggleStatus called', name: 'TasksNotifier');
    await upsert(current.copyWith(status: next));
  }

  /// Deletes a task: writes a local tombstone, best-effort publishes the
  /// NIP-09 deletion without blocking the local mutation on the network.
  Future<void> delete(Task task) async {
    debugLog('TasksNotifier.delete called', name: 'TasksNotifier');
    final current =
        ref.read(taskLocalStorageServiceProvider).getTask(task.id) ?? task;
    final tombstone = current.copyWith(
      deleted: true,
      deletionRequestPending: true,
      synced: false,
      updatedAt: nextNostrTimestamp(current.updatedAt),
      calendarMirrorRetractionPending:
          current.calendarMirrorRetractionPending || current.mirrorToCalendar,
    );
    await ref.read(taskLocalStorageServiceProvider).saveTask(tombstone);
    // A deleted task must stop nagging immediately, whether or not the
    // deletion ever reaches a relay.
    await ref.read(notificationServiceProvider).cancelForTask(tombstone.id);
    await _refresh();

    final auth = ref.read(authProvider).value;
    final config = ref.read(syncConfigProvider).value;
    final owner = tombstone.syncOwnerPubkey;
    // A local-only task never reached the relays, so there is nothing to
    // retract there — publishing its tombstone would leak the task's
    // existence to relays the user explicitly kept it away from.
    if (!tombstone.localOnly &&
        config != null &&
        config.allSyncRelays.isNotEmpty &&
        auth != null &&
        (owner == null || owner == auth.publicKeyHex)) {
      unawaited(_deleteAndRefresh(tombstone, config, auth));
    }
  }

  /// Full manual/pull-to-refresh sync: reconcile with the relays (pull +
  /// merge + push pending), then reload. No-op without an account or with
  /// no selected relays.
  Future<void> syncNow({bool userInitiated = false}) {
    final existing = _syncInFlight;
    if (existing != null) return existing;
    final future = _runSync(userInitiated: userInitiated);
    _syncInFlight = future;
    return future.whenComplete(() => _syncInFlight = null);
  }

  Future<void> _runSync({required bool userInitiated}) async {
    debugLog('TasksNotifier.syncNow called', name: 'TasksNotifier');
    // Auth/config may still be resolving when this fires at app start —
    // await the futures instead of reading a not-yet-loaded value, or the
    // on-entry sync would silently no-op on a cold start.
    final auth = await ref.read(authProvider.future);
    final config = await ref.read(syncConfigProvider.future);
    // Amber may show one approval per decrypt. Never trigger those prompts
    // merely because the app resumed; an explicit sync gesture is required.
    if (auth == null ||
        config.allSyncRelays.isEmpty ||
        (auth.loginMethod == LoginMethod.amber && !userInitiated)) {
      await _refresh();
      return;
    }
    final now = DateTime.now();
    final lastAutomatic = _lastAutomaticSync;
    if (!userInitiated &&
        lastAutomatic != null &&
        now.difference(lastAutomatic) < const Duration(seconds: 30)) {
      return;
    }
    if (!userInitiated) _lastAutomaticSync = now;
    ref.read(syncActivityProvider.notifier).set(true);
    try {
      await ref
          .read(nostrTaskSyncServiceProvider)
          .runSyncCycle(config: config, author: auth);
    } catch (_) {
      debugLog('Sync cycle failed', name: 'TasksNotifier');
    } finally {
      ref.read(syncActivityProvider.notifier).set(false);
    }
    await _refresh();
    // Sync may have merged tasks from another device after the initial
    // startup reschedule. Rebuild OS alarms from the now-current store.
    await rescheduleReminders();
  }

  Future<void> _publishAndRefresh(Task task) async {
    if (task.localOnly) return;
    final config = ref.read(syncConfigProvider).value;
    final auth = ref.read(authProvider).value;
    if (config == null || auth == null || config.allSyncRelays.isEmpty) return;
    final owner = task.syncOwnerPubkey;
    if (owner != null && owner != auth.publicKeyHex) return;
    try {
      await ref
          .read(nostrTaskSyncServiceProvider)
          .publishTask(task, config: config, author: auth);
      await _refresh();
    } catch (_) {
      debugLog('Task publish failed', name: 'TasksNotifier');
    }
  }

  Future<void> _deleteAndRefresh(
    Task task,
    SyncConfig config,
    User auth,
  ) async {
    try {
      await ref
          .read(nostrTaskSyncServiceProvider)
          .deleteTask(task, config: config, author: auth);
      await _refresh();
    } catch (_) {
      debugLog('Task deletion publish failed', name: 'TasksNotifier');
    }
  }

  Future<void> _refresh() async {
    final tasks = await ref.read(taskLocalStorageServiceProvider).loadTasks();
    state = AsyncData(tasks.where((t) => !t.deleted).toList());
  }

  /// Rebuilds every pending reminder from the stored tasks.
  ///
  /// Called once when the task list first appears. Alarms are OS state and can
  /// disappear without the app being told — an app update, a "clear data", a
  /// notification permission granted after the fact, or a task that arrived
  /// from another device during a sync and has never been scheduled here.
  Future<void> rescheduleReminders() async {
    final tasks = await ref.read(taskLocalStorageServiceProvider).loadTasks();
    await ref.read(notificationServiceProvider).rescheduleAll(tasks);
  }
}

final tasksProvider = AsyncNotifierProvider<TasksNotifier, List<Task>>(
  TasksNotifier.new,
);

/// The reminders master switch.
///
/// Turning it off cancels every alarm Kairos has scheduled; turning it back on
/// rebuilds them from the stored tasks, so the individual reminders the user
/// set on each task survive the round trip untouched.
class NotificationsEnabledNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() {
    return ref.read(localStorageServiceProvider).loadNotificationsEnabled();
  }

  Future<void> set(bool enabled) async {
    await ref
        .read(localStorageServiceProvider)
        .saveNotificationsEnabled(enabled);
    state = AsyncData(enabled);

    final notifications = ref.read(notificationServiceProvider);
    if (!enabled) {
      await notifications.cancelAll();
      return;
    }
    final tasks = await ref.read(taskLocalStorageServiceProvider).loadTasks();
    await notifications.rescheduleAll(tasks);
  }
}

final notificationsEnabledProvider =
    AsyncNotifierProvider<NotificationsEnabledNotifier, bool>(
      NotificationsEnabledNotifier.new,
    );
