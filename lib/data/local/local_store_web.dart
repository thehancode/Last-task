import 'package:idb_shim/idb_browser.dart';

import 'local_store_base.dart';

PlatformLocalStore createPlatformLocalStore() => _WebLocalStore();

class _WebLocalStore
    implements PlatformLocalStore, PlatformSyncStore, PlatformScopedStore {
  static const _databaseName = 'focus-list-local-v1';
  static const _listsStore = 'task_lists';
  static const _settingsStore = 'settings';
  static const _syncOutboxStore = 'sync_outbox';
  static const _syncCanonicalStore = 'sync_canonical';
  Database? _database;
  String? _accountId;

  String _key(String key) => _accountId == null ? key : '${_accountId!}::$key';
  String? get _prefix => _accountId == null ? null : '${_accountId!}::';

  bool _belongsToScope(Object key) {
    final value = key.toString();
    final prefix = _prefix;
    return prefix == null ? !value.contains('::') : value.startsWith(prefix);
  }

  String _unscopedKey(Object key) {
    final value = key.toString();
    final prefix = _prefix;
    return prefix == null ? value : value.substring(prefix.length);
  }

  @override
  void setAccountScope(String? accountId) => _accountId = accountId;

  @override
  Future<List<StoredDocument>> readGuestTaskLists() =>
      _readTaskListsForPrefix(null);

  @override
  Future<bool> guestImportWasDecided() async {
    final transaction = (await _open()).transaction(
      _settingsStore,
      idbModeReadOnly,
    );
    final value = await transaction
        .objectStore(_settingsStore)
        .getObject(_key('guest_import_decided'));
    await transaction.completed;
    return value == true;
  }

  @override
  Future<void> markGuestImportDecided() async {
    final transaction = (await _open()).transaction(
      _settingsStore,
      idbModeReadWrite,
    );
    await transaction
        .objectStore(_settingsStore)
        .put(true, _key('guest_import_decided'));
    await transaction.completed;
  }

  Future<Database> _open() async {
    if (_database != null) return _database!;
    _database = await idbFactoryBrowser.open(
      _databaseName,
      version: 2,
      onUpgradeNeeded: (event) {
        final database = event.database;
        if (!database.objectStoreNames.contains(_listsStore)) {
          database.createObjectStore(_listsStore);
        }
        if (!database.objectStoreNames.contains(_settingsStore)) {
          database.createObjectStore(_settingsStore);
        }
        if (!database.objectStoreNames.contains(_syncOutboxStore)) {
          database.createObjectStore(_syncOutboxStore);
        }
        if (!database.objectStoreNames.contains(_syncCanonicalStore)) {
          database.createObjectStore(_syncCanonicalStore);
        }
      },
    );
    return _database!;
  }

  @override
  Future<void> deleteTaskList(String id) async {
    final transaction = (await _open()).transaction(
      _listsStore,
      idbModeReadWrite,
    );
    await transaction.objectStore(_listsStore).delete(_key(id));
    await transaction.completed;
  }

  @override
  Future<Map<String, Object?>?> readSettings() async {
    final transaction = (await _open()).transaction(
      _settingsStore,
      idbModeReadOnly,
    );
    final value = await transaction
        .objectStore(_settingsStore)
        .getObject(_key('settings'));
    await transaction.completed;
    return value == null ? null : Map<String, Object?>.from(value as Map);
  }

  @override
  Future<Map<String, Object?>?> readDeviceState() async {
    final transaction = (await _open()).transaction(
      _settingsStore,
      idbModeReadOnly,
    );
    final value = await transaction
        .objectStore(_settingsStore)
        .getObject(_key('device_state'));
    await transaction.completed;
    return value == null ? null : Map<String, Object?>.from(value as Map);
  }

  @override
  Future<void> deleteAuthSession() async {
    final transaction = (await _open()).transaction(
      _settingsStore,
      idbModeReadWrite,
    );
    await transaction.objectStore(_settingsStore).delete('auth_session');
    await transaction.completed;
  }

  @override
  Future<Map<String, Object?>?> readAuthSession() async {
    final transaction = (await _open()).transaction(
      _settingsStore,
      idbModeReadOnly,
    );
    final value = await transaction
        .objectStore(_settingsStore)
        .getObject('auth_session');
    await transaction.completed;
    return value == null ? null : Map<String, Object?>.from(value as Map);
  }

  @override
  Future<List<StoredDocument>> readTaskLists() async {
    return _readTaskListsForPrefix(_prefix);
  }

  Future<List<StoredDocument>> _readTaskListsForPrefix(String? prefix) async {
    final transaction = (await _open()).transaction(
      _listsStore,
      idbModeReadOnly,
    );
    final store = transaction.objectStore(_listsStore);
    final keys = await store.getAllKeys();
    final result = <StoredDocument>[];
    for (final key in keys) {
      final valueKey = key.toString();
      if (prefix == null
          ? valueKey.contains('::')
          : !valueKey.startsWith(prefix)) {
        continue;
      }
      final value = await store.getObject(key);
      if (value != null) {
        result.add(
          StoredDocument(
            key: prefix == null ? valueKey : valueKey.substring(prefix.length),
            value: Map<String, Object?>.from(value as Map),
          ),
        );
      }
    }
    await transaction.completed;
    return result;
  }

  @override
  Future<void> writeSettings(Map<String, Object?> value) async {
    final transaction = (await _open()).transaction(
      _settingsStore,
      idbModeReadWrite,
    );
    await transaction.objectStore(_settingsStore).put(value, _key('settings'));
    await transaction.completed;
  }

  @override
  Future<void> writeDeviceState(Map<String, Object?> value) async {
    final transaction = (await _open()).transaction(
      _settingsStore,
      idbModeReadWrite,
    );
    await transaction
        .objectStore(_settingsStore)
        .put(value, _key('device_state'));
    await transaction.completed;
  }

  @override
  Future<void> writeAuthSession(Map<String, Object?> value) async {
    final transaction = (await _open()).transaction(
      _settingsStore,
      idbModeReadWrite,
    );
    await transaction.objectStore(_settingsStore).put(value, 'auth_session');
    await transaction.completed;
  }

  @override
  Future<void> writeTaskList(String id, Map<String, Object?> value) async {
    final transaction = (await _open()).transaction(
      _listsStore,
      idbModeReadWrite,
    );
    await transaction.objectStore(_listsStore).put(value, _key(id));
    await transaction.completed;
  }

  @override
  Future<List<StoredBinaryDocument>> readPendingMutations() =>
      _readBinaryStore(_syncOutboxStore);

  @override
  Future<void> writePendingMutation(String id, List<int> value) =>
      _writeBinary(_syncOutboxStore, id, value);

  @override
  Future<void> deletePendingMutation(String id) =>
      _deleteBinary(_syncOutboxStore, id);

  @override
  Future<Map<String, Object?>?> readSyncState() async {
    final transaction = (await _open()).transaction(
      _settingsStore,
      idbModeReadOnly,
    );
    final value = await transaction
        .objectStore(_settingsStore)
        .getObject(_key('sync_state'));
    await transaction.completed;
    return value == null ? null : Map<String, Object?>.from(value as Map);
  }

  @override
  Future<void> writeSyncState(Map<String, Object?> value) async {
    final transaction = (await _open()).transaction(
      _settingsStore,
      idbModeReadWrite,
    );
    await transaction
        .objectStore(_settingsStore)
        .put(value, _key('sync_state'));
    await transaction.completed;
  }

  @override
  Future<List<StoredBinaryDocument>> readCanonicalLists() =>
      _readBinaryStore(_syncCanonicalStore);

  @override
  Future<void> writeCanonicalList(String id, List<int> value) =>
      _writeBinary(_syncCanonicalStore, id, value);

  @override
  Future<void> deleteCanonicalList(String id) =>
      _deleteBinary(_syncCanonicalStore, id);

  Future<List<StoredBinaryDocument>> _readBinaryStore(String storeName) async {
    final transaction = (await _open()).transaction(storeName, idbModeReadOnly);
    final store = transaction.objectStore(storeName);
    final keys = await store.getAllKeys();
    final result = <StoredBinaryDocument>[];
    for (final key in keys) {
      if (!_belongsToScope(key)) continue;
      final value = await store.getObject(key);
      if (value is List) {
        result.add(
          StoredBinaryDocument(
            key: _unscopedKey(key),
            value: value.cast<int>(),
          ),
        );
      }
    }
    await transaction.completed;
    result.sort((a, b) => a.key.compareTo(b.key));
    return result;
  }

  Future<void> _writeBinary(
    String storeName,
    String id,
    List<int> value,
  ) async {
    final transaction = (await _open()).transaction(
      storeName,
      idbModeReadWrite,
    );
    await transaction.objectStore(storeName).put(value, _key(id));
    await transaction.completed;
  }

  Future<void> _deleteBinary(String storeName, String id) async {
    final transaction = (await _open()).transaction(
      storeName,
      idbModeReadWrite,
    );
    await transaction.objectStore(storeName).delete(_key(id));
    await transaction.completed;
  }
}
