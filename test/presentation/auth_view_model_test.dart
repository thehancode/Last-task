import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/data/backend_auth_session.dart';
import 'package:flutter_app/data/local/local_store_base.dart';
import 'package:flutter_app/data/providers.dart';
import 'package:flutter_app/presentation/auth_view_model.dart';

void main() {
  test('logout prefers login and a subsequent login succeeds', () async {
    final session = _FakeAuthSession();
    final container = ProviderContainer(
      overrides: [backendAuthSessionProvider.overrideWithValue(session)],
    );
    addTearDown(container.dispose);
    final auth = container.read(authViewModelProvider.notifier);
    await _settled(container);

    await auth.logIn('hancode', 'password');
    expect(container.read(authViewModelProvider).username, 'hancode');

    await auth.logOut();
    final signedOut = container.read(authViewModelProvider);
    expect(signedOut.phase, AuthPhase.signedOut);
    expect(signedOut.preferLogin, isTrue);

    await auth.logIn('hancode', 'password');
    expect(container.read(authViewModelProvider).username, 'hancode');
    expect(session.loginCalls, 2);
  });
}

Future<void> _settled(ProviderContainer container) async {
  for (var attempt = 0; attempt < 10; attempt++) {
    if (container.read(authViewModelProvider).phase != AuthPhase.loading) {
      return;
    }
    await Future<void>.delayed(Duration.zero);
  }
  throw StateError('Auth did not finish restoring');
}

class _FakeAuthSession extends BackendAuthSession {
  _FakeAuthSession() : super(_AuthStore());

  int loginCalls = 0;

  @override
  Future<AuthenticatedUser?> restore() async => null;

  @override
  Future<AuthenticatedUser> logIn(String username, String password) async {
    loginCalls++;
    return AuthenticatedUser(username: username);
  }

  @override
  Future<void> logOut() async {}
}

class _AuthStore implements PlatformLocalStore {
  @override
  Future<void> deleteAuthSession() async {}

  @override
  Future<void> deleteTaskList(String id) async {}

  @override
  Future<Map<String, Object?>?> readAuthSession() async => null;

  @override
  Future<Map<String, Object?>?> readDeviceState() async => null;

  @override
  Future<Map<String, Object?>?> readSettings() async => null;

  @override
  Future<List<StoredDocument>> readTaskLists() async => const [];

  @override
  Future<void> writeAuthSession(Map<String, Object?> value) async {}

  @override
  Future<void> writeDeviceState(Map<String, Object?> value) async {}

  @override
  Future<void> writeSettings(Map<String, Object?> value) async {}

  @override
  Future<void> writeTaskList(String id, Map<String, Object?> value) async {}
}
