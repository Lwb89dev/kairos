import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';
import '../models/task_model.dart';
import '../providers/sync_mode_provider.dart';
import '../providers/tasks_provider.dart';
import '../utils/constants.dart';
import '../utils/task_colors.dart';
import 'settings_screen.dart';
import 'task_details_screen.dart';
import 'task_editor_screen.dart';

/// Home screen: the task list. Pending tasks first (due-dated ones sorted to
/// the top by the storage layer), completed ones collapsed below — the
/// Google-Tasks layout. Tasks carry their Echoes-style color coding as card
/// backgrounds.
///
/// Sync-on-entry: a relay sync cycle fires when this screen first mounts
/// (covers both the very first access and every cold app start) and again
/// every time the app returns to the foreground, so the list is always as
/// fresh as the relays allow. The thin progress bar under the app bar shows
/// while a cycle is in flight; pull-to-refresh triggers one manually too.
class TasksListScreen extends ConsumerStatefulWidget {
  const TasksListScreen({super.key});

  @override
  ConsumerState<TasksListScreen> createState() => _TasksListScreenState();
}

class _TasksListScreenState extends ConsumerState<TasksListScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // On-entry sync. Post-frame so the first build (local Hive data) is
    // never blocked by the relay round-trip.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) ref.read(tasksProvider.notifier).syncNow();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Re-entering the app (from background) re-syncs, same as a fresh open.
    if (state == AppLifecycleState.resumed) {
      ref.read(tasksProvider.notifier).syncNow();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final tasksState = ref.watch(tasksProvider);
    final config = ref.watch(syncConfigProvider).value;
    final syncing = ref.watch(syncActivityProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          if (config != null && config.allSyncRelays.isNotEmpty)
            IconButton(
              tooltip: l.syncNowTooltip,
              icon: const Icon(Icons.sync),
              onPressed: syncing
                  ? null
                  : () => ref
                        .read(tasksProvider.notifier)
                        .syncNow(userInitiated: true),
            ),
          IconButton(
            tooltip: l.settingsTooltip,
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const SettingsScreen())),
          ),
        ],
        bottom: syncing
            ? const PreferredSize(
                preferredSize: Size.fromHeight(3),
                child: LinearProgressIndicator(minHeight: 3),
              )
            : null,
      ),
      body: tasksState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(child: Text(l.loadTasksError)),
        data: (tasks) => RefreshIndicator(
          onRefresh: () =>
              ref.read(tasksProvider.notifier).syncNow(userInitiated: true),
          child: tasks.isEmpty ? const _EmptyState() : _TaskList(tasks: tasks),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: l.newTaskTooltip,
        onPressed: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const TaskEditorScreen())),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    // Inside a ListView so RefreshIndicator still works on the empty state.
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 120),
        Icon(
          Icons.check_circle_outline,
          size: 64,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(height: 16),
        Text(
          l.emptyTasksTitle,
          textAlign: TextAlign.center,
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Text(
          l.emptyTasksBody,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _TaskList extends StatefulWidget {
  const _TaskList({required this.tasks});

  final List<Task> tasks;

  @override
  State<_TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<_TaskList> {
  bool _showCompleted = false;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final pending = widget.tasks.where((t) => !t.isDone).toList();
    final done = widget.tasks.where((t) => t.isDone).toList();
    final completedRows = _showCompleted ? done.length : 0;
    final headerRows = done.isEmpty ? 0 : 1;

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(
        bottom: 88,
      ), // Keep the FAB off the last tile.
      itemCount: pending.length + headerRows + completedRows,
      itemBuilder: (context, index) {
        if (index < pending.length) return _TaskTile(task: pending[index]);
        if (index == pending.length) {
          return ListTile(
            title: Text(l.completedCount(done.length)),
            trailing: Icon(
              _showCompleted ? Icons.expand_less : Icons.expand_more,
            ),
            onTap: () => setState(() => _showCompleted = !_showCompleted),
          );
        }
        return _TaskTile(task: done[index - pending.length - 1]);
      },
    );
  }
}

class _TaskTile extends ConsumerWidget {
  const _TaskTile({required this.task});

  final Task task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final due = task.dueDateUtc?.toLocal();
    final overdue = due != null && !task.isDone && due.isBefore(DateTime.now());

    // Echoes-style per-task color coding: the card takes the task's own
    // pastel background and the text/icon colors are derived for contrast
    // (see task_colors.dart). Uncolored tasks keep the theme surface.
    final background = task.color?.background;
    final onBackground = background != null
        ? readableTextColorOn(background)
        : null;
    final muted = background != null
        ? mutedTextColorOn(background)
        : theme.colorScheme.onSurfaceVariant;

    return Card(
      color: background,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: Checkbox(
          value: task.isDone,
          shape: const CircleBorder(),
          side: onBackground != null
              ? BorderSide(color: onBackground, width: 2)
              : null,
          onChanged: (_) => ref.read(tasksProvider.notifier).toggleStatus(task),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            color: task.isDone ? muted : onBackground,
            decoration: task.isDone ? TextDecoration.lineThrough : null,
            decorationColor: muted,
          ),
        ),
        subtitle: _subtitle(theme, due, overdue, muted),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (task.priority != null && task.priority! >= 4)
              Icon(
                Icons.priority_high,
                size: 18,
                color: theme.colorScheme.error,
              ),
            // A deliberately local-only task is not "pending sync", so it
            // gets no cloud badge at all instead of a misleading cloud-off.
            if (!task.localOnly)
              Icon(
                task.synced
                    ? Icons.cloud_done_outlined
                    : Icons.cloud_off_outlined,
                size: 18,
                color: task.synced
                    ? (onBackground ?? theme.colorScheme.primary)
                    : muted,
              ),
          ],
        ),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => TaskDetailsScreen(taskId: task.id)),
        ),
      ),
    );
  }

  Widget? _subtitle(ThemeData theme, DateTime? due, bool overdue, Color muted) {
    final parts = <String>[
      if (due != null) DateFormat.yMMMd().add_Hm().format(due),
      if (task.tags.isNotEmpty) task.tags.join(' · '),
    ];
    if (parts.isEmpty) return null;
    return Text(
      parts.join('  —  '),
      style: theme.textTheme.bodySmall?.copyWith(
        color: overdue ? theme.colorScheme.error : muted,
      ),
    );
  }
}
