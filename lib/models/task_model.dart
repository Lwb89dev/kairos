import '../utils/constants.dart';
import '../utils/task_colors.dart';

/// Lifecycle state of a task. Deliberately just two states (inline checkbox
/// semantics) — richer workflows are out of scope for the MVP.
enum TaskStatus {
  pending,
  done;

  static TaskStatus fromName(String? name) {
    return TaskStatus.values.asNameMap()[name] ?? TaskStatus.pending;
  }
}

/// A Kairos task. Offline-first: instances live in encrypted Hive storage and are the
/// source of truth; optional encrypted Nostr sync mirrors them outward.
///
/// Serialized with manual toJson/fromJson (no codegen — same constraint as
/// Echoes/Astraea). The same JSON body is NIP-44-encrypted into Kind-30789
/// `content`.
class Task {
  final String id;
  final String title;
  final String? description;

  /// Optional deadline stored as a UTC instant.
  final DateTime? dueDateUtc;

  final TaskStatus status;

  /// Free-form category tags, e.g. `["work", "personal"]`.
  final List<String> tags;

  /// Optional protocol-level cross-reference to a calendar event.
  final String? linkedEventId;

  /// 1 (low) … 5 (high); null = unset.
  final int? priority;

  /// User-chosen background color for this specific task (see [TaskColor],
  /// same Google Keep-style coding as Echoes notes). Null = no override,
  /// the app's normal surface color.
  final TaskColor? color;

  final DateTime createdAt;

  /// Bumped on every edit; also the Nostr `created_at` of the re-published
  /// Kind-30789 event, which is what makes last-write-wins reconciliation
  /// deterministic.
  final DateTime updatedAt;

  /// Whether the current local revision has been accepted by at least one
  /// relay (Nostr sync) — false while offline or when Nostr sync is off.
  final bool synced;

  /// Relay-confirmed id of the latest published Kind-30789 event, if any.
  final String? nostrEventId;

  /// Public key of the Nostr account this task was synchronized with. This
  /// prevents a pending task from being uploaded to a different account after
  /// sign-out/sign-in. Null means local-only or legacy/unclaimed data.
  final String? syncOwnerPubkey;

  /// Locally-deleted tombstone: kept (not hard-removed) so the sync layer can
  /// publish the NIP-09 deletion and reconcile late-arriving relay copies.
  /// The UI filters these out.
  final bool deleted;

  /// Local-only marker: a user-initiated deletion still needs its NIP-09
  /// request. It is never serialized to Nostr, so a tombstone pulled from a
  /// relay can be re-published to a newly added relay without deleting itself.
  final bool deletionRequestPending;

  /// User's explicit choice to keep this task off the relays: the sync layer
  /// must never publish it (not even its deletion tombstone). Cleared by the
  /// editor's "Sync task" action. Device-local bookkeeping — excluded from
  /// [toSyncJson], so it can never leak to a relay, and tasks pulled from
  /// relays always come back with `false`.
  final bool localOnly;

  const Task({
    required this.id,
    required this.title,
    this.description,
    this.dueDateUtc,
    this.status = TaskStatus.pending,
    this.tags = const [],
    this.linkedEventId,
    this.priority,
    this.color,
    required this.createdAt,
    required this.updatedAt,
    this.synced = false,
    this.nostrEventId,
    this.syncOwnerPubkey,
    this.deleted = false,
    this.deletionRequestPending = false,
    this.localOnly = false,
  });

  /// The Kind-30789 `d` tag: `checkmarks:<uuid>`. Immutable for the lifetime
  /// of the task — updates re-publish the same tag (parameterized
  /// replaceable), so the relay keeps only the newest revision.
  String get dTag => '${AppConstants.dTagPrefix}$id';

  bool get isDone => status == TaskStatus.done;

