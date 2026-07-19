// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Croatian (`hr`).
class AppLocalizationsHr extends AppLocalizations {
  AppLocalizationsHr([String locale = 'hr']) : super(locale);

  @override
  String get settingsTitle => 'Postavke';

  @override
  String get sectionAccount => 'Račun';

  @override
  String get addAccountTitle => 'Dodaj Nostr račun';

  @override
  String get addAccountSubtitle => 'Trenutno izvan mreže, samo lokalno.';

  @override
  String get backupKeyTitle => 'Sigurnosna kopija privatnog ključa';

  @override
  String get backupKeySubtitle => 'Potrebno za oporavak ovog Nostr računa.';

  @override
  String get logOut => 'Odjava';

  @override
  String get sectionSync => 'Sinkronizacija';

  @override
  String get syncInfoTitle => 'Neobavezna šifrirana sinkronizacija';

  @override
  String get syncInfoBody =>
      'Zadaci se sinkroniziraju samo kada su konfigurirani Nostr račun i barem jedan relej. Sadržaj zadataka šifrira se NIP-44 protokolom prije nego što napusti ovaj uređaj.';

  @override
  String get sectionRelays => 'Releji';

  @override
  String get sectionAppearance => 'Izgled';

  @override
  String get themeLabel => 'Tema';

  @override
  String get sectionLanguage => 'Jezik';

  @override
  String get langSystem => 'Sustav';

  @override
  String get sectionSupport => 'Podrška';

  @override
  String get supportKairosTitle => 'Podrži Kairos';

  @override
  String lightningAddressCopied(String address) {
    return 'Nije pronađen Lightning novčanik — adresa je kopirana: $address';
  }

  @override
  String get logoutConfirmTitle => 'Odjaviti se?';

  @override
  String get logoutConfirmBody =>
      'Vaši zadaci ostaju na ovom uređaju. Bez ključa se više ne mogu sinkronizirati — provjerite imate li sigurnosnu kopiju svog nseca prije odjave.';

  @override
  String get cancelButton => 'Odustani';

  @override
  String get nsecDialogTitle => 'Vaš privatni ključ (nsec)';

  @override
  String get nsecDialogWarning =>
      'Svatko tko ima ovaj ključ kontrolira vaš račun. Pohranite ga u upravitelj lozinki i nikada ga ne dijelite.';

  @override
  String get copyButton => 'Kopiraj';

  @override
  String get doneButton => 'Gotovo';

  @override
  String get signedInWithAmber => 'Prijavljeni putem Amber-a';

  @override
  String signedInWithKey(String npub) {
    return 'Prijavljeni · $npub';
  }

  @override
  String get relayInvalidUrlWss =>
      'Unesite valjan šifrirani wss:// URL releja.';

  @override
  String get relayUrlHint => 'wss://vaš-relej…';

  @override
  String get addRelayTooltip => 'Dodaj relej';

  @override
  String get noRelaysConfigured => 'Nema konfiguriranih releja.';

  @override
  String get removeRelayTooltip => 'Ukloni relej';

  @override
  String get homeRelayTitle => 'Osobni matični relej';

  @override
  String get homeRelayConfiguredSubtitle =>
      'Dodatna sigurnosna kopija za vaše šifrirane zadatke';

  @override
  String get homeRelaySubtitle =>
      'Neobavezno: dodajte vlastiti relej kao dodatnu sigurnosnu kopiju. Za razliku od ostalih releja, ovaj može koristiti i nešifriranu ws:// adresu ako je u vašoj lokalnoj mreži.';

  @override
  String get removeHomeRelayTooltip => 'Ukloni matični relej';

  @override
  String get homeRelayUrlHint =>
      'wss://vaš-matični-relej, ili ws:// u lokalnoj mreži';

  @override
  String get homeRelayInvalidUrl =>
      'Unesite valjan wss:// URL releja (ws:// je dopušten samo za matični relej u vašoj vlastitoj mreži).';

  @override
  String get saveButton => 'Spremi';

  @override
  String get onboardingSaveError =>
      'Postavljanje se nije moglo spremiti na ovom uređaju.';

  @override
  String get backButton => 'Natrag';

  @override
  String get getStartedButton => 'Započni';

  @override
  String get useOfflineButton => 'Koristi izvan mreže';

  @override
  String get nextButton => 'Dalje';

  @override
  String welcomeTitle(String appName) {
    return 'Dobrodošli u $appName';
  }

  @override
  String get welcomeSubtitle =>
      'Privatni, fokusirani upravitelj zadataka u Echoes ekosustavu.';

  @override
  String get featureLocalTitle => 'Vaše, na vašem uređaju';

  @override
  String get featureLocalBody =>
      'Zadaci se prvo lokalno pohranjuju u šifriranu bazu podataka. Aplikacija radi potpuno izvan mreže — račun nije potreban.';

  @override
  String get featureSyncTitle => 'Sinkronizacija putem Nostra';

  @override
  String get featureSyncBody =>
      'Prijavite se Nostr ključem i vaši se zadaci sinkroniziraju između uređaja putem releja koje sami odaberete — bez tvrtkinog poslužitelja u sredini.';

  @override
  String get featureEncryptedTitle => 'Šifrirano od kraja do kraja';

  @override
  String get featureEncryptedBody =>
      'Svaki zadatak je šifriran (NIP-44) prije nego što napusti uređaj. Releji vide samo šifrirani tekst.';

