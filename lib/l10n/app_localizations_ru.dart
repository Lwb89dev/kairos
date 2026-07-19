// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get sectionAccount => 'Аккаунт';

  @override
  String get addAccountTitle => 'Добавить аккаунт Nostr';

  @override
  String get addAccountSubtitle => 'Сейчас офлайн, только локально.';

  @override
  String get backupKeyTitle => 'Резервная копия приватного ключа';

  @override
  String get backupKeySubtitle =>
      'Необходима для восстановления этого аккаунта Nostr.';

  @override
  String get logOut => 'Выйти';

  @override
  String get sectionSync => 'Синхронизация';

  @override
  String get syncInfoTitle => 'Необязательная зашифрованная синхронизация';

  @override
  String get syncInfoBody =>
      'Задачи синхронизируются, только если настроены аккаунт Nostr и хотя бы один реле. Содержимое задач шифруется по NIP-44 перед отправкой с устройства.';

  @override
  String get sectionRelays => 'Реле';

  @override
  String get sectionAppearance => 'Внешний вид';

  @override
  String get themeLabel => 'Тема';

  @override
  String get sectionLanguage => 'Язык';

  @override
  String get langSystem => 'Системный';

  @override
  String get sectionSupport => 'Поддержка';

  @override
  String get supportKairosTitle => 'Поддержать Kairos';

  @override
  String lightningAddressCopied(String address) {
    return 'Кошелёк Lightning не найден — адрес скопирован: $address';
  }

  @override
  String get logoutConfirmTitle => 'Выйти из аккаунта?';

  @override
  String get logoutConfirmBody =>
      'Ваши задачи останутся на этом устройстве. Без ключа их больше нельзя будет синхронизировать — убедитесь, что у вас есть резервная копия nsec, прежде чем выходить.';

  @override
  String get cancelButton => 'Отмена';

  @override
  String get nsecDialogTitle => 'Ваш приватный ключ (nsec)';

  @override
  String get nsecDialogWarning =>
      'Любой, кто получит этот ключ, сможет управлять вашим аккаунтом. Храните его в менеджере паролей и никогда никому не показывайте.';

  @override
  String get copyButton => 'Копировать';

  @override
  String get doneButton => 'Готово';

  @override
  String get signedInWithAmber => 'Вход выполнен через Amber';

  @override
  String signedInWithKey(String npub) {
    return 'Вход выполнен · $npub';
  }

  @override
  String get relayInvalidUrlWss =>
      'Введите корректный зашифрованный адрес реле wss://.';

  @override
  String get relayUrlHint => 'wss://ваш-реле…';

  @override
  String get addRelayTooltip => 'Добавить реле';

  @override
  String get noRelaysConfigured => 'Реле не настроены.';

  @override
  String get removeRelayTooltip => 'Удалить реле';

  @override
  String get homeRelayTitle => 'Личный домашний реле';

  @override
  String get homeRelayConfiguredSubtitle =>
      'Дополнительная цель резервного копирования для ваших зашифрованных задач';

  @override
  String get homeRelaySubtitle =>
      'Необязательно: добавьте свой реле как дополнительную цель резервного копирования. В отличие от других реле, этот может использовать и незашифрованный адрес ws://, если находится в вашей локальной сети.';

  @override
  String get removeHomeRelayTooltip => 'Удалить домашний реле';

  @override
  String get homeRelayUrlHint =>
      'wss://ваш-домашний-реле или ws:// в локальной сети';

  @override
  String get homeRelayInvalidUrl =>
      'Введите корректный адрес реле wss:// (ws:// разрешён только для домашнего реле в вашей собственной сети).';

  @override
  String get saveButton => 'Сохранить';

  @override
  String get onboardingSaveError =>
      'Не удалось сохранить настройки на этом устройстве.';

  @override
  String get backButton => 'Назад';

  @override
  String get getStartedButton => 'Начать';

  @override
  String get useOfflineButton => 'Использовать офлайн';

  @override
  String get nextButton => 'Далее';

  @override
  String welcomeTitle(String appName) {
    return 'Добро пожаловать в $appName';
  }

  @override
  String get welcomeSubtitle =>
      'Приватный, сфокусированный менеджер задач в экосистеме Echoes.';

  @override
  String get featureLocalTitle => 'Ваше, на вашем устройстве';

  @override
  String get featureLocalBody =>
      'Задачи сначала сохраняются локально в зашифрованной базе данных. Приложение полностью работает офлайн — аккаунт не требуется.';

  @override
  String get featureSyncTitle => 'Синхронизация через Nostr';

  @override
  String get featureSyncBody =>
      'Войдите с ключом Nostr, и ваши задачи будут синхронизироваться между устройствами через выбранные вами реле — без сервера компании посередине.';

  @override
  String get featureEncryptedTitle => 'Сквозное шифрование';

  @override
  String get featureEncryptedBody =>
      'Каждая задача шифруется (NIP-44) перед тем, как покинуть устройство. Реле видят только зашифрованный текст.';

  @override
  String get featureAmberTitle => 'Поддержка Amber';

  @override
  String get featureAmberBody =>
      'На Android вы можете хранить ключ в Amber: один вход для всего набора приложений, и ни одно из них никогда не касается самого ключа.';

  @override
  String get loginPageTitle =>
      'Войдите, чтобы синхронизировать ваши зашифрованные задачи';

  @override
  String get loginPageBody =>
      'Используйте личность Nostr для необязательной синхронизации между устройствами или продолжите без аккаунта и храните всё локально.';

  @override
  String get relaySetupTitle => 'Выберите ваши реле';

  @override
  String get relaySetupBody =>
      'Реле хранят зашифрованные задачи для синхронизации с Kairos на других ваших устройствах. Добавьте один или несколько или оставьте это поле пустым и настройте синхронизацию позже.';

  @override
  String get relaySettingsLoadError => 'Не удалось загрузить настройки реле.';

  @override
  String get taskGoneMessage => 'Эта задача больше не существует.';

  @override
  String get taskDetailsTitle => 'Задача';

  @override
  String get editTooltip => 'Редактировать';

  @override
  String get deleteTooltip => 'Удалить';

  @override
  String get dueDateLabel => 'Срок выполнения';

  @override
  String get noneLabel => 'Нет';

  @override
  String get tagsLabel => 'Теги';

  @override
  String get priorityLabel => 'Приоритет';

  @override
  String priorityValue(int priority) {
    return '$priority / 5';
  }

  @override
  String get colorLabel => 'Цвет';

  @override
  String get syncStatusLabel => 'Синхронизация';

  @override
  String get syncedStatus => 'Опубликовано на реле';

  @override
  String get notSyncedStatus => 'Только локально (ожидает синхронизации)';

  @override
  String get linkedEventLabel => 'Связанное событие календаря';

  @override
  String createdUpdatedInfo(String created, String updated) {
    return 'Создано $created\nОбновлено $updated';
  }

  @override
  String get deleteTaskConfirmTitle => 'Удалить эту задачу?';

  @override
  String get deleteTaskConfirmBody =>
      'Задача удаляется локально, а запрос на удаление отправляется на ваши реле.';

  @override
  String get deleteButton => 'Удалить';

  @override
  String get deleteTaskError => 'Не удалось удалить задачу локально.';

  @override
  String get saveTaskError => 'Не удалось сохранить задачу локально.';

  @override
  String get editTaskTitle => 'Редактировать задачу';

  @override
  String get newTaskTitle => 'Новая задача';

  @override
  String get titleFieldLabel => 'Название';

  @override
  String get titleRequiredError => 'Необходимо указать название.';

  @override
  String get titleTooLongError => 'Название слишком длинное.';

  @override
  String get descriptionFieldLabel => 'Описание (необязательно)';

  @override
  String get noDueDateLabel => 'Без срока';

  @override
  String get optionalDeadlineHint => 'Необязательный срок.';

  @override
  String get clearDueDateTooltip => 'Очистить срок выполнения';

  @override
  String get tagsFieldLabel => 'Теги (через запятую, необязательно)';

  @override
  String get tagsFieldHint => 'работа, личное';

  @override
  String get tooManyTagsError => 'Используйте не более 32 тегов.';

  @override
  String get tagTooLongError =>
      'Каждый тег должен содержать не более 64 символов.';

  @override
  String get priorityScaleHint => '1 = низкий, 5 = высокий';

  @override
  String get syncNowTooltip => 'Синхронизировать сейчас';

  @override
  String get settingsTooltip => 'Настройки';

  @override
  String get newTaskTooltip => 'Новая задача';

  @override
  String get loadTasksError => 'Не удалось загрузить локальные задачи.';

  @override
  String get emptyTasksTitle => 'Пока нет задач';

  @override
  String get emptyTasksBody => 'Нажмите +, чтобы добавить первую задачу.';

  @override
  String completedCount(int count) {
    return 'Выполнено ($count)';
  }

  @override
  String get invalidKeyError =>
      'Этот приватный ключ недействителен. Проверьте его и попробуйте снова.';

  @override
  String get signInError => 'Не удалось войти. Попробуйте ещё раз.';

  @override
  String get signInAmberButton => 'Войти через Amber';

  @override
  String get createAccountButton => 'Создать новый аккаунт';

  @override
  String get generatedAccountHint =>
      'Сгенерированный аккаунт можно восстановить только с помощью его приватного ключа. Сделайте резервную копию в настройках после завершения установки.';

  @override
  String get importKeyButton => 'Импортировать существующий ключ';

  @override
  String get importKeyFieldLabel => 'nsec или приватный ключ в hex';

  @override
  String get importButton => 'Импортировать';

  @override
  String get storageFailureMessage =>
      'Kairos не удалось открыть зашифрованную локальную базу данных. Перезапустите приложение. Не удаляйте данные приложения; если проблема не исчезнет, сообщите о ней конфиденциально.';
}
