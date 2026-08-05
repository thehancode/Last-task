import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme_catalog.dart';
import '../../app/ui_mode.dart';
import '../../l10n/app_localizations.dart';
import '../terminal_style.dart';
import '../workspace_view_model.dart';
import 'workspace_theme_preview.dart';

EdgeInsetsGeometry? get _dialogTitlePadding =>
    usesTerminalPresentation ? const EdgeInsets.fromLTRB(10, 8, 10, 0) : null;

EdgeInsetsGeometry? get _dialogContentPadding =>
    usesTerminalPresentation ? const EdgeInsets.fromLTRB(10, 8, 10, 8) : null;

TextStyle? _dialogInputStyle(BuildContext context) =>
    usesTerminalPresentation ? Theme.of(context).textTheme.bodyMedium : null;

class WorkspaceHelpDialog extends StatelessWidget {
  const WorkspaceHelpDialog({super.key});

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
          children: [Text(strings.keyboardShortcutsHelp)],
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

class WorkspaceThemePickerDialog extends ConsumerWidget {
  const WorkspaceThemePickerDialog({super.key});

  void _select(WidgetRef ref, String id) {
    final vm = ref.read(workspaceViewModelProvider.notifier);
    final settings = ref.read(workspaceViewModelProvider).settings;
    unawaited(vm.updateSettings(settings.copyWith(themeId: id)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context)!;
    final state = ref.watch(workspaceViewModelProvider);
    final catalog = ref.watch(themeCatalogProvider);
    final theme = catalog.byId(state.settings.themeId);
    final content = SizedBox(
      width: 420,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            WorkspaceThemePreview(
              key: const Key('mobile-theme-preview'),
              theme: theme,
            ),
            const SizedBox(height: 12),
            for (final item in catalog.themes)
              Semantics(
                selected: item.id == theme.id,
                child: ListTile(
                  key: ValueKey('theme-choice-${item.id}'),
                  selected: item.id == theme.id,
                  selectedColor: Theme.of(context).colorScheme.primary,
                  leading: Icon(
                    item.id == theme.id
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                  ),
                  title: Text(item.name),
                  onTap: () => _select(ref, item.id),
                ),
              ),
          ],
        ),
      ),
    );
    if (!usesTerminalPresentation) {
      return Scaffold(
        appBar: AppBar(
          title: Text(strings.themes),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              key: const Key('mobile-themes-close'),
              icon: const Icon(Icons.close),
              tooltip: strings.close,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(padding: const EdgeInsets.all(16), child: content),
        ),
      );
    }
    return AlertDialog(
      title: Text(strings.themes),
      content: content,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(strings.close),
        ),
      ],
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
