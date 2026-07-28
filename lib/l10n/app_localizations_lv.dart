// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Latvian (`lv`).
class AppLocalizationsLv extends AppLocalizations {
  AppLocalizationsLv([String locale = 'lv']) : super(locale);

  @override
  String get settingsTitle => 'Iestatījumi';

  @override
  String get sectionAccount => 'Konts';

  @override
  String get addAccountTitle => 'Pievienot Nostr kontu';

  @override
  String get addAccountSubtitle => 'Pašlaik bezsaistē, tikai lokāli.';

  @override
  String get backupKeyTitle => 'Rezerves privātās atslēgas kopija';

  @override
  String get backupKeySubtitle => 'Nepieciešama, lai atjaunotu šo Nostr kontu.';

  @override
  String get logOut => 'Izrakstīties';

  @override
  String get sectionSync => 'Sinhronizācija';

  @override
  String get syncInfoTitle => 'Neobligāta šifrēta sinhronizācija';

  @override
  String get syncInfoBody =>
      'Uzdevumi tiek sinhronizēti tikai tad, kad ir konfigurēts Nostr konts un vismaz viens releja serveris. Uzdevumu saturs tiek šifrēts ar NIP-44, pirms tas atstāj šo ierīci.';

  @override
  String get sectionRelays => 'Releja serveri';

  @override
  String get sectionAppearance => 'Izskats';

  @override
  String get themeLabel => 'Motīvs';

  @override
  String get sectionLanguage => 'Valoda';

  @override
  String get langSystem => 'Sistēmas';

  @override
  String get sectionSupport => 'Atbalsts';

  @override
  String get supportKairosTitle => 'Atbalsti Kairos';

  @override
  String lightningAddressCopied(String address) {
    return 'Lightning maks netika atrasts — adrese nokopēta: $address';
  }

  @override
  String get logoutConfirmTitle => 'Izrakstīties?';

  @override
  String get logoutConfirmBody =>
      'Jūsu uzdevumi paliks šajā ierīcē. Bez atslēgas tos vairs nevarēs sinhronizēt — pirms izrakstīšanās pārliecinieties, ka jums ir sava nsec rezerves kopija.';

  @override
  String get cancelButton => 'Atcelt';

  @override
  String get nsecDialogTitle => 'Jūsu privātā atslēga (nsec)';

  @override
  String get nsecDialogWarning =>
      'Ikviens, kam ir šī atslēga, kontrolē jūsu kontu. Glabājiet to paroļu pārvaldniekā un nekad ar to nedalieties.';

  @override
  String get copyButton => 'Kopēt';

  @override
  String get doneButton => 'Gatavs';

  @override
  String get signedInWithAmber => 'Pierakstījies ar Amber';

  @override
  String signedInWithKey(String npub) {
    return 'Pierakstījies · $npub';
  }

  @override
  String get relayInvalidUrlWss =>
      'Ievadiet derīgu šifrētu wss:// releja servera adresi.';

  @override
  String get relayUrlHint => 'wss://jūsu-releja-serveris…';

  @override
  String get addRelayTooltip => 'Pievienot releja serveri';

  @override
  String get noRelaysConfigured => 'Nav konfigurēts neviens releja serveris.';

  @override
  String get removeRelayTooltip => 'Noņemt releja serveri';

  @override
  String get homeRelayTitle => 'Personīgais mājas releja serveris';

  @override
  String get homeRelayConfiguredSubtitle =>
      'Papildu rezerves vieta jūsu šifrētajiem uzdevumiem';

  @override
  String get homeRelaySubtitle =>
      'Neobligāti: pievienojiet savu releja serveri kā papildu rezerves vietu. Atšķirībā no citiem releja serveriem, šis var izmantot arī nešifrētu ws:// adresi, ja tas atrodas jūsu lokālajā tīklā.';

  @override
  String get removeHomeRelayTooltip => 'Noņemt mājas releja serveri';

  @override
  String get homeRelayUrlHint =>
      'wss://jūsu-mājas-releja-serveris vai ws:// lokālajā tīklā';

  @override
  String get homeRelayInvalidUrl =>
      'Ievadiet derīgu wss:// releja servera adresi (ws:// ir atļauts tikai mājas releja serverim jūsu pašu tīklā).';

  @override
  String get saveButton => 'Saglabāt';

  @override
  String get onboardingSaveError =>
      'Neizdevās saglabāt iestatījumus šajā ierīcē.';

  @override
  String get backButton => 'Atpakaļ';

  @override
  String get getStartedButton => 'Sākt';

  @override
  String get useOfflineButton => 'Izmantot bezsaistē';

