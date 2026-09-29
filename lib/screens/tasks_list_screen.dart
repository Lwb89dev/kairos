import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';
import '../models/task_model.dart';
import '../providers/sync_mode_provider.dart';
import '../providers/tasks_provider.dart';
import '../utils/constants.dart';
import '../utils/kairos_theme.dart';
import '../utils/task_colors.dart';
import 'widgets/kairos_glass.dart';
import 'settings_screen.dart';
import 'task_details_screen.dart';
import 'task_editor_screen.dart';

/// Home screen: the task list. Pending tasks first (due-dated ones sorted to
/// the top by the storage layer), completed ones collapsed below. Each task
/// is a gloss sheet on the desk — the same card an opened task becomes.
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
      if (!mounted) return;
      final notifier = ref.read(tasksProvider.notifier);
      notifier.syncNow();
      // Pending alarms are OS state and can vanish without the app being
      // told (app update, cleared data, a permission granted later, a task
      // that arrived from another device). Rebuild them on every open.
      notifier.rescheduleReminders();
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
        title: Text(
          AppConstants.appName,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
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
          color: Theme.of(context).colorScheme.primary,
          onRefresh: () =>
              ref.read(tasksProvider.notifier).syncNow(userInitiated: true),
          child: tasks.isEmpty ? const _EmptyState() : _TaskList(tasks: tasks),
        ),
      ),
      floatingActionButton: KairosFloatingActionButton(
        tooltip: l.newTaskTooltip,
        onPressed: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const TaskEditorScreen())),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    // Inside a ListView so RefreshIndicator still works on the empty state.
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 96),
        Center(
          child: KairosGlassSurface(
            margin: const EdgeInsets.symmetric(horizontal: KairosSpacing.lg),
            padding: const EdgeInsets.all(KairosSpacing.xl),
            child: Column(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 56,
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
            ),
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
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 104),
      itemCount: pending.length + headerRows + completedRows,
      itemBuilder: (context, index) {
        if (index < pending.length) return _TaskTile(task: pending[index]);
        if (index == pending.length) {
          return KairosSectionHeader(
            title: l.completedCount(done.length),
            trailing: IconButton(
              tooltip: l.completedCount(done.length),
              icon: Icon(
                _showCompleted ? Icons.expand_less : Icons.expand_more,
              ),
              onPressed: () => setState(() => _showCompleted = !_showCompleted),
            ),
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        KairosSpacing.md,
        0,
        KairosSpacing.md,
        KairosSpacing.sm,
      ),
      child: KairosGlassSurface(
        tint: task.color?.background,
        child: Builder(builder: (context) => _face(context, ref)),
      ),
    );
  }

  Widget _face(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final due = task.dueDateUtc?.toLocal();
    final overdue = due != null && !task.isDone && due.isBefore(DateTime.now());
    final muted = theme.colorScheme.onSurfaceVariant;
    final tinted = task.color != null;
    final dueColor = overdue && !tinted ? theme.colorScheme.error : muted;

    return InkWell(
      borderRadius: BorderRadius.circular(KairosRadii.md),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => TaskDetailsScreen(taskId: task.id)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 4, 10, 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            KairosCompletionControl(
              value: task.isDone,
              semanticLabel: task.title,
              onChanged: (_) =>
                  ref.read(tasksProvider.notifier).toggleStatus(task),
            ),
            Expanded(child: _copy(theme, muted, due, dueColor, l)),
            _trailing(theme, muted, tinted),
          ],
        ),
      ),
    );
  }

  Widget _copy(
    ThemeData theme,
    Color muted,
    DateTime? due,
    Color dueColor,
    AppLocalizations l,
  ) {
    final metadata = _metadata(due, dueColor, muted, l.addToCalendarTitle);
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            task.title,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: task.isDone ? muted : theme.colorScheme.onSurface,
              decoration: task.isDone ? TextDecoration.lineThrough : null,
              decorationColor: muted,
            ),
          ),
          if (metadata.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Wrap(spacing: 10, runSpacing: 3, children: metadata),
            ),
        ],
      ),
    );
  }

  List<Widget> _metadata(
    DateTime? due,
    Color dueColor,
    Color muted,
    String calendarLabel,
  ) {
    return [
      if (due != null)
        _MetaItem(
          icon: Icons.schedule_outlined,
          text: DateFormat.yMMMd().add_Hm().format(due),
          color: dueColor,
        ),
      if (task.tags.isNotEmpty)
        _MetaItem(
          icon: Icons.sell_outlined,
          text: task.tags.join(' · '),
          color: muted,
        ),
      if (task.reminders.isNotEmpty)
        _MetaItem(
          icon: Icons.notifications_none_rounded,
          text: '${task.reminders.length}',
          color: muted,
        ),
      if (task.mirrorToCalendar)
        _MetaItem(
          icon: Icons.event_available_outlined,
          text: calendarLabel,
          color: muted,
        ),
    ];
  }

  Widget _trailing(ThemeData theme, Color muted, bool tinted) {
    final priority = task.priority;
    final priorityColor = priority != null && priority >= 4 && !tinted
        ? theme.colorScheme.error
        : muted;
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (priority != null)
            Icon(
              priority >= 4 ? Icons.flag_rounded : Icons.flag_outlined,
              size: 17,
              color: priorityColor,
            ),
          if (!task.localOnly)
            Padding(
              padding: const EdgeInsets.only(left: 7),
              child: Icon(
                task.synced
                    ? Icons.cloud_done_outlined
                    : Icons.cloud_off_outlined,
                size: 17,
                color: task.synced ? theme.colorScheme.primary : muted,
              ),
            ),
        ],
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  const _MetaItem({
    required this.icon,
    required this.text,
    required this.color,
  });

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 4),
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color),
        ),
      ],
    );
  }
}
