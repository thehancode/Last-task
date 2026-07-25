import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/ui_mode.dart';
import '../../domain/models.dart';
import '../../l10n/app_localizations.dart';
import '../terminal_style.dart';
import '../workspace_view_model.dart';
import 'workspace_dialogs.dart';
import 'workspace_presenters.dart';
import 'workspace_task_visibility.dart';

Color _tagColor(BuildContext context, TaskTag tag) => switch (tag) {
  TaskTag.spade => TerminalPalette.of(context).accent,
  TaskTag.heart => TerminalPalette.of(context).done,
  TaskTag.club => TerminalPalette.of(context).error,
  TaskTag.diamond => TerminalPalette.of(context).pending,
};

class WorkspaceTaskRow extends ConsumerWidget {
  const WorkspaceTaskRow({
    super.key,
    required this.task,
    required this.state,
    this.completedAt,
  });
  final Task task;
  final WorkspaceState state;
  final DateTime? completedAt;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final terminal = usesTerminalPresentation;
    final list = state.lists.firstWhere(
      (candidate) => candidate.tasks.any((item) => item.id == task.id),
    );
    final depth = taskDepth(list, task);
    final hasChildren = taskHasChildren(list, task);
    final selected = task.id == state.selectedTaskId;
    final visibleTaskIds = selected ? state.visibleTaskIds : const <String>[];
    final done = task.status == TaskStatus.done;
    final archived = task.status == TaskStatus.archived;
    final animated = task.id == state.animatedTaskId;
    final highlighted = state.highlightedTaskIds.contains(task.id);
    final search = state.search;
    final title = _TaskTitle(
      value: task.title,
      selected: selected,
      display: state.search == null
          ? state.settings.longTitleDisplay
          : LongTitleDisplay.wrapAll,
      speed: state.settings.marqueeSpeedMs,
      searchQuery: search?.query,
      currentSearchMatch: search?.currentTaskId == task.id,
      style: TextStyle(
        color: selected
            ? TerminalPalette.of(context).background
            : done || archived
            ? TerminalPalette.of(context).muted
            : TerminalPalette.of(context).text,
        fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        decoration: done || archived ? TextDecoration.lineThrough : null,
      ),
    );
    final row = Semantics(
      selected: selected,
      button: true,
      label: AppLocalizations.of(context)!.taskSemantics(
        workspaceStatusLabel(task.status, AppLocalizations.of(context)!),
        task.title,
        task.tags.isEmpty
            ? ''
            : AppLocalizations.of(context)!.taskTagsSemantics(
                task.tags.map(state.settings.tagNames.nameFor).join(', '),
              ),
      ),
      child: Listener(
        onPointerDown: (_) =>
            ref.read(workspaceViewModelProvider.notifier).selectTask(task.id),
        child: InkWell(
          onTap: () =>
              ref.read(workspaceViewModelProvider.notifier).selectTask(task.id),
          onDoubleTap: () async {
            final vm = ref.read(workspaceViewModelProvider.notifier);
            final message = AppLocalizations.of(context)!.taskWasCopied;
            vm.selectTask(task.id);
            await Clipboard.setData(ClipboardData(text: task.title));
            vm.showNotice(message);
          },
          borderRadius: terminal ? BorderRadius.zero : BorderRadius.circular(5),
          child: AnimatedContainer(
            constraints: const BoxConstraints(),
            duration: terminal
                ? Duration.zero
                : const Duration(milliseconds: 220),
            margin: EdgeInsets.symmetric(vertical: terminal ? 0 : 2),
            padding: EdgeInsets.symmetric(
              horizontal: terminal ? 0 : 8,
              vertical: terminal ? 1 : 9,
            ).add(EdgeInsets.only(left: terminal ? 0 : depth * 16.0)),
            decoration: BoxDecoration(
              color: highlighted
                  ? TerminalPalette.of(context).accent
                  : animated
                  ? workspaceStatusColor(context, task.status)
                  : selected
                  ? TerminalPalette.of(context).accent
                  : Colors.transparent,
              borderRadius: terminal
                  ? BorderRadius.zero
                  : BorderRadius.circular(5),
              border: null,
            ),
            // The selected row supplies the violet background across its full
            // measured height, including the tag columns.
            child: Row(
              children: [
                Text(
                  '${terminal ? '  ' * depth : ''}${hasChildren ? (task.collapsed ? '▸ ' : '▾ ') : (selected ? '› ' : '- ')}',
                  style: TextStyle(
                    color: selected
                        ? TerminalPalette.of(context).background
                        : TerminalPalette.of(context).muted,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(child: title),
                _TaskTags(task: task, selected: selected),
                if (task.daily)
                  terminal
                      ? Text(
                          ' ↻',
                          style: TextStyle(
                            color: selected
                                ? TerminalPalette.of(context).background
                                : TerminalPalette.of(context).done,
                          ),
                        )
                      : Icon(
                          Icons.repeat,
                          size: 16,
                          color: selected
                              ? TerminalPalette.of(context).background
                              : TerminalPalette.of(context).done,
                        ),
                if (completedAt != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      workspaceLocalStamp(completedAt!),
                      style: TextStyle(
                        color: selected
                            ? TerminalPalette.of(context).background
                            : TerminalPalette.of(context).muted,
                        fontSize: terminal ? null : 12,
                      ),
                    ),
                  ),
                if (completedAt == null &&
                    !terminal &&
                    !(task.parentId != null && task.status == TaskStatus.done))
                  IconButton(
                    tooltip: AppLocalizations.of(context)!.advanceTask,
                    color: selected
                        ? TerminalPalette.of(context).background
                        : workspaceStatusColor(context, task.status),
                    onPressed: () {
                      ref
                          .read(workspaceViewModelProvider.notifier)
                          .selectTask(task.id);
                      unawaited(
                        ref
                            .read(workspaceViewModelProvider.notifier)
                            .advanceSelectedTask(),
                      );
                    },
                    icon: const Icon(Icons.play_arrow),
                  ),
                if (!terminal)
                  PopupMenuButton<String>(
                    tooltip: AppLocalizations.of(context)!.taskActions,
                    icon: Icon(
                      Icons.more_vert,
                      color: selected
                          ? TerminalPalette.of(context).background
                          : TerminalPalette.of(context).muted,
                    ),
                    onSelected: (action) =>
                        _handleTaskAction(context, ref, task, action),
                    itemBuilder: (_) => [
                      if (task.parentId == null &&
                          task.status == TaskStatus.done)
                        PopupMenuItem(
                          value: 'revert',
                          child: Text(
                            AppLocalizations.of(context)!.reopenInDoing,
                          ),
                        ),
                      if (task.status != TaskStatus.done &&
                          depth + 1 < maxTaskDepth)
                        PopupMenuItem(
                          value: 'subtask',
                          child: Text(AppLocalizations.of(context)!.newSubtask),
                        ),
                      if (hasChildren)
                        PopupMenuItem(
                          value: 'collapse',
                          child: Text(
                            task.collapsed
                                ? AppLocalizations.of(context)!.expandSubtasks
                                : AppLocalizations.of(
                                    context,
                                  )!.collapseSubtasks,
                          ),
                        ),
                      PopupMenuItem(
                        value: 'edit',
                        child: Text(AppLocalizations.of(context)!.edit),
                      ),
                      if (!hasChildren)
                        PopupMenuItem(
                          value: 'duplicate',
                          child: Text(AppLocalizations.of(context)!.duplicate),
                        ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Text(AppLocalizations.of(context)!.delete),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
    final interactiveRow =
        !kIsWeb && defaultTargetPlatform == TargetPlatform.android
        ? _AndroidTagSwipe(taskId: task.id, child: row)
        : row;
    return WorkspaceKeepSelectedTaskVisible(
      selected: selected,
      first: visibleTaskIds.isNotEmpty && visibleTaskIds.first == task.id,
      last: visibleTaskIds.isNotEmpty && visibleTaskIds.last == task.id,
      child: interactiveRow,
    );
  }
}

class _TaskTags extends StatelessWidget {
  const _TaskTags({required this.task, required this.selected});
  final Task task;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final terminal = usesTerminalPresentation;
    final cell = TerminalMetrics.cell(context);
    final cells = task.tags.length < 2 ? 2 : task.tags.length;
    return SizedBox(
      key: ValueKey('task-tags-${task.id}'),
      width: cell * cells,
      child: ColoredBox(
        color: terminal && selected && task.tags.isNotEmpty
            ? TerminalPalette.of(context).accent
            : Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            for (final tag in task.tags)
              SizedBox(
                width: cell,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    tag.glyph,
                    style: TextStyle(
                      color: terminal && selected
                          ? TerminalPalette.of(context).background
                          : _tagColor(context, tag),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _AndroidTagSwipe extends ConsumerStatefulWidget {
  const _AndroidTagSwipe({required this.taskId, required this.child});
  final String taskId;
  final Widget child;

  @override
  ConsumerState<_AndroidTagSwipe> createState() => _AndroidTagSwipeState();
}

class _AndroidTagSwipeState extends ConsumerState<_AndroidTagSwipe> {
  double _distance = 0;

  void _finish(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    final shouldCycle = _distance.abs() >= 48 || velocity.abs() >= 450;
    final left = _distance == 0 ? velocity < 0 : _distance < 0;
    _distance = 0;
    if (!shouldCycle) return;
    final vm = ref.read(workspaceViewModelProvider.notifier);
    vm.selectTask(widget.taskId);
    unawaited(vm.cycleSelectedTag(left ? 0 : 1));
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
    behavior: HitTestBehavior.translucent,
    onHorizontalDragStart: (_) => _distance = 0,
    onHorizontalDragUpdate: (details) => _distance += details.delta.dx,
    onHorizontalDragEnd: _finish,
    onHorizontalDragCancel: () => _distance = 0,
    child: widget.child,
  );
}

class WorkspaceEmptyState extends StatelessWidget {
  const WorkspaceEmptyState(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Text(
        '· $text',
        style: TextStyle(color: TerminalPalette.of(context).muted),
      ),
    ),
  );
}

class _TaskTitle extends StatefulWidget {
  const _TaskTitle({
    required this.value,
    required this.selected,
    required this.display,
    required this.speed,
    required this.style,
    this.searchQuery,
    this.currentSearchMatch = false,
  });
  final String value;
  final bool selected;
  final LongTitleDisplay display;
  final int speed;
  final TextStyle style;
  final String? searchQuery;
  final bool currentSearchMatch;

  @override
  State<_TaskTitle> createState() => _TaskTitleState();
}

class _TaskTitleState extends State<_TaskTitle> {
  static const _marqueeSeparator = '  ▢  ';
  static const _marqueeFrameInterval = Duration(milliseconds: 16);
  static const _marqueeStartDelay = Duration(milliseconds: 900);

  Timer? _timer;
  Timer? _marqueeStartTimer;
  final _marqueeScrollController = ScrollController();
  var _marqueeOffset = 0.0;
  var _available = 0;

  @override
  void initState() {
    super.initState();
    _configureTimer();
  }

  @override
  void didUpdateWidget(covariant _TaskTitle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selected != widget.selected ||
        oldWidget.display != widget.display ||
        oldWidget.speed != widget.speed) {
      _marqueeOffset = 0;
      _configureTimer(resetMarquee: true);
    }
  }

  void _configureTimer({bool resetMarquee = false}) {
    _timer?.cancel();
    _marqueeStartTimer?.cancel();
    if (!widget.selected || _available == 0) return;
    if (widget.display == LongTitleDisplay.marquee) {
      final length = widget.value
          .replaceAll(RegExp(r'[\r\n]+'), ' ')
          .characters
          .length;
      final cycleWidth =
          (length + _marqueeSeparator.characters.length) *
          TerminalMetrics.cell(context);
      if (resetMarquee) _marqueeOffset = 0;
      _marqueeStartTimer = Timer(_marqueeStartDelay, () {
        if (!mounted ||
            !widget.selected ||
            widget.display != LongTitleDisplay.marquee) {
          return;
        }
        _timer = Timer.periodic(_marqueeFrameInterval, (_) {
          if (!mounted) return;
          setState(() {
            _marqueeOffset =
                (_marqueeOffset +
                    _marqueeFrameInterval.inMilliseconds *
                        TerminalMetrics.cell(context) /
                        widget.speed) %
                cycleWidth;
          });
          if (_marqueeScrollController.hasClients) {
            _marqueeScrollController.jumpTo(_marqueeOffset);
          }
        });
      });
      return;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _marqueeStartTimer?.cancel();
    _marqueeScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.display == LongTitleDisplay.wrapAll ||
        (widget.display == LongTitleDisplay.wrapSelected && widget.selected)) {
      return _searchHighlightedTitle(context, widget.value, widget.style);
    }
    return LayoutBuilder(
      builder: (_, constraints) {
        final source = widget.value.replaceAll(RegExp(r'[\r\n]+'), ' ');
        final characters = source.characters.toList(growable: false);
        final available = (constraints.maxWidth / TerminalMetrics.cell(context))
            .floor()
            .clamp(1, 10000)
            .toInt();
        if (_available != available) {
          _available = available;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _configureTimer(resetMarquee: true);
          });
        }
        if (!widget.selected ||
            characters.length <= available ||
            characters.length <= 12) {
          return Text(
            source,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: widget.style,
          );
        }
        if (widget.display == LongTitleDisplay.marquee) {
          final loop = [...characters, ..._marqueeSeparator.characters].join();
          return SizedBox(
            width: constraints.maxWidth,
            child: SingleChildScrollView(
              key: const ValueKey('marquee-title'),
              controller: _marqueeScrollController,
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(loop, maxLines: 1, softWrap: false, style: widget.style),
                  Text(loop, maxLines: 1, softWrap: false, style: widget.style),
                ],
              ),
            ),
          );
        }
        return Text(
          source,
          maxLines: 1,
          overflow: TextOverflow.clip,
          style: widget.style,
        );
      },
    );
  }

  Widget _searchHighlightedTitle(
    BuildContext context,
    String value,
    TextStyle style,
  ) {
    final query = widget.searchQuery;
    if (query == null || query.isEmpty) return Text(value, style: style);
    final lower = value.toLowerCase();
    final needle = query.toLowerCase();
    final spans = <InlineSpan>[];
    var start = 0;
    while (start < value.length) {
      final match = lower.indexOf(needle, start);
      if (match < 0) {
        spans.add(TextSpan(text: value.substring(start)));
        break;
      }
      if (match > start) {
        spans.add(TextSpan(text: value.substring(start, match)));
      }
      spans.add(
        TextSpan(
          text: value.substring(match, match + needle.length),
          style: style.copyWith(
            color: TerminalPalette.of(context).background,
            backgroundColor: widget.currentSearchMatch
                ? TerminalPalette.of(context).pending
                : TerminalPalette.of(context).doing,
          ),
        ),
      );
      start = match + needle.length;
    }
    return Text.rich(TextSpan(style: style, children: spans));
  }
}

EdgeInsetsGeometry? get _dialogTitlePadding =>
    usesTerminalPresentation ? const EdgeInsets.fromLTRB(10, 8, 10, 0) : null;

EdgeInsetsGeometry? get _dialogContentPadding =>
    usesTerminalPresentation ? const EdgeInsets.fromLTRB(10, 8, 10, 8) : null;

Future<void> _handleTaskAction(
  BuildContext context,
  WidgetRef ref,
  Task task,
  String action,
) async {
  final vm = ref.read(workspaceViewModelProvider.notifier);
  vm.selectTask(task.id);
  if (action == 'collapse') {
    await vm.toggleSelectedCollapsed();
    return;
  }
  if (action == 'revert') {
    await vm.revertSelectedCompletedTask();
    return;
  }
  if (action == 'delete') {
    final delete =
        await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            titlePadding: _dialogTitlePadding,
            contentPadding: _dialogContentPadding,
            title: Text(
              AppLocalizations.of(context)!.deleteTaskTitle,
              style: TextStyle(color: TerminalPalette.of(context).error),
            ),
            content: Text(AppLocalizations.of(context)!.deleteTaskBody),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(AppLocalizations.of(context)!.cancel),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(AppLocalizations.of(context)!.delete),
              ),
            ],
          ),
        ) ??
        false;
    if (delete) await vm.deleteSelectedTask();
    return;
  }
  final draft = await showDialog<WorkspaceTaskDraft>(
    context: context,
    builder: (_) => WorkspaceTaskEditorDialog(
      title: action == 'edit'
          ? AppLocalizations.of(context)!.editTask
          : action == 'subtask'
          ? AppLocalizations.of(context)!.newSubtask
          : AppLocalizations.of(context)!.duplicateTask,
      initialTitle: action == 'subtask' ? '' : task.title,
      initialDaily: action == 'subtask' ? false : task.daily,
      allowDaily: action != 'subtask' && task.parentId == null,
    ),
  );
  if (draft == null) return;
  if (action == 'edit') {
    await vm.updateSelectedTask(draft.title, draft.daily);
    return;
  }
  if (action == 'subtask') {
    await vm.createSubtask(draft.title);
    return;
  }
  await vm.createTask(draft.title, draft.daily);
}
