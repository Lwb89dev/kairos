// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get settingsTitle => 'Ustawienia';

  @override
  String get sectionAccount => 'Konto';

  @override
  String get addAccountTitle => 'Dodaj konto Nostr';

  @override
  String get addAccountSubtitle => 'Obecnie offline, tylko lokalnie.';

  @override
  String get backupKeyTitle => 'Utwórz kopię zapasową klucza prywatnego';

  @override
  String get backupKeySubtitle => 'Wymagana do odzyskania tego konta Nostr.';

  @override
  String get logOut => 'Wyloguj się';

  @override
  String get sectionSync => 'Synchronizacja';

  @override
  String get syncInfoTitle => 'Opcjonalna szyfrowana synchronizacja';

  @override
  String get syncInfoBody =>
      'Zadania synchronizują się tylko wtedy, gdy skonfigurowano konto Nostr i co najmniej jeden przekaźnik. Treść zadań jest szyfrowana za pomocą NIP-44, zanim opuści to urządzenie.';

  @override
  String get sectionRelays => 'Przekaźniki';

  @override
  String get sectionAppearance => 'Wygląd';

  @override
  String get themeLabel => 'Motyw';

  @override
  String get sectionLanguage => 'Język';

  @override
  String get langSystem => 'Systemowy';

  @override
  String get sectionSupport => 'Wsparcie';

  @override
  String get supportKairosTitle => 'Wesprzyj Kairos';

  @override
  String lightningAddressCopied(String address) {
    return 'Nie znaleziono portfela Lightning — adres skopiowany: $address';
  }

  @override
  String get logoutConfirmTitle => 'Wylogować się?';

  @override
  String get logoutConfirmBody =>
      'Twoje zadania pozostaną na tym urządzeniu. Bez klucza nie będą się już synchronizować — upewnij się, że masz kopię zapasową swojego nsec przed wylogowaniem.';

  @override
  String get cancelButton => 'Anuluj';

  @override
  String get nsecDialogTitle => 'Twój klucz prywatny (nsec)';

  @override
  String get nsecDialogWarning =>
      'Każdy, kto ma ten klucz, kontroluje Twoje konto. Przechowuj go w menedżerze haseł i nigdy nikomu go nie udostępniaj.';

  @override
  String get copyButton => 'Kopiuj';

  @override
  String get doneButton => 'Gotowe';

  @override
  String get signedInWithAmber => 'Zalogowano przez Amber';

  @override
  String signedInWithKey(String npub) {
    return 'Zalogowano · $npub';
  }

  @override
  String get relayInvalidUrlWss =>
      'Podaj prawidłowy, szyfrowany adres przekaźnika wss://.';

  @override
  String get relayUrlHint => 'wss://twój-przekaźnik…';

  @override
  String get addRelayTooltip => 'Dodaj przekaźnik';

  @override
  String get noRelaysConfigured => 'Nie skonfigurowano żadnych przekaźników.';

  @override
  String get removeRelayTooltip => 'Usuń przekaźnik';

  @override
  String get homeRelayTitle => 'Osobisty domowy przekaźnik';

  @override
  String get homeRelayConfiguredSubtitle =>
      'Dodatkowy cel kopii zapasowej dla Twoich zaszyfrowanych zadań';

  @override
  String get homeRelaySubtitle =>
      'Opcjonalnie: dodaj własny przekaźnik jako dodatkowy cel kopii zapasowej. W przeciwieństwie do innych przekaźników, ten może używać również nieszyfrowanego adresu ws://, jeśli znajduje się w Twojej sieci lokalnej.';

  @override
  String get removeHomeRelayTooltip => 'Usuń domowy przekaźnik';

  @override
  String get homeRelayUrlHint =>
      'wss://twój-domowy-przekaźnik lub ws:// w sieci LAN';

  @override
  String get homeRelayInvalidUrl =>
      'Podaj prawidłowy adres przekaźnika wss:// (ws:// jest dozwolony tylko dla domowego przekaźnika we własnej sieci).';

  @override
  String get saveButton => 'Zapisz';

  @override
  String get onboardingSaveError =>
      'Nie udało się zapisać konfiguracji na tym urządzeniu.';

  @override
  String get backButton => 'Wstecz';

  @override
  String get getStartedButton => 'Rozpocznij';

  @override
  String get useOfflineButton => 'Używaj offline';

  @override
  String get nextButton => 'Dalej';

  @override
  String welcomeTitle(String appName) {
    return 'Witamy w $appName';
  }

  @override
  String get welcomeSubtitle =>
      'Prywatny, skoncentrowany menedżer zadań w ekosystemie Echoes.';

  @override
  String get featureLocalTitle => 'Twoje, na Twoim urządzeniu';

  @override
  String get featureLocalBody =>
      'Zadania są przechowywane najpierw lokalnie, w zaszyfrowanej bazie danych. Aplikacja działa w pełni offline — konto nie jest wymagane.';

  @override
  String get featureSyncTitle => 'Synchronizacja przez Nostr';

  @override
  String get featureSyncBody =>
      'Zaloguj się kluczem Nostr, a Twoje zadania będą synchronizowane między urządzeniami przez wybrane przez Ciebie przekaźniki — bez firmowego serwera pośrodku.';

  @override
  String get featureEncryptedTitle => 'Szyfrowanie end-to-end';

  @override
  String get featureEncryptedBody =>
      'Każde zadanie jest szyfrowane (NIP-44), zanim opuści urządzenie. Przekaźniki widzą wyłącznie zaszyfrowany tekst.';

  @override
  String get featureAmberTitle => 'Obsługa Amber';

  @override
  String get featureAmberBody =>
      'Na Androidzie możesz przechowywać swój klucz w Amber: jedno logowanie dla całego zestawu aplikacji, a żadna z nich nigdy nie ma dostępu do samego klucza.';

  @override
  String get loginPageTitle =>
      'Zaloguj się, aby synchronizować swoje zaszyfrowane zadania';

  @override
  String get loginPageBody =>
      'Użyj tożsamości Nostr do opcjonalnej synchronizacji między urządzeniami lub kontynuuj bez konta i trzymaj wszystko lokalnie.';

  @override
  String get relaySetupTitle => 'Wybierz swoje przekaźniki';

  @override
  String get relaySetupBody =>
      'Przekaźniki przechowują zaszyfrowane zadania do synchronizacji z Kairos na Twoich innych urządzeniach. Dodaj jeden lub więcej albo zostaw to pole puste i skonfiguruj synchronizację później.';

  @override
  String get relaySettingsLoadError =>
      'Nie udało się wczytać ustawień przekaźników.';

  @override
  String get taskGoneMessage => 'To zadanie już nie istnieje.';

  @override
  String get taskDetailsTitle => 'Zadanie';

  @override
  String get editTooltip => 'Edytuj';

  @override
  String get deleteTooltip => 'Usuń';

  @override
  String get dueDateLabel => 'Termin wykonania';

  @override
  String get noneLabel => 'Brak';

  @override
  String get tagsLabel => 'Tagi';

  @override
  String get priorityLabel => 'Priorytet';

  @override
  String priorityValue(int priority) {
    return '$priority / 5';
  }

  @override
  String get colorLabel => 'Kolor';

  @override
  String get syncStatusLabel => 'Synchronizacja';

  @override
  String get syncedStatus => 'Opublikowano na przekaźnikach';

  @override
  String get notSyncedStatus => 'Tylko lokalnie (oczekuje na synchronizację)';

  @override
  String get linkedEventLabel => 'Powiązane wydarzenie w kalendarzu';

  @override
  String createdUpdatedInfo(String created, String updated) {
    return 'Utworzono $created\nZaktualizowano $updated';
  }

  @override
  String get deleteTaskConfirmTitle => 'Usunąć to zadanie?';

  @override
  String get deleteTaskConfirmBody =>
      'Zadanie zostaje usunięte lokalnie, a żądanie usunięcia jest wysyłane do Twoich przekaźników.';

  @override
  String get deleteButton => 'Usuń';

  @override
  String get deleteTaskError => 'Nie udało się usunąć zadania lokalnie.';

  @override
  String get saveTaskError => 'Nie udało się zapisać zadania lokalnie.';

  @override
  String get editTaskTitle => 'Edytuj zadanie';

  @override
  String get newTaskTitle => 'Nowe zadanie';

  @override
  String get syncToNostrTitle => 'Synchronizuj z Nostr';

  @override
  String get syncToNostrSubtitle =>
      'Publikuje zadanie w postaci zaszyfrowanej na twoich przekaźnikach. Gdy wyłączone, zostaje tylko na tym urządzeniu.';

  @override
  String get syncTaskButton => 'Synchronizuj zadanie';

  @override
  String get localOnlyStatus => 'Tylko lokalnie (synchronizacja wyłączona)';

  @override
  String get titleFieldLabel => 'Tytuł';

  @override
  String get titleRequiredError => 'Tytuł jest wymagany.';

  @override
  String get titleTooLongError => 'Tytuł jest zbyt długi.';

  @override
  String get descriptionFieldLabel => 'Opis (opcjonalnie)';

  @override
  String get noDueDateLabel => 'Bez terminu';

  @override
  String get optionalDeadlineHint => 'Opcjonalny termin.';

  @override
  String get clearDueDateTooltip => 'Wyczyść termin wykonania';

  @override
  String get tagsFieldLabel => 'Tagi (oddzielone przecinkami, opcjonalnie)';

  @override
  String get tagsFieldHint => 'praca, prywatne';

  @override
  String get tooManyTagsError => 'Użyj maksymalnie 32 tagów.';

  @override
  String get tagTooLongError => 'Każdy tag może mieć maksymalnie 64 znaki.';

  @override
  String get priorityScaleHint => '1 = niski, 5 = wysoki';

  @override
  String get syncNowTooltip => 'Synchronizuj teraz';

  @override
  String get settingsTooltip => 'Ustawienia';

  @override
  String get newTaskTooltip => 'Nowe zadanie';

  @override
  String get loadTasksError => 'Nie udało się wczytać lokalnych zadań.';

  @override
  String get emptyTasksTitle => 'Brak zadań';

  @override
  String get emptyTasksBody => 'Dotknij +, aby dodać pierwsze zadanie.';

  @override
  String completedCount(int count) {
    return 'Ukończone ($count)';
  }

  @override
  String get invalidKeyError =>
      'Ten klucz prywatny jest nieprawidłowy. Sprawdź go i spróbuj ponownie.';

  @override
  String get signInError => 'Nie udało się zalogować. Spróbuj ponownie.';

  @override
  String get signInAmberButton => 'Zaloguj się przez Amber';

  @override
  String get createAccountButton => 'Utwórz nowe konto';

  @override
  String get generatedAccountHint =>
      'Wygenerowane konto można odzyskać wyłącznie za pomocą jego klucza prywatnego. Utwórz jego kopię zapasową w Ustawieniach po zakończeniu konfiguracji.';

  @override
  String get importKeyButton => 'Zaimportuj istniejący klucz';

  @override
  String get importKeyFieldLabel => 'nsec lub klucz prywatny w formacie hex';

  @override
  String get importButton => 'Importuj';

  @override
  String get storageFailureMessage =>
      'Kairos nie mógł otworzyć zaszyfrowanej lokalnej bazy danych. Uruchom aplikację ponownie. Nie czyść danych aplikacji; jeśli problem będzie się powtarzał, zgłoś go poufnie.';

  @override
  String get remindersLabel => 'Przypomnienia';

  @override
  String get addReminderButton => 'Dodaj przypomnienie';

  @override
  String get remindersNeedDueDate => 'Ustaw termin, aby dodać przypomnienia';

  @override
  String get removeReminderTooltip => 'Usuń przypomnienie';

  @override
  String get reminderAtDueTime => 'O godzinie terminu';

  @override
  String reminderMinutesBefore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minuty wcześniej',
      many: '$count minut wcześniej',
      few: '$count minuty wcześniej',
      one: '1 minutę wcześniej',
    );
    return '$_temp0';
  }

  @override
  String reminderHoursBefore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count godziny wcześniej',
      many: '$count godzin wcześniej',
      few: '$count godziny wcześniej',
      one: '1 godzinę wcześniej',
    );
    return '$_temp0';
  }

  @override
  String reminderDaysBefore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dnia wcześniej',
      many: '$count dni wcześniej',
      few: '$count dni wcześniej',
      one: '1 dzień wcześniej',
    );
    return '$_temp0';
  }

  @override
  String maxRemindersReached(int count) {
    return 'Zadanie może mieć najwyżej $count przypomnień';
  }

  @override
  String get notificationsTitle => 'Przypomnienia o zadaniach';

  @override
  String get notificationsSubtitle => 'Powiadom mnie przed terminem zadania';

  @override
  String get sectionReminders => 'Przypomnienia';

  @override
  String get addToCalendarTitle => 'Dodaj do kalendarza Astraea';

  @override
  String get addToCalendarSubtitle =>
      'To zadanie pojawi się także w kalendarzu i widżecie Astraea, w dniu terminu.';

  @override
  String get addToCalendarNeedsSync => 'Wymaga konta, przekaźnika i terminu';
}
