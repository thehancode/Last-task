import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../app/ui_mode.dart';
import '../app/desktop_background.dart';
import '../data/providers.dart';
import '../domain/models.dart';
import '../domain/repositories.dart';
import '../l10n/app_localizations.dart';
import 'terminal_style.dart';
import 'workspace_view_model.dart';
import 'workspace_projection.dart';
import 'workspace/workspace_dialogs.dart';
import 'workspace/workspace_android_sidebar.dart';
import 'workspace/workspace_chrome.dart';
import 'workspace/workspace_footer.dart';
import 'workspace/workspace_settings_dialog.dart';
import 'workspace/workspace_task_panel.dart';

EdgeInsetsGeometry? get _dialogTitlePadding =>
    usesTerminalPresentation ? const EdgeInsets.fromLTRB(10, 8, 10, 0) : null;
EdgeInsetsGeometry? get _dialogContentPadding =>
    usesTerminalPresentation ? const EdgeInsets.fromLTRB(10, 8, 10, 8) : null;

enum _ComposerMode { create, subtask, edit, duplicate }

class WorkspaceScreen extends ConsumerStatefulWidget {
  const WorkspaceScreen({super.key});

  @override
  ConsumerState<WorkspaceScreen> createState() => _WorkspaceScreenState();
}

class _WorkspaceScreenState extends ConsumerState<WorkspaceScreen>
    with WidgetsBindingObserver {
  final _focusNode = FocusNode(debugLabel: 'workspace');
  final _androidOverlayKey = GlobalKey();
  Timer? _grabTimer;
  Timer? _dailyRefreshTimer;
  Timer? _syncTimer;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _grabbed = false;
  final _composerController = TextEditingController();
  final _composerFocusNode = FocusNode(debugLabel: 'android-task-composer');
  _ComposerMode _composerMode = _ComposerMode.create;
  String? _composerTaskId;
  String? _contextualTaskId;
  Offset? _contextMenuPosition;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _dailyRefreshTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      unawaited(
        ref.read(workspaceViewModelProvider.notifier).refreshDailyTasks(),
      );
    });
    _setSyncInterval(const Duration(seconds: 15));
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      results,
    ) {
      if (results.any((result) => result != ConnectivityResult.none)) {
        _synchronize(force: true);
      }
    });
    _synchronize(force: true);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(
        ref.read(workspaceViewModelProvider.notifier).refreshDailyTasks(),
      );
      _setSyncInterval(const Duration(seconds: 15));
      _synchronize(force: true);
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.inactive) {
      _setSyncInterval(const Duration(seconds: 90));
    }
  }

  void _setSyncInterval(Duration interval) {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(interval, (_) => _synchronize());
  }

  void _synchronize({bool force = false}) {
    final repository = ref.read(taskListRepositoryProvider);
    if (repository is BackgroundSyncRepository) {
      unawaited(
        (repository as BackgroundSyncRepository).synchronize(force: force),
      );
    }
  }

  @override
  void dispose() {
    _grabTimer?.cancel();
    _dailyRefreshTimer?.cancel();
    _syncTimer?.cancel();
    unawaited(_connectivitySubscription?.cancel());
    WidgetsBinding.instance.removeObserver(this);
    _composerController.dispose();
    _composerFocusNode.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Task? _taskById(String? id) {
    if (id == null) return null;
    for (final list in ref.read(workspaceViewModelProvider).lists) {
      for (final task in list.tasks) {
        if (task.id == id) return task;
      }
    }
    return null;
  }

  TaskList? _listForTask(String id) {
    for (final list in ref.read(workspaceViewModelProvider).lists) {
      if (list.tasks.any((task) => task.id == id)) return list;
    }
    return null;
  }

  void _activateComposer(
    _ComposerMode mode, {
    Task? task,
    bool requestFocus = true,
  }) {
    setState(() {
      _composerMode = mode;
      _composerTaskId = task?.id;
      _composerController.text =
          mode == _ComposerMode.edit || mode == _ComposerMode.duplicate
          ? task?.title ?? ''
          : '';
      _composerController.selection = TextSelection.collapsed(
        offset: _composerController.text.length,
      );
    });
    if (requestFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _composerFocusNode.requestFocus();
      });
    }
  }

  bool _armSubtask(Task task) {
    final list = _listForTask(task.id);
    if (list == null) return false;
    final vm = ref.read(workspaceViewModelProvider.notifier);
    if (task.status == TaskStatus.done) {
      vm.showNotice('Completed tasks cannot receive subtasks');
      return false;
    }
    if (taskDepth(list, task) + 1 >= maxTaskDepth) {
      vm.showNotice('Tasks can only be nested three levels deep');
      return false;
    }
    _activateComposer(_ComposerMode.subtask, task: task);
    return true;
  }

  Future<void> _submitComposer() async {
    final input = _composerController.text;
    final vm = ref.read(workspaceViewModelProvider.notifier);
    final taskId = _composerTaskId;
    if (taskId != null) vm.selectTask(taskId);
    final success = switch (_composerMode) {
      _ComposerMode.create => await vm.createTask(input),
      _ComposerMode.subtask => await vm.createSubtask(input),
      _ComposerMode.edit => await vm.updateSelectedTask(input),
      _ComposerMode.duplicate => await vm.duplicateSelectedTask(input),
    };
    if (!success || !mounted) return;
    _dismissContextMenu(cancelComposer: false);
    _activateComposer(_ComposerMode.create, requestFocus: false);
    _composerFocusNode.requestFocus();
  }

  void _showContextMenu(Task task, Offset position) {
    _armSubtask(task);
    final overlay = _androidOverlayKey.currentContext?.findRenderObject();
    final localPosition = overlay is RenderBox
        ? overlay.globalToLocal(position)
        : position;
    setState(() {
      _contextualTaskId = task.id;
      _contextMenuPosition = localPosition;
    });
  }

  void _dismissContextMenu({bool cancelComposer = true}) {
    if (_contextualTaskId == null) return;
    setState(() {
      _contextualTaskId = null;
      _contextMenuPosition = null;
      if (cancelComposer && _composerMode == _ComposerMode.subtask) {
        _composerMode = _ComposerMode.create;
        _composerTaskId = null;
        _composerController.clear();
      }
    });
  }

  void _cancelSubtaskContext() {
    if (_contextualTaskId != null) {
      _dismissContextMenu();
    } else if (_composerMode == _ComposerMode.subtask) {
      _activateComposer(_ComposerMode.create, requestFocus: false);
    }
  }

  void _selectAndroidList(String listId) {
    ref.read(workspaceViewModelProvider.notifier).selectList(listId);
    _activateComposer(_ComposerMode.create, requestFocus: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.requestFocus();
    });
  }

  void _editContextTask() {
    final task = _taskById(_contextualTaskId);
    _dismissContextMenu(cancelComposer: false);
    if (task != null) _activateComposer(_ComposerMode.edit, task: task);
  }

  Future<void> _duplicateContextTask() async {
    final task = _taskById(_contextualTaskId);
    if (task == null) return;
    final list = _listForTask(task.id);
    _dismissContextMenu(cancelComposer: false);
    if (list != null && taskHasChildren(list, task)) {
      final vm = ref.read(workspaceViewModelProvider.notifier);
      vm.selectTask(task.id);
      _activateComposer(_ComposerMode.create, requestFocus: false);
      await vm.duplicateSelectedTaskTree();
      return;
    }
    _activateComposer(_ComposerMode.duplicate, task: task);
  }

  Future<void> _deleteContextTask() async {
    final task = _taskById(_contextualTaskId);
    _dismissContextMenu(cancelComposer: false);
    if (task == null) return;
    _activateComposer(_ComposerMode.create, requestFocus: false);
    ref.read(workspaceViewModelProvider.notifier).selectTask(task.id);
    await _confirmDeleteTask();
  }

  void _armGrab() {
    _grabTimer?.cancel();
    setState(() => _grabbed = true);
    _grabTimer = Timer(const Duration(milliseconds: 750), () {
      if (mounted) setState(() => _grabbed = false);
    });
  }

  void _releaseGrab() {
    _grabTimer?.cancel();
    if (_grabbed) setState(() => _grabbed = false);
  }

  KeyEventResult _onKey(FocusNode _, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    final vm = ref.read(workspaceViewModelProvider.notifier);
    if (ref.read(workspaceViewModelProvider).search != null) {
      if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        vm.moveSearch(-1);
        return KeyEventResult.handled;
      }
      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        vm.moveSearch(1);
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    }
    final control =
        HardwareKeyboard.instance.isControlPressed ||
        HardwareKeyboard.instance.isMetaPressed;
    final key = event.logicalKey;
    if (control) {
      if (key == LogicalKeyboardKey.arrowUp ||
          key == LogicalKeyboardKey.arrowDown ||
          key == LogicalKeyboardKey.arrowLeft ||
          key == LogicalKeyboardKey.arrowRight) {
        _releaseGrab();
        vm.clearMultiSelection();
        if (key == LogicalKeyboardKey.arrowUp ||
            key == LogicalKeyboardKey.arrowDown) {
          unawaited(
            vm.reorderSelected(key == LogicalKeyboardKey.arrowUp ? -1 : 1),
          );
        } else {
          unawaited(
            vm.reorderCurrentList(key == LogicalKeyboardKey.arrowLeft ? -1 : 1),
          );
        }
        return KeyEventResult.handled;
      }
      if (key == LogicalKeyboardKey.keyC) {
        if (HardwareKeyboard.instance.isShiftPressed) {
          unawaited(_copyCurrentSection());
        } else {
          unawaited(_copySelectedTitle());
        }
        return KeyEventResult.handled;
      }
      if (key == LogicalKeyboardKey.keyZ) {
        unawaited(vm.undo());
        return KeyEventResult.handled;
      }
      if (key == LogicalKeyboardKey.keyF) {
        vm.openSearch();
        return KeyEventResult.handled;
      }
      if (key == LogicalKeyboardKey.keyA) {
        if (HardwareKeyboard.instance.isShiftPressed) {
          vm.clearMultiSelection();
          vm.toggleMultiView();
        } else {
          vm.selectAllVisibleTasks();
        }
      }
      if (key == LogicalKeyboardKey.keyN) unawaited(_showListEditor());
      if (key == LogicalKeyboardKey.keyR || key == LogicalKeyboardKey.f2) {
        unawaited(_showListEditor(rename: true));
      }
      if (key == LogicalKeyboardKey.keyX) unawaited(_confirmDeleteList());
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.tab) {
      unawaited(_showTaskEditor(subtask: true));
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowLeft) {
      vm.clearMultiSelection();
      vm.cycleList(-1);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowRight) {
      vm.clearMultiSelection();
      vm.cycleList(1);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.space) {
      if (HardwareKeyboard.instance.isShiftPressed) {
        _releaseGrab();
        if (ref.read(workspaceViewModelProvider).view == WorkspaceView.list) {
          unawaited(vm.archiveSelectedTask());
        }
      } else if (_grabbed) {
        unawaited(vm.completeSelectedTask());
        _releaseGrab();
      } else {
        _armGrab();
      }
      return KeyEventResult.handled;
    }
    if (HardwareKeyboard.instance.isShiftPressed &&
        (key == LogicalKeyboardKey.arrowUp ||
            key == LogicalKeyboardKey.arrowDown)) {
      _releaseGrab();
      vm.extendTaskSelection(key == LogicalKeyboardKey.arrowUp ? -1 : 1);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowUp || key == LogicalKeyboardKey.keyK) {
      _releaseGrab();
      vm.moveSelection(-1);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowDown || key == LogicalKeyboardKey.keyJ) {
      _releaseGrab();
      vm.moveSelection(1);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.escape) {
      vm.clearMultiSelection();
      return KeyEventResult.handled;
    }
    if (usesTerminalPresentation &&
        event is KeyDownEvent &&
        key == LogicalKeyboardKey.keyT) {
      unawaited(_showThemePicker());
      return KeyEventResult.handled;
    }
    if (usesTerminalPresentation &&
        event is KeyDownEvent &&
        key == LogicalKeyboardKey.keyW) {
      unawaited(
        vm.cycleSelectedTag(HardwareKeyboard.instance.isShiftPressed ? 1 : 0),
      );
      return KeyEventResult.handled;
    }
    if (usesTerminalPresentation &&
        event is KeyDownEvent &&
        event.character == '/') {
      vm.openSearch();
      return KeyEventResult.handled;
    }
    if (_grabbed) {
      _releaseGrab();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.f2) {
      unawaited(_showListEditor(rename: true));
    } else if (key == LogicalKeyboardKey.keyN) {
      unawaited(_showTaskEditor());
    } else if (key == LogicalKeyboardKey.keyA) {
      unawaited(_showTaskEditor(subtask: true));
    } else if (key == LogicalKeyboardKey.keyH) {
      unawaited(vm.toggleSelectedCollapsed());
    } else if (key == LogicalKeyboardKey.keyE) {
      unawaited(_showTaskEditor(edit: true));
    } else if (key == LogicalKeyboardKey.keyD) {
      unawaited(_showTaskEditor(duplicate: true));
    } else if (key == LogicalKeyboardKey.keyX) {
      unawaited(_confirmDeleteTask());
    } else if (key == LogicalKeyboardKey.keyR) {
      unawaited(vm.revertSelectedCompletedTask());
    } else if (key == LogicalKeyboardKey.keyV) {
      vm.toggleCompletedView();
    } else if (key == LogicalKeyboardKey.keyG) {
      unawaited(_showSettings());
    } else if (key == LogicalKeyboardKey.keyS) {
      vm.toggleSound();
    } else if (key == LogicalKeyboardKey.keyQ) {
      SystemNavigator.pop();
    } else if (usesTerminalPresentation && event.character == '?') {
      unawaited(_showHelp());
    } else {
      return KeyEventResult.ignored;
    }
    return KeyEventResult.handled;
  }

  Future<void> _copySelectedTitle() async {
    final state = ref.read(workspaceViewModelProvider);
    if (state.hasMultiSelection) {
      final list = state.currentList;
      if (list == null) return;
      final tasks = [
        for (final id in state.visibleTaskIdsFor(list))
          if (state.multiSelectedTaskIds.contains(id))
            list.tasks.firstWhere((task) => task.id == id),
      ];
      if (tasks.isEmpty) return;
      final message = AppLocalizations.of(context)!.selectionWasCopied;
      await Clipboard.setData(
        ClipboardData(text: selectedTasksAsIndentedText(list, tasks)),
      );
      final vm = ref.read(workspaceViewModelProvider.notifier);
      vm.highlightTasks(tasks.map((task) => task.id));
      vm.showNotice(message, usesDoingColor: true);
      return;
    }
    final task = state.selectedTask;
    if (task == null) return;
    final message = AppLocalizations.of(context)!.taskWasCopied;
    await Clipboard.setData(ClipboardData(text: task.title));
    final vm = ref.read(workspaceViewModelProvider.notifier);
    vm.highlightTasks([task.id]);
    vm.showNotice(message, usesDoingColor: true);
  }

  Future<void> _copyCurrentSection() async {
    final state = ref.read(workspaceViewModelProvider);
    final section = selectedTaskSection(state);
    if (section == null) return;
    final message = AppLocalizations.of(context)!.selectionWasCopied;
    await Clipboard.setData(
      ClipboardData(text: sectionAsIndentedText(section)),
    );
    final vm = ref.read(workspaceViewModelProvider.notifier);
    vm.highlightTasks(section.tasks.map((task) => task.id));
    vm.showNotice(message, usesDoingColor: true);
  }

  Future<void> _showTaskEditor({
    bool edit = false,
    bool duplicate = false,
    bool subtask = false,
  }) async {
    final state = ref.read(workspaceViewModelProvider);
    final strings = AppLocalizations.of(context)!;
    final selected = state.selectedTask;
    if ((edit || duplicate || subtask) && selected == null) return;
    if (!usesTerminalPresentation) {
      _activateComposer(
        edit
            ? _ComposerMode.edit
            : duplicate
            ? _ComposerMode.duplicate
            : subtask
            ? _ComposerMode.subtask
            : _ComposerMode.create,
        task: edit || duplicate || subtask ? selected : null,
      );
      return;
    }
    final selectedList = state.selectedTaskList;
    if (duplicate &&
        selectedList != null &&
        taskHasChildren(selectedList, selected!)) {
      return;
    }
    final result = await showDialog<WorkspaceTaskDraft>(
      context: context,
      builder: (_) => WorkspaceTaskEditorDialog(
        title: edit
            ? strings.editTask
            : duplicate
            ? strings.duplicateTask
            : subtask
            ? strings.newSubtask
            : state.currentList?.isHabit == true
            ? strings.newDailyTask
            : strings.newTask,
        initialTitle: edit || duplicate ? selected?.title ?? '' : '',
      ),
    );
    if (result == null) return;
    final vm = ref.read(workspaceViewModelProvider.notifier);
    if (edit) {
      await vm.updateSelectedTask(result.title);
    } else if (duplicate) {
      await vm.duplicateSelectedTask(result.title);
    } else if (subtask) {
      await vm.createSubtask(result.title);
    } else {
      await vm.createTask(result.title);
    }
    _focusNode.requestFocus();
  }

  Future<void> _showListEditor({bool rename = false}) async {
    final state = ref.read(workspaceViewModelProvider);
    final result = await showDialog<WorkspaceListDraft>(
      context: context,
      builder: (_) => WorkspaceListEditorDialog(
        initial: rename ? state.currentList?.name ?? '' : '',
        rename: rename,
      ),
    );
    if (result == null) return;
    final vm = ref.read(workspaceViewModelProvider.notifier);
    if (rename) {
      await vm.renameCurrentList(result.name);
      _focusNode.requestFocus();
    } else {
      final created = await vm.createList(result.name, isHabit: result.isHabit);
      if (created && mounted && !usesTerminalPresentation) {
        _activateComposer(_ComposerMode.create);
      } else {
        _focusNode.requestFocus();
      }
    }
  }

  Future<void> _confirmDeleteTask() async {
    final state = ref.read(workspaceViewModelProvider);
    if (state.selectedTask == null) return;
    final strings = AppLocalizations.of(context)!;
    final deletingSelection = state.hasMultiSelection;
    final confirmed = await _confirm(
      deletingSelection
          ? strings.deleteSelectedTasksTitle(state.multiSelectedTaskIds.length)
          : strings.deleteTaskTitle,
      deletingSelection
          ? strings.deleteSelectedTasksBody(state.multiSelectedTaskIds.length)
          : strings.deleteTaskBody,
    );
    if (confirmed) {
      final vm = ref.read(workspaceViewModelProvider.notifier);
      if (deletingSelection) {
        await vm.deleteSelectedTasks();
      } else {
        await vm.deleteSelectedTask();
      }
    }
    _focusNode.requestFocus();
  }

  Future<void> _confirmDeleteList() async {
    final state = ref.read(workspaceViewModelProvider);
    if (state.lists.length == 1) {
      await ref.read(workspaceViewModelProvider.notifier).deleteCurrentList();
      return;
    }
    final confirmed = await _confirm(
      AppLocalizations.of(context)!.deleteListTitle,
      AppLocalizations.of(
        context,
      )!.deleteListBody(state.currentList?.name ?? ''),
    );
    if (confirmed) {
      await ref.read(workspaceViewModelProvider.notifier).deleteCurrentList();
    }
    _focusNode.requestFocus();
  }

  Future<bool> _confirm(String title, String content) async =>
      await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          titlePadding: _dialogTitlePadding,
          contentPadding: _dialogContentPadding,
          title: Text(
            title,
            style: TextStyle(color: TerminalPalette.of(context).error),
          ),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: TerminalPalette.of(context).error,
              ),
              onPressed: () => Navigator.pop(context, true),
              child: Text(AppLocalizations.of(context)!.delete),
            ),
          ],
        ),
      ) ??
      false;

  Future<void> _showSettings() async {
    await showDialog<void>(
      context: context,
      builder: (_) => const WorkspaceSettingsDialog(),
    );
    _focusNode.requestFocus();
  }

  Future<void> _showThemePicker() async {
    await showDialog<void>(
      context: context,
      builder: (_) =>
          const WorkspaceSettingsDialog(initialTab: SettingsTab.themes),
    );
    _focusNode.requestFocus();
  }

  Future<void> _showHelp() => showDialog<void>(
    context: context,
    builder: (_) => const WorkspaceHelpDialog(),
  );

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(workspaceViewModelProvider);
    ref.listen(
      workspaceViewModelProvider.select((value) => value.search != null),
      (previous, searching) {
        if (previous == true && !searching) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => _focusNode.requestFocus(),
          );
        }
      },
    );
    final terminal = usesTerminalPresentation;
    final appearance = state.deviceState.desktopAppearance;
    final backgroundPath = supportsDesktopBackground
        ? appearance.backgroundImagePath
        : null;
    final backgroundState = backgroundPath == null
        ? null
        : ref.watch(desktopBackgroundBytesProvider(backgroundPath));
    if (backgroundPath != null) {
      ref.listen(desktopBackgroundBytesProvider(backgroundPath), (_, next) {
        if (next.hasValue && next.value == null) {
          ref
              .read(workspaceViewModelProvider.notifier)
              .reportBackgroundUnavailable();
        }
      });
    }
    final background = backgroundState?.value;
    if (state.phase == WorkspacePhase.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (state.phase == WorkspacePhase.failure) {
      return Scaffold(
        body: Center(
          child: Text(
            state.error ?? AppLocalizations.of(context)!.couldNotLoad,
          ),
        ),
      );
    }
    final workspace = terminal
        ? SafeArea(
            child: Column(
              children: [
                if (usesFramelessDesktopWindow)
                  const WorkspaceDesktopWindowDragArea(),
                WorkspaceHeader(
                  state: state,
                  onNewTask: _showTaskEditor,
                  onCreateList: _showListEditor,
                  onRenameList: () => _showListEditor(rename: true),
                  onDeleteList: _confirmDeleteList,
                  onSettings: _showSettings,
                  onHelp: _showHelp,
                ),
                WorkspaceTabs(state: state),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: TerminalMetrics.cell(context),
                    ),
                    child: WorkspaceTaskPanel(
                      state: state,
                      background: background,
                      backgroundConfigured: backgroundPath != null,
                    ),
                  ),
                ),
                WorkspaceFooter(
                  state: state,
                  grabbed: _grabbed,
                  onNewTask: _showTaskEditor,
                  onCreateList: _showListEditor,
                  onSettings: _showSettings,
                  onHelp: _showHelp,
                ),
              ],
            ),
          )
        : SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) => Stack(
                        key: _androidOverlayKey,
                        children: [
                          Column(
                            children: [
                              AndroidWorkspaceHeader(state: state),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 10,
                                    bottom: 8,
                                  ),
                                  child: WorkspaceTaskPanel(
                                    state: state,
                                    background: background,
                                    backgroundConfigured:
                                        backgroundPath != null,
                                    contextualTaskId: _contextualTaskId,
                                    onTaskLongPress: _showContextMenu,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (_contextualTaskId != null) ...[
                            Positioned.fill(
                              child: GestureDetector(
                                key: const ValueKey(
                                  'android-context-menu-barrier',
                                ),
                                behavior: HitTestBehavior.opaque,
                                onTap: _dismissContextMenu,
                                child: const SizedBox.expand(),
                              ),
                            ),
                            _AndroidTaskContextMenu(
                              pressPosition:
                                  _contextMenuPosition ?? Offset.zero,
                              availableSize: constraints.biggest,
                              onEdit: _editContextTask,
                              onDuplicate: _duplicateContextTask,
                              onDelete: _deleteContextTask,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  _AndroidTaskComposer(
                    state: state,
                    controller: _composerController,
                    focusNode: _composerFocusNode,
                    mode: _composerMode,
                    contextTask: _taskById(_composerTaskId),
                    onCancelSubtask: _cancelSubtaskContext,
                    onSubmit: _submitComposer,
                  ),
                ],
              ),
            ),
          );
    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _onKey,
      child: Scaffold(
        drawer: terminal
            ? null
            : Drawer(
                child: AndroidWorkspaceSidebar(
                  state: state,
                  onSelectList: _selectAndroidList,
                  onSettings: _showSettings,
                  onCreateList: _showListEditor,
                  onRenameList: () => _showListEditor(rename: true),
                  onDeleteList: _confirmDeleteList,
                ),
              ),
        drawerEdgeDragWidth: terminal ? null : MediaQuery.sizeOf(context).width,
        onDrawerChanged: terminal
            ? null
            : (opened) {
                if (opened) _cancelSubtaskContext();
              },
        body: Stack(
          children: [
            Positioned.fill(child: workspace),
            if (terminal && state.tipId != null)
              Positioned(
                left: TerminalMetrics.cell(context),
                right: TerminalMetrics.cell(context),
                bottom: TerminalMetrics.line(context) * 2,
                child: IgnorePointer(
                  child: WorkspaceTransientBanner(
                    text: _tipText(AppLocalizations.of(context)!, state.tipId!),
                  ),
                ),
              ),
            if (terminal && state.reward != null)
              Positioned.fill(
                child: IgnorePointer(
                  ignoring: !state.reward!.tutorialUnlock,
                  child: WorkspaceRewardOverlay(
                    text: state.reward!.tutorialUnlock
                        ? AppLocalizations.of(context)!.tutorialUnlockAward
                        : _rewardText(
                            AppLocalizations.of(context)!,
                            state.reward!.messageIndex,
                          ),
                    actionLabel: state.reward!.tutorialUnlock
                        ? AppLocalizations.of(context)!.great
                        : null,
                    onAction: state.reward!.tutorialUnlock
                        ? ref
                              .read(workspaceViewModelProvider.notifier)
                              .dismissReward
                        : null,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _AndroidTaskComposer extends StatelessWidget {
  const _AndroidTaskComposer({
    required this.state,
    required this.controller,
    required this.focusNode,
    required this.mode,
    required this.contextTask,
    required this.onCancelSubtask,
    required this.onSubmit,
  });

  final WorkspaceState state;
  final TextEditingController controller;
  final FocusNode focusNode;
  final _ComposerMode mode;
  final Task? contextTask;
  final VoidCallback onCancelSubtask;
  final Future<void> Function() onSubmit;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final palette = TerminalPalette.of(context);
    final modeLabel = switch (mode) {
      _ComposerMode.create => null,
      _ComposerMode.subtask => strings.newSubtask,
      _ComposerMode.edit => strings.editTask,
      _ComposerMode.duplicate => strings.duplicateTask,
    };
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) => Padding(
        key: const ValueKey('android-task-composer'),
        padding: const EdgeInsets.only(top: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (state.notice != null)
              Container(
                key: const ValueKey('android-composer-notice'),
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: (state.notice!.error ? palette.error : palette.done)
                      .withValues(alpha: .14),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  state.notice!.text,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: state.notice!.error ? palette.error : palette.done,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            if (mode == _ComposerMode.subtask &&
                contextTask != null &&
                value.text.trim().isNotEmpty)
              Container(
                key: const ValueKey('android-composer-reply'),
                margin: const EdgeInsets.only(left: 10, right: 54, bottom: 6),
                padding: const EdgeInsets.fromLTRB(12, 7, 4, 7),
                decoration: BoxDecoration(
                  color: palette.accent.withValues(alpha: .12),
                  border: Border(
                    left: BorderSide(color: palette.accent, width: 3),
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            strings.newSubtask,
                            style: TextStyle(
                              color: palette.accent,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            contextTask!.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: strings.cancel,
                      visualDensity: VisualDensity.compact,
                      onPressed: onCancelSubtask,
                      icon: const Icon(Icons.close, size: 18),
                    ),
                  ],
                ),
              ),
            if (modeLabel != null && mode != _ComposerMode.subtask)
              Padding(
                key: const ValueKey('android-composer-mode'),
                padding: const EdgeInsets.only(left: 16, bottom: 3),
                child: Text(
                  modeLabel,
                  style: TextStyle(
                    color: palette.accent,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextField(
                    key: const ValueKey('android-composer-field'),
                    controller: controller,
                    focusNode: focusNode,
                    minLines: 1,
                    maxLines: 4,
                    textInputAction: TextInputAction.newline,
                    decoration: InputDecoration(
                      hintText: mode == _ComposerMode.subtask
                          ? strings.addNewSubtask
                          : strings.addNewTask,
                      hintStyle: TextStyle(color: palette.muted),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 13,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(26),
                        borderSide: BorderSide(color: palette.muted),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(26),
                        borderSide: BorderSide(
                          color: palette.muted.withValues(alpha: .6),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(26),
                        borderSide: BorderSide(
                          color: palette.accent,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Semantics(
                  button: true,
                  label: strings.save,
                  child: Material(
                    key: const ValueKey('android-composer-send'),
                    color: palette.accent,
                    shape: const CircleBorder(),
                    clipBehavior: Clip.antiAlias,
                    child: IconButton(
                      tooltip: strings.save,
                      color: palette.background,
                      onPressed: onSubmit,
                      icon: const Icon(Icons.arrow_upward),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AndroidTaskContextMenu extends StatelessWidget {
  const _AndroidTaskContextMenu({
    required this.pressPosition,
    required this.availableSize,
    required this.onEdit,
    required this.onDuplicate,
    required this.onDelete,
  });

  static const _width = 164.0;
  static const _height = 54.0;

  final Offset pressPosition;
  final Size availableSize;
  final VoidCallback onEdit;
  final VoidCallback onDuplicate;
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
      key: const ValueKey('android-task-context-menu'),
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
              key: const ValueKey('android-context-edit'),
              tooltip: strings.edit,
              onPressed: onEdit,
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              key: const ValueKey('android-context-duplicate'),
              tooltip: strings.duplicate,
              onPressed: onDuplicate,
              icon: const Icon(Icons.copy),
            ),
            IconButton(
              key: const ValueKey('android-context-delete'),
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

String _tipText(AppLocalizations strings, String id) => switch (id) {
  'navigation' => strings.tipNavigation,
  'reorder' => strings.tipReorder,
  'subtasks' => strings.tipSubtasks,
  'search' => strings.tipSearch,
  'copy' => strings.tipCopy,
  _ => '',
};

String _rewardText(AppLocalizations strings, int index) => switch (index % 6) {
  0 => strings.rewardGreatWork,
  1 => strings.rewardNicelyDone,
  2 => strings.rewardKeepGoing,
  3 => strings.rewardMomentum,
  4 => strings.rewardTaskCleared,
  _ => strings.rewardExcellent,
};
