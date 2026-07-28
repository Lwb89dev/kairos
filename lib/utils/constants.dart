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
  // Astraea calendar interoperability
  //
  // Astraea is the sibling calendar app in this ecosystem. It shares the
  // account keypair, so a task the user schedules can be published in the
  // shape Astraea already reads and will simply appear in that calendar (and
  // its home-screen widgets) with no coordination between the two apps.
  // These three values are Astraea's wire format, not ours: changing any of
  // them breaks the interoperability. See [AstraeaCalendarMirror].
  // ---------------------------------------------------------------------

  /// NIP-78 "application-specific data", the parameterized replaceable kind
  /// Astraea stores calendar events under.
  static const int astraeaCalendarEventKind = 30078;

  /// Astraea's `d`-tag namespace, retained from before its rename.
  static const String astraeaDTagPrefix = 'epochs:';

  /// Astraea's own default event colour, used for a task with no colour of
  /// its own rather than inventing one the user never chose.
  static const String astraeaDefaultEventColor = '0xFF2196F3';

  // ---------------------------------------------------------------------
  // Suggested relays. Fresh installs select none until the user opts in.
  // ---------------------------------------------------------------------

  /// The implicit relay set for installations that chose relays before the
  /// selection screen existed. It must stay exactly what it always was: an
  /// in-place update must never silently start talking to relay operators the
  /// user never chose.
  static const List<String> defaultRelays = [
    'wss://nos.lol',
    'wss://relay.damus.io',
  ];

  /// Public relays offered during onboarding and in Settings. Deliberately
  /// *not* selected on the user's behalf — each is added only when the user
  /// taps it, since connecting reveals their IP address and public key to the
  /// operator.
  ///
  /// Longer than [defaultRelays] on purpose: with a task list that lives only
  /// on relays, one slow or unreachable operator should not cost the user a
  /// sync. Same set as Astraea, so an account used across both apps converges
  /// on the same infrastructure instead of two disjoint halves of its data.
  static const List<String> suggestedRelays = [
    ...defaultRelays,
    'wss://relay.primal.net',
    'wss://relay.nostr.band',
    'wss://nostr.mom',
    'wss://relay.snort.social',
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

  /// Master switch for task reminders (Settings). Off cancels every scheduled
  /// notification; on re-schedules them from the stored tasks.
  static const String prefsNotificationsEnabledKey = 'kairos.notifications';

  /// Map of task id -> the OS notification ids scheduled for it, so a task can
  /// cancel exactly its own alarms without touching anything else's.
  static const String prefsNotificationIdsKey = 'kairos.notification_ids';

  /// Monotonic counter handing out OS notification ids.
  static const String prefsNotificationSeqKey = 'kairos.notification_seq';

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

  /// How many events a single REQ will buffer before it starts dropping
  /// them. Relays are untrusted: this only bounds memory, not CPU — see
  /// [maxVerifiedEventsPerFetch] for the expensive half.
  static const int maxBufferedEventsPerFetch = 2000;

  /// How many events per fetch may reach Schnorr verification and NIP-44
  /// decryption.
  ///
  /// This is a CPU budget, and it is the one that matters. Verifying an event
  /// costs ~7 ms and decrypting one ~4 ms of pure-Dart secp256k1 work, so an
  /// unbounded loop over a hostile relay's reply blocks the UI isolate for
  /// tens of seconds — far past Android's 5 s ANR threshold. Kind 30789 is
  /// parameterized-replaceable, so at most one event per `d` tag is ever
  /// meaningful; anything beyond this many *distinct* tasks is a relay
  /// flooding us, not a user's task list.
  static const int maxVerifiedEventsPerFetch = 512;

  /// Verification/decryption yields to the event loop every this many events,
  /// so the frame pipeline keeps running instead of freezing mid-sync.
  static const int cryptoYieldInterval = 8;

  /// How many kind-0 events a profile lookup will verify before giving up.
  /// There is only ever one real profile per account; the rest is noise.
  static const int maxProfileCandidates = 4;

  /// Upper bound on how long we wait for Amber to respond to a request.
  /// `amberflutter`'s Android side only resolves on RESULT_OK: if the user
  /// cancels in Amber it never resolves or rejects, so this timeout is our
  /// only way to recover from a hung request.
  static const Duration amberInteractionTimeout = Duration(seconds: 60);

  // ---------------------------------------------------------------------
  // Reminders
  // ---------------------------------------------------------------------

  /// Android notification channel for task reminders. The id is what the OS
  /// keys the user's per-channel settings on, so it must stay stable.
  static const String reminderChannelId = 'kairos_task_reminders';
  static const String reminderChannelName = 'Task reminders';
  static const String reminderChannelDescription =
      'Notifications for tasks with a due date.';

  // ---------------------------------------------------------------------
  // Support
  // ---------------------------------------------------------------------

  /// The developer's Lightning address, offered in Settings > Support. Same
  /// address used by Echoes and Astraea.
  static const String lightningAddress = 'lwb89@blink.sv';
}
