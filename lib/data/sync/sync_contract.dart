import 'package:fixnum/fixnum.dart';
import 'package:uuid/uuid.dart';

import '../../domain/models.dart' as domain;
import 'generated/google/protobuf/field_mask.pb.dart';
import 'generated/google/protobuf/timestamp.pb.dart';
import 'generated/lasttask/sync/v1/sync.pb.dart' as wire;

const _uuid = Uuid();

Timestamp timestampFromDateTime(DateTime value) {
  final micros = value.toUtc().microsecondsSinceEpoch;
  return Timestamp(
    seconds: Int64(micros ~/ Duration.microsecondsPerSecond),
    nanos: (micros % Duration.microsecondsPerSecond) * 1000,
  );
}

DateTime dateTimeFromTimestamp(Timestamp value) =>
    DateTime.fromMicrosecondsSinceEpoch(
      value.seconds.toInt() * Duration.microsecondsPerSecond +
          value.nanos ~/ 1000,
      isUtc: true,
    );

String completionEventId(String taskId, DateTime occurredAt) => _uuid.v5(
  Namespace.url.value,
  '$taskId:${occurredAt.toUtc().toIso8601String()}',
);

wire.Task taskToWire(domain.Task task) => wire.Task(
  id: task.id,
  title: task.title,
  status: _statusToWire(task.status),
  createdAt: timestampFromDateTime(task.createdAt),
  updatedAt: timestampFromDateTime(task.updatedAt),
  completedAt: task.completedAt == null
      ? null
      : timestampFromDateTime(task.completedAt!),
  daily: task.daily,
  tags: task.tags.map(_tagToWire),
  parentId: task.parentId,
  completionEvents: task.completionHistory.map(
    (occurredAt) => wire.CompletionEvent(
      id: completionEventId(task.id, occurredAt),
      occurredAt: timestampFromDateTime(occurredAt),
      logicalDate: occurredAt.toLocal().toIso8601String().substring(0, 10),
    ),
  ),
);

domain.Task taskFromWire(wire.Task task) => domain.Task(
  id: task.id,
  title: task.title,
  status: _statusFromWire(task.status),
  createdAt: dateTimeFromTimestamp(task.createdAt),
  updatedAt: dateTimeFromTimestamp(task.updatedAt),
  completedAt: task.hasCompletedAt()
      ? dateTimeFromTimestamp(task.completedAt)
      : null,
  daily: task.daily,
  completionHistory: task.completionEvents
      .map((event) => dateTimeFromTimestamp(event.occurredAt))
      .toList(growable: false),
  tags: task.tags.map(_tagFromWire).toList(growable: false),
  parentId: task.hasParentId() ? task.parentId : null,
);

wire.TaskList listToWire(domain.TaskList list, {int version = 0}) =>
    wire.TaskList(
      schemaVersion: list.schemaVersion,
      id: list.id,
      name: list.name,
      createdAt: timestampFromDateTime(list.createdAt),
      habit: list.isHabit,
      tutorial: list.isTutorial,
      tasks: list.tasks.map(taskToWire),
      version: Int64(version),
    );

domain.TaskList listFromWire(wire.TaskList list, {int? sortIndex}) =>
    domain.TaskList(
      schemaVersion: list.schemaVersion,
      id: list.id,
      name: list.name,
      createdAt: dateTimeFromTimestamp(list.createdAt),
      tasks: list.tasks.map(taskFromWire).toList(growable: false),
      isHabit: list.habit,
      isTutorial: list.tutorial,
      sortIndex: sortIndex,
    );

