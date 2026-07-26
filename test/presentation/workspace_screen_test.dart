import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/app/last_task_app.dart';
import 'package:flutter_app/app/theme_catalog.dart';
import 'package:flutter_app/data/providers.dart';
import 'package:flutter_app/domain/models.dart';
import 'package:flutter_app/domain/repositories.dart';
import 'package:flutter_app/presentation/terminal_style.dart';
import 'package:flutter_app/presentation/workspace_view_model.dart';

void main() {
  testWidgets('workspace loads its default list and exposes pointer commands', (
    tester,
  ) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.linux;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    await tester.binding.setSurfaceSize(const Size(1000, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          deviceStateRepositoryProvider.overrideWithValue(const _DeviceState()),
          taskListRepositoryProvider.overrideWithValue(_Lists()),
          settingsRepositoryProvider.overrideWithValue(_Settings()),
        ],
        child: const LastTaskApp(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 20));

    expect(find.textContaining('LAST TASK'), findsOneWidget);
    expect(find.text('Tutorial'), findsOneWidget);
    expect(find.text(tutorialTaskTitles.first), findsOneWidget);
    final dragArea = find.byKey(const Key('desktop-window-drag-area'));
    expect(dragArea, findsOneWidget);
    expect(
      tester.getSize(dragArea).height,
      TerminalMetrics.line(tester.element(dragArea)),
    );
    expect(find.bySemanticsLabel(RegExp('new command')), findsOneWidget);
    expect(
      find.bySemanticsLabel(RegExp('new list command'), skipOffstage: false),
      findsOneWidget,
    );
    expect(find.byType(FloatingActionButton), findsNothing);
    expect(tester.takeException(), isNull);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyG);
    await tester.pumpAndSettle();
    expect(find.text('Themes'), findsNothing);
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('terminal close button turns red on hover and closes the window', (
    tester,
  ) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.linux;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    var closeCalls = 0;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('window_manager'),
      (call) async {
        if (call.method == 'close') closeCalls++;
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        const MethodChannel('window_manager'),
        null,
      ),
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          deviceStateRepositoryProvider.overrideWithValue(const _DeviceState()),
          taskListRepositoryProvider.overrideWithValue(_Lists()),
          settingsRepositoryProvider.overrideWithValue(_Settings()),
        ],
        child: const LastTaskApp(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 20));

    final button = find.byKey(const Key('workspace-close-button'));
    expect(button, findsOneWidget);
    final context = tester.element(button);
    expect(
      tester.widget<Container>(button).color,
      TerminalPalette.of(context).muted,
    );
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(button));
    await tester.pump();
    expect(
      tester.widget<Container>(button).color,
      TerminalPalette.of(context).error,
    );

    await tester.tap(button);
    await tester.pump();
    expect(closeCalls, 1);
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('terminal footer uses two right-aligned command lines', (
    tester,
  ) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.linux;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    await tester.binding.setSurfaceSize(const Size(1000, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          deviceStateRepositoryProvider.overrideWithValue(const _DeviceState()),
          taskListRepositoryProvider.overrideWithValue(_Lists()),
          settingsRepositoryProvider.overrideWithValue(const _Settings()),
        ],
        child: const LastTaskApp(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 20));

    expect(find.text('New task'), findsOneWidget);
    expect(find.text('New list'), findsOneWidget);
    expect(find.text('Move'), findsOneWidget);
    expect(find.text('Tag task'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Help'), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('New list')).dx,
      lessThan(tester.getTopLeft(find.text('New task')).dx),
    );

    final status = tester.getRect(
      find.byKey(const Key('terminal-footer-status')),
    );
    final primary = tester.getRect(
      find.byKey(const Key('terminal-footer-primary')),
    );
    final secondary = tester.getRect(
      find.byKey(const Key('terminal-footer-secondary')),
    );
    expect(status.bottom, lessThanOrEqualTo(primary.top));
    expect(primary.top, lessThan(secondary.top));
    expect(primary.right, equals(1000));
    expect(secondary.right, equals(1000));
    expect(tester.takeException(), isNull);
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets(
    'entrance tip appears near the bottom above the terminal footer',
    (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.linux;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);
      await tester.binding.setSurfaceSize(const Size(1000, 700));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            deviceStateRepositoryProvider.overrideWithValue(
              const _DeviceState(),
            ),
            taskListRepositoryProvider.overrideWithValue(_Lists()),
            settingsRepositoryProvider.overrideWithValue(
              const _Settings(AppSettings(tipsEnabled: true)),
            ),
          ],
          child: const LastTaskApp(),
        ),
      );
      await tester.pump(const Duration(milliseconds: 20));

      final tip = find.textContaining('TIP:');
      expect(tip, findsOneWidget);
      final tipBottom = tester.getBottomLeft(tip).dy;
      final lineHeight = TerminalMetrics.line(tester.element(tip));
      expect(tipBottom, greaterThan(700 / 2));
      expect(700 - tipBottom, lessThan(lineHeight * 3));
      expect(tester.takeException(), isNull);
      debugDefaultTargetPlatformOverride = null;
    },
  );

  testWidgets('pointer-down selects a terminal task before tap resolution', (
    tester,
  ) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.linux;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    final list = _listsWithManyTasks(
      TaskStatus.pending,
      multipleLists: false,
    ).first;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          deviceStateRepositoryProvider.overrideWithValue(const _DeviceState()),
          taskListRepositoryProvider.overrideWithValue(_Lists([list])),
          settingsRepositoryProvider.overrideWithValue(const _Settings()),
        ],
        child: const LastTaskApp(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 20));

    final secondTask = find.ancestor(
      of: find.text('Task 1'),
      matching: find.byWidgetPredicate(
        (widget) => widget is Semantics && widget.properties.button == true,
      ),
    );
    final gesture = await tester.startGesture(tester.getCenter(secondTask));
    await tester.pump();

    expect(tester.widget<Semantics>(secondTask).properties.selected, isTrue);
    await gesture.up();
    await tester.pump(const Duration(milliseconds: 50));
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets(
    'terminal workspace remains usable in a constrained browser size',
    (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.linux;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);
      await tester.binding.setSurfaceSize(const Size(420, 360));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            deviceStateRepositoryProvider.overrideWithValue(
              const _DeviceState(),
            ),
            taskListRepositoryProvider.overrideWithValue(_Lists()),
            settingsRepositoryProvider.overrideWithValue(_Settings()),
          ],
          child: const LastTaskApp(),
        ),
      );
      await tester.pump(const Duration(milliseconds: 20));

      expect(find.textContaining('LAST TASK'), findsOneWidget);
      await tester.dragFrom(const Offset(390, 350), const Offset(-1800, 0));
      await tester.pump();
      expect(
        find.bySemanticsLabel(RegExp('help command'), skipOffstage: false),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
      debugDefaultTargetPlatformOverride = null;
    },
  );

  testWidgets('terminal multi view uses violet list names and panel border', (
    tester,
  ) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.linux;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    await tester.binding.setSurfaceSize(const Size(420, 500));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final list = _listWithTask();
    final secondList = TaskList(
      schemaVersion: currentSchemaVersion,
      id: 'list-2',
      name: 'Work',
      createdAt: list.createdAt,
      tasks: list.tasks,
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          deviceStateRepositoryProvider.overrideWithValue(const _DeviceState()),
          taskListRepositoryProvider.overrideWithValue(
            _Lists([list, secondList]),
          ),
          settingsRepositoryProvider.overrideWithValue(const _Settings()),
        ],
        child: const LastTaskApp(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 20));

    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyA);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    await tester.pump();

    for (final name in ['TASKS', 'WORK']) {
      final label = find.text(name);
      expect(label, findsOneWidget);
      expect(tester.widget<Text>(label).style?.color, classic.accent);
    }
    final panel = tester.widget<Container>(
      find.byKey(const ValueKey('task-panel-multi')),
    );
    final decoration = panel.decoration! as BoxDecoration;
    expect(decoration.border, Border.all(color: classic.accent));
    expect(tester.takeException(), isNull);
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('terminal task-panel background is transparent over an image', (
    tester,
  ) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.linux;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          deviceStateRepositoryProvider.overrideWithValue(
            const _DeviceState(
              DeviceWorkspaceState(
                desktopAppearance: DesktopAppearance(
                  backgroundImagePath: '/background.png',
                ),
              ),
            ),
          ),
          taskListRepositoryProvider.overrideWithValue(_Lists()),
          settingsRepositoryProvider.overrideWithValue(const _Settings()),
        ],
        child: const LastTaskApp(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 20));

    final panel = tester.widget<Container>(
      find.byKey(const ValueKey('task-panel-list')),
    );
    final decoration = panel.decoration! as BoxDecoration;
    expect(
      decoration.color,
      TerminalPalette.of(
        tester.element(find.byKey(const ValueKey('task-panel-list'))),
      ).panel.withValues(alpha: 0),
    );
    expect(tester.takeException(), isNull);
    debugDefaultTargetPlatformOverride = null;
  });

  for (final scenario in [
    (name: 'list', status: TaskStatus.pending),
    (name: 'focus', status: TaskStatus.doing),
    (name: 'completed', status: TaskStatus.done),
    (name: 'multi', status: TaskStatus.pending),
  ]) {
    testWidgets(
      'keyboard selection scrolls through overflowing ${scenario.name} view',
      (tester) async {
        debugDefaultTargetPlatformOverride = TargetPlatform.linux;
        addTearDown(() => debugDefaultTargetPlatformOverride = null);
        await tester.binding.setSurfaceSize(const Size(420, 300));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              deviceStateRepositoryProvider.overrideWithValue(
                const _DeviceState(),
              ),
              taskListRepositoryProvider.overrideWithValue(
                _Lists(
                  _listsWithManyTasks(
                    scenario.status,
                    multipleLists: scenario.name == 'multi',
                  ),
                ),
              ),
              settingsRepositoryProvider.overrideWithValue(const _Settings()),
            ],
            child: const LastTaskApp(),
          ),
        );
        await tester.pump(const Duration(milliseconds: 20));

        if (scenario.name == 'focus') {
          await tester.sendKeyEvent(LogicalKeyboardKey.keyC);
        } else if (scenario.name == 'completed') {
          await tester.sendKeyEvent(LogicalKeyboardKey.keyV);
        } else if (scenario.name == 'multi') {
          await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
          await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
          await tester.sendKeyEvent(LogicalKeyboardKey.keyA);
          await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
          await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
        }
        await tester.pump();
        await tester.pump();

        expect(find.byKey(const ValueKey('task-overflow-up')), findsNothing);
        expect(
          find.byKey(const ValueKey('task-overflow-down')),
          findsOneWidget,
        );

        void expectSelectionInsideViewport() {
          final viewport = find.byKey(const ValueKey('task-list-viewport'));
          final selectedTask = find.descendant(
            of: viewport,
            matching: find.byWidgetPredicate(
              (widget) =>
                  widget is Semantics &&
                  widget.properties.button == true &&
                  widget.properties.selected == true,
            ),
          );
          expect(selectedTask, findsOneWidget);
          expect(
            tester.getTopLeft(selectedTask).dy,
            greaterThanOrEqualTo(tester.getTopLeft(viewport).dy),
          );
          expect(
            tester.getBottomLeft(selectedTask).dy,
            lessThanOrEqualTo(tester.getBottomLeft(viewport).dy),
          );
        }

        for (var index = 1; index < 19; index++) {
          await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
          await tester.pumpAndSettle();
          expectSelectionInsideViewport();
        }
        await tester.pump();

        final secondLastTitle = scenario.name == 'completed'
            ? 'Task 1'
            : 'Task 18';
        final secondLastTask = find.ancestor(
          of: find.text(secondLastTitle),
          matching: find.byWidgetPredicate(
            (widget) => widget is Semantics && widget.properties.button == true,
          ),
        );
        final downIndicator = find.byKey(const ValueKey('task-overflow-down'));
        expect(secondLastTask, findsOneWidget);
        expect(find.byKey(const ValueKey('task-overflow-up')), findsOneWidget);
        expect(downIndicator, findsOneWidget);
        expect(
          tester.getBottomLeft(secondLastTask).dy,
          lessThanOrEqualTo(tester.getTopLeft(downIndicator).dy),
        );

        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.pump();
        await tester.pump();

        final lastTitle = scenario.name == 'completed' ? 'Task 0' : 'Task 19';
        final lastTask = find.text(lastTitle);
        final panel = find.byKey(ValueKey('task-panel-${scenario.name}'));
        expect(lastTask, findsOneWidget);
        expect(
          tester.getTopLeft(lastTask).dy,
          greaterThan(tester.getTopLeft(panel).dy),
        );
        expect(
          tester.getBottomLeft(lastTask).dy,
          lessThan(tester.getBottomLeft(panel).dy),
        );
        expect(find.byKey(const ValueKey('task-overflow-up')), findsOneWidget);
        expect(find.byKey(const ValueKey('task-overflow-down')), findsNothing);

        for (var index = 1; index < 19; index++) {
          await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
          await tester.pump();
        }
        await tester.pump();

        final secondTitle = scenario.name == 'completed' ? 'Task 18' : 'Task 1';
        final secondTask = find.ancestor(
          of: find.text(secondTitle),
          matching: find.byWidgetPredicate(
            (widget) => widget is Semantics && widget.properties.button == true,
          ),
        );
        final upIndicator = find.byKey(const ValueKey('task-overflow-up'));
        expect(secondTask, findsOneWidget);
        expect(upIndicator, findsOneWidget);
        expect(
          tester.getBottomLeft(upIndicator).dy,
          lessThanOrEqualTo(tester.getTopLeft(secondTask).dy),
        );
        expect(
          find.byKey(const ValueKey('task-overflow-down')),
          findsOneWidget,
        );

        await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
        await tester.pump();
        await tester.pump();

        expect(find.byKey(const ValueKey('task-overflow-up')), findsNothing);
        expect(
          find.byKey(const ValueKey('task-overflow-down')),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
        debugDefaultTargetPlatformOverride = null;
      },
    );
  }

  testWidgets('terminal dialog titles use the workspace text height', (
    tester,
  ) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.linux;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    await tester.binding.setSurfaceSize(const Size(700, 500));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          deviceStateRepositoryProvider.overrideWithValue(const _DeviceState()),
          taskListRepositoryProvider.overrideWithValue(_Lists()),
          settingsRepositoryProvider.overrideWithValue(const _Settings()),
        ],
        child: const LastTaskApp(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 20));
    await tester.tap(find.bySemanticsLabel(RegExp('new command')));
    await tester.pumpAndSettle();

    final title = find.text('New task').last;
    expect(title, findsOneWidget);
    expect(find.text('Daily task'), findsNothing);
    final editable = tester.widget<EditableText>(find.byType(EditableText));
    final terminalBody = Theme.of(
      tester.element(find.byType(EditableText)),
    ).textTheme.bodyMedium!;
    expect(editable.style.fontSize, terminalBody.fontSize);
    expect(editable.style.height, 1);
    final floatingLabel = find.text('Task title');
    expect(floatingLabel, findsOneWidget);
    expect(
      tester.getBottomLeft(floatingLabel).dy,
      lessThanOrEqualTo(tester.getTopLeft(find.byType(EditableText)).dy),
    );
    expect(tester.takeException(), isNull);
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('terminal rows grow with the configured font size', (
    tester,
  ) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.linux;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    await tester.binding.setSurfaceSize(const Size(700, 500));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final now = DateTime.utc(2026, 1, 1);
    final task = Task(
      id: 'task-1',
      title: 'Large terminal text\non a second line',
      status: TaskStatus.pending,
      createdAt: now,
      updatedAt: now,
      completedAt: null,
      daily: false,
      completionHistory: const [],
    );
    final list = TaskList(
      schemaVersion: 1,
      id: 'list-1',
      name: 'Tasks',
      createdAt: now,
      tasks: [task],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          deviceStateRepositoryProvider.overrideWithValue(const _DeviceState()),
          taskListRepositoryProvider.overrideWithValue(_Lists([list])),
          settingsRepositoryProvider.overrideWithValue(
            _Settings(
              const AppSettings(
                nativeFontSize: 28,
                longTitleDisplay: LongTitleDisplay.wrapAll,
              ),
            ),
          ),
        ],
        child: const LastTaskApp(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 20));

    final taskRow = find.bySemanticsLabel(RegExp('Pending task'));
    final taskText = find.text('Large terminal text\non a second line');
    expect(taskRow, findsOneWidget);
    expect(taskText, findsOneWidget);
    // bodyMedium is 14 px, scaled by 28 / 16 to 24.5 px. A normalized
    // two-line terminal paragraph should therefore occupy about 49 px.
    expect(tester.getSize(taskText).height, inInclusiveRange(49, 51));
    expect(tester.takeException(), isNull);
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('marquee loops through a visible cycle marker', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.linux;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    await tester.binding.setSurfaceSize(const Size(420, 360));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final now = DateTime.utc(2026, 1, 1);
    final task = Task(
      id: 'task-1',
      title:
          'A long task title that must scroll continuously through its cycle marker before it starts again',
      status: TaskStatus.pending,
      createdAt: now,
      updatedAt: now,
      completedAt: null,
      daily: false,
      completionHistory: const [],
    );
    final list = TaskList(
      schemaVersion: currentSchemaVersion,
      id: 'list-1',
      name: 'Tasks',
      createdAt: now,
      tasks: [task],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          deviceStateRepositoryProvider.overrideWithValue(const _DeviceState()),
          taskListRepositoryProvider.overrideWithValue(_Lists([list])),
          settingsRepositoryProvider.overrideWithValue(
            const _Settings(
              AppSettings(
                longTitleDisplay: LongTitleDisplay.marquee,
                marqueeSpeedMs: minMarqueeSpeedMs,
              ),
            ),
          ),
        ],
        child: const LastTaskApp(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 20));

    final marquee = find.byKey(const ValueKey('marquee-title'));
    expect(marquee, findsOneWidget);
    final scrollView = tester.widget<SingleChildScrollView>(marquee);
    final initialOffset = scrollView.controller!.offset;
    await tester.pump(const Duration(milliseconds: 750));
    expect(scrollView.controller!.offset, initialOffset);
    await tester.pump(const Duration(milliseconds: 300));
    final movedOffset = scrollView.controller!.offset;
    expect(movedOffset, greaterThan(initialOffset));
    expect(tester.takeException(), isNull);
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('T opens the terminal theme picker and arrows cycle themes', (
    tester,
  ) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.linux;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    await tester.binding.setSurfaceSize(const Size(700, 500));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          deviceStateRepositoryProvider.overrideWithValue(const _DeviceState()),
          taskListRepositoryProvider.overrideWithValue(
            _Lists([_listWithTask()]),
          ),
          settingsRepositoryProvider.overrideWithValue(const _Settings()),
        ],
        child: const LastTaskApp(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 20));

    await tester.sendKeyEvent(LogicalKeyboardKey.keyT);
    await tester.pump();
    expect(find.text('Themes'), findsOneWidget);
    expect(find.text('Classic'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();
    expect(
      Theme.of(
        tester.element(find.text('Themes')),
      ).extension<TerminalPalette>()!.theme.id,
      'gruvbox',
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.keyW);
    await tester.pumpAndSettle();
    expect(find.text('●'), findsOneWidget);

    await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyW);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
    await tester.pumpAndSettle();
    expect(find.text('▲'), findsOneWidget);
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets(
    'completed tutorial startup reveals Themes, its award, and title star',
    (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.linux;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);
      await tester.binding.setSurfaceSize(const Size(1000, 700));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final now = DateTime.utc(2026, 1, 1);
      final tutorial = TaskList(
        schemaVersion: currentSchemaVersion,
        id: 'tutorial',
        name: 'Tutorial',
        createdAt: now,
        isTutorial: true,
        tasks: [
          for (var index = 0; index < tutorialTaskIds.length; index++)
            Task(
              id: tutorialTaskIds[index],
              title: tutorialTaskTitles[index],
              status: TaskStatus.done,
              createdAt: now,
              updatedAt: now,
              completedAt: now,
              daily: false,
              completionHistory: const [],
            ),
        ],
      );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            deviceStateRepositoryProvider.overrideWithValue(
              const _DeviceState(),
            ),
            taskListRepositoryProvider.overrideWithValue(_Lists([tutorial])),
            settingsRepositoryProvider.overrideWithValue(const _Settings()),
          ],
          child: const LastTaskApp(),
        ),
      );
      await tester.pump(const Duration(milliseconds: 20));

      expect(
        find.textContaining('Congratulations, Themes have been unlocked'),
        findsOneWidget,
      );
      expect(find.text('< Great >'), findsOneWidget);
      expect(find.textContaining('✪'), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));
      expect(find.text('< Great >'), findsOneWidget);

      await tester.tap(find.text('< Great >'));
      await tester.pump();
      expect(find.text('< Great >'), findsNothing);

      await tester.sendKeyEvent(LogicalKeyboardKey.keyG);
      await tester.pumpAndSettle();
      expect(find.text('Themes'), findsOneWidget);
      expect(tester.takeException(), isNull);
      debugDefaultTargetPlatformOverride = null;
    },
  );

  testWidgets('terminal nested rows indent and H persists collapsed children', (
    tester,
  ) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.linux;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    final now = DateTime.utc(2026, 1, 1);
    final root = Task(
      id: 'root',
      title: 'Root',
      status: TaskStatus.pending,
      createdAt: now,
      updatedAt: now,
      completedAt: null,
      daily: false,
      completionHistory: const [],
    );
    final child = Task(
      id: 'child',
      title: 'Child',
      status: TaskStatus.pending,
      createdAt: root.createdAt,
      updatedAt: root.updatedAt,
      completedAt: null,
      daily: false,
      completionHistory: const [],
      parentId: 'root',
    );
    final repository = _Lists([
      TaskList(
        schemaVersion: currentSchemaVersion,
        id: 'list',
        name: 'Tasks',
        createdAt: root.createdAt,
        tasks: [root, child],
      ),
    ]);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          deviceStateRepositoryProvider.overrideWithValue(const _DeviceState()),
          taskListRepositoryProvider.overrideWithValue(repository),
          settingsRepositoryProvider.overrideWithValue(const _Settings()),
        ],
        child: const LastTaskApp(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 20));

    expect(
      tester.getTopLeft(find.text('Child')).dx,
      greaterThan(tester.getTopLeft(find.text('Root')).dx),
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.keyH);
    await tester.pumpAndSettle();
    expect(find.text('Child'), findsNothing);
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('selected terminal tags fill the wrapped task row', (
    tester,
  ) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.linux;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    await tester.binding.setSurfaceSize(const Size(700, 500));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final taggedTask = _listWithTask(
      tags: const [TaskTag.heart],
    ).tasks.single.copyWith(title: 'A selected task\nwith a second line');
    final list = _listWithTask(
      tags: const [TaskTag.heart],
    ).copyWith(tasks: [taggedTask]);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          deviceStateRepositoryProvider.overrideWithValue(const _DeviceState()),
          taskListRepositoryProvider.overrideWithValue(_Lists([list])),
          settingsRepositoryProvider.overrideWithValue(
            _Settings(
              const AppSettings(
                nativeFontSize: 28,
                longTitleDisplay: LongTitleDisplay.wrapAll,
              ),
            ),
          ),
        ],
        child: const LastTaskApp(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 20));

    final tags = find.byKey(const ValueKey('task-tags-task-1'));
    final tagBackground = find.descendant(
      of: tags,
      matching: find.byType(ColoredBox),
    );
    expect(tester.widget<ColoredBox>(tagBackground).color, classic.accent);
    expect(
      tester.widget<Text>(find.text('▲')).style?.color,
      classic.background,
    );
    expect(tester.takeException(), isNull);
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('Android swipes cycle first and second tags without dismissal', (
    tester,
  ) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    await tester.binding.setSurfaceSize(const Size(900, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          deviceStateRepositoryProvider.overrideWithValue(const _DeviceState()),
          taskListRepositoryProvider.overrideWithValue(
            _Lists([_listWithTask()]),
          ),
          settingsRepositoryProvider.overrideWithValue(const _Settings()),
        ],
        child: const LastTaskApp(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 20));

    final task = find.bySemanticsLabel(RegExp('Pending task: Swipe me'));
    await tester.drag(task, const Offset(-100, 0));
    await tester.pumpAndSettle();
    expect(task, findsOneWidget);
    expect(find.text('●'), findsOneWidget);

    await tester.drag(task, const Offset(100, 0));
    await tester.pumpAndSettle();
    expect(task, findsOneWidget);
    expect(find.text('▲'), findsOneWidget);
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('terminal search navigates matches and Enter keeps selection', (
    tester,
  ) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.linux;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    final now = DateTime.utc(2026, 1, 1);
    Task task(
      String id,
      String title, {
      TaskStatus status = TaskStatus.pending,
    }) => Task(
      id: id,
      title: title,
      status: status,
      createdAt: now,
      updatedAt: now,
      completedAt: status == TaskStatus.done ? now : null,
      daily: false,
      completionHistory: const [],
    );
    final list = TaskList(
      schemaVersion: currentSchemaVersion,
      id: 'search-list',
      name: 'Search',
      createdAt: now,
      tasks: [task('alpha', 'Needle alpha'), task('beta', 'Needle beta')],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          deviceStateRepositoryProvider.overrideWithValue(const _DeviceState()),
          taskListRepositoryProvider.overrideWithValue(_Lists([list])),
          settingsRepositoryProvider.overrideWithValue(const _Settings()),
        ],
        child: const LastTaskApp(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 20));

    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyF);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    await tester.pump();
    final field = find.byKey(const ValueKey('workspace-search-field'));
    expect(field, findsOneWidget);
    expect(tester.testTextInput.hasAnyClients, isTrue);
    final searchLine = find.byKey(const ValueKey('workspace-search-line'));
    final fieldDecoration = tester.widget<TextField>(field).decoration!;
    expect(fieldDecoration.border, InputBorder.none);
    expect(fieldDecoration.enabledBorder, InputBorder.none);
    expect(fieldDecoration.focusedBorder, InputBorder.none);
    expect(
      tester.getSize(searchLine).height,
      lessThanOrEqualTo(TerminalMetrics.line(tester.element(searchLine))),
    );
    expect(find.textContaining('Pending (2)'), findsOneWidget);
    expect(find.text('Needle alpha'), findsOneWidget);
    expect(find.text('Needle beta'), findsOneWidget);
    await tester.enterText(field, 'needle');
    await tester.pump();
    expect(find.text('1/2 '), findsOneWidget);

    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pump();
    expect(find.text('2/2 '), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();

    expect(field, findsNothing);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Semantics &&
            widget.properties.selected == true &&
            widget.properties.label?.contains('Needle beta') == true,
      ),
      findsOneWidget,
    );
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('search scrolls a distant wrapped match fully into view', (
    tester,
  ) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.linux;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    await tester.binding.setSurfaceSize(const Size(420, 300));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final now = DateTime.utc(2026, 1, 1);
    Task task(int index, String title) => Task(
      id: 'task-$index',
      title: title,
      status: TaskStatus.pending,
      createdAt: now,
      updatedAt: now,
      completedAt: null,
      daily: false,
      completionHistory: const [],
    );
    const lastTitle =
        'Needle last has enough words to wrap across multiple terminal lines';
    final list = TaskList(
      schemaVersion: currentSchemaVersion,
      id: 'search-list',
      name: 'Search',
      createdAt: now,
      tasks: [
        task(0, 'Needle first'),
        for (var index = 1; index < 15; index++)
          task(index, 'Ordinary task $index'),
        task(15, lastTitle),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          deviceStateRepositoryProvider.overrideWithValue(const _DeviceState()),
          taskListRepositoryProvider.overrideWithValue(_Lists([list])),
          settingsRepositoryProvider.overrideWithValue(const _Settings()),
        ],
        child: const LastTaskApp(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 20));

    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyF);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    await tester.pump();
    await tester.enterText(
      find.byKey(const ValueKey('workspace-search-field')),
      'needle',
    );
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pump();
    await tester.pump();

    final viewport = find.byKey(const ValueKey('task-list-viewport'));
    final selectedTask = find.descendant(
      of: viewport,
      matching: find.byWidgetPredicate(
        (widget) =>
            widget is Semantics &&
            widget.properties.button == true &&
            widget.properties.selected == true,
      ),
    );
    expect(selectedTask, findsOneWidget);
    expect(
      tester.getTopLeft(selectedTask).dy,
      greaterThanOrEqualTo(tester.getTopLeft(viewport).dy),
    );
    expect(
      tester.getBottomLeft(selectedTask).dy,
      lessThanOrEqualTo(tester.getBottomLeft(viewport).dy + .1),
    );
    expect(find.text(lastTitle, findRichText: true), findsOneWidget);
    expect(tester.takeException(), isNull);
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets(
    'multi-search scrolls a selected match in another list into view',
    (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.linux;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);
      await tester.binding.setSurfaceSize(const Size(420, 300));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final now = DateTime.utc(2026, 1, 1);
      Task task(
        String id,
        String title, {
        TaskStatus status = TaskStatus.pending,
      }) => Task(
        id: id,
        title: title,
        status: status,
        createdAt: now,
        updatedAt: now,
        completedAt: status == TaskStatus.done ? now : null,
        daily: false,
        completionHistory: const [],
      );
      TaskList list(String id, String name, List<Task> tasks) => TaskList(
        schemaVersion: currentSchemaVersion,
        id: id,
        name: name,
        createdAt: now,
        tasks: tasks,
      );
      const lastTitle =
          'Needle in the second list has enough words to wrap across lines';
      final lists = [
        list('first', 'First', [
          task('first-match', 'Needle in the first list'),
          for (var index = 0; index < 12; index++)
            task('first-$index', 'First task $index'),
        ]),
        list('second', 'Second', [
          for (var index = 0; index < 12; index++)
            task('second-$index', 'Second task $index'),
          task('second-match', lastTitle, status: TaskStatus.done),
        ]),
      ];
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            deviceStateRepositoryProvider.overrideWithValue(
              const _DeviceState(),
            ),
            taskListRepositoryProvider.overrideWithValue(_Lists(lists)),
            settingsRepositoryProvider.overrideWithValue(const _Settings()),
          ],
          child: const LastTaskApp(),
        ),
      );
      await tester.pump(const Duration(milliseconds: 20));

      await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
      await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.keyA);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
      await tester.pump();
      await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.keyF);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
      await tester.pump();
      await tester.enterText(
        find.byKey(const ValueKey('workspace-search-field')),
        'needle',
      );
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      await tester.pump();

      final viewport = find.byKey(const ValueKey('task-list-viewport'));
      final selectedTask = find.descendant(
        of: viewport,
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.button == true &&
              widget.properties.selected == true,
        ),
      );
      expect(selectedTask, findsOneWidget);
      expect(
        tester.getTopLeft(selectedTask).dy,
        greaterThanOrEqualTo(tester.getTopLeft(viewport).dy),
      );
      expect(
        tester.getBottomLeft(selectedTask).dy,
        lessThanOrEqualTo(tester.getBottomLeft(viewport).dy + .1),
      );
      expect(find.text(lastTitle, findRichText: true), findsOneWidget);
      expect(tester.takeException(), isNull);
      debugDefaultTargetPlatformOverride = null;
    },
  );

  testWidgets('workspace shortcuts stay inactive while typing a search', (
    tester,
  ) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.linux;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    var popCalls = 0;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'SystemNavigator.pop') popCalls++;
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          deviceStateRepositoryProvider.overrideWithValue(const _DeviceState()),
          taskListRepositoryProvider.overrideWithValue(
            _Lists([_listWithTask()]),
          ),
          settingsRepositoryProvider.overrideWithValue(const _Settings()),
        ],
        child: const LastTaskApp(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 20));

    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyF);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    await tester.pump();
    for (final key in [
      LogicalKeyboardKey.keyQ,
      LogicalKeyboardKey.keyA,
      LogicalKeyboardKey.keyN,
      LogicalKeyboardKey.keyE,
    ]) {
      await tester.sendKeyEvent(key);
      await tester.pump();
    }

    final field = find.byKey(const ValueKey('workspace-search-field'));
    expect(field, findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
    expect(popCalls, 0);
    await tester.enterText(field, 'qane');
    await tester.pump();
    expect(find.text('qane'), findsOneWidget);
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('search temporarily reveals only a matching collapsed branch', (
    tester,
  ) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.linux;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    await tester.binding.setSurfaceSize(const Size(700, 500));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final now = DateTime.utc(2026, 1, 1);
    Task task(String id, String title, {String? parentId}) => Task(
      id: id,
      title: title,
      status: TaskStatus.pending,
      createdAt: now,
      updatedAt: now,
      completedAt: null,
      daily: false,
      completionHistory: const [],
      parentId: parentId,
    );
    final list = TaskList(
      schemaVersion: currentSchemaVersion,
      id: 'search-list',
      name: 'Search',
      createdAt: now,
      tasks: [
        task('root', 'Root').copyWith(collapsed: true),
        task('branch', 'Matching branch', parentId: 'root'),
        task('match', 'Hidden Needle', parentId: 'branch'),
        task('unrelated', 'Unrelated', parentId: 'root'),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          deviceStateRepositoryProvider.overrideWithValue(const _DeviceState()),
          taskListRepositoryProvider.overrideWithValue(_Lists([list])),
          settingsRepositoryProvider.overrideWithValue(const _Settings()),
        ],
        child: const LastTaskApp(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 20));

    expect(find.text('Root'), findsOneWidget);
    expect(find.text('Matching branch'), findsNothing);
    expect(find.text('Hidden Needle'), findsNothing);
    expect(find.text('Unrelated'), findsNothing);

    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyF);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    await tester.pump();
    await tester.enterText(
      find.byKey(const ValueKey('workspace-search-field')),
      'needle',
    );
    await tester.pump();

    expect(find.text('Root'), findsOneWidget);
    expect(find.text('Matching branch'), findsOneWidget);
    expect(find.text('Hidden Needle', findRichText: true), findsOneWidget);
    expect(find.text('Unrelated'), findsNothing);

    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(find.text('Matching branch'), findsNothing);
    expect(find.text('Hidden Needle'), findsNothing);
    expect(find.text('Unrelated'), findsNothing);
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('inline search fits terminal mode at maximum font size', (
    tester,
  ) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.linux;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    await tester.binding.setSurfaceSize(const Size(700, 500));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          deviceStateRepositoryProvider.overrideWithValue(const _DeviceState()),
          taskListRepositoryProvider.overrideWithValue(
            _Lists([_listWithTask()]),
          ),
          settingsRepositoryProvider.overrideWithValue(
            const _Settings(AppSettings(nativeFontSize: 28)),
          ),
        ],
        child: const LastTaskApp(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 20));

    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyF);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    await tester.pump();

    expect(
      find.byKey(const ValueKey('workspace-search-field')),
      findsOneWidget,
    );
    expect(find.text('Swipe me'), findsOneWidget);
    expect(tester.takeException(), isNull);
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('inline search fits a constrained terminal window', (
    tester,
  ) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.linux;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    await tester.binding.setSurfaceSize(const Size(420, 300));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          deviceStateRepositoryProvider.overrideWithValue(const _DeviceState()),
          taskListRepositoryProvider.overrideWithValue(
            _Lists([_listWithTask()]),
          ),
          settingsRepositoryProvider.overrideWithValue(const _Settings()),
        ],
        child: const LastTaskApp(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 20));

    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyF);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    await tester.pump();

    expect(
      find.byKey(const ValueKey('workspace-search-field')),
      findsOneWidget,
    );
    expect(find.text('Swipe me'), findsOneWidget);
    expect(tester.takeException(), isNull);
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('Android hardware search keeps the task list visible', (
    tester,
  ) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          deviceStateRepositoryProvider.overrideWithValue(const _DeviceState()),
          taskListRepositoryProvider.overrideWithValue(
            _Lists([_listWithTask()]),
          ),
          settingsRepositoryProvider.overrideWithValue(const _Settings()),
        ],
        child: const LastTaskApp(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 20));

    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyF);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    await tester.pump();

    expect(
      find.byKey(const ValueKey('workspace-search-field')),
      findsOneWidget,
    );
    expect(find.text('Swipe me'), findsOneWidget);
    expect(tester.takeException(), isNull);
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('terminal copy shortcuts use title and indented section text', (
    tester,
  ) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.linux;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    String? clipboardText;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          clipboardText =
              (call.arguments as Map<Object?, Object?>)['text'] as String?;
        }
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          deviceStateRepositoryProvider.overrideWithValue(const _DeviceState()),
          taskListRepositoryProvider.overrideWithValue(
            _Lists([
              _listWithTask(tags: const [TaskTag.heart]),
            ]),
          ),
          settingsRepositoryProvider.overrideWithValue(const _Settings()),
        ],
        child: const LastTaskApp(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 20));

    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyC);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    await tester.pump();
    expect(clipboardText, 'Swipe me');
    expect(find.textContaining('Task was copied'), findsOneWidget);

    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyC);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    await tester.pump();
    expect(clipboardText, 'Swipe me ▲');
    expect(find.textContaining('Selection was copied'), findsOneWidget);

    await tester.tap(find.text('Swipe me'));
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tap(find.text('Swipe me'));
    await tester.pump(const Duration(milliseconds: 50));
    expect(clipboardText, 'Swipe me');
    expect(find.textContaining('Task was copied'), findsOneWidget);
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('settings use two table tabs without tag configuration', (
    tester,
  ) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.linux;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    await tester.binding.setSurfaceSize(const Size(900, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          deviceStateRepositoryProvider.overrideWithValue(
            const _DeviceState(
              DeviceWorkspaceState(
                desktopAppearance: DesktopAppearance(
                  backgroundImagePath: '/pictures/kanban/background.png',
                  backgroundOverlayOpacity: .4,
                  backgroundFit: DesktopBackgroundFit.contain,
                ),
              ),
            ),
          ),
          taskListRepositoryProvider.overrideWithValue(_Lists()),
          settingsRepositoryProvider.overrideWithValue(
            const _Settings(AppSettings()),
          ),
        ],
        child: const LastTaskApp(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 20));

    expect(tester.takeException(), isNull);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyG);
    await tester.pumpAndSettle();

    expect(find.text('Config'), findsOneWidget);
    expect(find.text('Background'), findsOneWidget);
    expect(find.text('Long-title mode'), findsOneWidget);
    expect(find.text('Marquee speed'), findsOneWidget);
    expect(find.text('< Wrap selected >'), findsOneWidget);
    expect(find.text('< Normal >'), findsOneWidget);
    expect(find.text('23pt'), findsOneWidget);
    expect(find.text('Tag names'), findsNothing);
    expect(find.byKey(const ValueKey('tag-name-heart')), findsNothing);

    await tester.tap(find.text('< Wrap selected >'));
    await tester.pump();
    expect(find.text('< Wrap all >'), findsOneWidget);

    await tester.tap(find.text('< Wrap all >'));
    await tester.pump();
    expect(find.text('< Marquee >'), findsOneWidget);

    await tester.tap(find.text('< Normal >'));
    await tester.pump();
    expect(find.text('< Fast >'), findsOneWidget);

    await tester.tap(find.text('< Marquee >'));
    await tester.pump();
    expect(find.text('< Wrap selected >'), findsOneWidget);
    final disabledSpeed = tester.widget<InkWell>(
      find.ancestor(of: find.text('< Fast >'), matching: find.byType(InkWell)),
    );
    expect(disabledSpeed.onTap, isNull);

    await tester.tap(find.text('[+]'));
    await tester.pump();
    expect(find.text('24pt'), findsOneWidget);

    await tester.tap(find.text('Background'));
    await tester.pump();
    expect(find.text('background.png'), findsOneWidget);
    expect(find.text('/pictures/kanban/background.png'), findsNothing);
    expect(find.text('< Contain >'), findsOneWidget);
    expect(find.text('Background transparency'), findsOneWidget);
    expect(find.text('60%'), findsOneWidget);

    await tester.tap(find.text('[+]'));
    await tester.pump();
    expect(find.text('70%'), findsOneWidget);
    expect(tester.takeException(), isNull);
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('configured tag names still update task semantics', (
    tester,
  ) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.linux;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          deviceStateRepositoryProvider.overrideWithValue(const _DeviceState()),
          taskListRepositoryProvider.overrideWithValue(
            _Lists([
              _listWithTask(tags: const [TaskTag.heart]),
            ]),
          ),
          settingsRepositoryProvider.overrideWithValue(
            const _Settings(AppSettings(tagNames: TagNames(heart: 'Urgent'))),
          ),
        ],
        child: const LastTaskApp(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 20));

    expect(find.bySemanticsLabel(RegExp('tags: Urgent')), findsOneWidget);
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('Android settings keep touch controls for shared config', (
    tester,
  ) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    await tester.binding.setSurfaceSize(const Size(700, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          deviceStateRepositoryProvider.overrideWithValue(const _DeviceState()),
          taskListRepositoryProvider.overrideWithValue(_Lists()),
          settingsRepositoryProvider.overrideWithValue(const _Settings()),
        ],
        child: const LastTaskApp(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 20));

    expect(tester.takeException(), isNull);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyG);
    await tester.pumpAndSettle();

    expect(find.text('Long-title mode'), findsOneWidget);
    expect(find.text('Marquee speed'), findsOneWidget);
    expect(find.byType(Switch), findsOneWidget);
    expect(find.text('Desktop font size'), findsNothing);
    expect(find.text('Background'), findsNothing);
    expect(find.text('Tag names'), findsNothing);
    expect(tester.takeException(), isNull);
    debugDefaultTargetPlatformOverride = null;
  });
  testWidgets('terminal tab selection reveals the selected tab and next tab', (
    tester,
  ) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.linux;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    await tester.binding.setSurfaceSize(const Size(420, 500));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(_workspaceWithLists(_tabLists()));
    await tester.pump(const Duration(milliseconds: 20));

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();

    _expectTextFullyVisible(tester, 'Tab three');
    _expectTextFullyVisible(tester, 'Tab four');
    expect(tester.takeException(), isNull);
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('terminal left tab selection reveals the preceding tab', (
    tester,
  ) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.linux;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    await tester.binding.setSurfaceSize(const Size(420, 500));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(_workspaceWithLists(_tabLists()));
    await tester.pump(const Duration(milliseconds: 20));

    for (var index = 0; index < 4; index++) {
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pumpAndSettle();
    }
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.pumpAndSettle();

    _expectTextFullyVisible(tester, 'Tab three');
    _expectTextFullyVisible(tester, 'Tab four');
    expect(tester.takeException(), isNull);
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets(
    'terminal pointer tab selection follows the same visibility rule',
    (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.linux;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);
      await tester.binding.setSurfaceSize(const Size(420, 500));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(_workspaceWithLists(_tabLists()));
      await tester.pump(const Duration(milliseconds: 20));

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pumpAndSettle();
      final targetRect = tester.getRect(find.text('Tab four'));
      await tester.tapAt(Offset(419, targetRect.center.dy));
      await tester.pumpAndSettle();

      _expectTextFullyVisible(tester, 'Tab four');
      _expectTextFullyVisible(tester, 'Tab five');
      expect(tester.takeException(), isNull);
      debugDefaultTargetPlatformOverride = null;
    },
  );

  testWidgets('Android tab selection reveals the selected tab and next tab', (
    tester,
  ) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    await tester.binding.setSurfaceSize(const Size(700, 500));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(_workspaceWithLists(_wideTabLists()));
    await tester.pump(const Duration(milliseconds: 20));

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();

    _expectTextFullyVisible(tester, 'Tab number three', width: 700);
    _expectTextFullyVisible(tester, 'Tab number four', width: 700);
    expect(tester.takeException(), isNull);
    debugDefaultTargetPlatformOverride = null;
  });
}

