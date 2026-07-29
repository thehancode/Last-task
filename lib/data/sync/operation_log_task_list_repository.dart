import 'dart:async';
import 'dart:math';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:uuid/uuid.dart';

import '../../domain/models.dart';
import '../../domain/repositories.dart';
import '../backend_auth_session.dart';
import '../local/local_store.dart';
import 'generated/lasttask/sync/v1/sync.pb.dart' as wire;
import 'sync_contract.dart';
import 'sync_gateway.dart';

abstract interface class WorkspaceSyncGateway {
  Future<wire.GetSnapshotResponse> getSnapshot();
  Future<wire.PullChangesResponse> pullChanges(int afterRevision);
  Future<wire.PushMutationsResponse> pushMutations(
    List<wire.WorkspaceMutation> mutations,
  );
  Future<wire.UpdateWorkspaceSettingsResponse> updateTimezone(String timezone);
}

class ConnectWorkspaceSyncGateway implements WorkspaceSyncGateway {
  ConnectWorkspaceSyncGateway(BackendAuthSession auth)
    : _delegate = SyncGateway(auth);

  final SyncGateway _delegate;

  @override
  Future<wire.GetSnapshotResponse> getSnapshot() => _delegate.getSnapshot();

  @override
  Future<wire.PullChangesResponse> pullChanges(int afterRevision) =>
      _delegate.pullChanges(afterRevision);

  @override
  Future<wire.PushMutationsResponse> pushMutations(
    List<wire.WorkspaceMutation> mutations,
  ) => _delegate.pushMutations(mutations);

  @override
  Future<wire.UpdateWorkspaceSettingsResponse> updateTimezone(
    String timezone,
  ) => _delegate.updateTimezone(timezone);
}

