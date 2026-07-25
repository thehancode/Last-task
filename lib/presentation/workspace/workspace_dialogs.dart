import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme_catalog.dart';
import '../../app/ui_mode.dart';
import '../../l10n/app_localizations.dart';
import '../terminal_style.dart';
import '../workspace_view_model.dart';
import 'workspace_dialog_tabs.dart';
import 'workspace_theme_preview.dart';

EdgeInsetsGeometry? get _dialogTitlePadding =>
    usesTerminalPresentation ? const EdgeInsets.fromLTRB(10, 8, 10, 0) : null;

EdgeInsetsGeometry? get _dialogContentPadding =>
    usesTerminalPresentation ? const EdgeInsets.fromLTRB(10, 8, 10, 8) : null;

TextStyle? _dialogInputStyle(BuildContext context) =>
    usesTerminalPresentation ? Theme.of(context).textTheme.bodyMedium : null;

class WorkspaceHelpDialog extends StatefulWidget {
  const WorkspaceHelpDialog({super.key});

  @override
  State<WorkspaceHelpDialog> createState() => _WorkspaceHelpDialogState();
}

class _WorkspaceHelpDialogState extends State<WorkspaceHelpDialog> {
  var _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return AlertDialog(
      titlePadding: _dialogTitlePadding,
      contentPadding: _dialogContentPadding,
      title: Text(strings.keyboardShortcuts),
      content: SizedBox(
        width: 680,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            WorkspaceDialogTabs(
              labels: [strings.keyboardShortcuts, strings.tipsTitle],
              selectedIndex: _selectedTab,
              onSelected: (index) => setState(() => _selectedTab = index),
            ),
            SizedBox(height: TerminalMetrics.line(context) * .35),
            IndexedStack(
              index: _selectedTab,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(strings.keyboardShortcutsHelp),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final id in const [
                      'navigation',
                      'reorder',
                      'subtasks',
                      'search',
                      'copy',
                    ])
                      Text('• ${_helpTipText(strings, id)}'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(strings.close),
        ),
      ],
    );
  }
}

String _helpTipText(AppLocalizations strings, String id) => switch (id) {
  'navigation' => strings.tipNavigation,
  'reorder' => strings.tipReorder,
  'subtasks' => strings.tipSubtasks,
  'search' => strings.tipSearch,
  'copy' => strings.tipCopy,
  _ => '',
};

class WorkspaceThemePickerDialog extends ConsumerStatefulWidget {
  const WorkspaceThemePickerDialog({super.key});

  @override
  ConsumerState<WorkspaceThemePickerDialog> createState() =>
      _WorkspaceThemePickerDialogState();
}

