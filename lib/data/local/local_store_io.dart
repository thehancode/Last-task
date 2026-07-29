import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'local_store_base.dart';

PlatformLocalStore createPlatformLocalStore() => _IoLocalStore();

class _IoLocalStore
    implements PlatformLocalStore, PlatformSyncStore, PlatformScopedStore {
  static const _settingsRelativePath = 'config/settings.json';
  static const _deviceStateRelativePath = 'config/device-state.json';
  static const _authSessionRelativePath = 'config/auth-session.json';
  static const _syncStateRelativePath = 'config/sync/state.json';
  static const _outboxRelativePath = 'config/sync/outbox';
  static const _canonicalRelativePath = 'config/sync/canonical';
  static const _guestImportMarkerRelativePath =
      'config/guest-import-decided.json';
  String? _accountId;

  @override
  void setAccountScope(String? accountId) => _accountId = accountId;

  @override
  Future<List<StoredDocument>> readGuestTaskLists() async =>
      _readTaskListsFrom(await _root());

  @override
  Future<bool> guestImportWasDecided() async => File(
    path.join((await _dataRoot()).path, _guestImportMarkerRelativePath),
  ).exists();

  @override
  Future<void> markGuestImportDecided() async {
    await _writeAtomically(
      File(path.join((await _dataRoot()).path, _guestImportMarkerRelativePath)),
      {'decided': true},
    );
  }

  Future<Directory> _root() async {
    if (Platform.isLinux) {
      return Directory(
        ioLocalStoreRootPath(
          isLinux: true,
          isWindows: false,
          applicationSupportPath: '',
          environment: Platform.environment,
        ),
      );
    }
    final support = await getApplicationSupportDirectory();
    return Directory(
      ioLocalStoreRootPath(
        isLinux: false,
        isWindows: Platform.isWindows,
        applicationSupportPath: support.path,
        environment: Platform.environment,
      ),
    );
  }

  Future<File> _settingsFile() async {
    final root = await _dataRoot();
    return File(path.join(root.path, _settingsRelativePath));
  }

  Future<File> _deviceStateFile() async {
    final root = await _dataRoot();
    return File(path.join(root.path, _deviceStateRelativePath));
  }

  Future<File> _authSessionFile() async {
    final root = await _root();
    return File(path.join(root.path, _authSessionRelativePath));
  }

  Future<File> _syncStateFile() async =>
      File(path.join((await _dataRoot()).path, _syncStateRelativePath));

  Future<Directory> _outboxDirectory() async =>
      Directory(path.join((await _dataRoot()).path, _outboxRelativePath));

  Future<Directory> _canonicalDirectory() async =>
      Directory(path.join((await _dataRoot()).path, _canonicalRelativePath));

  Future<Directory> _dataRoot() async {
    final root = await _root();
    final accountId = _accountId;
    if (accountId == null) return root;
    return Directory(
      path.join(root.path, 'accounts', Uri.encodeComponent(accountId)),
    );
  }

  @override
  Future<void> deleteAuthSession() async {
    final file = await _authSessionFile();
    if (await file.exists()) await file.delete();
  }

  @override
  Future<Map<String, Object?>?> readAuthSession() async {
    final file = await _authSessionFile();
    if (!await file.exists()) return null;
    return _decode(await file.readAsString(), file.path);
  }

  @override
  Future<void> deleteTaskList(String id) async {
    final root = await _dataRoot();
    final file = File(path.join(root.path, '$id.json'));
    if (await file.exists()) await file.delete();
  }

  @override
  Future<Map<String, Object?>?> readSettings() async {
    final file = await _settingsFile();
    if (!await file.exists()) return null;
    return _decode(await file.readAsString(), file.path);
  }

  @override
  Future<Map<String, Object?>?> readDeviceState() async {
    final file = await _deviceStateFile();
    if (!await file.exists()) return null;
    return _decode(await file.readAsString(), file.path);
  }

  @override
  Future<List<StoredDocument>> readTaskLists() async {
    return _readTaskListsFrom(await _dataRoot());
  }

  Future<List<StoredDocument>> _readTaskListsFrom(Directory root) async {
    if (!await root.exists()) return const [];
    final result = <StoredDocument>[];
    await for (final entity in root.list(followLinks: false)) {
      if (entity is! File || path.extension(entity.path) != '.json') continue;
      final key = path.basenameWithoutExtension(entity.path);
      try {
        result.add(
          StoredDocument(
            key: key,
            value: _decode(await entity.readAsString(), entity.path),
          ),
        );
      } on Object catch (error) {
        result.add(
          StoredDocument(key: key, value: const {}, error: error.toString()),
        );
      }
    }
    return result;
  }

  @override
  Future<void> writeSettings(Map<String, Object?> value) async {
    final file = await _settingsFile();
    await _writeAtomically(file, value);
  }

  @override
  Future<void> writeDeviceState(Map<String, Object?> value) async {
    await _writeAtomically(await _deviceStateFile(), value);
  }

  @override
  Future<void> writeAuthSession(Map<String, Object?> value) async {
    await _writeAtomically(await _authSessionFile(), value);
  }

  @override
  Future<void> writeTaskList(String id, Map<String, Object?> value) async {
    final root = await _dataRoot();
    await root.create(recursive: true);
    await _writeAtomically(File(path.join(root.path, '$id.json')), value);
  }

  @override
  Future<List<StoredBinaryDocument>> readPendingMutations() async =>
      _readBinaryDocuments(await _outboxDirectory(), '.pb');

  @override
  Future<void> writePendingMutation(String id, List<int> value) async {
    await _writeBytesAtomically(
      File(path.join((await _outboxDirectory()).path, '$id.pb')),
      value,
    );
  }

  @override
  Future<void> deletePendingMutation(String id) async {
    final file = File(path.join((await _outboxDirectory()).path, '$id.pb'));
    if (await file.exists()) await file.delete();
  }

  @override
  Future<Map<String, Object?>?> readSyncState() async {
    final file = await _syncStateFile();
    if (!await file.exists()) return null;
    return _decode(await file.readAsString(), file.path);
  }

  @override
  Future<void> writeSyncState(Map<String, Object?> value) async {
    await _writeAtomically(await _syncStateFile(), value);
  }

  @override
  Future<List<StoredBinaryDocument>> readCanonicalLists() async =>
      _readBinaryDocuments(await _canonicalDirectory(), '.pb');

  @override
  Future<void> writeCanonicalList(String id, List<int> value) async {
    await _writeBytesAtomically(
      File(path.join((await _canonicalDirectory()).path, '$id.pb')),
      value,
    );
  }

  @override
  Future<void> deleteCanonicalList(String id) async {
    final file = File(path.join((await _canonicalDirectory()).path, '$id.pb'));
    if (await file.exists()) await file.delete();
  }

  Future<List<StoredBinaryDocument>> _readBinaryDocuments(
    Directory directory,
    String extension,
  ) async {
    if (!await directory.exists()) return const [];
    final result = <StoredBinaryDocument>[];
    await for (final entity in directory.list(followLinks: false)) {
      if (entity is! File || path.extension(entity.path) != extension) continue;
      result.add(
        StoredBinaryDocument(
          key: path.basenameWithoutExtension(entity.path),
          value: await entity.readAsBytes(),
        ),
      );
    }
    result.sort((a, b) => a.key.compareTo(b.key));
    return result;
  }

  Future<void> _writeBytesAtomically(File destination, List<int> value) async {
    await destination.parent.create(recursive: true);
    final temp = File('${destination.path}.tmp');
    await temp.writeAsBytes(value, flush: true);
    await temp.rename(destination.path);
  }

  Future<void> _writeAtomically(
    File destination,
    Map<String, Object?> value,
  ) async {
    await destination.parent.create(recursive: true);
    final temp = File('${destination.path}.tmp');
    await temp.writeAsString(
      '${const JsonEncoder.withIndent('  ').convert(value)}\n',
      flush: true,
    );
    await temp.rename(destination.path);
  }

  Map<String, Object?> _decode(String source, String location) {
    try {
      return Map<String, Object?>.from(jsonDecode(source) as Map);
    } on Object catch (error) {
      throw FormatException('Invalid JSON in $location: $error');
    }
  }
}

String ioLocalStoreRootPath({
  required bool isLinux,
  required bool isWindows,
  required String applicationSupportPath,
  required Map<String, String> environment,
}) {
  final platformPath = path.Context(
    style: isWindows ? path.Style.windows : path.Style.posix,
  );
  if (isLinux) {
    final dataHome =
        environment['XDG_DATA_HOME'] ??
        platformPath.join(environment['HOME'] ?? '', '.local', 'share');
    // Using the existing Rust location makes migration seamless. Do not run
    // both applications concurrently because they cannot coordinate writes.
    return platformPath.join(dataHome, 'tui-kanban', 'tasklists');
  }
  if (isWindows) {
    return platformPath.join(applicationSupportPath, 'tasklists');
  }
  return platformPath.join(applicationSupportPath, 'focus-list', 'tasklists');
}
