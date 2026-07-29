//
//  Generated code. Do not modify.
//  source: lasttask/sync/v1/sync.proto
//

import "package:connectrpc/connect.dart" as connect;
import "sync.pb.dart" as lasttasksyncv1sync;

abstract final class WorkspaceSyncService {
  /// Fully-qualified name of the WorkspaceSyncService service.
  static const name = 'lasttask.sync.v1.WorkspaceSyncService';

  static const getSnapshot = connect.Spec(
    '/$name/GetSnapshot',
    connect.StreamType.unary,
    lasttasksyncv1sync.GetSnapshotRequest.new,
    lasttasksyncv1sync.GetSnapshotResponse.new,
  );

  static const pullChanges = connect.Spec(
    '/$name/PullChanges',
    connect.StreamType.unary,
    lasttasksyncv1sync.PullChangesRequest.new,
    lasttasksyncv1sync.PullChangesResponse.new,
  );

  static const pushMutations = connect.Spec(
    '/$name/PushMutations',
    connect.StreamType.unary,
    lasttasksyncv1sync.PushMutationsRequest.new,
    lasttasksyncv1sync.PushMutationsResponse.new,
  );

  static const updateWorkspaceSettings = connect.Spec(
    '/$name/UpdateWorkspaceSettings',
    connect.StreamType.unary,
    lasttasksyncv1sync.UpdateWorkspaceSettingsRequest.new,
    lasttasksyncv1sync.UpdateWorkspaceSettingsResponse.new,
  );

  static const watchWorkspace = connect.Spec(
    '/$name/WatchWorkspace',
    connect.StreamType.server,
    lasttasksyncv1sync.WatchWorkspaceRequest.new,
    lasttasksyncv1sync.WatchWorkspaceResponse.new,
  );

  static const ping = connect.Spec(
    '/$name/Ping',
    connect.StreamType.unary,
    lasttasksyncv1sync.PingRequest.new,
    lasttasksyncv1sync.PingResponse.new,
  );
}
