import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/data/backend_auth_session.dart';
import 'package:flutter_app/data/local/local_store_base.dart';
import 'package:flutter_app/data/providers.dart';
import 'package:flutter_app/presentation/admin_view_model.dart';

void main() {
  test('loads users and prepends a newly created user', () async {
    final session = _FakeAdminSession();
    final container = ProviderContainer(
      overrides: [backendAuthSessionProvider.overrideWithValue(session)],
    );
    addTearDown(container.dispose);

    await _settled(container);
    expect(
      container.read(adminViewModelProvider).users.single.username,
      'first',
    );

    final created = await container
        .read(adminViewModelProvider.notifier)
        .createUser(
          username: 'second',
          password: 'a secure password',
          email: 'second@example.com',
          displayName: 'Second user',
          isAdmin: true,
        );

    expect(created, isTrue);
    expect(
      container.read(adminViewModelProvider).users.map((user) => user.username),
      ['second', 'first'],
    );

    final deleted = await container
        .read(adminViewModelProvider.notifier)
        .deleteUser('1');

    expect(deleted, isTrue);
    expect(
      container.read(adminViewModelProvider).users.single.username,
      'second',
    );
  });
}

Future<void> _settled(ProviderContainer container) async {
  for (var attempt = 0; attempt < 10; attempt++) {
    if (!container.read(adminViewModelProvider).loading) return;
    await Future<void>.delayed(Duration.zero);
  }
  throw StateError('Admin users did not finish loading');
}

class _FakeAdminSession extends BackendAuthSession {
  _FakeAdminSession() : super(_Store());

  @override
  Future<List<AdminUser>> listAdminUsers() async => const [
    AdminUser(
      id: '1',
      username: 'first',
      email: 'first@example.com',
      displayName: 'First user',
      isAdmin: false,
    ),
  ];

  @override
  Future<AdminUser> createAdminUser({
    required String username,
    required String password,
    required String email,
    required String displayName,
    required bool isAdmin,
  }) async => AdminUser(
    id: '2',
    username: username,
    email: email,
    displayName: displayName,
    isAdmin: isAdmin,
  );

  @override
  Future<void> deleteAdminUser(String userId) async {}
}

class _Store implements PlatformLocalStore {
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
