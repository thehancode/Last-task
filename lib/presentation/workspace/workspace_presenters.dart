import 'package:flutter/material.dart';

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

String workspaceLocalStamp(DateTime value) {
  final local = value.toLocal();
  String two(int number) => number.toString().padLeft(2, '0');
  return '${local.year}-${two(local.month)}-${two(local.day)} '
      '${two(local.hour)}:${two(local.minute)}';
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
