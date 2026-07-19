// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Romanian Moldavian Moldovan (`ro`).
class AppLocalizationsRo extends AppLocalizations {
  AppLocalizationsRo([String locale = 'ro']) : super(locale);

  @override
  String get settingsTitle => 'Setări';

  @override
  String get sectionAccount => 'Cont';

  @override
  String get addAccountTitle => 'Adaugă un cont Nostr';

  @override
  String get addAccountSubtitle => 'Momentan offline, doar local.';

  @override
  String get backupKeyTitle => 'Salvează cheia privată';

  @override
  String get backupKeySubtitle =>
      'Necesară pentru recuperarea acestui cont Nostr.';

  @override
  String get logOut => 'Deconectare';

  @override
  String get sectionSync => 'Sincronizare';

  @override
  String get syncInfoTitle => 'Sincronizare criptată opțională';

  @override
  String get syncInfoBody =>
      'Sarcinile se sincronizează doar atunci când sunt configurate un cont Nostr și cel puțin un releu. Conținutul sarcinilor este criptat NIP-44 înainte de a părăsi acest dispozitiv.';

  @override
  String get sectionRelays => 'Relee';

  @override
  String get sectionAppearance => 'Aspect';

  @override
  String get themeLabel => 'Temă';

  @override
  String get sectionLanguage => 'Limbă';

  @override
  String get langSystem => 'Sistem';

  @override
  String get sectionSupport => 'Suport';

  @override
  String get supportKairosTitle => 'Susține Kairos';

  @override
  String lightningAddressCopied(String address) {
    return 'Nu s-a găsit niciun portofel Lightning — adresă copiată: $address';
  }

  @override
  String get logoutConfirmTitle => 'Te deconectezi?';

  @override
  String get logoutConfirmBody =>
      'Sarcinile tale rămân pe acest dispozitiv. Fără cheie, nu se mai pot sincroniza — asigură-te că ai o copie de rezervă a nsec-ului înainte de a te deconecta.';

  @override
  String get cancelButton => 'Anulează';

  @override
  String get nsecDialogTitle => 'Cheia ta privată (nsec)';

  @override
  String get nsecDialogWarning =>
      'Oricine deține această cheie îți controlează contul. Păstreaz-o într-un manager de parole și nu o distribui niciodată.';

  @override
  String get copyButton => 'Copiază';

  @override
  String get doneButton => 'Gata';

  @override
  String get signedInWithAmber => 'Conectat cu Amber';

  @override
  String signedInWithKey(String npub) {
    return 'Conectat · $npub';
  }

  @override
  String get relayInvalidUrlWss =>
      'Introdu o adresă wss:// validă și criptată a releului.';

  @override
  String get relayUrlHint => 'wss://releul-tău…';

  @override
  String get addRelayTooltip => 'Adaugă releu';

  @override
  String get noRelaysConfigured => 'Niciun releu configurat.';

  @override
  String get removeRelayTooltip => 'Elimină releul';

  @override
  String get homeRelayTitle => 'Releu personal de acasă';

  @override
  String get homeRelayConfiguredSubtitle =>
      'Destinație suplimentară de rezervă pentru sarcinile tale criptate';

  @override
  String get homeRelaySubtitle =>
      'Opțional: adaugă propriul releu ca destinație suplimentară de rezervă. Spre deosebire de celelalte relee, acesta poate folosi și o adresă necriptată ws://, dacă se află în rețeaua ta locală.';

  @override
  String get removeHomeRelayTooltip => 'Elimină releul de acasă';

  @override
  String get homeRelayUrlHint =>
      'wss://releul-tău-de-acasă, sau ws:// în rețeaua locală';

  @override
  String get homeRelayInvalidUrl =>
      'Introdu o adresă wss:// validă a releului (ws:// este permis doar pentru un releu de acasă din propria rețea).';

  @override
  String get saveButton => 'Salvează';

  @override
  String get onboardingSaveError =>
      'Configurarea nu a putut fi salvată pe acest dispozitiv.';

  @override
  String get backButton => 'Înapoi';

  @override
  String get getStartedButton => 'Începe';

  @override
  String get useOfflineButton => 'Utilizează offline';

  @override
  String get nextButton => 'Următorul';

  @override
  String welcomeTitle(String appName) {
    return 'Bine ai venit în $appName';
  }

  @override
  String get welcomeSubtitle =>
      'Un manager de sarcini privat și concentrat, în ecosistemul Echoes.';

  @override
  String get featureLocalTitle => 'Al tău, pe dispozitivul tău';

  @override
  String get featureLocalBody =>
      'Sarcinile sunt stocate mai întâi local, într-o bază de date criptată. Aplicația funcționează complet offline — nu este necesar niciun cont.';

  @override
  String get featureSyncTitle => 'Sincronizare prin Nostr';

  @override
  String get featureSyncBody =>
      'Conectează-te cu o cheie Nostr, iar sarcinile tale se vor sincroniza între dispozitive prin releele alese de tine — fără niciun server al unei companii la mijloc.';

  @override
  String get featureEncryptedTitle => 'Criptare end-to-end';

  @override
  String get featureEncryptedBody =>
      'Fiecare sarcină este criptată (NIP-44) înainte de a părăsi dispozitivul. Releele văd doar textul criptat.';

  @override
  String get featureAmberTitle => 'Suport Amber';

