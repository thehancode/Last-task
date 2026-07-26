import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/app/window_position_persistence_io.dart';
import 'package:flutter_app/data/local/local_store_io.dart';

void main() {
  test('Windows uses the fresh product-specific support directory', () {
    const support = r'C:\Users\tester\AppData\Roaming\com.tuikanban\Last Task';

    expect(
      ioLocalStoreRootPath(
        isLinux: false,
        isWindows: true,
        applicationSupportPath: support,
        environment: const {},
      ),
      r'C:\Users\tester\AppData\Roaming\com.tuikanban\Last Task\tasklists',
    );
    expect(
      windowPositionFilePath(
        isLinux: false,
        isWindows: true,
        applicationSupportPath: support,
        environment: const {},
      ),
      r'C:\Users\tester\AppData\Roaming\com.tuikanban\Last Task\window-position.json',
    );
  });

  test('Linux keeps the legacy XDG data and state locations', () {
    expect(
      ioLocalStoreRootPath(
        isLinux: true,
        isWindows: false,
        applicationSupportPath: '',
        environment: const {
          'XDG_DATA_HOME': '/data',
          'XDG_STATE_HOME': '/state',
        },
      ),
      '/data/tui-kanban/tasklists',
    );
    expect(
      windowPositionFilePath(
        isLinux: true,
        isWindows: false,
        applicationSupportPath: '',
        environment: const {
          'XDG_DATA_HOME': '/data',
          'XDG_STATE_HOME': '/state',
        },
      ),
      '/state/tui-kanban/window-position.json',
    );
  });

  test('Android keeps the existing focus-list support directory', () {
    expect(
      ioLocalStoreRootPath(
        isLinux: false,
        isWindows: false,
        applicationSupportPath: '/support',
        environment: const {},
      ),
      '/support/focus-list/tasklists',
    );
  });
}
