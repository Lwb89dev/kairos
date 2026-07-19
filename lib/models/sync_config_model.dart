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
}
