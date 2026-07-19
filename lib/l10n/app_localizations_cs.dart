// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get settingsTitle => 'Nastavení';

  @override
  String get sectionAccount => 'Účet';

  @override
  String get addAccountTitle => 'Přidat účet Nostr';

  @override
  String get addAccountSubtitle => 'Momentálně offline, pouze lokálně.';

  @override
  String get backupKeyTitle => 'Zálohovat soukromý klíč';

  @override
  String get backupKeySubtitle => 'Vyžadováno pro obnovení tohoto účtu Nostr.';

  @override
  String get logOut => 'Odhlásit se';

  @override
  String get sectionSync => 'Synchronizace';

  @override
  String get syncInfoTitle => 'Volitelná šifrovaná synchronizace';

  @override
  String get syncInfoBody =>
      'Úkoly se synchronizují pouze tehdy, je-li nastaven účet Nostr a alespoň jeden přenosový uzel. Obsah úkolů je před opuštěním zařízení šifrován pomocí NIP-44.';

  @override
  String get sectionRelays => 'Přenosové uzly';

  @override
  String get sectionAppearance => 'Vzhled';

  @override
  String get themeLabel => 'Motiv';

  @override
  String get sectionLanguage => 'Jazyk';

  @override
  String get langSystem => 'Systémový';

  @override
  String get sectionSupport => 'Podpora';

  @override
  String get supportKairosTitle => 'Podpořit Kairos';

  @override
  String lightningAddressCopied(String address) {
    return 'Nebyla nalezena žádná Lightning peněženka — adresa zkopírována: $address';
  }

  @override
  String get logoutConfirmTitle => 'Odhlásit se?';

  @override
  String get logoutConfirmBody =>
      'Vaše úkoly zůstanou na tomto zařízení. Bez klíče je již nebude možné synchronizovat — než se odhlásíte, ujistěte se, že máte zálohu svého nsec.';

  @override
  String get cancelButton => 'Zrušit';

  @override
  String get nsecDialogTitle => 'Váš soukromý klíč (nsec)';

  @override
  String get nsecDialogWarning =>
      'Kdokoli s tímto klíčem ovládá váš účet. Uchovávejte ho ve správci hesel a nikdy ho nikomu nesdílejte.';

  @override
  String get copyButton => 'Kopírovat';

  @override
  String get doneButton => 'Hotovo';

  @override
  String get signedInWithAmber => 'Přihlášeno přes Amber';

  @override
  String signedInWithKey(String npub) {
    return 'Přihlášeno · $npub';
  }

  @override
  String get relayInvalidUrlWss =>
      'Zadejte platnou šifrovanou adresu přenosového uzlu wss://.';

  @override
  String get relayUrlHint => 'wss://váš-uzel…';

  @override
  String get addRelayTooltip => 'Přidat přenosový uzel';

  @override
  String get noRelaysConfigured => 'Nejsou nastaveny žádné přenosové uzly.';

  @override
  String get removeRelayTooltip => 'Odebrat přenosový uzel';

  @override
  String get homeRelayTitle => 'Osobní domácí přenosový uzel';

  @override
  String get homeRelayConfiguredSubtitle =>
      'Další záložní cíl pro vaše šifrované úkoly';

  @override
  String get homeRelaySubtitle =>
      'Volitelné: přidejte vlastní přenosový uzel jako další záložní cíl. Na rozdíl od ostatních uzlů může tento používat i nešifrovanou adresu ws://, pokud se nachází ve vaší lokální síti.';

  @override
  String get removeHomeRelayTooltip => 'Odebrat domácí přenosový uzel';

  @override
  String get homeRelayUrlHint =>
      'wss://váš-domácí-uzel nebo ws:// v místní síti';

  @override
  String get homeRelayInvalidUrl =>
      'Zadejte platnou adresu přenosového uzlu wss:// (ws:// je povoleno pouze pro domácí uzel ve vlastní síti).';

  @override
  String get saveButton => 'Uložit';

  @override
  String get onboardingSaveError =>
      'Nastavení se na tomto zařízení nepodařilo uložit.';

  @override
  String get backButton => 'Zpět';

  @override
  String get getStartedButton => 'Začít';

  @override
  String get useOfflineButton => 'Používat offline';

  @override
  String get nextButton => 'Další';

  @override
  String welcomeTitle(String appName) {
    return 'Vítejte v $appName';
  }

  @override
  String get welcomeSubtitle =>
      'Soukromý, na úkoly zaměřený správce úkolů v ekosystému Echoes.';

  @override
  String get featureLocalTitle => 'Vaše, na vašem zařízení';

  @override
  String get featureLocalBody =>
      'Úkoly se nejprve ukládají lokálně do šifrované databáze. Aplikace funguje zcela offline — účet není vyžadován.';

  @override
  String get featureSyncTitle => 'Synchronizace přes Nostr';

  @override
  String get featureSyncBody =>
      'Přihlaste se pomocí klíče Nostr a vaše úkoly se budou synchronizovat mezi zařízeními přes vámi zvolené přenosové uzly — bez firemního serveru uprostřed.';

  @override
  String get featureEncryptedTitle => 'Šifrování typu end-to-end';

  @override
  String get featureEncryptedBody =>
      'Každý úkol je zašifrován (NIP-44), než opustí zařízení. Přenosové uzly vidí pouze zašifrovaný text.';

  @override
  String get featureAmberTitle => 'Podpora Amber';

  @override
  String get featureAmberBody =>
      'V Androidu můžete svůj klíč uchovávat v Amber: jedno přihlášení pro celou sadu aplikací a žádná z nich se samotného klíče nikdy nedotkne.';

  @override
  String get loginPageTitle =>
      'Přihlaste se pro synchronizaci svých šifrovaných úkolů';

  @override
  String get loginPageBody =>
      'Použijte identitu Nostr pro volitelnou synchronizaci mezi zařízeními, nebo pokračujte bez účtu a ponechte vše lokálně.';

  @override
  String get relaySetupTitle => 'Vyberte své přenosové uzly';

  @override
  String get relaySetupBody =>
      'Přenosové uzly ukládají šifrované úkoly pro synchronizaci s Kairos na vašich dalších zařízeních. Přidejte jeden nebo více, nebo ponechte prázdné a nastavte synchronizaci později.';

  @override
  String get relaySettingsLoadError =>
      'Nastavení přenosových uzlů se nepodařilo načíst.';

  @override
  String get taskGoneMessage => 'Tento úkol už neexistuje.';

  @override
  String get taskDetailsTitle => 'Úkol';

  @override
  String get editTooltip => 'Upravit';

  @override
  String get deleteTooltip => 'Smazat';

  @override
  String get dueDateLabel => 'Termín splnění';

  @override
  String get noneLabel => 'Žádný';

  @override
  String get tagsLabel => 'Štítky';

  @override
  String get priorityLabel => 'Priorita';

  @override
  String priorityValue(int priority) {
    return '$priority / 5';
  }

  @override
  String get colorLabel => 'Barva';

  @override
  String get syncStatusLabel => 'Synchronizace';

  @override
  String get syncedStatus => 'Zveřejněno na přenosových uzlech';

  @override
  String get notSyncedStatus => 'Pouze lokálně (čeká na synchronizaci)';

  @override
  String get linkedEventLabel => 'Propojená událost kalendáře';

  @override
  String createdUpdatedInfo(String created, String updated) {
    return 'Vytvořeno $created\nAktualizováno $updated';
  }

  @override
  String get deleteTaskConfirmTitle => 'Smazat tento úkol?';

  @override
  String get deleteTaskConfirmBody =>
      'Úkol se odstraní lokálně a na vaše přenosové uzly se odešle žádost o smazání.';

  @override
  String get deleteButton => 'Smazat';

  @override
  String get deleteTaskError => 'Úkol se nepodařilo lokálně smazat.';

  @override
  String get saveTaskError => 'Úkol se nepodařilo lokálně uložit.';

  @override
  String get editTaskTitle => 'Upravit úkol';

  @override
  String get newTaskTitle => 'Nový úkol';

  @override
  String get titleFieldLabel => 'Název';

  @override
  String get titleRequiredError => 'Název je povinný.';

  @override
  String get titleTooLongError => 'Název je příliš dlouhý.';

  @override
  String get descriptionFieldLabel => 'Popis (volitelné)';

  @override
  String get noDueDateLabel => 'Bez termínu';

  @override
  String get optionalDeadlineHint => 'Volitelný termín.';

  @override
  String get clearDueDateTooltip => 'Vymazat termín splnění';

  @override
  String get tagsFieldLabel => 'Štítky (oddělené čárkou, volitelné)';

  @override
  String get tagsFieldHint => 'práce, osobní';

  @override
  String get tooManyTagsError => 'Použijte nejvýše 32 štítků.';

  @override
  String get tagTooLongError => 'Každý štítek smí mít nejvýše 64 znaků.';

  @override
  String get priorityScaleHint => '1 = nízká, 5 = vysoká';

  @override
  String get syncNowTooltip => 'Synchronizovat nyní';

  @override
  String get settingsTooltip => 'Nastavení';

  @override
  String get newTaskTooltip => 'Nový úkol';

  @override
  String get loadTasksError => 'Lokální úkoly se nepodařilo načíst.';

  @override
  String get emptyTasksTitle => 'Zatím žádné úkoly';

  @override
  String get emptyTasksBody => 'Klepnutím na + přidáte svůj první úkol.';

  @override
  String completedCount(int count) {
    return 'Dokončeno ($count)';
  }

  @override
  String get invalidKeyError =>
      'Tento soukromý klíč není platný. Zkontrolujte ho a zkuste to znovu.';

  @override
  String get signInError => 'Přihlášení se nezdařilo. Zkuste to prosím znovu.';

  @override
  String get signInAmberButton => 'Přihlásit se přes Amber';

  @override
  String get createAccountButton => 'Vytvořit nový účet';

  @override
  String get generatedAccountHint =>
      'Vygenerovaný účet lze obnovit pouze pomocí jeho soukromého klíče. Po dokončení nastavení si ho zálohujte v Nastavení.';

  @override
  String get importKeyButton => 'Importovat existující klíč';

  @override
  String get importKeyFieldLabel => 'nsec nebo soukromý klíč v hex';

  @override
  String get importButton => 'Importovat';

  @override
  String get storageFailureMessage =>
      'Aplikaci Kairos se nepodařilo otevřít šifrovanou lokální databázi. Restartujte aplikaci. Nemažte data aplikace; pokud problém přetrvává, nahlaste ho soukromě.';
}
