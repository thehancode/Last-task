import '../../domain/models.dart';

enum WorkspacePhase { loading, ready, failure }

class NoticeState {
  const NoticeState(
    this.text, {
    this.error = false,
    this.usesDoingColor = false,
  });
  final String text;
  final bool error;
  final bool usesDoingColor;
}

class WorkspaceSearchState {
  const WorkspaceSearchState({
    this.query = '',
    this.matchIds = const [],
    this.currentIndex = 0,
    required this.allLists,
  });

  final String query;
  final List<String> matchIds;
  final int currentIndex;
  final bool allLists;

  String? get currentTaskId => matchIds.isEmpty ? null : matchIds[currentIndex];

  WorkspaceSearchState copyWith({
    String? query,
    List<String>? matchIds,
    int? currentIndex,
  }) => WorkspaceSearchState(
    query: query ?? this.query,
    matchIds: matchIds ?? this.matchIds,
    currentIndex: currentIndex ?? this.currentIndex,
    allLists: allLists,
  );
}

class RewardState {
  const RewardState(this.messageIndex, this.taskId) : tutorialUnlock = false;

  const RewardState.tutorial()
    : messageIndex = 0,
      taskId = null,
      tutorialUnlock = true;

  final int messageIndex;
  final String? taskId;
  final bool tutorialUnlock;
}

class WorkspaceState {
  const WorkspaceState({
    required this.phase,
    required this.lists,
    required this.settings,
    required this.view,
    this.currentListId,
    this.selectedTaskId,
    this.returnToMultiAfterFocus = false,
    this.soundEnabled = true,
    this.animatedTaskId,
    this.notice,
    this.error,
    this.deviceState = const DeviceWorkspaceState(),
    this.highlightedTaskIds = const {},
    this.multiSelectedTaskIds = const {},
    this.selectionAnchorTaskId,
    this.tipId,
    this.reward,
    this.search,
  });

  const WorkspaceState.loading()
    : phase = WorkspacePhase.loading,
      lists = const [],
      settings = const AppSettings(),
      view = WorkspaceView.list,
      currentListId = null,
      selectedTaskId = null,
      returnToMultiAfterFocus = false,
      soundEnabled = true,
      animatedTaskId = null,
      notice = null,
      error = null,
      deviceState = const DeviceWorkspaceState(),
      highlightedTaskIds = const {},
      multiSelectedTaskIds = const {},
      selectionAnchorTaskId = null,
      tipId = null,
      reward = null,
      search = null;

  final WorkspacePhase phase;
  final List<TaskList> lists;
  final AppSettings settings;
  final WorkspaceView view;
  final String? currentListId;
  final String? selectedTaskId;
  final bool returnToMultiAfterFocus;
  final bool soundEnabled;
  final String? animatedTaskId;
  final NoticeState? notice;
  final String? error;
  final DeviceWorkspaceState deviceState;
  final Set<String> highlightedTaskIds;
  final Set<String> multiSelectedTaskIds;
  final String? selectionAnchorTaskId;
  final String? tipId;
  final RewardState? reward;
  final WorkspaceSearchState? search;

  WorkspaceState copyWith({
    WorkspacePhase? phase,
    List<TaskList>? lists,
    AppSettings? settings,
    WorkspaceView? view,
    String? currentListId,
    String? selectedTaskId,
    bool clearSelection = false,
    bool? returnToMultiAfterFocus,
    bool? soundEnabled,
    String? animatedTaskId,
    bool clearAnimation = false,
    NoticeState? notice,
    bool clearNotice = false,
    String? error,
    bool clearError = false,
    DeviceWorkspaceState? deviceState,
    Set<String>? highlightedTaskIds,
    Set<String>? multiSelectedTaskIds,
    bool clearMultiSelection = false,
    String? selectionAnchorTaskId,
    bool clearSelectionAnchor = false,
    String? tipId,
    bool clearTip = false,
    RewardState? reward,
    bool clearReward = false,
    WorkspaceSearchState? search,
    bool clearSearch = false,
  }) => WorkspaceState(
    phase: phase ?? this.phase,
    lists: lists ?? this.lists,
    settings: settings ?? this.settings,
    view: view ?? this.view,
    currentListId: currentListId ?? this.currentListId,
    selectedTaskId: clearSelection
        ? null
        : (selectedTaskId ?? this.selectedTaskId),
    returnToMultiAfterFocus:
        returnToMultiAfterFocus ?? this.returnToMultiAfterFocus,
    soundEnabled: soundEnabled ?? this.soundEnabled,
    animatedTaskId: clearAnimation
        ? null
        : (animatedTaskId ?? this.animatedTaskId),
    notice: clearNotice ? null : (notice ?? this.notice),
    error: clearError ? null : (error ?? this.error),
    deviceState: deviceState ?? this.deviceState,
    highlightedTaskIds: highlightedTaskIds ?? this.highlightedTaskIds,
    multiSelectedTaskIds: clearMultiSelection
        ? const {}
        : (multiSelectedTaskIds ?? this.multiSelectedTaskIds),
    selectionAnchorTaskId: clearSelectionAnchor
        ? null
        : (selectionAnchorTaskId ?? this.selectionAnchorTaskId),
    tipId: clearTip ? null : (tipId ?? this.tipId),
    reward: clearReward ? null : (reward ?? this.reward),
    search: clearSearch ? null : (search ?? this.search),
  );
}

extension WorkspaceStateQueries on WorkspaceState {
  bool get hasMultiSelection => multiSelectedTaskIds.isNotEmpty;
  TaskList? get currentList {
    final id = currentListId;
    if (id == null) return null;
    for (final list in lists) {
      if (list.id == id) return list;
    }
    return null;
  }

