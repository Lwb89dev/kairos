// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Estonian (`et`).
class AppLocalizationsEt extends AppLocalizations {
  AppLocalizationsEt([String locale = 'et']) : super(locale);

  @override
  String get settingsTitle => 'Seaded';

  @override
  String get sectionAccount => 'Konto';

  @override
  String get addAccountTitle => 'Lisa Nostr konto';

  @override
  String get addAccountSubtitle => 'Praegu võrguühenduseta, ainult kohalik.';

  @override
  String get backupKeyTitle => 'Varunda privaatvõti';

  @override
  String get backupKeySubtitle => 'Vajalik selle Nostr konto taastamiseks.';

  @override
  String get logOut => 'Logi välja';

  @override
  String get sectionSync => 'Sünkroonimine';

  @override
  String get syncInfoTitle => 'Valikuline krüpteeritud sünkroonimine';

  @override
  String get syncInfoBody =>
      'Ülesanded sünkroonitakse ainult siis, kui on seadistatud Nostr konto ja vähemalt üks relee. Ülesannete sisu krüpteeritakse NIP-44 protokolliga enne seadmest lahkumist.';

  @override
  String get sectionRelays => 'Releed';

  @override
  String get sectionAppearance => 'Välimus';

  @override
  String get themeLabel => 'Teema';

  @override
  String get sectionLanguage => 'Keel';

  @override
  String get langSystem => 'Süsteemne';

  @override
  String get sectionSupport => 'Toetus';

  @override
  String get supportKairosTitle => 'Toeta Kairost';

  @override
  String lightningAddressCopied(String address) {
    return 'Lightning rahakotti ei leitud — aadress kopeeriti: $address';
  }

  @override
  String get logoutConfirmTitle => 'Kas logida välja?';

  @override
  String get logoutConfirmBody =>
      'Teie ülesanded jäävad sellesse seadmesse. Ilma võtmeta ei saa neid enam sünkroonida — veenduge enne väljalogimist, et teil on oma nsec varukoopia.';

  @override
  String get cancelButton => 'Tühista';

  @override
  String get nsecDialogTitle => 'Teie privaatvõti (nsec)';

  @override
  String get nsecDialogWarning =>
      'Igaüks, kellel on see võti, kontrollib teie kontot. Hoidke seda paroolihalduris ja ärge kunagi jagage seda.';

  @override
  String get copyButton => 'Kopeeri';

  @override
  String get doneButton => 'Valmis';

  @override
  String get signedInWithAmber => 'Sisse logitud Amberiga';

  @override
  String signedInWithKey(String npub) {
    return 'Sisse logitud · $npub';
  }

  @override
  String get relayInvalidUrlWss =>
      'Sisestage kehtiv krüpteeritud wss:// relee aadress.';

  @override
  String get relayUrlHint => 'wss://teie-relee…';

  @override
  String get addRelayTooltip => 'Lisa relee';

  @override
  String get noRelaysConfigured => 'Ühtegi releed pole seadistatud.';

  @override
  String get removeRelayTooltip => 'Eemalda relee';

  @override
  String get homeRelayTitle => 'Isiklik kodurelee';

  @override
  String get homeRelayConfiguredSubtitle =>
      'Täiendav varunduskoht teie krüpteeritud ülesannetele';

  @override
  String get homeRelaySubtitle =>
      'Valikuline: lisage oma relee täiendava varunduskohana. Erinevalt teistest releedest võib see kasutada ka krüpteerimata ws:// aadressi, kui see asub teie kohalikus võrgus.';

  @override
  String get removeHomeRelayTooltip => 'Eemalda kodurelee';

  @override
  String get homeRelayUrlHint =>
      'wss://teie-kodurelee või ws:// kohalikus võrgus';

  @override
  String get homeRelayInvalidUrl =>
      'Sisestage kehtiv wss:// relee aadress (ws:// on lubatud ainult kodureleele teie enda võrgus).';

  @override
  String get saveButton => 'Salvesta';

  @override
  String get onboardingSaveError =>
      'Seadistust ei õnnestunud selles seadmes salvestada.';

  @override
  String get backButton => 'Tagasi';

  @override
  String get getStartedButton => 'Alusta';

  @override
  String get useOfflineButton => 'Kasuta võrguühenduseta';

  @override
  String get nextButton => 'Edasi';

  @override
  String welcomeTitle(String appName) {
    return 'Tere tulemast, $appName';
  }

  @override
  String get welcomeSubtitle =>
      'Privaatne, fokusseeritud ülesannete haldur Echoes ökosüsteemis.';

  @override
  String get featureLocalTitle => 'Teie oma, teie seadmes';

  @override
  String get featureLocalBody =>
      'Ülesanded salvestatakse esmalt kohapeal krüpteeritud andmebaasi. Rakendus töötab täielikult võrguühenduseta — kontot pole vaja.';

  @override
  String get featureSyncTitle => 'Sünkroonimine Nostri kaudu';

  @override
  String get featureSyncBody =>
      'Logige sisse Nostr võtmega ja teie ülesanded sünkroonitakse seadmete vahel teie valitud releede kaudu — ilma ettevõtte serverita vahepeal.';

  @override
  String get featureEncryptedTitle => 'Otsast lõpuni krüpteeritud';

  @override
  String get featureEncryptedBody =>
      'Iga ülesanne krüpteeritakse (NIP-44) enne seadmest lahkumist. Releed näevad ainult krüpteeritud teksti.';

