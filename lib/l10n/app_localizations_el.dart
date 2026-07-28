// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Modern Greek (`el`).
class AppLocalizationsEl extends AppLocalizations {
  AppLocalizationsEl([String locale = 'el']) : super(locale);

  @override
  String get settingsTitle => 'Ρυθμίσεις';

  @override
  String get sectionAccount => 'Λογαριασμός';

  @override
  String get addAccountTitle => 'Προσθήκη λογαριασμού Nostr';

  @override
  String get addAccountSubtitle => 'Προς το παρόν εκτός σύνδεσης, μόνο τοπικά.';

  @override
  String get backupKeyTitle =>
      'Δημιουργία αντιγράφου ασφαλείας ιδιωτικού κλειδιού';

  @override
  String get backupKeySubtitle =>
      'Απαιτείται για την ανάκτηση αυτού του λογαριασμού Nostr.';

  @override
  String get logOut => 'Αποσύνδεση';

  @override
  String get sectionSync => 'Συγχρονισμός';

  @override
  String get syncInfoTitle => 'Προαιρετικός κρυπτογραφημένος συγχρονισμός';

  @override
  String get syncInfoBody =>
      'Οι εργασίες συγχρονίζονται μόνο όταν έχει διαμορφωθεί λογαριασμός Nostr και τουλάχιστον ένα relay. Το περιεχόμενο των εργασιών κρυπτογραφείται με NIP-44 πριν φύγει από τη συσκευή.';

  @override
  String get sectionRelays => 'Relays';

  @override
  String get sectionAppearance => 'Εμφάνιση';

  @override
  String get themeLabel => 'Θέμα';

  @override
  String get sectionLanguage => 'Γλώσσα';

  @override
  String get langSystem => 'Σύστημα';

  @override
  String get sectionSupport => 'Υποστήριξη';

  @override
  String get supportKairosTitle => 'Υποστηρίξτε το Kairos';

  @override
  String lightningAddressCopied(String address) {
    return 'Δεν βρέθηκε πορτοφόλι Lightning — η διεύθυνση αντιγράφηκε: $address';
  }

  @override
  String get logoutConfirmTitle => 'Αποσύνδεση;';

  @override
  String get logoutConfirmBody =>
      'Οι εργασίες σας παραμένουν σε αυτή τη συσκευή. Χωρίς το κλειδί, δεν μπορούν πλέον να συγχρονιστούν — βεβαιωθείτε ότι έχετε αντίγραφο ασφαλείας του nsec σας πριν αποσυνδεθείτε.';

  @override
  String get cancelButton => 'Ακύρωση';

  @override
  String get nsecDialogTitle => 'Το ιδιωτικό σας κλειδί (nsec)';

  @override
  String get nsecDialogWarning =>
      'Όποιος έχει αυτό το κλειδί ελέγχει τον λογαριασμό σας. Αποθηκεύστε το σε διαχειριστή κωδικών και μην το μοιραστείτε ποτέ.';

  @override
  String get copyButton => 'Αντιγραφή';

  @override
  String get doneButton => 'Τέλος';

  @override
  String get signedInWithAmber => 'Συνδεθήκατε με Amber';

  @override
  String signedInWithKey(String npub) {
    return 'Συνδεδεμένος/η · $npub';
  }

  @override
  String get relayInvalidUrlWss =>
      'Εισαγάγετε μια έγκυρη κρυπτογραφημένη διεύθυνση relay wss://.';

  @override
  String get relayUrlHint => 'wss://το-relay-σας…';

  @override
  String get addRelayTooltip => 'Προσθήκη relay';

  @override
  String get noRelaysConfigured => 'Δεν έχουν διαμορφωθεί relays.';

  @override
  String get removeRelayTooltip => 'Αφαίρεση relay';

  @override
  String get homeRelayTitle => 'Προσωπικό relay οικίας';

  @override
  String get homeRelayConfiguredSubtitle =>
      'Επιπλέον στόχος αντιγράφου ασφαλείας για τις κρυπτογραφημένες εργασίες σας';

