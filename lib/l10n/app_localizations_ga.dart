// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Irish (`ga`).
class AppLocalizationsGa extends AppLocalizations {
  AppLocalizationsGa([String locale = 'ga']) : super(locale);

  @override
  String get settingsTitle => 'Socruithe';

  @override
  String get sectionAccount => 'Cuntas';

  @override
  String get addAccountTitle => 'Cuir cuntas Nostr leis';

  @override
  String get addAccountSubtitle => 'As líne faoi láthair, áitiúil amháin.';

  @override
  String get backupKeyTitle => 'Déan cúltaca den eochair phríobháideach';

  @override
  String get backupKeySubtitle =>
      'Ag teastáil chun an cuntas Nostr seo a aisghabháil.';

  @override
  String get logOut => 'Logáil amach';

  @override
  String get sectionSync => 'Sioncrónú';

  @override
  String get syncInfoTitle => 'Sioncrónú criptithe roghnach';

  @override
  String get syncInfoBody =>
      'Ní shioncrónaítear tascanna ach amháin nuair a bhíonn cuntas Nostr agus relay amháin ar a laghad cumraithe. Déantar ábhar na dtascanna a chriptiú le NIP-44 sula bhfágann sé an gléas seo.';

  @override
  String get sectionRelays => 'Relays';

  @override
  String get sectionAppearance => 'Cuma';

  @override
  String get themeLabel => 'Téama';

  @override
  String get sectionLanguage => 'Teanga';

  @override
  String get langSystem => 'Córas';

  @override
  String get sectionSupport => 'Tacaíocht';

  @override
  String get supportKairosTitle => 'Tacaigh le Kairos';

  @override
  String lightningAddressCopied(String address) {
    return 'Níor aimsíodh sparán Lightning — cóipeáladh an seoladh: $address';
  }

  @override
  String get logoutConfirmTitle => 'Logáil amach?';

  @override
  String get logoutConfirmBody =>
      'Fanfaidh do chuid tascanna ar an ngléas seo. Gan an eochair, ní féidir leo sioncrónú a dhéanamh a thuilleadh — bí cinnte go bhfuil cúltaca de do nsec agat sula logálann tú amach.';

  @override
  String get cancelButton => 'Cealaigh';

  @override
  String get nsecDialogTitle => 'D\'eochair phríobháideach (nsec)';

  @override
  String get nsecDialogWarning =>
      'Bíonn smacht ag duine ar bith a bhfuil an eochair seo aige ar do chuntas. Coinnigh í i mbainisteoir focal faire agus ná roinn í riamh.';

  @override
  String get copyButton => 'Cóipeáil';

  @override
  String get doneButton => 'Críochnaithe';

  @override
  String get signedInWithAmber => 'Sínithe isteach le Amber';

  @override
  String signedInWithKey(String npub) {
    return 'Sínithe isteach · $npub';
  }

  @override
  String get relayInvalidUrlWss =>
      'Cuir isteach URL bailí criptithe relay wss://.';

  @override
  String get relayUrlHint => 'wss://do-relay…';

  @override
  String get addRelayTooltip => 'Cuir relay leis';

  @override
  String get noRelaysConfigured => 'Níl aon relay cumraithe.';

  @override
  String get removeRelayTooltip => 'Bain relay';

  @override
  String get homeRelayTitle => 'Relay baile pearsanta';

  @override
  String get homeRelayConfiguredSubtitle =>
      'Sprioc chúltaca bhreise do do chuid tascanna criptithe';

  @override
  String get homeRelaySubtitle =>
      'Roghnach: cuir do relay féin leis mar sprioc chúltaca bhreise. Murab ionann agus relays eile, féadfaidh seo seoladh neamhchriptithe ws:// a úsáid freisin má tá sé ar do líonra áitiúil.';

  @override
  String get removeHomeRelayTooltip => 'Bain an relay baile';

  @override
  String get homeRelayUrlHint => 'wss://do relay baile, nó ws:// ar do LAN';

  @override
  String get homeRelayInvalidUrl =>
      'Cuir isteach URL bailí relay wss:// (ní cheadaítear ws:// ach amháin do relay baile ar do líonra féin).';

  @override
  String get saveButton => 'Sábháil';

  @override
  String get onboardingSaveError =>
      'Níorbh fhéidir an socrú a shábháil ar an ngléas seo.';

  @override
  String get backButton => 'Ar Ais';

  @override
  String get getStartedButton => 'Tosaigh';

  @override
  String get useOfflineButton => 'Úsáid as líne';

  @override
  String get nextButton => 'Ar Aghaidh';

  @override
  String welcomeTitle(String appName) {
    return 'Fáilte go $appName';
  }

