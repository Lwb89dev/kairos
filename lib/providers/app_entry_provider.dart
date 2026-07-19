import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/logger.dart';
import 'service_providers.dart';

/// Whether the user has passed the entry screen — by signing in (Amber /
/// imported / generated key, handled in [AuthNotifier]) or by explicitly
/// choosing offline, local-only use. This, not the presence of an account,
/// is what the router uses to decide between the entry screen and the task
/// list: Kairos is fully usable with no Nostr account at all.
class AppEntryNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    debugLog('AppEntryNotifier.build called', name: 'AppEntryNotifier');
    return ref.read(localStorageServiceProvider).hasEntered();
  }

  /// Enters the app in offline, local-only mode (no account). Idempotent.
  Future<void> completeOnboarding() async {
    debugLog(
      'AppEntryNotifier.completeOnboarding called',
      name: 'AppEntryNotifier',
    );
    await ref.read(localStorageServiceProvider).setEntered();
    state = const AsyncData(true);
  }
}

final appEntryProvider = AsyncNotifierProvider<AppEntryNotifier, bool>(
  AppEntryNotifier.new,
);
