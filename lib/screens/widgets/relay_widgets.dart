import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/sync_mode_provider.dart';
import '../../utils/constants.dart';
import '../../utils/relay_url.dart';

/// Relay-management widgets shared by the onboarding relay-setup page and
/// Settings' relay section — the same trio Echoes uses (custom URL input,
/// suggested list, current list), plus the home-relay tile used by Astraea.

/// A text field + "add" button for entering a custom relay URL.
class RelayUrlInput extends ConsumerStatefulWidget {
  const RelayUrlInput({super.key});

  @override
  ConsumerState<RelayUrlInput> createState() => _RelayUrlInputState();
}

class _RelayUrlInputState extends ConsumerState<RelayUrlInput> {
  final _urlController = TextEditingController();

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _addRelay() async {
    final l = AppLocalizations.of(context);
    final url = normalizeSecureRelayUrl(_urlController.text);
    if (url == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l.relayInvalidUrlWss)));
      return;
    }
    await ref.read(syncConfigProvider.notifier).addRelay(url);
    _urlController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _urlController,
            keyboardType: TextInputType.url,
            autocorrect: false,
            enableSuggestions: false,
            decoration: InputDecoration(
              labelText: l.relayUrlHint,
              border: const OutlineInputBorder(),
            ),
            onSubmitted: (_) => _addRelay(),
          ),
        ),
        const SizedBox(width: 8),
        IconButton.filled(
          tooltip: l.addRelayTooltip,
          icon: const Icon(Icons.add),
          onPressed: _addRelay,
        ),
      ],
    );
  }
}

/// A row of well-known, commonly-used relays with a one-tap "add" button
/// each — switching to a checkmark icon once already in the user's relay
/// list. Shown during onboarding to make relay setup fast for newcomers who
/// don't have a preferred relay list yet.
class SuggestedRelayList extends ConsumerWidget {
  const SuggestedRelayList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUrls =
        ref.watch(syncConfigProvider).value?.relays.toSet() ?? const <String>{};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final url in AppConstants.defaultRelays)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.dns_outlined),
            title: Text(url),
            trailing: currentUrls.contains(url)
                ? Icon(
                    Icons.check_circle,
                    color: Theme.of(context).colorScheme.primary,
                  )
                : IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () =>
                        ref.read(syncConfigProvider.notifier).addRelay(url),
                  ),
          ),
      ],
    );
  }
}

/// The current relay list, with a remove button per relay.
class RelayListView extends ConsumerWidget {
  const RelayListView({
    super.key,
    required this.relays,
    this.shrinkWrap = false,
  });

  final List<String> relays;

  /// Set to true when embedded inside another scrollable (e.g. the
  /// onboarding carousel page), so this list sizes itself to its content
  /// instead of trying to scroll independently.
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    if (relays.isEmpty) {
      return Center(child: Text(l.noRelaysConfigured));
    }

    return ListView.builder(
      shrinkWrap: shrinkWrap,
      physics: shrinkWrap ? const NeverScrollableScrollPhysics() : null,
      itemCount: relays.length,
      itemBuilder: (context, index) {
        final url = relays[index];
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.dns_outlined),
          title: Text(url),
          trailing: IconButton(
            tooltip: l.removeRelayTooltip,
            icon: const Icon(Icons.delete_outline),
            onPressed: () =>
                ref.read(syncConfigProvider.notifier).removeRelay(url),
          ),
        );
      },
    );
  }
}

/// The optional personal/home relay: an *additional*
/// publish target for users running their own relay at home — their tasks
/// are backed up there on top of the public relays.
///
/// Unlike every other relay slot, the home relay may use a plaintext
/// `ws://` address (in addition to `wss://`): it's the one deliberate
/// exception to the app's wss-only policy, meant for a relay reachable only
/// on the user's own network (e.g. a Raspberry Pi at home that doesn't
/// terminate TLS). See [normalizeSecureRelayUrl].
class HomeRelayTile extends ConsumerWidget {
  const HomeRelayTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final homeRelay = ref.watch(syncConfigProvider).value?.homeRelayUrl;
    final configured = homeRelay != null && homeRelay.isNotEmpty;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.home_outlined),
      title: Text(configured ? homeRelay : l.homeRelayTitle),
      subtitle: Text(
        configured ? l.homeRelayConfiguredSubtitle : l.homeRelaySubtitle,
      ),
      trailing: configured
          ? IconButton(
              tooltip: l.removeHomeRelayTooltip,
              icon: const Icon(Icons.delete_outline),
              onPressed: () =>
                  ref.read(syncConfigProvider.notifier).setHomeRelay(null),
            )
          : const Icon(Icons.chevron_right),
      onTap: () => _promptHomeRelay(context, ref, l, current: homeRelay),
    );
  }

  Future<void> _promptHomeRelay(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l, {
    String? current,
  }) async {
    // The dialog's TextEditingController is owned by _HomeRelayDialog's own
    // State (not created/disposed here): showDialog's Future resolves as
    // soon as Navigator.pop() is called, which is *before* the dialog's
    // exit transition finishes animating — disposing the controller at that
    // point (as this used to) raced the still-animating TextField's own
    // rebuilds and threw "TextEditingController used after being disposed".
    // A State-owned controller is only disposed once the element is
    // actually unmounted, after the transition completes.
    final url = await showDialog<String>(
      context: context,
      builder: (dialogContext) =>
          _HomeRelayDialog(l: l, initialValue: current ?? ''),
    );
    if (url == null) return;
    final normalized = url.isEmpty
        ? null
        : normalizeSecureRelayUrl(url, allowInsecureLocal: true);
    if (url.isNotEmpty && normalized == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l.homeRelayInvalidUrl)));
      }
      return;
    }
    await ref.read(syncConfigProvider.notifier).setHomeRelay(normalized);
  }
}

class _HomeRelayDialog extends StatefulWidget {
  const _HomeRelayDialog({required this.l, required this.initialValue});

  final AppLocalizations l;
  final String initialValue;

  @override
  State<_HomeRelayDialog> createState() => _HomeRelayDialogState();
}

class _HomeRelayDialogState extends State<_HomeRelayDialog> {
  late final _controller = TextEditingController(text: widget.initialValue);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.l.homeRelayTitle),
      content: TextField(
        controller: _controller,
        autofocus: true,
        autocorrect: false,
        enableSuggestions: false,
        keyboardType: TextInputType.url,
        decoration: InputDecoration(
          labelText: widget.l.homeRelayUrlHint,
          border: const OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(widget.l.cancelButton),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_controller.text.trim()),
          child: Text(widget.l.saveButton),
        ),
      ],
    );
  }
}
