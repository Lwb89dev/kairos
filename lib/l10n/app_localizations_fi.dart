// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Finnish (`fi`).
class AppLocalizationsFi extends AppLocalizations {
  AppLocalizationsFi([String locale = 'fi']) : super(locale);

  @override
  String get settingsTitle => 'Asetukset';

  @override
  String get sectionAccount => 'Tili';

  @override
  String get addAccountTitle => 'Lisää Nostr-tili';

  @override
  String get addAccountSubtitle =>
      'Tällä hetkellä offline-tilassa, vain paikallisesti.';

  @override
  String get backupKeyTitle => 'Varmuuskopioi yksityinen avain';

  @override
  String get backupKeySubtitle => 'Vaaditaan tämän Nostr-tilin palauttamiseen.';

  @override
  String get logOut => 'Kirjaudu ulos';

  @override
  String get sectionSync => 'Synkronointi';

  @override
  String get syncInfoTitle => 'Valinnainen salattu synkronointi';

  @override
  String get syncInfoBody =>
      'Tehtävät synkronoidaan vain, kun Nostr-tili ja vähintään yksi relay on määritetty. Tehtävän sisältö salataan NIP-44:llä ennen kuin se lähtee tästä laitteesta.';

  @override
  String get sectionRelays => 'Relayt';

  @override
  String get sectionAppearance => 'Ulkoasu';

  @override
  String get themeLabel => 'Teema';

  @override
  String get sectionLanguage => 'Kieli';

  @override
  String get langSystem => 'Järjestelmä';

  @override
  String get sectionSupport => 'Tuki';

  @override
  String get supportKairosTitle => 'Tue Kairosta';

  @override
  String lightningAddressCopied(String address) {
    return 'Lightning-lompakkoa ei löytynyt — osoite kopioitu: $address';
  }

  @override
  String get logoutConfirmTitle => 'Kirjaudutaanko ulos?';

  @override
  String get logoutConfirmBody =>
      'Tehtäväsi pysyvät tällä laitteella. Ilman avainta niitä ei voi enää synkronoida — varmista, että sinulla on varmuuskopio nsec-avaimestasi ennen uloskirjautumista.';

  @override
  String get cancelButton => 'Peruuta';

  @override
  String get nsecDialogTitle => 'Yksityinen avaimesi (nsec)';

  @override
  String get nsecDialogWarning =>
      'Kuka tahansa, jolla on tämä avain, hallitsee tiliäsi. Säilytä se salasananhallinnassa äläkä koskaan jaa sitä.';

  @override
  String get copyButton => 'Kopioi';

  @override
  String get doneButton => 'Valmis';

  @override
  String get signedInWithAmber => 'Kirjauduttu sisään Amberilla';

  @override
  String signedInWithKey(String npub) {
    return 'Kirjautunut sisään · $npub';
  }

  @override
  String get relayInvalidUrlWss =>
      'Anna kelvollinen salattu wss://-relay-osoite.';

  @override
  String get relayUrlHint => 'wss://oma-relay…';

  @override
  String get addRelayTooltip => 'Lisää relay';

  @override
  String get noRelaysConfigured => 'Relayta ei ole määritetty.';

  @override
  String get removeRelayTooltip => 'Poista relay';

  @override
  String get homeRelayTitle => 'Henkilökohtainen kotirelay';

  @override
  String get homeRelayConfiguredSubtitle =>
      'Ylimääräinen varmuuskopiointikohde salatuille tehtävillesi';

  @override
  String get homeRelaySubtitle =>
      'Valinnainen: lisää oma relay ylimääräiseksi varmuuskopiointikohteeksi. Toisin kuin muut relayt, tämä voi käyttää myös salaamatonta ws://-osoitetta, jos se on paikallisverkossasi.';

  @override
  String get removeHomeRelayTooltip => 'Poista kotirelay';

  @override
  String get homeRelayUrlHint => 'wss://oma-kotirelay tai ws:// lähiverkossasi';

