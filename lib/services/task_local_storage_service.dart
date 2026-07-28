import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../models/task_model.dart';
import '../utils/constants.dart';
import '../utils/logger.dart';
import '../utils/nostr_timestamp.dart';
import 'local_storage_service.dart';

/// Hive persistence for tasks. Offline-first: every task write goes through
/// here *before* being handed to the Nostr sync layer — the user must never
/// lose a task just because there is no network connection.
///
/// Tasks are stored as JSON Maps via manual toJson/fromJson (no codegen —
/// same constraint as Echoes/Astraea: hive_generator conflicts with the
/// analyzer versions dart_nostr/riverpod pull in).
class TaskLocalStorageService {
  TaskLocalStorageService(this._localStorage);

  final LocalStorageService _localStorage;
  Box<Map>? _tasksBox;

  /// Must be called once at app startup, before any task read/write —
  /// in `main()` right after `WidgetsFlutterBinding.ensureInitialized()`.
  Future<void> init() async {
    SyncLog.storage('TaskLocalStorageService.init');
    await Hive.initFlutter();
    final key = await _loadOrCreateEncryptionKey();
    final encrypted = await Hive.openBox<Map>(
      AppConstants.tasksBoxName,
      encryptionCipher: HiveAesCipher(key),
    );
    await _migrateLegacyPlaintextBox(encrypted);
    _tasksBox = encrypted;
  }

  Future<List<int>> _loadOrCreateEncryptionKey() async {
    final stored = await _localStorage.loadTaskDatabaseKey();
    if (stored != null) {
      try {
        final decoded = base64Url.decode(stored);
        if (decoded.length == 32) return decoded;
      } catch (_) {
        // Fail closed below: replacing a malformed key would strand data.
      }
      throw StateError('The local task database encryption key is invalid.');
    }
    final generated = Hive.generateSecureKey();
    await _localStorage.saveTaskDatabaseKey(base64UrlEncode(generated));
    return generated;
  }

  /// Copies the original unencrypted legacy box into the encrypted Kairos
  /// box, verifies every key, then removes the plaintext copy. A failed copy
  /// leaves the legacy box intact so no user data is lost.
  Future<void> _migrateLegacyPlaintextBox(Box<Map> encrypted) async {
    if (!await Hive.boxExists(AppConstants.legacyTasksBoxName)) return;
    final legacy = await Hive.openBox<Map>(AppConstants.legacyTasksBoxName);
    try {
      for (final key in legacy.keys) {
        await _copyLegacyEntry(legacy, encrypted, key);
      }
      await encrypted.flush();
      final fullyCopied = legacy.keys.every(encrypted.containsKey);
      if (!fullyCopied) {
        throw StateError('Could not verify the encrypted task migration.');
      }
    } finally {
      await legacy.close();
    }
    await Hive.deleteBoxFromDisk(AppConstants.legacyTasksBoxName);
  }

  Future<void> _copyLegacyEntry(
    Box<Map> legacy,
    Box<Map> encrypted,
    dynamic key,
  ) async {
    if (encrypted.containsKey(key)) return;
    final value = legacy.get(key);
    if (value == null) return;
    await encrypted.put(key, value);
  }

  Box<Map> get _requireTasksBox {
    final box = _tasksBox;
    if (box == null) {
      throw StateError(
        'TaskLocalStorageService.init() has not been called yet.',
      );
    }
    return box;
  }