  @override
  String get homeRelaySubtitle =>
      'Προαιρετικό: προσθέστε το δικό σας relay ως επιπλέον στόχο αντιγράφου ασφαλείας. Σε αντίθεση με άλλα relays, αυτό μπορεί επίσης να χρησιμοποιεί μη κρυπτογραφημένη διεύθυνση ws:// αν βρίσκεται στο τοπικό σας δίκτυο.';

  @override
  String get removeHomeRelayTooltip => 'Αφαίρεση relay οικίας';

  @override
  String get homeRelayUrlHint =>
      'wss://το-relay-οικίας-σας, ή ws:// στο τοπικό σας δίκτυο';

  @override
  String get homeRelayInvalidUrl =>
      'Εισαγάγετε μια έγκυρη διεύθυνση relay wss:// (το ws:// επιτρέπεται μόνο για relay οικίας στο δικό σας δίκτυο).';

  @override
  String get saveButton => 'Αποθήκευση';

  @override
  String get onboardingSaveError =>
      'Δεν ήταν δυνατή η αποθήκευση της ρύθμισης σε αυτή τη συσκευή.';

  @override
  String get backButton => 'Πίσω';

  @override
  String get getStartedButton => 'Ξεκινήστε';

  @override
  String get useOfflineButton => 'Χρήση εκτός σύνδεσης';

  @override
  String get nextButton => 'Επόμενο';

  @override
  String welcomeTitle(String appName) {
    return 'Καλώς ήρθατε στο $appName';
  }

  @override
  String get welcomeSubtitle =>
      'Ένας ιδιωτικός, εστιασμένος διαχειριστής εργασιών στο οικοσύστημα Echoes.';

  @override
  String get featureLocalTitle => 'Δικό σας, στη συσκευή σας';

  @override
  String get featureLocalBody =>
      'Οι εργασίες αποθηκεύονται πρώτα τοπικά σε μια κρυπτογραφημένη βάση δεδομένων. Η εφαρμογή λειτουργεί πλήρως εκτός σύνδεσης — δεν απαιτείται λογαριασμός.';

  @override
  String get featureSyncTitle => 'Συγχρονισμός μέσω Nostr';

  @override
  String get featureSyncBody =>
      'Συνδεθείτε με κλειδί Nostr και οι εργασίες σας συγχρονίζονται σε όλες τις συσκευές μέσω relays που επιλέγετε εσείς — χωρίς εταιρικό διακομιστή στη μέση.';

  @override
  String get featureEncryptedTitle => 'Κρυπτογράφηση από άκρο σε άκρο';

  @override
  String get featureEncryptedBody =>
      'Κάθε εργασία κρυπτογραφείται (NIP-44) πριν φύγει από τη συσκευή. Τα relays βλέπουν μόνο κρυπτογραφημένο κείμενο.';

  @override
  String get featureAmberTitle => 'Υποστήριξη Amber';

  @override
  String get featureAmberBody =>
      'Σε Android μπορείτε να κρατήσετε το κλειδί σας στο Amber: μία σύνδεση για ολόκληρη τη σουίτα, χωρίς καμία εφαρμογή να αγγίζει ποτέ το ίδιο το κλειδί.';

  @override
  String get loginPageTitle =>
      'Συνδεθείτε για συγχρονισμό των κρυπτογραφημένων εργασιών σας';

  @override
  String get loginPageBody =>
      'Χρησιμοποιήστε μια ταυτότητα Nostr για προαιρετικό συγχρονισμό πολλαπλών συσκευών, ή συνεχίστε χωρίς λογαριασμό διατηρώντας τα πάντα τοπικά.';

  @override
  String get relaySetupTitle => 'Επιλέξτε τα relays σας';

  @override
  String get relaySetupBody =>
      'Τα relays αποθηκεύουν κρυπτογραφημένες εργασίες για συγχρονισμό με το Kairos στις άλλες συσκευές σας. Προσθέστε ένα ή περισσότερα, ή αφήστε το κενό και ρυθμίστε τον συγχρονισμό αργότερα.';

