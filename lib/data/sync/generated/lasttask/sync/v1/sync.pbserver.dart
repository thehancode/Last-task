// This is a generated file - do not edit.
//
// Generated from lasttask/sync/v1/sync.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'sync.pb.dart' as $2;
import 'sync.pbjson.dart';

export 'sync.pb.dart';

abstract class WorkspaceSyncServiceBase extends $pb.GeneratedService {
  $async.Future<$2.GetSnapshotResponse> getSnapshot(
      $pb.ServerContext ctx, $2.GetSnapshotRequest request);
  $async.Future<$2.PullChangesResponse> pullChanges(
      $pb.ServerContext ctx, $2.PullChangesRequest request);
  $async.Future<$2.PushMutationsResponse> pushMutations(
      $pb.ServerContext ctx, $2.PushMutationsRequest request);
  $async.Future<$2.UpdateWorkspaceSettingsResponse> updateWorkspaceSettings(
      $pb.ServerContext ctx, $2.UpdateWorkspaceSettingsRequest request);
  $async.Future<$2.WatchWorkspaceResponse> watchWorkspace(
      $pb.ServerContext ctx, $2.WatchWorkspaceRequest request);
  $async.Future<$2.PingResponse> ping(
      $pb.ServerContext ctx, $2.PingRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'GetSnapshot':
        return $2.GetSnapshotRequest();
      case 'PullChanges':
        return $2.PullChangesRequest();
      case 'PushMutations':
        return $2.PushMutationsRequest();
      case 'UpdateWorkspaceSettings':
        return $2.UpdateWorkspaceSettingsRequest();
      case 'WatchWorkspace':
        return $2.WatchWorkspaceRequest();
      case 'Ping':
        return $2.PingRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'GetSnapshot':
        return getSnapshot(ctx, request as $2.GetSnapshotRequest);
      case 'PullChanges':
        return pullChanges(ctx, request as $2.PullChangesRequest);
      case 'PushMutations':
        return pushMutations(ctx, request as $2.PushMutationsRequest);
      case 'UpdateWorkspaceSettings':
        return updateWorkspaceSettings(
            ctx, request as $2.UpdateWorkspaceSettingsRequest);
      case 'WatchWorkspace':
        return watchWorkspace(ctx, request as $2.WatchWorkspaceRequest);
      case 'Ping':
        return ping(ctx, request as $2.PingRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json =>
      WorkspaceSyncServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => WorkspaceSyncServiceBase$messageJson;
}
