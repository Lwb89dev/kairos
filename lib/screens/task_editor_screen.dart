import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';
import '../models/reminder_model.dart';
import '../models/task_model.dart';
import '../providers/auth_provider.dart';
import '../providers/sync_mode_provider.dart';
import '../providers/tasks_provider.dart';
import '../utils/kairos_theme.dart';
import '../utils/task_colors.dart';
import 'widgets/kairos_glass.dart';

/// Create/edit form: title (required), description, due date+time, tags,
/// priority. Pass [task] to edit; otherwise a new task is created on save.
/// Saving is offline-first — the screen never blocks on the network; sync
/// publication happens best-effort after the local write.
///
/// When sync is available (account + at least one relay): a new task, or an
/// existing task that is already syncing, gets a two-way "Sync to Nostr"
/// toggle — off pins it to this device ([Task.localOnly]), on (again) lifts
/// the pin; an existing local-only task instead gets a "Sync task" button
/// that saves the current edits and lifts the pin, publishing it a
/// posteriori.
class TaskEditorScreen extends ConsumerStatefulWidget {
  const TaskEditorScreen({super.key, this.task});

  final Task? task;

  @override
  ConsumerState<TaskEditorScreen> createState() => _TaskEditorScreenState();
}

class _TaskEditorScreenState extends ConsumerState<TaskEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _tagsController;

  DateTime? _dueDateLocal;
  int? _priority;
  TaskColor? _color;
  bool _saving = false;
  List<Reminder> _reminders = const [];
  bool _mirrorToCalendar = false;

  /// Driven by the "Sync to Nostr" toggle for a new task or an already-
  /// syncing existing task (defaults to on, i.e. reflects the task's current
  /// state). Existing local-only tasks ignore this field and are instead
  /// flipped to synced by the "Sync task" button.
  bool _syncOnSave = true;

  bool get _isEditing => widget.task != null;

  @override
  void initState() {
    super.initState();
    final task = widget.task;
    _titleController = TextEditingController(text: task?.title ?? '');
    _descriptionController = TextEditingController(
      text: task?.description ?? '',
    );
    _tagsController = TextEditingController(text: task?.tags.join(', ') ?? '');
    _dueDateLocal = task?.dueDateUtc?.toLocal();
    _priority = task?.priority;
    _color = task?.color;
    _reminders = task?.reminders ?? const [];
    _mirrorToCalendar = task?.mirrorToCalendar ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _pickDueDate() async {
    final now = DateTime.now();
    final initial = _dueDateLocal ?? now;
    // firstDate must never be after initialDate, or showDatePicker asserts —
    // an old overdue task can carry a due date well in the past.
    final earliest = DateTime(now.year - 1);
    final latest = DateTime(now.year + 10);
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: initial.isBefore(earliest) ? initial : earliest,
      lastDate: initial.isAfter(latest) ? initial : latest,
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    setState(() {
      final hadDueDate = _dueDateLocal != null;
      _dueDateLocal = DateTime(
        date.year,
        date.month,
        date.day,
        time?.hour ?? 23,
        time?.minute ?? 59,
      );
      // Setting a deadline for the first time is what makes a reminder
      // possible, so it comes with one rather than silently doing nothing.
      // Only on the first time: re-picking a date must not resurrect a
      // reminder the user deliberately removed.
      if (!hadDueDate && _reminders.isEmpty) {
        _reminders = const [Reminder.defaultReminder];
      }
    });
  }

  void _clearDueDate() {
    // Reminders count back from the deadline and the calendar entry needs a
    // day to sit on; neither survives its removal.
    setState(() {
      _dueDateLocal = null;
      _reminders = const [];
      _mirrorToCalendar = false;
    });
  }

  Future<void> _addReminder() async {
    final l = AppLocalizations.of(context);
    if (_reminders.length >= Reminder.maxPerTask) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.maxRemindersReached(Reminder.maxPerTask))),
      );
      return;
    }
    final chosen = await showModalBottomSheet<int>(
      context: context,
      builder: (sheetContext) => _ReminderPicker(
        alreadyChosen: _reminders.map((r) => r.minutesBefore).toSet(),
      ),
    );
    if (chosen == null || !mounted) return;
    setState(() {
      _reminders = [..._reminders, Reminder(minutesBefore: chosen)]
        ..sort((a, b) => b.minutesBefore.compareTo(a.minutesBefore));
    });
  }

  void _removeReminder(Reminder reminder) {
    setState(() {
      _reminders = _reminders.where((r) => r != reminder).toList();
    });
  }

  List<String> _parseTags() {
    return _tagsController.text
        .split(',')
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .take(Task.maxTags)
        .toSet()
        .toList(growable: false);
  }

  Future<void> _save({bool enableSync = false}) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);

    final notifier = ref.read(tasksProvider.notifier);
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final dueUtc = _dueDateLocal?.toUtc();
    final tags = _parseTags();

    try {
      if (_isEditing) {
        // The "Sync to Nostr" toggle only drives the save when the task was
        // syncing already; a local-only task is only ever lifted by the
        // explicit "Sync task" button ([enableSync]).
        final disableSync =
            !enableSync && !widget.task!.localOnly && !_syncOnSave;
        await notifier.updateFromEditor(
          widget.task!.copyWith(
            title: title,
            description: description.isEmpty ? null : description,
            clearDescription: description.isEmpty,
            dueDateUtc: dueUtc,
            clearDueDate: dueUtc == null,
            tags: tags,
            priority: _priority,
            clearPriority: _priority == null,
            color: _color,
            clearColor: _color == null,
            reminders: _reminders,
            mirrorToCalendar: _mirrorToCalendar,
          ),
          enableSync: enableSync,
          disableSync: disableSync,
        );
      } else {
        await notifier.createTask(
          title: title,
          description: description,
          dueDateUtc: dueUtc,
          tags: tags,
          priority: _priority,
          color: _color,
          localOnly: !_syncOnSave,
          reminders: _reminders,
          mirrorToCalendar: _mirrorToCalendar,
        );
      }
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      final l = AppLocalizations.of(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l.saveTaskError)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    final syncAvailable =
        ref.watch(authProvider).value != null &&
        (ref.watch(syncConfigProvider).value?.allSyncRelays.isNotEmpty ??
            false);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? l.editTaskTitle : l.newTaskTitle),
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l.saveButton),
          ),
        ],
      ),
      body: KairosAtmosphere(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              KairosSpacing.md,
              KairosSpacing.md,
              KairosSpacing.md,
              KairosSpacing.xl,
            ),
            children: [
              _buildTitleField(l),
              const SizedBox(height: KairosSpacing.sm),
              _buildDescriptionField(l),
              const SizedBox(height: KairosSpacing.lg),
              KairosGlassSurface(
                padding: const EdgeInsets.symmetric(
                  horizontal: KairosSpacing.sm,
                  vertical: KairosSpacing.xs,
                ),
                child: Column(
                  children: [
                    _buildDueDateTile(theme, l),
                    const Divider(),
                    _buildTagsField(l),
                    const SizedBox(height: KairosSpacing.sm),
                    _buildPrioritySection(theme, l),
                    const SizedBox(height: KairosSpacing.lg),
                    _buildColorSection(theme, l),
                    const SizedBox(height: KairosSpacing.lg),
                    _buildRemindersSection(theme, l),
                  ],
                ),
              ),
              ..._buildSyncControls(theme, l, syncAvailable: syncAvailable),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleField(AppLocalizations l) {
    return TextFormField(
      controller: _titleController,
      autofocus: !_isEditing,
      maxLength: Task.maxTitleLength,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: l.titleFieldLabel,
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        final title = value?.trim() ?? '';
        if (title.isEmpty) return l.titleRequiredError;
        if (title.length > Task.maxTitleLength) return l.titleTooLongError;
        return null;
      },
    );
  }

  Widget _buildDescriptionField(AppLocalizations l) {
    return TextFormField(
      controller: _descriptionController,
      minLines: 3,
      maxLines: 6,
      maxLength: Task.maxDescriptionLength,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: l.descriptionFieldLabel,
        border: const OutlineInputBorder(),
        alignLabelWithHint: true,
      ),
    );
  }

  /// Optional deadline stored in UTC and rendered in local time.
  Widget _buildDueDateTile(ThemeData theme, AppLocalizations l) {
    final due = _dueDateLocal;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.event_outlined),
      title: Text(
        due == null
            ? l.noDueDateLabel
            : DateFormat.yMMMd().add_Hm().format(due),
      ),
      subtitle: due == null
          ? Text(l.optionalDeadlineHint, style: theme.textTheme.bodySmall)
          : null,
      trailing: due == null
          ? null
          : IconButton(
              tooltip: l.clearDueDateTooltip,
              icon: const Icon(Icons.close),
              onPressed: _clearDueDate,
            ),
      onTap: _pickDueDate,
    );
  }

  Widget _buildTagsField(AppLocalizations l) {
    return TextFormField(
      controller: _tagsController,
      maxLength: Task.maxTagsInputLength,
      decoration: InputDecoration(
        labelText: l.tagsFieldLabel,
        hintText: l.tagsFieldHint,
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        final tags = (value ?? '')
            .split(',')
            .map((tag) => tag.trim())
            .where((tag) => tag.isNotEmpty)
            .toList();
        if (tags.length > Task.maxTags) return l.tooManyTagsError;
        if (tags.any((tag) => tag.length > Task.maxTagLength)) {
          return l.tagTooLongError;
        }
        return null;
      },
    );
  }

  Widget _buildPrioritySection(ThemeData theme, AppLocalizations l) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l.priorityLabel, style: theme.textTheme.titleSmall),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SegmentedButton<int?>(
            segments: [
              ButtonSegment(value: null, label: Text(l.noneLabel)),
              const ButtonSegment(value: 1, label: Text('1')),
              const ButtonSegment(value: 2, label: Text('2')),
              const ButtonSegment(value: 3, label: Text('3')),
              const ButtonSegment(value: 4, label: Text('4')),
              const ButtonSegment(value: 5, label: Text('5')),
            ],
            selected: {_priority},
            onSelectionChanged: (selection) =>
                setState(() => _priority = selection.first),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l.priorityScaleHint,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  /// Echoes-style color coding: a row of pastel swatches; the first slot is
  /// "no color" (theme surface).
  Widget _buildColorSection(ThemeData theme, AppLocalizations l) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l.colorLabel, style: theme.textTheme.titleSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _ColorSwatchOption(
              color: null,
              selected: _color == null,
              onTap: () => setState(() => _color = null),
            ),
            for (final color in TaskColor.values)
              _ColorSwatchOption(
                color: color,
                selected: _color == color,
                onTap: () => setState(() => _color = color),
              ),
          ],
        ),
      ],
    );
  }

  /// The task's reminders, as offsets before the due date.
  ///
  /// Without a due date there is nothing to count back from, so the section
  /// says so rather than offering a control that cannot work.
  Widget _buildRemindersSection(ThemeData theme, AppLocalizations l) {
    final hasDueDate = _dueDateLocal != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l.remindersLabel, style: theme.textTheme.titleSmall),
        const SizedBox(height: 8),
        if (!hasDueDate)
          Text(
            l.remindersNeedDueDate,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          )
        else ...[
          for (final reminder in _reminders)
            ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              leading: const Icon(Icons.notifications_active_outlined),
              title: Text(formatReminderOffset(l, reminder.minutesBefore)),
              trailing: IconButton(
                tooltip: l.removeReminderTooltip,
                icon: const Icon(Icons.close),
                onPressed: _saving ? null : () => _removeReminder(reminder),
              ),
            ),
          if (_reminders.isEmpty)
            Text(
              l.noneLabel,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: _saving ? null : _addReminder,
              icon: const Icon(Icons.add_alert_outlined),
              label: Text(l.addReminderButton),
            ),
          ),
        ],
      ],
    );
  }

  /// The Astraea calendar option: a dated task can reach Astraea immediately
  /// through the local bridge, and also gets the Nostr mirror when relays are
  /// available. A local-only task remains excluded from both paths.
  Widget _buildCalendarMirrorTile(ThemeData theme, AppLocalizations l) {
    // Reachable only while the task is (or will be) syncing — see
    // _buildSyncControls — so the live "Sync to Nostr" toggle is always the
    // right source of truth, for both a new task and an existing synced one.
    final available = _dueDateLocal != null && _syncOnSave;
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      secondary: const Icon(Icons.event_available_outlined),
      title: Text(l.addToCalendarTitle),
      subtitle: Text(
        available ? l.addToCalendarSubtitle : l.addToCalendarNeedsSync,
      ),
      value: available && _mirrorToCalendar,
      onChanged: !available || _saving
          ? null
          : (value) => setState(() => _mirrorToCalendar = value),
    );
  }

  /// Sync controls, only when sync can actually happen (account + at least
  /// one relay). A new task, or an existing task that is already syncing:
  /// a two-way "Sync to Nostr" toggle (off pins it local-only and — for an
  /// existing task — retracts its relay copy on save). An existing task
  /// pinned local-only: opt-in "Sync task" button that saves the current
  /// edits and publishes a posteriori. Only the button direction is a
  /// one-way door: an editor session cannot re-pin a task local-only and
  /// then change its mind back to "sync" without saving in between, since
  /// the button both flips the flag and saves immediately.
  List<Widget> _buildSyncControls(
    ThemeData theme,
    AppLocalizations l, {
    required bool syncAvailable,
  }) {
    final editingLocalOnly = _isEditing && widget.task!.localOnly;
    if (!editingLocalOnly) {
      final calendarTile = _buildCalendarMirrorTile(theme, l);
      if (!syncAvailable) {
        return [const SizedBox(height: 24), calendarTile];
      }
      return [
        const SizedBox(height: 24),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          secondary: const Icon(Icons.cloud_upload_outlined),
          title: Text(l.syncToNostrTitle),
          subtitle: Text(l.syncToNostrSubtitle),
          value: _syncOnSave,
          onChanged: _saving
              ? null
              : (value) => setState(() {
                  _syncOnSave = value;
                  // A task kept off the relays cannot be mirrored into a
                  // calendar that lives on them.
                  if (!value) _mirrorToCalendar = false;
                }),
        ),
        calendarTile,
      ];
    }
    if (!syncAvailable) return const [];
    return [
      const SizedBox(height: 24),
      FilledButton.tonalIcon(
        onPressed: _saving ? null : () => _save(enableSync: true),
        icon: const Icon(Icons.cloud_upload_outlined),
        label: Text(l.syncTaskButton),
      ),
      const SizedBox(height: 8),
      Text(
        l.syncToNostrSubtitle,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    ];
  }
}

