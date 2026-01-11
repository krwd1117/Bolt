import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ko'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Bolt'**
  String get appTitle;

  /// No description provided for @noMemosFound.
  ///
  /// In en, this message translates to:
  /// **'No memos found'**
  String get noMemosFound;

  /// No description provided for @tapToAdd.
  ///
  /// In en, this message translates to:
  /// **'Tap + to add a new task'**
  String get tapToAdd;

  /// No description provided for @todoHeader.
  ///
  /// In en, this message translates to:
  /// **'To Do'**
  String get todoHeader;

  /// No description provided for @completedHeader.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completedHeader;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get filterToday;

  /// No description provided for @filterUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get filterUpcoming;

  /// No description provided for @filterOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get filterOverdue;

  /// No description provided for @filterNoDate.
  ///
  /// In en, this message translates to:
  /// **'No Date'**
  String get filterNoDate;

  /// No description provided for @filterClear.
  ///
  /// In en, this message translates to:
  /// **'Clear Filters'**
  String get filterClear;

  /// No description provided for @dateToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get dateToday;

  /// No description provided for @dateTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get dateTomorrow;

  /// No description provided for @dateInDays.
  ///
  /// In en, this message translates to:
  /// **'In {days} days'**
  String dateInDays(int days);

  /// No description provided for @dateDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{days}d ago'**
  String dateDaysAgo(int days);

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @sectionNotionSync.
  ///
  /// In en, this message translates to:
  /// **'Notion Sync'**
  String get sectionNotionSync;

  /// No description provided for @sectionAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get sectionAccount;

  /// No description provided for @labelDatabase.
  ///
  /// In en, this message translates to:
  /// **'Database'**
  String get labelDatabase;

  /// No description provided for @msgSelectDatabase.
  ///
  /// In en, this message translates to:
  /// **'Select a database'**
  String get msgSelectDatabase;

  /// No description provided for @labelConfigureProperties.
  ///
  /// In en, this message translates to:
  /// **'Configure Properties'**
  String get labelConfigureProperties;

  /// No description provided for @btnConnectNotion.
  ///
  /// In en, this message translates to:
  /// **'Connect Notion'**
  String get btnConnectNotion;

  /// No description provided for @btnLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get btnLogout;

  /// No description provided for @dialogLogoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get dialogLogoutTitle;

  /// No description provided for @dialogLogoutContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get dialogLogoutContent;

  /// No description provided for @dialogCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get dialogCancel;

  /// No description provided for @dialogLogoutAction.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get dialogLogoutAction;

  /// No description provided for @msgLogoutSuccess.
  ///
  /// In en, this message translates to:
  /// **'Logged out successfully'**
  String get msgLogoutSuccess;

  /// No description provided for @labelVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get labelVersion;

  /// No description provided for @addTaskTitle.
  ///
  /// In en, this message translates to:
  /// **'New Task'**
  String get addTaskTitle;

  /// No description provided for @addTaskHint.
  ///
  /// In en, this message translates to:
  /// **'Enter a new task...'**
  String get addTaskHint;

  /// No description provided for @dateUntil.
  ///
  /// In en, this message translates to:
  /// **'Until {month}.{day}'**
  String dateUntil(String month, String day);

  /// No description provided for @msgNoDatabaseSelected.
  ///
  /// In en, this message translates to:
  /// **'No database selected.'**
  String get msgNoDatabaseSelected;

  /// No description provided for @btnCreateTask.
  ///
  /// In en, this message translates to:
  /// **'Create Task'**
  String get btnCreateTask;

  /// No description provided for @msgTaskAdded.
  ///
  /// In en, this message translates to:
  /// **'Task added to Notion!'**
  String get msgTaskAdded;

  /// No description provided for @msgTaskFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to add task: {error}'**
  String msgTaskFailed(String error);

  /// No description provided for @labelSelectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get labelSelectDate;

  /// No description provided for @labelName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get labelName;

  /// No description provided for @hintWhatNeedsToBeDone.
  ///
  /// In en, this message translates to:
  /// **'What needs to be done?'**
  String get hintWhatNeedsToBeDone;

  /// No description provided for @labelType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get labelType;

  /// No description provided for @labelNoType.
  ///
  /// In en, this message translates to:
  /// **'No Type'**
  String get labelNoType;

  /// No description provided for @labelDueDate.
  ///
  /// In en, this message translates to:
  /// **'Due Date'**
  String get labelDueDate;

  /// No description provided for @btnAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get btnAdd;

  /// No description provided for @mappingTitle.
  ///
  /// In en, this message translates to:
  /// **'Property Mapping'**
  String get mappingTitle;

  /// No description provided for @mappingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Configure how Bolt maps Notion properties'**
  String get mappingSubtitle;

  /// No description provided for @mappingSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get mappingSave;

  /// No description provided for @mappingSuccess.
  ///
  /// In en, this message translates to:
  /// **'Mapping saved'**
  String get mappingSuccess;

  /// No description provided for @dbSelectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Database'**
  String get dbSelectionTitle;

  /// No description provided for @dbSelectionEmpty.
  ///
  /// In en, this message translates to:
  /// **'No accessible databases found. Please check your Notion integration settings.'**
  String get dbSelectionEmpty;

  /// No description provided for @msgDatabaseSelected.
  ///
  /// In en, this message translates to:
  /// **'Selected {database}'**
  String msgDatabaseSelected(String database);

  /// No description provided for @tooltipRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh Properties'**
  String get tooltipRefresh;

  /// No description provided for @msgFailedToLoadProperties.
  ///
  /// In en, this message translates to:
  /// **'Failed to load properties'**
  String get msgFailedToLoadProperties;

  /// No description provided for @btnRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get btnRetry;

  /// No description provided for @sectionCoreProperties.
  ///
  /// In en, this message translates to:
  /// **'Core Task Properties'**
  String get sectionCoreProperties;

  /// No description provided for @sectionAutomationProperties.
  ///
  /// In en, this message translates to:
  /// **'Automation Properties'**
  String get sectionAutomationProperties;

  /// No description provided for @btnSaveConfiguration.
  ///
  /// In en, this message translates to:
  /// **'Save Configuration'**
  String get btnSaveConfiguration;

  /// No description provided for @msgConfigurationSaved.
  ///
  /// In en, this message translates to:
  /// **'Configuration saved'**
  String get msgConfigurationSaved;

  /// No description provided for @msgErrorLoadingProperties.
  ///
  /// In en, this message translates to:
  /// **'Error loading properties: {error}'**
  String msgErrorLoadingProperties(String error);

  /// No description provided for @propTaskTitle.
  ///
  /// In en, this message translates to:
  /// **'Task Title (Required)'**
  String get propTaskTitle;

  /// No description provided for @propStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get propStatus;

  /// No description provided for @propDueDate.
  ///
  /// In en, this message translates to:
  /// **'Due Date'**
  String get propDueDate;

  /// No description provided for @propType.
  ///
  /// In en, this message translates to:
  /// **'Type / Category'**
  String get propType;

  /// No description provided for @propName.
  ///
  /// In en, this message translates to:
  /// **'Name (Optional)'**
  String get propName;

  /// No description provided for @propDoneCheckbox.
  ///
  /// In en, this message translates to:
  /// **'Done Checkbox'**
  String get propDoneCheckbox;

  /// No description provided for @propDoneDate.
  ///
  /// In en, this message translates to:
  /// **'Done Date'**
  String get propDoneDate;

  /// No description provided for @propCreatedDate.
  ///
  /// In en, this message translates to:
  /// **'Created Date'**
  String get propCreatedDate;

  /// No description provided for @msgLaunchAuthUrlFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not launch Notion Auth URL'**
  String get msgLaunchAuthUrlFailed;

  /// No description provided for @msgError.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String msgError(String error);

  /// No description provided for @actionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get actionDelete;

  /// No description provided for @actionUndo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get actionUndo;

  /// No description provided for @dialogDeleteTaskTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Task'**
  String get dialogDeleteTaskTitle;

  /// No description provided for @dialogDeleteTaskContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this task?'**
  String get dialogDeleteTaskContent;

  /// No description provided for @msgTaskDeleted.
  ///
  /// In en, this message translates to:
  /// **'Task deleted'**
  String get msgTaskDeleted;

  /// No description provided for @msgDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete task: {error}'**
  String msgDeleteFailed(String error);

  /// No description provided for @calendarToggleTooltip.
  ///
  /// In en, this message translates to:
  /// **'Toggle Calendar'**
  String get calendarToggleTooltip;

  /// No description provided for @filterTodo.
  ///
  /// In en, this message translates to:
  /// **'To Do'**
  String get filterTodo;

  /// No description provided for @filterDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get filterDone;

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear Filters'**
  String get clearFilters;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get searchHint;

  /// No description provided for @sortByName.
  ///
  /// In en, this message translates to:
  /// **'Sort by Name'**
  String get sortByName;

  /// No description provided for @sortByDueDateNearest.
  ///
  /// In en, this message translates to:
  /// **'Due Date (Nearest)'**
  String get sortByDueDateNearest;

  /// No description provided for @sortByDueDateFarthest.
  ///
  /// In en, this message translates to:
  /// **'Due Date (Farthest)'**
  String get sortByDueDateFarthest;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ko':
      return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
