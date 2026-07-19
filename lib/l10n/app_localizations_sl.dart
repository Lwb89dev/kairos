// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Slovenian (`sl`).
class AppLocalizationsSl extends AppLocalizations {
  AppLocalizationsSl([String locale = 'sl']) : super(locale);

  @override
  String get settingsTitle => 'Nastavitve';

  @override
  String get sectionAccount => 'Račun';

  @override
  String get addAccountTitle => 'Dodaj Nostr račun';

  @override
  String get addAccountSubtitle => 'Trenutno brez povezave, samo lokalno.';

  @override
  String get backupKeyTitle => 'Varnostno kopiranje zasebnega ključa';

  @override
  String get backupKeySubtitle => 'Potrebno za obnovitev tega Nostr računa.';

  @override
  String get logOut => 'Odjava';

  @override
  String get sectionSync => 'Sinhronizacija';

  @override
  String get syncInfoTitle => 'Neobvezna šifrirana sinhronizacija';

  @override
  String get syncInfoBody =>
      'Opravila se sinhronizirajo samo, ko sta nastavljena Nostr račun in vsaj en rele. Vsebina opravil je šifrirana z NIP-44, preden zapusti to napravo.';

  @override
  String get sectionRelays => 'Releji';

  @override
  String get sectionAppearance => 'Videz';

  @override
  String get themeLabel => 'Tema';

  @override
  String get sectionLanguage => 'Jezik';

  @override
  String get langSystem => 'Sistemsko';

  @override
  String get sectionSupport => 'Podpora';

  @override
  String get supportKairosTitle => 'Podpri Kairos';

  @override
  String lightningAddressCopied(String address) {
    return 'Denarnica Lightning ni bila najdena — naslov je kopiran: $address';
  }

  @override
  String get logoutConfirmTitle => 'Se želite odjaviti?';

  @override
  String get logoutConfirmBody =>
      'Vaša opravila ostanejo na tej napravi. Brez ključa jih ni več mogoče sinhronizirati — pred odjavo se prepričajte, da imate varnostno kopijo svojega nseca.';

  @override
  String get cancelButton => 'Prekliči';

  @override
  String get nsecDialogTitle => 'Vaš zasebni ključ (nsec)';

  @override
  String get nsecDialogWarning =>
      'Kdor koli ima ta ključ, nadzoruje vaš račun. Shranite ga v upravitelja gesel in ga nikoli ne delite.';

  @override
  String get copyButton => 'Kopiraj';

  @override
  String get doneButton => 'Končano';

  @override
  String get signedInWithAmber => 'Prijavljeni z Amber';

  @override
  String signedInWithKey(String npub) {
    return 'Prijavljeni · $npub';
  }

  @override
  String get relayInvalidUrlWss =>
      'Vnesite veljaven šifriran naslov releja wss://.';

  @override
  String get relayUrlHint => 'wss://vaš-rele…';

  @override
  String get addRelayTooltip => 'Dodaj rele';

  @override
  String get noRelaysConfigured => 'Ni nastavljenih relejev.';

  @override
  String get removeRelayTooltip => 'Odstrani rele';

  @override
  String get homeRelayTitle => 'Osebni domači rele';

  @override
  String get homeRelayConfiguredSubtitle =>
      'Dodatna varnostna kopija za vaša šifrirana opravila';

  @override
  String get homeRelaySubtitle =>
      'Neobvezno: dodajte lasten rele kot dodatno varnostno kopijo. Za razliko od drugih relejev lahko ta uporablja tudi nešifriran naslov ws://, če je v vašem lokalnem omrežju.';

  @override
  String get removeHomeRelayTooltip => 'Odstrani domači rele';

  @override
  String get homeRelayUrlHint =>
      'wss://vaš-domači-rele ali ws:// v lokalnem omrežju';

  @override
  String get homeRelayInvalidUrl =>
      'Vnesite veljaven naslov releja wss:// (ws:// je dovoljen samo za domači rele v vašem lastnem omrežju).';

  @override
  String get saveButton => 'Shrani';

  @override
  String get onboardingSaveError =>
      'Nastavitve ni bilo mogoče shraniti na tej napravi.';

  @override
  String get backButton => 'Nazaj';

  @override
  String get getStartedButton => 'Začni';

  @override
  String get useOfflineButton => 'Uporabi brez povezave';

  @override
  String get nextButton => 'Naprej';

  @override
  String welcomeTitle(String appName) {
    return 'Dobrodošli v $appName';
  }

  @override
  String get welcomeSubtitle =>
      'Zaseben, osredotočen upravitelj opravil v ekosistemu Echoes.';

  @override
  String get featureLocalTitle => 'Vaše, na vaši napravi';

  @override
  String get featureLocalBody =>
      'Opravila so najprej shranjena lokalno v šifrirani podatkovni zbirki. Aplikacija deluje popolnoma brez povezave — račun ni potreben.';

  @override
  String get featureSyncTitle => 'Sinhronizacija prek Nostra';

  @override
  String get featureSyncBody =>
      'Prijavite se z Nostr ključem in vaša opravila se sinhronizirajo med napravami prek relejev, ki jih izberete sami — brez podjetniškega strežnika vmes.';

  @override
  String get featureEncryptedTitle => 'Šifrirano od konca do konca';

  @override
  String get featureEncryptedBody =>
      'Vsako opravilo je šifrirano (NIP-44), preden zapusti napravo. Releji vidijo le šifrirano besedilo.';

  @override
  String get featureAmberTitle => 'Podpora za Amber';

