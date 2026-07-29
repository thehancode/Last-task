import 'dart:async';
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

  test('writes locally before syncing to the backend in background', () async {
    final backendSave = Completer<void>();
    final local = _Lists();
    final backend = _Lists(saveGate: backendSave);
    final repository = LocalFirstTaskListRepository(local, backend);

    await repository.save(_list());

    expect(local.events, ['save:list']);
    expect(backend.events, isEmpty);

    await Future<void>.delayed(Duration.zero);
    expect(backend.events, ['load', 'save:list']);

    backendSave.complete();
    await repository.flushBackendWrites();
  });

  test('serializes background writes after loading backend versions', () async {
    final firstSave = Completer<void>();
    final local = _Lists();
    final backend = _Lists(saveGate: firstSave);
    final repository = LocalFirstTaskListRepository(local, backend);

    await repository.save(_list());
    await repository.save(_list().copyWith(name: 'Updated'));
    await Future<void>.delayed(Duration.zero);

    expect(local.events, ['save:list', 'save:list']);
    expect(backend.events, ['load', 'save:list']);

    firstSave.complete();
    await repository.flushBackendWrites();

    expect(backend.events, ['load', 'save:list', 'save:list']);
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
  _Lists({this.saveGate});

  final Completer<void>? saveGate;
  final List<String> events = [];
  var _saveCount = 0;

  @override
  Future<void> commit(TaskListChangeSet changes) async {
    events.add('commit');
  }

  @override
  Future<void> delete(String listId) async {
    events.add('delete:$listId');
  }

  @override
  Future<TaskListLoadResult> loadAll() async {
    events.add('load');
    return const TaskListLoadResult(lists: [], warnings: []);
  }

  @override
  Future<void> save(TaskList list) async {
    events.add('save:${list.id}');
    if (_saveCount++ == 0 && saveGate != null) await saveGate!.future;
  }
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
