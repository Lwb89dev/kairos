/// A single local reminder attached to a [Task]: "notify me N minutes before
/// the due date".
///
/// Reminders are OS-scheduled at task create/edit time via
/// [NotificationService.scheduleForTask] using `flutter_local_notifications`'
/// `zonedSchedule()` — there is no polling and no background service. The fire
/// instant is the task's due date minus [minutesBefore], resolved in the
/// device's IANA timezone so it lands on the intended wall-clock moment even
/// across a DST change.
///
/// Deliberately the same shape as Astraea's `Reminder`: a task mirrored into
/// the Astraea calendar carries its reminders over unchanged.
class Reminder {
  /// How many minutes before the due date the notification fires. `0` means
  /// "at the due time".
  final int minutesBefore;

  const Reminder({required this.minutesBefore});

  /// Offered in the editor, in the order shown. Same presets as Astraea.
  static const List<int> presetsMinutes = [0, 5, 15, 30, 60, 120, 1440];

  /// What a task gets when the user sets a due date without touching the
  /// reminder list: one hour ahead — early enough to act on, late enough not
  /// to be forgotten by the time it matters.
  static const Reminder defaultReminder = Reminder(minutesBefore: 60);

  /// Guards against a tampered or corrupted stored value turning into an
  /// absurd fire instant. A year of lead time is well past anything useful.
  static const int maxMinutesBefore = 525600;

  /// Upper bound on how many reminders one task may carry, so a single task
  /// cannot consume the OS alarm budget on its own.
  static const int maxPerTask = 8;

  Reminder copyWith({int? minutesBefore}) =>
      Reminder(minutesBefore: minutesBefore ?? this.minutesBefore);

  Map<String, dynamic> toJson() => {'minutesBefore': minutesBefore};

  /// Throws [FormatException] rather than clamping: the value arrives either
  /// from local storage or from a relay payload, and a nonsensical one is a
  /// corrupt record, not something to silently reinterpret.
  factory Reminder.fromJson(Map<String, dynamic> json) {
    final raw = json['minutesBefore'];
    if (raw is! num || raw != raw.roundToDouble() && raw is! int) {
      throw const FormatException('Reminder offset is invalid.');
    }
    final minutes = raw.toInt();
    if (minutes < 0 || minutes > maxMinutesBefore) {
      throw const FormatException('Reminder offset is out of range.');
    }
    return Reminder(minutesBefore: minutes);
  }

  /// Parses a stored/received list, dropping malformed entries rather than
  /// failing the whole task, and de-duplicating: two identical offsets would
  /// otherwise schedule two identical notifications.
  static List<Reminder> listFromJson(Object? raw) {
    if (raw == null) return const [];
    if (raw is! List) throw const FormatException('Reminders must be a list.');
    final seen = <int>{};
    final result = <Reminder>[];
    for (final entry in raw) {
      if (entry is! Map) continue;
      try {
        final reminder = Reminder.fromJson(
          entry.map((key, value) => MapEntry(key.toString(), value)),
        );
        if (seen.add(reminder.minutesBefore)) result.add(reminder);
      } catch (_) {
        continue;
      }
      if (result.length >= maxPerTask) break;
    }
    result.sort((a, b) => b.minutesBefore.compareTo(a.minutesBefore));
    return List.unmodifiable(result);
  }

  @override
  bool operator ==(Object other) =>
      other is Reminder && other.minutesBefore == minutesBefore;

  @override
  int get hashCode => minutesBefore.hashCode;

  @override
  String toString() => 'Reminder($minutesBefore min before)';
}
