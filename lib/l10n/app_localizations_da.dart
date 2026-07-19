// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Danish (`da`).
class AppLocalizationsDa extends AppLocalizations {
  AppLocalizationsDa([String locale = 'da']) : super(locale);

  @override
  String get settingsTitle => 'Indstillinger';

  @override
  String get sectionAccount => 'Konto';

  @override
  String get addAccountTitle => 'Tilføj en Nostr-konto';

  @override
  String get addAccountSubtitle => 'I øjeblikket offline, kun lokalt.';

  @override
  String get backupKeyTitle => 'Sikkerhedskopiér privat nøgle';

  @override
  String get backupKeySubtitle => 'Påkrævet for at gendanne denne Nostr-konto.';

  @override
  String get logOut => 'Log ud';

  @override
  String get sectionSync => 'Synkronisering';

  @override
  String get syncInfoTitle => 'Valgfri krypteret synkronisering';

  @override
  String get syncInfoBody =>
      'Opgaver synkroniseres kun, når en Nostr-konto og mindst ét relæ er konfigureret. Opgaveindhold krypteres med NIP-44, før det forlader denne enhed.';

  @override
  String get sectionRelays => 'Relæer';

  @override
  String get sectionAppearance => 'Udseende';

  @override
  String get themeLabel => 'Tema';

  @override
  String get sectionLanguage => 'Sprog';

  @override
  String get langSystem => 'System';

  @override
  String get sectionSupport => 'Support';

  @override
  String get supportKairosTitle => 'Støt Kairos';

  @override
  String lightningAddressCopied(String address) {
    return 'Ingen Lightning-wallet fundet — adresse kopieret: $address';
  }

  @override
  String get logoutConfirmTitle => 'Log ud?';

  @override
  String get logoutConfirmBody =>
      'Dine opgaver forbliver på denne enhed. Uden nøglen kan de ikke længere synkroniseres — sørg for, at du har en sikkerhedskopi af din nsec, før du logger ud.';

  @override
  String get cancelButton => 'Annuller';

  @override
  String get nsecDialogTitle => 'Din private nøgle (nsec)';

  @override
  String get nsecDialogWarning =>
      'Alle med denne nøgle har kontrol over din konto. Opbevar den i en adgangskodemanager, og del den aldrig.';

  @override
  String get copyButton => 'Kopiér';

  @override
  String get doneButton => 'Færdig';

  @override
  String get signedInWithAmber => 'Logget ind med Amber';

  @override
  String signedInWithKey(String npub) {
    return 'Logget ind · $npub';
  }

  @override
  String get relayInvalidUrlWss =>
      'Indtast en gyldig krypteret wss://-relæ-URL.';

  @override
  String get relayUrlHint => 'wss://dit-relæ…';

  @override
  String get addRelayTooltip => 'Tilføj relæ';

  @override
  String get noRelaysConfigured => 'Ingen relæer konfigureret.';

  @override
  String get removeRelayTooltip => 'Fjern relæ';

  @override
  String get homeRelayTitle => 'Personligt hjemmerelæ';

  @override
  String get homeRelayConfiguredSubtitle =>
      'Ekstra backupmål for dine krypterede opgaver';

  @override
  String get homeRelaySubtitle =>
      'Valgfrit: tilføj dit eget relæ som et ekstra backupmål. I modsætning til andre relæer kan dette også bruge en ukrypteret ws://-adresse, hvis det er på dit lokale netværk.';

  @override
  String get removeHomeRelayTooltip => 'Fjern hjemmerelæ';

  @override
  String get homeRelayUrlHint => 'wss://dit-hjemmerelæ, eller ws:// på dit LAN';

  @override
  String get homeRelayInvalidUrl =>
      'Indtast en gyldig wss://-relæ-URL (ws:// er kun tilladt for et hjemmerelæ på dit eget netværk).';

  @override
  String get saveButton => 'Gem';

  @override
  String get onboardingSaveError =>
      'Kunne ikke gemme opsætningen på denne enhed.';

  @override
  String get backButton => 'Tilbage';

  @override
  String get getStartedButton => 'Kom i gang';

  @override
  String get useOfflineButton => 'Brug offline';

  @override
  String get nextButton => 'Næste';

  @override
  String welcomeTitle(String appName) {
    return 'Velkommen til $appName';
  }

  @override
  String get welcomeSubtitle =>
      'En privat, fokuseret opgavehåndtering i Echoes-økosystemet.';

  @override
  String get featureLocalTitle => 'Din, på din enhed';

  @override
  String get featureLocalBody =>
      'Opgaver gemmes først lokalt i en krypteret database. Appen fungerer helt offline — ingen konto påkrævet.';

  @override
  String get featureSyncTitle => 'Synkronisering via Nostr';

  @override
  String get featureSyncBody =>
      'Log ind med en Nostr-nøgle, og dine opgaver synkroniseres på tværs af enheder via de relæer, du vælger — uden en virksomhedsserver imellem.';

  @override
  String get featureEncryptedTitle => 'End-to-end-krypteret';

  @override
  String get featureEncryptedBody =>
      'Hver opgave krypteres (NIP-44), før den forlader enheden. Relæer ser kun krypteret tekst.';

  @override
  String get featureAmberTitle => 'Amber-understøttelse';

