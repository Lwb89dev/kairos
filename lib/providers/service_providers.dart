import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/astraea_calendar_mirror.dart';
import '../services/file_cache_service.dart';
import '../services/local_storage_service.dart';
import '../services/nostr_service.dart';
import '../services/notification_service.dart';
import '../services/nostr_task_sync_service.dart';
import '../services/task_local_storage_service.dart';

/// Providers for the "infrastructure" services — each a singleton for the
/// app's lifetime. Kept separate from the state providers so those can
/// depend on services via `ref.read`/`ref.watch`, and tests can override
/// them with `overrideWith`. Same layout as Echoes/Astraea.

final fileCacheServiceProvider = Provider<FileCacheService>((ref) {
  return FileCacheService();
});

final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  return LocalStorageService();
});

final taskLocalStorageServiceProvider = Provider<TaskLocalStorageService>((
  ref,
) {
  return TaskLocalStorageService(ref.watch(localStorageServiceProvider));
});

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService(
    localStorageService: ref.watch(localStorageServiceProvider),
  );
});

final nostrServiceProvider = Provider<NostrService>((ref) {
  return NostrService();
});

final astraeaCalendarMirrorProvider = Provider<AstraeaCalendarMirror>((ref) {
  return AstraeaCalendarMirror(nostrService: ref.watch(nostrServiceProvider));
});

final nostrTaskSyncServiceProvider = Provider<NostrTaskSyncService>((ref) {
  return NostrTaskSyncService(
    taskStorage: ref.watch(taskLocalStorageServiceProvider),
    nostrService: ref.watch(nostrServiceProvider),
    calendarMirror: ref.watch(astraeaCalendarMirrorProvider),
  );
});
