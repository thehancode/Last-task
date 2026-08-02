import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/domain/models.dart';

void main() {
  test('tutorial and onboarding fields round-trip with legacy defaults', () {
    final legacyList = TaskList.fromJson({
      'schema_version': 1,
      'id': 'legacy',
      'name': 'Legacy',
      'created_at': '2026-01-01T00:00:00Z',
      'tasks': <Object?>[],
    });
    final legacyDevice = DeviceWorkspaceState.fromJson(const {});

    expect(legacyList.isTutorial, isFalse);
    expect(legacyDevice.terminalLaunchCount, 0);
    expect(legacyDevice.themesUnlocked, isFalse);
    expect(legacyDevice.tutorialAwardEarned, isFalse);

    final tutorial = legacyList.copyWith(isTutorial: true);
    final device = legacyDevice.copyWith(
      terminalLaunchCount: 2,
      themesUnlocked: true,
      tutorialAwardEarned: true,
    );

    expect(TaskList.fromJson(tutorial.toJson()).isTutorial, isTrue);
    final restoredDevice = DeviceWorkspaceState.fromJson(device.toJson());
    expect(restoredDevice.terminalLaunchCount, 2);
    expect(restoredDevice.themesUnlocked, isTrue);
    expect(restoredDevice.tutorialAwardEarned, isTrue);
  });

  test('legacy Focus device view falls back to the list view', () {
    final device = DeviceWorkspaceState.fromJson(const {'view': 'focus'});

    expect(device.view, WorkspaceView.list);
  });

  test('task tags round-trip while old tasks default to no tags', () {
    final oldTask = Task.fromJson(_taskJson());
    expect(oldTask.tags, isEmpty);

    final tagged = Task.fromJson({
      ..._taskJson(),
      'tags': ['spade', 'heart'],
    });
    expect(tagged.tags, [TaskTag.spade, TaskTag.heart]);
    expect(tagged.toJson()['tags'], ['spade', 'heart']);
  });

  test('task-list validation rejects duplicate tags', () {
    final task = Task.fromJson({
      ..._taskJson(),
      'tags': ['club', 'club'],
    });
    final list = TaskList(
      schemaVersion: currentSchemaVersion,
      id: 'list-1',
      name: 'Tasks',
      createdAt: DateTime.utc(2026),
      tasks: [task],
    );

    expect(list.validate, throwsFormatException);
  });

  test('habit-list type round-trips and enforces root daily state', () {
    final habit = TaskList.fromJson({
      'schema_version': currentSchemaVersion,
      'id': 'habit',
      'name': 'Habits',
      'created_at': '2026-01-01T00:00:00Z',
      'habit': true,
      'tasks': [
        {..._taskJson(), 'daily': true},
      ],
    });
    expect(habit.isHabit, isTrue);
    expect(habit.toJson()['habit'], isTrue);
    expect(habit.validate, returnsNormally);

    final normal = TaskList.fromJson({
      'schema_version': currentSchemaVersion,
      'id': 'normal',
      'name': 'Normal',
      'created_at': '2026-01-01T00:00:00Z',
      'tasks': [
        {..._taskJson(), 'daily': true},
      ],
    });
    expect(normal.isHabit, isFalse);
    expect(normal.validate, throwsFormatException);
  });

  test('nested task fields round-trip with backward-compatible defaults', () {
    final oldTask = Task.fromJson(_taskJson());
    expect(oldTask.parentId, isNull);
    expect(oldTask.collapsed, isFalse);

    final nested = Task.fromJson({
      ..._taskJson(),
      'parent_id': 'parent',
      'collapsed': true,
    });
    expect(nested.parentId, 'parent');
    expect(nested.collapsed, isTrue);
    expect(nested.toJson()['parent_id'], 'parent');
    expect(nested.toJson()['collapsed'], isTrue);
  });

  test('task-list validates preorder, depth, cycles, and daily roots', () {
    Task task(String id, {String? parentId, bool daily = false}) =>
        Task.fromJson({
          ..._taskJson(),
          'id': id,
          'parent_id': ?parentId,
          if (daily) 'daily': true,
        });
    TaskList list(List<Task> tasks) => TaskList(
      schemaVersion: currentSchemaVersion,
      id: 'list',
      name: 'Tasks',
      createdAt: DateTime.utc(2026),
      tasks: tasks,
    );

    expect(
      () => list([
        task('root'),
        task('child', parentId: 'root'),
        task('grandchild', parentId: 'child'),
      ]).validate(),
      returnsNormally,
    );
    expect(
      () => list([
        task('root'),
        task('child', parentId: 'root'),
        task('grandchild', parentId: 'child'),
        task('too-deep', parentId: 'grandchild'),
      ]).validate(),
      throwsFormatException,
    );
    expect(
      () => list([
        task('root', parentId: 'child'),
        task('child', parentId: 'root'),
      ]).validate(),
      throwsFormatException,
    );
    expect(
      () => list([
        task('root'),
        task('child', parentId: 'root', daily: true),
      ]).validate(),
      throwsFormatException,
    );
  });

  test(
    'tag names have backward-compatible defaults and persist custom names',
    () {
      final defaults = AppSettings.fromJson(const {});
      expect(defaults.languageLocale, 'en');
      expect(defaults.themeId, 'classic');
      expect(defaults.marqueeSpeedMs, normalMarqueeSpeedMs);
      expect(defaults.fontFamily, AppFontFamily.ubuntuMonoNerd);
      expect(defaults.nativeFontSize, 23);
      expect(defaults.tagNames.nameFor(TaskTag.spade), 'Spade');
      expect(defaults.tagNames.nameFor(TaskTag.heart), 'Heart');

      final settings = AppSettings.fromJson({
        'tag_names': {
          'spade': 'Work',
          'heart': 'Important',
          'club': 'Home',
          'diamond': 'Waiting',
        },
      });
      settings.validate();
      expect(settings.tagNames.nameFor(TaskTag.diamond), 'Waiting');
      expect((settings.toJson()['tag_names']! as Map)['heart'], 'Important');
      expect(settings.toJson()['language'], 'en');
      expect(settings.toJson()['theme'], 'classic');

      final removedFont = AppSettings.fromJson({'font_family': 'arimo_nerd'});
      expect(removedFont.fontFamily, AppFontFamily.ubuntuMonoNerd);
      expect(removedFont.toJson()['font_family'], 'ubuntu_mono_nerd');

      final removedBitstromFont = AppSettings.fromJson({
        'font_family': 'bitstrom_wera_nerd',
      });
      expect(removedBitstromFont.fontFamily, AppFontFamily.ubuntuMonoNerd);
      expect(removedBitstromFont.toJson()['font_family'], 'ubuntu_mono_nerd');

      final comicFont = AppSettings.fromJson({
        'font_family': 'comic_shanns_mono_nerd',
      });
      expect(comicFont.fontFamily, AppFontFamily.comicShannsMonoNerd);

      final themed = AppSettings.fromJson({'theme': 'gruvbox'});
      expect(themed.themeId, 'gruvbox');
      expect(themed.toJson()['theme'], 'gruvbox');

      final latinAmerican = AppSettings.fromJson({'language': 'es_419'});
      expect(latinAmerican.languageLocale, 'es_419');

      final legacyBackendSetting = AppSettings.fromJson({'use_backend': true});
      expect(legacyBackendSetting.toJson(), isNot(contains('use_backend')));
      expect(latinAmerican.toJson()['language'], 'es_419');
    },
  );

  test('tag names cannot be blank', () {
    const settings = AppSettings(tagNames: TagNames(heart: '   '));
    expect(settings.validate, throwsFormatException);
  });

  test('new settings preserve legacy long-title values and defaults', () {
    final legacyWrap = AppSettings.fromJson({'long_title_display': 'wrap'});
    expect(legacyWrap.longTitleDisplay, LongTitleDisplay.wrapAll);
    expect(
      AppSettings.fromJson(const {}).longTitleDisplay,
      LongTitleDisplay.wrapSelected,
    );
    expect(legacyWrap.tipsEnabled, isFalse);
    expect(legacyWrap.rewardDuration, RewardDuration.medium);

    final settings = AppSettings.fromJson({
      'long_title_display': 'slidingWindow',
      'tips_enabled': false,
      'reward_duration': 'long',
    });
    expect(settings.longTitleDisplay, LongTitleDisplay.marquee);
    expect(settings.tipsEnabled, isFalse);
    expect(
      settings.rewardDuration.duration,
      const Duration(milliseconds: 1400),
    );
  });

  test('device workspace state and desktop appearance round trip', () {
    const state = DeviceWorkspaceState(
      view: WorkspaceView.multi,
      currentListId: 'list',
      selectedTaskId: 'task',
      soundEnabled: false,
      seenTipIds: {'search', 'copy'},
      desktopAppearance: DesktopAppearance(
        backgroundImagePath: '/tmp/background.png',
        backgroundOverlayOpacity: .4,
        backgroundFit: DesktopBackgroundFit.contain,
      ),
    );
    final restored = DeviceWorkspaceState.fromJson(state.toJson());
    expect(restored.view, WorkspaceView.multi);
    expect(restored.selectedTaskId, 'task');
    expect(restored.seenTipIds, {'search', 'copy'});
    expect(restored.desktopAppearance.backgroundOverlayOpacity, .4);
    expect(
      restored.desktopAppearance.backgroundFit,
      DesktopBackgroundFit.contain,
    );
  });
}

Map<String, Object?> _taskJson() => {
  'id': 'task-1',
  'title': 'Tagged task',
  'status': 'pending',
  'created_at': '2026-01-01T00:00:00Z',
  'updated_at': '2026-01-01T00:00:00Z',
};
