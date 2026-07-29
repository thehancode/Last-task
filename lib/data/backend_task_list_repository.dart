import 'dart:async';
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

/// Persists task lists locally before mirroring each change to the backend.
///
/// Backend operations are serialized so versioned writes retain their order.
/// They deliberately do not delay or fail the local operation.
class LocalFirstTaskListRepository
    implements TaskListRepository, BackgroundSyncRepository {
  LocalFirstTaskListRepository(this._local, this._backend);

  final TaskListRepository _local;
  final TaskListRepository _backend;
  Future<void> _backendQueue = Future<void>.value();
  final StreamController<Object> _syncErrors =
      StreamController<Object>.broadcast(sync: true);
  bool _backendInitialized = false;

  @override
  Stream<Object> get syncErrors => _syncErrors.stream;

  @override
  Stream<void> get remoteChanges => const Stream<void>.empty();

  @override
  Future<void> synchronize({bool force = false}) => flushBackendWrites();

  @override
  Future<void> commit(TaskListChangeSet changes) async {
    await _local.commit(changes);
    _scheduleBackendWrite(() => _backend.commit(changes));
  }

  @override
  Future<void> delete(String listId) async {
    await _local.delete(listId);
    _scheduleBackendWrite(() => _backend.delete(listId));
  }

  @override
  Future<TaskListLoadResult> loadAll() => _local.loadAll();

  @override
  Future<void> save(TaskList list) async {
    await _local.save(list);
    _scheduleBackendWrite(() => _backend.save(list));
  }

  void _scheduleBackendWrite(Future<void> Function() write) {
    _backendQueue = _backendQueue
        .then((_) async {
          if (!_backendInitialized) {
            await _backend.loadAll();
            _backendInitialized = true;
          }
          await write();
        })
        // A backend outage must not surface as an unhandled asynchronous error
        // or prevent later writes from being attempted.
        .catchError((Object error, StackTrace _) {
          if (!_syncErrors.isClosed) _syncErrors.add(error);
        });
    unawaited(_backendQueue);
  }

  /// Waits until already-scheduled backend work settles.
  ///
  /// Production writes do not await this; it exists for lifecycle coordination
  /// and deterministic tests.
  Future<void> flushBackendWrites() => _backendQueue;

  Future<void> dispose() => _syncErrors.close();
}