/// A local-first repository backed by a durable protobuf mutation outbox.
///
/// Local documents remain the UI's source of truth. Network synchronization is
/// serialized in the background and canonical server results are projected
/// back into the same local repository.
class OperationLogTaskListRepository
    implements TaskListRepository, BackgroundSyncRepository {
  factory OperationLogTaskListRepository({
    required TaskListRepository local,
    required PlatformSyncStore syncStore,
    required BackendAuthSession auth,
    WorkspaceSyncGateway? gateway,
    Future<String> Function()? readTimezone,
    bool Function()? isSignedIn,
  }) => OperationLogTaskListRepository._(
    local,
    syncStore,
    gateway ?? ConnectWorkspaceSyncGateway(auth),
    readTimezone ??
        (() async => (await FlutterTimezone.getLocalTimezone()).identifier),
    isSignedIn ?? (() => auth.user != null),
  );

  OperationLogTaskListRepository._(
    this._local,
    this._syncStore,
    this._gateway,
    this._readTimezone,
    this._isSignedIn,
  );

  final TaskListRepository _local;
  final PlatformSyncStore _syncStore;
  final WorkspaceSyncGateway _gateway;
  final Future<String> Function() _readTimezone;
  final bool Function() _isSignedIn;
  final _uuid = const Uuid();
  final StreamController<Object> _syncErrors =
      StreamController<Object>.broadcast(sync: true);
  final StreamController<void> _remoteChanges =
      StreamController<void>.broadcast(sync: true);

  Future<void> _queue = Future<void>.value();
  _SyncState? _state;
  int _failureCount = 0;
  DateTime? _retryAfter;

  @override
  Stream<Object> get syncErrors => _syncErrors.stream;

  @override
  Stream<void> get remoteChanges => _remoteChanges.stream;

  @override
  Future<TaskListLoadResult> loadAll() => _local.loadAll();

  @override
  Future<void> save(TaskList list) =>
      commit(TaskListChangeSet(upserts: [list]));

  @override
  Future<void> delete(String listId) =>
      commit(TaskListChangeSet(deletes: [listId]));

  @override
  Future<void> commit(TaskListChangeSet changes) =>
      _serialized(() => _commitNow(changes));

  Future<void> _commitNow(TaskListChangeSet changes) async {
    for (final list in changes.upserts) {
      list.validate();
    }
    final before = await _local.loadAll();
    final byId = {for (final list in before.lists) list.id: list};
    final operations = <wire.Operation>[
      for (final id in changes.deletes)
        wire.Operation(deleteList: wire.DeleteList(listId: id)),
      for (final list in changes.upserts) ...diffList(byId[list.id], list),
    ];
    final desiredLists = [
      for (final list in before.lists)
        if (!changes.deletes.contains(list.id))
          changes.upserts
                  .where((candidate) => candidate.id == list.id)
                  .firstOrNull ??
              list,
      for (final list in changes.upserts)
        if (!byId.containsKey(list.id)) list,
    ];
    if (desiredLists.isNotEmpty &&
        desiredLists.every((list) => list.sortIndex != null)) {
      desiredLists.sort(
        (left, right) => left.sortIndex!.compareTo(right.sortIndex!),
      );
      for (var index = 0; index < desiredLists.length; index++) {
        operations.add(
          wire.Operation(
            moveList: wire.MoveList(
              listId: desiredLists[index].id,
              afterListId: index == 0 ? null : desiredLists[index - 1].id,
            ),
          ),
        );
      }
    }

    // Guest changes remain fully local and are offered for import when an
    // account is selected. Never leak them into an unrelated account.
    if (_isSignedIn() && operations.isNotEmpty) {
      final state = await _loadState();
      final mutation = wire.WorkspaceMutation(
        mutationId: _uuid.v7(),
        deviceId: state.deviceId,
        baseWorkspaceRevision: Int64(state.revision),
        baseListVersions: state.listVersions.entries.map(
          (entry) => wire.ResourceVersion(
            listId: entry.key,
            version: Int64(entry.value),
          ),
        ),
        createdAt: timestampFromDateTime(DateTime.now().toUtc()),
        operations: operations,
      );
      await _syncStore.writePendingMutation(
        mutation.mutationId,
        mutation.writeToBuffer(),
      );
    }

    await _local.commit(changes);
    if (_isSignedIn() && operations.isNotEmpty) _scheduleSync();
  }

  @override
  Future<void> synchronize({bool force = false}) {
    if (!_isSignedIn()) return Future<void>.value();
    final retryAfter = _retryAfter;
    if (!force && retryAfter != null && DateTime.now().isBefore(retryAfter)) {
      return _queue;
    }
    return _serialized(() async {
      try {
        await _synchronizeNow();
        _failureCount = 0;
        _retryAfter = null;
      } on Object catch (error) {
        _failureCount++;
        final seconds = min(120, 15 * (1 << min(_failureCount - 1, 3)));
        _retryAfter = DateTime.now().add(
          Duration(seconds: seconds + Random().nextInt(4)),
        );
        if (!_syncErrors.isClosed) _syncErrors.add(error);
      }
    });
  }

  Future<T> _serialized<T>(Future<T> Function() action) {
    final completer = Completer<T>();
    _queue = _queue.then((_) async {
      try {
        completer.complete(await action());
      } on Object catch (error, stackTrace) {
        completer.completeError(error, stackTrace);
      }
    });
    return completer.future;
  }

  void _scheduleSync() {
    unawaited(synchronize());
  }

  Future<void> _synchronizeNow() async {
    var state = await _loadState();
    if (!state.initialized) {
      await _applySnapshot((await _gateway.getSnapshot()).snapshot);
      state = await _loadState();
    }
    final localTimezone = await _readTimezone();
    if (state.timezone != localTimezone) {
      final response = await _gateway.updateTimezone(localTimezone);
      state = state.copyWith(
        revision: response.workspaceRevision.toInt(),
        timezone: response.accountTimezone,
      );
      await _saveState(state);
    }
    final documents = await _syncStore.readPendingMutations();
    documents.sort((left, right) => left.key.compareTo(right.key));
    if (documents.isNotEmpty) {
      final mutations = documents
          .map((document) => wire.WorkspaceMutation.fromBuffer(document.value))
          .toList(growable: false);
      final response = await _gateway.pushMutations(mutations);
      for (final result in response.results) {
        await _applyResult(result);
        await _syncStore.deletePendingMutation(result.mutationId);
        state = state.applyResult(result);
      }
      await _saveState(state);
    }

    final pulled = await _gateway.pullChanges(state.revision);
    if (pulled.resetRequired) {
      await _applySnapshot((await _gateway.getSnapshot()).snapshot);
      return;
    }
    var changed = false;
    for (final change in pulled.changes) {
      await _applyResult(change.result);
      state = state.applyResult(change.result);
      changed = true;
    }
    if (pulled.currentRevision.toInt() > state.revision) {
      state = state.copyWith(revision: pulled.currentRevision.toInt());
    }
    await _saveState(state);
    if (changed && !_remoteChanges.isClosed) _remoteChanges.add(null);
  }

  Future<void> _applyResult(wire.MutationResult result) async {
    final current = await _local.loadAll();
    final currentById = {for (final list in current.lists) list.id: list};
    await _local.commit(
      TaskListChangeSet(
        upserts: result.changedLists
            .map(
              (list) => _preserveDeviceState(
                listFromWire(list),
                currentById[list.id],
              ),
            )
            .toList(growable: false),
        deletes: result.deletedListIds,
      ),
    );
    for (final list in result.changedLists) {
      await _syncStore.writeCanonicalList(list.id, list.writeToBuffer());
    }
    for (final id in result.deletedListIds) {
      await _syncStore.deleteCanonicalList(id);
    }
  }

  Future<void> _applySnapshot(wire.WorkspaceSnapshot snapshot) async {
    final current = await _local.loadAll();
    final serverIds = snapshot.lists.map((list) => list.id).toSet();
    await _local.commit(
      TaskListChangeSet(
        upserts: [
          for (var index = 0; index < snapshot.lists.length; index++)
            _preserveDeviceState(
              listFromWire(snapshot.lists[index], sortIndex: index),
              current.lists
                  .where((list) => list.id == snapshot.lists[index].id)
                  .firstOrNull,
            ),
        ],
        deletes: [
          for (final list in current.lists)
            if (!serverIds.contains(list.id)) list.id,
        ],
      ),
    );
    final state = (await _loadState()).copyWith(
      revision: snapshot.workspaceRevision.toInt(),
      timezone: snapshot.accountTimezone,
      initialized: true,
      listVersions: {
        for (final list in snapshot.lists) list.id: list.version.toInt(),
      },
    );
    await _saveState(state);
    if (!_remoteChanges.isClosed) _remoteChanges.add(null);
  }

  Future<_SyncState> _loadState() async {
    final cached = _state;
    if (cached != null) return cached;
    final stored = await _syncStore.readSyncState();
    return _state = _SyncState.fromJson(stored, fallbackDeviceId: _uuid.v4());
  }

  Future<void> _saveState(_SyncState state) async {
    _state = state;
    await _syncStore.writeSyncState(state.toJson());
  }

  TaskList _preserveDeviceState(TaskList canonical, TaskList? local) {
    if (local == null) return canonical;
    final collapsed = {
      for (final task in local.tasks)
        if (task.collapsed) task.id,
    };
    return canonical.copyWith(
      tasks: [
        for (final task in canonical.tasks)
          task.copyWith(collapsed: collapsed.contains(task.id)),
      ],
    );
  }

  Future<void> dispose() async {
    await _syncErrors.close();
    await _remoteChanges.close();
  }
}

