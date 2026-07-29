import 'package:connectrpc/connect.dart';
import 'package:connectrpc/protobuf.dart';
import 'package:connectrpc/protocol/connect.dart' as protocol;
import 'package:connectrpc/web.dart' as connect_web;

Transport createSyncTransport(Uri baseUri) => protocol.Transport(
  baseUrl: baseUri.toString().replaceFirst(RegExp(r'/$'), ''),
  codec: const ProtoCodec(),
  httpClient: connect_web.createHttpClient(credentials: 'include'),
);