List<wire.Operation> diffList(domain.TaskList? before, domain.TaskList after) {
  if (before == null) {
    final operations = <wire.Operation>[
      wire.Operation(
        createList: wire.CreateList(
          listId: after.id,
          name: after.name,
          createdAt: timestampFromDateTime(after.createdAt),
          habit: after.isHabit,
          tutorial: after.isTutorial,
        ),
      ),
    ];
    for (var index = 0; index < after.tasks.length; index++) {
      final afterTaskId = _previousSiblingId(after.tasks, index);
      operations.add(
        wire.Operation(
          createTask: wire.CreateTask(
            listId: after.id,
            task: taskToWire(after.tasks[index]),
            afterTaskId: afterTaskId,
          ),
        ),
      );
    }
    return operations;
  }

  final operations = <wire.Operation>[];
  if (before.name != after.name) {
    operations.add(
      wire.Operation(
        renameList: wire.RenameList(listId: after.id, name: after.name),
      ),
    );
  }
  final oldById = {for (final task in before.tasks) task.id: task};
  final newById = {for (final task in after.tasks) task.id: task};

  // Delete only missing subtree roots; deleting a root removes its descendants.
  for (final task in before.tasks) {
    if (newById.containsKey(task.id)) continue;
    if (task.parentId != null && !newById.containsKey(task.parentId)) continue;
    operations.add(
      wire.Operation(
        deleteTask: wire.DeleteTask(listId: after.id, taskId: task.id),
      ),
    );
  }

  for (var index = 0; index < after.tasks.length; index++) {
    final task = after.tasks[index];
    final old = oldById[task.id];
    final afterTaskId = _previousSiblingId(after.tasks, index);
    if (old == null) {
      operations.add(
        wire.Operation(
          createTask: wire.CreateTask(
            listId: after.id,
            task: taskToWire(task),
            afterTaskId: afterTaskId,
          ),
        ),
      );
      continue;
    }
    final fields = <String>[];
    if (old.title != task.title) fields.add('title');
    if (!_sameList(old.tags, task.tags)) fields.add('tags');
    if (fields.isNotEmpty) {
      operations.add(
        wire.Operation(
          updateTask: wire.UpdateTask(
            listId: after.id,
            task: taskToWire(task),
            updateMask: FieldMask(paths: fields),
          ),
        ),
      );
    }
    if (old.status != task.status || old.completedAt != task.completedAt) {
      operations.add(
        wire.Operation(
          setTaskStatus: wire.SetTaskStatus(
            listId: after.id,
            taskId: task.id,
            status: _statusToWire(task.status),
            changedAt: timestampFromDateTime(task.updatedAt),
            reason: wire.StatusChangeReason.STATUS_CHANGE_REASON_USER,
          ),
        ),
      );
    }
    final oldEvents = {
      for (final value in old.completionHistory)
        completionEventId(task.id, value): value,
    };
    final newEvents = {
      for (final value in task.completionHistory)
        completionEventId(task.id, value): value,
    };
    for (final entry in newEvents.entries) {
      if (oldEvents.containsKey(entry.key)) continue;
      operations.add(
        wire.Operation(
          addCompletionEvent: wire.AddCompletionEvent(
            listId: after.id,
            taskId: task.id,
            event: taskToWire(
              task,
            ).completionEvents.firstWhere((event) => event.id == entry.key),
          ),
        ),
      );
    }
    for (final id in oldEvents.keys) {
      if (!newEvents.containsKey(id)) {
        operations.add(
          wire.Operation(
            removeCompletionEvent: wire.RemoveCompletionEvent(
              listId: after.id,
              taskId: task.id,
              eventId: id,
            ),
          ),
        );
      }
    }
    final oldIndex = before.tasks.indexWhere(
      (candidate) => candidate.id == task.id,
    );
    final oldAfterTaskId = _previousSiblingId(before.tasks, oldIndex);
    if (old.parentId != task.parentId || oldAfterTaskId != afterTaskId) {
      operations.add(
        wire.Operation(
          moveTask: wire.MoveTask(
            listId: after.id,
            taskId: task.id,
            parentId: task.parentId,
            afterTaskId: afterTaskId,
          ),
        ),
      );
    }
  }
  return operations;
}

bool _sameList<T>(List<T> left, List<T> right) {
  if (left.length != right.length) return false;
  for (var index = 0; index < left.length; index++) {
    if (left[index] != right[index]) return false;
  }
  return true;
}

String? _previousSiblingId(List<domain.Task> tasks, int index) {
  final parentId = tasks[index].parentId;
  for (var candidate = index - 1; candidate >= 0; candidate--) {
    if (tasks[candidate].parentId == parentId) return tasks[candidate].id;
  }
  return null;
}

wire.TaskStatus _statusToWire(domain.TaskStatus status) => switch (status) {
  domain.TaskStatus.pending => wire.TaskStatus.TASK_STATUS_PENDING,
  domain.TaskStatus.doing => wire.TaskStatus.TASK_STATUS_DOING,
  domain.TaskStatus.done => wire.TaskStatus.TASK_STATUS_DONE,
  domain.TaskStatus.archived => wire.TaskStatus.TASK_STATUS_ARCHIVED,
};

domain.TaskStatus _statusFromWire(wire.TaskStatus status) => switch (status) {
  wire.TaskStatus.TASK_STATUS_DOING => domain.TaskStatus.doing,
  wire.TaskStatus.TASK_STATUS_DONE => domain.TaskStatus.done,
  wire.TaskStatus.TASK_STATUS_ARCHIVED => domain.TaskStatus.archived,
  _ => domain.TaskStatus.pending,
};

wire.TaskTag _tagToWire(domain.TaskTag tag) => switch (tag) {
  domain.TaskTag.spade => wire.TaskTag.TASK_TAG_SPADE,
  domain.TaskTag.heart => wire.TaskTag.TASK_TAG_HEART,
  domain.TaskTag.club => wire.TaskTag.TASK_TAG_CLUB,
  domain.TaskTag.diamond => wire.TaskTag.TASK_TAG_DIAMOND,
};

domain.TaskTag _tagFromWire(wire.TaskTag tag) => switch (tag) {
  wire.TaskTag.TASK_TAG_HEART => domain.TaskTag.heart,
  wire.TaskTag.TASK_TAG_CLUB => domain.TaskTag.club,
  wire.TaskTag.TASK_TAG_DIAMOND => domain.TaskTag.diamond,
  _ => domain.TaskTag.spade,
};
