import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/ui_mode.dart';
import '../../l10n/app_localizations.dart';
import '../terminal_style.dart';
import '../workspace_view_model.dart';
import 'workspace_dialogs.dart';
import 'workspace_presenters.dart';
import 'workspace_settings_dialog.dart';

class WorkspaceFooter extends ConsumerWidget {
  const WorkspaceFooter({
    super.key,
    required this.state,
    required this.grabbed,
    required this.onNewTask,
    required this.onCreateList,
    required this.onRenameList,
    required this.onDeleteList,
    required this.onSettings,
    required this.onHelp,
  });
  final WorkspaceState state;
  final bool grabbed;
  final VoidCallback onNewTask;
  final VoidCallback onCreateList;
  final VoidCallback onRenameList;
  final VoidCallback onDeleteList;
  final VoidCallback onSettings;
  final VoidCallback onHelp;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final terminal = usesTerminalPresentation;
    final activity = state.notice != null
        ? Text(
            ' ${state.notice!.text} ',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: state.notice!.error
                  ? TerminalPalette.of(context).error
                  : TerminalPalette.of(context).done,
              fontWeight: FontWeight.bold,
            ),
          )
        : grabbed
        ? Text(
            AppLocalizations.of(context)!.spaceArmed,
            style: TextStyle(
              color: TerminalPalette.of(context).pending,
              fontWeight: FontWeight.bold,
            ),
          )
        : state.selectedTask?.daily ?? false
        ? Text(
            AppLocalizations.of(
              context,
            )!.dailyActivity(workspaceDailyActivity(state.selectedTask!)),
            style: TextStyle(
              color: TerminalPalette.of(context).done,
              fontWeight: FontWeight.bold,
            ),
          )
        : terminal
        ? const Text(' ')
        : const SizedBox.shrink();

    if (!terminal) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          activity,
          const SizedBox(height: 3),
          Text(
            AppLocalizations.of(context)!.keyboardHint,
            style: TextStyle(
              color: TerminalPalette.of(context).muted,
              fontSize: 12,
            ),
          ),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 1),
          child: activity,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _TerminalCommand(
                keys: 'ctrl+a',
                label: AppLocalizations.of(context)!.commandMulti,
                onTap: ref
                    .read(workspaceViewModelProvider.notifier)
                    .toggleMultiView,
              ),
              _TerminalCommand(
                keys: '←/→',
                label: AppLocalizations.of(context)!.commandLists,
                onTap: () =>
                    ref.read(workspaceViewModelProvider.notifier).cycleList(1),
              ),
              _TerminalCommand(
                keys: '↑↓',
                label: AppLocalizations.of(context)!.commandMove,
              ),
              _TerminalCommand(
                keys: 'n',
                label: AppLocalizations.of(context)!.commandNew,
                onTap: onNewTask,
              ),
              _TerminalCommand(
                keys: 'space f',
                label: AppLocalizations.of(context)!.commandAdvance,
              ),
              _TerminalCommand(
                keys: 'space ↑↓',
                label: AppLocalizations.of(context)!.commandSort,
              ),
              _TerminalCommand(
                keys: 't',
                label: 'themes',
                onTap: () => showDialog<void>(
                  context: context,
                  builder: (_) => const WorkspaceSettingsDialog(
                    initialTab: SettingsTab.themes,
                  ),
                ),
              ),
              _TerminalCommand(
                keys: 'w/shift+w',
                label: AppLocalizations.of(context)!.commandTags,
              ),
              _TerminalCommand(
                keys: 'ctrl+n',
                label: AppLocalizations.of(context)!.commandNewList,
                onTap: onCreateList,
              ),
              _TerminalCommand(
                keys: 'f2',
                label: AppLocalizations.of(context)!.commandRename,
                onTap: onRenameList,
              ),
              _TerminalCommand(
                keys: 'ctrl+x',
                label: AppLocalizations.of(context)!.commandDeleteList,
                onTap: onDeleteList,
              ),
              _TerminalCommand(
                keys: 'g',
                label: AppLocalizations.of(context)!.commandSettings,
                onTap: onSettings,
              ),
              _TerminalCommand(
                keys: '?',
                label: AppLocalizations.of(context)!.commandHelp,
                onTap: onHelp,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TerminalCommand extends StatelessWidget {
  const _TerminalCommand({required this.keys, required this.label, this.onTap});
  final String keys;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: onTap != null,
    label: AppLocalizations.of(context)!.commandSemantics(label, keys),
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              keys,
              style: TextStyle(
                color: TerminalPalette.of(context).accent,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: TerminalMetrics.cell(context)),
            Text(
              label,
              style: TextStyle(color: TerminalPalette.of(context).muted),
            ),
          ],
        ),
      ),
    ),
  );
}
