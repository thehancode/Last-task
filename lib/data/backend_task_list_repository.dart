import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../domain/models.dart';
import '../domain/repositories.dart';

/// A development client for the local backend described in Backend.txt.
///
/// Android emulators reach the host machine through 10.0.2.2; the browser and
/// desktop targets reach the compose service through localhost.
Uri localBackendUri() => Uri.parse(
  !kIsWeb && defaultTargetPlatform == TargetPlatform.android
      ? 'http://10.0.2.2:8080'
      : 'http://localhost:8080',
);

class BackendTaskListRepository implements TaskListRepository {
  BackendTaskListRepository({http.Client? client, Uri? baseUri})
    : _client = client ?? http.Client(),
      _baseUri = baseUri ?? localBackendUri();

  final http.Client _client;
  final Uri _baseUri;
  final Map<String, int> _versions = {};
  String? _accessToken;

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
    await _authenticate();
    final request = http.Request(method, _baseUri.resolve(path));
    request.headers['Authorization'] = 'Bearer $_accessToken';
    if (body != null) {
      request.headers['Content-Type'] = 'application/json';
      request.body = jsonEncode(body);
    }
    final streamed = await _client.send(request);
    final response = await http.Response.fromStream(streamed);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response;
    }
    debugPrint(
      'Backend API error: $method ${request.url} '
      'returned ${response.statusCode}: ${response.body}',
    );
    throw BackendRequestException(response.statusCode, response.body);
  }

  Future<void> _authenticate() async {
    if (_accessToken != null) return;
    final response = await _client.post(
      _baseUri.resolve('/v1/auth/google'),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id_token': 'flutter-local-development-token',
        'platform': _platformName(),
        'device_name': 'Last Task local development',
      }),
    );
    if (response.statusCode != 201) {
      debugPrint(
        'Backend authentication error: POST ${response.request?.url} '
        'returned ${response.statusCode}: ${response.body}',
      );
      throw BackendRequestException(response.statusCode, response.body);
    }
    _accessToken = _object(response.body)['access_token']! as String;
  }

  String _platformName() => switch (defaultTargetPlatform) {
    TargetPlatform.android => 'android',
    TargetPlatform.windows => 'windows',
    _ => kIsWeb ? 'web' : 'linux',
  };

  Map<String, Object?> _object(String value) =>
      Map<String, Object?>.from(jsonDecode(value) as Map);
}

class BackendRequestException implements Exception {
  const BackendRequestException(this.statusCode, this.body);

  final int statusCode;
  final String body;

  @override
  String toString() => 'Backend request failed ($statusCode): $body';
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
