// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hungarian (`hu`).
class AppLocalizationsHu extends AppLocalizations {
  AppLocalizationsHu([String locale = 'hu']) : super(locale);

  @override
  String get settingsTitle => 'Beállítások';

  @override
  String get sectionAccount => 'Fiók';

  @override
  String get addAccountTitle => 'Nostr fiók hozzáadása';

  @override
  String get addAccountSubtitle => 'Jelenleg offline, csak helyi.';

  @override
  String get backupKeyTitle => 'Privát kulcs biztonsági mentése';

  @override
  String get backupKeySubtitle =>
      'Szükséges ennek a Nostr fióknak a helyreállításához.';

  @override
  String get logOut => 'Kijelentkezés';

  @override
  String get sectionSync => 'Szinkronizálás';

  @override
  String get syncInfoTitle => 'Opcionális titkosított szinkronizálás';

  @override
  String get syncInfoBody =>
      'A feladatok csak akkor szinkronizálódnak, ha be van állítva egy Nostr fiók és legalább egy relé. A feladatok tartalma NIP-44 titkosítást kap, mielőtt elhagyná ezt az eszközt.';

  @override
  String get sectionRelays => 'Relék';

  @override
  String get sectionAppearance => 'Megjelenés';

  @override
  String get themeLabel => 'Téma';

  @override
  String get sectionLanguage => 'Nyelv';

  @override
  String get langSystem => 'Rendszer';

  @override
  String get sectionSupport => 'Támogatás';

  @override
  String get supportKairosTitle => 'Kairos támogatása';

  @override
  String lightningAddressCopied(String address) {
    return 'Nem található Lightning tárca — cím másolva: $address';
  }

  @override
  String get logoutConfirmTitle => 'Kijelentkezel?';

  @override
  String get logoutConfirmBody =>
      'A feladataid ezen az eszközön maradnak. A kulcs nélkül többé nem szinkronizálhatók — a kijelentkezés előtt győződj meg róla, hogy van biztonsági mentésed az nsec kulcsodról.';

  @override
  String get cancelButton => 'Mégse';

  @override
  String get nsecDialogTitle => 'A privát kulcsod (nsec)';

  @override
  String get nsecDialogWarning =>
      'Aki ismeri ezt a kulcsot, az irányítja a fiókodat. Tárold jelszókezelőben, és soha ne oszd meg senkivel.';

  @override
  String get copyButton => 'Másolás';

  @override
  String get doneButton => 'Kész';

  @override
  String get signedInWithAmber => 'Bejelentkezve Amberrel';

  @override
  String signedInWithKey(String npub) {
    return 'Bejelentkezve · $npub';
  }

  @override
  String get relayInvalidUrlWss =>
      'Adj meg egy érvényes, titkosított wss:// relécímet.';

  @override
  String get relayUrlHint => 'wss://saját-reléd…';

  @override
  String get addRelayTooltip => 'Relé hozzáadása';

  @override
  String get noRelaysConfigured => 'Nincs beállítva relé.';

  @override
  String get removeRelayTooltip => 'Relé eltávolítása';

  @override
  String get homeRelayTitle => 'Személyes otthoni relé';

  @override
  String get homeRelayConfiguredSubtitle =>
      'További biztonsági mentési cél a titkosított feladataidhoz';

  @override
  String get homeRelaySubtitle =>
      'Opcionális: adj hozzá saját relét további biztonsági mentési célként. A többi relétől eltérően ez titkosítatlan ws:// címet is használhat, ha a helyi hálózatodon található.';

  @override
  String get removeHomeRelayTooltip => 'Otthoni relé eltávolítása';

  @override
  String get homeRelayUrlHint =>
      'wss://saját-otthoni-reléd, vagy ws:// a helyi hálózaton';

  @override
  String get homeRelayInvalidUrl =>
      'Adj meg egy érvényes wss:// relécímet (a ws:// csak a saját hálózatodon lévő otthoni relé esetén megengedett).';

  @override
  String get saveButton => 'Mentés';

  @override
  String get onboardingSaveError =>
      'Nem sikerült elmenteni a beállítást ezen az eszközön.';

  @override
  String get backButton => 'Vissza';

  @override
  String get getStartedButton => 'Kezdés';

  @override
  String get useOfflineButton => 'Használat offline módban';

