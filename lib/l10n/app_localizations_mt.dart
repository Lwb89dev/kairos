// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Maltese (`mt`).
class AppLocalizationsMt extends AppLocalizations {
  AppLocalizationsMt([String locale = 'mt']) : super(locale);

  @override
  String get settingsTitle => 'Issettjar';

  @override
  String get sectionAccount => 'Kont';

  @override
  String get addAccountTitle => 'Żid kont Nostr';

  @override
  String get addAccountSubtitle => 'Bħalissa offline, lokali biss.';

  @override
  String get backupKeyTitle => 'Ħu kopja tal-appoġġ taċ-ċavetta privata';

  @override
  String get backupKeySubtitle => 'Meħtieġa biex tirkupra dan il-kont Nostr.';

  @override
  String get logOut => 'Oħroġ';

  @override
  String get sectionSync => 'Sinkronizzazzjoni';

  @override
  String get syncInfoTitle => 'Sinkronizzazzjoni kriptata mhux obbligatorja';

  @override
  String get syncInfoBody =>
      'Il-kompiti jissinkronizzaw biss meta jkunu kkonfigurati kont Nostr u tal-inqas relay wieħed. Il-kontenut tal-kompiti jiġi kriptat b\'NIP-44 qabel ma joħroġ minn dan l-apparat.';

  @override
  String get sectionRelays => 'Relays';

  @override
  String get sectionAppearance => 'Dehra';

  @override
  String get themeLabel => 'Tema';

  @override
  String get sectionLanguage => 'Lingwa';

  @override
  String get langSystem => 'Sistema';

  @override
  String get sectionSupport => 'Appoġġ';

  @override
  String get supportKairosTitle => 'Appoġġja lil Kairos';

  @override
  String lightningAddressCopied(String address) {
    return 'Ma nstab l-ebda kartafoll Lightning — l-indirizz ġie kkupjat: $address';
  }

  @override
  String get logoutConfirmTitle => 'Toħroġ?';

  @override
  String get logoutConfirmBody =>
      'Il-kompiti tiegħek jibqgħu fuq dan l-apparat. Mingħajr iċ-ċavetta, ma jistgħux jibqgħu jissinkronizzaw — kun żgur li għandek kopja tal-appoġġ tan-nsec tiegħek qabel toħroġ.';

  @override
  String get cancelButton => 'Ikkanċella';

  @override
  String get nsecDialogTitle => 'Iċ-ċavetta privata tiegħek (nsec)';

  @override
  String get nsecDialogWarning =>
      'Kull min għandu din iċ-ċavetta jikkontrolla l-kont tiegħek. Aħżinha f\'maniġer tal-passwords u qatt taqsamha ma\' ħadd.';

  @override
  String get copyButton => 'Ikkupja';

  @override
  String get doneButton => 'Lest';

  @override
  String get signedInWithAmber => 'Idħalt bl-Amber';

  @override
  String signedInWithKey(String npub) {
    return 'Idħalt · $npub';
  }

  @override
  String get relayInvalidUrlWss =>
      'Daħħal URL validu ta\' relay kriptat wss://.';

  @override
  String get relayUrlHint => 'wss://ir-relay-tiegħek…';

  @override
  String get addRelayTooltip => 'Żid relay';

  @override
  String get noRelaysConfigured => 'L-ebda relay ikkonfigurat.';

  @override
  String get removeRelayTooltip => 'Neħħi relay';

  @override
  String get homeRelayTitle => 'Relay personali tad-dar';

  @override
  String get homeRelayConfiguredSubtitle =>
      'Mira addizzjonali ta\' kopja tal-appoġġ għall-kompiti kriptati tiegħek';

  @override
  String get homeRelaySubtitle =>
      'Mhux obbligatorju: żid ir-relay tiegħek stess bħala mira addizzjonali ta\' kopja tal-appoġġ. B\'differenza minn relays oħra, dan jista\' juża wkoll indirizz ws:// mhux kriptat jekk ikun fuq in-network lokali tiegħek.';