  @override
  String get relaySettingsLoadError =>
      'Δεν ήταν δυνατή η φόρτωση των ρυθμίσεων relay.';

  @override
  String get taskGoneMessage => 'Αυτή η εργασία δεν υπάρχει πια.';

  @override
  String get taskDetailsTitle => 'Εργασία';

  @override
  String get editTooltip => 'Επεξεργασία';

  @override
  String get deleteTooltip => 'Διαγραφή';

  @override
  String get dueDateLabel => 'Ημερομηνία λήξης';

  @override
  String get noneLabel => 'Καμία';

  @override
  String get tagsLabel => 'Ετικέτες';

  @override
  String get priorityLabel => 'Προτεραιότητα';

  @override
  String priorityValue(int priority) {
    return '$priority / 5';
  }

  @override
  String get colorLabel => 'Χρώμα';

  @override
  String get syncStatusLabel => 'Συγχρονισμός';

  @override
  String get syncedStatus => 'Δημοσιεύτηκε στα relays';

  @override
  String get notSyncedStatus => 'Μόνο τοπικά (εκκρεμεί συγχρονισμός)';

  @override
  String get linkedEventLabel => 'Συνδεδεμένο συμβάν ημερολογίου';

  @override
  String createdUpdatedInfo(String created, String updated) {
    return 'Δημιουργήθηκε $created\nΕνημερώθηκε $updated';
  }

  @override
  String get deleteTaskConfirmTitle => 'Διαγραφή αυτής της εργασίας;';

  @override
  String get deleteTaskConfirmBody =>
      'Η εργασία αφαιρείται τοπικά και ένα αίτημα διαγραφής αποστέλλεται στα relays σας.';

  @override
  String get deleteButton => 'Διαγραφή';

  @override
  String get deleteTaskError =>
      'Δεν ήταν δυνατή η τοπική διαγραφή της εργασίας.';

  @override
  String get saveTaskError =>
      'Δεν ήταν δυνατή η τοπική αποθήκευση της εργασίας.';

  @override
  String get editTaskTitle => 'Επεξεργασία εργασίας';

  @override
  String get newTaskTitle => 'Νέα εργασία';

  @override
  String get syncToNostrTitle => 'Συγχρονισμός στο Nostr';

  @override
  String get syncToNostrSubtitle =>
      'Δημοσιεύει την εργασία, κρυπτογραφημένη, στους αναμεταδότες σας. Αν είναι ανενεργό, μένει μόνο σε αυτήν τη συσκευή.';

  @override
  String get syncTaskButton => 'Συγχρονισμός εργασίας';

  @override
  String get localOnlyStatus => 'Μόνο τοπικά (συγχρονισμός ανενεργός)';

  @override
  String get titleFieldLabel => 'Τίτλος';

  @override
  String get titleRequiredError => 'Απαιτείται τίτλος.';

  @override
  String get titleTooLongError => 'Ο τίτλος είναι πολύ μεγάλος.';

  @override
  String get descriptionFieldLabel => 'Περιγραφή (προαιρετικό)';

  @override
  String get noDueDateLabel => 'Χωρίς ημερομηνία λήξης';

  @override
  String get optionalDeadlineHint => 'Προαιρετική προθεσμία.';

  @override
  String get clearDueDateTooltip => 'Καθαρισμός ημερομηνίας λήξης';

  @override
  String get tagsFieldLabel => 'Ετικέτες (χωρισμένες με κόμμα, προαιρετικό)';

  @override
  String get tagsFieldHint => 'εργασία, προσωπικά';

  @override
  String get tooManyTagsError => 'Χρησιμοποιήστε το πολύ 32 ετικέτες.';

  @override
  String get tagTooLongError =>
      'Κάθε ετικέτα πρέπει να έχει έως 64 χαρακτήρες.';

  @override
  String get priorityScaleHint => '1 = χαμηλή, 5 = υψηλή';

