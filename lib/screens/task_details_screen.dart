import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';
import '../models/task_model.dart';
import '../providers/tasks_provider.dart';
import '../utils/task_colors.dart';
import 'task_editor_screen.dart';

/// Read view of a single task, with quick actions: toggle done, edit
/// (pushes [TaskEditorScreen]), delete. Watches the provider by [taskId] so
/// it live-updates when a sync cycle or the editor changes the task
/// underneath it.
class TaskDetailsScreen extends ConsumerWidget {
  const TaskDetailsScreen({super.key, required this.taskId});

  final String taskId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    final task = ref.watch(
      tasksProvider.select(
        (state) => state.value?.where((t) => t.id == taskId).firstOrNull,
      ),
    );

    // Deleted underneath us (sync or our own delete action): nothing to show.
    if (task == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l.taskGoneMessage)),
      );
    }

    final due = task.dueDateUtc?.toLocal();

    return Scaffold(
      appBar: AppBar(
        title: Text(l.taskDetailsTitle),
        actions: [
          IconButton(
            tooltip: l.editTooltip,
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => TaskEditorScreen(task: task)),
            ),
          ),
          IconButton(
            tooltip: l.deleteTooltip,
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _confirmDelete(context, ref, task, l),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: task.isDone,
                shape: const CircleBorder(),
                onChanged: (_) =>
                    ref.read(tasksProvider.notifier).toggleStatus(task),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  task.title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    decoration: task.isDone ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (task.description != null) ...[
            Text(task.description!, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 24),
          ],
          _DetailRow(
            icon: Icons.event_outlined,
            label: l.dueDateLabel,
            value: due == null
                ? l.noneLabel
                : DateFormat.yMMMd().add_Hm().format(due),
          ),
          _DetailRow(
            icon: Icons.label_outline,
            label: l.tagsLabel,
            value: task.tags.isEmpty ? l.noneLabel : task.tags.join(', '),
          ),
          _DetailRow(
            icon: Icons.flag_outlined,
            label: l.priorityLabel,
            value: task.priority == null
                ? l.noneLabel
                : l.priorityValue(task.priority!),
          ),
          if (task.color != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.palette_outlined,
                    size: 20,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 130,
                    child: Text(
                      l.colorLabel,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: task.color!.background,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.colorScheme.outlineVariant,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(task.color!.name, style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
          _DetailRow(
            icon: task.localOnly
                ? Icons.smartphone
                : task.synced
                ? Icons.cloud_done_outlined
                : Icons.cloud_off_outlined,
            label: l.syncStatusLabel,
            value: task.localOnly
                ? l.localOnlyStatus
                : task.synced
                ? l.syncedStatus
                : l.notSyncedStatus,
          ),
          if (task.linkedEventId != null)
            _DetailRow(
              icon: Icons.link,
              label: l.linkedEventLabel,
              value: task.linkedEventId!,
            ),
          const Divider(height: 32),
          Text(
            l.createdUpdatedInfo(
              DateFormat.yMMMd().add_Hm().format(task.createdAt.toLocal()),
              DateFormat.yMMMd().add_Hm().format(task.updatedAt.toLocal()),
            ),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    Task task,
    AppLocalizations l,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l.deleteTaskConfirmTitle),
        content: Text(l.deleteTaskConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l.cancelButton),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l.deleteButton),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await ref.read(tasksProvider.notifier).delete(task);
      if (context.mounted) Navigator.of(context).pop();
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l.deleteTaskError)));
    }
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 16),
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(child: Text(value, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
