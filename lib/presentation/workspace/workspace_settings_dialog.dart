import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/desktop_background.dart';
import '../../app/ui_mode.dart';
import '../../domain/models.dart';
import '../../l10n/app_localizations.dart';
import '../terminal_style.dart';
import '../workspace_view_model.dart';

EdgeInsetsGeometry? get _dialogTitlePadding =>
    usesTerminalPresentation ? const EdgeInsets.fromLTRB(10, 8, 10, 0) : null;

EdgeInsetsGeometry? get _dialogContentPadding =>
    usesTerminalPresentation ? const EdgeInsets.fromLTRB(10, 8, 10, 8) : null;

TextStyle? _dialogInputStyle(BuildContext context) =>
    usesTerminalPresentation ? Theme.of(context).textTheme.bodyMedium : null;

Color _tagColor(BuildContext context, TaskTag tag) => switch (tag) {
  TaskTag.spade => TerminalPalette.of(context).accent,
  TaskTag.heart => TerminalPalette.of(context).done,
  TaskTag.club => TerminalPalette.of(context).error,
  TaskTag.diamond => TerminalPalette.of(context).pending,
};

class WorkspaceSettingsDialog extends ConsumerStatefulWidget {
  const WorkspaceSettingsDialog({super.key});

  @override
  ConsumerState<WorkspaceSettingsDialog> createState() =>
      _WorkspaceSettingsDialogState();
}

