// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get settingsTitle => 'Impostazioni';

  @override
  String get sectionAccount => 'Account';

  @override
  String get addAccountTitle => 'Aggiungi un account Nostr';

  @override
  String get addAccountSubtitle => 'Attualmente offline, solo locale.';

  @override
  String get backupKeyTitle => 'Backup della chiave privata';

  @override
  String get backupKeySubtitle =>
      'Necessaria per recuperare questo account Nostr.';

  @override
  String get logOut => 'Esci';

  @override
  String get sectionSync => 'Sincronizzazione';

  @override
  String get syncInfoTitle => 'Sincronizzazione crittografata opzionale';

  @override
  String get syncInfoBody =>
      'Le attività si sincronizzano solo quando sono configurati un account Nostr e almeno un relay. Il contenuto delle attività viene crittografato con NIP-44 prima di lasciare questo dispositivo.';

  @override
  String get sectionRelays => 'Relay';

  @override
  String get sectionAppearance => 'Aspetto';

  @override
  String get themeLabel => 'Tema';

  @override
  String get sectionLanguage => 'Lingua';

  @override
  String get langSystem => 'Sistema';

  @override
  String get sectionSupport => 'Supporto';

  @override
  String get supportKairosTitle => 'Sostieni Kairos';

  @override
  String lightningAddressCopied(String address) {
    return 'Nessun wallet Lightning trovato — indirizzo copiato: $address';
  }

  @override
  String get logoutConfirmTitle => 'Uscire?';

  @override
  String get logoutConfirmBody =>
      'Le tue attività restano su questo dispositivo. Senza la chiave non potranno più sincronizzarsi: assicurati di avere un backup del tuo nsec prima di uscire.';

  @override
  String get cancelButton => 'Annulla';

  @override
  String get nsecDialogTitle => 'La tua chiave privata (nsec)';

  @override
  String get nsecDialogWarning =>
      'Chiunque abbia questa chiave controlla il tuo account. Conservala in un password manager e non condividerla mai.';

  @override
  String get copyButton => 'Copia';

  @override
  String get doneButton => 'Fatto';

  @override
  String get signedInWithAmber => 'Accesso con Amber';

  @override
  String signedInWithKey(String npub) {
    return 'Accesso eseguito · $npub';
  }

  @override
  String get relayInvalidUrlWss =>
      'Inserisci un URL relay wss:// crittografato valido.';

  @override
  String get relayUrlHint => 'wss://il-tuo-relay…';

  @override
  String get addRelayTooltip => 'Aggiungi relay';

  @override
  String get noRelaysConfigured => 'Nessun relay configurato.';

  @override
  String get removeRelayTooltip => 'Rimuovi relay';

  @override
  String get homeRelayTitle => 'Relay personale';

  @override
  String get homeRelayConfiguredSubtitle =>
      'Destinazione di backup aggiuntiva per le tue attività crittografate';

  @override
  String get homeRelaySubtitle =>
      'Facoltativo: aggiungi un tuo relay come destinazione di backup aggiuntiva. A differenza degli altri relay, questo può usare anche un indirizzo ws:// non crittografato se si trova sulla tua rete locale.';

  @override
  String get removeHomeRelayTooltip => 'Rimuovi relay personale';

  @override
  String get homeRelayUrlHint =>
      'wss://il-tuo-relay-personale, oppure ws:// sulla tua LAN';

  @override
  String get homeRelayInvalidUrl =>
      'Inserisci un URL relay wss:// valido (ws:// è consentito solo per un relay personale sulla tua rete).';

  @override
  String get saveButton => 'Salva';

  @override
  String get onboardingSaveError =>
      'Impossibile salvare la configurazione su questo dispositivo.';

  @override
  String get backButton => 'Indietro';

  @override
  String get getStartedButton => 'Inizia';

  @override
  String get useOfflineButton => 'Usa offline';

  @override
  String get nextButton => 'Avanti';

  @override
  String welcomeTitle(String appName) {
    return 'Benvenuto in $appName';
  }

  @override
  String get welcomeSubtitle =>
      'Un task manager privato e concentrato, nell\'ecosistema Echoes.';

  @override
  String get featureLocalTitle => 'Tuo, sul tuo dispositivo';

  @override
  String get featureLocalBody =>
      'Le attività vengono salvate innanzitutto localmente in un database crittografato. L\'app funziona completamente offline: nessun account richiesto.';

  @override
  String get featureSyncTitle => 'Sincronizzazione tramite Nostr';

  @override
  String get featureSyncBody =>
      'Accedi con una chiave Nostr e le tue attività si sincronizzano tra i dispositivi tramite i relay che scegli tu, senza server aziendali di mezzo.';

  @override
  String get featureEncryptedTitle => 'Crittografia end-to-end';

  @override
  String get featureEncryptedBody =>
      'Ogni attività viene crittografata (NIP-44) prima di lasciare il dispositivo. I relay vedono solo testo cifrato.';

  @override
  String get featureAmberTitle => 'Supporto per Amber';

  @override
  String get featureAmberBody =>
      'Su Android puoi conservare la tua chiave in Amber: un solo accesso per tutta la suite, e nessuna app tocca mai la chiave stessa.';

  @override
  String get loginPageTitle =>
      'Accedi per sincronizzare le tue attività crittografate';

  @override
  String get loginPageBody =>
      'Usa un\'identità Nostr per la sincronizzazione facoltativa multi-dispositivo, oppure continua senza account e mantieni tutto locale.';

  @override
  String get relaySetupTitle => 'Scegli i tuoi relay';

  @override
  String get relaySetupBody =>
      'I relay conservano le attività crittografate per la sincronizzazione con Kairos sui tuoi altri dispositivi. Aggiungine uno o più, oppure lascia vuoto e configura la sincronizzazione più tardi.';

  @override
  String get relaySettingsLoadError =>
      'Impossibile caricare le impostazioni dei relay.';

  @override
  String get taskGoneMessage => 'Questa attività non esiste più.';

  @override
  String get taskDetailsTitle => 'Attività';

  @override
  String get editTooltip => 'Modifica';

  @override
  String get deleteTooltip => 'Elimina';

  @override
  String get dueDateLabel => 'Scadenza';

  @override
  String get noneLabel => 'Nessuna';

  @override
  String get tagsLabel => 'Tag';

  @override
  String get priorityLabel => 'Priorità';

  @override
  String priorityValue(int priority) {
    return '$priority / 5';
  }

  @override
  String get colorLabel => 'Colore';

  @override
  String get syncStatusLabel => 'Sincronizzazione';

  @override
  String get syncedStatus => 'Pubblicata sui relay';

  @override
  String get notSyncedStatus => 'Solo locale (sincronizzazione in sospeso)';

  @override
  String get linkedEventLabel => 'Evento di calendario collegato';

  @override
  String createdUpdatedInfo(String created, String updated) {
    return 'Creata il $created\nAggiornata il $updated';
  }

  @override
  String get deleteTaskConfirmTitle => 'Eliminare questa attività?';

  @override
  String get deleteTaskConfirmBody =>
      'L\'attività viene rimossa localmente e una richiesta di eliminazione viene inviata ai tuoi relay.';

  @override
  String get deleteButton => 'Elimina';

  @override
  String get deleteTaskError => 'Impossibile eliminare l\'attività localmente.';

  @override
  String get saveTaskError => 'Impossibile salvare l\'attività localmente.';

  @override
  String get editTaskTitle => 'Modifica attività';

  @override
  String get newTaskTitle => 'Nuova attività';

  @override
  String get syncToNostrTitle => 'Sincronizza su Nostr';

  @override
  String get syncToNostrSubtitle =>
      'Pubblica questo task, crittografato, sui tuoi relay. Se disattivato, resta solo su questo dispositivo.';

  @override
  String get syncTaskButton => 'Sincronizza task';

  @override
  String get localOnlyStatus => 'Solo locale (sync disattivata)';

  @override
  String get titleFieldLabel => 'Titolo';

  @override
  String get titleRequiredError => 'Il titolo è obbligatorio.';

  @override
  String get titleTooLongError => 'Il titolo è troppo lungo.';

  @override
  String get descriptionFieldLabel => 'Descrizione (facoltativa)';

  @override
  String get noDueDateLabel => 'Nessuna scadenza';

  @override
  String get optionalDeadlineHint => 'Scadenza facoltativa.';

  @override
  String get clearDueDateTooltip => 'Rimuovi scadenza';

  @override
  String get tagsFieldLabel => 'Tag (separati da virgola, facoltativo)';

  @override
  String get tagsFieldHint => 'lavoro, personale';

  @override
  String get tooManyTagsError => 'Usa al massimo 32 tag.';

  @override
  String get tagTooLongError => 'Ogni tag deve avere al massimo 64 caratteri.';

  @override
  String get priorityScaleHint => '1 = bassa, 5 = alta';

  @override
  String get syncNowTooltip => 'Sincronizza ora';

  @override
  String get settingsTooltip => 'Impostazioni';

  @override
  String get newTaskTooltip => 'Nuova attività';

  @override
  String get loadTasksError => 'Impossibile caricare le attività locali.';

  @override
  String get emptyTasksTitle => 'Ancora nessuna attività';

  @override
  String get emptyTasksBody => 'Tocca + per aggiungere la tua prima attività.';

  @override
  String completedCount(int count) {
    return 'Completate ($count)';
  }

  @override
  String get invalidKeyError =>
      'Quella chiave privata non è valida. Controllala e riprova.';

  @override
  String get signInError => 'Impossibile accedere. Riprova.';

  @override
  String get signInAmberButton => 'Accedi con Amber';

  @override
  String get createAccountButton => 'Crea un nuovo account';

  @override
  String get generatedAccountHint =>
      'Un account generato può essere recuperato solo con la sua chiave privata. Eseguine il backup dalle Impostazioni dopo la configurazione.';

  @override
  String get importKeyButton => 'Importa una chiave esistente';

  @override
  String get importKeyFieldLabel => 'nsec o chiave privata esadecimale';

  @override
  String get importButton => 'Importa';

  @override
  String get storageFailureMessage =>
      'Kairos non è riuscito ad aprire il proprio database locale crittografato. Riavvia l\'app. Non cancellare i dati dell\'app; se il problema persiste, segnalalo in privato.';

  @override
  String get remindersLabel => 'Promemoria';

  @override
  String get addReminderButton => 'Aggiungi promemoria';

  @override
  String get remindersNeedDueDate =>
      'Imposta una scadenza per aggiungere promemoria';

  @override
  String get removeReminderTooltip => 'Rimuovi promemoria';

  @override
  String get reminderAtDueTime => 'All’orario di scadenza';

  @override
  String reminderMinutesBefore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minuti prima',
      one: '1 minuto prima',
    );
    return '$_temp0';
  }

  @override
  String reminderHoursBefore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ore prima',
      one: '1 ora prima',
    );
    return '$_temp0';
  }

  @override
  String reminderDaysBefore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count giorni prima',
      one: '1 giorno prima',
    );
    return '$_temp0';
  }

  @override
  String maxRemindersReached(int count) {
    return 'Un task può avere al massimo $count promemoria';
  }

  @override
  String get notificationsTitle => 'Promemoria dei task';

  @override
  String get notificationsSubtitle =>
      'Avvisami prima della scadenza di un task';

  @override
  String get sectionReminders => 'Promemoria';

  @override
  String get addToCalendarTitle => 'Aggiungi al calendario Astraea';

  @override
  String get addToCalendarSubtitle =>
      'Questo task compare anche nel calendario e nel widget di Astraea, nel giorno di scadenza.';

  @override
  String get addToCalendarNeedsSync =>
      'Richiede un account, un relay e una scadenza';
}
