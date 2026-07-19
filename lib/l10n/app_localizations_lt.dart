// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Lithuanian (`lt`).
class AppLocalizationsLt extends AppLocalizations {
  AppLocalizationsLt([String locale = 'lt']) : super(locale);

  @override
  String get settingsTitle => 'Nustatymai';

  @override
  String get sectionAccount => 'Paskyra';

  @override
  String get addAccountTitle => 'Pridėti Nostr paskyrą';

  @override
  String get addAccountSubtitle =>
      'Šiuo metu neprisijungta, tik vietinis saugojimas.';

  @override
  String get backupKeyTitle => 'Privataus rakto atsarginė kopija';

  @override
  String get backupKeySubtitle =>
      'Reikalinga norint atkurti šią Nostr paskyrą.';

  @override
  String get logOut => 'Atsijungti';

  @override
  String get sectionSync => 'Sinchronizavimas';

  @override
  String get syncInfoTitle => 'Neprivalomas šifruotas sinchronizavimas';

  @override
  String get syncInfoBody =>
      'Užduotys sinchronizuojamos tik tada, kai sukonfigūruota Nostr paskyra ir bent vienas relė. Užduočių turinys šifruojamas NIP-44 protokolu prieš išsiunčiant iš šio įrenginio.';

  @override
  String get sectionRelays => 'Relės';

  @override
  String get sectionAppearance => 'Išvaizda';

  @override
  String get themeLabel => 'Tema';

  @override
  String get sectionLanguage => 'Kalba';

  @override
  String get langSystem => 'Sistemos';

  @override
  String get sectionSupport => 'Parama';

  @override
  String get supportKairosTitle => 'Paremti Kairos';

  @override
  String lightningAddressCopied(String address) {
    return 'Lightning piniginė nerasta — adresas nukopijuotas: $address';
  }

  @override
  String get logoutConfirmTitle => 'Atsijungti?';

  @override
  String get logoutConfirmBody =>
      'Jūsų užduotys liks šiame įrenginyje. Be rakto jos nebegalės sinchronizuotis — prieš atsijungdami įsitikinkite, kad turite savo nsec atsarginę kopiją.';

  @override
  String get cancelButton => 'Atšaukti';

  @override
  String get nsecDialogTitle => 'Jūsų privatus raktas (nsec)';

  @override
  String get nsecDialogWarning =>
      'Kiekvienas, turintis šį raktą, valdo jūsų paskyrą. Saugokite jį slaptažodžių tvarkyklėje ir niekada nesidalinkite juo.';

  @override
  String get copyButton => 'Kopijuoti';

  @override
  String get doneButton => 'Atlikta';

  @override
  String get signedInWithAmber => 'Prisijungta su Amber';

  @override
  String signedInWithKey(String npub) {
    return 'Prisijungta · $npub';
  }

  @override
  String get relayInvalidUrlWss =>
      'Įveskite galiojantį šifruotą wss:// relės adresą.';

  @override
  String get relayUrlHint => 'wss://jūsų-relė…';

  @override
  String get addRelayTooltip => 'Pridėti relę';

  @override
  String get noRelaysConfigured => 'Nesukonfigūruota jokių relių.';

  @override
  String get removeRelayTooltip => 'Pašalinti relę';

  @override
  String get homeRelayTitle => 'Asmeninė namų relė';

  @override
  String get homeRelayConfiguredSubtitle =>
      'Papildoma atsarginė vieta jūsų šifruotoms užduotims';

  @override
  String get homeRelaySubtitle =>
      'Neprivaloma: pridėkite savo relę kaip papildomą atsarginę vietą. Skirtingai nuo kitų relių, ši gali naudoti ir nešifruotą ws:// adresą, jei ji yra jūsų vietiniame tinkle.';

  @override
  String get removeHomeRelayTooltip => 'Pašalinti namų relę';

  @override
  String get homeRelayUrlHint =>
      'wss://jūsų-namų-relė arba ws:// vietiniame tinkle';

