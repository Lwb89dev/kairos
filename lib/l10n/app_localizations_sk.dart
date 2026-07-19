// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Slovak (`sk`).
class AppLocalizationsSk extends AppLocalizations {
  AppLocalizationsSk([String locale = 'sk']) : super(locale);

  @override
  String get settingsTitle => 'Nastavenia';

  @override
  String get sectionAccount => 'Účet';

  @override
  String get addAccountTitle => 'Pridať účet Nostr';

  @override
  String get addAccountSubtitle => 'Momentálne offline, iba lokálne.';

  @override
  String get backupKeyTitle => 'Zálohovať súkromný kľúč';

  @override
  String get backupKeySubtitle => 'Potrebné na obnovenie tohto účtu Nostr.';

  @override
  String get logOut => 'Odhlásiť sa';

  @override
  String get sectionSync => 'Synchronizácia';

  @override
  String get syncInfoTitle => 'Voliteľná šifrovaná synchronizácia';

  @override
  String get syncInfoBody =>
      'Úlohy sa synchronizujú iba vtedy, keď je nastavený účet Nostr a aspoň jeden prenosový uzol. Obsah úloh je pred opustením zariadenia šifrovaný pomocou NIP-44.';

  @override
  String get sectionRelays => 'Prenosové uzly';

  @override
  String get sectionAppearance => 'Vzhľad';

  @override
  String get themeLabel => 'Motív';

  @override
  String get sectionLanguage => 'Jazyk';

  @override
  String get langSystem => 'Systémový';

  @override
  String get sectionSupport => 'Podpora';

  @override
  String get supportKairosTitle => 'Podporiť Kairos';

  @override
  String lightningAddressCopied(String address) {
    return 'Nenašla sa žiadna Lightning peňaženka — adresa skopírovaná: $address';
  }

  @override
  String get logoutConfirmTitle => 'Odhlásiť sa?';

  @override
  String get logoutConfirmBody =>
      'Vaše úlohy zostanú na tomto zariadení. Bez kľúča ich už nebude možné synchronizovať — pred odhlásením sa uistite, že máte zálohu svojho nsec.';

  @override
  String get cancelButton => 'Zrušiť';

  @override
  String get nsecDialogTitle => 'Váš súkromný kľúč (nsec)';

  @override
  String get nsecDialogWarning =>
      'Ktokoľvek s týmto kľúčom ovláda váš účet. Uchovávajte ho v správcovi hesiel a nikdy ho s nikým nezdieľajte.';

  @override
  String get copyButton => 'Kopírovať';

  @override
  String get doneButton => 'Hotovo';

  @override
  String get signedInWithAmber => 'Prihlásené cez Amber';

  @override
  String signedInWithKey(String npub) {
    return 'Prihlásené · $npub';
  }

  @override
  String get relayInvalidUrlWss =>
      'Zadajte platnú šifrovanú adresu prenosového uzla wss://.';

  @override
  String get relayUrlHint => 'wss://váš-uzol…';

  @override
  String get addRelayTooltip => 'Pridať prenosový uzol';

  @override
  String get noRelaysConfigured => 'Nie sú nastavené žiadne prenosové uzly.';

  @override
  String get removeRelayTooltip => 'Odstrániť prenosový uzol';

  @override
  String get homeRelayTitle => 'Osobný domáci prenosový uzol';

  @override
  String get homeRelayConfiguredSubtitle =>
      'Ďalší záložný cieľ pre vaše šifrované úlohy';

  @override
  String get homeRelaySubtitle =>
      'Voliteľné: pridajte vlastný prenosový uzol ako ďalší záložný cieľ. Na rozdiel od ostatných uzlov môže tento používať aj nešifrovanú adresu ws://, ak sa nachádza vo vašej lokálnej sieti.';

  @override
  String get removeHomeRelayTooltip => 'Odstrániť domáci prenosový uzol';