  @override
  String get nextButton => 'Tovább';

  @override
  String welcomeTitle(String appName) {
    return 'Üdvözlünk a(z) $appName alkalmazásban';
  }

  @override
  String get welcomeSubtitle =>
      'Privát, összpontosított feladatkezelő az Echoes ökoszisztémában.';

  @override
  String get featureLocalTitle => 'A tiéd, a saját eszközödön';

  @override
  String get featureLocalBody =>
      'A feladatok először helyben, titkosított adatbázisban tárolódnak. Az alkalmazás teljesen offline is működik — fiók nem szükséges.';

  @override
  String get featureSyncTitle => 'Szinkronizálás Nostron keresztül';

  @override
  String get featureSyncBody =>
      'Jelentkezz be egy Nostr kulccsal, és a feladataid az általad választott réléken keresztül szinkronizálódnak az eszközeid között — vállalati szerver nélkül.';

  @override
  String get featureEncryptedTitle => 'Végpontok közötti titkosítás';

  @override
  String get featureEncryptedBody =>
      'Minden feladat titkosítva van (NIP-44), mielőtt elhagyná az eszközt. A relék csak titkosított szöveget látnak.';

  @override
  String get featureAmberTitle => 'Amber-támogatás';

  @override
  String get featureAmberBody =>
      'Androidon a kulcsodat az Amberben is tárolhatod: egyetlen bejelentkezés az egész alkalmazáscsomaghoz, és egyik alkalmazás sem fér hozzá magához a kulcshoz.';

  @override
  String get loginPageTitle =>
      'Jelentkezz be a titkosított feladataid szinkronizálásához';

  @override
  String get loginPageBody =>
      'Használj Nostr-azonosítót az opcionális, több eszköz közötti szinkronizáláshoz, vagy folytasd fiók nélkül, és tarts mindent helyben.';

  @override
  String get relaySetupTitle => 'Válaszd ki a réléidet';

  @override
  String get relaySetupBody =>
      'A relék titkosított feladatokat tárolnak, hogy szinkronizálni tudd a Kairost a többi eszközöddel. Adj hozzá egyet vagy többet, vagy hagyd üresen, és állítsd be a szinkronizálást később.';

  @override
  String get relaySettingsLoadError =>
      'Nem sikerült betölteni a relébeállításokat.';

  @override
  String get taskGoneMessage => 'Ez a feladat már nem létezik.';

  @override
  String get taskDetailsTitle => 'Feladat';

  @override
  String get editTooltip => 'Szerkesztés';

  @override
  String get deleteTooltip => 'Törlés';

  @override
  String get dueDateLabel => 'Határidő';

  @override
  String get noneLabel => 'Nincs';

  @override
  String get tagsLabel => 'Címkék';

  @override
  String get priorityLabel => 'Prioritás';

  @override
  String priorityValue(int priority) {
    return '$priority / 5';
  }

  @override
  String get colorLabel => 'Szín';

  @override
  String get syncStatusLabel => 'Szinkronizálás';

  @override
  String get syncedStatus => 'Közzétéve a réléken';

  @override
  String get notSyncedStatus => 'Csak helyi (szinkronizálásra vár)';

  @override
  String get linkedEventLabel => 'Kapcsolt naptáresemény';

  @override
  String createdUpdatedInfo(String created, String updated) {
    return 'Létrehozva: $created\nFrissítve: $updated';
  }

  @override
  String get deleteTaskConfirmTitle => 'Törlöd ezt a feladatot?';

  @override
  String get deleteTaskConfirmBody =>
      'A feladat helyben törlődik, és törlési kérelem kerül elküldésre a réléidnek.';

  @override
  String get deleteButton => 'Törlés';

  @override
  String get deleteTaskError => 'Nem sikerült helyben törölni a feladatot.';

  @override
  String get saveTaskError => 'Nem sikerült helyben elmenteni a feladatot.';

  @override
  String get editTaskTitle => 'Feladat szerkesztése';

  @override
  String get newTaskTitle => 'Új feladat';

  @override
  String get syncToNostrTitle => 'Szinkronizálás a Nostrra';

  @override
  String get syncToNostrSubtitle =>
      'Titkosítva közzéteszi a feladatot a relékre. Ha ki van kapcsolva, csak ezen az eszközön marad.';

  @override
  String get syncTaskButton => 'Feladat szinkronizálása';

