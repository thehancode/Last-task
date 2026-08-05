import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'desktop_background_base.dart';

DesktopBackgroundService createDesktopBackgroundService() =>
    _IoDesktopBackgroundService();

class _IoDesktopBackgroundService implements DesktopBackgroundService {
  @override
  Future<String?> pickImagePath() async {
    if (!Platform.isLinux && !Platform.isWindows && !Platform.isAndroid) {
      return null;
    }
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: Platform.isAndroid,
    );
    if (result == null) return null;
    final file = result.files.single;
    if (!Platform.isAndroid) return file.path;

    final bytes = file.bytes;
    if (bytes == null) return null;
    final directory = Directory(
      path.join((await getApplicationSupportDirectory()).path, 'backgrounds'),
    );
    await directory.create(recursive: true);
    final extension = path.extension(file.name);
    final destination = File(
      path.join(
        directory.path,
        'background-${DateTime.now().microsecondsSinceEpoch}$extension',
      ),
    );
    await destination.writeAsBytes(bytes, flush: true);
    return destination.path;
  }

  @override
  Future<Uint8List?> loadImageBytes(String path) async {
    if (!Platform.isLinux && !Platform.isWindows && !Platform.isAndroid) {
      return null;
    }
    final file = File(path);
    if (!await file.exists()) return null;
    try {
      return await file.readAsBytes();
    } on Object {
      return null;
    }
  }
}
