import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'backend_http_client_factory.dart';
import 'backend_configuration.dart';
import 'local/local_store.dart';

Uri localBackendUri() => BackendConfiguration.baseUri;

class BackendRequestException implements Exception {
  const BackendRequestException(this.statusCode, this.body);

  final int statusCode;
  final String body;

  @override
  String toString() => 'Backend request failed ($statusCode): $body';
}

class AuthenticatedUser {
  const AuthenticatedUser({
    required this.username,
    required this.isAdmin,
    this.id,
  });

  final String username;
  final bool isAdmin;
  final String? id;
}

class AdminUser {
  const AdminUser({
    required this.id,
    required this.username,
    required this.email,
    required this.displayName,
    required this.isAdmin,
  });

  final String id;
  final String? username;
  final String email;
  final String displayName;
  final bool isAdmin;

  factory AdminUser.fromJson(Map<String, Object?> json) => AdminUser(
    id: json['id']! as String,
    username: json['username'] as String?,
    email: json['email']! as String,
    displayName: json['display_name']! as String,
    isAdmin: json['is_admin']! as bool,
  );
}

class BackendAuthSession {
  BackendAuthSession(this._store, {http.Client? client, Uri? baseUri})
    : _client = client ?? createBackendHttpClient(),
      _baseUri = baseUri ?? localBackendUri();

  final PlatformLocalStore _store;
  final http.Client _client;
  final Uri _baseUri;
  String? _accessToken;
  String? _refreshToken;
  AuthenticatedUser? _user;

  AuthenticatedUser? get user => _user;
  Uri get baseUri => _baseUri;

  Future<String> accessToken({bool refresh = false}) async {
    if (refresh || _accessToken == null) await _refresh();
    return _accessToken!;
  }

  Future<AuthenticatedUser?> restore() async {
    final stored = await _store.readAuthSession();
    _refreshToken = stored?['refresh_token'] as String?;
    if (!kIsWeb && _refreshToken == null) return null;
    try {
      await _refresh();
      return _user;
    } on BackendRequestException {
      await clear();
      return null;
    }
  }

  Future<AuthenticatedUser> logIn(String username, String password) =>
      _credentials('/v1/auth/login', username, password);

  Future<List<AdminUser>> listAdminUsers() async {
    final response = await request('GET', '/v1/admin/users');
    final body = _object(response.body);
    return (body['users']! as List)
        .cast<Map>()
        .map((value) => AdminUser.fromJson(Map<String, Object?>.from(value)))
        .toList(growable: false);
  }

  Future<AdminUser> createAdminUser({
    required String username,
    required String password,
    required String email,
    required String displayName,
    required bool isAdmin,
  }) async {
    final response = await request(
      'POST',
      '/v1/admin/users',
      body: {
        'username': username,
        'password': password,
        'email': email,
        'display_name': displayName,
        'is_admin': isAdmin,
      },
    );
    return AdminUser.fromJson(_object(response.body));
  }

  Future<void> deleteAdminUser(String userId) async {
    await request('DELETE', '/v1/admin/users/$userId');
  }

  Future<http.Response> request(
    String method,
    String path, {
    Map<String, Object?>? body,
  }) async {
    if (_accessToken == null) {
      await _refresh();
    }
    var response = await _send(method, path, body: body);
    if (response.statusCode == 401) {
      await _refresh();
      response = await _send(method, path, body: body);
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw BackendRequestException(response.statusCode, response.body);
    }
    return response;
  }

  Future<void> logOut() async {
    try {
      if (_accessToken != null) await _send('DELETE', '/v1/auth/session');
    } finally {
      await clear();
    }
  }

  Future<void> clear() async {
    _accessToken = null;
    _refreshToken = null;
    _user = null;
    await _store.deleteAuthSession();
    if (_store case final PlatformScopedStore scoped) {
      scoped.setAccountScope(null);
    }
  }

  Future<AuthenticatedUser> _credentials(
    String path,
    String username,
    String password,
  ) async {
    final response = await _client.post(
      _baseUri.resolve(path),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
        'platform': _platformName(),
        'device_name': 'Last Task',
      }),
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw BackendRequestException(response.statusCode, response.body);
    }
    return _applyLogin(response.body);
  }

  Future<void> _refresh() async {
    final response = await _client.post(
      _baseUri.resolve('/v1/auth/refresh'),
      headers: const {'Content-Type': 'application/json'},
      body: _refreshToken == null
          ? '{}'
          : jsonEncode({'refresh_token': _refreshToken}),
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw BackendRequestException(response.statusCode, response.body);
    }
    await _applyLogin(response.body);
  }

  Future<http.Response> _send(
    String method,
    String path, {
    Map<String, Object?>? body,
  }) async {
    final request = http.Request(method, _baseUri.resolve(path));
    request.headers['Authorization'] = 'Bearer $_accessToken';
    if (body != null) {
      request.headers['Content-Type'] = 'application/json';
      request.body = jsonEncode(body);
    }
    return http.Response.fromStream(await _client.send(request));
  }

  Future<AuthenticatedUser> _applyLogin(String response) async {
    final body = _object(response);
    _accessToken = body['access_token']! as String;
    _refreshToken = body['refresh_token'] as String? ?? _refreshToken;
    final user = Map<String, Object?>.from(body['user']! as Map);
    _user = AuthenticatedUser(
      username: user['display_name']! as String,
      isAdmin: await _isAdmin(),
      id: user['id'] as String?,
    );
    if (_store case final PlatformScopedStore scoped) {
      scoped.setAccountScope(_user!.id);
    }
    if (!kIsWeb && _refreshToken != null) {
      await _store.writeAuthSession({'refresh_token': _refreshToken});
    }
    return _user!;
  }

  String _platformName() => switch (defaultTargetPlatform) {
    TargetPlatform.android => 'android',
    TargetPlatform.windows => 'windows',
    _ => kIsWeb ? 'web' : 'linux',
  };

  Map<String, Object?> _object(String value) =>
      Map<String, Object?>.from(jsonDecode(value) as Map);

  Future<bool> _isAdmin() async {
    try {
      await request('GET', '/v1/admin/users');
      return true;
    } on BackendRequestException catch (error) {
      if (error.statusCode == 403) return false;
      rethrow;
    }
  }
}
