// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bulgarian (`bg`).
class AppLocalizationsBg extends AppLocalizations {
  AppLocalizationsBg([String locale = 'bg']) : super(locale);

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get sectionAccount => 'Акаунт';

  @override
  String get addAccountTitle => 'Добавяне на Nostr акаунт';

  @override
  String get addAccountSubtitle => 'В момента офлайн, само локално.';

  @override
  String get backupKeyTitle => 'Архивиране на личен ключ';

  @override
  String get backupKeySubtitle =>
      'Необходим за възстановяване на този Nostr акаунт.';

  @override
  String get logOut => 'Изход';

  @override
  String get sectionSync => 'Синхронизация';

  @override
  String get syncInfoTitle => 'Незадължителна криптирана синхронизация';

  @override
  String get syncInfoBody =>
      'Задачите се синхронизират само когато е конфигуриран Nostr акаунт и поне един релей. Съдържанието на задачите се криптира с NIP-44, преди да напусне това устройство.';

  @override
  String get sectionRelays => 'Релеи';

  @override
  String get sectionAppearance => 'Изглед';

  @override
  String get themeLabel => 'Тема';

  @override
  String get sectionLanguage => 'Език';

  @override
  String get langSystem => 'Системен';

  @override
  String get sectionSupport => 'Подкрепа';

  @override
  String get supportKairosTitle => 'Подкрепете Kairos';

  @override
  String lightningAddressCopied(String address) {
    return 'Не е намерен Lightning портфейл — адресът е копиран: $address';
  }

  @override
  String get logoutConfirmTitle => 'Изход от акаунта?';

  @override
  String get logoutConfirmBody =>
      'Задачите ви остават на това устройство. Без ключа те вече не могат да се синхронизират — уверете се, че имате резервно копие на вашия nsec, преди да излезете.';

  @override
  String get cancelButton => 'Отказ';

  @override
  String get nsecDialogTitle => 'Вашият личен ключ (nsec)';

  @override
  String get nsecDialogWarning =>
      'Всеки, който притежава този ключ, контролира акаунта ви. Съхранявайте го в мениджър на пароли и никога не го споделяйте.';

  @override
  String get copyButton => 'Копиране';

  @override
  String get doneButton => 'Готово';

  @override
  String get signedInWithAmber => 'Вписан с Amber';

  @override
  String signedInWithKey(String npub) {
    return 'Вписан · $npub';
  }

  @override
  String get relayInvalidUrlWss =>
      'Въведете валиден криптиран wss:// адрес на релей.';

  @override
  String get relayUrlHint => 'wss://вашият-релей…';

  @override
  String get addRelayTooltip => 'Добавяне на релей';

  @override
  String get noRelaysConfigured => 'Няма конфигурирани релеи.';

  @override
  String get removeRelayTooltip => 'Премахване на релей';

  @override
  String get homeRelayTitle => 'Личен домашен релей';

  @override
  String get homeRelayConfiguredSubtitle =>
      'Допълнителна цел за архивиране на вашите криптирани задачи';

  @override
  String get homeRelaySubtitle =>
      'По желание: добавете собствен релей като допълнителна цел за архивиране. За разлика от другите релеи, този може да използва и некриптиран ws:// адрес, ако е във вашата локална мрежа.';

  @override
  String get removeHomeRelayTooltip => 'Премахване на домашния релей';

  @override
  String get homeRelayUrlHint =>
      'wss://вашият-домашен-релей, или ws:// в локалната мрежа';

  @override
  String get homeRelayInvalidUrl =>
      'Въведете валиден wss:// адрес на релей (ws:// е разрешен само за домашен релей във вашата собствена мрежа).';

  @override
  String get saveButton => 'Запиши';

  @override
  String get onboardingSaveError =>
      'Настройката не можа да бъде запазена на това устройство.';

  @override
  String get backButton => 'Назад';

  @override
  String get getStartedButton => 'Начало';

  @override
  String get useOfflineButton => 'Използване офлайн';