Widget _workspaceWithLists(List<TaskList> lists) => ProviderScope(
  overrides: [
    deviceStateRepositoryProvider.overrideWithValue(const _DeviceState()),
    taskListRepositoryProvider.overrideWithValue(_Lists(lists)),
    settingsRepositoryProvider.overrideWithValue(const _Settings()),
  ],
  child: const LastTaskApp(),
);

void _expectTextFullyVisible(
  WidgetTester tester,
  String text, {
  double width = 420,
}) {
  final rect = tester.getRect(find.text(text));
  expect(rect.left, greaterThanOrEqualTo(0));
  expect(rect.right, lessThanOrEqualTo(width));
}

List<TaskList> _tabLists() {
  final now = DateTime.utc(2026, 1, 1);
  const names = ['Tab one', 'Tab two', 'Tab three', 'Tab four', 'Tab five'];
  return [
    for (var index = 0; index < names.length; index++)
      TaskList(
        schemaVersion: currentSchemaVersion,
        id: 'tab-$index',
        name: names[index],
        createdAt: now,
        tasks: const [],
      ),
  ];
}

List<TaskList> _wideTabLists() {
  final now = DateTime.utc(2026, 1, 1);
  const names = [
    'Tab number one',
    'Tab number two',
    'Tab number three',
    'Tab number four',
    'Tab number five',
  ];
  return [
    for (var index = 0; index < names.length; index++)
      TaskList(
        schemaVersion: currentSchemaVersion,
        id: 'wide-tab-$index',
        name: names[index],
        createdAt: now,
        tasks: const [],
      ),
  ];
}