  @override
  String get homeRelayInvalidUrl =>
      'Įveskite galiojantį wss:// relės adresą (ws:// leidžiamas tik namų relei jūsų pačių tinkle).';

  @override
  String get saveButton => 'Išsaugoti';

  @override
  String get onboardingSaveError =>
      'Nepavyko išsaugoti sąrankos šiame įrenginyje.';

  @override
  String get backButton => 'Atgal';

  @override
  String get getStartedButton => 'Pradėti';

  @override
  String get useOfflineButton => 'Naudoti neprisijungus';

  @override
  String get nextButton => 'Toliau';

  @override
  String welcomeTitle(String appName) {
    return 'Sveiki atvykę į $appName';
  }

  @override
  String get welcomeSubtitle =>
      'Privati, sutelkta užduočių tvarkyklė Echoes ekosistemoje.';

  @override
  String get featureLocalTitle => 'Jūsų, jūsų įrenginyje';

  @override
  String get featureLocalBody =>
      'Užduotys iš pradžių saugomos vietoje, šifruotoje duomenų bazėje. Programa veikia visiškai neprisijungus — paskyra nereikalinga.';

  @override
  String get featureSyncTitle => 'Sinchronizavimas per Nostr';

  @override
  String get featureSyncBody =>
      'Prisijunkite su Nostr raktu, ir jūsų užduotys sinchronizuosis tarp įrenginių per jūsų pasirinktas relias — be jokio įmonės serverio tarpininko.';

  @override
  String get featureEncryptedTitle => 'Šifruota visu keliu';

  @override
  String get featureEncryptedBody =>
      'Kiekviena užduotis šifruojama (NIP-44) prieš išsiunčiant iš įrenginio. Relės mato tik šifruotą tekstą.';

  @override
  String get featureAmberTitle => 'Amber palaikymas';

  @override
  String get featureAmberBody =>
      'Sistemoje Android galite laikyti raktą Amber programoje: vienas prisijungimas visai programų šeimai, o raktas nepasiekiamas jokiai programai.';

  @override
  String get loginPageTitle =>
      'Prisijunkite, kad sinchronizuotumėte savo šifruotas užduotis';

  @override
  String get loginPageBody =>
      'Naudokite Nostr tapatybę neprivalomam sinchronizavimui tarp kelių įrenginių arba tęskite be paskyros ir viską laikykite vietoje.';

  @override
  String get relaySetupTitle => 'Pasirinkite savo relias';

  @override
  String get relaySetupBody =>
      'Relės saugo šifruotas užduotis sinchronizavimui su Kairos jūsų kituose įrenginiuose. Pridėkite vieną ar daugiau arba palikite tuščią ir sukonfigūruokite sinchronizavimą vėliau.';

  @override
  String get relaySettingsLoadError => 'Nepavyko įkelti relių nustatymų.';

  @override
  String get taskGoneMessage => 'Ši užduotis nebeegzistuoja.';

  @override
  String get taskDetailsTitle => 'Užduotis';

  @override
  String get editTooltip => 'Redaguoti';

  @override
  String get deleteTooltip => 'Ištrinti';

  @override
  String get dueDateLabel => 'Terminas';

  @override
  String get noneLabel => 'Nėra';

  @override
  String get tagsLabel => 'Žymos';

  @override
  String get priorityLabel => 'Prioritetas';

  @override
  String priorityValue(int priority) {
    return '$priority / 5';
  }

  @override
  String get colorLabel => 'Spalva';

  @override
  String get syncStatusLabel => 'Sinchronizavimas';

  @override
  String get syncedStatus => 'Paskelbta relėse';

  @override
  String get notSyncedStatus => 'Tik vietoje (laukia sinchronizavimo)';

  @override
  String get linkedEventLabel => 'Susietas kalendoriaus įvykis';

