import 'package:flutter/material.dart';

import '../terminal_style.dart';

/// Compact, terminal-styled tabs shared by workspace dialogs.
class WorkspaceDialogTabs extends StatelessWidget {
  const WorkspaceDialogTabs({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var index = 0; index < labels.length; index++)
          Expanded(
            child: _WorkspaceDialogTab(
              label: labels[index],
              selected: selectedIndex == index,
              onTap: () => onSelected(index),
            ),
          ),
      ],
    );
  }
}

class _WorkspaceDialogTab extends StatelessWidget {
  const _WorkspaceDialogTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = TerminalPalette.of(context);
    return Semantics(
      selected: selected,
      button: true,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: TerminalMetrics.line(context) * .2,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: selected ? palette.accent : palette.muted,
                  width: selected ? 2 : 1,
                ),
              ),
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: selected ? palette.accent : palette.muted,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
