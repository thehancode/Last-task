import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/backend_auth_session.dart';
import '../data/providers.dart';
import 'workspace_view_model.dart';

final authViewModelProvider = NotifierProvider<AuthViewModel, AuthState>(
  AuthViewModel.new,
);

enum AuthPhase { loading, signedOut, signedIn }

class AuthState {
  const AuthState._({
    required this.phase,
    this.username,
    this.error,
    this.preferLogin = false,
  });

  const AuthState.loading() : this._(phase: AuthPhase.loading);
  const AuthState.signedOut({String? error, bool preferLogin = false})
    : this._(
        phase: AuthPhase.signedOut,
        error: error,
        preferLogin: preferLogin,
      );
  const AuthState.signedIn(String username)
    : this._(phase: AuthPhase.signedIn, username: username);

  final AuthPhase phase;
  final String? username;
  final String? error;
  final bool preferLogin;

  bool get isSignedIn => phase == AuthPhase.signedIn;
}

class AuthViewModel extends Notifier<AuthState> {
  BackendAuthSession get _session => ref.read(backendAuthSessionProvider);

  @override
  AuthState build() {
    Future<void>.microtask(_restore);
    return const AuthState.loading();
  }

  Future<void> register(String username, String password) => _authenticate(
    () => _session.register(username, password),
    preferLogin: false,
  );

  Future<void> logIn(String username, String password) => _authenticate(
    () => _session.logIn(username, password),
    preferLogin: true,
  );

  Future<void> logOut() async {
    try {
      await _session.logOut();
    } finally {
      state = const AuthState.signedOut(preferLogin: true);
    }
  }

  Future<void> _restore() async {
    try {
      final user = await _session.restore();
      state = user == null
          ? const AuthState.signedOut()
          : AuthState.signedIn(user.username);
    } on Object {
      state = const AuthState.signedOut();
    }
  }

  Future<void> _authenticate(
    Future<AuthenticatedUser> Function() action, {
    required bool preferLogin,
  }) async {
    state = const AuthState.loading();
    try {
      final user = await action();
      // Reset user-scoped data only after fresh credentials exist. Invalidating
      // the workspace during logout can otherwise make it reload with a
      // cleared session and preserve that failure for the next login.
      ref.invalidate(taskListRepositoryProvider);
      ref.invalidate(workspaceViewModelProvider);
      state = AuthState.signedIn(user.username);
    } on BackendRequestException catch (error) {
      state = AuthState.signedOut(
        error: _message(error),
        preferLogin: preferLogin,
      );
    } on Object {
      state = AuthState.signedOut(preferLogin: preferLogin);
    }
  }

  String _message(BackendRequestException error) {
    if (error.statusCode == 409) return 'That username is already in use.';
    if (error.statusCode == 401) return 'Invalid username or password.';
    return 'Could not contact the server. Try again.';
  }
}
