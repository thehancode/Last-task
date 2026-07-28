import 'package:flutter/foundation.dart';

/// Backend endpoints supplied at build time with `--dart-define-from-file`.
///
/// Development builds default to localhost. Android emulators use their host
/// loopback alias because their own localhost points at the emulator.
class BackendConfiguration {
  const BackendConfiguration._();

  static const _baseUrl = String.fromEnvironment(
    'BACKEND_BASE_URL',
    defaultValue: 'http://localhost:8080',
  );
  static const _androidBaseUrl = String.fromEnvironment(
    'ANDROID_BACKEND_BASE_URL',
    defaultValue: 'http://10.0.2.2:8080',
  );

  static Uri get baseUri => Uri.parse(
    !kIsWeb && defaultTargetPlatform == TargetPlatform.android
        ? _androidBaseUrl
        : _baseUrl,
  );
}
