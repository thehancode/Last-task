import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:flutter_app/data/backend_task_list_repository.dart';
import 'package:flutter_app/data/backend_auth_session.dart';
import 'package:flutter_app/data/local/local_store_base.dart';
import 'package:flutter_app/domain/models.dart';
import 'package:flutter_app/domain/repositories.dart';

void main() {
  test('can log in again after logging out', () async {
    var loginCount = 0;
    final requests = <http.Request>[];
    final client = MockClient((request) async {
      requests.add(request);
      if (request.url.path == '/v1/auth/login') {
        loginCount++;
        return http.Response(
          jsonEncode({
            'access_token': 'access-token-$loginCount',
            'refresh_token': 'refresh-token-$loginCount',
            'user': {'display_name': 'hancode'},
          }),
          200,
        );
      }
      if (request.url.path == '/v1/admin/users') {
        return http.Response('{"users":[]}', 403);
      }
      if (request.method == 'DELETE' &&
          request.url.path == '/v1/auth/session') {
        expect(request.headers['authorization'], 'Bearer access-token-1');
        return http.Response('', 204);
      }
      throw StateError('Unexpected ${request.method} ${request.url}');
    });
    final session = BackendAuthSession(
      _AuthStore(),
      client: client,
      baseUri: Uri.parse('http://server.test:8080'),
    );

    await session.logIn('hancode', '43214321');
    await session.logOut();
    final user = await session.logIn('hancode', '43214321');

    expect(user.username, 'hancode');
    expect(requests.map((request) => request.url.path), [
      '/v1/auth/login',
      '/v1/admin/users',
      '/v1/auth/session',
      '/v1/auth/login',
      '/v1/admin/users',
    ]);
  });

  test(
    'uses a credential session to save a versioned task-list aggregate',
    () async {
      final requests = <http.Request>[];
      final client = MockClient((request) async {
        requests.add(request);
        if (request.url.path == '/v1/auth/login') {
          return http.Response(
            jsonEncode({
              'access_token': 'access-token',
              'refresh_token': 'refresh-token',
              'user': {'display_name': 'hancode'},
            }),
            200,
          );
        }
        if (request.url.path == '/v1/admin/users') {
          return http.Response('{"users":[]}', 403);
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
      final session = BackendAuthSession(
        _AuthStore(),
        client: client,
        baseUri: Uri.parse('http://server.test:8080'),
      );
      await session.logIn('hancode', '43214321');
      final repository = BackendTaskListRepository(auth: session);
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
        '/v1/auth/login',
        '/v1/admin/users',
        '/v1/task-lists/list-1',
      ]);
    },
  );

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

class _AuthStore implements PlatformLocalStore {
  Map<String, Object?>? _session;

  @override
  Future<void> deleteAuthSession() async => _session = null;

  @override
  Future<void> deleteTaskList(String id) async {}

  @override
  Future<Map<String, Object?>?> readAuthSession() async => _session;

  @override
  Future<Map<String, Object?>?> readDeviceState() async => null;

  @override
  Future<Map<String, Object?>?> readSettings() async => null;

  @override
  Future<List<StoredDocument>> readTaskLists() async => const [];

  @override
  Future<void> writeAuthSession(Map<String, Object?> value) async {
    _session = Map<String, Object?>.from(value);
  }

  @override
  Future<void> writeDeviceState(Map<String, Object?> value) async {}

  @override
  Future<void> writeSettings(Map<String, Object?> value) async {}

  @override
  Future<void> writeTaskList(String id, Map<String, Object?> value) async {}
}
