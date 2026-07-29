//
//  Generated code. Do not modify.
//  source: lasttask/sync/v1/sync.proto
//

import "package:connectrpc/connect.dart" as connect;
import "sync.pb.dart" as lasttasksyncv1sync;
import "sync.connect.spec.dart" as specs;

extension type WorkspaceSyncServiceClient(connect.Transport _transport) {
  Future<lasttasksyncv1sync.GetSnapshotResponse> getSnapshot(
    lasttasksyncv1sync.GetSnapshotRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.WorkspaceSyncService.getSnapshot,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<lasttasksyncv1sync.PullChangesResponse> pullChanges(
    lasttasksyncv1sync.PullChangesRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.WorkspaceSyncService.pullChanges,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<lasttasksyncv1sync.PushMutationsResponse> pushMutations(
    lasttasksyncv1sync.PushMutationsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.WorkspaceSyncService.pushMutations,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<lasttasksyncv1sync.UpdateWorkspaceSettingsResponse>
  updateWorkspaceSettings(
    lasttasksyncv1sync.UpdateWorkspaceSettingsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.WorkspaceSyncService.updateWorkspaceSettings,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Stream<lasttasksyncv1sync.WatchWorkspaceResponse> watchWorkspace(
    lasttasksyncv1sync.WatchWorkspaceRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).server(
      specs.WorkspaceSyncService.watchWorkspace,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<lasttasksyncv1sync.PingResponse> ping(
    lasttasksyncv1sync.PingRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.WorkspaceSyncService.ping,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
