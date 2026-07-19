import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kairos/l10n/app_localizations.dart';
import 'package:kairos/providers/locale_provider.dart';
import 'package:kairos/providers/service_providers.dart';
import 'package:kairos/screens/settings_screen.dart';
import 'package:kairos/services/local_storage_service.dart';
import 'package:kairos/services/task_local_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  Future<void> pumpSettings(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        // Adding a relay marks tasks unsynced via TaskLocalStorageService,
        // which normally requires the Hive box `main()` opens at startup.
        // This test only pumps SettingsScreen directly, so it swaps in a
        // no-op fake for that one write — everything else (locale, relay
        // validation, dialogs) runs through the real providers/services.
        overrides: [
          taskLocalStorageServiceProvider.overrideWithValue(
            _NoopTaskLocalStorageService(),
          ),
        ],
        child: const _TestApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('Settings shows Language and Support sections', (tester) async {
    await pumpSettings(tester);
    final list = find.byType(Scrollable).first;

    await tester.scrollUntilVisible(
      find.text('Language'),
      200,
      scrollable: list,
    );
    expect(find.text('Language'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Support'),
      200,
      scrollable: list,
    );
    expect(find.text('Support'), findsOneWidget);
    expect(find.text('Support Kairos'), findsOneWidget);
    expect(find.text('lwb89@blink.sv'), findsOneWidget);
  });

  testWidgets('switching language to Italian updates visible strings live', (
    tester,
  ) async {
    await pumpSettings(tester);
    expect(find.text('Settings'), findsOneWidget);

    // Drives the same localeProvider the Language dropdown writes to
    // (LocaleNotifier.setLocale) rather than the DropdownButton's popup
    // route directly — that route runs its own overlay animation that
    // fights pumpAndSettle in a widget test. This still exercises the real
    // rendering path: AppLocalizations.of(context) re-resolving on every
    // watcher when localeProvider's state changes.
    final container = ProviderScope.containerOf(
      tester.element(find.byType(SettingsScreen)),
    );
    await container.read(localeProvider.notifier).setLocale(const Locale('it'));
    await tester.pumpAndSettle();

    expect(find.text('Impostazioni'), findsOneWidget);
    expect(find.text('Settings'), findsNothing);

    final list = find.byType(Scrollable).first;
    await tester.scrollUntilVisible(find.text('Lingua'), 200, scrollable: list);
    expect(find.text('Lingua'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Sostieni Kairos'),
      200,
      scrollable: list,
    );
    expect(find.text('Supporto'), findsOneWidget);
    expect(find.text('Sostieni Kairos'), findsOneWidget);
  });

  testWidgets(
    'public relay field rejects ws:// but the home relay tile accepts it',
    (tester) async {
      await pumpSettings(tester);

      // Public relay slot: ws:// is rejected with an error snackbar.
      await tester.enterText(
        find.byType(TextField).first,
        'ws://insecure.example',
      );
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      expect(
        find.text('Enter a valid encrypted wss:// relay URL.'),
        findsOneWidget,
      );
      await tester.pumpAndSettle();

      // Home relay slot: ws:// on a LAN address is accepted.
      final list = find.byType(Scrollable).first;
      await tester.scrollUntilVisible(
        find.text('Personal home relay'),
        200,
        scrollable: list,
      );
      await tester.tap(find.text('Personal home relay'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byType(TextField).last,
        'ws://192.168.1.50:4848',
      );
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(find.text('ws://192.168.1.50:4848'), findsOneWidget);
      expect(
        find.text(
          "Enter a valid wss:// relay URL (ws:// is only allowed for a home relay on your own network).",
        ),
        findsNothing,
      );
    },
  );
}

class _NoopTaskLocalStorageService extends TaskLocalStorageService {
  _NoopTaskLocalStorageService() : super(LocalStorageService());

  @override
  Future<void> markAllUnsynced() async {}
}

/// Mirrors `KairosApp`'s locale wiring (main.dart) so `localeProvider`
/// changes actually reach `MaterialApp.locale` — a bare `MaterialApp` in the
/// test (no `locale:` watch) would silently ignore `setLocale` calls.
class _TestApp extends ConsumerWidget {
  const _TestApp();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      home: const SettingsScreen(),
    );
  }
}