  Task? get selectedTask {
    final id = selectedTaskId;
    if (id == null) return null;
    for (final list in lists) {
      for (final task in list.tasks) {
        if (task.id == id) return task;
      }
    }
    return null;
  }

  TaskList? get selectedTaskList {
    final id = selectedTaskId;
    if (id == null) return null;
    for (final list in lists) {
      if (list.tasks.any((task) => task.id == id)) return list;
    }
    return null;
  }

  List<String> visibleTaskIdsFor(TaskList? list) => switch (view) {
    WorkspaceView.list => visibleTreeTasksInStatusOrder(list, const [
      TaskStatus.doing,
      TaskStatus.pending,
      TaskStatus.done,
      TaskStatus.archived,
    ]).map((task) => task.id).toList(),
    WorkspaceView.focus => visibleTreeTasks(
      list,
      rootStatuses: const {TaskStatus.doing},
    ).map((task) => task.id).toList(),
    WorkspaceView.completed => completedTreeRows(
      list,
    ).map((row) => row.task.id).toList(),
    WorkspaceView.multi => visibleTreeTasksInStatusOrder(list, const [
      TaskStatus.doing,
      TaskStatus.pending,
    ]).map((task) => task.id).toList(),
  };

  List<String> get visibleTaskIds => view == WorkspaceView.multi
      ? [for (final list in lists) ...visibleTaskIdsFor(list)]
      : visibleTaskIdsFor(currentList);

  List<CompletionEntry> get completedEntries => completionEntries(currentList);
}

class CompletionEntry {
  const CompletionEntry(this.task, this.completedAt);
  final Task task;
  final DateTime completedAt;
}

class CompletionTreeRow {
  const CompletionTreeRow(this.task, this.completedAt);
  final Task task;
  final DateTime? completedAt;
}

List<CompletionTreeRow> completedTreeRows(
  TaskList? list, {
  Set<String> revealTaskIds = const {},
}) {
  if (list == null) return const [];
  final revealPathIds = _taskRevealPathIds(list, revealTaskIds);
  final rows = <CompletionTreeRow>[];
  for (final entry in completionEntries(list)) {
    final suppressedParents = <String>{};
    for (final task in [entry.task, ...taskDescendants(list, entry.task)]) {
      final suppressed =
          task.parentId != null && suppressedParents.contains(task.parentId);
      if (!suppressed || revealPathIds.contains(task.id)) {
        rows.add(
          CompletionTreeRow(
            task,
            task.id == entry.task.id ? entry.completedAt : null,
          ),
        );
      }
      if (suppressed || task.collapsed) suppressedParents.add(task.id);
    }
  }
  return rows;
}

List<Task> visibleTreeTasks(
  TaskList? list, {
  Set<TaskStatus>? rootStatuses,
  Set<String> revealTaskIds = const {},
}) {
  if (list == null) return const [];
  final revealPathIds = _taskRevealPathIds(list, revealTaskIds);
  final result = <Task>[];
  final suppressedParents = <String>{};
  for (final task in list.tasks) {
    final root = taskRoot(list, task);
    if (rootStatuses != null && !rootStatuses.contains(root.status)) continue;
    final suppressed =
        task.parentId != null && suppressedParents.contains(task.parentId);
    if (!suppressed || revealPathIds.contains(task.id)) {
      result.add(task);
    }
    if (suppressed || task.collapsed) suppressedParents.add(task.id);
  }
  return result;
}

Set<String> _taskRevealPathIds(TaskList list, Set<String> revealTaskIds) {
  if (revealTaskIds.isEmpty) return const {};
  final byId = {for (final task in list.tasks) task.id: task};
  final result = <String>{};
  for (final id in revealTaskIds) {
    var task = byId[id];
    while (task != null && result.add(task.id)) {
      task = task.parentId == null ? null : byId[task.parentId];
    }
  }
  return result;
}

List<Task> visibleTreeTasksInStatusOrder(
  TaskList? list,
  List<TaskStatus> statuses,
) {
  if (list == null) return const [];
  final visible = visibleTreeTasks(list, rootStatuses: statuses.toSet());
  return [
    for (final status in statuses)
      for (final task in visible)
        if (taskRoot(list, task).status == status) task,
  ];
}

Task taskRoot(TaskList list, Task task) {
  var current = task;
  while (current.parentId != null) {
    current = list.tasks.firstWhere((item) => item.id == current.parentId);
  }
  return current;
}

int taskDepth(TaskList list, Task task) {
  var depth = 0;
  var current = task;
  while (current.parentId != null) {
    depth++;
    current = list.tasks.firstWhere((item) => item.id == current.parentId);
  }
  return depth;
}

bool taskHasChildren(TaskList list, Task task) =>
    list.tasks.any((candidate) => candidate.parentId == task.id);

List<Task> taskDescendants(TaskList list, Task task) {
  final descendantIds = <String>{task.id};
  final result = <Task>[];
  for (final candidate in list.tasks) {
    if (candidate.parentId != null &&
        descendantIds.contains(candidate.parentId)) {
      descendantIds.add(candidate.id);
      result.add(candidate);
    }
  }
  return result;
}

List<CompletionEntry> completionEntries(TaskList? list) {
  if (list == null) return const [];
  final entries = <CompletionEntry>[];
  for (final task in list.tasks) {
    if (task.parentId != null) continue;
    if (task.daily) {
      entries.addAll(
        task.completionHistory.map((time) => CompletionEntry(task, time)),
      );
    } else if (task.completedAt != null) {
      entries.add(CompletionEntry(task, task.completedAt!));
    }
  }
  entries.sort((a, b) => b.completedAt.compareTo(a.completedAt));
  return entries;
}
