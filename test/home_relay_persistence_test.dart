import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:kairos/models/sync_config_model.dart';
import 'package:kairos/services/local_storage_service.dart';
import 'package:kairos/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Regression tests for the home relay round-trip.
///
/// The relay sanitization logic used to be copied into three places and two
/// of the copies omitted `allowInsecureLocal`, so the persistence layer threw
/// away exactly the addresses the home-relay slot exists for: a `ws://` LAN
/// relay, or any relay on a private IP. The UI kept showing it (the provider
/// held the accepted value in memory) and it vanished on restart.
///
/// Every case here goes through the real save → load cycle, not just the
/// normalizer, because the bug lived in the gap between the two.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  Future<SyncConfig> roundTrip(SyncConfig config) async {
    final storage = LocalStorageService();
    await storage.saveSyncConfig(config);
    return storage.loadSyncConfig();
  }

  group('a home relay survives save and reload', () {
    const cases = <String, String>{
      'plaintext LAN relay': 'ws://192.168.1.10:7777',
      'TLS relay on a private IP': 'wss://192.168.1.10:7777',
      'plaintext loopback relay': 'ws://127.0.0.1:4869',
      'mDNS hostname': 'ws://pi.local:7777',
      'ordinary public relay': 'wss://home.example',
    };

    cases.forEach((name, url) {
      test(name, () async {
        final config = await roundTrip(SyncConfig(homeRelayUrl: url));
        expect(config.homeRelayUrl, url);
        expect(config.allSyncRelays, contains(url));
      });
    });
  });

  test(
    'a home relay read back from tampered preferences is preserved',
    () async {
      SharedPreferences.setMockInitialValues({
        AppConstants.prefsHomeRelayKey: 'ws://192.168.1.10:7777',
      });
      final config = await LocalStorageService().loadSyncConfig();
      expect(config.homeRelayUrl, 'ws://192.168.1.10:7777');
    },
  );

  test('clearing the home relay removes it from storage', () async {
    final storage = LocalStorageService();
    await storage.saveSyncConfig(
      const SyncConfig(homeRelayUrl: 'ws://192.168.1.10:7777'),
    );
    await storage.saveSyncConfig(const SyncConfig());

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString(AppConstants.prefsHomeRelayKey), isNull);
    expect((await storage.loadSyncConfig()).homeRelayUrl, isNull);
  });

  test(
    'the relay list keeps LAN relays and refuses public plaintext',
    () async {
      final config = await roundTrip(
        const SyncConfig(
          relays: [
            'ws://insecure.example', // plaintext to a public host: refused
            'wss://192.168.1.10', // self-hosted relay over TLS: kept
            'ws://192.168.1.11', // self-hosted relay on the LAN: kept
            'wss://good.example',
          ],
        ),
      );
      expect(config.relays, [
        'wss://192.168.1.10',
        'ws://192.168.1.11',
        'wss://good.example',
      ]);
    },
  );

  test('a malformed home relay is dropped rather than stored', () async {
    final config = await roundTrip(
      const SyncConfig(homeRelayUrl: 'http://192.168.1.10'),
    );
    expect(config.homeRelayUrl, isNull);
  });

  group('the connection cap holds through the round trip', () {
    test('home relay counts against the total', () async {
      final config = await roundTrip(
        SyncConfig(
          relays: [for (var i = 0; i < 30; i++) 'wss://relay$i.example'],
          homeRelayUrl: 'ws://192.168.1.10:7777',
        ),
      );
      expect(config.relays, hasLength(AppConstants.maxRelayConnections - 1));
      expect(config.allSyncRelays, hasLength(AppConstants.maxRelayConnections));
    });

    test('tampered preferences cannot amplify the fan-out', () async {
      SharedPreferences.setMockInitialValues({
        AppConstants.prefsRelaysKey: jsonEncode([
          for (var i = 0; i < 500; i++) 'wss://relay$i.example',
        ]),
        AppConstants.prefsHomeRelayKey: 'ws://192.168.1.10:7777',
      });
      final config = await LocalStorageService().loadSyncConfig();
      expect(config.allSyncRelays, hasLength(AppConstants.maxRelayConnections));
    });
  });

  group('SyncConfig.sanitized is the single normalization', () {
    test('deduplicates the home relay out of the public list', () {
      final config = SyncConfig.sanitized(
        relays: ['wss://a.example', 'wss://home.example', 'wss://a.example/'],
        homeRelayUrl: 'wss://home.example',
      );
      expect(config.relays, ['wss://a.example']);
      expect(config.homeRelayUrl, 'wss://home.example');
      expect(config.allSyncRelays, hasLength(2));
    });

    test('is idempotent', () {
      final once = SyncConfig.sanitized(
        relays: ['wss://a.example', 'ws://bad.example'],
        homeRelayUrl: 'ws://192.168.1.10',
      );
      final twice = once.sanitized();
      expect(twice.relays, once.relays);
      expect(twice.homeRelayUrl, once.homeRelayUrl);
    });
  });
}
