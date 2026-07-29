import 'package:connectrpc/connect.dart';

import 'connect_transport_stub.dart'
    if (dart.library.io) 'connect_transport_io.dart'
    if (dart.library.js_interop) 'connect_transport_web.dart'
    as implementation;

Transport createSyncTransport(Uri baseUri) =>
    implementation.createSyncTransport(baseUri);
