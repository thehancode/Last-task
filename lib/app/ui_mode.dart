import 'package:flutter/foundation.dart';

/// The browser, Linux, and Windows builds mirror the terminal application.
/// Other Flutter targets retain the touch-oriented Material presentation.
bool get usesTerminalPresentation =>
    usesTerminalPresentationFor(isWeb: kIsWeb, platform: defaultTargetPlatform);

bool usesTerminalPresentationFor({
  required bool isWeb,
  required TargetPlatform platform,
}) =>
    isWeb ||
    platform == TargetPlatform.linux ||
    platform == TargetPlatform.windows;

/// Native background images are available where an IO image picker and
/// filesystem-backed image loading are supported.
bool get supportsDesktopBackground => supportsDesktopBackgroundFor(
  isWeb: kIsWeb,
  platform: defaultTargetPlatform,
);

bool supportsDesktopBackgroundFor({
  required bool isWeb,
  required TargetPlatform platform,
}) =>
    !isWeb &&
    (platform == TargetPlatform.linux ||
        platform == TargetPlatform.windows ||
        platform == TargetPlatform.android);

/// Linux and Windows use a frameless native window, so Flutter provides the
/// replacement drag area.
bool get usesFramelessDesktopWindow => usesFramelessDesktopWindowFor(
  isWeb: kIsWeb,
  platform: defaultTargetPlatform,
);

bool usesFramelessDesktopWindowFor({
  required bool isWeb,
  required TargetPlatform platform,
}) =>
    !isWeb &&
    (platform == TargetPlatform.linux || platform == TargetPlatform.windows);

/// Window placement is restored only on the desktop targets that use the
/// custom native window treatment.
bool get usesWindowPositionPersistence => usesWindowPositionPersistenceFor(
  isWeb: kIsWeb,
  platform: defaultTargetPlatform,
);

bool usesWindowPositionPersistenceFor({
  required bool isWeb,
  required TargetPlatform platform,
}) =>
    !isWeb &&
    (platform == TargetPlatform.linux || platform == TargetPlatform.windows);