  @override
  String get nextButton => 'Tālāk';

  @override
  String welcomeTitle(String appName) {
    return 'Laipni lūdzam $appName';
  }

  @override
  String get welcomeSubtitle =>
      'Privāts, fokusēts uzdevumu pārvaldnieks Echoes ekosistēmā.';

  @override
  String get featureLocalTitle => 'Jūsu, jūsu ierīcē';

  @override
  String get featureLocalBody =>
      'Uzdevumi vispirms tiek saglabāti lokāli šifrētā datubāzē. Lietotne darbojas pilnībā bezsaistē — konts nav nepieciešams.';

  @override
  String get featureSyncTitle => 'Sinhronizācija caur Nostr';

  @override
  String get featureSyncBody =>
      'Pierakstieties ar Nostr atslēgu, un jūsu uzdevumi sinhronizēsies starp ierīcēm caur jūsu izvēlētajiem releja serveriem — bez uzņēmuma servera pa vidu.';

  @override
  String get featureEncryptedTitle => 'Šifrēts no gala līdz galam';

  @override
  String get featureEncryptedBody =>
      'Katrs uzdevums tiek šifrēts (NIP-44), pirms tas atstāj ierīci. Releja serveri redz tikai šifrētu tekstu.';

  @override
  String get featureAmberTitle => 'Amber atbalsts';

  @override
  String get featureAmberBody =>
      'Android ierīcē varat glabāt savu atslēgu lietotnē Amber: viena pieteikšanās visai lietotņu saimei, un neviena lietotne nekad nepieskaras pašai atslēgai.';

  @override
  String get loginPageTitle =>
      'Pierakstieties, lai sinhronizētu savus šifrētos uzdevumus';

  @override
  String get loginPageBody =>
      'Izmantojiet Nostr identitāti neobligātai sinhronizācijai starp vairākām ierīcēm vai turpiniet bez konta un saglabājiet visu lokāli.';

  @override
  String get relaySetupTitle => 'Izvēlieties savus releja serverus';

  @override
  String get relaySetupBody =>
      'Releja serveri glabā šifrētus uzdevumus sinhronizācijai ar Kairos jūsu citās ierīcēs. Pievienojiet vienu vai vairākus, vai atstājiet tukšu un konfigurējiet sinhronizāciju vēlāk.';

  @override
  String get relaySettingsLoadError =>
      'Neizdevās ielādēt releja servera iestatījumus.';

  @override
  String get taskGoneMessage => 'Šis uzdevums vairs neeksistē.';

  @override
  String get taskDetailsTitle => 'Uzdevums';

  @override
  String get editTooltip => 'Rediģēt';

  @override
  String get deleteTooltip => 'Dzēst';

  @override
  String get dueDateLabel => 'Izpildes termiņš';

  @override
  String get noneLabel => 'Nav';

  @override
  String get tagsLabel => 'Birkas';

  @override
  String get priorityLabel => 'Prioritāte';

  @override
  String priorityValue(int priority) {
    return '$priority / 5';
  }

  @override
  String get colorLabel => 'Krāsa';

  @override
  String get syncStatusLabel => 'Sinhronizācija';

  @override
  String get syncedStatus => 'Publicēts releja serveros';

  @override
  String get notSyncedStatus => 'Tikai lokāli (gaida sinhronizāciju)';

  @override
  String get linkedEventLabel => 'Saistītais kalendāra notikums';

  @override
  String createdUpdatedInfo(String created, String updated) {
    return 'Izveidots $created\nAtjaunināts $updated';
  }

  @override
  String get deleteTaskConfirmTitle => 'Dzēst šo uzdevumu?';

  @override
  String get deleteTaskConfirmBody =>
      'Uzdevums tiek noņemts lokāli, un dzēšanas pieprasījums tiek nosūtīts jūsu releja serveriem.';

  @override
  String get deleteButton => 'Dzēst';

  @override
  String get deleteTaskError => 'Neizdevās lokāli dzēst uzdevumu.';

  @override
  String get saveTaskError => 'Neizdevās lokāli saglabāt uzdevumu.';

  @override
  String get editTaskTitle => 'Rediģēt uzdevumu';

  @override
  String get newTaskTitle => 'Jauns uzdevums';

  @override
  String get syncToNostrTitle => 'Sinhronizēt ar Nostr';

  @override
  String get syncToNostrSubtitle =>
      'Publicē uzdevumu šifrētā veidā jūsu relejos. Ja izslēgts, tas paliek tikai šajā ierīcē.';

  @override
  String get syncTaskButton => 'Sinhronizēt uzdevumu';

