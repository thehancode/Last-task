import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';

import '../../app/ui_mode.dart';
import '../../domain/models.dart';
import '../../l10n/app_localizations.dart';
import '../terminal_style.dart';
import '../workspace_view_model.dart';

class WorkspaceTransientBanner extends StatelessWidget {
  const WorkspaceTransientBanner({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: TerminalPalette.of(context).panel,
      border: Border.all(color: TerminalPalette.of(context).doing),
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: TerminalMetrics.cell(context),
        vertical: 2,
      ),
      child: Text('TIP: $text'),
    ),
  );
}

class WorkspaceRewardOverlay extends StatelessWidget {
  const WorkspaceRewardOverlay({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: TerminalPalette.of(context).background.withValues(alpha: .72),
    child: Center(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: TerminalPalette.of(context).panel,
          border: Border.all(color: TerminalPalette.of(context).done, width: 2),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: TerminalMetrics.cell(context) * 3,
            vertical: TerminalMetrics.line(context),
          ),
          child: Text(
            '✦  $text  ✦',
            style: TextStyle(
              color: TerminalPalette.of(context).done,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ),
  );
}

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
    return SizedBox(
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
              style: TextStyle(
                color: terminal
                    ? TerminalPalette.of(context).background
                    : TerminalPalette.of(context).accent,
                fontWeight: FontWeight.bold,
                fontSize: terminal ? null : 20,
              ),
            ),
          ),
          const Spacer(),
          Text(
            _viewLabel(state.view, strings),
            style: TextStyle(
              color: TerminalPalette.of(context).muted,
              fontWeight: FontWeight.bold,
            ),
          ),
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

class WorkspaceTabs extends ConsumerWidget {
  const WorkspaceTabs({super.key, required this.state});
  final WorkspaceState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context)!;
    Widget item(int index) {
      final list = state.lists[index];
      final selected =
          state.view != WorkspaceView.multi && list.id == state.currentListId;
      return Semantics(
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
                            ? TerminalPalette.of(context).accent
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
                            ? TerminalPalette.of(context).accent
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
                selectedColor: TerminalPalette.of(context).accent,
                onSelected: (_) => ref
                    .read(workspaceViewModelProvider.notifier)
                    .selectList(list.id),
              ),
      );
    }

    if (usesTerminalPresentation) {
      return SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
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
      WorkspaceView.focus => strings.doingFocus,
      WorkspaceView.completed => strings.completed,
      WorkspaceView.multi => strings.multiView,
    };
