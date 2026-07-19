import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/app_localizations.dart';
import '../models/user_model.dart';
import '../providers/auth_provider.dart';
import '../providers/locale_provider.dart';
import '../providers/profile_provider.dart';
import '../providers/service_providers.dart';
import '../providers/sync_mode_provider.dart';
import '../providers/theme_provider.dart';
import '../utils/constants.dart';
import '../utils/formatter.dart';
import 'widgets/login_options.dart';
import 'widgets/relay_widgets.dart';

/// Account, explicit relay configuration, appearance, language and support
/// settings.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const _privacyChannel = MethodChannel('dev.echoes.kairos/privacy');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final config = ref.watch(syncConfigProvider).value;
    final auth = ref.watch(authProvider).value;
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.settingsTitle)),
      body: config == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                // ---------------------------------------------------------
                // Account
                // ---------------------------------------------------------
                _SectionHeader(l.sectionAccount),
                if (auth == null)
                  ListTile(
                    leading: const Icon(Icons.person_add_outlined),
                    title: Text(l.addAccountTitle),
                    subtitle: Text(l.addAccountSubtitle),
                    onTap: () => _showLoginSheet(context, l),
                  )
                else ...[
                  _AccountRow(user: auth),
                  if (auth.loginMethod.isLocalKey)
                    ListTile(
                      leading: const Icon(Icons.key_outlined),
                      title: Text(l.backupKeyTitle),
                      subtitle: Text(l.backupKeySubtitle),
                      onTap: () => _backupPrivateKey(context, ref, l),
                    ),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: Text(l.logOut),
                    onTap: () => _confirmLogout(context, ref, l),
                  ),
                ],

                // ---------------------------------------------------------
                // Encrypted Nostr synchronization
                // ---------------------------------------------------------
                _SectionHeader(l.sectionSync),
                ListTile(
                  leading: const Icon(Icons.lock_outline),
                  title: Text(l.syncInfoTitle),
                  subtitle: Text(l.syncInfoBody),
                ),
                _SectionHeader(l.sectionRelays),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      RelayListView(relays: config.relays, shrinkWrap: true),
                      const SizedBox(height: 8),
                      const RelayUrlInput(),
                      const Divider(height: 24),
                      const HomeRelayTile(),
                    ],
                  ),
                ),

                // ---------------------------------------------------------
                // Appearance
                // ---------------------------------------------------------
                _SectionHeader(l.sectionAppearance),
                ListTile(
                  leading: const Icon(Icons.dark_mode_outlined),
                  title: Text(l.themeLabel),
                  trailing: SegmentedButton<ThemeMode>(
                    segments: const [
                      ButtonSegment(
                        value: ThemeMode.dark,
                        icon: Icon(Icons.dark_mode, size: 18),
                      ),
                      ButtonSegment(
                        value: ThemeMode.light,
                        icon: Icon(Icons.light_mode, size: 18),
                      ),
                      ButtonSegment(
                        value: ThemeMode.system,
                        icon: Icon(Icons.brightness_auto, size: 18),
                      ),
                    ],
                    selected: {themeMode},
                    onSelectionChanged: (selection) => ref
                        .read(themeModeProvider.notifier)
                        .setThemeMode(selection.first),
                  ),
                ),

                // ---------------------------------------------------------
                // Language
                // ---------------------------------------------------------
                _SectionHeader(l.sectionLanguage),
                const _LanguageSection(),

                // ---------------------------------------------------------
                // Support
                // ---------------------------------------------------------
                _SectionHeader(l.sectionSupport),
                const _DonationTile(),
                const SizedBox(height: 24),
              ],
            ),
    );
  }

  /// The same login options as onboarding, in a bottom sheet — closes
  /// itself as soon as sign-in succeeds.
  void _showLoginSheet(BuildContext context, AppLocalizations l) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: 24 + MediaQuery.of(sheetContext).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l.addAccountTitle,
                style: Theme.of(sheetContext).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              LoginOptions(onLoggedIn: () => Navigator.of(sheetContext).pop()),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmLogout(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l.logoutConfirmTitle),
        content: Text(l.logoutConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l.cancelButton),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l.logOut),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(authProvider.notifier).logout();
    }
  }

  Future<void> _backupPrivateKey(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l,
  ) async {
    final privateKeyHex = await ref
        .read(localStorageServiceProvider)
        .loadPrivateKey();
    if (privateKeyHex == null) return;
    final nsec = ref.read(nostrServiceProvider).privateKeyToNsec(privateKeyHex);
    if (!context.mounted) return;
    try {
      await _privacyChannel.invokeMethod<void>('setSecure', true);
    } catch (_) {
      // The native privacy channel is Android-only.
    }
    if (!context.mounted) return;
    try {
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(l.nsecDialogTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l.nsecDialogWarning),
              const SizedBox(height: 16),
              Text(nsec, style: const TextStyle(fontFamily: 'monospace')),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await _copySensitive(nsec);
                if (dialogContext.mounted) Navigator.of(dialogContext).pop();
              },
              child: Text(l.copyButton),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(l.doneButton),
            ),
          ],
        ),
      );
    } finally {
      try {
        await _privacyChannel.invokeMethod<void>('setSecure', false);
      } catch (_) {
        // Non-Android platform.
      }
    }
  }

  Future<void> _copySensitive(String value) async {
    try {
      await _privacyChannel.invokeMethod<void>('copySensitive', value);
      return;
    } catch (_) {
      await Clipboard.setData(ClipboardData(text: value));
    }
    Timer(const Duration(seconds: 60), () async {
      final current = await Clipboard.getData(Clipboard.kTextPlain);
      if (current?.text == value) {
        await Clipboard.setData(const ClipboardData(text: ''));
      }
    });
  }
}