  @override
  String get removeHomeRelayTooltip => 'Neħħi r-relay tad-dar';

  @override
  String get homeRelayUrlHint =>
      'wss://ir-relay-tad-dar-tiegħek, jew ws:// fuq il-LAN tiegħek';

  @override
  String get homeRelayInvalidUrl =>
      'Daħħal URL validu ta\' relay wss:// (ws:// jitħalla biss għal relay tad-dar fuq in-network tiegħek stess).';

  @override
  String get saveButton => 'Issejvja';

  @override
  String get onboardingSaveError =>
      'Ma setgħetx tiġi ssejvjata l-konfigurazzjoni fuq dan l-apparat.';

  @override
  String get backButton => 'Lura';

  @override
  String get getStartedButton => 'Ibda';

  @override
  String get useOfflineButton => 'Uża offline';

  @override
  String get nextButton => 'Li Jmiss';

  @override
  String welcomeTitle(String appName) {
    return 'Merħba għal $appName';
  }

  @override
  String get welcomeSubtitle =>
      'Maniġer ta\' kompiti privat u ffokat fl-ekosistema ta\' Echoes.';

  @override
  String get featureLocalTitle => 'Tiegħek, fuq l-apparat tiegħek';

  @override
  String get featureLocalBody =>
      'Il-kompiti jinħażnu lokalment l-ewwel f\'database kriptata. L-app taħdem kompletament offline — l-ebda kont mhu meħtieġ.';

  @override
  String get featureSyncTitle => 'Sinkronizzazzjoni permezz ta\' Nostr';

  @override
  String get featureSyncBody =>
      'Idħol b\'ċavetta Nostr u l-kompiti tiegħek jissinkronizzaw fuq diversi apparati permezz ta\' relays li tagħżel int — mingħajr server ta\' kumpanija fin-nofs.';

  @override
  String get featureEncryptedTitle => 'Kriptat minn tarf sa tarf';

  @override
  String get featureEncryptedBody =>
      'Kull kompitu jiġi kriptat (NIP-44) qabel ma joħroġ mill-apparat. Ir-relays jaraw biss test ċifrat.';

  @override
  String get featureAmberTitle => 'Appoġġ għal Amber';

  @override
  String get featureAmberBody =>
      'Fuq Android tista\' żżomm iċ-ċavetta tiegħek fl-Amber: dħul wieħed għas-suite kollha, u l-ebda app qatt ma tmiss iċ-ċavetta nnifisha.';

  @override
  String get loginPageTitle =>
      'Idħol biex tissinkronizza l-kompiti kriptati tiegħek';

  @override
  String get loginPageBody =>
      'Uża identità Nostr għal sinkronizzazzjoni mhux obbligatorja bejn diversi apparati, jew kompli mingħajr kont u żomm kollox lokali.';

  @override
  String get relaySetupTitle => 'Agħżel ir-relays tiegħek';

  @override
  String get relaySetupBody =>
      'Ir-relays jaħżnu kompiti kriptati għas-sinkronizzazzjoni ma\' Kairos fuq l-apparati l-oħra tiegħek. Żid wieħed jew aktar, jew ħalliha vojta u kkonfigura s-sinkronizzazzjoni aktar tard.';

  @override
  String get relaySettingsLoadError =>
      'Ma setgħux jitgħabbew is-settings tar-relay.';

  @override
  String get taskGoneMessage => 'Dan il-kompitu m\'għadux jeżisti.';

  @override
  String get taskDetailsTitle => 'Kompitu';

  @override
  String get editTooltip => 'Editja';

  @override
  String get deleteTooltip => 'Ħassar';

  @override
  String get dueDateLabel => 'Data ta\' skadenza';

  @override
  String get noneLabel => 'Xejn';

  @override
  String get tagsLabel => 'Tikketti';

  @override
  String get priorityLabel => 'Prijorità';

  @override
  String priorityValue(int priority) {
    return '$priority / 5';
  }

  @override
  String get colorLabel => 'Kulur';

  @override
  String get syncStatusLabel => 'Sinkronizzazzjoni';