class _WorkspaceThemePickerDialogState
    extends ConsumerState<WorkspaceThemePickerDialog> {
  final _focusNode = FocusNode(debugLabel: 'theme-picker');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _focusNode.requestFocus(),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _cycle(int direction) {
    final catalog = ref.read(themeCatalogProvider);
    final current = ref.read(workspaceViewModelProvider).settings.themeId;
    final index = catalog.themes.indexWhere((theme) => theme.id == current);
    final next =
        catalog.themes[(index + direction + catalog.themes.length) %
            catalog.themes.length];
    _select(next.id);
  }

  void _select(String id) {
    final vm = ref.read(workspaceViewModelProvider.notifier);
    final settings = ref.read(workspaceViewModelProvider).settings;
    unawaited(vm.updateSettings(settings.copyWith(themeId: id)));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(workspaceViewModelProvider);
    final catalog = ref.watch(themeCatalogProvider);
    final theme = catalog.byId(state.settings.themeId);
    return Focus(
      focusNode: _focusNode,
      onKeyEvent: (_, event) {
        if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
          return KeyEventResult.ignored;
        }
        if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
          _cycle(-1);
          return KeyEventResult.handled;
        }
        if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
          _cycle(1);
          return KeyEventResult.handled;
        }
        if (event.logicalKey == LogicalKeyboardKey.escape ||
            event.logicalKey == LogicalKeyboardKey.keyT) {
          Navigator.pop(context);
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: AlertDialog(
        titlePadding: _dialogTitlePadding,
        contentPadding: _dialogContentPadding,
        title: const Text('Themes'),
        content: SizedBox(
          width: 360,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WorkspaceThemePreview(theme: theme),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: [
                  for (final item in catalog.themes)
                    TextButton(
                      onPressed: () => _select(item.id),
                      child: Text(item.name),
                    ),
                ],
              ),
              Text(
                '← / → to cycle',
                style: TextStyle(color: TerminalPalette.of(context).muted),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class WorkspaceTaskDraft {
  const WorkspaceTaskDraft(this.title);
  final String title;
}

class _SaveTaskIntent extends Intent {
  const _SaveTaskIntent();
}

class WorkspaceTaskEditorDialog extends StatefulWidget {
  const WorkspaceTaskEditorDialog({
    super.key,
    required this.title,
    required this.initialTitle,
  });
  final String title;
  final String initialTitle;
  @override
  State<WorkspaceTaskEditorDialog> createState() =>
      _WorkspaceTaskEditorDialogState();
}

class _WorkspaceTaskEditorDialogState extends State<WorkspaceTaskEditorDialog> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialTitle,
  );
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() => Navigator.pop(context, WorkspaceTaskDraft(_controller.text));

  @override
  Widget build(BuildContext context) => Shortcuts(
    shortcuts: const {
      SingleActivator(LogicalKeyboardKey.enter): _SaveTaskIntent(),
    },
    child: Actions(
      actions: {
        _SaveTaskIntent: CallbackAction<_SaveTaskIntent>(
          onInvoke: (_) {
            _save();
            return null;
          },
        ),
      },
      child: AlertDialog(
        titlePadding: _dialogTitlePadding,
        contentPadding: _dialogContentPadding,
        title: Text(widget.title),
        content: SizedBox(
          width: 460,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _controller,
                autofocus: true,
                style: _dialogInputStyle(context),
                cursorHeight: usesTerminalPresentation
                    ? TerminalMetrics.renderedFontSize(context)
                    : null,
                cursorWidth: usesTerminalPresentation ? 1 : 2,
                maxLines: 3,
                minLines: 1,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.taskTitle,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          FilledButton(
            onPressed: _save,
            child: Text(AppLocalizations.of(context)!.save),
          ),
        ],
      ),
    ),
  );
}

class WorkspaceListDraft {
  const WorkspaceListDraft(this.name, this.isHabit);

  final String name;
  final bool isHabit;
}

class WorkspaceListEditorDialog extends StatefulWidget {
  const WorkspaceListEditorDialog({
    super.key,
    required this.initial,
    required this.rename,
  });
  final String initial;
  final bool rename;
  @override
  State<WorkspaceListEditorDialog> createState() =>
      _WorkspaceListEditorDialogState();
}

class _WorkspaceListEditorDialogState extends State<WorkspaceListEditorDialog> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initial,
  );
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  var _isHabit = false;

  void _save() =>
      Navigator.pop(context, WorkspaceListDraft(_controller.text, _isHabit));

  @override
  Widget build(BuildContext context) => AlertDialog(
    titlePadding: _dialogTitlePadding,
    contentPadding: _dialogContentPadding,
    title: Text(
      widget.rename
          ? AppLocalizations.of(context)!.renameList
          : AppLocalizations.of(context)!.newList,
    ),
    content: SizedBox(
      width: 380,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            autofocus: true,
            style: _dialogInputStyle(context),
            cursorHeight: usesTerminalPresentation
                ? TerminalMetrics.renderedFontSize(context)
                : null,
            cursorWidth: usesTerminalPresentation ? 1 : 2,
            onSubmitted: (_) => _save(),
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.listName,
            ),
          ),
          if (!widget.rename)
            usesTerminalPresentation
                ? Semantics(
                    toggled: _isHabit,
                    button: true,
                    label: AppLocalizations.of(context)!.habitList,
                    child: InkWell(
                      onTap: () => setState(() => _isHabit = !_isHabit),
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: TerminalMetrics.line(context) * .25,
                        ),
                        child: Row(
                          children: [
                            Text(
                              _isHabit ? '[x]' : '[ ]',
                              style: TextStyle(
                                color: TerminalPalette.of(context).accent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: TerminalMetrics.cell(context)),
                            Expanded(
                              child: Text(
                                AppLocalizations.of(context)!.habitList,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _isHabit,
                    onChanged: (value) =>
                        setState(() => _isHabit = value ?? false),
                    title: Text(AppLocalizations.of(context)!.habitList),
                  ),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(AppLocalizations.of(context)!.cancel),
      ),
      FilledButton(
        onPressed: _save,
        child: Text(AppLocalizations.of(context)!.save),
      ),
    ],
  );
}
