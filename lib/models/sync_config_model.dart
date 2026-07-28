import '../utils/constants.dart';
import '../utils/relay_url.dart';

/// User-selected Nostr relay configuration. An empty list is an explicit
/// local-only posture: Kairos never chooses network infrastructure silently.
class SyncConfig {
  /// Relays used for encrypted task publication and retrieval.
  final List<String> relays;

  /// Optional personal/home relay URL used as an *additional* backup target
  /// (tasks are published here too). Null/empty means "not configured".
  /// Same concept as Astraea's personal relay setting.
  final String? homeRelayUrl;

  const SyncConfig({this.relays = const [], this.homeRelayUrl});

  /// Every relay we should publish to: the public list plus the home relay
  /// (de-duplicated) when one is configured.
  List<String> get allSyncRelays {
    final home = homeRelayUrl?.trim();
    if (home == null || home.isEmpty) return relays;
    return {...relays, home}.toList();
  }

  SyncConfig copyWith({
    List<String>? relays,
    String? homeRelayUrl,
    bool clearHomeRelay = false,
  }) {
    return SyncConfig(
      relays: relays ?? this.relays,
      homeRelayUrl: clearHomeRelay ? null : (homeRelayUrl ?? this.homeRelayUrl),
    );
  }

  /// The single normalization used by *every* boundary that reads, writes or
  /// hands out a relay configuration: the settings provider, the
  /// SharedPreferences layer and any config rebuilt from untrusted stored
  /// state.
  ///
  /// Having one implementation is the point. This logic used to be copied
  /// into three places, and two of the copies forgot `allowInsecureLocal` on
  /// the home relay — so a `ws://` (or private-IP) home relay was accepted by
  /// the UI, kept in memory, and then silently dropped by the persistence
  /// layer, which is exactly the LAN-relay case the slot exists for.
  ///
  /// Drops malformed/insecure entries, removes the home relay from the public
  /// list so it is never counted twice, and truncates to
  /// [AppConstants.maxRelayConnections] total endpoints.
  factory SyncConfig.sanitized({
    required Iterable<String> relays,
    String? homeRelayUrl,
  }) {
    final home = normalizeSecureRelayUrl(homeRelayUrl ?? '');
    final limit = home == null
        ? AppConstants.maxRelayConnections
        : AppConstants.maxRelayConnections - 1;
    final sanitizedRelays = relays
        .map(normalizeSecureRelayUrl)
        .whereType<String>()
        .where((relay) => relay != home)
        .toSet()
        .take(limit)
        .toList(growable: false);
    return SyncConfig(relays: sanitizedRelays, homeRelayUrl: home);
  }

  /// [SyncConfig.sanitized] applied to this instance.
  SyncConfig sanitized() =>
      SyncConfig.sanitized(relays: relays, homeRelayUrl: homeRelayUrl);
}