  @override
  String get localOnlyStatus => 'Tikai lokāli (sinhronizācija izslēgta)';

  @override
  String get titleFieldLabel => 'Nosaukums';

  @override
  String get titleRequiredError => 'Nosaukums ir obligāts.';

  @override
  String get titleTooLongError => 'Nosaukums ir pārāk garš.';

  @override
  String get descriptionFieldLabel => 'Apraksts (neobligāts)';

  @override
  String get noDueDateLabel => 'Bez izpildes termiņa';

  @override
  String get optionalDeadlineHint => 'Neobligāts termiņš.';

  @override
  String get clearDueDateTooltip => 'Notīrīt izpildes termiņu';

  @override
  String get tagsFieldLabel => 'Birkas (atdalītas ar komatu, neobligāti)';

  @override
  String get tagsFieldHint => 'darbs, personīgi';

  @override
  String get tooManyTagsError => 'Izmantojiet ne vairāk kā 32 birkas.';

  @override
  String get tagTooLongError =>
      'Katrai birkai jābūt ne garākai par 64 rakstzīmēm.';

  @override
  String get priorityScaleHint => '1 = zema, 5 = augsta';

  @override
  String get syncNowTooltip => 'Sinhronizēt tagad';

  @override
  String get settingsTooltip => 'Iestatījumi';

  @override
  String get newTaskTooltip => 'Jauns uzdevums';

  @override
  String get loadTasksError => 'Neizdevās ielādēt lokālos uzdevumus.';

  @override
  String get emptyTasksTitle => 'Vēl nav neviena uzdevuma';

  @override
  String get emptyTasksBody =>
      'Pieskarieties +, lai pievienotu savu pirmo uzdevumu.';

  @override
  String completedCount(int count) {
    return 'Pabeigts ($count)';
  }

  @override
  String get invalidKeyError =>
      'Šī privātā atslēga nav derīga. Pārbaudiet to un mēģiniet vēlreiz.';

  @override
  String get signInError => 'Neizdevās pierakstīties. Lūdzu, mēģiniet vēlreiz.';

  @override
  String get signInAmberButton => 'Pierakstīties ar Amber';

  @override
  String get createAccountButton => 'Izveidot jaunu kontu';

  @override
  String get generatedAccountHint =>
      'Ģenerētu kontu var atjaunot tikai ar tā privāto atslēgu. Izveidojiet rezerves kopiju Iestatījumos pēc iestatīšanas.';

  @override
  String get importKeyButton => 'Importēt esošu atslēgu';

  @override
  String get importKeyFieldLabel => 'nsec vai heksadecimālā privātā atslēga';

  @override
  String get importButton => 'Importēt';

  @override
  String get storageFailureMessage =>
      'Kairos neizdevās atvērt savu šifrēto lokālo datubāzi. Restartējiet lietotni. Nedzēsiet lietotnes datus; ja problēma turpinās, ziņojiet par to privāti.';

  @override
  String get remindersLabel => 'Atgādinājumi';

  @override
  String get addReminderButton => 'Pievienot atgādinājumu';

  @override
  String get remindersNeedDueDate =>
      'Iestati termiņu, lai pievienotu atgādinājumus';

  @override
  String get removeReminderTooltip => 'Noņemt atgādinājumu';

  @override
  String get reminderAtDueTime => 'Termiņa brīdī';

  @override
  String reminderMinutesBefore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minūtes iepriekš',
      one: '$count minūti iepriekš',
      zero: '$count minūšu iepriekš',
    );
    return '$_temp0';
  }

  @override
  String reminderHoursBefore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count stundas iepriekš',
      one: '$count stundu iepriekš',
      zero: '$count stundu iepriekš',
    );
    return '$_temp0';
  }

  @override
  String reminderDaysBefore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dienas iepriekš',
      one: '$count dienu iepriekš',
      zero: '$count dienu iepriekš',
    );
    return '$_temp0';
  }

  @override
  String maxRemindersReached(int count) {
    return 'Uzdevumam var būt ne vairāk kā $count atgādinājumi';
  }

  @override
  String get notificationsTitle => 'Uzdevumu atgādinājumi';

  @override
  String get notificationsSubtitle => 'Paziņot man pirms uzdevuma termiņa';

  @override
  String get sectionReminders => 'Atgādinājumi';

  @override
  String get addToCalendarTitle => 'Pievienot Astraea kalendāram';

  @override
  String get addToCalendarSubtitle =>
      'Šis uzdevums termiņa dienā parādās arī Astraea kalendārā un logrīkā.';

  @override
  String get addToCalendarNeedsSync => 'Nepieciešams konts, relejs un termiņš';
}
