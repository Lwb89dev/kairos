// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get settingsTitle => 'Instellingen';

  @override
  String get sectionAccount => 'Account';

  @override
  String get addAccountTitle => 'Nostr-account toevoegen';

  @override
  String get addAccountSubtitle => 'Momenteel offline, alleen lokaal.';

  @override
  String get backupKeyTitle => 'Privésleutel back-uppen';

  @override
  String get backupKeySubtitle => 'Vereist om dit Nostr-account te herstellen.';

  @override
  String get logOut => 'Uitloggen';

  @override
  String get sectionSync => 'Synchronisatie';

  @override
  String get syncInfoTitle => 'Optionele versleutelde synchronisatie';

  @override
  String get syncInfoBody =>
      'Taken worden alleen gesynchroniseerd als er een Nostr-account en minstens één relay zijn geconfigureerd. Taakinhoud wordt met NIP-44 versleuteld voordat deze het apparaat verlaat.';

  @override
  String get sectionRelays => 'Relays';

  @override
  String get sectionAppearance => 'Uiterlijk';

  @override
  String get themeLabel => 'Thema';

  @override
  String get sectionLanguage => 'Taal';

  @override
  String get langSystem => 'Systeem';

  @override
  String get sectionSupport => 'Ondersteuning';

  @override
  String get supportKairosTitle => 'Steun Kairos';

  @override
  String lightningAddressCopied(String address) {
    return 'Geen Lightning-wallet gevonden — adres gekopieerd: $address';
  }

  @override
  String get logoutConfirmTitle => 'Uitloggen?';

  @override
  String get logoutConfirmBody =>
      'Je taken blijven op dit apparaat. Zonder de sleutel kunnen ze niet meer worden gesynchroniseerd — zorg dat je een back-up van je nsec hebt voordat je uitlogt.';

  @override
  String get cancelButton => 'Annuleren';

  @override
  String get nsecDialogTitle => 'Je privésleutel (nsec)';

  @override
  String get nsecDialogWarning =>
      'Iedereen met deze sleutel heeft controle over je account. Bewaar hem in een wachtwoordmanager en deel hem nooit.';

  @override
  String get copyButton => 'Kopiëren';

  @override
  String get doneButton => 'Klaar';

  @override
  String get signedInWithAmber => 'Ingelogd met Amber';

  @override
  String signedInWithKey(String npub) {
    return 'Ingelogd · $npub';
  }

  @override
  String get relayInvalidUrlWss =>
      'Voer een geldige versleutelde wss://-relay-URL in.';

  @override
  String get relayUrlHint => 'wss://jouw-relay…';

  @override
  String get addRelayTooltip => 'Relay toevoegen';

  @override
  String get noRelaysConfigured => 'Geen relays geconfigureerd.';

  @override
  String get removeRelayTooltip => 'Relay verwijderen';

  @override
  String get homeRelayTitle => 'Persoonlijke home-relay';

  @override
  String get homeRelayConfiguredSubtitle =>
      'Extra back-updoel voor je versleutelde taken';

  @override
  String get homeRelaySubtitle =>
      'Optioneel: voeg je eigen relay toe als extra back-updoel. In tegenstelling tot andere relays mag deze ook een onversleuteld ws://-adres gebruiken als hij zich in je lokale netwerk bevindt.';

  @override
  String get removeHomeRelayTooltip => 'Home-relay verwijderen';

  @override
  String get homeRelayUrlHint => 'wss://jouw-home-relay, of ws:// op je LAN';

  @override
  String get homeRelayInvalidUrl =>
      'Voer een geldige wss://-relay-URL in (ws:// is alleen toegestaan voor een home-relay op je eigen netwerk).';

  @override
  String get saveButton => 'Opslaan';

  @override
  String get onboardingSaveError =>
      'Instellen kon niet worden opgeslagen op dit apparaat.';

  @override
  String get backButton => 'Terug';

  @override
  String get getStartedButton => 'Aan de slag';

  @override
  String get useOfflineButton => 'Offline gebruiken';

  @override
  String get nextButton => 'Volgende';

  @override
  String welcomeTitle(String appName) {
    return 'Welkom bij $appName';
  }

  @override
  String get welcomeSubtitle =>
      'Een privé, gefocuste taakbeheerder in het Echoes-ecosysteem.';

  @override
  String get featureLocalTitle => 'Van jou, op jouw apparaat';

  @override
  String get featureLocalBody =>
      'Taken worden eerst lokaal opgeslagen in een versleutelde database. De app werkt volledig offline — geen account vereist.';

  @override
  String get featureSyncTitle => 'Synchroniseren via Nostr';

  @override
  String get featureSyncBody =>
      'Log in met een Nostr-sleutel en je taken worden via de relays die je kiest gesynchroniseerd tussen apparaten — zonder bedrijfsserver ertussen.';

  @override
  String get featureEncryptedTitle => 'End-to-end versleuteld';

  @override
  String get featureEncryptedBody =>
      'Elke taak wordt versleuteld (NIP-44) voordat deze het apparaat verlaat. Relays zien uitsluitend cijfertekst.';

  @override
  String get featureAmberTitle => 'Amber-ondersteuning';

  @override
  String get featureAmberBody =>
      'Op Android kun je je sleutel in Amber bewaren: één keer inloggen voor de hele suite, en geen enkele app raakt de sleutel zelf ooit aan.';

  @override
  String get loginPageTitle =>
      'Log in om je versleutelde taken te synchroniseren';

  @override
  String get loginPageBody =>
      'Gebruik een Nostr-identiteit voor optionele synchronisatie tussen meerdere apparaten, of ga verder zonder account en houd alles lokaal.';

  @override
  String get relaySetupTitle => 'Kies je relays';

  @override
  String get relaySetupBody =>
      'Relays slaan versleutelde taken op voor synchronisatie met Kairos op je andere apparaten. Voeg er een of meer toe, of laat dit leeg en stel synchronisatie later in.';

  @override
  String get relaySettingsLoadError =>
      'Relay-instellingen konden niet worden geladen.';

  @override
  String get taskGoneMessage => 'Deze taak bestaat niet meer.';

  @override
  String get taskDetailsTitle => 'Taak';

  @override
  String get editTooltip => 'Bewerken';

  @override
  String get deleteTooltip => 'Verwijderen';

  @override
  String get dueDateLabel => 'Vervaldatum';

  @override
  String get noneLabel => 'Geen';

  @override
  String get tagsLabel => 'Tags';

  @override
  String get priorityLabel => 'Prioriteit';

  @override
  String priorityValue(int priority) {
    return '$priority / 5';
  }

  @override
  String get colorLabel => 'Kleur';

  @override
  String get syncStatusLabel => 'Synchronisatie';

  @override
  String get syncedStatus => 'Gepubliceerd naar relays';

  @override
  String get notSyncedStatus => 'Alleen lokaal (synchronisatie in behandeling)';

  @override
  String get linkedEventLabel => 'Gekoppelde agenda-afspraak';

  @override
  String createdUpdatedInfo(String created, String updated) {
    return 'Aangemaakt $created\nBijgewerkt $updated';
  }

  @override
  String get deleteTaskConfirmTitle => 'Deze taak verwijderen?';

  @override
  String get deleteTaskConfirmBody =>
      'De taak wordt lokaal verwijderd en er wordt een verwijderverzoek naar je relays gestuurd.';

  @override
  String get deleteButton => 'Verwijderen';

  @override
  String get deleteTaskError => 'De taak kon lokaal niet worden verwijderd.';

  @override
  String get saveTaskError => 'De taak kon lokaal niet worden opgeslagen.';

  @override
  String get editTaskTitle => 'Taak bewerken';

  @override
  String get newTaskTitle => 'Nieuwe taak';

  @override
  String get titleFieldLabel => 'Titel';

  @override
  String get titleRequiredError => 'Een titel is verplicht.';

  @override
  String get titleTooLongError => 'De titel is te lang.';

  @override
  String get descriptionFieldLabel => 'Beschrijving (optioneel)';

  @override
  String get noDueDateLabel => 'Geen vervaldatum';

  @override
  String get optionalDeadlineHint => 'Optionele deadline.';

  @override
  String get clearDueDateTooltip => 'Vervaldatum wissen';

  @override
  String get tagsFieldLabel => 'Tags (kommagescheiden, optioneel)';

  @override
  String get tagsFieldHint => 'werk, privé';

  @override
  String get tooManyTagsError => 'Gebruik maximaal 32 tags.';

  @override
  String get tagTooLongError => 'Elke tag mag maximaal 64 tekens bevatten.';

  @override
  String get priorityScaleHint => '1 = laag, 5 = hoog';

  @override
  String get syncNowTooltip => 'Nu synchroniseren';

  @override
  String get settingsTooltip => 'Instellingen';

  @override
  String get newTaskTooltip => 'Nieuwe taak';

  @override
  String get loadTasksError => 'Lokale taken konden niet worden geladen.';

  @override
  String get emptyTasksTitle => 'Nog geen taken';

  @override
  String get emptyTasksBody => 'Tik op + om je eerste taak toe te voegen.';

  @override
  String completedCount(int count) {
    return 'Voltooid ($count)';
  }

  @override
  String get invalidKeyError =>
      'Die privésleutel is ongeldig. Controleer hem en probeer het opnieuw.';

  @override
  String get signInError => 'Inloggen mislukt. Probeer het opnieuw.';

  @override
  String get signInAmberButton => 'Inloggen met Amber';

  @override
  String get createAccountButton => 'Nieuw account aanmaken';

  @override
  String get generatedAccountHint =>
      'Een gegenereerd account kan alleen worden hersteld met de bijbehorende privésleutel. Maak er na het instellen een back-up van in Instellingen.';

  @override
  String get importKeyButton => 'Bestaande sleutel importeren';

  @override
  String get importKeyFieldLabel => 'nsec of hexadecimale privésleutel';

  @override
  String get importButton => 'Importeren';

  @override
  String get storageFailureMessage =>
      'Kairos kon de versleutelde lokale database niet openen. Start de app opnieuw. Wis geen app-gegevens; als het probleem aanhoudt, meld dit dan privé.';
}
