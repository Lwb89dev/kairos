import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';
import '../models/task_model.dart';
import '../providers/auth_provider.dart';
import '../providers/sync_mode_provider.dart';
import '../providers/tasks_provider.dart';
import '../utils/task_colors.dart';

/// Create/edit form: title (required), description, due date+time, tags,
/// priority. Pass [task] to edit; otherwise a new task is created on save.
/// Saving is offline-first — the screen never blocks on the network; sync
/// publication happens best-effort after the local write.
///
/// When sync is available (account + at least one relay), a new task gets a
/// "Sync to Nostr" toggle — off pins it to this device ([Task.localOnly]) —
/// and an existing local-only task gets a "Sync task" button that saves the
/// current edits and lifts the pin, publishing it a posteriori.
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

  /// New tasks: driven by the "Sync to Nostr" toggle (defaults to on).
  /// Existing local-only tasks: flipped to true by the "Sync task" button.
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
      _dueDateLocal = DateTime(
        date.year,
        date.month,
        date.day,
        time?.hour ?? 23,
        time?.minute ?? 59,
      );
    });
  }

  List<String> _parseTags() {
    return _tagsController.text
        .split(',')
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .take(32)
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
          ),
          enableSync: enableSync,
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
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              autofocus: !_isEditing,
              maxLength: 512,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: l.titleFieldLabel,
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                final title = value?.trim() ?? '';
                if (title.isEmpty) return l.titleRequiredError;
                if (title.length > 512) return l.titleTooLongError;
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              minLines: 3,
              maxLines: 6,
              maxLength: 16384,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: l.descriptionFieldLabel,
                border: const OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 16),

            // Optional deadline stored in UTC and rendered in local time.
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.event_outlined),
              title: Text(
                _dueDateLocal == null
                    ? l.noDueDateLabel
                    : DateFormat.yMMMd().add_Hm().format(_dueDateLocal!),
              ),
              subtitle: _dueDateLocal == null
                  ? Text(
                      l.optionalDeadlineHint,
                      style: theme.textTheme.bodySmall,
                    )
                  : null,
              trailing: _dueDateLocal == null
                  ? null
                  : IconButton(
                      tooltip: l.clearDueDateTooltip,
                      icon: const Icon(Icons.close),
                      onPressed: () => setState(() => _dueDateLocal = null),
                    ),
              onTap: _pickDueDate,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _tagsController,
              maxLength: 2079,
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
                if (tags.length > 32) return l.tooManyTagsError;
                if (tags.any((tag) => tag.length > 64)) {
                  return l.tagTooLongError;
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

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
            const SizedBox(height: 24),

            // Echoes-style color coding: a row of pastel swatches; the first
            // slot is "no color" (theme surface).
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

            // Sync controls, only when sync can actually happen (account +
            // at least one relay). New task: opt-out toggle. Existing task
            // pinned local-only: opt-in "Sync task" button that saves the
            // current edits and publishes a posteriori.
            if (syncAvailable && !_isEditing) ...[
              const SizedBox(height: 24),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                secondary: const Icon(Icons.cloud_upload_outlined),
                title: Text(l.syncToNostrTitle),
                subtitle: Text(l.syncToNostrSubtitle),
                value: _syncOnSave,
                onChanged: _saving
                    ? null
                    : (value) => setState(() => _syncOnSave = value),
              ),
            ] else if (syncAvailable &&
                _isEditing &&
                widget.task!.localOnly) ...[
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
            ],
          ],
        ),
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
