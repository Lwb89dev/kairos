import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../providers/app_entry_provider.dart';
import '../providers/sync_mode_provider.dart';
import '../utils/constants.dart';
import '../utils/kairos_theme.dart';
import 'widgets/kairos_glass.dart';
import 'widgets/login_options.dart';
import 'widgets/relay_widgets.dart';

/// First-launch, three-step carousel — the same onboarding flow as
/// Echoes/Astraea:
///  1. [_IntroPage] — explains local storage, optional encrypted sync and Amber.
///  2. [_LoginPage] — sign in with Nostr (Amber, new account, or an imported
///     key), or skip to a local-only session.
///  3. [_RelaySetupPage] — pick relays to sync through, including the
///     optional personal home relay.
///
/// Shown exactly once: finishing (or skipping login) persists the entered
/// flag so `_AppRoot` (see main.dart) routes straight to the task list
/// afterwards, whether or not the user ended up signed in.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  static const _pageCount = 3;

  final _pageController = PageController();
  int _page = 0;
  bool _finishing = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int page) {
    if (page < 0 || page >= _pageCount || !_pageController.hasClients) return;
    _pageController.animateToPage(
      page,
      duration: KairosMotion.of(context, const Duration(milliseconds: 300)),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _finish() async {
    if (_finishing) return;
    setState(() => _finishing = true);
    // Persist even an explicitly empty relay choice so future upgrades never
    // mistake "none" for the historical implicit defaults.
    try {
      final config = await ref.read(syncConfigProvider.future);
      await ref.read(syncConfigProvider.notifier).save(config);
      await ref.read(appEntryProvider.notifier).completeOnboarding();
    } catch (_) {
      if (!mounted) return;
      final l = AppLocalizations.of(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l.onboardingSaveError)));
    } finally {
      if (mounted) setState(() => _finishing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (page) => setState(() => _page = page),
                children: [
                  const _IntroPage(),
                  _LoginPage(onAdvance: () => _goToPage(2)),
                  const _RelaySetupPage(),
                ],
              ),
            ),
            _OnboardingBottomBar(
              page: _page,
              pageCount: _pageCount,
              finishing: _finishing,
              onBack: () => _goToPage(_page - 1),
              onNext: () => _goToPage(_page + 1),
              // Skipping login means there's no Nostr account to sync with,
              // so relay setup (page 3) would be meaningless — go straight
              // to finishing onboarding instead of just advancing a page.
              // Relays can still be configured later from Settings.
              onSkip: _finish,
              onFinish: _finish,
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingBottomBar extends StatelessWidget {
  const _OnboardingBottomBar({
    required this.page,
    required this.pageCount,
    required this.finishing,
    required this.onBack,
    required this.onNext,
    required this.onSkip,
    required this.onFinish,
  });

  final int page;
  final int pageCount;
  final bool finishing;
  final VoidCallback onBack;
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isFirst = page == 0;
    final isLast = page == pageCount - 1;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      child: KairosFloatingBar(
        child: Row(
          children: [
            SizedBox(
              width: 72,
              child: isFirst
                  ? null
                  : TextButton(onPressed: onBack, child: Text(l.backButton)),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  pageCount,
                  (i) => _Dot(active: i == page),
                ),
              ),
            ),
            if (isLast)
              FilledButton(
                onPressed: finishing ? null : onFinish,
                child: finishing
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l.getStartedButton),
              )
            else if (page == 1)
              TextButton(
                onPressed: finishing ? null : onSkip,
                child: finishing
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l.useOfflineButton),
              )
            else
              FilledButton(onPressed: onNext, child: Text(l.nextButton)),
          ],
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: KairosMotion.of(context, KairosMotion.quick),
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: active ? 20 : 6,
      height: 6,
      decoration: BoxDecoration(
        color: active
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.outlineVariant,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

// ── Page 1: how Kairos works ────────────────────────────────────────────

class _IntroPage extends StatelessWidget {
  const _IntroPage();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        KairosSpacing.lg,
        KairosSpacing.md,
        KairosSpacing.lg,
        KairosSpacing.xl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset('assets/icon/icon.png', width: 72, height: 72),
          ),
          const SizedBox(height: 16),
          Text(
            l.welcomeTitle(AppConstants.appName),
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 4),
          Text(
            l.welcomeSubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          KairosGlassSurface(
            padding: const EdgeInsets.fromLTRB(
              KairosSpacing.md,
              KairosSpacing.lg,
              KairosSpacing.md,
              KairosSpacing.sm,
            ),
            child: Column(
              children: [
                _FeatureRow(
                  icon: Icons.smartphone,
                  title: l.featureLocalTitle,
                  body: l.featureLocalBody,
                ),
                _FeatureRow(
                  icon: Icons.sync,
                  title: l.featureSyncTitle,
                  body: l.featureSyncBody,
                ),
                _FeatureRow(
                  icon: Icons.lock_outline,
                  title: l.featureEncryptedTitle,
                  body: l.featureEncryptedBody,
                ),
                _FeatureRow(
                  icon: Icons.shield_outlined,
                  title: l.featureAmberTitle,
                  body: l.featureAmberBody,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(body, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Page 2: sign in or skip ─────────────────────────────────────────────

class _LoginPage extends StatelessWidget {
  const _LoginPage({required this.onAdvance});

  final VoidCallback onAdvance;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(Icons.key, size: 48, color: theme.colorScheme.primary),
          const SizedBox(height: 16),
          Text(
            l.loginPageTitle,
            style: theme.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            l.loginPageBody,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          KairosGlassSurface(
            padding: const EdgeInsets.all(KairosSpacing.md),
            child: LoginOptions(onLoggedIn: onAdvance),
          ),
        ],
      ),
    );
  }
}

// ── Page 3: relay setup ─────────────────────────────────────────────────

class _RelaySetupPage extends ConsumerWidget {
  const _RelaySetupPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    final config = ref.watch(syncConfigProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.dns_outlined, size: 48, color: theme.colorScheme.primary),
          const SizedBox(height: 16),
          Text(l.relaySetupTitle, style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(l.relaySetupBody, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 16),
          const RelayUrlInput(),
          const SizedBox(height: 8),
          const SuggestedRelayList(),
          const Divider(),
          const HomeRelayTile(),
          const Divider(),
          const SizedBox(height: 8),
          config.when(
            data: (c) => RelayListView(relays: c.relays, shrinkWrap: true),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, _) => Text(l.relaySettingsLoadError),
          ),
        ],
      ),
    );
  }
}
