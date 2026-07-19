/// Small display-formatting helpers.
class Formatter {
  Formatter._();

  /// Truncates a hex/npub key for display (e.g. "npub1abc…wxyz") — the
  /// fallback when an account has no kind-0 profile name. Same helper as
  /// Echoes and Astraea.
  static String truncateKey(String key, {int head = 8, int tail = 4}) {
    if (key.length <= head + tail) return key;
    return '${key.substring(0, head)}…${key.substring(key.length - tail)}';
  }
}