  @override
  String get syncedStatus => 'Ippubblikat fuq ir-relays';

  @override
  String get notSyncedStatus => 'Lokali biss (sinkronizzazzjoni pendenti)';

  @override
  String get linkedEventLabel => 'Avveniment tal-kalendarju marbut';

  @override
  String createdUpdatedInfo(String created, String updated) {
    return 'Maħluq $created\nAġġornat $updated';
  }

  @override
  String get deleteTaskConfirmTitle => 'Tħassar dan il-kompitu?';

  @override
  String get deleteTaskConfirmBody =>
      'Il-kompitu jitneħħa lokalment u talba għat-tħassir tintbagħat lir-relays tiegħek.';

  @override
  String get deleteButton => 'Ħassar';

  @override
  String get deleteTaskError => 'Ma setax jitħassar il-kompitu lokalment.';

  @override
  String get saveTaskError => 'Ma setax jiġi ssejvjat il-kompitu lokalment.';

  @override
  String get editTaskTitle => 'Editja l-kompitu';

  @override
  String get newTaskTitle => 'Kompitu ġdid';

  @override
  String get titleFieldLabel => 'Titlu';

  @override
  String get titleRequiredError => 'Titlu huwa meħtieġ.';

  @override
  String get titleTooLongError => 'It-titlu huwa twil wisq.';

  @override
  String get descriptionFieldLabel => 'Deskrizzjoni (mhux obbligatorja)';

  @override
  String get noDueDateLabel => 'L-ebda data ta\' skadenza';

  @override
  String get optionalDeadlineHint => 'Skadenza mhux obbligatorja.';

  @override
  String get clearDueDateTooltip => 'Neħħi d-data ta\' skadenza';

  @override
  String get tagsFieldLabel =>
      'Tikketti (separati bil-virgola, mhux obbligatorju)';

  @override
  String get tagsFieldHint => 'xogħol, personali';

  @override
  String get tooManyTagsError => 'Uża mhux aktar minn 32 tikketta.';

  @override
  String get tagTooLongError =>
      'Kull tikketta trid tkun mhux aktar minn 64 karattru.';

  @override
  String get priorityScaleHint => '1 = baxxa, 5 = għolja';

  @override
  String get syncNowTooltip => 'Sinkronizza issa';

  @override
  String get settingsTooltip => 'Issettjar';

  @override
  String get newTaskTooltip => 'Kompitu ġdid';

  @override
  String get loadTasksError => 'Ma setgħux jitgħabbew il-kompiti lokali.';

  @override
  String get emptyTasksTitle => 'Għad m\'hemm l-ebda kompitu';

  @override
  String get emptyTasksBody => 'Agħfas + biex iżżid l-ewwel kompitu tiegħek.';

  @override
  String completedCount(int count) {
    return 'Lest ($count)';
  }

  @override
  String get invalidKeyError =>
      'Dik iċ-ċavetta privata mhix valida. Iċċekkjaha u erġa\' pprova.';

  @override
  String get signInError =>
      'Ma setax isir id-dħul. Jekk jogħġbok erġa\' pprova.';

  @override
  String get signInAmberButton => 'Idħol bl-Amber';

  @override
  String get createAccountButton => 'Oħloq kont ġdid';

  @override
  String get generatedAccountHint =>
      'Kont iġġenerat jista\' jiġi rkuprat biss biċ-ċavetta privata tiegħu. Ħu kopja tal-appoġġ tiegħu mill-Issettjar wara l-konfigurazzjoni.';

  @override
  String get importKeyButton => 'Importa ċavetta eżistenti';

  @override
  String get importKeyFieldLabel => 'nsec jew ċavetta privata eżadeċimali';

  @override
  String get importButton => 'Importa';

  @override
  String get storageFailureMessage =>
      'Kairos ma setax jiftaħ id-database lokali kriptata tiegħu. Erġa\' ibda l-app. Tħassarx id-dejta tal-app; jekk il-problema tippersisti, irrapportaha b\'mod privat.';
}
