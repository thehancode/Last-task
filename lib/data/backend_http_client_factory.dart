import 'backend_http_client.dart'
    if (dart.library.js_interop) 'backend_http_client_web.dart'
    as implementation;
import 'package:http/http.dart' as http;

export 'package:http/http.dart' show Client;

http.Client createBackendHttpClient() =>
    implementation.createBackendHttpClient();
