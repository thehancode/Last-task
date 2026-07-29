import 'package:connectrpc/connect.dart';
import 'package:fixnum/fixnum.dart';

import '../backend_auth_session.dart';
import 'connect_transport.dart';
import 'generated/lasttask/sync/v1/sync.connect.client.dart';
import 'generated/lasttask/sync/v1/sync.pb.dart';

class SyncGateway {
  SyncGateway(BackendAuthSession auth)
    : _auth = auth,
      _client = WorkspaceSyncServiceClient(createSyncTransport(auth.baseUri));

  final BackendAuthSession _auth;
  final WorkspaceSyncServiceClient _client;

  Future<GetSnapshotResponse> getSnapshot() => _authenticated(
    (headers) => _client.getSnapshot(GetSnapshotRequest(), headers: headers),
  );

  Future<PullChangesResponse> pullChanges(int afterRevision) => _authenticated(
    (headers) => _client.pullChanges(
      PullChangesRequest(afterRevision: Int64(afterRevision), limit: 200),
      headers: headers,
    ),
  );

  Future<PushMutationsResponse> pushMutations(
    List<WorkspaceMutation> mutations,
  ) => _authenticated(
    (headers) => _client.pushMutations(
      PushMutationsRequest(mutations: mutations),
      headers: headers,
    ),
  );

  Future<UpdateWorkspaceSettingsResponse> updateTimezone(String timezone) =>
      _authenticated(
        (headers) => _client.updateWorkspaceSettings(
          UpdateWorkspaceSettingsRequest(accountTimezone: timezone),
          headers: headers,
        ),
      );

  Future<T> _authenticated<T>(
    Future<T> Function(Headers headers) request,
  ) async {
    Future<T> send({bool refresh = false}) async {
      final headers = Headers()
        ..['authorization'] =
            'Bearer ${await _auth.accessToken(refresh: refresh)}';
      return request(headers);
    }

    try {
      return await send();
    } on ConnectException catch (error) {
      if (error.code != Code.unauthenticated) rethrow;
      return send(refresh: true);
    }
  }
}