  @override
  String get homeRelayUrlHint =>
      'wss://váš-domáci-uzol alebo ws:// v lokálnej sieti';

  @override
  String get homeRelayInvalidUrl =>
      'Zadajte platnú adresu prenosového uzla wss:// (ws:// je povolené iba pre domáci uzol vo vlastnej sieti).';

  @override
  String get saveButton => 'Uložiť';

  @override
  String get onboardingSaveError =>
      'Nastavenie sa na tomto zariadení nepodarilo uložiť.';

  @override
  String get backButton => 'Späť';

  @override
  String get getStartedButton => 'Začať';

  @override
  String get useOfflineButton => 'Používať offline';

  @override
  String get nextButton => 'Ďalej';

  @override
  String welcomeTitle(String appName) {
    return 'Vitajte v $appName';
  }

  @override
  String get welcomeSubtitle =>
      'Súkromný, na úlohy zameraný správca úloh v ekosystéme Echoes.';

  @override
  String get featureLocalTitle => 'Vaše, na vašom zariadení';

  @override
  String get featureLocalBody =>
      'Úlohy sa najprv ukladajú lokálne do šifrovanej databázy. Aplikácia funguje úplne offline — účet nie je potrebný.';

  @override
  String get featureSyncTitle => 'Synchronizácia cez Nostr';

  @override
  String get featureSyncBody =>
      'Prihláste sa pomocou kľúča Nostr a vaše úlohy sa budú synchronizovať medzi zariadeniami cez vami zvolené prenosové uzly — bez firemného servera uprostred.';

  @override
  String get featureEncryptedTitle => 'End-to-end šifrovanie';

  @override
  String get featureEncryptedBody =>
      'Každá úloha je zašifrovaná (NIP-44) skôr, než opustí zariadenie. Prenosové uzly vidia iba zašifrovaný text.';

  @override
  String get featureAmberTitle => 'Podpora Amber';

  @override
  String get featureAmberBody =>
      'V Androide môžete svoj kľúč uchovávať v Amber: jedno prihlásenie pre celý balík aplikácií a žiadna z nich sa samotného kľúča nikdy nedotkne.';

  @override
  String get loginPageTitle =>
      'Prihláste sa a synchronizujte svoje šifrované úlohy';

  @override
  String get loginPageBody =>
      'Použite identitu Nostr na voliteľnú synchronizáciu medzi zariadeniami, alebo pokračujte bez účtu a ponechajte všetko lokálne.';

  @override
  String get relaySetupTitle => 'Vyberte svoje prenosové uzly';

  @override
  String get relaySetupBody =>
      'Prenosové uzly uchovávajú šifrované úlohy na synchronizáciu s Kairos na vašich ďalších zariadeniach. Pridajte jeden alebo viac, alebo nechajte prázdne a nastavte synchronizáciu neskôr.';

  @override
  String get relaySettingsLoadError =>
      'Nastavenia prenosových uzlov sa nepodarilo načítať.';

  @override
  String get taskGoneMessage => 'Táto úloha už neexistuje.';

  @override
  String get taskDetailsTitle => 'Úloha';

  @override
  String get editTooltip => 'Upraviť';

  @override
  String get deleteTooltip => 'Odstrániť';

  @override
  String get dueDateLabel => 'Termín splnenia';

  @override
  String get noneLabel => 'Žiadny';

  @override
  String get tagsLabel => 'Štítky';

  @override
  String get priorityLabel => 'Priorita';

  @override
  String priorityValue(int priority) {
    return '$priority / 5';
  }

  @override
  String get colorLabel => 'Farba';

  @override
  String get syncStatusLabel => 'Synchronizácia';

  @override
  String get syncedStatus => 'Zverejnené na prenosových uzloch';

  @override
  String get notSyncedStatus => 'Iba lokálne (čaká na synchronizáciu)';

  @override
  String get linkedEventLabel => 'Prepojená udalosť kalendára';