TaskList _listWithTask({List<TaskTag> tags = const []}) {
  final now = DateTime.utc(2026, 1, 1);
  return TaskList(
    schemaVersion: currentSchemaVersion,
    id: 'list-1',
    name: 'Tasks',
    createdAt: now,
    tasks: [
      Task(
        id: 'task-1',
        title: 'Swipe me',
        status: TaskStatus.pending,
        createdAt: now,
        updatedAt: now,
        completedAt: null,
        daily: false,
        completionHistory: const [],
        tags: tags,
      ),
    ],
  );
}

List<TaskList> _listsWithManyTasks(
  TaskStatus status, {
  required bool multipleLists,
}) {
  final now = DateTime.utc(2026, 1, 1);
  Task task(int index) => Task(
    id: 'task-$index',
    title: 'Task $index',
    status: status,
    createdAt: now,
    updatedAt: now,
    completedAt: status == TaskStatus.done
        ? now.add(Duration(minutes: index))
        : null,
    daily: false,
    completionHistory: const [],
  );
  TaskList list(String id, String name, Iterable<int> indexes) => TaskList(
    schemaVersion: currentSchemaVersion,
    id: id,
    name: name,
    createdAt: now,
    tasks: indexes.map(task).toList(),
  );

  if (multipleLists) {
    return [
      list('list-1', 'Tasks', Iterable<int>.generate(10)),
      list('list-2', 'Work', Iterable<int>.generate(10, (index) => index + 10)),
    ];
  }
  return [list('list-1', 'Tasks', Iterable<int>.generate(20))];
}