  @override
  String get welcomeSubtitle =>
      'Bainisteoir tascanna príobháideach, dírithe, i gcóras Echoes.';

  @override
  String get featureLocalTitle => 'Is leatsa é, ar do ghléas';

  @override
  String get featureLocalBody =>
      'Stóráiltear tascanna go háitiúil ar dtús i mbunachar sonraí criptithe. Oibríonn an aip go hiomlán as líne — ní gá cuntas a bheith agat.';

  @override
  String get featureSyncTitle => 'Sioncrónú trí Nostr';

  @override
  String get featureSyncBody =>
      'Sínigh isteach le heochair Nostr agus sioncrónaíonn do chuid tascanna ar fud gléasanna trí relays a roghnaíonn tusa — gan freastalaí cuideachta sa lár.';

  @override
  String get featureEncryptedTitle => 'Criptithe ó cheann go ceann';

  @override
  String get featureEncryptedBody =>
      'Déantar gach tasc a chriptiú (NIP-44) sula bhfágann sé an gléas. Ní fheiceann relays ach téacs criptithe.';

  @override
  String get featureAmberTitle => 'Tacaíocht Amber';

  @override
  String get featureAmberBody =>
      'Ar Android is féidir leat d\'eochair a choinneáil in Amber: sín isteach amháin don tsraith iomlán, agus ní bhaineann aon aip leis an eochair féin riamh.';

  @override
  String get loginPageTitle =>
      'Sínigh isteach chun do chuid tascanna criptithe a shioncrónú';

  @override
  String get loginPageBody =>
      'Úsáid aitheantas Nostr le haghaidh sioncrónú roghnach ilghléasach, nó lean ar aghaidh gan cuntas agus coinnigh gach rud go háitiúil.';

  @override
  String get relaySetupTitle => 'Roghnaigh do relays';

  @override
  String get relaySetupBody =>
      'Stórálann relays tascanna criptithe le haghaidh sioncrónaithe le Kairos ar do ghléasanna eile. Cuir ceann amháin nó níos mó leis, nó fág folamh é agus cumraigh sioncrónú níos déanaí.';

  @override
  String get relaySettingsLoadError =>
      'Níorbh fhéidir socruithe an relay a luchtú.';

  @override
  String get taskGoneMessage => 'Níl an tasc seo ann a thuilleadh.';

  @override
  String get taskDetailsTitle => 'Tasc';

  @override
  String get editTooltip => 'Cuir in Eagar';

  @override
  String get deleteTooltip => 'Scrios';

  @override
  String get dueDateLabel => 'Dáta dlite';

  @override
  String get noneLabel => 'Neamhní';

  @override
  String get tagsLabel => 'Clibeanna';

  @override
  String get priorityLabel => 'Tosaíocht';

  @override
  String priorityValue(int priority) {
    return '$priority / 5';
  }

  @override
  String get colorLabel => 'Dath';

  @override
  String get syncStatusLabel => 'Sioncrónú';

  @override
  String get syncedStatus => 'Foilsithe ar relays';

  @override
  String get notSyncedStatus => 'Áitiúil amháin (sioncrónú ar feitheamh)';

  @override
  String get linkedEventLabel => 'Imeacht féilire nasctha';

  @override
  String createdUpdatedInfo(String created, String updated) {
    return 'Cruthaithe $created\nNuashonraithe $updated';
  }

  @override
  String get deleteTaskConfirmTitle => 'An tasc seo a scriosadh?';

  @override
  String get deleteTaskConfirmBody =>
      'Baintear an tasc go háitiúil agus seoltar iarratas scriosta chuig do chuid relays.';

  @override
  String get deleteButton => 'Scrios';

  @override
  String get deleteTaskError =>
      'Níorbh fhéidir an tasc a scriosadh go háitiúil.';

  @override
  String get saveTaskError => 'Níorbh fhéidir an tasc a shábháil go háitiúil.';

  @override
  String get editTaskTitle => 'Cuir tasc in eagar';

  @override
  String get newTaskTitle => 'Tasc nua';

  @override
  String get syncToNostrTitle => 'Sioncronaigh le Nostr';

  @override
  String get syncToNostrSubtitle =>
      'Foilsíonn sé an tasc, criptithe, chuig do sheachadáin. Nuair atá sé múchta, fanann sé ar an ngléas seo amháin.';

  @override
  String get syncTaskButton => 'Sioncronaigh an tasc';

  @override
  String get localOnlyStatus => 'Áitiúil amháin (sioncronú múchta)';

  @override
  String get titleFieldLabel => 'Teideal';

  @override
  String get titleRequiredError => 'Tá teideal ag teastáil.';