  @override
  String get nextButton => 'Напред';

  @override
  String welcomeTitle(String appName) {
    return 'Добре дошли в $appName';
  }

  @override
  String get welcomeSubtitle =>
      'Личен, фокусиран мениджър на задачи в екосистемата Echoes.';

  @override
  String get featureLocalTitle => 'Ваши, на вашето устройство';

  @override
  String get featureLocalBody =>
      'Задачите се съхраняват първо локално в криптирана база данни. Приложението работи напълно офлайн — не се изисква акаунт.';

  @override
  String get featureSyncTitle => 'Синхронизация чрез Nostr';

  @override
  String get featureSyncBody =>
      'Впишете се с Nostr ключ и задачите ви се синхронизират между устройствата чрез избрани от вас релеи — без сървър на компания по средата.';

  @override
  String get featureEncryptedTitle => 'Криптирано от край до край';

  @override
  String get featureEncryptedBody =>
      'Всяка задача се криптира (NIP-44), преди да напусне устройството. Релеите виждат само шифрован текст.';

  @override
  String get featureAmberTitle => 'Поддръжка на Amber';

  @override
  String get featureAmberBody =>
      'На Android можете да съхранявате ключа си в Amber: едно вписване за целия пакет приложения, а нито едно приложение не докосва самия ключ.';

  @override
  String get loginPageTitle =>
      'Влезте, за да синхронизирате криптираните си задачи';

  @override
  String get loginPageBody =>
      'Използвайте Nostr идентичност за незадължителна синхронизация между устройства или продължете без акаунт и запазете всичко локално.';

  @override
  String get relaySetupTitle => 'Изберете релеи';

  @override
  String get relaySetupBody =>
      'Релеите съхраняват криптирани задачи за синхронизация с Kairos на другите ви устройства. Добавете един или повече, или оставете това поле празно и конфигурирайте синхронизацията по-късно.';

  @override
  String get relaySettingsLoadError =>
      'Настройките на релеите не можаха да бъдат заредени.';

  @override
  String get taskGoneMessage => 'Тази задача вече не съществува.';

  @override
  String get taskDetailsTitle => 'Задача';

  @override
  String get editTooltip => 'Редактиране';

  @override
  String get deleteTooltip => 'Изтриване';

  @override
  String get dueDateLabel => 'Краен срок';

  @override
  String get noneLabel => 'Няма';

  @override
  String get tagsLabel => 'Етикети';

  @override
  String get priorityLabel => 'Приоритет';

  @override
  String priorityValue(int priority) {
    return '$priority / 5';
  }

  @override
  String get colorLabel => 'Цвят';

  @override
  String get syncStatusLabel => 'Синхронизация';

  @override
  String get syncedStatus => 'Публикувано в релеите';

  @override
  String get notSyncedStatus => 'Само локално (изчаква синхронизация)';

  @override
  String get linkedEventLabel => 'Свързано събитие в календара';

  @override
  String createdUpdatedInfo(String created, String updated) {
    return 'Създадено $created\nОбновено $updated';
  }

  @override
  String get deleteTaskConfirmTitle => 'Изтриване на тази задача?';

  @override
  String get deleteTaskConfirmBody =>
      'Задачата се премахва локално и заявка за изтриване се изпраща до вашите релеи.';

  @override
  String get deleteButton => 'Изтрий';

  @override
  String get deleteTaskError => 'Задачата не можа да бъде изтрита локално.';

  @override
  String get saveTaskError => 'Задачата не можа да бъде запазена локално.';

  @override
  String get editTaskTitle => 'Редактиране на задача';

  @override
  String get newTaskTitle => 'Нова задача';

  @override
  String get syncToNostrTitle => 'Синхронизиране с Nostr';

  @override
  String get syncToNostrSubtitle =>
      'Публикува задачата шифрована на вашите релета. Ако е изключено, тя остава само на това устройство.';

  @override
  String get syncTaskButton => 'Синхронизирай задачата';

