import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/backend_auth_session.dart';
import '../data/providers.dart';

final adminViewModelProvider = NotifierProvider<AdminViewModel, AdminState>(
  AdminViewModel.new,
);

class AdminState {
  const AdminState({this.users = const [], this.loading = true, this.error});

  final List<AdminUser> users;
  final bool loading;
  final String? error;

  AdminState copyWith({List<AdminUser>? users, bool? loading, String? error}) =>
      AdminState(
        users: users ?? this.users,
        loading: loading ?? this.loading,
        error: error,
      );
}

class AdminViewModel extends Notifier<AdminState> {
  BackendAuthSession get _session => ref.read(backendAuthSessionProvider);

  @override
  AdminState build() {
    Future<void>.microtask(load);
    return const AdminState();
  }

  Future<void> load() async {
    state = AdminState(users: state.users, loading: true);
    try {
      state = AdminState(
        users: await _session.listAdminUsers(),
        loading: false,
      );
    } on BackendRequestException {
      state = state.copyWith(
        loading: false,
        error: 'Could not load users. Try again.',
      );
    } on Object {
      state = state.copyWith(
        loading: false,
        error: 'Could not load users. Try again.',
      );
    }
  }

  Future<bool> createUser({
    required String username,
    required String password,
    required String email,
    required String displayName,
    required bool isAdmin,
  }) async {
    state = AdminState(users: state.users, loading: true);
    try {
      final user = await _session.createAdminUser(
        username: username,
        password: password,
        email: email,
        displayName: displayName,
        isAdmin: isAdmin,
      );
      state = AdminState(users: [user, ...state.users], loading: false);
      return true;
    } on BackendRequestException catch (error) {
      state = state.copyWith(
        loading: false,
        error: error.statusCode == 422
            ? 'Enter a valid, unused username, email, and password.'
            : 'Could not create the user. Try again.',
      );
      return false;
    } on Object {
      state = state.copyWith(
        loading: false,
        error: 'Could not create the user. Try again.',
      );
      return false;
    }
  }

  Future<bool> deleteUser(String userId) async {
    state = AdminState(users: state.users, loading: true);
    try {
      await _session.deleteAdminUser(userId);
      state = AdminState(
        users: state.users.where((user) => user.id != userId).toList(),
        loading: false,
      );
      return true;
    } on BackendRequestException catch (error) {
      state = state.copyWith(
        loading: false,
        error: error.statusCode == 409
            ? 'This user cannot be deleted.'
            : 'Could not delete the user. Try again.',
      );
      return false;
    } on Object {
      state = state.copyWith(
        loading: false,
        error: 'Could not delete the user. Try again.',
      );
      return false;
    }
  }
}