  @override
  String get titleTooLongError => 'Tá an teideal rófhada.';

  @override
  String get descriptionFieldLabel => 'Cur síos (roghnach)';

  @override
  String get noDueDateLabel => 'Gan dáta dlite';

  @override
  String get optionalDeadlineHint => 'Sprioc-am roghnach.';

  @override
  String get clearDueDateTooltip => 'Glan an dáta dlite';

  @override
  String get tagsFieldLabel => 'Clibeanna (deighilte le camóga, roghnach)';

  @override
  String get tagsFieldHint => 'obair, pearsanta';

  @override
  String get tooManyTagsError => 'Ná húsáid ach 32 chlib ar a mhéad.';

  @override
  String get tagTooLongError =>
      'Ní mór gach clib a bheith 64 charachtar ar a mhéad.';

  @override
  String get priorityScaleHint => '1 = íseal, 5 = ard';

  @override
  String get syncNowTooltip => 'Sioncrónaigh anois';

  @override
  String get settingsTooltip => 'Socruithe';

  @override
  String get newTaskTooltip => 'Tasc nua';

  @override
  String get loadTasksError => 'Níorbh fhéidir na tascanna áitiúla a luchtú.';

  @override
  String get emptyTasksTitle => 'Níl aon tascanna ann fós';

  @override
  String get emptyTasksBody => 'Tapáil + chun do chéad tasc a chur leis.';

  @override
  String completedCount(int count) {
    return 'Críochnaithe ($count)';
  }

  @override
  String get invalidKeyError =>
      'Níl an eochair phríobháideach sin bailí. Seiceáil í agus bain triail eile as.';

  @override
  String get signInError =>
      'Níorbh fhéidir síniú isteach. Bain triail eile as le do thoil.';

  @override
  String get signInAmberButton => 'Sínigh isteach le Amber';

  @override
  String get createAccountButton => 'Cruthaigh cuntas nua';

  @override
  String get generatedAccountHint =>
      'Ní féidir cuntas ginte a aisghabháil ach lena eochair phríobháideach féin. Déan cúltaca de sna Socruithe tar éis an tsocraithe.';

  @override
  String get importKeyButton => 'Iompórtáil eochair atá ann cheana';

  @override
  String get importKeyFieldLabel =>
      'nsec nó eochair phríobháideach heicsidheachúlach';

  @override
  String get importButton => 'Iompórtáil';

  @override
  String get storageFailureMessage =>
      'Níorbh fhéidir le Kairos a bhunachar sonraí áitiúil criptithe a oscailt. Atosaigh an aip. Ná glan sonraí na haipe; má leanann an fhadhb, tuairiscigh í go príobháideach.';

  @override
  String get remindersLabel => 'Meabhrúcháin';

  @override
  String get addReminderButton => 'Cuir meabhrúchán leis';

  @override
  String get remindersNeedDueDate =>
      'Socraigh spriocdháta chun meabhrúcháin a chur leis';

  @override
  String get removeReminderTooltip => 'Bain an meabhrúchán';

  @override
  String get reminderAtDueTime => 'Ag am an spriocdháta';

  @override
  String reminderMinutesBefore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nóiméad roimh ré',
      many: '$count nóiméad roimh ré',
      few: '$count nóiméad roimh ré',
      two: '$count nóiméad roimh ré',
      one: '$count nóiméad roimh ré',
    );
    return '$_temp0';
  }

  @override
  String reminderHoursBefore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count uair roimh ré',
      many: '$count n-uaire roimh ré',
      few: '$count huaire roimh ré',
      two: '$count uair roimh ré',
      one: '$count uair roimh ré',
    );
    return '$_temp0';
  }

  @override
  String reminderDaysBefore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lá roimh ré',
      many: '$count lá roimh ré',
      few: '$count lá roimh ré',
      two: '$count lá roimh ré',
      one: '$count lá roimh ré',
    );
    return '$_temp0';
  }

  @override
  String maxRemindersReached(int count) {
    return 'Ní féidir níos mó ná $count meabhrúchán a bheith ag tasc';
  }

  @override
  String get notificationsTitle => 'Meabhrúcháin tascanna';

  @override
  String get notificationsSubtitle => 'Cuir in iúl dom roimh spriocdháta taisc';

  @override
  String get sectionReminders => 'Meabhrúcháin';

  @override
  String get addToCalendarTitle => 'Cuir le féilire Astraea';

  @override
  String get addToCalendarSubtitle =>
      'Taispeántar an tasc seo i bhféilire agus i ngiuirléid Astraea freisin, ar lá an spriocdháta.';

  @override
  String get addToCalendarNeedsSync =>
      'Teastaíonn cuntas, athsheachadán agus spriocdháta';
}
