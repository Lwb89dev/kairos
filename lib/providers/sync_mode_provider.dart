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
        : normalizeSecureRelayUrl(url);
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

  Future<void> save(SyncConfig config) => _save((_) => config);

  /// Applies [update] to the current configuration, persists the sanitized
  /// result and publishes it. A relay the user just added has to receive the
  /// tasks it missed, so every existing revision is marked pending.
  Future<void> _save(SyncConfig Function(SyncConfig) update) async {
    final storage = ref.read(localStorageServiceProvider);
    final current = state.value ?? await storage.loadSyncConfig();
    final next = update(current).sanitized();
    await storage.saveSyncConfig(next);

    // Deselecting a relay has to actually close its socket. This is the only
    // place that knows the user changed the selection, and the transport
    // layer's registry never drops anything on its own.
    await ref
        .read(nostrServiceProvider)
        .dropDeselectedRelays(next.allSyncRelays.toSet());

    final addedRelay = next.allSyncRelays.any(
      (relay) => !current.allSyncRelays.contains(relay),
    );
    if (addedRelay) {
      await ref.read(taskLocalStorageServiceProvider).markAllUnsynced();
    }
    state = AsyncData(next);
  }
}

final syncConfigProvider =
    AsyncNotifierProvider<SyncConfigNotifier, SyncConfig>(
      SyncConfigNotifier.new,
    );
