import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';

import '../../app/ui_mode.dart';
import '../../domain/models.dart';
import '../../l10n/app_localizations.dart';
import '../auth_view_model.dart';
import '../terminal_style.dart';
import '../workspace_view_model.dart';

class WorkspaceDesktopWindowDragArea extends StatelessWidget {
  const WorkspaceDesktopWindowDragArea({super.key});

  @override
  Widget build(BuildContext context) => KeyedSubtree(
    key: const Key('desktop-window-drag-area'),
    child: Semantics(
      label: AppLocalizations.of(context)!.dragWindow,
      child: MouseRegion(
        cursor: SystemMouseCursors.move,
        child: DragToMoveArea(
          child: SizedBox(
            width: double.infinity,
            height: TerminalMetrics.line(context),
          ),
        ),
      ),
    ),
  );
}

class WorkspaceHeader extends ConsumerWidget {
  const WorkspaceHeader({
    super.key,
    required this.state,
    required this.onNewTask,
    required this.onCreateList,
    required this.onRenameList,
    required this.onDeleteList,
    required this.onSettings,
    required this.onHelp,
  });
  final WorkspaceState state;
  final VoidCallback onNewTask;
  final VoidCallback onCreateList;
  final VoidCallback onRenameList;
  final VoidCallback onDeleteList;
  final VoidCallback onSettings;
  final VoidCallback onHelp;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final terminal = usesTerminalPresentation;
    final strings = AppLocalizations.of(context)!;
    final username = ref.watch(authViewModelProvider).username;
    return SizedBox(
      child: Row(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Container(
                      color: terminal
                          ? TerminalPalette.of(context).accent
                          : Colors.transparent,
                      padding: EdgeInsets.symmetric(
                        horizontal: terminal ? 8 : 0,
                        vertical: terminal ? 1 : 0,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        strings.workspaceTitle,
                        semanticsLabel: strings.workspaceTitle,
                        style: TextStyle(
                          color: terminal
                              ? TerminalPalette.of(context).background
                              : TerminalPalette.of(context).accent,
                          fontWeight: FontWeight.bold,
                          fontSize: terminal ? null : 20,
                        ),
                      ),
                    ),
                    if (username != null) ...[
                      SizedBox(width: TerminalMetrics.cell(context)),
                      Text(
                        username,
                        key: const Key('workspace-account-name'),
                        style: TextStyle(
                          color: TerminalPalette.of(context).muted,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          Text(
            _viewLabel(state.view, strings),
            style: TextStyle(
              color: TerminalPalette.of(context).muted,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (usesFramelessDesktopWindow) ...[
            SizedBox(width: TerminalMetrics.cell(context)),
            const WorkspaceCloseButton(),
          ],
          if (!terminal) ...[
            const SizedBox(width: 8),
            IconButton(
              tooltip: strings.newTaskTooltip,
              onPressed: onNewTask,
              icon: const Icon(Icons.add_task),
            ),
            IconButton(
              tooltip: strings.newListTooltip,
              onPressed: onCreateList,
              icon: const Icon(Icons.playlist_add),
            ),
            PopupMenuButton<String>(
              tooltip: strings.listActions,
              onSelected: (value) {
                if (value == 'rename') onRenameList();
                if (value == 'delete') onDeleteList();
              },
              itemBuilder: (_) => [
                PopupMenuItem(value: 'rename', child: Text(strings.renameList)),
                PopupMenuItem(value: 'delete', child: Text(strings.deleteList)),
              ],
            ),
            PopupMenuButton<String>(
              tooltip: strings.appActions,
              onSelected: (value) {
                if (value == 'multi') {
                  ref
                      .read(workspaceViewModelProvider.notifier)
                      .toggleMultiView();
                }
                if (value == 'settings') onSettings();
                if (value == 'help') onHelp();
              },
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: 'multi',
                  child: Text(strings.toggleMultiView),
                ),
                PopupMenuItem(value: 'settings', child: Text(strings.settings)),
                PopupMenuItem(
                  value: 'help',
                  child: Text(strings.keyboardShortcuts),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class WorkspaceCloseButton extends StatefulWidget {
  const WorkspaceCloseButton({super.key});

  @override
  State<WorkspaceCloseButton> createState() => _WorkspaceCloseButtonState();
}

class _WorkspaceCloseButtonState extends State<WorkspaceCloseButton> {
  var _hovered = false;

  @override
  Widget build(BuildContext context) {
    final palette = TerminalPalette.of(context);
    return Semantics(
      button: true,
      label: AppLocalizations.of(context)!.closeApp,
      child: Tooltip(
        message: AppLocalizations.of(context)!.closeApp,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: GestureDetector(
            onTap: () {
              // This replaces the native caption button in our frameless
              // desktop window, so close the host window rather than only
              // dismissing Flutter's navigation stack.
              windowManager.close();
            },
            child: Container(
              key: const Key('workspace-close-button'),
              width: 28,
              height: TerminalMetrics.line(context),
              alignment: Alignment.center,
              color: _hovered ? palette.error : palette.muted,
              child: Text(
                '×',
                style: TextStyle(
                  color: palette.background,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class WorkspaceTabs extends ConsumerStatefulWidget {
  const WorkspaceTabs({super.key, required this.state});
  final WorkspaceState state;

  @override
  ConsumerState<WorkspaceTabs> createState() => _WorkspaceTabsState();
}

class _WorkspaceTabsState extends ConsumerState<WorkspaceTabs> {
  static const _scrollDuration = Duration(milliseconds: 180);
  final _scrollController = ScrollController();
  final _viewportKey = GlobalKey();
  final _tabKeys = <String, GlobalKey>{};

  @override
  void didUpdateWidget(covariant WorkspaceTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    final previousId = _selectedListId(oldWidget.state);
    final selectedId = _selectedListId(widget.state);
    if (selectedId == null || selectedId == previousId) return;

    final direction = _selectionDirection(previousId, selectedId);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _selectedListId(widget.state) == selectedId) {
        _scrollToSelection(selectedId, direction);
      }
    });
  }

  String? _selectedListId(WorkspaceState state) =>
      state.view == WorkspaceView.multi ? null : state.currentListId;

  int _selectionDirection(String? previousId, String selectedId) {
    if (previousId == null) return 0;
    final previous = widget.state.lists.indexWhere(
      (list) => list.id == previousId,
    );
    final selected = widget.state.lists.indexWhere(
      (list) => list.id == selectedId,
    );
    if (previous < 0 || selected < 0 || previous == selected) return 0;
    if (previous == widget.state.lists.length - 1 && selected == 0) return 1;
    if (previous == 0 && selected == widget.state.lists.length - 1) return -1;
    return selected > previous ? 1 : -1;
  }

  void _scrollToSelection(String selectedId, int direction) {
    if (!_scrollController.hasClients) return;
    final viewport = _viewportKey.currentContext?.findRenderObject();
    final selected = _tabKeys[selectedId]?.currentContext?.findRenderObject();
    if (viewport is! RenderBox || selected is! RenderBox) return;

    RenderBox? adjacent;
    final selectedIndex = widget.state.lists.indexWhere(
      (list) => list.id == selectedId,
    );
    final adjacentIndex = selectedIndex + direction;
    if (direction != 0 &&
        adjacentIndex >= 0 &&
        adjacentIndex < widget.state.lists.length) {
      final adjacentRenderObject =
          _tabKeys[widget.state.lists[adjacentIndex].id]?.currentContext
              ?.findRenderObject();
      if (adjacentRenderObject is RenderBox) {
        adjacent = adjacentRenderObject;
      }
    }

    final selectedRect = _rectInViewport(selected, viewport);
    var targetRect = selectedRect;
    if (adjacent != null) {
      final adjacentRect = _rectInViewport(adjacent, viewport);
      final combined = selectedRect.expandToInclude(adjacentRect);
      if (combined.width <= _scrollController.position.viewportDimension) {
        targetRect = combined;
      }
    }

    final position = _scrollController.position;
    final target = _targetOffset(position, targetRect);
    if ((target - position.pixels).abs() < .5) return;
    _scrollController.animateTo(
      target,
      duration: _scrollDuration,
      curve: Curves.easeOut,
    );
  }

  Rect _rectInViewport(RenderBox child, RenderBox viewport) => Rect.fromLTWH(
    child.localToGlobal(Offset.zero, ancestor: viewport).dx,
    0,
    child.size.width,
    child.size.height,
  );

  double _targetOffset(ScrollPosition position, Rect targetRect) {
    final viewportEnd = position.viewportDimension;
    var target = position.pixels;
    if (targetRect.left < 0) {
      target += targetRect.left;
    } else if (targetRect.right > viewportEnd) {
      target += targetRect.right - viewportEnd;
    }
    return target.clamp(position.minScrollExtent, position.maxScrollExtent);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final strings = AppLocalizations.of(context)!;
    Widget item(int index) {
      final list = state.lists[index];
      final selected =
          state.view != WorkspaceView.multi && list.id == state.currentListId;
      final selectedColor = list.isHabit
          ? TerminalPalette.of(context).doing
          : TerminalPalette.of(context).accent;
      return KeyedSubtree(
        key: _tabKeys.putIfAbsent(list.id, GlobalKey.new),
        child: Semantics(
          selected: selected,
          button: true,
          label: strings.taskList(list.name),
          child: usesTerminalPresentation
              ? InkWell(
                  onTap: () => ref
                      .read(workspaceViewModelProvider.notifier)
                      .selectList(list.id),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: selected
                              ? selectedColor
                              : TerminalPalette.of(context).muted,
                          width: selected ? 2 : 1,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: TerminalMetrics.cell(context),
                        vertical: TerminalMetrics.line(context) * .2,
                      ),
                      child: Text(
                        list.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: selected
                              ? selectedColor
                              : TerminalPalette.of(context).muted,
                          fontWeight: selected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                )
              : ChoiceChip(
                  selected: selected,
                  label: Text(list.name),
                  selectedColor: selectedColor,
                  onSelected: (_) => ref
                      .read(workspaceViewModelProvider.notifier)
                      .selectList(list.id),
                ),
        ),
      );
    }

    if (usesTerminalPresentation) {
      return SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          key: _viewportKey,
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              for (var index = 0; index < state.lists.length; index++)
                item(index),
            ],
          ),
        ),
      );
    }
    return SizedBox(
      height: 42,
      child: ListView.separated(
        key: _viewportKey,
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: state.lists.length,
        separatorBuilder: (_, _) => const SizedBox(width: 6),
        itemBuilder: (_, index) => item(index),
      ),
    );
  }
}

String _viewLabel(WorkspaceView view, AppLocalizations strings) =>
    switch (view) {
      WorkspaceView.list => strings.listView,
      WorkspaceView.completed => strings.completed,
      WorkspaceView.multi => strings.multiView,
    };
