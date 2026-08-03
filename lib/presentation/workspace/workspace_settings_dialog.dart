import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;

import '../../app/desktop_background.dart';
import '../../app/theme_catalog.dart';
import '../../app/ui_mode.dart';
import '../../domain/models.dart';
import '../../l10n/app_localizations.dart';
import '../terminal_style.dart';
import '../workspace_view_model.dart';
import '../auth_view_model.dart';
import 'workspace_dialog_tabs.dart';
import 'workspace_theme_preview.dart';

EdgeInsetsGeometry? get _dialogTitlePadding =>
    usesTerminalPresentation ? const EdgeInsets.fromLTRB(10, 8, 10, 0) : null;

EdgeInsetsGeometry? get _dialogContentPadding =>
    usesTerminalPresentation ? const EdgeInsets.fromLTRB(10, 8, 10, 8) : null;

class WorkspaceSettingsDialog extends ConsumerStatefulWidget {
  const WorkspaceSettingsDialog({
    super.key,
    this.initialTab = SettingsTab.config,
  });

  final SettingsTab initialTab;

  @override
  ConsumerState<WorkspaceSettingsDialog> createState() =>
      _WorkspaceSettingsDialogState();
}

enum SettingsTab { config, background, themes }

class _WorkspaceSettingsDialogState
    extends ConsumerState<WorkspaceSettingsDialog> {
  late var _selectedTab = widget.initialTab;

  Future<void> _exportData() async {
    final vm = ref.read(workspaceViewModelProvider.notifier);
    try {
      final result = await FilePicker.platform.saveFile(
        dialogTitle: 'Export Last Task data',
        fileName: 'last-task-export.json',
        type: FileType.custom,
        allowedExtensions: const ['json'],
        bytes: Uint8List.fromList(utf8.encode(vm.exportDataJson())),
      );
      if (result != null) vm.showNotice('Data exported');
    } on Object catch (error) {
      vm.showNotice('Export failed: $error');
    }
  }

  Future<void> _importData() async {
    final vm = ref.read(workspaceViewModelProvider.notifier);
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['json'],
        withData: true,
      );
      if (result == null) return;
      final bytes = result.files.single.bytes;
      if (bytes == null) {
        vm.showNotice(
          'Could not read the selected file',
          usesDoingColor: false,
        );
        return;
      }
      await vm.importDataJson(utf8.decode(bytes));
    } on Object catch (error) {
      vm.showNotice('Import failed: $error');
    }
  }

  Future<void> _pickBackground() async {
    final selectedPath = await ref
        .read(desktopBackgroundServiceProvider)
        .pickImagePath();
    if (selectedPath == null) return;
    final appearance = ref
        .read(workspaceViewModelProvider)
        .deviceState
        .desktopAppearance;
    await ref
        .read(workspaceViewModelProvider.notifier)
        .updateDesktopAppearance(
          appearance.copyWith(backgroundImagePath: selectedPath),
        );
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final state = ref.watch(workspaceViewModelProvider);
    final settings = state.settings;
    final vm = ref.read(workspaceViewModelProvider.notifier);
    Future<void> logOut() async {
      Navigator.pop(context);
      await ref.read(authViewModelProvider.notifier).logOut();
    }

    final tabs = [
      SettingsTab.config,
      if (supportsDesktopBackground) SettingsTab.background,
      if (usesTerminalPresentation && state.deviceState.themesUnlocked)
        SettingsTab.themes,
    ];
    final selectedTab = tabs.contains(_selectedTab)
        ? _selectedTab
        : SettingsTab.config;

    return AlertDialog(
      titlePadding: _dialogTitlePadding,
      contentPadding: _dialogContentPadding,
      title: Text(strings.settings),
      content: SizedBox(
        width: 680,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (tabs.length > 1)
                WorkspaceDialogTabs(
                  labels: [
                    for (final tab in tabs)
                      switch (tab) {
                        SettingsTab.config => strings.configTab,
                        SettingsTab.background => strings.backgroundTab,
                        SettingsTab.themes => strings.themes,
                      },
                  ],
                  selectedIndex: tabs.indexOf(selectedTab),
                  onSelected: (index) =>
                      setState(() => _selectedTab = tabs[index]),
                ),
              SizedBox(height: TerminalMetrics.line(context) * .35),
              IndexedStack(
                index: tabs.indexOf(selectedTab),
                children: [
                  for (final tab in tabs)
                    switch (tab) {
                      SettingsTab.config => _ConfigSettings(
                        settings: settings,
                        onUpdate: vm.updateSettings,
                        onLogOut: logOut,
                        onExportData: _exportData,
                        onImportData: _importData,
                      ),
                      SettingsTab.background => _BackgroundSettings(
                        appearance: state.deviceState.desktopAppearance,
                        onPickImage: _pickBackground,
                        onUpdate: vm.updateDesktopAppearance,
                      ),
                      SettingsTab.themes => _ThemeSettings(
                        themeId: settings.themeId,
                        onSelect: (id) =>
                            vm.updateSettings(settings.copyWith(themeId: id)),
                      ),
                    },
                ],
              ),
            ],
          ),
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

class _ConfigSettings extends StatelessWidget {
  const _ConfigSettings({
    required this.settings,
    required this.onUpdate,
    required this.onLogOut,
    required this.onExportData,
    required this.onImportData,
  });

  final AppSettings settings;
  final ValueChanged<AppSettings> onUpdate;
  final Future<void> Function() onLogOut;
  final Future<void> Function() onExportData;
  final Future<void> Function() onImportData;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final marqueePreset = _MarqueePreset.nearest(settings.marqueeSpeedMs);
    if (!usesTerminalPresentation) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(strings.longTitleMode),
            subtitle: Text(_longTitleLabel(strings, settings.longTitleDisplay)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => onUpdate(
              settings.copyWith(
                longTitleDisplay: settings.longTitleDisplay.next,
              ),
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            enabled: settings.longTitleDisplay == LongTitleDisplay.marquee,
            title: Text(strings.marqueeSpeedLabel),
            subtitle: Text(marqueePreset.label(strings)),
            trailing: const Icon(Icons.chevron_right),
            onTap: settings.longTitleDisplay == LongTitleDisplay.marquee
                ? () => onUpdate(
                    settings.copyWith(
                      marqueeSpeedMs: marqueePreset.next.milliseconds,
                    ),
                  )
                : null,
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(strings.rewardDuration),
            subtitle: Text(
              _rewardDurationLabel(strings, settings.rewardDuration),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => onUpdate(
              settings.copyWith(
                rewardDuration:
                    RewardDuration.values[(settings.rewardDuration.index + 1) %
                        RewardDuration.values.length],
              ),
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(strings.fontFamily),
            subtitle: Text(settings.fontFamily.label),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => onUpdate(
              settings.copyWith(fontFamily: settings.fontFamily.next),
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(strings.language),
            subtitle: Text(_languageLabel(settings.languageLocale)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => onUpdate(
              settings.copyWith(
                languageLocale: _nextLanguageLocale(settings.languageLocale),
              ),
            ),
          ),
          if (usesTerminalPresentation) ...[
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(strings.exportData),
              trailing: const Icon(Icons.download),
              onTap: onExportData,
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(strings.importData),
              trailing: const Icon(Icons.upload),
              onTap: onImportData,
            ),
          ],
          SizedBox(
            width: double.infinity,
            child: TextButton(
              key: const Key('settings-log-out-action'),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              onPressed: onLogOut,
              child: Text(strings.logOut),
            ),
          ),
        ],
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _SettingsRow(
          label: strings.longTitleMode,
          control: _CycleButton(
            value: _longTitleLabel(strings, settings.longTitleDisplay),
            onTap: () => onUpdate(
              settings.copyWith(
                longTitleDisplay: settings.longTitleDisplay.next,
              ),
            ),
          ),
        ),
        _SettingsRow(
          label: strings.marqueeSpeedLabel,
          control: _CycleButton(
            value: marqueePreset.label(strings),
            onTap: settings.longTitleDisplay == LongTitleDisplay.marquee
                ? () {
                    final next = marqueePreset.next;
                    onUpdate(
                      settings.copyWith(marqueeSpeedMs: next.milliseconds),
                    );
                  }
                : null,
          ),
        ),
        _SettingsRow(
          label: strings.showTips,
          control: _ToggleButton(
            value: settings.tipsEnabled,
            onChanged: (value) =>
                onUpdate(settings.copyWith(tipsEnabled: value)),
          ),
        ),
        _SettingsRow(
          label: strings.rewardDuration,
          control: _CycleButton(
            value: _rewardDurationLabel(strings, settings.rewardDuration),
            onTap: () => onUpdate(
              settings.copyWith(
                rewardDuration:
                    RewardDuration.values[(settings.rewardDuration.index + 1) %
                        RewardDuration.values.length],
              ),
            ),
          ),
        ),
        if (usesTerminalPresentation)
          _SettingsRow(
            label: strings.fontFamily,
            control: _CycleButton(
              value: settings.fontFamily.label,
              onTap: () => onUpdate(
                settings.copyWith(fontFamily: settings.fontFamily.next),
              ),
            ),
          ),
        if (usesTerminalPresentation)
          _SettingsRow(
            label: strings.desktopFontSizeLabel,
            control: _StepControl(
              value: '${settings.nativeFontSize}pt',
              onDecrease: settings.nativeFontSize > 10
                  ? () => onUpdate(
                      settings.copyWith(
                        nativeFontSize: settings.nativeFontSize - 1,
                      ),
                    )
                  : null,
              onIncrease: settings.nativeFontSize < 28
                  ? () => onUpdate(
                      settings.copyWith(
                        nativeFontSize: settings.nativeFontSize + 1,
                      ),
                    )
                  : null,
            ),
          ),
        _SettingsRow(
          label: strings.language,
          control: _CycleButton(
            value: _languageLabel(settings.languageLocale),
            onTap: () => onUpdate(
              settings.copyWith(
                languageLocale: _nextLanguageLocale(settings.languageLocale),
              ),
            ),
          ),
        ),
        _SettingsRow(
          label: strings.exportData,
          control: _TextAction(
            value: strings.exportData,
            onTap: onExportData,
            fillWidth: true,
          ),
        ),
        _SettingsRow(
          label: strings.importData,
          control: _TextAction(
            value: strings.importData,
            onTap: onImportData,
            fillWidth: true,
          ),
        ),
        _TextAction(
          key: const Key('settings-log-out-action'),
          value: strings.logOut,
          onTap: onLogOut,
          fillWidth: true,
          enabledColor: TerminalPalette.of(context).error,
        ),
      ],
    );
  }
}

class _ThemeSettings extends ConsumerWidget {
  const _ThemeSettings({required this.themeId, required this.onSelect});

  final String themeId;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalog = ref.watch(themeCatalogProvider);
    final selected = catalog.byId(themeId);
    return Focus(
      autofocus: true,
      onKeyEvent: (_, event) {
        if (event is! KeyDownEvent) return KeyEventResult.ignored;
        final delta = switch (event.logicalKey) {
          LogicalKeyboardKey.arrowLeft => -1,
          LogicalKeyboardKey.arrowRight => 1,
          _ => 0,
        };
        if (delta == 0) return KeyEventResult.ignored;
        final current = catalog.themes.indexWhere(
          (theme) => theme.id == selected.id,
        );
        final index = (current + delta) % catalog.themes.length;
        onSelect(catalog.themes[index].id);
        return KeyEventResult.handled;
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 7, child: WorkspaceThemePreview(theme: selected)),
          SizedBox(width: TerminalMetrics.cell(context)),
          Expanded(
            flex: 3,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final theme in catalog.themes)
                  _ThemeChoice(
                    theme: theme,
                    selected: theme.id == themeId,
                    onTap: () => onSelect(theme.id),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemeChoice extends StatelessWidget {
  const _ThemeChoice({
    required this.theme,
    required this.selected,
    required this.onTap,
  });

  final AppThemeDefinition theme;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    selected: selected,
    label: theme.name,
    child: InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(
          vertical: TerminalMetrics.line(context) * .06,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: TerminalMetrics.cell(context) * .4,
          vertical: TerminalMetrics.line(context) * .1,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: selected
                ? TerminalPalette.of(context).accent
                : TerminalPalette.of(context).muted,
          ),
        ),
        child: WorkspaceMarqueeText(
          text: theme.name,
          style: TextStyle(
            color: selected
                ? TerminalPalette.of(context).accent
                : TerminalPalette.of(context).text,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    ),
  );
}

class _BackgroundSettings extends StatelessWidget {
  const _BackgroundSettings({
    required this.appearance,
    required this.onPickImage,
    required this.onUpdate,
  });

  final DesktopAppearance appearance;
  final VoidCallback onPickImage;
  final ValueChanged<DesktopAppearance> onUpdate;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final selectedPath = appearance.backgroundImagePath;
    final transparency = ((1 - appearance.backgroundOverlayOpacity) * 100)
        .round();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _SettingsRow(
          label: selectedPath == null
              ? strings.noImageSelected
              : path.basename(selectedPath),
          onLabelTap: onPickImage,
          control: _TextAction(
            value: strings.clear,
            fillWidth: true,
            onTap: selectedPath == null
                ? null
                : () =>
                      onUpdate(appearance.copyWith(clearBackgroundImage: true)),
          ),
        ),
        _SettingsRow(
          label: strings.backgroundFit,
          control: _CycleButton(
            value: appearance.backgroundFit == DesktopBackgroundFit.cover
                ? strings.cover
                : strings.contain,
            onTap: () => onUpdate(
              appearance.copyWith(
                backgroundFit:
                    appearance.backgroundFit == DesktopBackgroundFit.cover
                    ? DesktopBackgroundFit.contain
                    : DesktopBackgroundFit.cover,
              ),
            ),
          ),
        ),
        _SettingsRow(
          label: strings.backgroundTransparency,
          control: _StepControl(
            value: '$transparency%',
            onDecrease: transparency > 0
                ? () => onUpdate(
                    appearance.copyWith(
                      backgroundOverlayOpacity:
                          (appearance.backgroundOverlayOpacity + .1)
                              .clamp(0.0, 1.0)
                              .toDouble(),
                    ),
                  )
                : null,
            onIncrease: transparency < 100
                ? () => onUpdate(
                    appearance.copyWith(
                      backgroundOverlayOpacity:
                          (appearance.backgroundOverlayOpacity - .1)
                              .clamp(0.0, 1.0)
                              .toDouble(),
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.label,
    required this.control,
    this.onLabelTap,
  });

  final String label;
  final Widget control;
  final VoidCallback? onLabelTap;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(vertical: TerminalMetrics.line(context) * .1),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 7,
          child: onLabelTap == null
              ? Text(label, maxLines: 1, overflow: TextOverflow.ellipsis)
              : Semantics(
                  button: true,
                  child: InkWell(
                    onTap: onLabelTap,
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
        ),
        Expanded(
          flex: 3,
          child: LayoutBuilder(
            builder: (context, constraints) =>
                SizedBox(width: constraints.maxWidth, child: control),
          ),
        ),
      ],
    ),
  );
}

class _CycleButton extends StatelessWidget {
  const _CycleButton({required this.value, required this.onTap});

  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) =>
      _TextAction(value: '< $value >', onTap: onTap, fillWidth: true);
}

class _ToggleButton extends StatelessWidget {
  const _ToggleButton({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    if (!usesTerminalPresentation) {
      return Switch(value: value, onChanged: onChanged);
    }
    return Semantics(
      toggled: value,
      child: _TextAction(
        value: value ? '[x]' : '[ ]',
        onTap: () => onChanged(!value),
        fillWidth: true,
      ),
    );
  }
}

class _StepControl extends StatelessWidget {
  const _StepControl({
    required this.value,
    required this.onDecrease,
    required this.onIncrease,
  });

  final String value;
  final VoidCallback? onDecrease;
  final VoidCallback? onIncrease;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: _TextAction(
            value: '[−]',
            semanticsLabel: strings.decrease,
            onTap: onDecrease,
            fillWidth: true,
          ),
        ),
        Expanded(child: Center(child: Text(value))),
        Expanded(
          child: _TextAction(
            value: '[+]',
            semanticsLabel: strings.increase,
            onTap: onIncrease,
            fillWidth: true,
          ),
        ),
      ],
    );
  }
}