  @override
  String get featureAmberBody =>
      'V Androidu lahko svoj ključ hranite v Amberju: ena prijava za celoten nabor aplikacij, pri čemer se nobena aplikacija nikoli ne dotakne samega ključa.';

  @override
  String get loginPageTitle =>
      'Prijavite se za sinhronizacijo šifriranih opravil';

  @override
  String get loginPageBody =>
      'Uporabite Nostr identiteto za neobvezno sinhronizacijo med napravami ali nadaljujte brez računa in obdržite vse lokalno.';

  @override
  String get relaySetupTitle => 'Izberite svoje releje';

  @override
  String get relaySetupBody =>
      'Releji shranjujejo šifrirana opravila za sinhronizacijo s Kairosom na vaših drugih napravah. Dodajte enega ali več ali pustite prazno in sinhronizacijo nastavite pozneje.';

  @override
  String get relaySettingsLoadError =>
      'Nastavitev relejev ni bilo mogoče naložiti.';

  @override
  String get taskGoneMessage => 'To opravilo ne obstaja več.';

  @override
  String get taskDetailsTitle => 'Opravilo';

  @override
  String get editTooltip => 'Uredi';

  @override
  String get deleteTooltip => 'Izbriši';

  @override
  String get dueDateLabel => 'Rok';

  @override
  String get noneLabel => 'Brez';

  @override
  String get tagsLabel => 'Oznake';

  @override
  String get priorityLabel => 'Prioriteta';

  @override
  String priorityValue(int priority) {
    return '$priority / 5';
  }

  @override
  String get colorLabel => 'Barva';

  @override
  String get syncStatusLabel => 'Sinhronizacija';

  @override
  String get syncedStatus => 'Objavljeno na relejih';

  @override
  String get notSyncedStatus => 'Samo lokalno (čaka na sinhronizacijo)';

  @override
  String get linkedEventLabel => 'Povezan dogodek v koledarju';

  @override
  String createdUpdatedInfo(String created, String updated) {
    return 'Ustvarjeno $created\nPosodobljeno $updated';
  }

  @override
  String get deleteTaskConfirmTitle => 'Želite izbrisati to opravilo?';

  @override
  String get deleteTaskConfirmBody =>
      'Opravilo se odstrani lokalno, zahteva za izbris pa se pošlje vašim relejem.';

  @override
  String get deleteButton => 'Izbriši';

  @override
  String get deleteTaskError => 'Opravila ni bilo mogoče lokalno izbrisati.';

  @override
  String get saveTaskError => 'Opravila ni bilo mogoče lokalno shraniti.';

  @override
  String get editTaskTitle => 'Uredi opravilo';

  @override
  String get newTaskTitle => 'Novo opravilo';

  @override
  String get syncToNostrTitle => 'Sinhroniziraj v Nostr';

  @override
  String get syncToNostrSubtitle =>
      'Objavi opravilo, šifrirano, na tvoje releje. Če je izklopljeno, ostane samo v tej napravi.';

  @override
  String get syncTaskButton => 'Sinhroniziraj opravilo';

  @override
  String get localOnlyStatus => 'Samo lokalno (sinhronizacija izklopljena)';

  @override
  String get titleFieldLabel => 'Naslov';

  @override
  String get titleRequiredError => 'Naslov je obvezen.';

  @override
  String get titleTooLongError => 'Naslov je predolg.';

  @override
  String get descriptionFieldLabel => 'Opis (neobvezno)';

  @override
  String get noDueDateLabel => 'Brez roka';

  @override
  String get optionalDeadlineHint => 'Neobvezen rok.';

  @override
  String get clearDueDateTooltip => 'Počisti rok';

  @override
  String get tagsFieldLabel => 'Oznake (ločene z vejico, neobvezno)';

  @override
  String get tagsFieldHint => 'služba, osebno';

  @override
  String get tooManyTagsError => 'Uporabite največ 32 oznak.';

  @override
  String get tagTooLongError => 'Vsaka oznaka sme imeti največ 64 znakov.';

  @override
  String get priorityScaleHint => '1 = nizka, 5 = visoka';

  @override
  String get syncNowTooltip => 'Sinhroniziraj zdaj';

  @override
  String get settingsTooltip => 'Nastavitve';

  @override
  String get newTaskTooltip => 'Novo opravilo';

  @override
  String get loadTasksError => 'Lokalnih opravil ni bilo mogoče naložiti.';

  @override
  String get emptyTasksTitle => 'Še ni opravil';

  @override
  String get emptyTasksBody => 'Tapnite +, da dodate svoje prvo opravilo.';

  @override
  String completedCount(int count) {
    return 'Dokončano ($count)';
  }

  @override
  String get invalidKeyError =>
      'Ta zasebni ključ ni veljaven. Preverite ga in poskusite znova.';

  @override
  String get signInError => 'Prijava ni uspela. Poskusite znova.';

  @override
  String get signInAmberButton => 'Prijava z Amber';

  @override
  String get createAccountButton => 'Ustvari nov račun';

  @override
  String get generatedAccountHint =>
      'Ustvarjen račun je mogoče obnoviti samo z njegovim zasebnim ključem. Po nastavitvi ga varnostno kopirajte v Nastavitvah.';

  @override
  String get importKeyButton => 'Uvozi obstoječi ključ';

  @override
  String get importKeyFieldLabel => 'nsec ali šestnajstiški zasebni ključ';

  @override
  String get importButton => 'Uvozi';

  @override
  String get storageFailureMessage =>
      'Kairos ni mogel odpreti svoje šifrirane lokalne podatkovne zbirke. Znova zaženite aplikacijo. Ne brišite podatkov aplikacije; če se težava nadaljuje, jo prijavite zasebno.';
}