  @override
  String get featureAmberTitle => 'Podrška za Amber';

  @override
  String get featureAmberBody =>
      'Na Androidu možete čuvati svoj ključ u Amberu: jedna prijava za cijeli paket aplikacija, a nijedna aplikacija nikada ne dodiruje sam ključ.';

  @override
  String get loginPageTitle =>
      'Prijavite se za sinkronizaciju šifriranih zadataka';

  @override
  String get loginPageBody =>
      'Koristite Nostr identitet za neobaveznu sinkronizaciju na više uređaja ili nastavite bez računa i zadržite sve lokalno.';

  @override
  String get relaySetupTitle => 'Odaberite svoje releje';

  @override
  String get relaySetupBody =>
      'Releji pohranjuju šifrirane zadatke radi sinkronizacije s Kairosom na vašim drugim uređajima. Dodajte jedan ili više, ili ostavite prazno i konfigurirajte sinkronizaciju kasnije.';

  @override
  String get relaySettingsLoadError =>
      'Postavke releja nije bilo moguće učitati.';

  @override
  String get taskGoneMessage => 'Ovaj zadatak više ne postoji.';

  @override
  String get taskDetailsTitle => 'Zadatak';

  @override
  String get editTooltip => 'Uredi';

  @override
  String get deleteTooltip => 'Izbriši';

  @override
  String get dueDateLabel => 'Rok';

  @override
  String get noneLabel => 'Nema';

  @override
  String get tagsLabel => 'Oznake';

  @override
  String get priorityLabel => 'Prioritet';

  @override
  String priorityValue(int priority) {
    return '$priority / 5';
  }

  @override
  String get colorLabel => 'Boja';

  @override
  String get syncStatusLabel => 'Sinkronizacija';

  @override
  String get syncedStatus => 'Objavljeno na relejima';

  @override
  String get notSyncedStatus => 'Samo lokalno (čeka sinkronizaciju)';

  @override
  String get linkedEventLabel => 'Povezani događaj u kalendaru';

  @override
  String createdUpdatedInfo(String created, String updated) {
    return 'Stvoreno $created\nAžurirano $updated';
  }

  @override
  String get deleteTaskConfirmTitle => 'Izbrisati ovaj zadatak?';

  @override
  String get deleteTaskConfirmBody =>
      'Zadatak se uklanja lokalno, a zahtjev za brisanje šalje se vašim relejima.';

  @override
  String get deleteButton => 'Izbriši';

  @override
  String get deleteTaskError => 'Zadatak se nije mogao lokalno izbrisati.';

  @override
  String get saveTaskError => 'Zadatak se nije mogao lokalno spremiti.';

  @override
  String get editTaskTitle => 'Uredi zadatak';

  @override
  String get newTaskTitle => 'Novi zadatak';

  @override
  String get titleFieldLabel => 'Naslov';

  @override
  String get titleRequiredError => 'Naslov je obavezan.';

  @override
  String get titleTooLongError => 'Naslov je predugačak.';

  @override
  String get descriptionFieldLabel => 'Opis (neobavezno)';

  @override
  String get noDueDateLabel => 'Bez roka';

  @override
  String get optionalDeadlineHint => 'Neobavezni rok.';

  @override
  String get clearDueDateTooltip => 'Ukloni rok';

  @override
  String get tagsFieldLabel => 'Oznake (odvojene zarezom, neobavezno)';

  @override
  String get tagsFieldHint => 'posao, osobno';

  @override
  String get tooManyTagsError => 'Koristite najviše 32 oznake.';

  @override
  String get tagTooLongError => 'Svaka oznaka smije imati najviše 64 znaka.';

  @override
  String get priorityScaleHint => '1 = nizak, 5 = visok';

  @override
  String get syncNowTooltip => 'Sinkroniziraj sada';

  @override
  String get settingsTooltip => 'Postavke';

  @override
  String get newTaskTooltip => 'Novi zadatak';

  @override
  String get loadTasksError => 'Lokalne zadatke nije bilo moguće učitati.';

  @override
  String get emptyTasksTitle => 'Još nema zadataka';

  @override
  String get emptyTasksBody => 'Dodirnite + za dodavanje prvog zadatka.';

  @override
  String completedCount(int count) {
    return 'Dovršeno ($count)';
  }

  @override
  String get invalidKeyError =>
      'Taj privatni ključ nije valjan. Provjerite ga i pokušajte ponovno.';

  @override
  String get signInError => 'Prijava nije uspjela. Pokušajte ponovno.';

  @override
  String get signInAmberButton => 'Prijava putem Amber-a';

  @override
  String get createAccountButton => 'Stvori novi račun';

  @override
  String get generatedAccountHint =>
      'Generirani račun može se oporaviti samo pomoću privatnog ključa. Napravite sigurnosnu kopiju u Postavkama nakon postavljanja.';

  @override
  String get importKeyButton => 'Uvezi postojeći ključ';

  @override
  String get importKeyFieldLabel => 'nsec ili hex privatni ključ';

  @override
  String get importButton => 'Uvezi';

  @override
  String get storageFailureMessage =>
      'Kairos nije mogao otvoriti svoju šifriranu lokalnu bazu podataka. Ponovno pokrenite aplikaciju. Ne brišite podatke aplikacije; ako se problem nastavi, prijavite ga privatno.';
}
