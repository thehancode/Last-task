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

DateTime _localCalendarDay(DateTime value) =>
    DateTime(value.year, value.month, value.day);

enum _ComposerMode { create, subtask, edit, duplicate }

class WorkspaceScreen extends ConsumerStatefulWidget {
  const WorkspaceScreen({super.key});

  @override
  ConsumerState<WorkspaceScreen> createState() => _WorkspaceScreenState();
}

class _WorkspaceScreenState extends ConsumerState<WorkspaceScreen>
    with WidgetsBindingObserver {
  final _focusNode = FocusNode(debugLabel: 'workspace');
  final _scaffoldKey = GlobalKey<ScaffoldState>();
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
  String? _loadedComposerListId;
  bool _updatingComposerText = false;
  double _lastViewInset = 0;
  String? _contextualTaskId;
  Offset? _contextMenuPosition;
  bool _androidSecondaryListPage = false;
  late DateTime _completionLabelDay;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _completionLabelDay = _localCalendarDay(DateTime.now());
    _composerController.addListener(_onComposerChanged);
    _composerFocusNode.addListener(_onComposerFocusChanged);
    _dailyRefreshTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      _refreshCompletionLabels();
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    _lastViewInset = View.of(context).viewInsets.bottom;
  }

  @override
  void didChangeMetrics() {
    if (!mounted) return;
    final inset = View.of(context).viewInsets.bottom;
    if (_lastViewInset > 0 && inset == 0 && _composerFocusNode.hasFocus) {
      _composerFocusNode.unfocus();
    }
    _lastViewInset = inset;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshCompletionLabels();
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

  void _refreshCompletionLabels() {
    final today = _localCalendarDay(DateTime.now());
    if (today == _completionLabelDay || !mounted) return;
    setState(() => _completionLabelDay = today);
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
    _composerController
      ..removeListener(_onComposerChanged)
      ..dispose();
    _composerFocusNode
      ..removeListener(_onComposerFocusChanged)
      ..dispose();
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

  String _currentComposerDraft() {
    final state = ref.read(workspaceViewModelProvider);
    final listId = state.currentListId;
    if (listId == null) return '';
    return (state.deviceState.composerDrafts[listId] ?? '').replaceAll(
      RegExp(r'[\r\n]+'),
      ' ',
    );
  }

  void _replaceComposerText(String text) {
    _updatingComposerText = true;
    _composerController.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
    _updatingComposerText = false;
  }

  void _restoreCurrentDraft() {
    _loadedComposerListId = ref.read(workspaceViewModelProvider).currentListId;
    _replaceComposerText(_currentComposerDraft());
  }

  void _onComposerChanged() {
    if (_updatingComposerText || _composerMode != _ComposerMode.create) return;
    final listId = ref.read(workspaceViewModelProvider).currentListId;
    if (listId == null) return;
    ref
        .read(workspaceViewModelProvider.notifier)
        .updateComposerDraft(listId, _composerController.text);
  }

  void _onComposerFocusChanged() {
    if (!mounted) return;
    if (!_composerFocusNode.hasFocus && _composerMode == _ComposerMode.create) {
      final listId = ref.read(workspaceViewModelProvider).currentListId;
      if (listId != null) {
        ref
            .read(workspaceViewModelProvider.notifier)
            .updateComposerDraft(
              listId,
              _composerController.text,
              immediate: true,
            );
      }
    }
    setState(() {});
  }

  void _activateComposer(
    _ComposerMode mode, {
    Task? task,
    bool requestFocus = true,
  }) {
    final text = switch (mode) {
      _ComposerMode.create => _currentComposerDraft(),
      _ComposerMode.edit || _ComposerMode.duplicate => task?.title ?? '',
      _ComposerMode.subtask => '',
    };
    setState(() {
      _composerMode = mode;
      _composerTaskId = task?.id;
      if (mode == _ComposerMode.create) {
        _loadedComposerListId = ref
            .read(workspaceViewModelProvider)
            .currentListId;
      }
      _replaceComposerText(text);
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
    _activateComposer(_ComposerMode.subtask, task: task, requestFocus: false);
    return true;
  }

  Future<void> _submitComposer() async {
    final input = _composerController.text;
    final submittedMode = _composerMode;
    final submittedListId = ref.read(workspaceViewModelProvider).currentListId;
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
    if (submittedMode == _ComposerMode.create && submittedListId != null) {
      ref
          .read(workspaceViewModelProvider.notifier)
          .updateComposerDraft(submittedListId, '', immediate: true);
    }
    _dismissContextMenu(cancelComposer: false);
    _activateComposer(_ComposerMode.create, requestFocus: false);
    _composerFocusNode.requestFocus();
  }

  void _showContextMenu(Task task, Offset position) {
    ref.read(workspaceViewModelProvider.notifier).selectTask(task.id);
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
    final restoreDraft =
        cancelComposer && _composerMode == _ComposerMode.subtask;
    setState(() {
      _contextualTaskId = null;
      _contextMenuPosition = null;
      if (cancelComposer && _composerMode == _ComposerMode.subtask) {
        _composerMode = _ComposerMode.create;
        _composerTaskId = null;
      }
    });
    if (restoreDraft) _restoreCurrentDraft();
  }

  void _cancelSubtaskContext() {
    if (_contextualTaskId != null) {
      _dismissContextMenu();
    } else if (_composerMode == _ComposerMode.subtask) {
      _activateComposer(_ComposerMode.create, requestFocus: false);
    }
  }

  void _cancelEditingComposer() {
    _activateComposer(_ComposerMode.create, requestFocus: false);
    ref.read(workspaceViewModelProvider.notifier).clearTaskSelection();
  }

  void _selectAndroidList(String listId) {
    if (_androidSecondaryListPage) {
      setState(() => _androidSecondaryListPage = false);
    }
    ref.read(workspaceViewModelProvider.notifier).selectList(listId);
    _activateComposer(_ComposerMode.create, requestFocus: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.requestFocus();
    });
  }

  void _setAndroidListPage(int index) {
    final secondary = index == 1;
    if (_androidSecondaryListPage == secondary) return;
    setState(() => _androidSecondaryListPage = secondary);
  }

  void _openAndroidSidebar() => _scaffoldKey.currentState?.openDrawer();

  void _editContextTask() {
    final task = _taskById(_contextualTaskId);
    _dismissContextMenu(cancelComposer: false);
    if (task != null) _activateComposer(_ComposerMode.edit, task: task);
  }

  Future<void> _copyContextTask() async {
    final task = _taskById(_contextualTaskId);
    if (task == null) return;
    _dismissContextMenu();
    await Clipboard.setData(ClipboardData(text: task.title));
    if (!mounted) return;
    final vm = ref.read(workspaceViewModelProvider.notifier);
    vm.highlightTasks([task.id]);
    vm.showNotice(
      AppLocalizations.of(context)!.taskWasCopied,
      usesDoingColor: true,
    );
  }

  Future<void> _deleteContextTask() async {
    final task = _taskById(_contextualTaskId);
    _dismissContextMenu(cancelComposer: false);
    if (task == null) return;
    _activateComposer(_ComposerMode.create, requestFocus: false);
    ref.read(workspaceViewModelProvider.notifier).selectTask(task.id);
    await _confirmDeleteTask();
  }

  Future<void> _archiveContextTask() async {
    final task = _taskById(_contextualTaskId);
    _dismissContextMenu(cancelComposer: false);
    if (task == null) return;
    _activateComposer(_ComposerMode.create, requestFocus: false);
    final vm = ref.read(workspaceViewModelProvider.notifier);
    vm.selectTask(task.id);
    await vm.archiveSelectedTask();
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
        if (usesTerminalPresentation &&
            HardwareKeyboard.instance.isShiftPressed) {
          unawaited(vm.redo());
        } else {
          unawaited(vm.undo());
        }
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
        final selected = ref.read(workspaceViewModelProvider).selectedTask;
        unawaited(
          selected?.status == TaskStatus.done ||
                  selected?.status == TaskStatus.archived
              ? vm.restoreSelectedTaskToPending()
              : vm.completeSelectedTask(),
        );
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
    if (usesTerminalPresentation && key == LogicalKeyboardKey.enter) {
      unawaited(
        _showTaskEditor(edit: HardwareKeyboard.instance.isShiftPressed),
      );
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.f2) {
      unawaited(_showListEditor(rename: true));
    } else if (!usesTerminalPresentation && key == LogicalKeyboardKey.keyN) {
      unawaited(_showTaskEditor());
    } else if (key == LogicalKeyboardKey.keyA) {
      unawaited(_showTaskEditor(subtask: true));
    } else if (key == LogicalKeyboardKey.keyH) {
      unawaited(vm.toggleSelectedCollapsed());
    } else if (!usesTerminalPresentation && key == LogicalKeyboardKey.keyE) {
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
    if (usesTerminalPresentation) {
      await showDialog<void>(
        context: context,
        builder: (_) => const WorkspaceSettingsDialog(),
      );
    } else {
      await Navigator.of(context).push<void>(
        MaterialPageRoute(builder: (_) => const WorkspaceSettingsDialog()),
      );
    }
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
    if (!terminal &&
        state.phase == WorkspacePhase.ready &&
        _composerMode == _ComposerMode.create &&
        _loadedComposerListId != state.currentListId) {
      _loadedComposerListId = state.currentListId;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _composerMode == _ComposerMode.create) {
          _restoreCurrentDraft();
        }
      });
    }
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
                              AndroidWorkspaceHeader(
                                state: state,
                                onOpenSidebar: _openAndroidSidebar,
                              ),
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
                                    onAndroidListPageChanged:
                                        _setAndroidListPage,
                                    onAndroidOpenDrawer: _openAndroidSidebar,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (state.notice != null)
                            Positioned(
                              left: 8,
                              right: 8,
                              bottom: 16,
                              child: IgnorePointer(
                                child: _AndroidNoticeBanner(
                                  notice: state.notice!,
                                ),
                              ),
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
                              onCopy: _copyContextTask,
                              onArchive: _archiveContextTask,
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
    final focusedWorkspace = Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _onKey,
      child: Scaffold(
        key: _scaffoldKey,
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
        drawerEdgeDragWidth: terminal
            ? null
            : state.view == WorkspaceView.list
            ? 24
            : MediaQuery.sizeOf(context).width,
        drawerEnableOpenDragGesture:
            terminal || state.view != WorkspaceView.list,
        onDrawerChanged: terminal
            ? null
            : (opened) {
                if (opened) _cancelSubtaskContext();
              },
        body: Stack(
          children: [
            Positioned.fill(child: workspace),
            if (!terminal &&
                state.view == WorkspaceView.list &&
                !_androidSecondaryListPage)
              Positioned(
                key: const ValueKey('android-drawer-edge-region'),
                left: 0,
                top: 0,
                bottom: 0,
                width: AndroidGestureConfig.drawerEdgeWidth,
                child: AndroidDrawerEdgeDragRegion(
                  onOpenDrawer: _openAndroidSidebar,
                ),
              ),
          ],
        ),
      ),
    );
    if (terminal) return focusedWorkspace;
    return PopScope(
      canPop:
          !_composerFocusNode.hasFocus &&
          _composerMode == _ComposerMode.create &&
          state.selectedTaskId == null,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        if (_composerFocusNode.hasFocus) {
          _composerFocusNode.unfocus();
        } else if (_composerMode == _ComposerMode.edit ||
            _composerMode == _ComposerMode.duplicate) {
          _cancelEditingComposer();
        } else if (ref.read(workspaceViewModelProvider).selectedTaskId !=
            null) {
          _dismissContextMenu();
          ref.read(workspaceViewModelProvider.notifier).clearTaskSelection();
        }
      },
      child: focusedWorkspace,
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
    final hasContext = contextTask != null;
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) => TextFieldTapRegion(
        child: Padding(
          key: const ValueKey('android-task-composer'),
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (mode == _ComposerMode.subtask &&
                  contextTask != null &&
                  focusNode.hasFocus)
                _AndroidComposerPreview(
                  key: const ValueKey('android-composer-reply'),
                  label: strings.newSubtask,
                  text: contextTask!.title,
                  onCancel: onCancelSubtask,
                )
              else if (mode == _ComposerMode.edit && contextTask != null)
                _AndroidComposerPreview(
                  key: const ValueKey('android-composer-edit-preview'),
                  label: strings.editTask,
                  text: value.text,
                ),
              if (mode == _ComposerMode.duplicate)
                Padding(
                  key: const ValueKey('android-composer-mode'),
                  padding: const EdgeInsets.only(left: 16, bottom: 3),
                  child: Text(
                    strings.duplicateTask,
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
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 79),
                      child: TextField(
                        key: const ValueKey('android-composer-field'),
                        controller: controller,
                        focusNode: focusNode,
                        minLines: 1,
                        maxLines: null,
                        textInputAction: TextInputAction.newline,
                        style: const TextStyle(fontSize: 14, height: 1.2),
                        scrollPhysics: const ClampingScrollPhysics(),
                        onTapOutside: (_) => focusNode.unfocus(),
                        decoration: InputDecoration(
                          hintText: mode == _ComposerMode.subtask
                              ? strings.addNewSubtask
                              : strings.addNewTask,
                          hintStyle: TextStyle(color: palette.muted),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 10,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(26),
                            borderSide: BorderSide(color: palette.muted),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(26),
                            borderSide: BorderSide(
                              color: hasContext
                                  ? palette.accent
                                  : palette.muted.withValues(alpha: .6),
                              width: hasContext ? 1.5 : 1,
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
      ),
    );
  }
}

class _AndroidNoticeBanner extends StatelessWidget {
  const _AndroidNoticeBanner({required this.notice});

  final NoticeState notice;

  @override
  Widget build(BuildContext context) {
    final palette = TerminalPalette.of(context);
    final color = notice.error ? palette.error : palette.done;
    return Container(
      key: const ValueKey('android-floating-notice'),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        notice.text,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _AndroidComposerPreview extends StatelessWidget {
  const _AndroidComposerPreview({
    super.key,
    required this.label,
    required this.text,
    this.onCancel,
  });

  final String label;
  final String text;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    final palette = TerminalPalette.of(context);
    final strings = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 54, bottom: 6),
      padding: EdgeInsets.fromLTRB(12, 7, onCancel == null ? 12 : 4, 7),
      decoration: BoxDecoration(
        color: palette.accent.withValues(alpha: .12),
        border: Border(left: BorderSide(color: palette.accent, width: 3)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: palette.accent,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 112),
                  child: Scrollbar(
                    child: SingleChildScrollView(child: Text(text)),
                  ),
                ),
              ],
            ),
          ),
          if (onCancel != null)
            IconButton(
              tooltip: strings.cancel,
              visualDensity: VisualDensity.compact,
              onPressed: onCancel,
              icon: const Icon(Icons.close, size: 18),
            ),
        ],
      ),
    );
  }
}

class _AndroidTaskContextMenu extends StatelessWidget {
  const _AndroidTaskContextMenu({
    required this.pressPosition,
    required this.availableSize,
    required this.onEdit,
    required this.onCopy,
    required this.onArchive,
    required this.onDelete,
  });

  static const _width = 212.0;
  static const _height = 54.0;

  final Offset pressPosition;
  final Size availableSize;
  final VoidCallback onEdit;
  final VoidCallback onCopy;
  final VoidCallback onArchive;
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
              key: const ValueKey('android-context-copy'),
              tooltip: strings.copy,
              onPressed: onCopy,
              icon: const Icon(Icons.copy),
            ),
            IconButton(
              key: const ValueKey('android-context-archive'),
              tooltip: strings.archive,
              onPressed: onArchive,
              icon: const Icon(Icons.archive_outlined),
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