  @override
  String get localOnlyStatus => 'Само локално (синхронизацията е изключена)';

  @override
  String get titleFieldLabel => 'Заглавие';

  @override
  String get titleRequiredError => 'Заглавието е задължително.';

  @override
  String get titleTooLongError => 'Заглавието е твърде дълго.';

  @override
  String get descriptionFieldLabel => 'Описание (незадължително)';

  @override
  String get noDueDateLabel => 'Без краен срок';

  @override
  String get optionalDeadlineHint => 'Незадължителен краен срок.';

  @override
  String get clearDueDateTooltip => 'Изчистване на крайния срок';

  @override
  String get tagsFieldLabel =>
      'Етикети (разделени със запетая, незадължително)';

  @override
  String get tagsFieldHint => 'работа, лично';

  @override
  String get tooManyTagsError => 'Използвайте най-много 32 етикета.';

  @override
  String get tagTooLongError =>
      'Всеки етикет трябва да е най-много 64 символа.';

  @override
  String get priorityScaleHint => '1 = нисък, 5 = висок';

  @override
  String get syncNowTooltip => 'Синхронизирай сега';

  @override
  String get settingsTooltip => 'Настройки';

  @override
  String get newTaskTooltip => 'Нова задача';

  @override
  String get loadTasksError => 'Локалните задачи не можаха да бъдат заредени.';

  @override
  String get emptyTasksTitle => 'Все още няма задачи';

  @override
  String get emptyTasksBody => 'Докоснете +, за да добавите първата си задача.';

  @override
  String completedCount(int count) {
    return 'Завършени ($count)';
  }

  @override
  String get invalidKeyError =>
      'Този личен ключ не е валиден. Проверете го и опитайте отново.';

  @override
  String get signInError => 'Неуспешно вписване. Моля, опитайте отново.';

  @override
  String get signInAmberButton => 'Вписване с Amber';

  @override
  String get createAccountButton => 'Създаване на нов акаунт';

  @override
  String get generatedAccountHint =>
      'Генериран акаунт може да бъде възстановен само с личния му ключ. Архивирайте го от Настройки след настройването.';

  @override
  String get importKeyButton => 'Импортиране на съществуващ ключ';

  @override
  String get importKeyFieldLabel => 'nsec или hex личен ключ';

  @override
  String get importButton => 'Импортиране';

  @override
  String get storageFailureMessage =>
      'Kairos не можа да отвори криптираната си локална база данни. Рестартирайте приложението. Не изтривайте данните на приложението; ако проблемът продължава, докладвайте го поверително.';

  @override
  String get remindersLabel => 'Напомняния';

  @override
  String get addReminderButton => 'Добавяне на напомняне';

  @override
  String get remindersNeedDueDate =>
      'Задай краен срок, за да добавиш напомняния';

  @override
  String get removeReminderTooltip => 'Премахване на напомнянето';

  @override
  String get reminderAtDueTime => 'В момента на срока';

  @override
  String reminderMinutesBefore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count минути по-рано',
      one: '1 минута по-рано',
    );
    return '$_temp0';
  }

  @override
  String reminderHoursBefore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count часа по-рано',
      one: '1 час по-рано',
    );
    return '$_temp0';
  }

  @override
  String reminderDaysBefore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count дни по-рано',
      one: '1 ден по-рано',
    );
    return '$_temp0';
  }

  @override
  String maxRemindersReached(int count) {
    return 'Една задача може да има най-много $count напомняния';
  }

  @override
  String get notificationsTitle => 'Напомняния за задачи';

  @override
  String get notificationsSubtitle =>
      'Уведомявай ме преди крайния срок на задача';

  @override
  String get sectionReminders => 'Напомняния';

  @override
  String get addToCalendarTitle => 'Добавяне в календара на Astraea';

  @override
  String get addToCalendarSubtitle =>
      'Тази задача се показва и в календара и приспособлението на Astraea, в деня на срока.';

  @override
  String get addToCalendarNeedsSync => 'Изисква акаунт, реле и краен срок';
}