  @override
  String get featureAmberTitle => 'Amberi tugi';

  @override
  String get featureAmberBody =>
      'Androidis saate hoida oma võtit Amberis: üks sisselogimine kogu rakenduste sarjale, ilma et ükski rakendus kunagi võtit ennast puudutaks.';

  @override
  String get loginPageTitle =>
      'Logige sisse, et sünkroonida oma krüpteeritud ülesandeid';

  @override
  String get loginPageBody =>
      'Kasutage Nostr identiteeti valikuliseks mitme seadme sünkroonimiseks või jätkake ilma kontota ja hoidke kõike kohapeal.';

  @override
  String get relaySetupTitle => 'Valige oma releed';

  @override
  String get relaySetupBody =>
      'Releed salvestavad krüpteeritud ülesandeid sünkroonimiseks Kairosega teie teistes seadmetes. Lisage üks või mitu, või jätke tühjaks ja seadistage sünkroonimine hiljem.';

  @override
  String get relaySettingsLoadError => 'Relee sätteid ei õnnestunud laadida.';

  @override
  String get taskGoneMessage => 'Seda ülesannet enam ei ole.';

  @override
  String get taskDetailsTitle => 'Ülesanne';

  @override
  String get editTooltip => 'Muuda';

  @override
  String get deleteTooltip => 'Kustuta';

  @override
  String get dueDateLabel => 'Tähtaeg';

  @override
  String get noneLabel => 'Puudub';

  @override
  String get tagsLabel => 'Sildid';

  @override
  String get priorityLabel => 'Prioriteet';

  @override
  String priorityValue(int priority) {
    return '$priority / 5';
  }

  @override
  String get colorLabel => 'Värv';

  @override
  String get syncStatusLabel => 'Sünkroonimine';

  @override
  String get syncedStatus => 'Avaldatud releedes';

  @override
  String get notSyncedStatus => 'Ainult kohalik (sünkroonimine ootel)';

  @override
  String get linkedEventLabel => 'Seotud kalendrisündmus';

  @override
  String createdUpdatedInfo(String created, String updated) {
    return 'Loodud $created\nUuendatud $updated';
  }

  @override
  String get deleteTaskConfirmTitle => 'Kas kustutada see ülesanne?';

  @override
  String get deleteTaskConfirmBody =>
      'Ülesanne eemaldatakse kohapeal ja kustutamistaotlus saadetakse teie releedele.';

  @override
  String get deleteButton => 'Kustuta';

  @override
  String get deleteTaskError => 'Ülesannet ei õnnestunud kohapeal kustutada.';

  @override
  String get saveTaskError => 'Ülesannet ei õnnestunud kohapeal salvestada.';

  @override
  String get editTaskTitle => 'Muuda ülesannet';

  @override
  String get newTaskTitle => 'Uus ülesanne';

  @override
  String get titleFieldLabel => 'Pealkiri';

  @override
  String get titleRequiredError => 'Pealkiri on kohustuslik.';

  @override
  String get titleTooLongError => 'Pealkiri on liiga pikk.';

  @override
  String get descriptionFieldLabel => 'Kirjeldus (valikuline)';

  @override
  String get noDueDateLabel => 'Tähtaeg puudub';

  @override
  String get optionalDeadlineHint => 'Valikuline tähtaeg.';

  @override
  String get clearDueDateTooltip => 'Tühjenda tähtaeg';

  @override
  String get tagsFieldLabel => 'Sildid (komadega eraldatud, valikuline)';

  @override
  String get tagsFieldHint => 'töö, isiklik';

  @override
  String get tooManyTagsError => 'Kasutage kõige rohkem 32 silti.';

  @override
  String get tagTooLongError => 'Iga silt tohib olla kuni 64 tähemärki pikk.';

  @override
  String get priorityScaleHint => '1 = madal, 5 = kõrge';

  @override
  String get syncNowTooltip => 'Sünkrooni kohe';

  @override
  String get settingsTooltip => 'Seaded';

  @override
  String get newTaskTooltip => 'Uus ülesanne';

  @override
  String get loadTasksError => 'Kohalikke ülesandeid ei õnnestunud laadida.';

  @override
  String get emptyTasksTitle => 'Ülesandeid pole veel';

  @override
  String get emptyTasksBody => 'Puudutage +, et lisada oma esimene ülesanne.';

  @override
  String completedCount(int count) {
    return 'Lõpetatud ($count)';
  }

  @override
  String get invalidKeyError =>
      'See privaatvõti ei ole kehtiv. Kontrollige seda ja proovige uuesti.';

  @override
  String get signInError => 'Sisselogimine ebaõnnestus. Palun proovige uuesti.';

  @override
  String get signInAmberButton => 'Logi sisse Amberiga';

  @override
  String get createAccountButton => 'Loo uus konto';

  @override
  String get generatedAccountHint =>
      'Genereeritud kontot saab taastada ainult selle privaatvõtmega. Varundage see pärast seadistamist seadetes.';

  @override
  String get importKeyButton => 'Impordi olemasolev võti';

  @override
  String get importKeyFieldLabel =>
      'nsec või kuueteistkümnendsüsteemis privaatvõti';

  @override
  String get importButton => 'Impordi';

  @override
  String get storageFailureMessage =>
      'Kairos ei suutnud avada oma krüpteeritud kohalikku andmebaasi. Käivitage rakendus uuesti. Ärge kustutage rakenduse andmeid; kui probleem püsib, teatage sellest privaatselt.';
}