  /// Returns all cached tasks (including local deletion tombstones, so the
  /// sync layer can reconcile them). Callers that render the task list
  /// should filter out `deleted` tasks. Sorted: due-dated tasks first by due
  /// date, then the rest by creation time (newest first).
  Future<List<Task>> loadTasks() async {
    SyncLog.storage('TaskLocalStorageService.loadTasks');
    final box = _requireTasksBox;
    final tasks = <Task>[];
    for (final stored in box.values) {
      try {
        tasks.add(Task.fromJson(_asStringKeyedMap(stored)));
      } catch (_) {
        // One damaged entry must not make the rest of the local task list
        // unavailable. Leave it in the box for possible manual recovery.
        SyncLog.warn('STORAGE', 'Skipped one invalid task record');
      }
    }
    tasks.sort((a, b) {
      final aDue = a.dueDateUtc;
      final bDue = b.dueDateUtc;
      if (aDue != null && bDue != null) return aDue.compareTo(bDue);
      if (aDue != null) return -1;
      if (bDue != null) return 1;
      return b.createdAt.compareTo(a.createdAt);
    });
    return tasks;
  }

  /// Creates or updates a task in the local cache. Idempotent on [Task.id].
  Future<void> saveTask(Task task) async {
    SyncLog.storage('TaskLocalStorageService.saveTask: ${task.id}');
    await _requireTasksBox.put(task.id, task.toJson());
  }

  Task? getTask(String taskId) {
    final stored = _requireTasksBox.get(taskId);
    if (stored == null) return null;
    try {
      return Task.fromJson(_asStringKeyedMap(stored));
    } catch (_) {
      return null;
    }
  }

  /// Marks [published] synchronized only if it is still the current local
  /// revision. Network acknowledgements may arrive after a newer edit; blindly
  /// saving the old object here would otherwise roll that edit back.
  Future<bool> markSyncedIfCurrent(
    Task published, {
    required String eventId,
    required String ownerPubkey,
    bool clearDeletionRequestPending = false,
  }) async {
    final current = getTask(published.id);
    if (current == null || current.updatedAt != published.updatedAt) {
      return false;
    }
    await _requireTasksBox.put(
      current.id,
      current
          .copyWith(
            synced: true,
            nostrEventId: eventId,
            syncOwnerPubkey: ownerPubkey,
            clearDeletionRequestPending: clearDeletionRequestPending,
          )
          .toJson(),
    );
    return true;
  }

  /// Records the id of the calendar event currently mirroring [taskId], or
  /// clears it with a null [calendarEventId] once the mirror is retracted.
  /// The revision guard prevents a slow publication from overwriting the
  /// bookkeeping of a newer task edit.
  ///
  /// Deliberately does *not* bump `updatedAt` or clear `synced`: which
  /// calendar event a task is mirrored by is device-local bookkeeping, not a
  /// task revision. Treating it as one would republish the task to the relays
  /// every time its mirror was refreshed, in an endless loop.
  Future<bool> updateCalendarMirror(
    String taskId, {
    required DateTime expectedUpdatedAt,
    required String? calendarEventId,
  }) async {
    final current = getTask(taskId);
    if (current == null) return false;
    if (current.updatedAt != expectedUpdatedAt) return false;
    if (current.calendarNostrEventId == calendarEventId &&
        !current.calendarMirrorRetractionPending) {
      return false;
    }
    await _requireTasksBox.put(
      taskId,
      current
          .copyWith(
            calendarNostrEventId: calendarEventId,
            clearCalendarNostrEventId: calendarEventId == null,
            calendarMirrorRetractionPending: false,
          )
          .toJson(),
    );
    return true;
  }

  /// A newly added relay must receive existing tasks too. Revisions are
  /// marked pending locally; publication remains user/foreground driven.
  Future<void> markAllUnsynced() async {
    final box = _requireTasksBox;
    for (final key in box.keys.toList(growable: false)) {
      final task = getTask(key.toString());
      if (task != null) {
        await box.put(
          key,
          task
              .copyWith(
                synced: false,
                updatedAt: nextNostrTimestamp(task.updatedAt),
              )
              .toJson(),
        );
      }
    }
  }

  /// Hive deserializes nested maps as `Map<dynamic, dynamic>`; normalize to
  /// the `Map<String, dynamic>` our fromJson factories expect.
  Map<String, dynamic> _asStringKeyedMap(Map<dynamic, dynamic> raw) {
    return raw.map((key, value) => MapEntry(key.toString(), value));
  }
}
