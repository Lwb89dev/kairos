import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/sync_config_model.dart';
import '../models/user_model.dart';
import '../utils/constants.dart';
import '../utils/logger.dart';
import '../utils/relay_url.dart';

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
    final home = normalizeSecureRelayUrl(
      prefs.getString(AppConstants.prefsHomeRelayKey) ?? '',
    );
    final relayLimit = home == null
        ? AppConstants.maxRelayConnections
        : AppConstants.maxRelayConnections - 1;
    final relays = storedRelays
        .where((relay) => relay != home)
        .take(relayLimit)
        .toList(growable: false);
    return SyncConfig(relays: relays, homeRelayUrl: home);
  }

  Future<void> saveSyncConfig(SyncConfig config) async {
    debugLog(
      'LocalStorageService.saveSyncConfig called',
      name: 'LocalStorageService',
    );
    final prefs = await _prefs;
    final home = normalizeSecureRelayUrl(config.homeRelayUrl ?? '');
    final relayLimit = home == null
        ? AppConstants.maxRelayConnections
        : AppConstants.maxRelayConnections - 1;
    final relays = config.relays
        .map(normalizeSecureRelayUrl)
        .whereType<String>()
        .where((relay) => relay != home)
        .toSet()
        .take(relayLimit)
        .toList(growable: false);
    await prefs.setString(AppConstants.prefsRelaysKey, jsonEncode(relays));
    if (home == null || home.isEmpty) {
      await prefs.remove(AppConstants.prefsHomeRelayKey);
    } else {
      await prefs.setString(AppConstants.prefsHomeRelayKey, home);
    }
  }

  List<String> _decodeRelayList(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return const [];
      return decoded
          .whereType<String>()
          .map(normalizeSecureRelayUrl)
          .whereType<String>()
          .toSet()
          .take(AppConstants.maxRelayConnections)
          .toList(growable: false);
    } catch (_) {
      return const [];
    }
  }
}
