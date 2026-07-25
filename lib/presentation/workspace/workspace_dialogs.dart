import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme_catalog.dart';
import '../../app/ui_mode.dart';
import '../../l10n/app_localizations.dart';
import '../terminal_style.dart';
import '../workspace_view_model.dart';

EdgeInsetsGeometry? get _dialogTitlePadding =>
    usesTerminalPresentation ? const EdgeInsets.fromLTRB(10, 8, 10, 0) : null;

EdgeInsetsGeometry? get _dialogContentPadding =>
    usesTerminalPresentation ? const EdgeInsets.fromLTRB(10, 8, 10, 8) : null;

TextStyle? _dialogInputStyle(BuildContext context) =>
    usesTerminalPresentation ? Theme.of(context).textTheme.bodyMedium : null;

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
              _ThemePreview(theme: theme),
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

class _ThemePreview extends StatelessWidget {
  const _ThemePreview({required this.theme});
  final AppThemeDefinition theme;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    color: theme.panel,
    padding: TerminalMetrics.panelPadding(context),
    child: DefaultTextStyle(
      style: Theme.of(
        context,
      ).textTheme.bodyMedium!.copyWith(color: theme.text),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('● Doing', style: TextStyle(color: theme.doing)),
          Text('◌ Pending', style: TextStyle(color: theme.pending)),
          Text('✓ Done', style: TextStyle(color: theme.done)),
          const Text('  sample task'),
          Text(
            '  sample task',
            style: TextStyle(
              color: theme.muted,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          Container(
            width: double.infinity,
            color: theme.accent,
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Text(
              '› selected task',
              style: TextStyle(
                color: theme.background,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class WorkspaceTaskDraft {
  const WorkspaceTaskDraft(this.title, this.daily);
  final String title;
  final bool daily;
}

class _ToggleDailyIntent extends Intent {
  const _ToggleDailyIntent();
}

class _SaveTaskIntent extends Intent {
  const _SaveTaskIntent();
}

class _TaskEditorTerminalToggle extends StatelessWidget {
  const _TaskEditorTerminalToggle({
    required this.value,
    required this.label,
    required this.onChanged,
  });

  final bool value;
  final String label;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => Semantics(
    toggled: value,
    button: true,
    label: label,
    child: InkWell(
      onTap: () => onChanged(!value),
      child: SizedBox(
        height: TerminalMetrics.line(context),
        child: Row(
          children: [
            Text(
              value ? '[x]' : '[ ]',
              style: TextStyle(
                color: TerminalPalette.of(context).accent,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: TerminalMetrics.cell(context)),
            Text(label),
          ],
        ),
      ),
    ),
  );
}

class WorkspaceTaskEditorDialog extends StatefulWidget {
  const WorkspaceTaskEditorDialog({
    super.key,
    required this.title,
    required this.initialTitle,
    required this.initialDaily,
    this.allowDaily = true,
  });
  final String title;
  final String initialTitle;
  final bool initialDaily;
  final bool allowDaily;
  @override
  State<WorkspaceTaskEditorDialog> createState() =>
      _WorkspaceTaskEditorDialogState();
}

class _WorkspaceTaskEditorDialogState extends State<WorkspaceTaskEditorDialog> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialTitle,
  );
  late bool _daily = widget.initialDaily;
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() =>
      Navigator.pop(context, WorkspaceTaskDraft(_controller.text, _daily));

  @override
  Widget build(BuildContext context) => Shortcuts(
    shortcuts: const {
      SingleActivator(LogicalKeyboardKey.tab): _ToggleDailyIntent(),
      SingleActivator(LogicalKeyboardKey.enter): _SaveTaskIntent(),
    },
    child: Actions(
      actions: {
        _ToggleDailyIntent: CallbackAction<_ToggleDailyIntent>(
          onInvoke: (_) {
            if (!widget.allowDaily) return null;
            setState(() => _daily = !_daily);
            return null;
          },
        ),
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
              if (widget.allowDaily && usesTerminalPresentation)
                _TaskEditorTerminalToggle(
                  value: _daily,
                  label: AppLocalizations.of(context)!.dailyTask,
                  onChanged: (value) => setState(() => _daily = value),
                )
              else if (widget.allowDaily)
                SwitchListTile(
                  value: _daily,
                  onChanged: (value) => setState(() => _daily = value),
                  title: Text(AppLocalizations.of(context)!.dailyTask),
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

  void _save() => Navigator.pop(context, _controller.text);

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
      child: TextField(
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