/// The signed-in account row: kind-0 profile name and avatar when they could
/// be fetched, falling back cleanly (truncated npub / plain icon) while
/// loading or when the account has no public profile.
class _AccountRow extends ConsumerWidget {
  const _AccountRow({required this.user});

  final User user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final profile = ref.watch(profileProvider).value;
    final avatarUrl = profile?.picture;
    final avatarFile = avatarUrl != null
        ? ref.watch(avatarFileProvider(avatarUrl)).value
        : null;
    final displayName = profile?.label ?? Formatter.truncateKey(user.npub);

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: avatarFile != null
            ? ResizeImage(FileImage(avatarFile), width: 128, height: 128)
            : null,
        child: avatarFile == null
            ? Icon(
                user.loginMethod == LoginMethod.amber
                    ? Icons.shield_outlined
                    : Icons.verified_user_outlined,
              )
            : null,
      ),
      title: Text(displayName),
      subtitle: Text(
        user.loginMethod == LoginMethod.amber
            ? l.signedInWithAmber
            : l.signedInWithKey(Formatter.truncateKey(user.npub)),
      ),
    );
  }
}

/// A dropdown to pick an explicit app language, or follow the system locale.
/// Same widget shape and language groupings as Echoes.
class _LanguageSection extends ConsumerWidget {
  const _LanguageSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final locale = ref.watch(localeProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String?>(
          value: locale?.languageCode,
          isExpanded: true,
          borderRadius: BorderRadius.circular(12),
          items: [
            DropdownMenuItem<String?>(value: null, child: Text(l.langSystem)),
            ..._buildLanguageItems(_euOfficialLanguages),
            ..._buildLanguageItems(_additionalLanguages),
          ],
          onChanged: (code) {
            ref
                .read(localeProvider.notifier)
                .setLocale(code != null ? Locale(code) : null);
          },
        ),
      ),
    );
  }

  List<DropdownMenuItem<String?>> _buildLanguageItems(
    Map<String, String> languages,
  ) {
    final sorted = languages.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));
    return sorted
        .map(
          (e) => DropdownMenuItem<String?>(value: e.key, child: Text(e.value)),
        )
        .toList();
  }
}

const Map<String, String> _euOfficialLanguages = {
  'bg': 'Български', // Bulgarian
  'cs': 'Čeština', // Czech
  'da': 'Dansk', // Danish
  'de': 'Deutsch', // German
  'el': 'Ελληνικά', // Greek
  'en': 'English', // English
  'es': 'Español', // Spanish
  'et': 'Eesti', // Estonian
  'fi': 'Suomi', // Finnish
  'fr': 'Français', // French
  'ga': 'Gaeilge', // Irish
  'hr': 'Hrvatski', // Croatian
  'hu': 'Magyar', // Hungarian
  'it': 'Italiano', // Italian
  'lt': 'Lietuvių', // Lithuanian
  'lv': 'Latviešu', // Latvian
  'mt': 'Malti', // Maltese
  'nl': 'Nederlands', // Dutch
  'pl': 'Polski', // Polish
  'pt': 'Português', // Portuguese
  'ro': 'Română', // Romanian
  'sk': 'Slovenčina', // Slovak
  'sl': 'Slovenščina', // Slovenian
  'sv': 'Svenska', // Swedish
};

const Map<String, String> _additionalLanguages = {
  'ja': '日本語', // Japanese
  'ru': 'Русский', // Russian
  'zh': '中文', // Chinese (Simplified)
};

/// "Support Kairos": opens the developer's Lightning address via a
/// `lightning:` URI, with a clipboard-copy fallback when no wallet handles
/// it. Same pattern (and address) as Echoes/Astraea.
class _DonationTile extends StatelessWidget {
  const _DonationTile();

  Future<void> _donate(BuildContext context, AppLocalizations l) async {
    final uri = Uri.parse('lightning:${AppConstants.lightningAddress}');
    var launched = false;
    try {
      launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      launched = false;
    }
    if (launched) return;

    await Clipboard.setData(
      const ClipboardData(text: AppConstants.lightningAddress),
    );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l.lightningAddressCopied(AppConstants.lightningAddress),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        onTap: () => _donate(context, l),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: colorScheme.primary.withValues(alpha: 0.4),
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Icon(Icons.bolt_rounded, color: colorScheme.primary),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.supportKairosTitle,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      AppConstants.lightningAddress,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.open_in_new_rounded,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}