class _TextAction extends StatelessWidget {
  const _TextAction({
    super.key,
    required this.value,
    required this.onTap,
    this.semanticsLabel,
    this.fillWidth = false,
    this.enabledColor,
  });

  final String value;
  final VoidCallback? onTap;
  final String? semanticsLabel;
  final bool fillWidth;
  final Color? enabledColor;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    if (!usesTerminalPresentation) {
      return TextButton(onPressed: onTap, child: Text(value));
    }
    return Semantics(
      button: true,
      enabled: enabled,
      label: semanticsLabel,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: fillWidth ? double.infinity : null,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: TerminalMetrics.line(context) * .1,
            ),
            child: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: constraints.maxWidth),
                  child: Center(
                    child: Text(
                      value,
                      style: TextStyle(
                        color: enabled
                            ? enabledColor ?? TerminalPalette.of(context).accent
                            : TerminalPalette.of(context).muted,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum _MarqueePreset {
  slow(slowMarqueeSpeedMs),
  normal(normalMarqueeSpeedMs),
  fast(fastMarqueeSpeedMs);

  const _MarqueePreset(this.milliseconds);

  final int milliseconds;

  _MarqueePreset get next => values[(index + 1) % values.length];

  String label(AppLocalizations strings) => switch (this) {
    _MarqueePreset.slow => strings.slow,
    _MarqueePreset.normal => strings.normal,
    _MarqueePreset.fast => strings.fast,
  };

  static _MarqueePreset nearest(int milliseconds) {
    var nearest = values.first;
    var distance = (milliseconds - nearest.milliseconds).abs();
    for (final preset in values.skip(1)) {
      final candidateDistance = (milliseconds - preset.milliseconds).abs();
      if (candidateDistance < distance) {
        nearest = preset;
        distance = candidateDistance;
      }
    }
    return nearest;
  }
}

String _rewardDurationLabel(
  AppLocalizations strings,
  RewardDuration duration,
) => switch (duration) {
  RewardDuration.short => strings.shortDuration,
  RewardDuration.medium => strings.mediumDuration,
  RewardDuration.long => strings.longDuration,
};

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
