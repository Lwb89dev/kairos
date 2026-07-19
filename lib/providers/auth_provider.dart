import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_model.dart';
import '../services/nostr_service.dart';
import '../utils/logger.dart';
import 'app_entry_provider.dart';
import 'service_providers.dart';

/// Global authentication state: `null` = no Nostr account (offline,
/// local-only use — the app still opens; see [appEntryProvider]); otherwise
/// the user is signed in with that identity (local key or Amber).
///
class AuthNotifier extends AsyncNotifier<User?> {
  @override
  Future<User?> build() async {
    debugLog('AuthNotifier.build called', name: 'AuthNotifier');
    final localStorage = ref.read(localStorageServiceProvider);
    final publicKeyHex = await localStorage.loadPublicKey();
    if (publicKeyHex == null) return null;

    final nostrService = ref.read(nostrServiceProvider);
    final method =
        await localStorage.loadLoginMethod() ?? LoginMethod.importedKey;

    if (method == LoginMethod.amber) {
      try {
        return nostrService.amberSession(publicKeyHex);
      } catch (_) {
        await localStorage.clearSession();
        return null;
      }
    }

    final privateKeyHex = await localStorage.loadPrivateKey();
    if (privateKeyHex == null) {
      await localStorage.clearSession();
      return null; // Inconsistent: treat as logged out.
    }
    try {
      return await nostrService.login(privateKeyHex, method: method);
    } catch (_) {
      await localStorage.clearSession();
      return null;
    }
  }

  /// Creates and persists a brand-new keypair (first-time user).
  Future<void> generateAccount() async {
    debugLog('AuthNotifier.generateAccount called', name: 'AuthNotifier');
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final nostrService = ref.read(nostrServiceProvider);
      final user = await nostrService.generateAccount();
      await _persist(user);
      return user;
    });
  }

  /// Signs in via Amber (NIP-55 external signer): the private key never
  /// enters the app. Persists the public key + login method only.
  Future<void> loginWithAmber() async {
    debugLog('AuthNotifier.loginWithAmber called', name: 'AuthNotifier');
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final nostrService = ref.read(nostrServiceProvider);
      final user = await nostrService.loginWithAmber();
      await _persist(user);
      return user;
    });
  }

  /// Imports an existing account from an nsec (bech32) or hex private key.
  Future<void> importAccount(String privateKey) async {
    debugLog('AuthNotifier.importAccount called', name: 'AuthNotifier');
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final nostrService = ref.read(nostrServiceProvider);
      // Decode inside its own guard so a malformed key can never leak: any
      // decode failure collapses into a fixed, key-free marker exception
      // (the login form shows a generic "invalid key" message for it).
      final User user;
      try {
        user = await nostrService.importAccount(privateKey);
      } catch (_) {
        throw const InvalidPrivateKeyException();
      }
      await _persist(user);
      return user;
    });
  }

  Future<void> _persist(User user) async {
    final localStorage = ref.read(localStorageServiceProvider);
    try {
      if (user.privateKeyHex != null) {
        await localStorage.savePrivateKey(user.privateKeyHex!);
      } else {
        // An external-signer session must not leave an older local key behind.
        await localStorage.clearPrivateKey();
      }
      await localStorage.savePublicKey(user.publicKeyHex);
      await localStorage.saveLoginMethod(user.loginMethod);
    } catch (_) {
      // Never leave a half-written session that might later be interpreted as
      // another login method or identity.
      await localStorage.clearSession();
      rethrow;
    }
    // Login and onboarding completion are intentionally separate: signing in
    // on first launch must not skip the explicit relay-selection page.
  }

  /// Clears the local account and returns to "logged out".
  Future<void> logout() async {
    debugLog('AuthNotifier.logout called', name: 'AuthNotifier');
    await ref.read(localStorageServiceProvider).clearSession();
    state = const AsyncData(null);
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, User?>(
  AuthNotifier.new,
);