  @override
  String get featureAmberBody =>
      'Pe Android îți poți păstra cheia în Amber: o singură conectare pentru întreaga suită, iar nicio aplicație nu atinge vreodată cheia în sine.';

  @override
  String get loginPageTitle =>
      'Conectează-te pentru a-ți sincroniza sarcinile criptate';

  @override
  String get loginPageBody =>
      'Folosește o identitate Nostr pentru sincronizare opțională pe mai multe dispozitive, sau continuă fără cont și păstrează totul local.';

  @override
  String get relaySetupTitle => 'Alege-ți releele';

  @override
  String get relaySetupBody =>
      'Releele stochează sarcini criptate pentru sincronizarea cu Kairos pe celelalte dispozitive ale tale. Adaugă unul sau mai multe, sau lasă câmpul gol și configurează sincronizarea mai târziu.';

  @override
  String get relaySettingsLoadError =>
      'Setările releelor nu au putut fi încărcate.';

  @override
  String get taskGoneMessage => 'Această sarcină nu mai există.';

  @override
  String get taskDetailsTitle => 'Sarcină';

  @override
  String get editTooltip => 'Editează';

  @override
  String get deleteTooltip => 'Șterge';

  @override
  String get dueDateLabel => 'Termen limită';

  @override
  String get noneLabel => 'Niciunul';

  @override
  String get tagsLabel => 'Etichete';

  @override
  String get priorityLabel => 'Prioritate';

  @override
  String priorityValue(int priority) {
    return '$priority / 5';
  }

  @override
  String get colorLabel => 'Culoare';

  @override
  String get syncStatusLabel => 'Sincronizare';

  @override
  String get syncedStatus => 'Publicat pe relee';

  @override
  String get notSyncedStatus => 'Doar local (sincronizare în așteptare)';

  @override
  String get linkedEventLabel => 'Eveniment de calendar asociat';

  @override
  String createdUpdatedInfo(String created, String updated) {
    return 'Creat $created\nActualizat $updated';
  }

  @override
  String get deleteTaskConfirmTitle => 'Ștergi această sarcină?';

  @override
  String get deleteTaskConfirmBody =>
      'Sarcina este eliminată local, iar o cerere de ștergere este trimisă către releele tale.';

  @override
  String get deleteButton => 'Șterge';

  @override
  String get deleteTaskError => 'Sarcina nu a putut fi ștearsă local.';

  @override
  String get saveTaskError => 'Sarcina nu a putut fi salvată local.';

  @override
  String get editTaskTitle => 'Editează sarcina';

  @override
  String get newTaskTitle => 'Sarcină nouă';

  @override
  String get syncToNostrTitle => 'Sincronizează pe Nostr';

  @override
  String get syncToNostrSubtitle =>
      'Publică sarcina, criptată, pe releele tale. Dacă e dezactivat, rămâne doar pe acest dispozitiv.';

  @override
  String get syncTaskButton => 'Sincronizează sarcina';

  @override
  String get localOnlyStatus => 'Doar local (sincronizare oprită)';

  @override
  String get titleFieldLabel => 'Titlu';

  @override
  String get titleRequiredError => 'Titlul este obligatoriu.';

  @override
  String get titleTooLongError => 'Titlul este prea lung.';

  @override
  String get descriptionFieldLabel => 'Descriere (opțional)';

  @override
  String get noDueDateLabel => 'Fără termen limită';

  @override
  String get optionalDeadlineHint => 'Termen limită opțional.';

  @override
  String get clearDueDateTooltip => 'Șterge termenul limită';

  @override
  String get tagsFieldLabel => 'Etichete (separate prin virgulă, opțional)';

  @override
  String get tagsFieldHint => 'muncă, personal';

  @override
  String get tooManyTagsError => 'Folosește cel mult 32 de etichete.';

  @override
  String get tagTooLongError =>
      'Fiecare etichetă poate avea cel mult 64 de caractere.';

  @override
  String get priorityScaleHint => '1 = scăzută, 5 = ridicată';

  @override
  String get syncNowTooltip => 'Sincronizează acum';

  @override
  String get settingsTooltip => 'Setări';

  @override
  String get newTaskTooltip => 'Sarcină nouă';

  @override
  String get loadTasksError => 'Sarcinile locale nu au putut fi încărcate.';

  @override
  String get emptyTasksTitle => 'Nicio sarcină încă';

  @override
  String get emptyTasksBody => 'Atinge + pentru a adăuga prima ta sarcină.';

  @override
  String completedCount(int count) {
    return 'Finalizate ($count)';
  }

  @override
  String get invalidKeyError =>
      'Această cheie privată nu este validă. Verific-o și încearcă din nou.';

  @override
  String get signInError => 'Conectarea a eșuat. Te rugăm să încerci din nou.';

  @override
  String get signInAmberButton => 'Conectează-te cu Amber';

  @override
  String get createAccountButton => 'Creează un cont nou';

  @override
  String get generatedAccountHint =>
      'Un cont generat poate fi recuperat doar cu cheia sa privată. Fă o copie de rezervă din Setări după configurare.';

  @override
  String get importKeyButton => 'Importă o cheie existentă';

  @override
  String get importKeyFieldLabel => 'nsec sau cheie privată hex';

  @override
  String get importButton => 'Importă';

  @override
  String get storageFailureMessage =>
      'Kairos nu a putut deschide baza de date locală criptată. Repornește aplicația. Nu șterge datele aplicației; dacă problema persistă, raportează-o confidențial.';
}