  @override
  String get localOnlyStatus => 'Csak helyi (szinkronizálás kikapcsolva)';

  @override
  String get titleFieldLabel => 'Cím';

  @override
  String get titleRequiredError => 'A cím megadása kötelező.';

  @override
  String get titleTooLongError => 'A cím túl hosszú.';

  @override
  String get descriptionFieldLabel => 'Leírás (opcionális)';

  @override
  String get noDueDateLabel => 'Nincs határidő';

  @override
  String get optionalDeadlineHint => 'Opcionális határidő.';

  @override
  String get clearDueDateTooltip => 'Határidő törlése';

  @override
  String get tagsFieldLabel => 'Címkék (vesszővel elválasztva, opcionális)';

  @override
  String get tagsFieldHint => 'munka, magán';

  @override
  String get tooManyTagsError => 'Legfeljebb 32 címkét használj.';

  @override
  String get tagTooLongError => 'Egy címke legfeljebb 64 karakter lehet.';

  @override
  String get priorityScaleHint => '1 = alacsony, 5 = magas';

  @override
  String get syncNowTooltip => 'Szinkronizálás most';

  @override
  String get settingsTooltip => 'Beállítások';

  @override
  String get newTaskTooltip => 'Új feladat';

  @override
  String get loadTasksError => 'Nem sikerült betölteni a helyi feladatokat.';

  @override
  String get emptyTasksTitle => 'Még nincsenek feladatok';

  @override
  String get emptyTasksBody =>
      'Koppints a + gombra az első feladat hozzáadásához.';

  @override
  String completedCount(int count) {
    return 'Befejezve ($count)';
  }

  @override
  String get invalidKeyError =>
      'Ez a privát kulcs érvénytelen. Ellenőrizd, és próbáld újra.';

  @override
  String get signInError => 'Nem sikerült bejelentkezni. Kérjük, próbáld újra.';

  @override
  String get signInAmberButton => 'Bejelentkezés Amberrel';

  @override
  String get createAccountButton => 'Új fiók létrehozása';

  @override
  String get generatedAccountHint =>
      'A generált fiókot csak a privát kulcsával lehet visszaállítani. Készíts róla biztonsági mentést a Beállításokban a beállítás után.';

  @override
  String get importKeyButton => 'Meglévő kulcs importálása';

  @override
  String get importKeyFieldLabel => 'nsec vagy hexadecimális privát kulcs';

  @override
  String get importButton => 'Importálás';

  @override
  String get storageFailureMessage =>
      'A Kairos nem tudta megnyitni a titkosított helyi adatbázisát. Indítsd újra az alkalmazást. Ne töröld az alkalmazás adatait; ha a probléma továbbra is fennáll, jelentsd privát módon.';

  @override
  String get remindersLabel => 'Emlékeztetők';

  @override
  String get addReminderButton => 'Emlékeztető hozzáadása';

  @override
  String get remindersNeedDueDate =>
      'Állíts be határidőt az emlékeztetők hozzáadásához';

  @override
  String get removeReminderTooltip => 'Emlékeztető eltávolítása';

  @override
  String get reminderAtDueTime => 'A határidő időpontjában';

  @override
  String reminderMinutesBefore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count perccel előtte',
      one: '1 perccel előtte',
    );
    return '$_temp0';
  }

  @override
  String reminderHoursBefore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count órával előtte',
      one: '1 órával előtte',
    );
    return '$_temp0';
  }

  @override
  String reminderDaysBefore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nappal előtte',
      one: '1 nappal előtte',
    );
    return '$_temp0';
  }

  @override
  String maxRemindersReached(int count) {
    return 'Egy feladathoz legfeljebb $count emlékeztető tartozhat';
  }

  @override
  String get notificationsTitle => 'Feladat-emlékeztetők';

  @override
  String get notificationsSubtitle => 'Értesíts a feladat határideje előtt';

  @override
  String get sectionReminders => 'Emlékeztetők';

  @override
  String get addToCalendarTitle => 'Hozzáadás az Astraea naptárhoz';

  @override
  String get addToCalendarSubtitle =>
      'Ez a feladat a határidő napján az Astraea naptárában és widgetjében is megjelenik.';

  @override
  String get addToCalendarNeedsSync => 'Fiók, relay és határidő szükséges';
}