  Task copyWith({
    String? title,
    String? description,
    bool clearDescription = false,
    DateTime? dueDateUtc,
    bool clearDueDate = false,
    TaskStatus? status,
    List<String>? tags,
    String? linkedEventId,
    bool clearLinkedEvent = false,
    int? priority,
    bool clearPriority = false,
    TaskColor? color,
    bool clearColor = false,
    DateTime? updatedAt,
    bool? synced,
    String? nostrEventId,
    String? syncOwnerPubkey,
    bool? deleted,
    bool? deletionRequestPending,
    bool clearDeletionRequestPending = false,
    bool? localOnly,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      description: clearDescription ? null : (description ?? this.description),
      dueDateUtc: clearDueDate ? null : (dueDateUtc ?? this.dueDateUtc),
      status: status ?? this.status,
      tags: tags ?? this.tags,
      linkedEventId: clearLinkedEvent
          ? null
          : (linkedEventId ?? this.linkedEventId),
      priority: clearPriority ? null : (priority ?? this.priority),
      color: clearColor ? null : (color ?? this.color),
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      synced: synced ?? this.synced,
      nostrEventId: nostrEventId ?? this.nostrEventId,
      syncOwnerPubkey: syncOwnerPubkey ?? this.syncOwnerPubkey,
      deleted: deleted ?? this.deleted,
      deletionRequestPending: clearDeletionRequestPending
          ? false
          : (deletionRequestPending ?? this.deletionRequestPending),
      localOnly: localOnly ?? this.localOnly,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDateUtc?.toIso8601String(),
      'status': status.name,
      'tags': tags,
      'linkedEventId': linkedEventId,
      'priority': priority,
      'color': color?.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'synced': synced,
      'nostrEventId': nostrEventId,
      'syncOwnerPubkey': syncOwnerPubkey,
      'deleted': deleted,
      'deletionRequestPending': deletionRequestPending,
      'localOnly': localOnly,
    };
  }

  /// Task payload that is encrypted and published. Relay-sync bookkeeping is
  /// deliberately excluded: it is device-local state, not task content.
  Map<String, dynamic> toSyncJson() => {
    'id': id,
    'title': title,
    'description': description,
    'dueDate': dueDateUtc?.toIso8601String(),
    'status': status.name,
    'tags': tags,
    'linkedEventId': linkedEventId,
    'priority': priority,
    'color': color?.name,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'deleted': deleted,
  };

  factory Task.fromJson(Map<String, dynamic> json) {
    final id = _requiredBoundedString(json['id'], 'id', maxLength: 128);
    final title = _requiredBoundedString(
      json['title'],
      'title',
      maxLength: 512,
    );
    final description = _optionalBoundedString(
      json['description'],
      'description',
      maxLength: 16384,
    );
    final rawTags = json['tags'];
    if (rawTags != null && rawTags is! List) {
      throw const FormatException('Task tags must be a list.');
    }
    final tags = (rawTags as List? ?? const [])
        .whereType<String>()
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .take(32)
        .toList(growable: false);
    if (tags.any((tag) => tag.length > 64)) {
      throw const FormatException('Task tag is too long.');
    }
    final priority = json['priority'];
    if (priority != null &&
        (priority is! int || priority < 1 || priority > 5)) {
      throw const FormatException('Task priority is invalid.');
    }
    final synced = json['synced'] as bool? ?? false;
    final deleted = json['deleted'] as bool? ?? false;
    return Task(
      id: id,
      title: title,
      description: description,
      dueDateUtc: json['dueDate'] == null
          ? null
          : DateTime.parse(json['dueDate'] as String).toUtc(),
      status: TaskStatus.fromName(json['status'] as String?),
      tags: tags,
      linkedEventId: _optionalBoundedString(
        json['linkedEventId'],
        'linkedEventId',
        maxLength: 128,
      ),
      priority: priority as int?,
      color: TaskColor.values.asNameMap()[json['color'] as String?],
      createdAt: DateTime.parse(json['createdAt'] as String).toUtc(),
      updatedAt: DateTime.parse(json['updatedAt'] as String).toUtc(),
      synced: synced,
      nostrEventId: _optionalBoundedString(
        json['nostrEventId'],
        'nostrEventId',
        maxLength: 128,
      ),
      syncOwnerPubkey: _optionalBoundedString(
        json['syncOwnerPubkey'],
        'syncOwnerPubkey',
        maxLength: 64,
      ),
      deleted: deleted,
      deletionRequestPending:
          json['deletionRequestPending'] as bool? ?? (deleted && !synced),
      localOnly: json['localOnly'] as bool? ?? false,
    );
  }
}

String _requiredBoundedString(
  Object? value,
  String field, {
  required int maxLength,
}) {
  if (value is! String) throw FormatException('Task $field is missing.');
  final trimmed = value.trim();
  if (trimmed.isEmpty || trimmed.length > maxLength) {
    throw FormatException('Task $field is invalid.');
  }
  return trimmed;
}

String? _optionalBoundedString(
  Object? value,
  String field, {
  required int maxLength,
}) {
  if (value == null) return null;
  if (value is! String || value.length > maxLength) {
    throw FormatException('Task $field is invalid.');
  }
  final trimmed = value.trim();
  return trimmed.isEmpty ? null : trimmed;
}