class _SyncState {
  const _SyncState({
    required this.deviceId,
    required this.revision,
    required this.listVersions,
    required this.timezone,
    required this.initialized,
  });

  final String deviceId;
  final int revision;
  final Map<String, int> listVersions;
  final String? timezone;
  final bool initialized;

  factory _SyncState.fromJson(
    Map<String, Object?>? json, {
    required String fallbackDeviceId,
  }) => _SyncState(
    deviceId: json?['device_id'] as String? ?? fallbackDeviceId,
    revision: json?['workspace_revision'] as int? ?? 0,
    timezone: json?['account_timezone'] as String?,
    initialized:
        json?['initialized'] as bool? ??
        (json?['workspace_revision'] as int? ?? 0) > 0,
    listVersions: {
      for (final entry
          in (json?['list_versions'] as Map? ?? const <Object?, Object?>{})
              .entries)
        if (entry.key is String && entry.value is int)
          entry.key! as String: entry.value! as int,
    },
  );

  _SyncState applyResult(wire.MutationResult result) => copyWith(
    revision: result.workspaceRevision.toInt(),
    listVersions: {
      ...listVersions,
      for (final version in result.listVersions)
        version.listId: version.version.toInt(),
    }..removeWhere((id, _) => result.deletedListIds.contains(id)),
  );

  _SyncState copyWith({
    int? revision,
    Map<String, int>? listVersions,
    String? timezone,
    bool? initialized,
  }) => _SyncState(
    deviceId: deviceId,
    revision: revision ?? this.revision,
    listVersions: listVersions ?? this.listVersions,
    timezone: timezone ?? this.timezone,
    initialized: initialized ?? this.initialized,
  );

  Map<String, Object?> toJson() => {
    'device_id': deviceId,
    'workspace_revision': revision,
    'list_versions': listVersions,
    if (timezone != null) 'account_timezone': timezone,
    'initialized': initialized,
  };
}
