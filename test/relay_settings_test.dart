import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:kairos/models/sync_config_model.dart';
import 'package:kairos/services/local_storage_service.dart';
import 'package:kairos/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('fresh install starts without silently selected relays', () async {
    final config = await LocalStorageService().loadSyncConfig();
    expect(config.relays, isEmpty);
  });

  test('upgrade preserves the historical implicit relay selection', () async {
    SharedPreferences.setMockInitialValues({
      AppConstants.prefsEnteredKey: true,
    });
    final config = await LocalStorageService().loadSyncConfig();
    expect(config.relays, AppConstants.defaultRelays);
  });

  test('explicit empty choice remains empty after onboarding', () async {
    SharedPreferences.setMockInitialValues({
      AppConstants.prefsEnteredKey: true,
      AppConstants.prefsRelaysKey: jsonEncode(<String>[]),
    });
    final config = await LocalStorageService().loadSyncConfig();
    expect(config.relays, isEmpty);
  });

  test('stored insecure or malformed relay URLs are discarded', () async {
    SharedPreferences.setMockInitialValues({
      AppConstants.prefsRelaysKey: jsonEncode([
        'ws://insecure.example',
        'not a URL',
        'WSS://NOS.LOL',
      ]),
    });
    final config = await LocalStorageService().loadSyncConfig();
    expect(config.relays, ['wss://nos.lol']);
  });

  test('tampered preferences cannot amplify relay connections', () async {
    SharedPreferences.setMockInitialValues({
      AppConstants.prefsRelaysKey: jsonEncode([
        for (var index = 0; index < 30; index++) 'wss://relay$index.example',
      ]),
      AppConstants.prefsHomeRelayKey: 'wss://home.example',
    });
    final config = await LocalStorageService().loadSyncConfig();
    expect(config.allSyncRelays, hasLength(AppConstants.maxRelayConnections));
    expect(config.homeRelayUrl, 'wss://home.example');
  });

  test('saving configuration drops malformed and excess endpoints', () async {
    final storage = LocalStorageService();
    await storage.saveSyncConfig(
      SyncConfig(
        relays: [
          'ws://insecure.example',
          for (var index = 0; index < 30; index++) 'wss://relay$index.example',
        ],
      ),
    );
    final config = await storage.loadSyncConfig();
    expect(config.relays, hasLength(AppConstants.maxRelayConnections));
    expect(config.relays, isNot(contains('ws://insecure.example')));
  });
}
