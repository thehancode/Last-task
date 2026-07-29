import 'local_store_base.dart';

PlatformLocalStore createPlatformLocalStore() => _MemoryStore();

class _MemoryStore
    implements PlatformLocalStore, PlatformSyncStore, PlatformScopedStore {
  final Map<String, Map<String, Object?>> _lists = {};
  final Map<String, List<int>> _outbox = {};
  final Map<String, List<int>> _canonical = {};
  Map<String, Object?>? _syncState;
  Map<String, Object?>? _settings;
  Map<String, Object?>? _deviceState;
  Map<String, Object?>? _authSession;

  @override
  void setAccountScope(String? accountId) {}

  @override
  Future<List<StoredDocument>> readGuestTaskLists() => readTaskLists();

  @override
  Future<bool> guestImportWasDecided() async => true;

  @override
  Future<void> markGuestImportDecided() async {}

  @override
  Future<void> deleteTaskList(String id) async => _lists.remove(id);

  @override
  Future<Map<String, Object?>?> readSettings() async => _settings;

  @override
  Future<Map<String, Object?>?> readDeviceState() async => _deviceState;

  @override
  Future<void> deleteAuthSession() async => _authSession = null;

  @override
  Future<Map<String, Object?>?> readAuthSession() async => _authSession;

  @override
  Future<List<StoredDocument>> readTaskLists() async => _lists.entries
      .map(
        (entry) => StoredDocument(
          key: entry.key,
          value: Map<String, Object?>.from(entry.value),
        ),
      )
      .toList(growable: false);

  @override
  Future<void> writeSettings(Map<String, Object?> value) async {
    _settings = Map<String, Object?>.from(value);
  }

  @override
  Future<void> writeDeviceState(Map<String, Object?> value) async {
    _deviceState = Map<String, Object?>.from(value);
  }

  @override
  Future<void> writeAuthSession(Map<String, Object?> value) async {
    _authSession = Map<String, Object?>.from(value);
  }

  @override
  Future<void> writeTaskList(String id, Map<String, Object?> value) async {
    _lists[id] = Map<String, Object?>.from(value);
  }

  @override
  Future<List<StoredBinaryDocument>> readPendingMutations() async =>
      _outbox.entries
          .map(
            (entry) => StoredBinaryDocument(key: entry.key, value: entry.value),
          )
          .toList()
        ..sort((a, b) => a.key.compareTo(b.key));

  @override
  Future<void> writePendingMutation(String id, List<int> value) async {
    _outbox[id] = List<int>.from(value);
  }

  @override
  Future<void> deletePendingMutation(String id) async => _outbox.remove(id);

  @override
  Future<Map<String, Object?>?> readSyncState() async =>
      _syncState == null ? null : Map<String, Object?>.from(_syncState!);

  @override
  Future<void> writeSyncState(Map<String, Object?> value) async {
    _syncState = Map<String, Object?>.from(value);
  }

  @override
  Future<List<StoredBinaryDocument>> readCanonicalLists() async =>
      _canonical.entries
          .map(
            (entry) => StoredBinaryDocument(key: entry.key, value: entry.value),
          )
          .toList()
        ..sort((a, b) => a.key.compareTo(b.key));

  @override
  Future<void> writeCanonicalList(String id, List<int> value) async {
    _canonical[id] = List<int>.from(value);
  }

  @override
  Future<void> deleteCanonicalList(String id) async => _canonical.remove(id);
}
