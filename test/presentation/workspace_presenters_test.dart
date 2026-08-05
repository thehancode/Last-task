import 'package:flutter_app/l10n/app_localizations_en.dart';
import 'package:flutter_app/l10n/app_localizations_es.dart';
import 'package:flutter_app/presentation/workspace/workspace_presenters.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final english = AppLocalizationsEn();
  final spanish = AppLocalizationsEs();

  test('completion stamp uses 24-hour time on the same local day', () {
    expect(
      workspaceCompletionStamp(
        DateTime(2026, 12, 31, 23, 15),
        english,
        now: DateTime(2026, 12, 31, 23, 59),
      ),
      '23:15',
    );
  });

  test('completion stamp counts local calendar days through day 30', () {
    final now = DateTime(2026, 3, 31, 8);
    expect(
      workspaceCompletionStamp(
        DateTime(2026, 3, 30, 23, 59),
        english,
        now: now,
      ),
      '1d',
    );
    expect(
      workspaceCompletionStamp(DateTime(2026, 3, 1, 8), english, now: now),
      '30d',
    );
  });

  test('completion stamp uses each language date pattern after day 30', () {
    final completedAt = DateTime(2026, 12, 31, 23, 15);
    final now = DateTime(2027, 2, 1);
    expect(
      workspaceCompletionStamp(completedAt, english, now: now),
      '12-31-2026',
    );
    expect(
      workspaceCompletionStamp(completedAt, spanish, now: now),
      '31/12/2026',
    );
  });

  test('completion stamp shows a full date for future calendar days', () {
    expect(
      workspaceCompletionStamp(
        DateTime(2027, 1, 1, 23, 15),
        english,
        now: DateTime(2026, 12, 31, 23, 59),
      ),
      '01-01-2027',
    );
  });
}
