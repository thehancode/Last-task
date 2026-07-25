import 'package:flutter/material.dart';

import '../../app/ui_mode.dart';
import '../../l10n/app_localizations.dart';
import '../terminal_style.dart';
import '../workspace_view_model.dart';
import 'workspace_presenters.dart';

class WorkspaceFooter extends StatelessWidget {
  const WorkspaceFooter({
    super.key,
    required this.state,
    required this.grabbed,
    required this.onNewTask,
    required this.onCreateList,
    required this.onSettings,
    required this.onHelp,
  });
  final WorkspaceState state;
  final bool grabbed;
  final VoidCallback onNewTask;
  final VoidCallback onCreateList;
  final VoidCallback onSettings;
  final VoidCallback onHelp;

  @override
  Widget build(BuildContext context) {
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
          key: const Key('terminal-footer-status'),
          padding: const EdgeInsets.symmetric(vertical: 1),
          child: activity,
        ),
        _TerminalFooterLine(
          lineKey: const Key('terminal-footer-primary'),
          children: [
            _TerminalCommand(
              keys: 'ctrl+n',
              label: AppLocalizations.of(context)!.commandNewList,
              semanticsLabel: AppLocalizations.of(
                context,
              )!.commandNewListLegacy,
              onTap: onCreateList,
            ),
            const _TerminalSeparator(),
            _TerminalCommand(
              keys: 'n',
              label: AppLocalizations.of(context)!.commandNew,
              semanticsLabel: AppLocalizations.of(context)!.commandNewLegacy,
              onTap: onNewTask,
            ),
            const _TerminalSeparator(),
            _TerminalCommand(
              keys: '↑↓←→',
              label: AppLocalizations.of(context)!.commandMove,
              semanticsLabel: AppLocalizations.of(context)!.commandMoveLegacy,
            ),
            const _TerminalSeparator(),
            _TerminalCommand(
              keys: 'w',
              label: AppLocalizations.of(context)!.commandTags,
              semanticsLabel: AppLocalizations.of(context)!.commandTagsLegacy,
            ),
          ],
        ),
        _TerminalFooterLine(
          lineKey: const Key('terminal-footer-secondary'),
          children: [
            _TerminalCommand(
              keys: 'g',
              label: AppLocalizations.of(context)!.commandSettings,
              semanticsLabel: AppLocalizations.of(
                context,
              )!.commandSettingsLegacy,
              onTap: onSettings,
            ),
            const _TerminalSeparator(),
            _TerminalCommand(
              keys: '?',
              label: AppLocalizations.of(context)!.commandHelp,
              semanticsLabel: AppLocalizations.of(context)!.commandHelpLegacy,
              onTap: onHelp,
            ),
          ],
        ),
      ],
    );
  }
}

class _TerminalFooterLine extends StatelessWidget {
  const _TerminalFooterLine({required this.lineKey, required this.children});

  final Key lineKey;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => KeyedSubtree(
      key: lineKey,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: constraints.maxWidth),
          child: Align(
            alignment: Alignment.centerRight,
            child: Row(mainAxisSize: MainAxisSize.min, children: children),
          ),
        ),
      ),
    ),
  );
}

class _TerminalSeparator extends StatelessWidget {
  const _TerminalSeparator();

  @override
  Widget build(BuildContext context) =>
      Text('|', style: TextStyle(color: TerminalPalette.of(context).muted));
}

class _TerminalCommand extends StatelessWidget {
  const _TerminalCommand({
    required this.keys,
    required this.label,
    this.semanticsLabel,
    this.onTap,
  });
  final String keys;
  final String label;
  final String? semanticsLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: onTap != null,
    label: AppLocalizations.of(
      context,
    )!.commandSemantics(semanticsLabel ?? label, keys),
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