  @override
  String get homeRelayInvalidUrl =>
      'Anna kelvollinen wss://-relay-osoite (ws:// on sallittu vain omassa verkossasi olevalle kotirelaylle).';

  @override
  String get saveButton => 'Tallenna';

  @override
  String get onboardingSaveError =>
      'Asetuksia ei voitu tallentaa tälle laitteelle.';

  @override
  String get backButton => 'Takaisin';

  @override
  String get getStartedButton => 'Aloita';

  @override
  String get useOfflineButton => 'Käytä offline-tilassa';

  @override
  String get nextButton => 'Seuraava';

  @override
  String welcomeTitle(String appName) {
    return 'Tervetuloa, $appName';
  }

  @override
  String get welcomeSubtitle =>
      'Yksityinen, keskittynyt tehtävienhallinta Echoes-ekosysteemissä.';

  @override
  String get featureLocalTitle => 'Sinun, omalla laitteellasi';

  @override
  String get featureLocalBody =>
      'Tehtävät tallennetaan ensin paikallisesti salattuun tietokantaan. Sovellus toimii täysin offline-tilassa — tiliä ei tarvita.';

  @override
  String get featureSyncTitle => 'Synkronointi Nostrin kautta';

  @override
  String get featureSyncBody =>
      'Kirjaudu sisään Nostr-avaimella, ja tehtäväsi synkronoituvat laitteiden välillä valitsemiesi relayjen kautta — ilman yritysten palvelinta välissä.';

  @override
  String get featureEncryptedTitle => 'Päästä päähän salattu';

  @override
  String get featureEncryptedBody =>
      'Jokainen tehtävä salataan (NIP-44) ennen kuin se lähtee laitteesta. Relayt näkevät vain salatekstiä.';

  @override
  String get featureAmberTitle => 'Amber-tuki';

  @override
  String get featureAmberBody =>
      'Androidilla voit säilyttää avaimesi Amberissa: yksi kirjautuminen koko sarjalle, eikä mikään sovellus koskaan koske itse avainta.';

  @override
  String get loginPageTitle =>
      'Kirjaudu sisään synkronoidaksesi salatut tehtäväsi';

  @override
  String get loginPageBody =>
      'Käytä Nostr-identiteettiä valinnaiseen laitteiden väliseen synkronointiin tai jatka ilman tiliä ja pidä kaikki paikallisena.';

  @override
  String get relaySetupTitle => 'Valitse relayt';

  @override
  String get relaySetupBody =>
      'Relayt tallentavat salatut tehtävät synkronointia varten Kairosin kanssa muilla laitteillasi. Lisää yksi tai useampi tai jätä tämä tyhjäksi ja määritä synkronointi myöhemmin.';

  @override
  String get relaySettingsLoadError => 'Relay-asetuksia ei voitu ladata.';

  @override
  String get taskGoneMessage => 'Tätä tehtävää ei enää ole olemassa.';

  @override
  String get taskDetailsTitle => 'Tehtävä';

  @override
  String get editTooltip => 'Muokkaa';

  @override
  String get deleteTooltip => 'Poista';

  @override
  String get dueDateLabel => 'Eräpäivä';

  @override
  String get noneLabel => 'Ei mitään';

  @override
  String get tagsLabel => 'Tunnisteet';

  @override
  String get priorityLabel => 'Prioriteetti';

  @override
  String priorityValue(int priority) {
    return '$priority / 5';
  }

  @override
  String get colorLabel => 'Väri';

  @override
  String get syncStatusLabel => 'Synkronointi';

  @override
  String get syncedStatus => 'Julkaistu relayihin';

  @override
  String get notSyncedStatus => 'Vain paikallinen (synkronointi odottaa)';

  @override
  String get linkedEventLabel => 'Linkitetty kalenteritapahtuma';

  @override
  String createdUpdatedInfo(String created, String updated) {
    return 'Luotu $created\nPäivitetty $updated';
  }

