import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/data/backend_configuration.dart';

void main() {
  test(
    'uses the local desktop endpoint when no build environment is supplied',
    () {
      debugDefaultTargetPlatformOverride = TargetPlatform.linux;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);

      expect(BackendConfiguration.baseUri, Uri.parse('http://localhost:8080'));
    },
  );
}