class _Lists implements TaskListRepository {
  _Lists([List<TaskList> lists = const []]) : _lists = List.of(lists);
  final List<TaskList> _lists;

  @override
  Future<void> commit(TaskListChangeSet changes) async {
    for (final list in changes.upserts) {
      await save(list);
    }
    for (final id in changes.deletes) {
      await delete(id);
    }
  }

  @override
  Future<void> delete(String listId) async {
    _lists.removeWhere((list) => list.id == listId);
  }

  @override
  Future<TaskListLoadResult> loadAll() async =>
      TaskListLoadResult(lists: List.of(_lists), warnings: const []);

  @override
  Future<void> save(TaskList list) async {
    _lists.removeWhere((candidate) => candidate.id == list.id);
    _lists.add(list);
  }
}

class _Settings implements SettingsRepository {
  const _Settings([this.settings = const AppSettings(nativeFontSize: 16)]);
  final AppSettings settings;

  @override
  Future<AppSettings> load() async => settings;

  @override
  Future<void> save(AppSettings settings) async {}
}

class _DeviceState implements DeviceStateRepository {
  const _DeviceState([this.state = const DeviceWorkspaceState()]);

  final DeviceWorkspaceState state;

  @override
  Future<DeviceWorkspaceState> load() async => state;

  @override
  Future<void> save(DeviceWorkspaceState state) async {}
}
