import 'dart:io' as io;

import 'package:connectrpc/connect.dart';
import 'package:connectrpc/io.dart' as connect_io;
import 'package:connectrpc/protobuf.dart';
import 'package:connectrpc/protocol/connect.dart' as protocol;

Transport createSyncTransport(Uri baseUri) => protocol.Transport(
  baseUrl: baseUri.toString().replaceFirst(RegExp(r'/$'), ''),
  codec: const ProtoCodec(),
  httpClient: connect_io.createHttpClient(io.HttpClient()),
);
