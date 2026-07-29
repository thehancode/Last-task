class StoredDocument {
  const StoredDocument({required this.key, required this.value, this.error});

  /// The backing-store key or filename stem. It can differ from the list UUID
  /// while importing a legacy Rust file.
  final String key;
  final Map<String, Object?> value;
  final String? error;
}

class StoredBinaryDocument {
  const StoredBinaryDocument({required this.key, required this.value});

  final String key;
  final List<int> value;
}

abstract interface class PlatformLocalStore {
  Future<List<StoredDocument>> readTaskLists();
  Future<void> writeTaskList(String id, Map<String, Object?> value);
  Future<void> deleteTaskList(String id);
  Future<Map<String, Object?>?> readSettings();
  Future<void> writeSettings(Map<String, Object?> value);
  Future<Map<String, Object?>?> readDeviceState();
  Future<void> writeDeviceState(Map<String, Object?> value);
  Future<Map<String, Object?>?> readAuthSession();
  Future<void> writeAuthSession(Map<String, Object?> value);
  Future<void> deleteAuthSession();
}

/// Durable synchronization metadata kept alongside the platform local store.
///
/// The outbox is written before the projected task-list document. Replaying it
/// after a crash is therefore always safe.
abstract interface class PlatformSyncStore {
  Future<List<StoredBinaryDocument>> readPendingMutations();
  Future<void> writePendingMutation(String id, List<int> value);
  Future<void> deletePendingMutation(String id);
  Future<Map<String, Object?>?> readSyncState();
  Future<void> writeSyncState(Map<String, Object?> value);
  Future<List<StoredBinaryDocument>> readCanonicalLists();
  Future<void> writeCanonicalList(String id, List<int> value);
  Future<void> deleteCanonicalList(String id);
}

/// Selects the isolated data namespace used by account-scoped repositories.
///
/// Authentication itself is deliberately global so the account can be
/// restored before its data namespace is selected. A null id selects guest.
abstract interface class PlatformScopedStore {
  void setAccountScope(String? accountId);
  Future<List<StoredDocument>> readGuestTaskLists();
  Future<bool> guestImportWasDecided();
  Future<void> markGuestImportDecided();
}
