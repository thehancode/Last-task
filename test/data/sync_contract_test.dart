import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/data/sync/generated/lasttask/sync/v1/sync.pb.dart'
    as wire;
import 'package:flutter_app/data/sync/sync_contract.dart';
import 'package:flutter_app/domain/models.dart';

void main() {
  test('new list becomes create-list followed by ordered task operations', () {
    final operations = diffList(null, _list());

    expect(operations.map((operation) => operation.whichValue()), [
      wire.Operation_Value.createList,
      wire.Operation_Value.createTask,
      wire.Operation_Value.createTask,
    ]);
    expect(operations[2].createTask.hasAfterTaskId(), isFalse);
    expect(operations[2].createTask.task.parentId, 'task-1');
  });

  test('editing one task emits field, status, completion, and move deltas', () {
    final before = _list();
    final completedAt = DateTime.utc(2026, 7, 28, 13);
    final changedTask = before.tasks[1].copyWith(
      title: 'Changed',
      status: TaskStatus.done,
      updatedAt: completedAt,
      completedAt: completedAt,
      completionHistory: [completedAt],
      tags: const [TaskTag.heart],
      clearParentId: true,
    );
    final after = before.copyWith(tasks: [changedTask, before.tasks[0]]);

    final operations = diffList(before, after);
    final kinds = operations.map((operation) => operation.whichValue()).toSet();

    expect(kinds, contains(wire.Operation_Value.updateTask));
    expect(kinds, contains(wire.Operation_Value.setTaskStatus));
    expect(kinds, contains(wire.Operation_Value.addCompletionEvent));
    expect(kinds, contains(wire.Operation_Value.moveTask));
    expect(
      operations
          .firstWhere((operation) => operation.hasUpdateTask())
          .updateTask
          .updateMask
          .paths,
      containsAll(['title', 'tags']),
    );
  });

  test('wire conversion intentionally excludes device-local collapse', () {
    final collapsed = _list().tasks.first.copyWith(collapsed: true);

    final roundTrip = taskFromWire(taskToWire(collapsed));

    expect(roundTrip.collapsed, isFalse);
    expect(roundTrip.id, collapsed.id);
  });
}

TaskList _list() {
  final now = DateTime.utc(2026, 7, 28, 12);
  return TaskList(
    schemaVersion: 1,
    id: 'list-1',
    name: 'Work',
    createdAt: now,
    tasks: [
      Task(
        id: 'task-1',
        title: 'Root',
        status: TaskStatus.pending,
        createdAt: now,
        updatedAt: now,
        completedAt: null,
        daily: false,
        completionHistory: const [],
      ),
      Task(
        id: 'task-2',
        title: 'Child',
        status: TaskStatus.pending,
        createdAt: now,
        updatedAt: now,
        completedAt: null,
        daily: false,
        completionHistory: const [],
        parentId: 'task-1',
      ),
    ],
  );
}
