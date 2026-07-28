import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/sync_config_model.dart';
import '../models/user_model.dart';
import '../utils/constants.dart';
import '../utils/logger.dart';

/// Session + settings persistence: secret material lives in
/// flutter_secure_storage, everything non-sensitive (pubkey, login method,
/// relay list, entered flag) in SharedPreferences.
///
/// Task persistence is deliberately NOT here — see
/// [TaskLocalStorageService], which owns the Hive box.
class LocalStorageService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  // ---------------------------------------------------------------------
  // Account private key (flutter_secure_storage — NEVER plaintext prefs).
  // ---------------------------------------------------------------------

  Future<void> savePrivateKey(String privateKeyHex) async {
    debugLog(
      'LocalStorageService.savePrivateKey called',
      name: 'LocalStorageService',
    );
    await _secureStorage.write(
      key: AppConstants.secureStoragePrivateKeyKey,
      value: privateKeyHex,
    );
  }

  Future<String?> loadPrivateKey() async {
    debugLog(
      'LocalStorageService.loadPrivateKey called',
      name: 'LocalStorageService',
    );
    return _secureStorage.read(key: AppConstants.secureStoragePrivateKeyKey);
  }

  Future<void> clearPrivateKey() async {
    debugLog(
      'LocalStorageService.clearPrivateKey called',
      name: 'LocalStorageService',
    );
    await _secureStorage.delete(key: AppConstants.secureStoragePrivateKeyKey);
  }

  /// Clears the whole local session (private key + pubkey + login method).
  Future<void> clearSession() async {
    debugLog(
      'LocalStorageService.clearSession called',
      name: 'LocalStorageService',
    );
    await clearPrivateKey();
    final prefs = await _prefs;
    await prefs.remove(AppConstants.prefsPublicKeyKey);
    await prefs.remove(AppConstants.prefsLoginMethodKey);
    await prefs.remove(AppConstants.prefsProfileCacheKey);
  }

  // ---------------------------------------------------------------------
  // Local task database key (secure storage, never SharedPreferences).
  // ---------------------------------------------------------------------

  Future<String?> loadTaskDatabaseKey() {
    return _secureStorage.read(key: AppConstants.secureStorageTaskDatabaseKey);
  }

  Future<void> saveTaskDatabaseKey(String encodedKey) {
    return _secureStorage.write(
      key: AppConstants.secureStorageTaskDatabaseKey,
      value: encodedKey,
    );
  }

  // ---------------------------------------------------------------------
  // Public key + login method (SharedPreferences — the pubkey is public).
  // ---------------------------------------------------------------------

  Future<void> savePublicKey(String publicKeyHex) async {
    final prefs = await _prefs;
    await prefs.setString(AppConstants.prefsPublicKeyKey, publicKeyHex);
  }

  Future<String?> loadPublicKey() async {
    final prefs = await _prefs;
    return prefs.getString(AppConstants.prefsPublicKeyKey);
  }

  Future<void> saveLoginMethod(LoginMethod method) async {
    final prefs = await _prefs;
    await prefs.setString(AppConstants.prefsLoginMethodKey, method.name);
  }

  Future<LoginMethod?> loadLoginMethod() async {
    final prefs = await _prefs;
    final raw = prefs.getString(AppConstants.prefsLoginMethodKey);
    if (raw == null) return null;
    return LoginMethod.values.asNameMap()[raw];
  }

  // ---------------------------------------------------------------------
  // Entry flag: has the user passed the entry screen (signed in OR chosen
  // offline, local-only use)? Separate from the account: local-only mode is
  // "entered == true, no account". Same pattern as Astraea.
  // ---------------------------------------------------------------------

  Future<bool> hasEntered() async {
    final prefs = await _prefs;
    return prefs.getBool(AppConstants.prefsEnteredKey) ?? false;
  }

  Future<void> setEntered() async {
    debugLog(
      'LocalStorageService.setEntered called',
      name: 'LocalStorageService',
    );
    final prefs = await _prefs;
    await prefs.setBool(AppConstants.prefsEnteredKey, true);
  }

  // ---------------------------------------------------------------------
  // Reminders: the master switch, plus the bookkeeping that lets a task
  // cancel exactly the OS notifications it scheduled.
  // ---------------------------------------------------------------------

  /// Defaults to true: a user who sets a reminder expects it to fire without
  /// having to find a switch first. The OS-level notification permission is a
  /// separate, real gate on top of this.
  Future<bool> loadNotificationsEnabled() async {
    final prefs = await _prefs;
    return prefs.getBool(AppConstants.prefsNotificationsEnabledKey) ?? true;
  }

  Future<void> saveNotificationsEnabled(bool enabled) async {
    final prefs = await _prefs;
    await prefs.setBool(AppConstants.prefsNotificationsEnabledKey, enabled);
  }

  /// Reserves [count] fresh OS notification ids.
  ///
  /// A monotonic counter rather than a hash of the task id: two different
  /// tasks must never collide onto the same id (the second would silently
  /// replace the first's alarm), and one task needs several distinct ids when
  /// it has several reminders. Wraps well below the 32-bit ceiling Android
  /// requires.
  Future<List<int>> allocateNotificationIds(int count) async {
    if (count <= 0) return const [];
    final prefs = await _prefs;
    final start = prefs.getInt(AppConstants.prefsNotificationSeqKey) ?? 1;
    final ids = [for (var i = 0; i < count; i++) _wrapId(start + i)];
    await prefs.setInt(AppConstants.prefsNotificationSeqKey, start + count);
    return ids;
  }

  static int _wrapId(int value) => value % 0x7FFFFFFF;

  Future<void> saveNotificationIds(String taskId, List<int> ids) async {
    final map = await _loadNotificationIdMap();
    if (ids.isEmpty) {
      map.remove(taskId);
    } else {
      map[taskId] = ids;
    }
    await _saveNotificationIdMap(map);
  }

  Future<List<int>> loadNotificationIds(String taskId) async {
    final map = await _loadNotificationIdMap();
    return map[taskId] ?? const [];
  }

  Future<List<int>> loadAllNotificationIds() async {
    final map = await _loadNotificationIdMap();
    return [for (final ids in map.values) ...ids];
  }

  Future<void> clearNotificationIds(String taskId) async {
    final map = await _loadNotificationIdMap();
    if (map.remove(taskId) != null) await _saveNotificationIdMap(map);
  }

  Future<void> clearAllNotificationIds() async {
    final prefs = await _prefs;
    await prefs.remove(AppConstants.prefsNotificationIdsKey);
  }

  Future<Map<String, List<int>>> _loadNotificationIdMap() async {
    final prefs = await _prefs;
    final raw = prefs.getString(AppConstants.prefsNotificationIdsKey);
    if (raw == null) return {};
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return {};
      return {
        for (final entry in decoded.entries)
          if (entry.value is List)
            entry.key.toString(): (entry.value as List)
                .whereType<int>()
                .toList(),
      };
    } catch (_) {
      // Corrupt bookkeeping would otherwise strand alarms we can no longer
      // name. Starting over is recoverable: rescheduleAll rebuilds it.
      return {};
    }
  }

  Future<void> _saveNotificationIdMap(Map<String, List<int>> map) async {
    final prefs = await _prefs;
    await prefs.setString(
      AppConstants.prefsNotificationIdsKey,
      jsonEncode(map),
    );
  }

  // ---------------------------------------------------------------------
  // Sync configuration (explicit relay list + optional home relay).
  // ---------------------------------------------------------------------

  Future<SyncConfig> loadSyncConfig() async {
    debugLog(
      'LocalStorageService.loadSyncConfig called',
      name: 'LocalStorageService',
    );
    final prefs = await _prefs;
    final rawRelays = prefs.getString(AppConstants.prefsRelaysKey);
    final hasCompletedOnboarding =
        prefs.getBool(AppConstants.prefsEnteredKey) ?? false;
    final storedRelays = rawRelays == null
        // Preserve historical implicit defaults for upgrades, while a fresh
        // install begins with no network endpoints selected.
        ? (hasCompletedOnboarding
              ? AppConstants.defaultRelays
              : const <String>[])
        : _decodeRelayList(rawRelays);
    return SyncConfig.sanitized(
      relays: storedRelays,
      homeRelayUrl: prefs.getString(AppConstants.prefsHomeRelayKey),
    );
  }

  Future<void> saveSyncConfig(SyncConfig config) async {
    debugLog(
      'LocalStorageService.saveSyncConfig called',
      name: 'LocalStorageService',
    );
    final prefs = await _prefs;
    final safe = config.sanitized();
    final home = safe.homeRelayUrl;
    await prefs.setString(AppConstants.prefsRelaysKey, jsonEncode(safe.relays));
    if (home == null || home.isEmpty) {
      await prefs.remove(AppConstants.prefsHomeRelayKey);
    } else {
      await prefs.setString(AppConstants.prefsHomeRelayKey, home);
    }
  }

  /// Decodes the stored JSON array. Per-entry validation and the connection
  /// cap are applied afterwards by [SyncConfig.sanitized], so this only has
  /// to survive arbitrary tampered JSON.
  List<String> _decodeRelayList(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return const [];
      return decoded.whereType<String>().toList(growable: false);
    } catch (_) {
      return const [];
    }
  }
}
