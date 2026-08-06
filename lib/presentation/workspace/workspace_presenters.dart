import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/models.dart';
import '../../l10n/app_localizations.dart';
import '../terminal_style.dart';

String workspaceStatusLabel(TaskStatus status, AppLocalizations strings) =>
    switch (status) {
      TaskStatus.pending => strings.pending,
      TaskStatus.doing => strings.doing,
      TaskStatus.done => strings.done,
      TaskStatus.archived => strings.archived,
    };

String workspaceStatusIcon(TaskStatus status) => switch (status) {
  TaskStatus.pending => '◌',
  TaskStatus.doing => '●',
  TaskStatus.done => '✓',
  TaskStatus.archived => '×',
};

Color workspaceStatusColor(BuildContext context, TaskStatus status) =>
    switch (status) {
      TaskStatus.pending => TerminalPalette.of(context).pending,
      TaskStatus.doing => TerminalPalette.of(context).doing,
      TaskStatus.done => TerminalPalette.of(context).done,
      TaskStatus.archived => TerminalPalette.of(context).muted,
    };

String workspaceCompletionStamp(
  DateTime value,
  AppLocalizations strings, {
  DateTime? now,
  bool compactElapsed = false,
}) {
  final local = value.toLocal();
  final localNow = (now ?? DateTime.now()).toLocal();
  String two(int number) => number.toString().padLeft(2, '0');
  final completionDay = DateTime.utc(local.year, local.month, local.day);
  final currentDay = DateTime.utc(localNow.year, localNow.month, localNow.day);
  final daysAgo = currentDay.difference(completionDay).inDays;
  if (daysAgo == 0) {
    return '${two(local.hour)}:${two(local.minute)}';
  }
  if (daysAgo >= 1 && daysAgo <= 30) {
    return '$daysAgo${strings.completionDaySuffix}';
  }
  if (compactElapsed) {
    final future = daysAgo < 0;
    final elapsedDays = daysAgo.abs();
    final prefix = future ? '+' : '';
    if (elapsedDays <= 30) {
      return '$prefix$elapsedDays${strings.completionDaySuffix}';
    }
    if (elapsedDays < 365) {
      return '$prefix${elapsedDays ~/ 30}${strings.completionMonthSuffix}';
    }
    return '$prefix${elapsedDays ~/ 365}${strings.completionYearSuffix}';
  }
  return DateFormat(strings.completionDatePattern).format(local);
}

String workspaceDailyActivity(Task task, {DateTime? today}) {
  final now = today ?? DateTime.now();
  return List<String>.generate(16, (offset) {
    final day = now.subtract(Duration(days: offset));
    return task.completionHistory.any((entry) => isSameLocalDay(entry, day))
        ? '■'
        : '·';
  }).join();
}