  @override
  String createdUpdatedInfo(String created, String updated) {
    return 'Vytvorené $created\nAktualizované $updated';
  }

  @override
  String get deleteTaskConfirmTitle => 'Odstrániť túto úlohu?';

  @override
  String get deleteTaskConfirmBody =>
      'Úloha sa odstráni lokálne a na vaše prenosové uzly sa odošle žiadosť o odstránenie.';

  @override
  String get deleteButton => 'Odstrániť';

  @override
  String get deleteTaskError => 'Úlohu sa nepodarilo lokálne odstrániť.';

  @override
  String get saveTaskError => 'Úlohu sa nepodarilo lokálne uložiť.';

  @override
  String get editTaskTitle => 'Upraviť úlohu';

  @override
  String get newTaskTitle => 'Nová úloha';

  @override
  String get syncToNostrTitle => 'Synchronizovať s Nostr';

  @override
  String get syncToNostrSubtitle =>
      'Publikuje úlohu zašifrovanú na vaše relaye. Ak je vypnuté, zostane len v tomto zariadení.';

  @override
  String get syncTaskButton => 'Synchronizovať úlohu';

  @override
  String get localOnlyStatus => 'Iba lokálne (synchronizácia vypnutá)';

  @override
  String get titleFieldLabel => 'Názov';

  @override
  String get titleRequiredError => 'Názov je povinný.';

  @override
  String get titleTooLongError => 'Názov je príliš dlhý.';

  @override
  String get descriptionFieldLabel => 'Popis (voliteľné)';

  @override
  String get noDueDateLabel => 'Bez termínu';

  @override
  String get optionalDeadlineHint => 'Voliteľný termín.';

  @override
  String get clearDueDateTooltip => 'Vymazať termín splnenia';

  @override
  String get tagsFieldLabel => 'Štítky (oddelené čiarkou, voliteľné)';

  @override
  String get tagsFieldHint => 'práca, osobné';

  @override
  String get tooManyTagsError => 'Použite najviac 32 štítkov.';

  @override
  String get tagTooLongError => 'Každý štítok môže mať najviac 64 znakov.';

  @override
  String get priorityScaleHint => '1 = nízka, 5 = vysoká';

  @override
  String get syncNowTooltip => 'Synchronizovať teraz';

  @override
  String get settingsTooltip => 'Nastavenia';

  @override
  String get newTaskTooltip => 'Nová úloha';

  @override
  String get loadTasksError => 'Lokálne úlohy sa nepodarilo načítať.';

  @override
  String get emptyTasksTitle => 'Zatiaľ žiadne úlohy';

  @override
  String get emptyTasksBody => 'Klepnutím na + pridáte svoju prvú úlohu.';

  @override
  String completedCount(int count) {
    return 'Dokončené ($count)';
  }

  @override
  String get invalidKeyError =>
      'Tento súkromný kľúč nie je platný. Skontrolujte ho a skúste to znova.';

  @override
  String get signInError =>
      'Prihlásenie sa nepodarilo. Skúste to prosím znova.';

  @override
  String get signInAmberButton => 'Prihlásiť sa cez Amber';

  @override
  String get createAccountButton => 'Vytvoriť nový účet';

  @override
  String get generatedAccountHint =>
      'Vygenerovaný účet je možné obnoviť iba pomocou jeho súkromného kľúča. Po dokončení nastavenia si ho zálohujte v Nastaveniach.';

  @override
  String get importKeyButton => 'Importovať existujúci kľúč';

  @override
  String get importKeyFieldLabel => 'nsec alebo súkromný kľúč v hex';

  @override
  String get importButton => 'Importovať';

  @override
  String get storageFailureMessage =>
      'Aplikácii Kairos sa nepodarilo otvoriť šifrovanú lokálnu databázu. Reštartujte aplikáciu. Neodstraňujte dáta aplikácie; ak problém pretrváva, nahláste ho súkromne.';
}
