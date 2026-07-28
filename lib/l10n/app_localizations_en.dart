// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get settingsTitle => 'Settings';

  @override
  String get sectionAccount => 'Account';

  @override
  String get addAccountTitle => 'Add a Nostr account';

  @override
  String get addAccountSubtitle => 'Currently offline, local-only.';

  @override
  String get backupKeyTitle => 'Back up private key';

  @override
  String get backupKeySubtitle => 'Required to recover this Nostr account.';

  @override
  String get logOut => 'Log out';

  @override
  String get sectionSync => 'Sync';

  @override
  String get syncInfoTitle => 'Optional encrypted sync';

  @override
  String get syncInfoBody =>
      'Tasks sync only when a Nostr account and at least one relay are configured. Task content is NIP-44 encrypted before it leaves this device.';

  @override
  String get sectionRelays => 'Relays';

  @override
  String get sectionAppearance => 'Appearance';

  @override
  String get themeLabel => 'Theme';

  @override
  String get sectionLanguage => 'Language';

  @override
  String get langSystem => 'System';

  @override
  String get sectionSupport => 'Support';

  @override
  String get supportKairosTitle => 'Support Kairos';

  @override
  String lightningAddressCopied(String address) {
    return 'No Lightning wallet found — address copied: $address';
  }

  @override
  String get logoutConfirmTitle => 'Log out?';

  @override
  String get logoutConfirmBody =>
      'Your tasks stay on this device. Without the key, they can no longer sync — make sure you have a backup of your nsec before logging out.';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get nsecDialogTitle => 'Your private key (nsec)';

  @override
  String get nsecDialogWarning =>
      'Anyone with this key controls your account. Store it in a password manager and never share it.';

  @override
  String get copyButton => 'Copy';

  @override
  String get doneButton => 'Done';

  @override
  String get signedInWithAmber => 'Signed in with Amber';

  @override
  String signedInWithKey(String npub) {
    return 'Signed in · $npub';
  }

  @override
  String get relayInvalidUrlWss => 'Enter a valid encrypted wss:// relay URL.';

  @override
  String get relayUrlHint => 'wss://your-relay…';

  @override
  String get addRelayTooltip => 'Add relay';

  @override
  String get noRelaysConfigured => 'No relays configured.';

  @override
  String get removeRelayTooltip => 'Remove relay';

  @override
  String get homeRelayTitle => 'Personal home relay';

  @override
  String get homeRelayConfiguredSubtitle =>
      'Extra backup target for your encrypted tasks';

  @override
  String get homeRelaySubtitle =>
      'Optional: add your own relay as an extra backup target. Unlike other relays, this one may also use an unencrypted ws:// address if it\'s on your local network.';

  @override
  String get removeHomeRelayTooltip => 'Remove home relay';

  @override
  String get homeRelayUrlHint => 'wss://your-home-relay, or ws:// on your LAN';

  @override
  String get homeRelayInvalidUrl =>
      'Enter a valid wss:// relay URL (ws:// is only allowed for a home relay on your own network).';

  @override
  String get saveButton => 'Save';

  @override
  String get onboardingSaveError => 'Could not save setup on this device.';

  @override
  String get backButton => 'Back';

  @override
  String get getStartedButton => 'Get started';

  @override
  String get useOfflineButton => 'Use offline';

  @override
  String get nextButton => 'Next';

  @override
  String welcomeTitle(String appName) {
    return 'Welcome to $appName';
  }

  @override
  String get welcomeSubtitle =>
      'A private, focused task manager in the Echoes ecosystem.';

  @override
  String get featureLocalTitle => 'Yours, on your device';

  @override
  String get featureLocalBody =>
      'Tasks are stored locally first in an encrypted database. The app works fully offline — no account required.';

  @override
  String get featureSyncTitle => 'Sync through Nostr';

  @override
  String get featureSyncBody =>
      'Sign in with a Nostr key and your tasks sync across devices through relays you choose — no company server in the middle.';

  @override
  String get featureEncryptedTitle => 'End-to-end encrypted';

  @override
  String get featureEncryptedBody =>
      'Every task is encrypted (NIP-44) before it leaves the device. Relays only ever see ciphertext.';

  @override
  String get featureAmberTitle => 'Amber support';

  @override
  String get featureAmberBody =>
      'On Android you can keep your key in Amber: one sign-in for the whole suite, and no app ever touches the key itself.';

  @override
  String get loginPageTitle => 'Sign in to sync your encrypted tasks';

  @override
  String get loginPageBody =>
      'Use a Nostr identity for optional multi-device sync, or continue without an account and keep everything local.';

  @override
  String get relaySetupTitle => 'Choose your relays';

  @override
  String get relaySetupBody =>
      'Relays store encrypted tasks for synchronization with Kairos on your other devices. Add one or more, or leave this empty and configure sync later.';

  @override
  String get relaySettingsLoadError => 'Could not load relay settings.';

  @override
  String get taskGoneMessage => 'This task no longer exists.';

  @override
  String get taskDetailsTitle => 'Task';

  @override
  String get editTooltip => 'Edit';

  @override
  String get deleteTooltip => 'Delete';

  @override
  String get dueDateLabel => 'Due date';

  @override
  String get noneLabel => 'None';

  @override
  String get tagsLabel => 'Tags';

  @override
  String get priorityLabel => 'Priority';

  @override
  String priorityValue(int priority) {
    return '$priority / 5';
  }

  @override
  String get colorLabel => 'Color';

  @override
  String get syncStatusLabel => 'Sync';

  @override
  String get syncedStatus => 'Published to relays';

  @override
  String get notSyncedStatus => 'Local only (pending sync)';

  @override
  String get linkedEventLabel => 'Linked calendar event';

  @override
  String createdUpdatedInfo(String created, String updated) {
    return 'Created $created\nUpdated $updated';
  }

  @override
  String get deleteTaskConfirmTitle => 'Delete this task?';

  @override
  String get deleteTaskConfirmBody =>
      'The task is removed locally and a deletion request is sent to your relays.';

  @override
  String get deleteButton => 'Delete';

  @override
  String get deleteTaskError => 'Could not delete the task locally.';

  @override
  String get saveTaskError => 'Could not save the task locally.';

  @override
  String get editTaskTitle => 'Edit task';

  @override
  String get newTaskTitle => 'New task';

  @override
  String get syncToNostrTitle => 'Sync to Nostr';

  @override
  String get syncToNostrSubtitle =>
      'Publish this task, encrypted, to your relays. When off, it stays only on this device.';

  @override
  String get syncTaskButton => 'Sync task';

  @override
  String get localOnlyStatus => 'Local only (sync off)';

  @override
  String get titleFieldLabel => 'Title';

  @override
  String get titleRequiredError => 'A title is required.';

  @override
  String get titleTooLongError => 'The title is too long.';

  @override
  String get descriptionFieldLabel => 'Description (optional)';

  @override
  String get noDueDateLabel => 'No due date';

  @override
  String get optionalDeadlineHint => 'Optional deadline.';

  @override
  String get clearDueDateTooltip => 'Clear due date';

  @override
  String get tagsFieldLabel => 'Tags (comma-separated, optional)';

  @override
  String get tagsFieldHint => 'work, personal';

  @override
  String get tooManyTagsError => 'Use at most 32 tags.';

  @override
  String get tagTooLongError => 'Each tag must be at most 64 characters.';

  @override
  String get priorityScaleHint => '1 = low, 5 = high';

  @override
  String get syncNowTooltip => 'Sync now';

  @override
  String get settingsTooltip => 'Settings';

  @override
  String get newTaskTooltip => 'New task';

  @override
  String get loadTasksError => 'Could not load local tasks.';

  @override
  String get emptyTasksTitle => 'No tasks yet';

  @override
  String get emptyTasksBody => 'Tap + to add your first task.';

  @override
  String completedCount(int count) {
    return 'Completed ($count)';
  }

  @override
  String get invalidKeyError =>
      'That private key is not valid. Check it and try again.';

  @override
  String get signInError => 'Could not sign in. Please try again.';

  @override
  String get signInAmberButton => 'Sign in with Amber';

  @override
  String get createAccountButton => 'Create a new account';

  @override
  String get generatedAccountHint =>
      'A generated account can only be recovered with its private key. Back it up from Settings after setup.';

  @override
  String get importKeyButton => 'Import an existing key';

  @override
  String get importKeyFieldLabel => 'nsec or hex private key';

  @override
  String get importButton => 'Import';

  @override
  String get storageFailureMessage =>
      'Kairos could not open its encrypted local database. Restart the app. Do not clear app data; if the problem persists, report it privately.';

  @override
  String get remindersLabel => 'Reminders';

  @override
  String get addReminderButton => 'Add reminder';

  @override
  String get remindersNeedDueDate => 'Set a due date to add reminders';

  @override
  String get removeReminderTooltip => 'Remove reminder';

  @override
  String get reminderAtDueTime => 'At the due time';

  @override
  String reminderMinutesBefore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes before',
      one: '1 minute before',
    );
    return '$_temp0';
  }

  @override
  String reminderHoursBefore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours before',
      one: '1 hour before',
    );
    return '$_temp0';
  }

  @override
  String reminderDaysBefore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days before',
      one: '1 day before',
    );
    return '$_temp0';
  }

  @override
  String maxRemindersReached(int count) {
    return 'A task can have at most $count reminders';
  }

  @override
  String get notificationsTitle => 'Task reminders';

  @override
  String get notificationsSubtitle => 'Notify me before a task is due';

  @override
  String get sectionReminders => 'Reminders';

  @override
  String get addToCalendarTitle => 'Add to Astraea calendar';

  @override
  String get addToCalendarSubtitle =>
      'This task also appears in Astraea\'s calendar and widget, on the day it is due.';

  @override
  String get addToCalendarNeedsSync =>
      'Requires an account, a relay and a due date';
}
