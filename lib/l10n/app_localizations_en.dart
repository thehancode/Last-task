// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Last Task';

  @override
  String get windowTitle => 'Last Task';

  @override
  String get workspaceTitle => 'LAST TASK';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get close => 'Close';

  @override
  String get task => 'Task';

  @override
  String get newTask => 'New task';

  @override
  String get newDailyTask => 'Create new daily task';

  @override
  String get newSubtask => 'New subtask';

  @override
  String get collapseSubtasks => 'Collapse subtasks';

  @override
  String get expandSubtasks => 'Expand subtasks';

  @override
  String get editTask => 'Edit task';

  @override
  String get duplicateTask => 'Duplicate task';

  @override
  String get deleteTaskTitle => 'Delete task?';

  @override
  String get deleteListTitle => 'Delete list?';

  @override
  String get deleteList => 'Delete list';

  @override
  String get deleteTaskBody =>
      'This task and all its subtasks will be deleted. This cannot be undone.';

  @override
  String deleteSelectedTasksTitle(Object count) {
    return 'Delete selected tasks?';
  }

  @override
  String deleteSelectedTasksBody(Object count) {
    return 'Delete $count selected tasks and their subtasks? This cannot be undone.';
  }

  @override
  String deleteListBody(Object listName) {
    return 'Delete \"$listName\" and all its tasks?';
  }

  @override
  String get keyboardShortcuts => 'Keyboard shortcuts';

  @override
  String get keyboardShortcutsHelp =>
      '↑/↓ or J/K   Move selection\nShift+↑/↓   Select visible tasks\n←/→   Switch task lists\nHold Ctrl + ←/→   Reorder task lists\nSpace then F   Advance status\nSpace then Space   Complete subtree\nShift+Space   Archive task\nHold Ctrl + ↑/↓   Reorder task/subtree\nN / Tab / E / D / X   New, subtask, edit, duplicate, delete\nH   Collapse / expand subtasks\nW / Shift+W   Cycle first / second tag\nCtrl+C   Copy task/selection\nCtrl+Shift+C   Copy current section\nEsc   Clear selection\nCtrl+A / Ctrl+Shift+A   Select visible / Multi view\nCtrl+F or /   Search\nCtrl+Z   Undo\nCtrl+N   New list\nF2 / Ctrl+R   Rename list\nCtrl+X   Delete list\nC   Doing focus\nV   Completed history\nG   Settings\nS   Sound\nQ   Quit';

  @override
  String get couldNotLoad => 'Could not load Last Task';

  @override
  String get dragWindow => 'Drag window';

  @override
  String get closeApp => 'Close app';

  @override
  String get newTaskTooltip => 'New task (N)';

  @override
  String get newListTooltip => 'New list (Ctrl+N)';

  @override
  String get listActions => 'List actions';

  @override
  String get appActions => 'App actions';

  @override
  String get newList => 'New list';

  @override
  String get renameList => 'Rename list';

  @override
  String get toggleMultiView => 'Toggle Multi view';

  @override
  String get settings => 'Settings';

  @override
  String get createAccount => 'Create account';

  @override
  String get logIn => 'Log in';

  @override
  String get logOut => 'Log out';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get themes => 'Themes';

  @override
  String taskList(Object listName) {
    return 'Task list $listName';
  }

  @override
  String get listView => 'LIST VIEW';

  @override
  String get doingFocus => 'DOING FOCUS';

  @override
  String get completed => 'COMPLETED';

  @override
  String get multiView => 'MULTI VIEW';

  @override
  String get pending => 'Pending';

  @override
  String get doing => 'Doing';

  @override
  String get done => 'Done';

  @override
  String get archived => 'Archived';

  @override
  String get noDoingTasks => 'No doing tasks';

  @override
  String get noCompletedTasks =>
      'No completed tasks yet — finish one with Space, then F.';

  @override
  String get noDoingOrPendingTasks => 'No Doing or Pending tasks';

  @override
  String get empty => 'empty';

  @override
  String taskSemantics(Object status, Object title, Object tags) {
    return '$status task: $title$tags';
  }

  @override
  String taskTagsSemantics(Object tags) {
    return ', tags: $tags';
  }

  @override
  String get advanceTask => 'Advance task';

  @override
  String get taskActions => 'Task actions';

  @override
  String get reopenInDoing => 'Restore to Pending';

  @override
  String get edit => 'Edit';

  @override
  String get duplicate => 'Duplicate';

  @override
  String get spaceArmed => ' SPACE armed — F advance ';

  @override
  String dailyActivity(Object activity) {
    return ' Daily: $activity';
  }

  @override
  String get keyboardHint =>
      'Ctrl+A multi   Tab lists   ↑↓ move   N new   Space+F advance   Ctrl+↑↓ sort   ? help';

  @override
  String commandSemantics(Object label, Object keys) {
    return '$label command ($keys)';
  }

  @override
  String get commandMulti => 'multi';

  @override
  String get commandLists => 'lists';

  @override
  String get commandMove => 'Move';

  @override
  String get commandMoveLegacy => 'move';

  @override
  String get commandNew => 'New task';

  @override
  String get commandNewLegacy => 'new';

  @override
  String get commandAdvance => 'advance';

  @override
  String get commandSort => 'sort';

  @override
  String get commandTags => 'Tag task';

  @override
  String get commandTagsLegacy => 'tags';

  @override
  String get commandNewList => 'New list';

  @override
  String get commandNewListLegacy => 'new list';

  @override
  String get commandRename => 'rename';

  @override
  String get commandDeleteList => 'del list';

  @override
  String get commandSettings => 'Settings';

  @override
  String get commandSettingsLegacy => 'settings';

  @override
  String get commandHelp => 'Help';

  @override
  String get commandHelpLegacy => 'help';

  @override
  String get taskTitle => 'Task title';

  @override
  String get habitList => 'Habit list (tasks in this list reset daily)';

  @override
  String get listName => 'List name';

  @override
  String get tagNamesCannotBeEmpty => 'Tag names cannot be empty';

  @override
  String marqueeSpeed(int milliseconds) {
    return 'Marquee speed: $milliseconds ms';
  }

  @override
  String get marqueeSpeedLabel => 'Marquee speed';

  @override
  String get slow => 'Slow';

  @override
  String get normal => 'Normal';

  @override
  String get fast => 'Fast';

  @override
  String get wrapLongTitles => 'Wrap long titles';

  @override
  String desktopFontSize(int points) {
    return 'Desktop font size: $points pt';
  }

  @override
  String get desktopFontSizeLabel => 'Desktop font size';

  @override
  String get fontFamily => 'Font';

  @override
  String get tagNames => 'Tag names';

  @override
  String get saveTagNames => 'Save tag names';

  @override
  String get language => 'Language';

  @override
  String languageValue(Object language) {
    return 'Language: $language';
  }

  @override
  String get showTips => 'Show entrance tips';

  @override
  String get useBackend => 'Use Backend';

  @override
  String get exportData => 'Export data';

  @override
  String get importData => 'Load data';

  @override
  String get rewardDuration => 'Reward duration';

  @override
  String get tipsTitle => 'Tips';

  @override
  String get tipNavigation => 'Use left and right to switch task lists.';

  @override
  String get tipReorder =>
      'Hold Ctrl and press up or down to reorder a task subtree.';

  @override
  String get tipSubtasks => 'Press Tab to add a subtask to the selected task.';

  @override
  String get tipSearch => 'Press Ctrl+F or / to search tasks.';

  @override
  String get tipCopy =>
      'Ctrl+C copies one title; Ctrl+Shift+C copies its section.';

  @override
  String get taskWasCopied => 'Task was copied';

  @override
  String get selectionWasCopied => 'Selection was copied';

  @override
  String selectedTasksCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tasks selected',
      one: '1 task selected',
    );
    return '$_temp0';
  }

  @override
  String get rewardGreatWork => 'Great work!';

  @override
  String get rewardNicelyDone => 'Nicely done!';

  @override
  String get rewardKeepGoing => 'Keep going!';

  @override
  String get rewardMomentum => 'Momentum gained!';

  @override
  String get rewardTaskCleared => 'Task cleared!';

  @override
  String get rewardExcellent => 'Excellent!';

  @override
  String get search => 'Search';

  @override
  String get previousMatch => 'Previous match';

  @override
  String get nextMatch => 'Next match';

  @override
  String get closeSearch => 'Close search';

  @override
  String get typeToSearch => 'Type to search';

  @override
  String get noSearchMatches => 'No matches';

  @override
  String get longTitleMode => 'Long-title mode';

  @override
  String get wrapSelected => 'Wrap selected';

  @override
  String get wrapAll => 'Wrap all';

  @override
  String get marquee => 'Marquee';

  @override
  String get shortDuration => 'Short';

  @override
  String get mediumDuration => 'Medium';

  @override
  String get longDuration => 'Long';

  @override
  String get backgroundImage => 'Background image';

  @override
  String get backgroundOpacity => 'Background color opacity';

  @override
  String get backgroundTransparency => 'Background transparency';

  @override
  String get configTab => 'Config';

  @override
  String get backgroundTab => 'Background';

  @override
  String get decrease => 'Decrease';

  @override
  String get increase => 'Increase';

  @override
  String get backgroundFit => 'Image fit';

  @override
  String get cover => 'Cover';

  @override
  String get contain => 'Contain';

  @override
  String get noImageSelected => 'No image selected';

  @override
  String get none => 'None';

  @override
  String get clear => 'Clear';

  @override
  String get tutorialUnlockAward =>
      'Congratulations, Themes have been unlocked, you can change themes by pressing G and going to the themes tab';

  @override
  String get great => 'Great';

  @override
  String get tutorialAwardBadge => 'Tutorial completed';

  @override
  String get languageName => 'English';
}
