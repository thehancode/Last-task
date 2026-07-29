import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/backend_auth_session.dart';
import '../data/providers.dart';
import '../data/local/local_store.dart';
import '../domain/models.dart';
import 'workspace_view_model.dart';

final authViewModelProvider = NotifierProvider<AuthViewModel, AuthState>(
  AuthViewModel.new,
);

enum AuthPhase { loading, signedOut, signedIn }

class AuthState {
  const AuthState._({
    required this.phase,
    this.username,
    this.userId,
    this.isAdmin = false,
    this.error,
    this.guestImportPending = false,
  });

  const AuthState.loading() : this._(phase: AuthPhase.loading);
  const AuthState.signedOut({String? error})
    : this._(phase: AuthPhase.signedOut, error: error);
  const AuthState.signedIn(
    String username, {
    required bool isAdmin,
    String? userId,
    bool guestImportPending = false,
  }) : this._(
         phase: AuthPhase.signedIn,
         username: username,
         isAdmin: isAdmin,
         userId: userId,
         guestImportPending: guestImportPending,
       );

  final AuthPhase phase;
  final String? username;
  final String? userId;
  final bool isAdmin;
  final String? error;
  final bool guestImportPending;

  bool get isSignedIn => phase == AuthPhase.signedIn;
}

class AuthViewModel extends Notifier<AuthState> {
  BackendAuthSession get _session => ref.read(backendAuthSessionProvider);

  @override
  AuthState build() {
    Future<void>.microtask(_restore);
    return const AuthState.loading();
  }

  Future<void> logIn(String username, String password) =>
      _authenticate(() => _session.logIn(username, password));

  Future<void> logOut() async {
    try {
      await _session.logOut();
    } finally {
      state = const AuthState.signedOut();
    }
  }

  Future<void> _restore() async {
    try {
      final user = await _session.restore();
      state = user == null
          ? const AuthState.signedOut()
          : await _signedInState(user);
    } on Object {
      state = const AuthState.signedOut();
    }
  }

  Future<void> importGuestWorkspace() async {
    final store = ref.read(platformLocalStoreProvider);
    if (store is! PlatformScopedStore) return;
    final scoped = store as PlatformScopedStore;
    final documents = await scoped.readGuestTaskLists();
    final repository = ref.read(taskListRepositoryProvider);
    for (final document in documents) {
      if (document.error != null) continue;
      try {
        final list = TaskList.fromJson(document.value);
        list.validate();
        await repository.save(list);
      } on FormatException {
        // The local repository already reports malformed guest documents when
        // opened directly. Do not prevent valid lists from being imported.
      }
    }
    await scoped.markGuestImportDecided();
    _finishGuestImport();
  }

  Future<void> keepGuestWorkspaceSeparate() async {
    final store = ref.read(platformLocalStoreProvider);
    if (store case final PlatformScopedStore scoped) {
      await scoped.markGuestImportDecided();
    }
    _finishGuestImport();
  }

  void _finishGuestImport() {
    state = AuthState.signedIn(
      state.username!,
      isAdmin: state.isAdmin,
      userId: state.userId,
    );
    ref.invalidate(workspaceViewModelProvider);
  }

  Future<void> _authenticate(
    Future<AuthenticatedUser> Function() action,
  ) async {
    state = const AuthState.loading();
    try {
      final user = await action();
      // Reset user-scoped data only after fresh credentials exist. Invalidating
      // the workspace during logout can otherwise make it reload with a
      // cleared session and preserve that failure for the next login.
      ref.invalidate(taskListRepositoryProvider);
      ref.invalidate(workspaceViewModelProvider);
      state = await _signedInState(user);
    } on BackendRequestException catch (error) {
      state = AuthState.signedOut(error: _message(error));
    } on Object {
      state = const AuthState.signedOut();
    }
  }

  Future<AuthState> _signedInState(AuthenticatedUser user) async {
    var offerImport = false;
    final store = ref.read(platformLocalStoreProvider);
    if (!user.isAdmin && store is PlatformScopedStore) {
      final scoped = store as PlatformScopedStore;
      offerImport =
          !await scoped.guestImportWasDecided() &&
          (await scoped.readGuestTaskLists()).isNotEmpty;
    }
    return AuthState.signedIn(
      user.username,
      isAdmin: user.isAdmin,
      userId: user.id,
      guestImportPending: offerImport,
    );
  }

  String _message(BackendRequestException error) {
    if (error.statusCode == 401) return 'Invalid username or password.';
    return 'Could not contact the server. Try again.';
  }
}
