import 'dart:convert';

import 'package:http/http.dart' as http;

import '../domain/models.dart';
import '../domain/repositories.dart';
import 'backend_auth_session.dart';
import 'local/local_store.dart';

class BackendTaskListRepository implements TaskListRepository {
  BackendTaskListRepository({
    BackendAuthSession? auth,
    http.Client? client,
    Uri? baseUri,
  }) : _auth =
           auth ??
           BackendAuthSession(
             createPlatformLocalStore(),
             client: client,
             baseUri: baseUri,
           );

  final BackendAuthSession _auth;
  final Map<String, int> _versions = {};

  @override
  Future<TaskListLoadResult> loadAll() async {
    final response = await _request('GET', '/v1/task-lists');
    final body = _object(response.body);
    final lists = <TaskList>[];
    for (final value in body['lists'] as List<Object?>? ?? const []) {
      final envelope = Map<String, Object?>.from(value! as Map);
      final list = TaskList.fromJson(
        Map<String, Object?>.from(envelope['list']! as Map),
      );
      list.validate();
      _versions[list.id] = envelope['version']! as int;
      lists.add(list);
    }
    return TaskListLoadResult(lists: lists, warnings: const []);
  }

  @override
  Future<void> save(TaskList list) async {
    list.validate();
    final response = await _request(
      'PUT',
      '/v1/task-lists/${Uri.encodeComponent(list.id)}',
      body: {
        'expected_version': _versions[list.id] ?? 0,
        'list': list.toJson(),
      },
    );
    final result = _object(response.body);
    _versions[list.id] = result['version']! as int;
  }

  @override
  Future<void> delete(String listId) async {
    final version = _versions[listId];
    if (version == null) {
      throw StateError('No backend version is known for task list $listId');
    }
    await _request(
      'DELETE',
      '/v1/task-lists/${Uri.encodeComponent(listId)}?expected_version=$version',
    );
    _versions.remove(listId);
  }

  @override
  Future<void> commit(TaskListChangeSet changes) async {
    for (final list in changes.upserts) {
      list.validate();
    }
    final response = await _request(
      'POST',
      '/v1/task-lists/batch',
      body: {
        'upserts': [
          for (final list in changes.upserts)
            {
              'expected_version': _versions[list.id] ?? 0,
              'list': list.toJson(),
            },
        ],
        'deletes': [
          for (final id in changes.deletes)
            {'id': id, 'expected_version': _versions[id] ?? 0},
        ],
      },
    );
    final result = _object(response.body);
    for (final value in result['lists'] as List<Object?>? ?? const []) {
      final item = Map<String, Object?>.from(value! as Map);
      _versions[item['id']! as String] = item['version']! as int;
    }
    for (final id in changes.deletes) {
      _versions.remove(id);
    }
  }

  Future<http.Response> _request(
    String method,
    String path, {
    Map<String, Object?>? body,
  }) async {
    return _auth.request(method, path, body: body);
  }

  Map<String, Object?> _object(String value) =>
      Map<String, Object?>.from(jsonDecode(value) as Map);
}

class SwitchingTaskListRepository
    implements TaskListRepository, PersistenceModeRepository {
  SwitchingTaskListRepository(this._local, this._backend, this._settings);

  final TaskListRepository _local;
  final TaskListRepository _backend;
  final SettingsRepository _settings;

  Future<TaskListRepository> get _active async =>
      (await _settings.load()).useBackend ? _backend : _local;

  @override
  Future<void> commit(TaskListChangeSet changes) async =>
      (await _active).commit(changes);

  @override
  Future<void> delete(String listId) async => (await _active).delete(listId);

  @override
  Future<TaskListLoadResult> loadAll() async => (await _active).loadAll();

  @override
  Future<void> save(TaskList list) async => (await _active).save(list);

  @override
  Future<void> enableBackend(List<TaskList> lists) async {
    final remote = await _backend.loadAll();
    if (remote.lists.isNotEmpty) {
      throw StateError(
        'The backend already contains task lists. Clear it or use a merge flow before switching.',
      );
    }
    await _backend.commit(TaskListChangeSet(upserts: lists));
  }

  @override
  Future<void> disableBackend(List<TaskList> lists) async {
    final local = await _local.loadAll();
    await _local.commit(
      TaskListChangeSet(
        upserts: lists,
        deletes: [for (final list in local.lists) list.id],
      ),
    );
  }
}
