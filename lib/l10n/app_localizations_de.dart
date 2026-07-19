// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get sectionAccount => 'Konto';

  @override
  String get addAccountTitle => 'Nostr-Konto hinzufügen';

  @override
  String get addAccountSubtitle => 'Derzeit offline, nur lokal.';

  @override
  String get backupKeyTitle => 'Privaten Schlüssel sichern';

  @override
  String get backupKeySubtitle =>
      'Erforderlich, um dieses Nostr-Konto wiederherzustellen.';

  @override
  String get logOut => 'Abmelden';

  @override
  String get sectionSync => 'Synchronisierung';

  @override
  String get syncInfoTitle => 'Optionale verschlüsselte Synchronisierung';

  @override
  String get syncInfoBody =>
      'Aufgaben werden nur synchronisiert, wenn ein Nostr-Konto und mindestens ein Relay konfiguriert sind. Aufgabeninhalte werden mit NIP-44 verschlüsselt, bevor sie dieses Gerät verlassen.';

  @override
  String get sectionRelays => 'Relays';

  @override
  String get sectionAppearance => 'Erscheinungsbild';

  @override
  String get themeLabel => 'Design';

  @override
  String get sectionLanguage => 'Sprache';

  @override
  String get langSystem => 'System';

  @override
  String get sectionSupport => 'Support';

  @override
  String get supportKairosTitle => 'Kairos unterstützen';

  @override
  String lightningAddressCopied(String address) {
    return 'Kein Lightning-Wallet gefunden — Adresse kopiert: $address';
  }

  @override
  String get logoutConfirmTitle => 'Abmelden?';

  @override
  String get logoutConfirmBody =>
      'Deine Aufgaben bleiben auf diesem Gerät. Ohne den Schlüssel können sie nicht mehr synchronisiert werden — stelle sicher, dass du eine Sicherung deines nsec hast, bevor du dich abmeldest.';

  @override
  String get cancelButton => 'Abbrechen';

  @override
  String get nsecDialogTitle => 'Dein privater Schlüssel (nsec)';

  @override
  String get nsecDialogWarning =>
      'Jeder mit diesem Schlüssel hat die Kontrolle über dein Konto. Bewahre ihn in einem Passwort-Manager auf und gib ihn niemals weiter.';

  @override
  String get copyButton => 'Kopieren';

  @override
  String get doneButton => 'Fertig';

  @override
  String get signedInWithAmber => 'Mit Amber angemeldet';

  @override
  String signedInWithKey(String npub) {
    return 'Angemeldet · $npub';
  }

  @override
  String get relayInvalidUrlWss =>
      'Gib eine gültige verschlüsselte wss://-Relay-URL ein.';

  @override
  String get relayUrlHint => 'wss://dein-relay…';

  @override
  String get addRelayTooltip => 'Relay hinzufügen';

  @override
  String get noRelaysConfigured => 'Keine Relays konfiguriert.';

  @override
  String get removeRelayTooltip => 'Relay entfernen';

  @override
  String get homeRelayTitle => 'Persönliches Home-Relay';

  @override
  String get homeRelayConfiguredSubtitle =>
      'Zusätzliches Backup-Ziel für deine verschlüsselten Aufgaben';

  @override
  String get homeRelaySubtitle =>
      'Optional: Füge dein eigenes Relay als zusätzliches Backup-Ziel hinzu. Im Gegensatz zu anderen Relays kann dieses auch eine unverschlüsselte ws://-Adresse verwenden, wenn es sich in deinem lokalen Netzwerk befindet.';

  @override
  String get removeHomeRelayTooltip => 'Home-Relay entfernen';

  @override
  String get homeRelayUrlHint =>
      'wss://dein-home-relay oder ws:// in deinem LAN';

  @override
  String get homeRelayInvalidUrl =>
      'Gib eine gültige wss://-Relay-URL ein (ws:// ist nur für ein Home-Relay im eigenen Netzwerk erlaubt).';

  @override
  String get saveButton => 'Speichern';

  @override
  String get onboardingSaveError =>
      'Setup konnte auf diesem Gerät nicht gespeichert werden.';

  @override
  String get backButton => 'Zurück';

  @override
  String get getStartedButton => 'Los geht\'s';

  @override
  String get useOfflineButton => 'Offline nutzen';

  @override
  String get nextButton => 'Weiter';

  @override
  String welcomeTitle(String appName) {
    return 'Willkommen bei $appName';
  }

  @override
  String get welcomeSubtitle =>
      'Ein privater, fokussierter Aufgabenmanager im Echoes-Ökosystem.';

  @override
  String get featureLocalTitle => 'Deins, auf deinem Gerät';

  @override
  String get featureLocalBody =>
      'Aufgaben werden zunächst lokal in einer verschlüsselten Datenbank gespeichert. Die App funktioniert vollständig offline — kein Konto erforderlich.';

  @override
  String get featureSyncTitle => 'Synchronisierung über Nostr';

  @override
  String get featureSyncBody =>
      'Melde dich mit einem Nostr-Schlüssel an, und deine Aufgaben werden über die von dir gewählten Relays geräteübergreifend synchronisiert — ohne Firmenserver dazwischen.';

  @override
  String get featureEncryptedTitle => 'Ende-zu-Ende-verschlüsselt';

  @override
  String get featureEncryptedBody =>
      'Jede Aufgabe wird verschlüsselt (NIP-44), bevor sie das Gerät verlässt. Relays sehen ausschließlich Chiffretext.';

  @override
  String get featureAmberTitle => 'Amber-Unterstützung';

  @override
  String get featureAmberBody =>
      'Auf Android kannst du deinen Schlüssel in Amber aufbewahren: eine Anmeldung für die gesamte Suite, und keine App kommt jemals mit dem Schlüssel selbst in Berührung.';

  @override
  String get loginPageTitle =>
      'Melde dich an, um deine verschlüsselten Aufgaben zu synchronisieren';

  @override
  String get loginPageBody =>
      'Nutze eine Nostr-Identität für optionale geräteübergreifende Synchronisierung oder mache ohne Konto weiter und behalte alles lokal.';

  @override
  String get relaySetupTitle => 'Wähle deine Relays';

  @override
  String get relaySetupBody =>
      'Relays speichern verschlüsselte Aufgaben zur Synchronisierung mit Kairos auf deinen anderen Geräten. Füge eines oder mehrere hinzu, oder lass dies leer und richte die Synchronisierung später ein.';

  @override
  String get relaySettingsLoadError =>
      'Relay-Einstellungen konnten nicht geladen werden.';

  @override
  String get taskGoneMessage => 'Diese Aufgabe existiert nicht mehr.';

  @override
  String get taskDetailsTitle => 'Aufgabe';

  @override
  String get editTooltip => 'Bearbeiten';

  @override
  String get deleteTooltip => 'Löschen';

  @override
  String get dueDateLabel => 'Fälligkeitsdatum';

  @override
  String get noneLabel => 'Keine';

  @override
  String get tagsLabel => 'Tags';

  @override
  String get priorityLabel => 'Priorität';

  @override
  String priorityValue(int priority) {
    return '$priority / 5';
  }

  @override
  String get colorLabel => 'Farbe';

  @override
  String get syncStatusLabel => 'Synchronisierung';

  @override
  String get syncedStatus => 'Auf Relays veröffentlicht';

  @override
  String get notSyncedStatus => 'Nur lokal (Synchronisierung ausstehend)';

  @override
  String get linkedEventLabel => 'Verknüpftes Kalenderereignis';

  @override
  String createdUpdatedInfo(String created, String updated) {
    return 'Erstellt $created\nAktualisiert $updated';
  }

  @override
  String get deleteTaskConfirmTitle => 'Diese Aufgabe löschen?';

  @override
  String get deleteTaskConfirmBody =>
      'Die Aufgabe wird lokal entfernt und eine Löschanfrage wird an deine Relays gesendet.';

  @override
  String get deleteButton => 'Löschen';

  @override
  String get deleteTaskError =>
      'Die Aufgabe konnte lokal nicht gelöscht werden.';

  @override
  String get saveTaskError =>
      'Die Aufgabe konnte lokal nicht gespeichert werden.';

  @override
  String get editTaskTitle => 'Aufgabe bearbeiten';

  @override
  String get newTaskTitle => 'Neue Aufgabe';

  @override
  String get titleFieldLabel => 'Titel';

  @override
  String get titleRequiredError => 'Ein Titel ist erforderlich.';

  @override
  String get titleTooLongError => 'Der Titel ist zu lang.';

  @override
  String get descriptionFieldLabel => 'Beschreibung (optional)';

  @override
  String get noDueDateLabel => 'Kein Fälligkeitsdatum';

  @override
  String get optionalDeadlineHint => 'Optionale Frist.';

  @override
  String get clearDueDateTooltip => 'Fälligkeitsdatum löschen';

  @override
  String get tagsFieldLabel => 'Tags (durch Komma getrennt, optional)';

  @override
  String get tagsFieldHint => 'Arbeit, Privat';

  @override
  String get tooManyTagsError => 'Verwende höchstens 32 Tags.';

  @override
  String get tagTooLongError =>
      'Jeder Tag darf höchstens 64 Zeichen lang sein.';

  @override
  String get priorityScaleHint => '1 = niedrig, 5 = hoch';

  @override
  String get syncNowTooltip => 'Jetzt synchronisieren';

  @override
  String get settingsTooltip => 'Einstellungen';

  @override
  String get newTaskTooltip => 'Neue Aufgabe';

  @override
  String get loadTasksError => 'Lokale Aufgaben konnten nicht geladen werden.';

  @override
  String get emptyTasksTitle => 'Noch keine Aufgaben';

  @override
  String get emptyTasksBody =>
      'Tippe auf +, um deine erste Aufgabe hinzuzufügen.';

  @override
  String completedCount(int count) {
    return 'Abgeschlossen ($count)';
  }

  @override
  String get invalidKeyError =>
      'Dieser private Schlüssel ist ungültig. Überprüfe ihn und versuche es erneut.';

  @override
  String get signInError =>
      'Anmeldung fehlgeschlagen. Bitte versuche es erneut.';

  @override
  String get signInAmberButton => 'Mit Amber anmelden';

  @override
  String get createAccountButton => 'Neues Konto erstellen';

  @override
  String get generatedAccountHint =>
      'Ein generiertes Konto kann nur mit seinem privaten Schlüssel wiederhergestellt werden. Sichere ihn nach der Einrichtung in den Einstellungen.';

  @override
  String get importKeyButton => 'Vorhandenen Schlüssel importieren';

  @override
  String get importKeyFieldLabel =>
      'nsec oder hexadezimaler privater Schlüssel';

  @override
  String get importButton => 'Importieren';

  @override
  String get storageFailureMessage =>
      'Kairos konnte die verschlüsselte lokale Datenbank nicht öffnen. Starte die App neu. Lösche keine App-Daten; falls das Problem weiterhin besteht, melde es vertraulich.';
}
