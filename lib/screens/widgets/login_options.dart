import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../services/nostr_service.dart';

/// The three ways to sign in with Nostr, in the ecosystem's privacy order:
/// Amber (NIP-55 external signer), create a brand-new account, or import an
/// existing key (nsec/hex), consistent with Echoes and Astraea —
/// shared between the onboarding login page and Settings > "Add a Nostr
/// account".
///
/// Skipping (offline, local-only use) is deliberately NOT in here: it
/// belongs to the surrounding flow (onboarding's Skip button), which also
/// decides what "done" means via [onLoggedIn].
class LoginOptions extends ConsumerStatefulWidget {
  const LoginOptions({super.key, this.onLoggedIn});

  /// Called once after a sign-in succeeds (any method).
  final VoidCallback? onLoggedIn;

  @override
  ConsumerState<LoginOptions> createState() => _LoginOptionsState();
}

class _LoginOptionsState extends ConsumerState<LoginOptions> {
  final _importController = TextEditingController();
  bool _showImportField = false;

  bool get _supportsAmber =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  @override
  void dispose() {
    _importController.dispose();
    super.dispose();
  }

  Future<void> _loginWithAmber() async {
    await ref.read(authProvider.notifier).loginWithAmber();
  }

  Future<void> _generate() async {
    await ref.read(authProvider.notifier).generateAccount();
  }

  Future<void> _import() async {
    final key = _importController.text.trim();
    if (key.isEmpty) return;
    await ref.read(authProvider.notifier).importAccount(key);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    final authState = ref.watch(authProvider);
    final isLoading = authState.isLoading;

    ref.listen(authProvider, (previous, next) {
      // Only a transition into "signed in" counts — not the initial build
      // replaying an existing session.
      if (previous?.value == null && next.value != null) {
        widget.onLoggedIn?.call();
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (authState.hasError)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              // Never interpolate the raw error for a bad key: it can embed
              // the key the user just typed. Only non-key errors (e.g. Amber
              // failures) get their detailed message.
              authState.error is InvalidPrivateKeyException
                  ? l.invalidKeyError
                  : l.signInError,
              textAlign: TextAlign.center,
              style: TextStyle(color: theme.colorScheme.error),
            ),
          ),

        // 1. Amber (NIP-55) — the private key stays outside Kairos.
        if (_supportsAmber) ...[
          FilledButton.tonalIcon(
            onPressed: isLoading ? null : _loginWithAmber,
            icon: const Icon(Icons.shield_outlined),
            label: Text(l.signInAmberButton),
          ),
          const SizedBox(height: 12),
        ],

        // 2. Generate a new account.
        OutlinedButton.icon(
          onPressed: isLoading ? null : _generate,
          icon: const Icon(Icons.auto_awesome),
          label: Text(l.createAccountButton),
        ),
        const SizedBox(height: 8),
        Text(
          l.generatedAccountHint,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),

        // 3. Import an existing key.
        OutlinedButton.icon(
          onPressed: isLoading
              ? null
              : () => setState(() => _showImportField = !_showImportField),
          icon: const Icon(Icons.key),
          label: Text(l.importKeyButton),
        ),
        if (_showImportField) ...[
          const SizedBox(height: 16),
          TextField(
            controller: _importController,
            obscureText: true,
            // A private key must never reach the keyboard's learning or
            // suggestion caches.
            autocorrect: false,
            enableSuggestions: false,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.done,
            onSubmitted: isLoading ? null : (_) => _import(),
            decoration: InputDecoration(
              labelText: l.importKeyFieldLabel,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: isLoading ? null : _import,
            child: Text(l.importButton),
          ),
        ],

        if (isLoading) ...[
          const SizedBox(height: 24),
          const Center(child: CircularProgressIndicator()),
        ],
      ],
    );
  }
}
