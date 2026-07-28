import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/repositories.dart';
import 'backend_task_list_repository.dart';
import 'backend_auth_session.dart';
import 'local/local_store.dart';
import 'local_repositories.dart';

final platformLocalStoreProvider = Provider<PlatformLocalStore>(
  (ref) => createPlatformLocalStore(),
);

final taskListRepositoryProvider = Provider<TaskListRepository>((ref) {
  final store = ref.watch(platformLocalStoreProvider);
  return SwitchingTaskListRepository(
    LocalTaskListRepository(store),
    BackendTaskListRepository(auth: ref.watch(backendAuthSessionProvider)),
    LocalSettingsRepository(store),
  );
});

final backendAuthSessionProvider = Provider<BackendAuthSession>(
  (ref) => BackendAuthSession(ref.watch(platformLocalStoreProvider)),
);

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => LocalSettingsRepository(ref.watch(platformLocalStoreProvider)),
);

final deviceStateRepositoryProvider = Provider<DeviceStateRepository>(
  (ref) => LocalDeviceStateRepository(ref.watch(platformLocalStoreProvider)),
);
