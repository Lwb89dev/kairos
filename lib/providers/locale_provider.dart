import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Holds the app-level language override, persisted in SharedPreferences.
///
/// `null` means "follow the device's system locale"; setting an explicit
/// [Locale] overrides that. [KairosApp] watches this to drive
/// [MaterialApp.locale].
///
/// The persisted value is loaded eagerly in `main()` (see
/// [loadInitialLocale]) and passed into the constructor via
/// `localeProvider.overrideWith(...)` on the root [ProviderContainer], so
/// the very first frame already renders in the right language instead of
/// flashing the system locale and then rebuilding. Same pattern as Echoes.
class LocaleNotifier extends Notifier<Locale?> {
  LocaleNotifier([this._initial]);

  static const _prefsKey = 'checkmarks.language';

  final Locale? _initial;

  @override
  Locale? build() => _initial;

  /// Updates the language, persists it, and rebuilds anything watching
  /// this provider. Pass `null` to go back to following the system locale
  /// (this also removes the stored preference).
  Future<void> setLocale(Locale? locale) async {
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    if (locale != null) {
      await prefs.setString(_prefsKey, locale.languageCode);
    } else {
      await prefs.remove(_prefsKey);
    }
  }

  /// Reads the persisted language code and rebuilds the [Locale], if any.
  /// Called once in `main()`, before `runApp`.
  static Future<Locale?> loadInitialLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_prefsKey);
    return code == null ? null : Locale(code);
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale?>(
  LocaleNotifier.new,
);