  @override
  String get syncNowTooltip => 'Συγχρονισμός τώρα';

  @override
  String get settingsTooltip => 'Ρυθμίσεις';

  @override
  String get newTaskTooltip => 'Νέα εργασία';

  @override
  String get loadTasksError =>
      'Δεν ήταν δυνατή η φόρτωση των τοπικών εργασιών.';

  @override
  String get emptyTasksTitle => 'Δεν υπάρχουν εργασίες ακόμα';

  @override
  String get emptyTasksBody =>
      'Πατήστε + για να προσθέσετε την πρώτη σας εργασία.';

  @override
  String completedCount(int count) {
    return 'Ολοκληρωμένες ($count)';
  }

  @override
  String get invalidKeyError =>
      'Αυτό το ιδιωτικό κλειδί δεν είναι έγκυρο. Ελέγξτε το και δοκιμάστε ξανά.';

  @override
  String get signInError => 'Δεν ήταν δυνατή η σύνδεση. Δοκιμάστε ξανά.';

  @override
  String get signInAmberButton => 'Σύνδεση με Amber';

  @override
  String get createAccountButton => 'Δημιουργία νέου λογαριασμού';

  @override
  String get generatedAccountHint =>
      'Ένας λογαριασμός που δημιουργείται αυτόματα μπορεί να ανακτηθεί μόνο με το ιδιωτικό του κλειδί. Δημιουργήστε αντίγραφο ασφαλείας από τις Ρυθμίσεις μετά τη ρύθμιση.';

  @override
  String get importKeyButton => 'Εισαγωγή υπάρχοντος κλειδιού';

  @override
  String get importKeyFieldLabel => 'nsec ή δεκαεξαδικό ιδιωτικό κλειδί';

  @override
  String get importButton => 'Εισαγωγή';

  @override
  String get storageFailureMessage =>
      'Το Kairos δεν μπόρεσε να ανοίξει την κρυπτογραφημένη τοπική βάση δεδομένων του. Επανεκκινήστε την εφαρμογή. Μην διαγράψετε τα δεδομένα της εφαρμογής· αν το πρόβλημα παραμένει, αναφέρετέ το ιδιωτικά.';

  @override
  String get remindersLabel => 'Υπενθυμίσεις';

  @override
  String get addReminderButton => 'Προσθήκη υπενθύμισης';

  @override
  String get remindersNeedDueDate =>
      'Όρισε προθεσμία για να προσθέσεις υπενθυμίσεις';

  @override
  String get removeReminderTooltip => 'Αφαίρεση υπενθύμισης';

  @override
  String get reminderAtDueTime => 'Την ώρα της προθεσμίας';

  @override
  String reminderMinutesBefore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count λεπτά πριν',
      one: '1 λεπτό πριν',
    );
    return '$_temp0';
  }

  @override
  String reminderHoursBefore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ώρες πριν',
      one: '1 ώρα πριν',
    );
    return '$_temp0';
  }

  @override
  String reminderDaysBefore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ημέρες πριν',
      one: '1 ημέρα πριν',
    );
    return '$_temp0';
  }

  @override
  String maxRemindersReached(int count) {
    return 'Μια εργασία μπορεί να έχει το πολύ $count υπενθυμίσεις';
  }

  @override
  String get notificationsTitle => 'Υπενθυμίσεις εργασιών';

  @override
  String get notificationsSubtitle =>
      'Ειδοποίησέ με πριν από την προθεσμία μιας εργασίας';

  @override
  String get sectionReminders => 'Υπενθυμίσεις';

  @override
  String get addToCalendarTitle => 'Προσθήκη στο ημερολόγιο Astraea';

  @override
  String get addToCalendarSubtitle =>
      'Αυτή η εργασία εμφανίζεται και στο ημερολόγιο και το widget του Astraea, την ημέρα της προθεσμίας.';

  @override
  String get addToCalendarNeedsSync =>
      'Απαιτεί λογαριασμό, relay και προθεσμία';
}