  @override
  String createdUpdatedInfo(String created, String updated) {
    return 'Sukurta $created\nAtnaujinta $updated';
  }

  @override
  String get deleteTaskConfirmTitle => 'Ištrinti šią užduotį?';

  @override
  String get deleteTaskConfirmBody =>
      'Užduotis pašalinama vietoje, o ištrynimo užklausa siunčiama jūsų relėms.';

  @override
  String get deleteButton => 'Ištrinti';

  @override
  String get deleteTaskError => 'Nepavyko ištrinti užduoties vietoje.';

  @override
  String get saveTaskError => 'Nepavyko išsaugoti užduoties vietoje.';

  @override
  String get editTaskTitle => 'Redaguoti užduotį';

  @override
  String get newTaskTitle => 'Nauja užduotis';

  @override
  String get syncToNostrTitle => 'Sinchronizuoti su Nostr';

  @override
  String get syncToNostrSubtitle =>
      'Paskelbia užduotį užšifruotą jūsų relėse. Jei išjungta, ji lieka tik šiame įrenginyje.';

  @override
  String get syncTaskButton => 'Sinchronizuoti užduotį';

  @override
  String get localOnlyStatus => 'Tik vietinė (sinchronizavimas išjungtas)';

  @override
  String get titleFieldLabel => 'Pavadinimas';

  @override
  String get titleRequiredError => 'Pavadinimas yra privalomas.';

  @override
  String get titleTooLongError => 'Pavadinimas per ilgas.';

  @override
  String get descriptionFieldLabel => 'Aprašymas (neprivalomas)';

  @override
  String get noDueDateLabel => 'Be termino';

  @override
  String get optionalDeadlineHint => 'Neprivalomas terminas.';

  @override
  String get clearDueDateTooltip => 'Išvalyti terminą';

  @override
  String get tagsFieldLabel => 'Žymos (atskirtos kableliais, neprivaloma)';

  @override
  String get tagsFieldHint => 'darbas, asmeniška';

  @override
  String get tooManyTagsError => 'Naudokite ne daugiau kaip 32 žymas.';

  @override
  String get tagTooLongError =>
      'Kiekviena žyma turi būti ne ilgesnė nei 64 simboliai.';

  @override
  String get priorityScaleHint => '1 = žemas, 5 = aukštas';

  @override
  String get syncNowTooltip => 'Sinchronizuoti dabar';

  @override
  String get settingsTooltip => 'Nustatymai';

  @override
  String get newTaskTooltip => 'Nauja užduotis';

  @override
  String get loadTasksError => 'Nepavyko įkelti vietinių užduočių.';

  @override
  String get emptyTasksTitle => 'Kol kas nėra užduočių';

  @override
  String get emptyTasksBody => 'Palieskite +, kad pridėtumėte pirmą užduotį.';

  @override
  String completedCount(int count) {
    return 'Atlikta ($count)';
  }

  @override
  String get invalidKeyError =>
      'Šis privatus raktas negalioja. Patikrinkite jį ir bandykite dar kartą.';

  @override
  String get signInError => 'Nepavyko prisijungti. Bandykite dar kartą.';

  @override
  String get signInAmberButton => 'Prisijungti su Amber';

  @override
  String get createAccountButton => 'Sukurti naują paskyrą';

  @override
  String get generatedAccountHint =>
      'Sugeneruotą paskyrą galima atkurti tik naudojant jos privatų raktą. Po sąrankos padarykite atsarginę kopiją Nustatymuose.';

  @override
  String get importKeyButton => 'Importuoti esamą raktą';

  @override
  String get importKeyFieldLabel => 'nsec arba šešioliktainis privatus raktas';

  @override
  String get importButton => 'Importuoti';

  @override
  String get storageFailureMessage =>
      'Kairos nepavyko atverti šifruotos vietinės duomenų bazės. Paleiskite programą iš naujo. Nevalykite programos duomenų; jei problema kartojasi, praneškite apie ją privačiai.';
}
