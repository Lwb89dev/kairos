import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'l10n/app_localizations.dart';
import 'providers/app_entry_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/locale_provider.dart';
import 'providers/service_providers.dart';
import 'providers/theme_provider.dart';
import 'screens/onboarding_screen.dart';
import 'screens/tasks_list_screen.dart';
import 'utils/constants.dart';
import 'utils/logger.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _initializeTimezone();

  // Read the persisted theme/language before the first frame so they can be
  // seeded into the container below and the app never flashes the wrong
  // theme or locale.
  final initialThemeMode = await ThemeModeNotifier.loadInitialThemeMode();
  final initialLocale = await LocaleNotifier.loadInitialLocale();

  // Manually created container (instead of a bare ProviderScope) so the Hive
  // box is ready *before* the first frame, avoiding a race on startup reads.
  // Same bootstrap pattern as Echoes and Astraea.
  final container = ProviderContainer(
    overrides: [
      themeModeProvider.overrideWith(() => ThemeModeNotifier(initialThemeMode)),
      localeProvider.overrideWith(() => LocaleNotifier(initialLocale)),
    ],
  );
  try {
    await container.read(taskLocalStorageServiceProvider).init();
  } catch (_) {
    container.dispose();
    runApp(const _StorageFailureApp());
    return;
  }

  // Reminders are handed to the OS, so the plugin has to exist before any
  // task is saved. Failures are contained inside init(): a device that
  // refuses notifications must still get its task list.
  await container.read(notificationServiceProvider).init();

  runApp(
    UncontrolledProviderScope(container: container, child: const KairosApp()),
  );
  // The on-entry relay sync lives in TasksListScreen (it fires both on
  // first mount and on every app resume), so main() has nothing more to do.
}

/// Seeds the `timezone` package's local zone from the device.
///
/// Reminders fire at a wall-clock moment computed from a UTC due date, so the
/// zone has to be the device's real IANA zone, not the UTC fallback the
/// package starts with — otherwise every reminder would land offset by the
/// user's UTC difference. A lookup failure falls back to UTC rather than
/// blocking startup.
Future<void> _initializeTimezone() async {
  tz.initializeTimeZones();
  try {
    final name = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(name));
  } catch (_) {
    debugLog('Could not resolve the device timezone', name: 'main');
  }
}

class _StorageFailureApp extends StatelessWidget {
  const _StorageFailureApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        _FallbackMaterialLocalizationsDelegate(),
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: KairosApp._brandSeed,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Builder(
                builder: (context) => Text(
                  AppLocalizations.of(context).storageFailureMessage,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class KairosApp extends ConsumerWidget {
  const KairosApp({super.key});

  /// Deep violet from Kairos' clock-and-constellation icon.
  static const _brandSeed = Color(0xFF7454E8);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        _FallbackMaterialLocalizationsDelegate(),
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      // Privacy-friendly default: dark theme (see [ThemeModeNotifier]) —
      // light is available from Settings. Consistent with Echoes/Astraea.
      themeMode: themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _brandSeed,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _brandSeed,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const _AppRoot(),
    );
  }
}

// ── Material localizations fallback ────────────────────────────────────────

/// A [LocalizationsDelegate] for [MaterialLocalizations] that accepts every
/// locale but falls back to English when [GlobalMaterialLocalizations] does
/// not natively support the requested one.
///
/// Needed for EU official languages Kairos supports (Irish `ga`, Maltese
/// `mt`) that are not yet part of `flutter_localizations`. Without this
/// fallback, selecting one of them crashes widgets like [AppBar] with
/// "NoMaterialLocalizationsFound". Kairos' own translations
/// ([AppLocalizations]) are unaffected — only built-in Material strings
/// (e.g. the back-button tooltip) fall back to English for those locales.
/// Same workaround as Echoes.
class _FallbackMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const _FallbackMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<MaterialLocalizations> load(Locale locale) {
    final effective = GlobalMaterialLocalizations.delegate.isSupported(locale)
        ? locale
        : const Locale('en');
    return GlobalMaterialLocalizations.delegate.load(effective);
  }

  @override
  bool shouldReload(_FallbackMaterialLocalizationsDelegate old) => false;
}

/// Routes between the onboarding carousel and the task list based on whether
/// the user has entered the app yet (see [appEntryProvider]) — either by
/// completing onboarding (signed in or explicitly local-only) or via a
/// completed onboarding. The task list works with or without a Nostr account,
/// so account presence is deliberately not what gates it.
class _AppRoot extends ConsumerWidget {
  const _AppRoot();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entered = ref.watch(appEntryProvider);
    // Keep auth alive while routing, but completing a login must not skip the
    // relay-choice step in onboarding.
    ref.watch(authProvider);

    return entered.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, _) => const OnboardingScreen(),
      data: (hasEntered) =>
          hasEntered ? const TasksListScreen() : const OnboardingScreen(),
    );
  }
}
