/// App-wide constants shared across services/providers/UI.
class AppConstants {
  AppConstants._();

  static const String appName = 'Kairos';

  // ---------------------------------------------------------------------
  // Nostr event kinds
  // ---------------------------------------------------------------------

  /// Nostr kind used for encrypted tasks: 30789, a parameterized replaceable
  /// event. The relay keeps only the latest version per `d` tag, so updating
  /// a task (title edit, checkbox toggle) = republishing the same `d` tag.
  /// Each task JSON is NIP-44 self-encrypted (conversation key with the
  /// user's own keypair) before being placed in `content`.
  static const int taskEventKind = 30789;

  /// NIP-09 event deletion request kind, used to retract a task from the
  /// relays. Relays may ignore deletion requests, so deletion is also
  /// tracked with a local `deleted` tombstone flag.
  static const int deletionEventKind = 5;

  /// Stable wire namespace from the app's original name. It must not change:
  /// doing so would orphan already-published tasks on Nostr relays. This is a
  /// protocol identifier, not user-visible branding (the same compatibility
  /// approach Astraea uses for its historical `epochs:` tags).
  static const String dTagPrefix = 'checkmarks:';

  // ---------------------------------------------------------------------
  // Suggested relays. Fresh installs select none until the user opts in.
  // ---------------------------------------------------------------------

  static const List<String> defaultRelays = [
    'wss://nos.lol',
    'wss://relay.damus.io',
  ];

  /// Hard ceiling for simultaneously configured WebSocket endpoints. This
  /// bounds sockets, acknowledgement fan-out and attacker-controlled config
  /// amplification even if local preferences are tampered with.
  static const int maxRelayConnections = 12;

  // ---------------------------------------------------------------------
  // SharedPreferences keys (non-sensitive settings)
  // ---------------------------------------------------------------------

  static const String prefsRelaysKey = 'checkmarks.relays';
  static const String prefsHomeRelayKey = 'checkmarks.home_relay';
  static const String prefsPublicKeyKey = 'checkmarks.pubkey';

  /// Last-fetched profile metadata (name/avatar URL) for the signed-in
  /// account, so the UI shows something immediately on launch instead of a
  /// blank state while [ProfileNotifier] re-fetches from the relays.
  static const String prefsProfileCacheKey = 'checkmarks.profile_cache';
  static const String prefsLoginMethodKey = 'checkmarks.login_method';

  /// Set once the user has passed the entry screen — either by signing in
  /// (Amber / imported / generated key) or by explicitly choosing offline,
  /// local-only use. This key remains stable across the product rename.
  static const String prefsEnteredKey = 'checkmarks.entered';

  /// flutter_secure_storage key for the account private key (nsec/hex).
  static const String secureStoragePrivateKeyKey = 'checkmarks.privkey';

  // ---------------------------------------------------------------------
  /// Secure-storage key for the AES-256 key encrypting the local Hive box.
  static const String secureStorageTaskDatabaseKey = 'kairos.tasks_db_key.v1';

  /// Encrypted task box. The old plaintext box is migrated once at startup.
  static const String tasksBoxName = 'kairos_tasks_v1';
  static const String legacyTasksBoxName = 'checkmarks_tasks';

  // ---------------------------------------------------------------------
  // Sync
  // ---------------------------------------------------------------------

  /// Upper bound on how long a REQ waits for stored events before the
  /// relay's EOSE ("end of stored events").
  static const Duration syncEoseTimeout = Duration(seconds: 10);

  /// Upper bound on how long we wait for Amber to respond to a request.
  /// `amberflutter`'s Android side only resolves on RESULT_OK: if the user
  /// cancels in Amber it never resolves or rejects, so this timeout is our
  /// only way to recover from a hung request.
  static const Duration amberInteractionTimeout = Duration(seconds: 60);

  // ---------------------------------------------------------------------
  // Support
  // ---------------------------------------------------------------------

  /// The developer's Lightning address, offered in Settings > Support. Same
  /// address used by Echoes and Astraea.
  static const String lightningAddress = 'lwb89@blink.sv';
}
