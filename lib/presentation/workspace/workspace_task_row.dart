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
import '../workspace_projection.dart';
import 'workspace_presenters.dart';
import 'workspace_task_visibility.dart';

Color _tagColor(BuildContext context, TaskTag tag) => switch (tag) {
  TaskTag.spade => TerminalPalette.of(context).accent,
  TaskTag.heart => TerminalPalette.of(context).done,
  TaskTag.club => TerminalPalette.of(context).error,
  TaskTag.diamond => TerminalPalette.of(context).pending,
};

class WorkspaceTaskInteractions extends InheritedWidget {
  const WorkspaceTaskInteractions({
    super.key,
    required this.contextualTaskId,
    required this.onLongPress,
    required super.child,
  });

  final String? contextualTaskId;
  final void Function(Task task, Offset globalPosition) onLongPress;

  static WorkspaceTaskInteractions? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<WorkspaceTaskInteractions>();

  @override
  bool updateShouldNotify(WorkspaceTaskInteractions oldWidget) =>
      contextualTaskId != oldWidget.contextualTaskId ||
      onLongPress != oldWidget.onLongPress;
}

class WorkspaceTaskRow extends ConsumerWidget {
  const WorkspaceTaskRow({
    super.key,
    required this.task,
    required this.state,
    this.statusChangedAt,
    this.contextual = false,
    this.onLongPress,
    this.showMobileDivider = false,
  });
  final Task task;
  final WorkspaceState state;
  final DateTime? statusChangedAt;
  final bool contextual;
  final void Function(Task task, Offset globalPosition)? onLongPress;
  final bool showMobileDivider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final terminal = usesTerminalPresentation;
    final interactions = WorkspaceTaskInteractions.maybeOf(context);
    final list = state.lists.firstWhere(
      (candidate) => candidate.tasks.any((item) => item.id == task.id),
    );
    final depth = taskDepth(list, task);
    final hasChildren = taskHasChildren(list, task);
    final selected = task.id == state.selectedTaskId;
    final visuallySelected = terminal
        ? selected
        : contextual || interactions?.contextualTaskId == task.id;
    final multiSelected = state.multiSelectedTaskIds.contains(task.id);
    final visibleTaskIds = selected ? state.visibleTaskIds : const <String>[];
    final done = task.status == TaskStatus.done;
    final archived = task.status == TaskStatus.archived;
    final animated = task.id == state.animatedTaskId;
    final highlighted = state.highlightedTaskIds.contains(task.id);
    final search = state.search;
    final title = _TaskTitle(
      value: task.title,
      selected: visuallySelected,
      display: !terminal || state.search != null
          ? LongTitleDisplay.wrapAll
          : state.settings.longTitleDisplay,
      searchQuery: search?.query,
      currentSearchMatch: search?.currentTaskId == task.id,
      style: TextStyle(
        color: visuallySelected || multiSelected || highlighted
            ? TerminalPalette.of(context).background
            : done || archived
            ? TerminalPalette.of(context).muted
            : TerminalPalette.of(context).text,
        fontWeight: visuallySelected || multiSelected || highlighted
            ? FontWeight.bold
            : FontWeight.normal,
        decoration: done || archived ? TextDecoration.lineThrough : null,
        decorationColor: TerminalPalette.of(context).muted,
        height: terminal ? null : 1.1,
      ),
    );
    final row = Semantics(
      selected: visuallySelected || multiSelected,
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
        onPointerDown: (_) {
          if (terminal && !state.hasMultiSelection) {
            ref.read(workspaceViewModelProvider.notifier).selectTask(task.id);
          }
        },
        child: InkWell(
          onTap: terminal
              ? () => ref
                    .read(workspaceViewModelProvider.notifier)
                    .selectTask(task.id)
              : null,
          onDoubleTap: () async {
            final vm = ref.read(workspaceViewModelProvider.notifier);
            if (!terminal) {
              if (task.status == TaskStatus.pending ||
                  task.status == TaskStatus.doing) {
                vm.selectTask(task.id);
                await vm.completeSelectedTask();
              } else if (task.status == TaskStatus.done ||
                  task.status == TaskStatus.archived) {
                vm.selectTask(task.id);
                await vm.restoreSelectedTaskToPending();
              }
              return;
            }
            final list = state.currentList;
            if (state.hasMultiSelection && list != null) {
              final message = AppLocalizations.of(context)!.selectionWasCopied;
              final tasks = [
                for (final id in state.visibleTaskIdsFor(list))
                  if (state.multiSelectedTaskIds.contains(id))
                    list.tasks.firstWhere((task) => task.id == id),
              ];
              await Clipboard.setData(
                ClipboardData(text: selectedTasksAsIndentedText(list, tasks)),
              );
              vm.highlightTasks(tasks.map((task) => task.id));
              vm.showNotice(message, usesDoingColor: true);
            } else {
              final message = AppLocalizations.of(context)!.taskWasCopied;
              await Clipboard.setData(ClipboardData(text: task.title));
              vm.highlightTasks([task.id]);
              vm.showNotice(message, usesDoingColor: true);
            }
            vm.selectTask(task.id);
          },
          borderRadius: terminal ? BorderRadius.zero : BorderRadius.circular(5),
          child: AnimatedContainer(
            constraints: const BoxConstraints(),
            duration: terminal
                ? Duration.zero
                : const Duration(milliseconds: 220),
            margin: EdgeInsets.zero,
            padding: EdgeInsets.symmetric(
              horizontal: terminal ? 0 : 8,
              vertical: terminal ? 1 : 4,
            ).add(EdgeInsets.only(left: terminal ? 0 : depth * 16.0)),
            decoration: BoxDecoration(
              color: highlighted
                  ? TerminalPalette.of(context).doing
                  : visuallySelected
                  ? TerminalPalette.of(context).accent
                  : multiSelected
                  ? TerminalPalette.of(context).doing
                  : animated
                  ? workspaceStatusColor(context, task.status)
                  : Colors.transparent,
              borderRadius: terminal
                  ? BorderRadius.zero
                  : BorderRadius.circular(5),
              border: null,
            ),
            // The selected row supplies the violet background across its full
            // measured height, including the tag columns.
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (terminal)
                  Text(
                    '${'  ' * depth}${hasChildren ? (task.collapsed ? '▸ ' : '▾ ') : (selected ? '› ' : '- ')}',
                    style: TextStyle(
                      color: selected
                          ? TerminalPalette.of(context).background
                          : TerminalPalette.of(context).muted,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                else
                  SizedBox(
                    width: 32,
                    child: hasChildren
                        ? IconButton(
                            key: ValueKey('task-collapse-${task.id}'),
                            padding: EdgeInsets.zero,
                            visualDensity: VisualDensity.compact,
                            tooltip: task.collapsed
                                ? AppLocalizations.of(context)!.expandSubtasks
                                : AppLocalizations.of(
                                    context,
                                  )!.collapseSubtasks,
                            onPressed: () {
                              final vm = ref.read(
                                workspaceViewModelProvider.notifier,
                              );
                              vm.selectTask(task.id);
                              unawaited(vm.toggleSelectedCollapsed());
                            },
                            icon: Icon(
                              task.collapsed
                                  ? Icons.arrow_right
                                  : Icons.arrow_drop_down,
                            ),
                          )
                        : Text(
                            '-',
                            key: ValueKey('task-prefix-${task.id}'),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: visuallySelected
                                  ? TerminalPalette.of(context).background
                                  : TerminalPalette.of(context).muted,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                Expanded(child: title),
                _TaskTags(task: task, selected: visuallySelected),
                if (task.daily)
                  terminal
                      ? Text(
                          ' ↻',
                          style: TextStyle(
                            color: visuallySelected
                                ? TerminalPalette.of(context).background
                                : TerminalPalette.of(context).done,
                          ),
                        )
                      : Icon(
                          Icons.repeat,
                          size: 16,
                          color: visuallySelected
                              ? TerminalPalette.of(context).background
                              : TerminalPalette.of(context).done,
                        ),
                if (statusChangedAt != null)
                  Padding(
                    padding: EdgeInsets.only(
                      left: terminal ? TerminalMetrics.cell(context) : 8,
                    ),
                    child: SizedBox(
                      key: ValueKey('status-stamp-${task.id}'),
                      width: terminal
                          ? TerminalMetrics.cell(context) * 10
                          : null,
                      child: Text(
                        workspaceCompletionStamp(
                          statusChangedAt!,
                          AppLocalizations.of(context)!,
                        ),
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: visuallySelected
                              ? TerminalPalette.of(context).background
                              : TerminalPalette.of(context).muted,
                          fontSize: terminal ? null : 12,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
    final interactiveRow =
        !kIsWeb && defaultTargetPlatform == TargetPlatform.android
        ? _AndroidTaskGesture(
            task: task,
            onLongPress: onLongPress ?? interactions?.onLongPress,
            child: row,
          )
        : row;
    return WorkspaceKeepSelectedTaskVisible(
      // Android does not expose keyboard selection; automatically revealing
      // the view-model selection would override its Done/Pending entry point.
      selected: terminal && selected,
      first: visibleTaskIds.isNotEmpty && visibleTaskIds.first == task.id,
      last: visibleTaskIds.isNotEmpty && visibleTaskIds.last == task.id,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          interactiveRow,
          if (!terminal && showMobileDivider)
            FractionallySizedBox(
              widthFactor: 0.75,
              child: SizedBox(
                key: ValueKey('task-divider-${task.id}'),
                height: 10,
                child: CustomPaint(
                  painter: _DottedTaskDividerPainter(
                    color: TerminalPalette.of(context).muted,
                    gap: _twoSpaceWidth(context),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

double _twoSpaceWidth(BuildContext context) {
  final painter = TextPainter(
    text: TextSpan(text: '  ', style: Theme.of(context).textTheme.bodyMedium),
    textDirection: Directionality.of(context),
  )..layout();
  return painter.width;
}

class _DottedTaskDividerPainter extends CustomPainter {
  const _DottedTaskDividerPainter({required this.color, required this.gap});

  static const diameter = 2.0;

  final Color color;
  final double gap;

  @override
  void paint(Canvas canvas, Size size) {
    final step = diameter + gap;
    final count = ((size.width + gap) / step).floor();
    if (count <= 0) return;
    final usedWidth = count * diameter + (count - 1) * gap;
    final firstCenter = (size.width - usedWidth) / 2 + diameter / 2;
    final paint = Paint()..color = color;
    for (var index = 0; index < count; index++) {
      canvas.drawCircle(
        Offset(firstCenter + index * step, size.height / 2),
        diameter / 2,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_DottedTaskDividerPainter oldDelegate) =>
      color != oldDelegate.color || gap != oldDelegate.gap;
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

class _AndroidTaskGesture extends StatefulWidget {
  const _AndroidTaskGesture({
    required this.task,
    required this.child,
    this.onLongPress,
  });
  final Task task;
  final Widget child;
  final void Function(Task task, Offset globalPosition)? onLongPress;

  @override
  State<_AndroidTaskGesture> createState() => _AndroidTaskGestureState();
}

class _AndroidTaskGestureState extends State<_AndroidTaskGesture> {
  @override
  Widget build(BuildContext context) => GestureDetector(
    behavior: HitTestBehavior.translucent,
    onLongPressStart: (details) =>
        widget.onLongPress?.call(widget.task, details.globalPosition),
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

class _TaskTitle extends StatelessWidget {
  const _TaskTitle({
    required this.value,
    required this.selected,
    required this.display,
    required this.style,
    this.searchQuery,
    this.currentSearchMatch = false,
  });
  final String value;
  final bool selected;
  final LongTitleDisplay display;
  final TextStyle style;
  final String? searchQuery;
  final bool currentSearchMatch;

  @override
  Widget build(BuildContext context) {
    if (display == LongTitleDisplay.wrapAll ||
        (display == LongTitleDisplay.wrapSelected && selected)) {
      return _searchHighlightedTitle(context, value, style);
    }
    return Text(
      value.replaceAll(RegExp(r'[\r\n]+'), ' '),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: style,
    );
  }

  Widget _searchHighlightedTitle(
    BuildContext context,
    String value,
    TextStyle style,
  ) {
    final query = searchQuery;
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
            backgroundColor: currentSearchMatch
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
