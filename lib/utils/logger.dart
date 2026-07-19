import 'package:flutter/foundation.dart';

void debugLog(String message, {String? name}) {
  if (kDebugMode) debugPrint('[${name ?? 'APP'}] $message');
}

/// Debug-only diagnostics. Release builds emit nothing, so task identifiers,
/// filesystem paths and relay errors never become production log metadata.
class SyncLog {
  SyncLog._();

  static void nostr(String message) => _log('NOSTR', message);

  static void storage(String message) => _log('STORAGE', message);

  static void warn(String name, String message) => _log(name, message);

  static void _log(String name, String message) {
    if (kDebugMode) debugPrint('[$name] $message');
  }
}
