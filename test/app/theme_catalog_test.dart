import 'package:flutter_app/app/theme_catalog.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final validTheme = <String, Object?>{
    'id': 'test',
    'name': 'Test',
    'background': '#000000',
    'panel': '#111111',
    'text': '#ffffff',
    'muted': '#999999',
    'accent': '#aa00ff',
    'pending': '#ffaa00',
    'doing': '#00aaff',
    'done': '#00aa00',
    'error': '#ff0000',
  };

  test('theme light flag is explicit with a dark-compatible default', () {
    expect(AppThemeDefinition.fromJson(validTheme).isLight, isFalse);
    expect(
      AppThemeDefinition.fromJson({...validTheme, 'is_light': true}).isLight,
      isTrue,
    );
  });

  test('theme light flag rejects non-boolean values', () {
    expect(
      () => AppThemeDefinition.fromJson({...validTheme, 'is_light': 'yes'}),
      throwsFormatException,
    );
  });
}