  @override
  String get featureAmberBody =>
      'På Android kan du opbevare din nøgle i Amber: ét login for hele suiten, og ingen app rører nogensinde selve nøglen.';

  @override
  String get loginPageTitle =>
      'Log ind for at synkronisere dine krypterede opgaver';

  @override
  String get loginPageBody =>
      'Brug en Nostr-identitet til valgfri synkronisering på tværs af enheder, eller fortsæt uden en konto og behold alt lokalt.';

  @override
  String get relaySetupTitle => 'Vælg dine relæer';

  @override
  String get relaySetupBody =>
      'Relæer gemmer krypterede opgaver til synkronisering med Kairos på dine andre enheder. Tilføj et eller flere, eller lad dette stå tomt og konfigurér synkronisering senere.';

  @override
  String get relaySettingsLoadError =>
      'Kunne ikke indlæse relæindstillingerne.';

  @override
  String get taskGoneMessage => 'Denne opgave findes ikke længere.';

  @override
  String get taskDetailsTitle => 'Opgave';

  @override
  String get editTooltip => 'Rediger';

  @override
  String get deleteTooltip => 'Slet';

  @override
  String get dueDateLabel => 'Forfaldsdato';

  @override
  String get noneLabel => 'Ingen';

  @override
  String get tagsLabel => 'Tags';

  @override
  String get priorityLabel => 'Prioritet';

  @override
  String priorityValue(int priority) {
    return '$priority / 5';
  }

  @override
  String get colorLabel => 'Farve';

  @override
  String get syncStatusLabel => 'Synkronisering';

  @override
  String get syncedStatus => 'Udgivet til relæer';

  @override
  String get notSyncedStatus => 'Kun lokal (synkronisering afventer)';

  @override
  String get linkedEventLabel => 'Tilknyttet kalenderbegivenhed';

  @override
  String createdUpdatedInfo(String created, String updated) {
    return 'Oprettet $created\nOpdateret $updated';
  }

  @override
  String get deleteTaskConfirmTitle => 'Slet denne opgave?';

  @override
  String get deleteTaskConfirmBody =>
      'Opgaven fjernes lokalt, og en sletteanmodning sendes til dine relæer.';

  @override
  String get deleteButton => 'Slet';

  @override
  String get deleteTaskError => 'Opgaven kunne ikke slettes lokalt.';

  @override
  String get saveTaskError => 'Opgaven kunne ikke gemmes lokalt.';

  @override
  String get editTaskTitle => 'Rediger opgave';

  @override
  String get newTaskTitle => 'Ny opgave';

  @override
  String get syncToNostrTitle => 'Synkroniser til Nostr';

  @override
  String get syncToNostrSubtitle =>
      'Udgiver opgaven krypteret til dine relæer. Hvis fra, bliver den kun på denne enhed.';

  @override
  String get syncTaskButton => 'Synkroniser opgave';

  @override
  String get localOnlyStatus => 'Kun lokalt (synk fra)';

  @override
  String get titleFieldLabel => 'Titel';

  @override
  String get titleRequiredError => 'En titel er påkrævet.';

  @override
  String get titleTooLongError => 'Titlen er for lang.';

  @override
  String get descriptionFieldLabel => 'Beskrivelse (valgfri)';

  @override
  String get noDueDateLabel => 'Ingen forfaldsdato';

  @override
  String get optionalDeadlineHint => 'Valgfri deadline.';

  @override
  String get clearDueDateTooltip => 'Ryd forfaldsdato';

  @override
  String get tagsFieldLabel => 'Tags (kommaseparerede, valgfrit)';

  @override
  String get tagsFieldHint => 'arbejde, privat';

  @override
  String get tooManyTagsError => 'Brug højst 32 tags.';

  @override
  String get tagTooLongError => 'Hvert tag må højst være 64 tegn langt.';

  @override
  String get priorityScaleHint => '1 = lav, 5 = høj';

  @override
  String get syncNowTooltip => 'Synkroniser nu';

  @override
  String get settingsTooltip => 'Indstillinger';

  @override
  String get newTaskTooltip => 'Ny opgave';

  @override
  String get loadTasksError => 'Kunne ikke indlæse lokale opgaver.';

  @override
  String get emptyTasksTitle => 'Ingen opgaver endnu';

  @override
  String get emptyTasksBody => 'Tryk på + for at tilføje din første opgave.';

  @override
  String completedCount(int count) {
    return 'Fuldført ($count)';
  }

  @override
  String get invalidKeyError =>
      'Den private nøgle er ikke gyldig. Tjek den, og prøv igen.';

  @override
  String get signInError => 'Kunne ikke logge ind. Prøv igen.';

  @override
  String get signInAmberButton => 'Log ind med Amber';

  @override
  String get createAccountButton => 'Opret en ny konto';

  @override
  String get generatedAccountHint =>
      'En genereret konto kan kun gendannes med sin private nøgle. Sikkerhedskopiér den fra Indstillinger efter opsætningen.';

  @override
  String get importKeyButton => 'Importer en eksisterende nøgle';

  @override
  String get importKeyFieldLabel => 'nsec eller hexadecimal privat nøgle';

  @override
  String get importButton => 'Importer';

  @override
  String get storageFailureMessage =>
      'Kairos kunne ikke åbne sin krypterede lokale database. Genstart appen. Ryd ikke appdata; hvis problemet fortsætter, så rapporter det privat.';
}