/// Renders a reminder offset the way the user picked it: "at the due time",
/// or in whole minutes, hours or days — whichever the offset divides into
/// cleanly, so "1 day before" never shows up as "1440 minutes before".
///
/// Shared by the editor and the picker so the same offset is never worded two
/// different ways in the same screen.
String formatReminderOffset(AppLocalizations l, int minutesBefore) {
  if (minutesBefore <= 0) return l.reminderAtDueTime;
  if (minutesBefore % 1440 == 0) {
    return l.reminderDaysBefore(minutesBefore ~/ 1440);
  }
  if (minutesBefore % 60 == 0) {
    return l.reminderHoursBefore(minutesBefore ~/ 60);
  }
  return l.reminderMinutesBefore(minutesBefore);
}

/// Bottom sheet offering the preset reminder offsets. Offsets already on the
/// task are shown ticked and are not selectable again — two identical
/// reminders would just schedule the same notification twice.
class _ReminderPicker extends StatelessWidget {
  const _ReminderPicker({required this.alreadyChosen});

  final Set<int> alreadyChosen;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return SafeArea(
      child: ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              l.addReminderButton,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          for (final minutes in Reminder.presetsMinutes)
            ListTile(
              enabled: !alreadyChosen.contains(minutes),
              leading: Icon(
                alreadyChosen.contains(minutes)
                    ? Icons.check
                    : Icons.notifications_outlined,
              ),
              title: Text(formatReminderOffset(l, minutes)),
              onTap: () => Navigator.of(context).pop(minutes),
            ),
        ],
      ),
    );
  }
}

/// One tappable swatch: a colored circle (or a crossed-out one for "no
/// color"), ringed with the primary color when selected — the same picker
/// affordance Echoes uses for note colors.
class _ColorSwatchOption extends StatelessWidget {
  const _ColorSwatchOption({
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final TaskColor? color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final background =
        color?.background ?? theme.colorScheme.surfaceContainerHighest;

    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: background,
          shape: BoxShape.circle,
          border: Border.all(
            color: selected
                ? theme.colorScheme.primary
                : theme.colorScheme.outlineVariant,
            width: selected ? 3 : 1,
          ),
        ),
        child: color == null
            ? Icon(
                Icons.format_color_reset_outlined,
                size: 20,
                color: theme.colorScheme.onSurfaceVariant,
              )
            : selected
            ? Icon(
                Icons.check,
                size: 20,
                color: readableTextColorOn(background),
              )
            : null,
      ),
    );
  }
}
