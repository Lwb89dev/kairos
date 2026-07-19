// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get settingsTitle => 'Inställningar';

  @override
  String get sectionAccount => 'Konto';

  @override
  String get addAccountTitle => 'Lägg till ett Nostr-konto';

  @override
  String get addAccountSubtitle => 'För närvarande offline, endast lokalt.';

  @override
  String get backupKeyTitle => 'Säkerhetskopiera privat nyckel';

  @override
  String get backupKeySubtitle => 'Krävs för att återställa detta Nostr-konto.';

  @override
  String get logOut => 'Logga ut';

  @override
  String get sectionSync => 'Synkronisering';

  @override
  String get syncInfoTitle => 'Valfri krypterad synkronisering';

  @override
  String get syncInfoBody =>
      'Uppgifter synkroniseras endast när ett Nostr-konto och minst en relä är konfigurerade. Uppgiftsinnehåll krypteras med NIP-44 innan det lämnar den här enheten.';

  @override
  String get sectionRelays => 'Reläer';

  @override
  String get sectionAppearance => 'Utseende';

  @override
  String get themeLabel => 'Tema';

  @override
  String get sectionLanguage => 'Språk';

  @override
  String get langSystem => 'System';

  @override
  String get sectionSupport => 'Support';

  @override
  String get supportKairosTitle => 'Stöd Kairos';

  @override
  String lightningAddressCopied(String address) {
    return 'Ingen Lightning-plånbok hittades — adressen kopierades: $address';
  }

  @override
  String get logoutConfirmTitle => 'Logga ut?';

  @override
  String get logoutConfirmBody =>
      'Dina uppgifter finns kvar på den här enheten. Utan nyckeln kan de inte längre synkroniseras — se till att du har en säkerhetskopia av din nsec innan du loggar ut.';

  @override
  String get cancelButton => 'Avbryt';

  @override
  String get nsecDialogTitle => 'Din privata nyckel (nsec)';

  @override
  String get nsecDialogWarning =>
      'Alla med den här nyckeln har kontroll över ditt konto. Förvara den i en lösenordshanterare och dela den aldrig.';

  @override
  String get copyButton => 'Kopiera';

  @override
  String get doneButton => 'Klar';

  @override
  String get signedInWithAmber => 'Inloggad med Amber';

  @override
  String signedInWithKey(String npub) {
    return 'Inloggad · $npub';
  }

  @override
  String get relayInvalidUrlWss => 'Ange en giltig krypterad wss://-relä-URL.';

  @override
  String get relayUrlHint => 'wss://din-relä…';

  @override
  String get addRelayTooltip => 'Lägg till relä';

  @override
  String get noRelaysConfigured => 'Inga reläer konfigurerade.';

  @override
  String get removeRelayTooltip => 'Ta bort relä';

  @override
  String get homeRelayTitle => 'Personlig hemrelä';

  @override
  String get homeRelayConfiguredSubtitle =>
      'Extra säkerhetskopieringsmål för dina krypterade uppgifter';

  @override
  String get homeRelaySubtitle =>
      'Valfritt: lägg till din egen relä som ett extra säkerhetskopieringsmål. Till skillnad från andra reläer kan den här också använda en okrypterad ws://-adress om den finns på ditt lokala nätverk.';

  @override
  String get removeHomeRelayTooltip => 'Ta bort hemrelä';

  @override
  String get homeRelayUrlHint => 'wss://din-hemrelä, eller ws:// på ditt LAN';

  @override
  String get homeRelayInvalidUrl =>
      'Ange en giltig wss://-relä-URL (ws:// tillåts endast för en hemrelä på ditt eget nätverk).';

  @override
  String get saveButton => 'Spara';

  @override
  String get onboardingSaveError =>
      'Kunde inte spara konfigurationen på den här enheten.';

  @override
  String get backButton => 'Tillbaka';

  @override
  String get getStartedButton => 'Kom igång';

  @override
  String get useOfflineButton => 'Använd offline';

  @override
  String get nextButton => 'Nästa';

  @override
  String welcomeTitle(String appName) {
    return 'Välkommen till $appName';
  }

  @override
  String get welcomeSubtitle =>
      'En privat, fokuserad uppgiftshanterare i Echoes-ekosystemet.';

  @override
  String get featureLocalTitle => 'Din, på din enhet';

  @override
  String get featureLocalBody =>
      'Uppgifter lagras först lokalt i en krypterad databas. Appen fungerar helt offline — inget konto krävs.';

  @override
  String get featureSyncTitle => 'Synkronisering via Nostr';

  @override
  String get featureSyncBody =>
      'Logga in med en Nostr-nyckel så synkroniseras dina uppgifter mellan enheter via de reläer du väljer — utan någon företagsserver emellan.';

  @override
  String get featureEncryptedTitle => 'Totalkrypterad (end-to-end)';

  @override
  String get featureEncryptedBody =>
      'Varje uppgift krypteras (NIP-44) innan den lämnar enheten. Reläer ser endast krypterad text.';

  @override
  String get featureAmberTitle => 'Amber-stöd';

  @override
  String get featureAmberBody =>
      'På Android kan du förvara din nyckel i Amber: en inloggning för hela sviten, och ingen app rör någonsin själva nyckeln.';

  @override
  String get loginPageTitle =>
      'Logga in för att synkronisera dina krypterade uppgifter';

  @override
  String get loginPageBody =>
      'Använd en Nostr-identitet för valfri synkronisering mellan flera enheter, eller fortsätt utan konto och behåll allt lokalt.';

  @override
  String get relaySetupTitle => 'Välj dina reläer';

  @override
  String get relaySetupBody =>
      'Reläer lagrar krypterade uppgifter för synkronisering med Kairos på dina andra enheter. Lägg till en eller flera, eller lämna detta tomt och konfigurera synkronisering senare.';

  @override
  String get relaySettingsLoadError =>
      'Kunde inte läsa in reläinställningarna.';

  @override
  String get taskGoneMessage => 'Den här uppgiften finns inte längre.';

  @override
  String get taskDetailsTitle => 'Uppgift';

  @override
  String get editTooltip => 'Redigera';

  @override
  String get deleteTooltip => 'Ta bort';

  @override
  String get dueDateLabel => 'Förfallodatum';

  @override
  String get noneLabel => 'Ingen';

  @override
  String get tagsLabel => 'Etiketter';

  @override
  String get priorityLabel => 'Prioritet';

  @override
  String priorityValue(int priority) {
    return '$priority / 5';
  }

  @override
  String get colorLabel => 'Färg';

  @override
  String get syncStatusLabel => 'Synkronisering';

  @override
  String get syncedStatus => 'Publicerad till reläer';

  @override
  String get notSyncedStatus => 'Endast lokal (synkronisering väntar)';

  @override
  String get linkedEventLabel => 'Länkad kalenderhändelse';

  @override
  String createdUpdatedInfo(String created, String updated) {
    return 'Skapad $created\nUppdaterad $updated';
  }

  @override
  String get deleteTaskConfirmTitle => 'Ta bort den här uppgiften?';

  @override
  String get deleteTaskConfirmBody =>
      'Uppgiften tas bort lokalt och en borttagningsförfrågan skickas till dina reläer.';

  @override
  String get deleteButton => 'Ta bort';

  @override
  String get deleteTaskError => 'Kunde inte ta bort uppgiften lokalt.';

  @override
  String get saveTaskError => 'Kunde inte spara uppgiften lokalt.';

  @override
  String get editTaskTitle => 'Redigera uppgift';

  @override
  String get newTaskTitle => 'Ny uppgift';

  @override
  String get titleFieldLabel => 'Titel';

  @override
  String get titleRequiredError => 'En titel krävs.';

  @override
  String get titleTooLongError => 'Titeln är för lång.';

  @override
  String get descriptionFieldLabel => 'Beskrivning (valfritt)';

  @override
  String get noDueDateLabel => 'Inget förfallodatum';

  @override
  String get optionalDeadlineHint => 'Valfri deadline.';

  @override
  String get clearDueDateTooltip => 'Rensa förfallodatum';

  @override
  String get tagsFieldLabel => 'Etiketter (kommaseparerade, valfritt)';

  @override
  String get tagsFieldHint => 'jobb, privat';

  @override
  String get tooManyTagsError => 'Använd högst 32 etiketter.';

  @override
  String get tagTooLongError => 'Varje etikett får vara högst 64 tecken lång.';

  @override
  String get priorityScaleHint => '1 = låg, 5 = hög';

  @override
  String get syncNowTooltip => 'Synkronisera nu';

  @override
  String get settingsTooltip => 'Inställningar';

  @override
  String get newTaskTooltip => 'Ny uppgift';

  @override
  String get loadTasksError => 'Kunde inte läsa in lokala uppgifter.';

  @override
  String get emptyTasksTitle => 'Inga uppgifter än';

  @override
  String get emptyTasksBody =>
      'Tryck på + för att lägga till din första uppgift.';

  @override
  String completedCount(int count) {
    return 'Slutförda ($count)';
  }

  @override
  String get invalidKeyError =>
      'Den privata nyckeln är ogiltig. Kontrollera den och försök igen.';

  @override
  String get signInError => 'Det gick inte att logga in. Försök igen.';

  @override
  String get signInAmberButton => 'Logga in med Amber';

  @override
  String get createAccountButton => 'Skapa ett nytt konto';

  @override
  String get generatedAccountHint =>
      'Ett genererat konto kan endast återställas med sin privata nyckel. Säkerhetskopiera den från Inställningar efter konfigurationen.';

  @override
  String get importKeyButton => 'Importera en befintlig nyckel';

  @override
  String get importKeyFieldLabel => 'nsec eller hexadecimal privat nyckel';

  @override
  String get importButton => 'Importera';

  @override
  String get storageFailureMessage =>
      'Kairos kunde inte öppna sin krypterade lokala databas. Starta om appen. Rensa inte appdata; om problemet kvarstår, rapportera det privat.';
}
