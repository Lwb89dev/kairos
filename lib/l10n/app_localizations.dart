import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bg.dart';
import 'app_localizations_cs.dart';
import 'app_localizations_da.dart';
import 'app_localizations_de.dart';
import 'app_localizations_el.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_et.dart';
import 'app_localizations_fi.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ga.dart';
import 'app_localizations_hr.dart';
import 'app_localizations_hu.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_lt.dart';
import 'app_localizations_lv.dart';
import 'app_localizations_mt.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ro.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_sk.dart';
import 'app_localizations_sl.dart';
import 'app_localizations_sv.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('bg'),
    Locale('cs'),
    Locale('da'),
    Locale('de'),
    Locale('el'),
    Locale('en'),
    Locale('es'),
    Locale('et'),
    Locale('fi'),
    Locale('fr'),
    Locale('ga'),
    Locale('hr'),
    Locale('hu'),
    Locale('it'),
    Locale('ja'),
    Locale('lt'),
    Locale('lv'),
    Locale('mt'),
    Locale('nl'),
    Locale('pl'),
    Locale('pt'),
    Locale('ro'),
    Locale('ru'),
    Locale('sk'),
    Locale('sl'),
    Locale('sv'),
    Locale('zh'),
  ];

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @sectionAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get sectionAccount;

  /// No description provided for @addAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Add a Nostr account'**
  String get addAccountTitle;

  /// No description provided for @addAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Currently offline, local-only.'**
  String get addAccountSubtitle;

  /// No description provided for @backupKeyTitle.
  ///
  /// In en, this message translates to:
  /// **'Back up private key'**
  String get backupKeyTitle;

  /// No description provided for @backupKeySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Required to recover this Nostr account.'**
  String get backupKeySubtitle;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOut;

  /// No description provided for @sectionSync.
  ///
  /// In en, this message translates to:
  /// **'Sync'**
  String get sectionSync;

  /// No description provided for @syncInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Optional encrypted sync'**
  String get syncInfoTitle;

  /// No description provided for @syncInfoBody.
  ///
  /// In en, this message translates to:
  /// **'Tasks sync only when a Nostr account and at least one relay are configured. Task content is NIP-44 encrypted before it leaves this device.'**
  String get syncInfoBody;

  /// No description provided for @sectionRelays.
  ///
  /// In en, this message translates to:
  /// **'Relays'**
  String get sectionRelays;

  /// No description provided for @sectionAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get sectionAppearance;

  /// No description provided for @themeLabel.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get themeLabel;

  /// No description provided for @sectionLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get sectionLanguage;

  /// No description provided for @langSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get langSystem;

  /// No description provided for @sectionSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get sectionSupport;

  /// No description provided for @supportKairosTitle.
  ///
  /// In en, this message translates to:
  /// **'Support Kairos'**
  String get supportKairosTitle;

  /// No description provided for @lightningAddressCopied.
  ///
  /// In en, this message translates to:
  /// **'No Lightning wallet found — address copied: {address}'**
  String lightningAddressCopied(String address);

  /// No description provided for @logoutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Log out?'**
  String get logoutConfirmTitle;

  /// No description provided for @logoutConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Your tasks stay on this device. Without the key, they can no longer sync — make sure you have a backup of your nsec before logging out.'**
  String get logoutConfirmBody;

  /// No description provided for @cancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// No description provided for @nsecDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Your private key (nsec)'**
  String get nsecDialogTitle;

  /// No description provided for @nsecDialogWarning.
  ///
  /// In en, this message translates to:
  /// **'Anyone with this key controls your account. Store it in a password manager and never share it.'**
  String get nsecDialogWarning;

  /// No description provided for @copyButton.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copyButton;

  /// No description provided for @doneButton.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get doneButton;

  /// No description provided for @signedInWithAmber.
  ///
  /// In en, this message translates to:
  /// **'Signed in with Amber'**
  String get signedInWithAmber;

  /// No description provided for @signedInWithKey.
  ///
  /// In en, this message translates to:
  /// **'Signed in · {npub}'**
  String signedInWithKey(String npub);

  /// No description provided for @relayInvalidUrlWss.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid encrypted wss:// relay URL.'**
  String get relayInvalidUrlWss;

  /// No description provided for @relayUrlHint.
  ///
  /// In en, this message translates to:
  /// **'wss://your-relay…'**
  String get relayUrlHint;

  /// No description provided for @addRelayTooltip.
  ///
  /// In en, this message translates to:
  /// **'Add relay'**
  String get addRelayTooltip;

  /// No description provided for @noRelaysConfigured.
  ///
  /// In en, this message translates to:
  /// **'No relays configured.'**
  String get noRelaysConfigured;

  /// No description provided for @removeRelayTooltip.
  ///
  /// In en, this message translates to:
  /// **'Remove relay'**
  String get removeRelayTooltip;

  /// No description provided for @homeRelayTitle.
  ///
  /// In en, this message translates to:
  /// **'Personal home relay'**
  String get homeRelayTitle;

  /// No description provided for @homeRelayConfiguredSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Extra backup target for your encrypted tasks'**
  String get homeRelayConfiguredSubtitle;

  /// No description provided for @homeRelaySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Optional: add your own relay as an extra backup target. Unlike other relays, this one may also use an unencrypted ws:// address if it\'s on your local network.'**
  String get homeRelaySubtitle;

  /// No description provided for @removeHomeRelayTooltip.
  ///
  /// In en, this message translates to:
  /// **'Remove home relay'**
  String get removeHomeRelayTooltip;

  /// No description provided for @homeRelayUrlHint.
  ///
  /// In en, this message translates to:
  /// **'wss://your-home-relay, or ws:// on your LAN'**
  String get homeRelayUrlHint;

  /// No description provided for @homeRelayInvalidUrl.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid wss:// relay URL (ws:// is only allowed for a home relay on your own network).'**
  String get homeRelayInvalidUrl;

  /// No description provided for @saveButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveButton;

  /// No description provided for @onboardingSaveError.
  ///
  /// In en, this message translates to:
  /// **'Could not save setup on this device.'**
  String get onboardingSaveError;

  /// No description provided for @backButton.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get backButton;

  /// No description provided for @getStartedButton.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get getStartedButton;

  /// No description provided for @useOfflineButton.
  ///
  /// In en, this message translates to:
  /// **'Use offline'**
  String get useOfflineButton;

  /// No description provided for @nextButton.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextButton;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to {appName}'**
  String welcomeTitle(String appName);

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A private, focused task manager in the Echoes ecosystem.'**
  String get welcomeSubtitle;

  /// No description provided for @featureLocalTitle.
  ///
  /// In en, this message translates to:
  /// **'Yours, on your device'**
  String get featureLocalTitle;

  /// No description provided for @featureLocalBody.
  ///
  /// In en, this message translates to:
  /// **'Tasks are stored locally first in an encrypted database. The app works fully offline — no account required.'**
  String get featureLocalBody;

  /// No description provided for @featureSyncTitle.
  ///
  /// In en, this message translates to:
  /// **'Sync through Nostr'**
  String get featureSyncTitle;

  /// No description provided for @featureSyncBody.
  ///
  /// In en, this message translates to:
  /// **'Sign in with a Nostr key and your tasks sync across devices through relays you choose — no company server in the middle.'**
  String get featureSyncBody;

  /// No description provided for @featureEncryptedTitle.
  ///
  /// In en, this message translates to:
  /// **'End-to-end encrypted'**
  String get featureEncryptedTitle;

  /// No description provided for @featureEncryptedBody.
  ///
  /// In en, this message translates to:
  /// **'Every task is encrypted (NIP-44) before it leaves the device. Relays only ever see ciphertext.'**
  String get featureEncryptedBody;

  /// No description provided for @featureAmberTitle.
  ///
  /// In en, this message translates to:
  /// **'Amber support'**
  String get featureAmberTitle;

  /// No description provided for @featureAmberBody.
  ///
  /// In en, this message translates to:
  /// **'On Android you can keep your key in Amber: one sign-in for the whole suite, and no app ever touches the key itself.'**
  String get featureAmberBody;

  /// No description provided for @loginPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to sync your encrypted tasks'**
  String get loginPageTitle;

  /// No description provided for @loginPageBody.
  ///
  /// In en, this message translates to:
  /// **'Use a Nostr identity for optional multi-device sync, or continue without an account and keep everything local.'**
  String get loginPageBody;

  /// No description provided for @relaySetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your relays'**
  String get relaySetupTitle;

  /// No description provided for @relaySetupBody.
  ///
  /// In en, this message translates to:
  /// **'Relays store encrypted tasks for synchronization with Kairos on your other devices. Add one or more, or leave this empty and configure sync later.'**
  String get relaySetupBody;

  /// No description provided for @relaySettingsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load relay settings.'**
  String get relaySettingsLoadError;

  /// No description provided for @taskGoneMessage.
  ///
  /// In en, this message translates to:
  /// **'This task no longer exists.'**
  String get taskGoneMessage;

  /// No description provided for @taskDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Task'**
  String get taskDetailsTitle;

  /// No description provided for @editTooltip.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editTooltip;

  /// No description provided for @deleteTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteTooltip;

  /// No description provided for @dueDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Due date'**
  String get dueDateLabel;

  /// No description provided for @noneLabel.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get noneLabel;

  /// No description provided for @tagsLabel.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get tagsLabel;

  /// No description provided for @priorityLabel.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get priorityLabel;

  /// No description provided for @priorityValue.
  ///
  /// In en, this message translates to:
  /// **'{priority} / 5'**
  String priorityValue(int priority);

  /// No description provided for @colorLabel.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get colorLabel;

  /// No description provided for @syncStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Sync'**
  String get syncStatusLabel;

  /// No description provided for @syncedStatus.
  ///
  /// In en, this message translates to:
  /// **'Published to relays'**
  String get syncedStatus;

  /// No description provided for @notSyncedStatus.
  ///
  /// In en, this message translates to:
  /// **'Local only (pending sync)'**
  String get notSyncedStatus;

  /// No description provided for @linkedEventLabel.
  ///
  /// In en, this message translates to:
  /// **'Linked calendar event'**
  String get linkedEventLabel;

  /// No description provided for @createdUpdatedInfo.
  ///
  /// In en, this message translates to:
  /// **'Created {created}\nUpdated {updated}'**
  String createdUpdatedInfo(String created, String updated);

  /// No description provided for @deleteTaskConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this task?'**
  String get deleteTaskConfirmTitle;

  /// No description provided for @deleteTaskConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'The task is removed locally and a deletion request is sent to your relays.'**
  String get deleteTaskConfirmBody;

  /// No description provided for @deleteButton.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteButton;

  /// No description provided for @deleteTaskError.
  ///
  /// In en, this message translates to:
  /// **'Could not delete the task locally.'**
  String get deleteTaskError;

  /// No description provided for @saveTaskError.
  ///
  /// In en, this message translates to:
  /// **'Could not save the task locally.'**
  String get saveTaskError;

  /// No description provided for @editTaskTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit task'**
  String get editTaskTitle;

  /// No description provided for @newTaskTitle.
  ///
  /// In en, this message translates to:
  /// **'New task'**
  String get newTaskTitle;

  /// No description provided for @syncToNostrTitle.
  ///
  /// In en, this message translates to:
  /// **'Sync to Nostr'**
  String get syncToNostrTitle;

  /// No description provided for @syncToNostrSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Publish this task, encrypted, to your relays. When off, it stays only on this device.'**
  String get syncToNostrSubtitle;

  /// No description provided for @syncTaskButton.
  ///
  /// In en, this message translates to:
  /// **'Sync task'**
  String get syncTaskButton;

  /// No description provided for @localOnlyStatus.
  ///
  /// In en, this message translates to:
  /// **'Local only (sync off)'**
  String get localOnlyStatus;

  /// No description provided for @titleFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get titleFieldLabel;

  /// No description provided for @titleRequiredError.
  ///
  /// In en, this message translates to:
  /// **'A title is required.'**
  String get titleRequiredError;

  /// No description provided for @titleTooLongError.
  ///
  /// In en, this message translates to:
  /// **'The title is too long.'**
  String get titleTooLongError;

  /// No description provided for @descriptionFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get descriptionFieldLabel;

  /// No description provided for @noDueDateLabel.
  ///
  /// In en, this message translates to:
  /// **'No due date'**
  String get noDueDateLabel;

  /// No description provided for @optionalDeadlineHint.
  ///
  /// In en, this message translates to:
  /// **'Optional deadline.'**
  String get optionalDeadlineHint;

  /// No description provided for @clearDueDateTooltip.
  ///
  /// In en, this message translates to:
  /// **'Clear due date'**
  String get clearDueDateTooltip;

  /// No description provided for @tagsFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Tags (comma-separated, optional)'**
  String get tagsFieldLabel;

  /// No description provided for @tagsFieldHint.
  ///
  /// In en, this message translates to:
  /// **'work, personal'**
  String get tagsFieldHint;

  /// No description provided for @tooManyTagsError.
  ///
  /// In en, this message translates to:
  /// **'Use at most 32 tags.'**
  String get tooManyTagsError;

  /// No description provided for @tagTooLongError.
  ///
  /// In en, this message translates to:
  /// **'Each tag must be at most 64 characters.'**
  String get tagTooLongError;

  /// No description provided for @priorityScaleHint.
  ///
  /// In en, this message translates to:
  /// **'1 = low, 5 = high'**
  String get priorityScaleHint;

  /// No description provided for @syncNowTooltip.
  ///
  /// In en, this message translates to:
  /// **'Sync now'**
  String get syncNowTooltip;

  /// No description provided for @settingsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTooltip;

  /// No description provided for @newTaskTooltip.
  ///
  /// In en, this message translates to:
  /// **'New task'**
  String get newTaskTooltip;

  /// No description provided for @loadTasksError.
  ///
  /// In en, this message translates to:
  /// **'Could not load local tasks.'**
  String get loadTasksError;

  /// No description provided for @emptyTasksTitle.
  ///
  /// In en, this message translates to:
  /// **'No tasks yet'**
  String get emptyTasksTitle;

  /// No description provided for @emptyTasksBody.
  ///
  /// In en, this message translates to:
  /// **'Tap + to add your first task.'**
  String get emptyTasksBody;

  /// No description provided for @completedCount.
  ///
  /// In en, this message translates to:
  /// **'Completed ({count})'**
  String completedCount(int count);

  /// No description provided for @invalidKeyError.
  ///
  /// In en, this message translates to:
  /// **'That private key is not valid. Check it and try again.'**
  String get invalidKeyError;

  /// No description provided for @signInError.
  ///
  /// In en, this message translates to:
  /// **'Could not sign in. Please try again.'**
  String get signInError;

  /// No description provided for @signInAmberButton.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Amber'**
  String get signInAmberButton;

  /// No description provided for @createAccountButton.
  ///
  /// In en, this message translates to:
  /// **'Create a new account'**
  String get createAccountButton;

  /// No description provided for @generatedAccountHint.
  ///
  /// In en, this message translates to:
  /// **'A generated account can only be recovered with its private key. Back it up from Settings after setup.'**
  String get generatedAccountHint;

  /// No description provided for @importKeyButton.
  ///
  /// In en, this message translates to:
  /// **'Import an existing key'**
  String get importKeyButton;

  /// No description provided for @importKeyFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'nsec or hex private key'**
  String get importKeyFieldLabel;

  /// No description provided for @importButton.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get importButton;

  /// No description provided for @storageFailureMessage.
  ///
  /// In en, this message translates to:
  /// **'Kairos could not open its encrypted local database. Restart the app. Do not clear app data; if the problem persists, report it privately.'**
  String get storageFailureMessage;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'bg',
    'cs',
    'da',
    'de',
    'el',
    'en',
    'es',
    'et',
    'fi',
    'fr',
    'ga',
    'hr',
    'hu',
    'it',
    'ja',
    'lt',
    'lv',
    'mt',
    'nl',
    'pl',
    'pt',
    'ro',
    'ru',
    'sk',
    'sl',
    'sv',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bg':
      return AppLocalizationsBg();
    case 'cs':
      return AppLocalizationsCs();
    case 'da':
      return AppLocalizationsDa();
    case 'de':
      return AppLocalizationsDe();
    case 'el':
      return AppLocalizationsEl();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'et':
      return AppLocalizationsEt();
    case 'fi':
      return AppLocalizationsFi();
    case 'fr':
      return AppLocalizationsFr();
    case 'ga':
      return AppLocalizationsGa();
    case 'hr':
      return AppLocalizationsHr();
    case 'hu':
      return AppLocalizationsHu();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'lt':
      return AppLocalizationsLt();
    case 'lv':
      return AppLocalizationsLv();
    case 'mt':
      return AppLocalizationsMt();
    case 'nl':
      return AppLocalizationsNl();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ro':
      return AppLocalizationsRo();
    case 'ru':
      return AppLocalizationsRu();
    case 'sk':
      return AppLocalizationsSk();
    case 'sl':
      return AppLocalizationsSl();
    case 'sv':
      return AppLocalizationsSv();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