  @override
  String get deleteTaskConfirmTitle => 'Poistetaanko tämä tehtävä?';

  @override
  String get deleteTaskConfirmBody =>
      'Tehtävä poistetaan paikallisesti, ja poistopyyntö lähetetään relayeillesi.';

  @override
  String get deleteButton => 'Poista';

  @override
  String get deleteTaskError => 'Tehtävää ei voitu poistaa paikallisesti.';

  @override
  String get saveTaskError => 'Tehtävää ei voitu tallentaa paikallisesti.';

  @override
  String get editTaskTitle => 'Muokkaa tehtävää';

  @override
  String get newTaskTitle => 'Uusi tehtävä';

  @override
  String get syncToNostrTitle => 'Synkronoi Nostriin';

  @override
  String get syncToNostrSubtitle =>
      'Julkaisee tehtävän salattuna releillesi. Pois päältä: tehtävä pysyy vain tällä laitteella.';

  @override
  String get syncTaskButton => 'Synkronoi tehtävä';

  @override
  String get localOnlyStatus => 'Vain paikallinen (synkronointi pois)';

  @override
  String get titleFieldLabel => 'Otsikko';

  @override
  String get titleRequiredError => 'Otsikko vaaditaan.';

  @override
  String get titleTooLongError => 'Otsikko on liian pitkä.';

  @override
  String get descriptionFieldLabel => 'Kuvaus (valinnainen)';

  @override
  String get noDueDateLabel => 'Ei eräpäivää';

  @override
  String get optionalDeadlineHint => 'Valinnainen määräaika.';

  @override
  String get clearDueDateTooltip => 'Tyhjennä eräpäivä';

  @override
  String get tagsFieldLabel => 'Tunnisteet (pilkuilla erotettuna, valinnainen)';

  @override
  String get tagsFieldHint => 'työ, henkilökohtainen';

  @override
  String get tooManyTagsError => 'Käytä enintään 32 tunnistetta.';

  @override
  String get tagTooLongError =>
      'Kunkin tunnisteen on oltava enintään 64 merkkiä pitkä.';

  @override
  String get priorityScaleHint => '1 = matala, 5 = korkea';

  @override
  String get syncNowTooltip => 'Synkronoi nyt';

  @override
  String get settingsTooltip => 'Asetukset';

  @override
  String get newTaskTooltip => 'Uusi tehtävä';

  @override
  String get loadTasksError => 'Paikallisia tehtäviä ei voitu ladata.';

  @override
  String get emptyTasksTitle => 'Ei vielä tehtäviä';

  @override
  String get emptyTasksBody =>
      'Napauta +-painiketta lisätäksesi ensimmäisen tehtäväsi.';

  @override
  String completedCount(int count) {
    return 'Valmiit ($count)';
  }

  @override
  String get invalidKeyError =>
      'Tämä yksityinen avain ei ole kelvollinen. Tarkista se ja yritä uudelleen.';

  @override
  String get signInError => 'Sisäänkirjautuminen epäonnistui. Yritä uudelleen.';

  @override
  String get signInAmberButton => 'Kirjaudu sisään Amberilla';

  @override
  String get createAccountButton => 'Luo uusi tili';

  @override
  String get generatedAccountHint =>
      'Luodun tilin voi palauttaa vain sen yksityisellä avaimella. Varmuuskopioi se Asetuksista määrityksen jälkeen.';

  @override
  String get importKeyButton => 'Tuo olemassa oleva avain';

  @override
  String get importKeyFieldLabel =>
      'nsec tai heksadesimaalinen yksityinen avain';

  @override
  String get importButton => 'Tuo';

  @override
  String get storageFailureMessage =>
      'Kairos ei voinut avata salattua paikallista tietokantaansa. Käynnistä sovellus uudelleen. Älä tyhjennä sovelluksen tietoja; jos ongelma jatkuu, ilmoita siitä yksityisesti.';
}
