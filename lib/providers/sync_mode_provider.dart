import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/sync_config_model.dart';
import '../utils/constants.dart';
import '../utils/logger.dart';
import '../utils/relay_url.dart';
import 'service_providers.dart';

/// Explicit relay configuration persisted in SharedPreferences.
class SyncConfigNotifier extends AsyncNotifier<SyncConfig> {
  @override
  Future<SyncConfig> build() async {
    debugLog('SyncConfigNotifier.build called', name: 'SyncConfigNotifier');
    return ref.read(localStorageServiceProvider).loadSyncConfig();
  }

  Future<void> addRelay(String url) async {
    final trimmed = normalizeSecureRelayUrl(url);
    if (trimmed == null) return;
    await _save((c) {
      if (c.relays.contains(trimmed)) return c;
      if (c.allSyncRelays.length >= AppConstants.maxRelayConnections) {
        return c;
      }
      return c.copyWith(relays: [...c.relays, trimmed]);
    });
  }

  Future<void> removeRelay(String url) async {
    await _save(
      (c) => c.copyWith(relays: c.relays.where((r) => r != url).toList()),
    );
  }

  /// Sets (or clears, with null/empty) the personal/home relay used as an
  /// additional publish target.
  Future<void> setHomeRelay(String? url) async {
    final trimmed = url == null || url.trim().isEmpty
        ? null
        : normalizeSecureRelayUrl(url, allowInsecureLocal: true);
    if (url != null && url.trim().isNotEmpty && trimmed == null) return;
    await _save((c) {
      if (trimmed == null || trimmed.isEmpty) {
        return c.copyWith(clearHomeRelay: true);
      }
      if (!c.allSyncRelays.contains(trimmed) &&
          c.allSyncRelays.length >= AppConstants.maxRelayConnections) {
        return c;
      }
      return c.copyWith(homeRelayUrl: trimmed);
    });
  }

  Future<void> save(SyncConfig config) async {
    final safe = _sanitize(config);
    final current =
        state.value ??
        await ref.read(localStorageServiceProvider).loadSyncConfig();
    await ref.read(localStorageServiceProvider).saveSyncConfig(safe);
    final addedRelay = safe.allSyncRelays.any(
      (relay) => !current.allSyncRelays.contains(relay),
    );
    if (addedRelay) {
      await ref.read(taskLocalStorageServiceProvider).markAllUnsynced();
    }
    state = AsyncData(safe);
  }

  Future<void> _save(SyncConfig Function(SyncConfig) update) async {
    final current =
        state.value ??
        await ref.read(localStorageServiceProvider).loadSyncConfig();
    final next = update(current);
    await ref.read(localStorageServiceProvider).saveSyncConfig(next);
    final addedRelay = next.allSyncRelays.any(
      (relay) => !current.allSyncRelays.contains(relay),
    );
    if (addedRelay) {
      await ref.read(taskLocalStorageServiceProvider).markAllUnsynced();
    }
    state = AsyncData(next);
  }

  SyncConfig _sanitize(SyncConfig config) {
    final home = normalizeSecureRelayUrl(
      config.homeRelayUrl ?? '',
      allowInsecureLocal: true,
    );
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
    return SyncConfig(relays: relays, homeRelayUrl: home);
  }
}

final syncConfigProvider =
    AsyncNotifierProvider<SyncConfigNotifier, SyncConfig>(
      SyncConfigNotifier.new,
    );
