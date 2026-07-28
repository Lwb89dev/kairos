// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get sectionAccount => 'Compte';

  @override
  String get addAccountTitle => 'Ajouter un compte Nostr';

  @override
  String get addAccountSubtitle => 'Actuellement hors ligne, local uniquement.';

  @override
  String get backupKeyTitle => 'Sauvegarder la clé privée';

  @override
  String get backupKeySubtitle => 'Nécessaire pour récupérer ce compte Nostr.';

  @override
  String get logOut => 'Se déconnecter';

  @override
  String get sectionSync => 'Synchronisation';

  @override
  String get syncInfoTitle => 'Synchronisation chiffrée facultative';

  @override
  String get syncInfoBody =>
      'Les tâches se synchronisent uniquement lorsqu\'un compte Nostr et au moins un relais sont configurés. Le contenu des tâches est chiffré avec NIP-44 avant de quitter cet appareil.';

  @override
  String get sectionRelays => 'Relais';

  @override
  String get sectionAppearance => 'Apparence';

  @override
  String get themeLabel => 'Thème';

  @override
  String get sectionLanguage => 'Langue';

  @override
  String get langSystem => 'Système';

  @override
  String get sectionSupport => 'Assistance';

  @override
  String get supportKairosTitle => 'Soutenir Kairos';

  @override
  String lightningAddressCopied(String address) {
    return 'Aucun portefeuille Lightning trouvé — adresse copiée : $address';
  }

  @override
  String get logoutConfirmTitle => 'Se déconnecter ?';

  @override
  String get logoutConfirmBody =>
      'Vos tâches restent sur cet appareil. Sans la clé, elles ne pourront plus se synchroniser : assurez-vous d\'avoir une sauvegarde de votre nsec avant de vous déconnecter.';

  @override
  String get cancelButton => 'Annuler';

  @override
  String get nsecDialogTitle => 'Votre clé privée (nsec)';

  @override
  String get nsecDialogWarning =>
      'Toute personne possédant cette clé contrôle votre compte. Conservez-la dans un gestionnaire de mots de passe et ne la partagez jamais.';

  @override
  String get copyButton => 'Copier';

  @override
  String get doneButton => 'Terminé';

  @override
  String get signedInWithAmber => 'Connecté avec Amber';

  @override
  String signedInWithKey(String npub) {
    return 'Connecté · $npub';
  }

  @override
  String get relayInvalidUrlWss =>
      'Saisissez une URL de relais wss:// chiffrée valide.';

  @override
  String get relayUrlHint => 'wss://votre-relais…';

  @override
  String get addRelayTooltip => 'Ajouter un relais';

  @override
  String get noRelaysConfigured => 'Aucun relais configuré.';

  @override
  String get removeRelayTooltip => 'Supprimer le relais';

  @override
  String get homeRelayTitle => 'Relais personnel';

  @override
  String get homeRelayConfiguredSubtitle =>
      'Cible de sauvegarde supplémentaire pour vos tâches chiffrées';

  @override
  String get homeRelaySubtitle =>
      'Facultatif : ajoutez votre propre relais comme cible de sauvegarde supplémentaire. Contrairement aux autres relais, celui-ci peut aussi utiliser une adresse ws:// non chiffrée s\'il se trouve sur votre réseau local.';

  @override
  String get removeHomeRelayTooltip => 'Supprimer le relais personnel';

  @override
  String get homeRelayUrlHint =>
      'wss://votre-relais-personnel, ou ws:// sur votre réseau local';

  @override
  String get homeRelayInvalidUrl =>
      'Saisissez une URL de relais wss:// valide (ws:// n\'est autorisé que pour un relais personnel sur votre propre réseau).';

  @override
  String get saveButton => 'Enregistrer';

  @override
  String get onboardingSaveError =>
      'Impossible d\'enregistrer la configuration sur cet appareil.';

  @override
  String get backButton => 'Retour';

  @override
  String get getStartedButton => 'Commencer';

  @override
  String get useOfflineButton => 'Utiliser hors ligne';

  @override
  String get nextButton => 'Suivant';

  @override
  String welcomeTitle(String appName) {
    return 'Bienvenue sur $appName';
  }

  @override
  String get welcomeSubtitle =>
      'Un gestionnaire de tâches privé et ciblé, au sein de l\'écosystème Echoes.';

  @override
  String get featureLocalTitle => 'À vous, sur votre appareil';

  @override
  String get featureLocalBody =>
      'Les tâches sont d\'abord stockées localement dans une base de données chiffrée. L\'application fonctionne entièrement hors ligne — aucun compte requis.';

  @override
  String get featureSyncTitle => 'Synchronisation via Nostr';

  @override
  String get featureSyncBody =>
      'Connectez-vous avec une clé Nostr et vos tâches se synchronisent entre appareils via les relais que vous choisissez — aucun serveur d\'entreprise entre les deux.';

  @override
  String get featureEncryptedTitle => 'Chiffrement de bout en bout';

  @override
  String get featureEncryptedBody =>
      'Chaque tâche est chiffrée (NIP-44) avant de quitter l\'appareil. Les relais ne voient jamais que du texte chiffré.';

  @override
  String get featureAmberTitle => 'Prise en charge d\'Amber';

  @override
  String get featureAmberBody =>
      'Sur Android, vous pouvez conserver votre clé dans Amber : une seule connexion pour toute la suite, et aucune application ne touche jamais la clé elle-même.';

  @override
  String get loginPageTitle =>
      'Connectez-vous pour synchroniser vos tâches chiffrées';

  @override
  String get loginPageBody =>
      'Utilisez une identité Nostr pour une synchronisation multi-appareils facultative, ou continuez sans compte et gardez tout en local.';

  @override
  String get relaySetupTitle => 'Choisissez vos relais';

  @override
  String get relaySetupBody =>
      'Les relais stockent des tâches chiffrées pour la synchronisation avec Kairos sur vos autres appareils. Ajoutez-en un ou plusieurs, ou laissez ce champ vide et configurez la synchronisation plus tard.';

  @override
  String get relaySettingsLoadError =>
      'Impossible de charger les paramètres des relais.';

  @override
  String get taskGoneMessage => 'Cette tâche n\'existe plus.';

  @override
  String get taskDetailsTitle => 'Tâche';

  @override
  String get editTooltip => 'Modifier';

  @override
  String get deleteTooltip => 'Supprimer';

  @override
  String get dueDateLabel => 'Date d\'échéance';

  @override
  String get noneLabel => 'Aucune';

  @override
  String get tagsLabel => 'Étiquettes';

  @override
  String get priorityLabel => 'Priorité';

  @override
  String priorityValue(int priority) {
    return '$priority / 5';
  }

  @override
  String get colorLabel => 'Couleur';

  @override
  String get syncStatusLabel => 'Synchronisation';

  @override
  String get syncedStatus => 'Publiée sur les relais';

  @override
  String get notSyncedStatus => 'Local uniquement (synchronisation en attente)';

  @override
  String get linkedEventLabel => 'Événement de calendrier lié';

  @override
  String createdUpdatedInfo(String created, String updated) {
    return 'Créée le $created\nMise à jour le $updated';
  }

  @override
  String get deleteTaskConfirmTitle => 'Supprimer cette tâche ?';

  @override
  String get deleteTaskConfirmBody =>
      'La tâche est supprimée localement et une demande de suppression est envoyée à vos relais.';

  @override
  String get deleteButton => 'Supprimer';

  @override
  String get deleteTaskError => 'Impossible de supprimer la tâche localement.';

  @override
  String get saveTaskError => 'Impossible d\'enregistrer la tâche localement.';

  @override
  String get editTaskTitle => 'Modifier la tâche';

  @override
  String get newTaskTitle => 'Nouvelle tâche';

  @override
  String get syncToNostrTitle => 'Synchroniser sur Nostr';

  @override
  String get syncToNostrSubtitle =>
      'Publie cette tâche, chiffrée, sur vos relais. Si désactivé, elle reste uniquement sur cet appareil.';

  @override
  String get syncTaskButton => 'Synchroniser la tâche';

  @override
  String get localOnlyStatus => 'Local uniquement (sync désactivée)';

  @override
  String get titleFieldLabel => 'Titre';

  @override
  String get titleRequiredError => 'Un titre est requis.';

  @override
  String get titleTooLongError => 'Le titre est trop long.';

  @override
  String get descriptionFieldLabel => 'Description (facultative)';

  @override
  String get noDueDateLabel => 'Aucune date d\'échéance';

  @override
  String get optionalDeadlineHint => 'Échéance facultative.';

  @override
  String get clearDueDateTooltip => 'Effacer la date d\'échéance';

  @override
  String get tagsFieldLabel =>
      'Étiquettes (séparées par des virgules, facultatif)';

  @override
  String get tagsFieldHint => 'travail, personnel';

  @override
  String get tooManyTagsError => 'Utilisez au maximum 32 étiquettes.';

  @override
  String get tagTooLongError =>
      'Chaque étiquette doit comporter au maximum 64 caractères.';

  @override
  String get priorityScaleHint => '1 = faible, 5 = élevée';

  @override
  String get syncNowTooltip => 'Synchroniser maintenant';

  @override
  String get settingsTooltip => 'Paramètres';

  @override
  String get newTaskTooltip => 'Nouvelle tâche';

  @override
  String get loadTasksError => 'Impossible de charger les tâches locales.';

  @override
  String get emptyTasksTitle => 'Aucune tâche pour l\'instant';

  @override
  String get emptyTasksBody =>
      'Appuyez sur + pour ajouter votre première tâche.';

  @override
  String completedCount(int count) {
    return 'Terminées ($count)';
  }

  @override
  String get invalidKeyError =>
      'Cette clé privée n\'est pas valide. Vérifiez-la et réessayez.';

  @override
  String get signInError => 'Impossible de se connecter. Veuillez réessayer.';

  @override
  String get signInAmberButton => 'Se connecter avec Amber';

  @override
  String get createAccountButton => 'Créer un nouveau compte';

  @override
  String get generatedAccountHint =>
      'Un compte généré ne peut être récupéré qu\'avec sa clé privée. Sauvegardez-la depuis les Paramètres après la configuration.';

  @override
  String get importKeyButton => 'Importer une clé existante';

  @override
  String get importKeyFieldLabel => 'nsec ou clé privée hexadécimale';

  @override
  String get importButton => 'Importer';

  @override
  String get storageFailureMessage =>
      'Kairos n\'a pas pu ouvrir sa base de données locale chiffrée. Redémarrez l\'application. Ne réinitialisez pas les données de l\'application ; si le problème persiste, signalez-le en privé.';

  @override
  String get remindersLabel => 'Rappels';

  @override
  String get addReminderButton => 'Ajouter un rappel';

  @override
  String get remindersNeedDueDate =>
      'Définissez une échéance pour ajouter des rappels';

  @override
  String get removeReminderTooltip => 'Supprimer le rappel';

  @override
  String get reminderAtDueTime => 'À l’heure de l’échéance';

  @override
  String reminderMinutesBefore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes avant',
      one: '1 minute avant',
    );
    return '$_temp0';
  }

  @override
  String reminderHoursBefore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count heures avant',
      one: '1 heure avant',
    );
    return '$_temp0';
  }

  @override
  String reminderDaysBefore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jours avant',
      one: '1 jour avant',
    );
    return '$_temp0';
  }

  @override
  String maxRemindersReached(int count) {
    return 'Une tâche peut avoir au maximum $count rappels';
  }

  @override
  String get notificationsTitle => 'Rappels de tâches';

  @override
  String get notificationsSubtitle => 'M’avertir avant l’échéance d’une tâche';

  @override
  String get sectionReminders => 'Rappels';

  @override
  String get addToCalendarTitle => 'Ajouter au calendrier Astraea';

  @override
  String get addToCalendarSubtitle =>
      'Cette tâche apparaît aussi dans le calendrier et le widget d’Astraea, le jour de son échéance.';

  @override
  String get addToCalendarNeedsSync =>
      'Nécessite un compte, un relais et une échéance';
}
