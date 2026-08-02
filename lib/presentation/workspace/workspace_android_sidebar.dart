import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models.dart';
import '../../l10n/app_localizations.dart';
import '../auth_view_model.dart';
import '../terminal_style.dart';
import '../workspace_view_model.dart';

class AndroidWorkspaceHeader extends ConsumerWidget {
  const AndroidWorkspaceHeader({super.key, required this.state});

  final WorkspaceState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context)!;
    final isMulti = state.view == WorkspaceView.multi;
    final title = state.currentList?.name ?? strings.appTitle;
    final viewLabel = isMulti ? strings.multiView : strings.listView;
    return Semantics(
      button: true,
      label: '$title, $viewLabel',
      child: InkWell(
        key: const ValueKey('android-view-toggle'),
        borderRadius: BorderRadius.circular(12),
        onTap: () =>
            ref.read(workspaceViewModelProvider.notifier).toggleMultiView(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                viewLabel,
                key: const ValueKey('android-view-subtitle'),
                style: TextStyle(
                  color: TerminalPalette.of(context).muted,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AndroidWorkspaceSidebar extends ConsumerStatefulWidget {
  const AndroidWorkspaceSidebar({
    super.key,
    required this.state,
    required this.onSelectList,
    required this.onSettings,
    required this.onCreateList,
    required this.onRenameList,
    required this.onDeleteList,
  });

  final WorkspaceState state;
  final ValueChanged<String> onSelectList;
  final VoidCallback onSettings;
  final VoidCallback onCreateList;
  final VoidCallback onRenameList;
  final VoidCallback onDeleteList;

  @override
  ConsumerState<AndroidWorkspaceSidebar> createState() =>
      _AndroidWorkspaceSidebarState();
}

class _AndroidWorkspaceSidebarState
    extends ConsumerState<AndroidWorkspaceSidebar> {
  final _stackKey = GlobalKey();
  String? _contextualListId;
  Offset? _contextMenuPosition;

  void _closeDrawerThen(VoidCallback action) {
    Navigator.of(context).pop();
    WidgetsBinding.instance.addPostFrameCallback((_) => action());
  }

  void _selectList(TaskList list) {
    widget.onSelectList(list.id);
    Navigator.of(context).pop();
  }

  void _showListMenu(TaskList list, Offset globalPosition) {
    widget.onSelectList(list.id);
    final box = _stackKey.currentContext?.findRenderObject();
    final localPosition = box is RenderBox
        ? box.globalToLocal(globalPosition)
        : globalPosition;
    setState(() {
      _contextualListId = list.id;
      _contextMenuPosition = localPosition;
    });
  }

  void _dismissListMenu() {
    if (_contextualListId == null) return;
    setState(() {
      _contextualListId = null;
      _contextMenuPosition = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final palette = TerminalPalette.of(context);
    final username = ref.watch(authViewModelProvider).username;
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) => Stack(
          key: _stackKey,
          children: [
            CustomScrollView(
              key: const ValueKey('android-sidebar-scroll'),
              slivers: [
                SliverToBoxAdapter(
                  child: SizedBox(
                    key: const ValueKey('android-sidebar-header'),
                    height: constraints.maxHeight * .5,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            strings.appTitle,
                            style: TextStyle(
                              color: palette.accent,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (username != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              username,
                              key: const ValueKey(
                                'android-sidebar-account-name',
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: palette.muted,
                                fontSize: 14,
                              ),
                            ),
                          ],
                          ListTile(
                            key: const ValueKey('android-sidebar-settings'),
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.settings),
                            title: Text(strings.settings),
                            onTap: () => _closeDrawerThen(widget.onSettings),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                    child: Text(
                      strings.listsLabel,
                      key: const ValueKey('android-sidebar-lists-label'),
                      style: TextStyle(color: palette.muted, fontSize: 12),
                    ),
                  ),
                ),
                SliverList.builder(
                  itemCount: widget.state.lists.length,
                  itemBuilder: (context, index) {
                    final list = widget.state.lists[index];
                    final selected =
                        widget.state.view != WorkspaceView.multi &&
                        list.id == widget.state.currentListId;
                    final contextual = list.id == _contextualListId;
                    final color = list.isHabit ? palette.doing : palette.accent;
                    return Semantics(
                      selected: selected || contextual,
                      button: true,
                      label: strings.taskList(list.name),
                      child: GestureDetector(
                        onLongPressStart: (details) =>
                            _showListMenu(list, details.globalPosition),
                        child: ListTile(
                          key: ValueKey('android-sidebar-list-${list.id}'),
                          selected: selected || contextual,
                          selectedColor: color,
                          selectedTileColor: color.withValues(alpha: .12),
                          title: Text(
                            list.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () => _selectList(list),
                        ),
                      ),
                    );
                  },
                ),
                const SliverPadding(padding: EdgeInsets.only(bottom: 88)),
              ],
            ),
            Positioned(
              right: 16,
              bottom: 12,
              child: FloatingActionButton.extended(
                key: const ValueKey('android-sidebar-new-list'),
                heroTag: 'android-sidebar-new-list',
                backgroundColor: palette.accent,
                foregroundColor: palette.background,
                onPressed: () => _closeDrawerThen(widget.onCreateList),
                icon: const Icon(Icons.add),
                label: Text(strings.newList),
              ),
            ),
            if (_contextualListId != null) ...[
              Positioned.fill(
                child: GestureDetector(
                  key: const ValueKey('android-list-context-menu-barrier'),
                  behavior: HitTestBehavior.opaque,
                  onTap: _dismissListMenu,
                  child: const SizedBox.expand(),
                ),
              ),
              _AndroidListContextMenu(
                pressPosition: _contextMenuPosition ?? Offset.zero,
                availableSize: constraints.biggest,
                onEdit: () => _closeDrawerThen(widget.onRenameList),
                onDelete: () => _closeDrawerThen(widget.onDeleteList),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AndroidListContextMenu extends StatelessWidget {
  const _AndroidListContextMenu({
    required this.pressPosition,
    required this.availableSize,
    required this.onEdit,
    required this.onDelete,
  });

  static const _width = 116.0;
  static const _height = 54.0;

  final Offset pressPosition;
  final Size availableSize;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final left = (pressPosition.dx - _width / 2).clamp(
      8.0,
      availableSize.width - _width - 8,
    );
    final top = (pressPosition.dy - _height - 10).clamp(
      4.0,
      availableSize.height - _height - 4,
    );
    return Positioned(
      key: const ValueKey('android-list-context-menu'),
      left: left,
      top: top,
      width: _width,
      height: _height,
      child: Material(
        elevation: 8,
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              key: const ValueKey('android-list-context-edit'),
              tooltip: strings.edit,
              onPressed: onEdit,
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              key: const ValueKey('android-list-context-delete'),
              tooltip: strings.delete,
              color: TerminalPalette.of(context).error,
              onPressed: onDelete,
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}