class _WorkspaceSettingsDialogState
    extends ConsumerState<WorkspaceSettingsDialog> {
  late final Map<TaskTag, TextEditingController> _tagControllers;
  String? _tagError;

  @override
  void initState() {
    super.initState();
    final names = ref.read(workspaceViewModelProvider).settings.tagNames;
    _tagControllers = {
      for (final tag in TaskTag.values)
        tag: TextEditingController(text: names.nameFor(tag)),
    };
  }

  @override
  void dispose() {
    for (final controller in _tagControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _saveTagNames(AppSettings settings) async {
    final values = {
      for (final entry in _tagControllers.entries)
        entry.key: normalizeName(entry.value.text),
    };
    if (values.values.any((value) => value.isEmpty)) {
      setState(
        () => _tagError = AppLocalizations.of(context)!.tagNamesCannotBeEmpty,
      );
      return;
    }
    setState(() => _tagError = null);
    await ref
        .read(workspaceViewModelProvider.notifier)
        .updateSettings(
          settings.copyWith(
            tagNames: TagNames(
              spade: values[TaskTag.spade]!,
              heart: values[TaskTag.heart]!,
              club: values[TaskTag.club]!,
              diamond: values[TaskTag.diamond]!,
            ),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(workspaceViewModelProvider).settings;
    final vm = ref.read(workspaceViewModelProvider.notifier);
    return AlertDialog(
      titlePadding: _dialogTitlePadding,
      contentPadding: _dialogContentPadding,
      title: Text(AppLocalizations.of(context)!.settings),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(
                  context,
                )!.marqueeSpeed(settings.marqueeSpeedMs),
              ),
              Slider(
                value: settings.marqueeSpeedMs.toDouble(),
                min: minMarqueeSpeedMs.toDouble(),
                max: maxMarqueeSpeedMs.toDouble(),
                divisions: (maxMarqueeSpeedMs - minMarqueeSpeedMs) ~/ 25,
                onChanged: (value) => vm.updateSettings(
                  settings.copyWith(marqueeSpeedMs: (value / 25).round() * 25),
                ),
              ),
              if (usesTerminalPresentation)
                _TerminalCycleControl(
                  label: AppLocalizations.of(context)!.longTitleMode,
                  value: _longTitleLabel(
                    AppLocalizations.of(context)!,
                    settings.longTitleDisplay,
                  ),
                  onTap: () => vm.updateSettings(
                    settings.copyWith(
                      longTitleDisplay: settings.longTitleDisplay.next,
                    ),
                  ),
                )
              else
                SwitchListTile(
                  value: settings.longTitleDisplay == LongTitleDisplay.wrapAll,
                  onChanged: (value) => vm.updateSettings(
                    settings.copyWith(
                      longTitleDisplay: value
                          ? LongTitleDisplay.wrapAll
                          : LongTitleDisplay.marquee,
                    ),
                  ),
                  title: Text(AppLocalizations.of(context)!.wrapLongTitles),
                ),
              if (usesTerminalPresentation)
                _TerminalToggle(
                  value: settings.tipsEnabled,
                  onChanged: (value) =>
                      vm.updateSettings(settings.copyWith(tipsEnabled: value)),
                  label: AppLocalizations.of(context)!.showTips,
                ),
              if (usesTerminalPresentation)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(AppLocalizations.of(context)!.rewardDuration),
                  subtitle: Text(switch (settings.rewardDuration) {
                    RewardDuration.short => AppLocalizations.of(
                      context,
                    )!.shortDuration,
                    RewardDuration.medium => AppLocalizations.of(
                      context,
                    )!.mediumDuration,
                    RewardDuration.long => AppLocalizations.of(
                      context,
                    )!.longDuration,
                  }),
                  onTap: () => vm.updateSettings(
                    settings.copyWith(
                      rewardDuration:
                          RewardDuration.values[(settings.rewardDuration.index +
                                  1) %
                              RewardDuration.values.length],
                    ),
                  ),
                ),
              if (!kIsWeb && defaultTargetPlatform == TargetPlatform.linux) ...[
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(AppLocalizations.of(context)!.backgroundImage),
                  subtitle: Text(
                    ref
                            .watch(workspaceViewModelProvider)
                            .deviceState
                            .desktopAppearance
                            .backgroundImagePath ??
                        AppLocalizations.of(context)!.none,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () => showDialog<void>(
                    context: context,
                    builder: (_) => const _DesktopBackgroundDialog(),
                  ),
                ),
              ],
              Text(
                AppLocalizations.of(
                  context,
                )!.desktopFontSize(settings.nativeFontSize),
              ),
              Slider(
                value: settings.nativeFontSize.toDouble(),
                min: 10,
                max: 28,
                divisions: 18,
                onChanged: (value) => vm.updateSettings(
                  settings.copyWith(nativeFontSize: value.round()),
                ),
              ),
              if (usesTerminalPresentation)
                _TerminalLanguageControl(
                  languageLocale: settings.languageLocale,
                  onTap: () => vm.updateSettings(
                    settings.copyWith(
                      languageLocale: _nextLanguageLocale(
                        settings.languageLocale,
                      ),
                    ),
                  ),
                )
              else
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(AppLocalizations.of(context)!.language),
                  subtitle: Text(_languageLabel(settings.languageLocale)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => vm.updateSettings(
                    settings.copyWith(
                      languageLocale: _nextLanguageLocale(
                        settings.languageLocale,
                      ),
                    ),
                  ),
                ),
              const Divider(),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(AppLocalizations.of(context)!.tagNames),
              ),
              for (final tag in TaskTag.values)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Row(
                    children: [
                      SizedBox(
                        width: TerminalMetrics.cell(context) * 2,
                        child: Text(
                          tag.glyph,
                          style: TextStyle(
                            color: _tagColor(context, tag),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          key: ValueKey('tag-name-${tag.wireName}'),
                          controller: _tagControllers[tag],
                          style: _dialogInputStyle(context),
                          decoration: InputDecoration(
                            labelText: const TagNames().nameFor(tag),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (_tagError != null)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _tagError!,
                    style: TextStyle(color: TerminalPalette.of(context).error),
                  ),
                ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => _saveTagNames(settings),
                  child: Text(AppLocalizations.of(context)!.saveTagNames),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(AppLocalizations.of(context)!.close),
        ),
      ],
    );
  }
}

class _DesktopBackgroundDialog extends ConsumerWidget {
  const _DesktopBackgroundDialog();

  Future<void> _pick(WidgetRef ref) async {
    final path = await ref
        .read(desktopBackgroundServiceProvider)
        .pickImagePath();
    if (path == null) return;
    final appearance = ref
        .read(workspaceViewModelProvider)
        .deviceState
        .desktopAppearance;
    await ref
        .read(workspaceViewModelProvider.notifier)
        .updateDesktopAppearance(
          appearance.copyWith(backgroundImagePath: path),
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appearance = ref
        .watch(workspaceViewModelProvider)
        .deviceState
        .desktopAppearance;
    final vm = ref.read(workspaceViewModelProvider.notifier);
    return AlertDialog(
      titlePadding: _dialogTitlePadding,
      contentPadding: _dialogContentPadding,
      title: Text(AppLocalizations.of(context)!.backgroundImage),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                appearance.backgroundImagePath ??
                    AppLocalizations.of(context)!.noImageSelected,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () => _pick(ref),
              trailing: TextButton(
                onPressed: appearance.backgroundImagePath == null
                    ? null
                    : () => vm.updateDesktopAppearance(
                        appearance.copyWith(clearBackgroundImage: true),
                      ),
                child: Text(AppLocalizations.of(context)!.clear),
              ),
            ),
            Text(
              '${AppLocalizations.of(context)!.backgroundOpacity}: '
              '${(appearance.backgroundOverlayOpacity * 100).round()}%',
            ),
            Slider(
              value: appearance.backgroundOverlayOpacity,
              min: 0,
              max: 1,
              divisions: 20,
              onChanged: (value) => vm.updateDesktopAppearance(
                appearance.copyWith(backgroundOverlayOpacity: value),
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(AppLocalizations.of(context)!.backgroundFit),
              subtitle: Text(
                appearance.backgroundFit == DesktopBackgroundFit.cover
                    ? AppLocalizations.of(context)!.cover
                    : AppLocalizations.of(context)!.contain,
              ),
              onTap: () => vm.updateDesktopAppearance(
                appearance.copyWith(
                  backgroundFit:
                      appearance.backgroundFit == DesktopBackgroundFit.cover
                      ? DesktopBackgroundFit.contain
                      : DesktopBackgroundFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(AppLocalizations.of(context)!.close),
        ),
      ],
    );
  }
}

class _TerminalCycleControl extends StatelessWidget {
  const _TerminalCycleControl({
    required this.label,
    required this.value,
    required this.onTap,
  });
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: '$label: $value',
    child: InkWell(
      onTap: onTap,
      child: SizedBox(
        height: TerminalMetrics.line(context),
        child: Row(
          children: [
            Text(
              '< $value >',
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

class _TerminalToggle extends StatelessWidget {
  const _TerminalToggle({
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

class _TerminalLanguageControl extends StatelessWidget {
  const _TerminalLanguageControl({
    required this.languageLocale,
    required this.onTap,
  });

  final String languageLocale;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return Semantics(
      button: true,
      label: strings.languageValue(_languageLabel(languageLocale)),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 1),
          child: Text(strings.languageValue(_languageLabel(languageLocale))),
        ),
      ),
    );
  }
}

String _longTitleLabel(AppLocalizations strings, LongTitleDisplay display) =>
    switch (display) {
      LongTitleDisplay.wrapSelected => strings.wrapSelected,
      LongTitleDisplay.wrapAll => strings.wrapAll,
      LongTitleDisplay.marquee => strings.marquee,
    };

String _languageLabel(String localeName) =>
    lookupAppLocalizations(_supportedLanguageLocale(localeName)).languageName;

String _nextLanguageLocale(String currentLocale) {
  final locales = AppLocalizations.supportedLocales;
  final currentIndex = locales.indexWhere(
    (locale) => locale.toString() == currentLocale,
  );
  return locales[(currentIndex + 1) % locales.length].toString();
}

Locale _supportedLanguageLocale(String localeName) {
  for (final locale in AppLocalizations.supportedLocales) {
    if (locale.toString() == localeName) return locale;
  }
  return AppLocalizations.supportedLocales.first;
}
