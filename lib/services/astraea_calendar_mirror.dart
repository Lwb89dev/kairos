import 'dart:convert';

import 'package:timezone/timezone.dart' as tz;

import '../models/sync_config_model.dart';
import '../models/task_model.dart';
import '../models/user_model.dart';
import '../utils/constants.dart';
import '../utils/logger.dart';
import '../utils/task_colors.dart';
import 'nostr_service.dart';

/// Publishes a dated task as an Astraea calendar event, so a task the user
/// scheduled for a future day also shows up in that app's calendar and in its
/// home-screen widget.
///
/// ## How this reaches Astraea
///
/// Nothing is shared between the two apps at runtime — no IPC, no shared
/// database, no changes on Astraea's side. The relays are the integration
/// point. Astraea stores its calendar as kind-30078 (NIP-78 application data)
/// parameterized-replaceable events under the `d` tag `epochs:<uuid>`, NIP-44
/// self-encrypted with the account's own key. Kairos holds that same key, so
/// it can write an event in exactly that shape; Astraea's next sync pulls it
/// like any other, saves it locally, and refreshes its widgets from that local
/// copy. That is also why the widget requirement is satisfied for free: the
/// widgets are drawn natively from Astraea's own store, not from anything
/// Kairos does.
///
/// ## The coordinate
///
/// The `d` tag is derived deterministically from the task id
/// ([calendarDTagFor]), so re-publishing an edited task replaces the same
/// event instead of littering the calendar with copies, and no extra state has
/// to be kept in sync to find it again. The task's own UUIDv4 makes a
/// collision with a genuine Astraea event effectively impossible.
///
/// ## What it deliberately does not do
///
/// It never *reads* Astraea's events. A one-way mirror cannot corrupt the
/// user's calendar, and Kairos has no business interpreting appointments it
/// did not create. The consequence is that an edit made to the mirrored event
/// inside Astraea is overwritten the next time the task changes in Kairos —
/// the task is the source of truth for its own mirror.
class AstraeaCalendarMirror {
  AstraeaCalendarMirror({required NostrService nostrService})
    : _nostr = nostrService;

  final NostrService _nostr;

  /// The `d` tag of the calendar event mirroring [taskId].
  static String calendarDTagFor(String taskId) =>
      '${AppConstants.astraeaDTagPrefix}$taskId';

  /// Whether [task] should currently have a calendar event on the relays.
  ///
  /// A local-only task is excluded for the same reason it is excluded from
  /// task sync: the user pinned it to this device, and mirroring it would
  /// publish the very thing they kept off the network.
  static bool shouldMirror(Task task) {
    return task.mirrorToCalendar &&
        !task.localOnly &&
        !task.deleted &&
        task.dueDateUtc != null;
  }

  /// Publishes (or replaces) the calendar event for [task] and returns the
  /// relay-confirmed event id.
  Future<String> publish({
    required Task task,
    required SyncConfig config,
    required User author,
  }) async {
    if (!shouldMirror(task)) {
      throw StateError('This task must not be mirrored to the calendar.');
    }
    SyncLog.nostr('calendar mirror: publishing ${task.id}');
    return _nostr.publishRawEvent(
      author: author,
      kind: AppConstants.astraeaCalendarEventKind,
      dTag: calendarDTagFor(task.id),
      plaintextContent: jsonEncode(_toAstraeaEventJson(task)),
      createdAt: task.updatedAt,
      relayUrls: config.allSyncRelays,
    );
  }

  /// Retracts the calendar event when the task is deleted or the user unticks
  /// the calendar option.
  ///
  /// The encrypted tombstone is the authoritative operation: Astraea keeps a
  /// local copy and does not delete local events merely because a relay stops
  /// returning them. NIP-09 is sent as a second cleanup request for relays
  /// that honour it. The tombstone uses the same replaceable coordinate, so
  /// it also works when the concrete event id was lost in a race.
  Future<void> retract({
    required Task task,
    required SyncConfig config,
    required User author,
  }) async {
    SyncLog.nostr('calendar mirror: retracting event');
    await _nostr.publishRawEvent(
      author: author,
      kind: AppConstants.astraeaCalendarEventKind,
      dTag: calendarDTagFor(task.id),
      plaintextContent: jsonEncode(_toAstraeaEventJson(task, deleted: true)),
      createdAt: task.updatedAt,
      relayUrls: config.allSyncRelays,
    );
    final previousEventId = task.calendarNostrEventId;
    if (previousEventId != null) {
      await _nostr.publishDeletion(
        author: author,
        nostrEventId: previousEventId,
        relayUrls: config.allSyncRelays,
      );
    }
  }

  /// Maps a task onto Astraea's `Event` JSON.
  ///
  /// Field choices worth stating:
  ///  - A task is a point in time, not an interval. The one-millisecond end is
  ///    visually zero-length, but prevents Astraea's half-open calendar range
  ///    from dropping a deadline exactly at midnight.
  ///  - The current device zone is retained as authoring context. Astraea uses
  ///    it in details/editor views while its agenda still renders the instant
  ///    in device-local time.
  ///  - The task's reminders travel with it, so the same notification the user
  ///    asked for in Kairos also exists on the calendar side.
  ///  - `synced` is false and the sync-ownership fields are absent: those
  ///    describe Astraea's own publishing history, and it is not Kairos'
  ///    place to assert anything about it.
  Map<String, dynamic> _toAstraeaEventJson(Task task, {bool deleted = false}) {
    final dueDate = task.dueDateUtc ?? task.updatedAt;
    return {
      'id': task.id,
      'title': task.title,
      'description': _descriptionFor(task),
      'startTimeUtc': dueDate.toIso8601String(),
      'endTimeUtc': dueDate
          .add(const Duration(milliseconds: 1))
          .toIso8601String(),
      'timezone': _timezoneName(),
      'isAllDay': false,
      'recurrence': null,
      'recurrenceEnd': null,
      'reminders': task.reminders.map((r) => r.toJson()).toList(),
      'color': _colorFor(task),
      'location': null,
      'synced': false,
      'nostrEventId': null,
      'syncOwnerPubkey': null,
      'deleted': deleted,
      'createdAt': task.createdAt.millisecondsSinceEpoch,
      'updatedAt': task.updatedAt.millisecondsSinceEpoch,
    };
  }

  String _timezoneName() {
    // The application initializes timezone data during startup. Keeping a
    // safe fallback here also makes background/tests that construct this
    // service before startup deterministic instead of throwing from tz.local.
    try {
      return tz.local.name;
    } catch (_) {
      return 'UTC';
    }
  }

  /// The task's own description, prefixed so someone reading their calendar
  /// can tell where the entry came from and which app to edit it in.
  String _descriptionFor(Task task) {
    const marker = 'Kairos task';
    final description = task.description?.trim();
    if (description == null || description.isEmpty) return marker;
    return '$marker\n\n$description';
  }

  /// Astraea stores an ARGB hex string. A task that carries one of Kairos'
  /// pastel colors keeps it; the rest get Astraea's own default blue rather
  /// than a colour the user never picked.
  String _colorFor(Task task) {
    final color = task.color;
    if (color == null) return AppConstants.astraeaDefaultEventColor;
    final argb = color.background.toARGB32();
    return '0x${argb.toRadixString(16).toUpperCase().padLeft(8, '0')}';
  }
}
