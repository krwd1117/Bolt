// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Bolt';

  @override
  String get noMemosFound => 'No memos found';

  @override
  String get tapToAdd => 'Tap + to add a new task';

  @override
  String get todoHeader => 'To Do';

  @override
  String get completedHeader => 'Completed';

  @override
  String get filterAll => 'All';

  @override
  String get filterToday => 'Today';

  @override
  String get filterUpcoming => 'Upcoming';

  @override
  String get filterOverdue => 'Overdue';

  @override
  String get filterNoDate => 'No Date';

  @override
  String get filterClear => 'Clear Filters';

  @override
  String get dateToday => 'Today';

  @override
  String get dateTomorrow => 'Tomorrow';

  @override
  String dateInDays(int days) {
    return 'In $days days';
  }

  @override
  String dateDaysAgo(int days) {
    return '${days}d ago';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get sectionNotionSync => 'Notion Sync';

  @override
  String get sectionAccount => 'Account';

  @override
  String get labelDatabase => 'Database';

  @override
  String get msgSelectDatabase => 'Select a database';

  @override
  String get labelConfigureProperties => 'Configure Properties';

  @override
  String get btnConnectNotion => 'Connect Notion';

  @override
  String get btnLogout => 'Logout';

  @override
  String get dialogLogoutTitle => 'Logout';

  @override
  String get dialogLogoutContent => 'Are you sure you want to logout?';

  @override
  String get dialogCancel => 'Cancel';

  @override
  String get dialogLogoutAction => 'Logout';

  @override
  String get msgLogoutSuccess => 'Logged out successfully';

  @override
  String get labelVersion => 'Version';

  @override
  String get addTaskTitle => 'New Task';

  @override
  String get addTaskHint => 'Enter a new task...';

  @override
  String dateUntil(String month, String day) {
    return 'Until $month.$day';
  }

  @override
  String get msgNoDatabaseSelected => 'No database selected.';

  @override
  String get btnCreateTask => 'Create Task';

  @override
  String get msgTaskAdded => 'Task added to Notion!';

  @override
  String msgTaskFailed(String error) {
    return 'Failed to add task: $error';
  }

  @override
  String get labelSelectDate => 'Select Date';

  @override
  String get labelName => 'Name';

  @override
  String get hintWhatNeedsToBeDone => 'What needs to be done?';

  @override
  String get labelType => 'Type';

  @override
  String get labelNoType => 'No Type';

  @override
  String get labelDueDate => 'Due Date';

  @override
  String get btnAdd => 'Add';

  @override
  String get mappingTitle => 'Property Mapping';

  @override
  String get mappingSubtitle => 'Configure how Bolt maps Notion properties';

  @override
  String get mappingSave => 'Save';

  @override
  String get mappingSuccess => 'Mapping saved';

  @override
  String get dbSelectionTitle => 'Select Database';

  @override
  String get dbSelectionEmpty =>
      'No accessible databases found. Please check your Notion integration settings.';

  @override
  String msgDatabaseSelected(String database) {
    return 'Selected $database';
  }

  @override
  String get tooltipRefresh => 'Refresh Properties';

  @override
  String get msgFailedToLoadProperties => 'Failed to load properties';

  @override
  String get btnRetry => 'Retry';

  @override
  String get sectionCoreProperties => 'Core Task Properties';

  @override
  String get sectionAutomationProperties => 'Automation Properties';

  @override
  String get btnSaveConfiguration => 'Save Configuration';

  @override
  String get msgConfigurationSaved => 'Configuration saved';

  @override
  String msgErrorLoadingProperties(String error) {
    return 'Error loading properties: $error';
  }

  @override
  String get propTaskTitle => 'Task Title (Required)';

  @override
  String get propStatus => 'Status';

  @override
  String get propDueDate => 'Due Date';

  @override
  String get propType => 'Type / Category';

  @override
  String get propName => 'Name (Optional)';

  @override
  String get propDoneCheckbox => 'Done Checkbox';

  @override
  String get propDoneDate => 'Done Date';

  @override
  String get propCreatedDate => 'Created Date';

  @override
  String get msgLaunchAuthUrlFailed => 'Could not launch Notion Auth URL';

  @override
  String msgError(String error) {
    return 'Error: $error';
  }

  @override
  String get actionDelete => 'Delete';

  @override
  String get actionUndo => 'Undo';

  @override
  String get dialogDeleteTaskTitle => 'Delete Task';

  @override
  String get dialogDeleteTaskContent =>
      'Are you sure you want to delete this task?';

  @override
  String get msgTaskDeleted => 'Task deleted';

  @override
  String msgDeleteFailed(String error) {
    return 'Failed to delete task: $error';
  }

  @override
  String get calendarToggleTooltip => 'Toggle Calendar';

  @override
  String get filterTodo => 'To Do';

  @override
  String get filterDone => 'Done';

  @override
  String get clearFilters => 'Clear Filters';

  @override
  String get searchHint => 'Search...';

  @override
  String get sortByName => 'Sort by Name';

  @override
  String get sortByDueDateNearest => 'Due Date (Nearest)';

  @override
  String get sortByDueDateFarthest => 'Due Date (Farthest)';
}
