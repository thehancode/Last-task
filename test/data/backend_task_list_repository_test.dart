import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:flutter_app/data/backend_task_list_repository.dart';
import 'package:flutter_app/domain/models.dart';
import 'package:flutter_app/domain/repositories.dart';

void main() {
  test('authenticates then saves a versioned task-list aggregate', () async {
    final requests = <http.Request>[];
    final client = MockClient((request) async {
      requests.add(request);
      if (request.url.path == '/v1/auth/google') {
        return http.Response(jsonEncode({'access_token': 'access-token'}), 201);
      }
      expect(request.headers['authorization'], 'Bearer access-token');
      if (request.method == 'PUT') {
        final body = jsonDecode(request.body) as Map<String, Object?>;
        expect(body['expected_version'], 0);
        return http.Response(
          jsonEncode({'version': 1, 'list': body['list']}),
          201,
        );
      }
      throw StateError('Unexpected ${request.method} ${request.url}');
    });
    final repository = BackendTaskListRepository(
      client: client,
      baseUri: Uri.parse('http://server.test:8080'),
    );
    final now = DateTime.utc(2026, 7, 26);
    final list = TaskList(
      schemaVersion: 1,
      id: 'list-1',
      name: 'Work',
      createdAt: now,
      tasks: [
        Task(
          id: 'task-1',
          title: 'Ship backend',
          status: TaskStatus.pending,
          createdAt: now,
          updatedAt: now,
          completedAt: null,
          daily: false,
          completionHistory: const [],
        ),
      ],
    );

    await repository.save(list);

    expect(requests.map((request) => request.url.path), [
      '/v1/auth/google',
      '/v1/task-lists/list-1',
    ]);
  });

  test('switching to a non-empty backend does not overwrite it', () async {
    final local = _Lists();
    final backend = _Lists(
      TaskListLoadResult(lists: [_list()], warnings: const []),
    );
    final repository = SwitchingTaskListRepository(
      local,
      backend,
      _Settings(const AppSettings()),
    );

    await expectLater(
      repository.enableBackend([_list()]),
      throwsA(isA<StateError>()),
    );
  });
}

TaskList _list() => TaskList(
  schemaVersion: 1,
  id: 'list',
  name: 'List',
  createdAt: DateTime.utc(2026),
  tasks: const [],
);

class _Lists implements TaskListRepository {
  _Lists([this.result = const TaskListLoadResult(lists: [], warnings: [])]);

  final TaskListLoadResult result;

  @override
  Future<void> commit(TaskListChangeSet changes) async {}

  @override
  Future<void> delete(String listId) async {}

  @override
  Future<TaskListLoadResult> loadAll() async => result;

  @override
  Future<void> save(TaskList list) async {}
}

class _Settings implements SettingsRepository {
  const _Settings(this.value);

  final AppSettings value;

  @override
  Future<AppSettings> load() async => value;

  @override
  Future<void> save(AppSettings settings) async {}
}
