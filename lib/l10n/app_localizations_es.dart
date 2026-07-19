// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get sectionAccount => 'Cuenta';

  @override
  String get addAccountTitle => 'Añadir una cuenta de Nostr';

  @override
  String get addAccountSubtitle => 'Actualmente sin conexión, solo local.';

  @override
  String get backupKeyTitle => 'Hacer copia de seguridad de la clave privada';

  @override
  String get backupKeySubtitle =>
      'Necesaria para recuperar esta cuenta de Nostr.';

  @override
  String get logOut => 'Cerrar sesión';

  @override
  String get sectionSync => 'Sincronización';

  @override
  String get syncInfoTitle => 'Sincronización cifrada opcional';

  @override
  String get syncInfoBody =>
      'Las tareas se sincronizan solo cuando se ha configurado una cuenta de Nostr y al menos un relay. El contenido de las tareas se cifra con NIP-44 antes de salir de este dispositivo.';

  @override
  String get sectionRelays => 'Relays';

  @override
  String get sectionAppearance => 'Apariencia';

  @override
  String get themeLabel => 'Tema';

  @override
  String get sectionLanguage => 'Idioma';

  @override
  String get langSystem => 'Sistema';

  @override
  String get sectionSupport => 'Soporte';

  @override
  String get supportKairosTitle => 'Apoya a Kairos';

  @override
  String lightningAddressCopied(String address) {
    return 'No se encontró ninguna wallet Lightning — dirección copiada: $address';
  }

  @override
  String get logoutConfirmTitle => '¿Cerrar sesión?';

  @override
  String get logoutConfirmBody =>
      'Tus tareas permanecen en este dispositivo. Sin la clave, ya no podrán sincronizarse: asegúrate de tener una copia de seguridad de tu nsec antes de cerrar sesión.';

  @override
  String get cancelButton => 'Cancelar';

  @override
  String get nsecDialogTitle => 'Tu clave privada (nsec)';

  @override
  String get nsecDialogWarning =>
      'Cualquiera que tenga esta clave controla tu cuenta. Guárdala en un gestor de contraseñas y no la compartas nunca.';

  @override
  String get copyButton => 'Copiar';

  @override
  String get doneButton => 'Listo';

  @override
  String get signedInWithAmber => 'Sesión iniciada con Amber';

  @override
  String signedInWithKey(String npub) {
    return 'Sesión iniciada · $npub';
  }

  @override
  String get relayInvalidUrlWss =>
      'Introduce una URL de relay wss:// cifrada válida.';

  @override
  String get relayUrlHint => 'wss://tu-relay…';

  @override
  String get addRelayTooltip => 'Añadir relay';

  @override
  String get noRelaysConfigured => 'No hay relays configurados.';

  @override
  String get removeRelayTooltip => 'Eliminar relay';

  @override
  String get homeRelayTitle => 'Relay personal';

  @override
  String get homeRelayConfiguredSubtitle =>
      'Destino de copia de seguridad adicional para tus tareas cifradas';

  @override
  String get homeRelaySubtitle =>
      'Opcional: añade tu propio relay como destino de copia de seguridad adicional. A diferencia de otros relays, este también puede usar una dirección ws:// sin cifrar si está en tu red local.';

  @override
  String get removeHomeRelayTooltip => 'Eliminar relay personal';

  @override
  String get homeRelayUrlHint =>
      'wss://tu-relay-personal, o ws:// en tu red LAN';

  @override
  String get homeRelayInvalidUrl =>
      'Introduce una URL de relay wss:// válida (ws:// solo se permite para un relay personal en tu propia red).';

  @override
  String get saveButton => 'Guardar';

  @override
  String get onboardingSaveError =>
      'No se pudo guardar la configuración en este dispositivo.';

  @override
  String get backButton => 'Atrás';

  @override
  String get getStartedButton => 'Comenzar';

  @override
  String get useOfflineButton => 'Usar sin conexión';

  @override
  String get nextButton => 'Siguiente';

  @override
  String welcomeTitle(String appName) {
    return 'Bienvenido a $appName';
  }

  @override
  String get welcomeSubtitle =>
      'Un gestor de tareas privado y centrado, dentro del ecosistema Echoes.';

  @override
  String get featureLocalTitle => 'Tuyo, en tu dispositivo';

  @override
  String get featureLocalBody =>
      'Las tareas se guardan primero localmente en una base de datos cifrada. La app funciona completamente sin conexión: no se requiere cuenta.';

  @override
  String get featureSyncTitle => 'Sincronización a través de Nostr';

  @override
  String get featureSyncBody =>
      'Inicia sesión con una clave Nostr y tus tareas se sincronizan entre dispositivos a través de los relays que elijas, sin ningún servidor empresarial de por medio.';

  @override
  String get featureEncryptedTitle => 'Cifrado de extremo a extremo';

  @override
  String get featureEncryptedBody =>
      'Cada tarea se cifra (NIP-44) antes de salir del dispositivo. Los relays solo llegan a ver texto cifrado.';

  @override
  String get featureAmberTitle => 'Compatibilidad con Amber';

  @override
  String get featureAmberBody =>
      'En Android puedes guardar tu clave en Amber: un solo inicio de sesión para toda la suite, y ninguna app llega a tocar la clave en sí.';

  @override
  String get loginPageTitle =>
      'Inicia sesión para sincronizar tus tareas cifradas';

  @override
  String get loginPageBody =>
      'Usa una identidad de Nostr para la sincronización opcional entre dispositivos, o continúa sin cuenta y mantén todo local.';

  @override
  String get relaySetupTitle => 'Elige tus relays';

  @override
  String get relaySetupBody =>
      'Los relays almacenan tareas cifradas para la sincronización con Kairos en tus otros dispositivos. Añade uno o más, o deja esto vacío y configura la sincronización más tarde.';

  @override
  String get relaySettingsLoadError =>
      'No se pudieron cargar los ajustes de los relays.';

  @override
  String get taskGoneMessage => 'Esta tarea ya no existe.';

  @override
  String get taskDetailsTitle => 'Tarea';

  @override
  String get editTooltip => 'Editar';

  @override
  String get deleteTooltip => 'Eliminar';

  @override
  String get dueDateLabel => 'Fecha de vencimiento';

  @override
  String get noneLabel => 'Ninguna';

  @override
  String get tagsLabel => 'Etiquetas';

  @override
  String get priorityLabel => 'Prioridad';

  @override
  String priorityValue(int priority) {
    return '$priority / 5';
  }

  @override
  String get colorLabel => 'Color';

  @override
  String get syncStatusLabel => 'Sincronización';

  @override
  String get syncedStatus => 'Publicada en los relays';

  @override
  String get notSyncedStatus => 'Solo local (sincronización pendiente)';

  @override
  String get linkedEventLabel => 'Evento de calendario vinculado';

  @override
  String createdUpdatedInfo(String created, String updated) {
    return 'Creada el $created\nActualizada el $updated';
  }

  @override
  String get deleteTaskConfirmTitle => '¿Eliminar esta tarea?';

  @override
  String get deleteTaskConfirmBody =>
      'La tarea se elimina localmente y se envía una solicitud de eliminación a tus relays.';

  @override
  String get deleteButton => 'Eliminar';

  @override
  String get deleteTaskError => 'No se pudo eliminar la tarea localmente.';

  @override
  String get saveTaskError => 'No se pudo guardar la tarea localmente.';

  @override
  String get editTaskTitle => 'Editar tarea';

  @override
  String get newTaskTitle => 'Nueva tarea';

  @override
  String get syncToNostrTitle => 'Sincronizar con Nostr';

  @override
  String get syncToNostrSubtitle =>
      'Publica esta tarea, cifrada, en tus relés. Si está desactivado, se queda solo en este dispositivo.';

  @override
  String get syncTaskButton => 'Sincronizar tarea';

  @override
  String get localOnlyStatus => 'Solo local (sin sincronización)';

  @override
  String get titleFieldLabel => 'Título';

  @override
  String get titleRequiredError => 'El título es obligatorio.';

  @override
  String get titleTooLongError => 'El título es demasiado largo.';

  @override
  String get descriptionFieldLabel => 'Descripción (opcional)';

  @override
  String get noDueDateLabel => 'Sin fecha de vencimiento';

  @override
  String get optionalDeadlineHint => 'Fecha límite opcional.';

  @override
  String get clearDueDateTooltip => 'Borrar fecha de vencimiento';

  @override
  String get tagsFieldLabel => 'Etiquetas (separadas por comas, opcional)';

  @override
  String get tagsFieldHint => 'trabajo, personal';

  @override
  String get tooManyTagsError => 'Usa como máximo 32 etiquetas.';

  @override
  String get tagTooLongError =>
      'Cada etiqueta debe tener como máximo 64 caracteres.';

  @override
  String get priorityScaleHint => '1 = baja, 5 = alta';

  @override
  String get syncNowTooltip => 'Sincronizar ahora';

  @override
  String get settingsTooltip => 'Ajustes';

  @override
  String get newTaskTooltip => 'Nueva tarea';

  @override
  String get loadTasksError => 'No se pudieron cargar las tareas locales.';

  @override
  String get emptyTasksTitle => 'Aún no hay tareas';

  @override
  String get emptyTasksBody => 'Toca + para añadir tu primera tarea.';

  @override
  String completedCount(int count) {
    return 'Completadas ($count)';
  }

  @override
  String get invalidKeyError =>
      'Esa clave privada no es válida. Compruébala e inténtalo de nuevo.';

  @override
  String get signInError => 'No se pudo iniciar sesión. Inténtalo de nuevo.';

  @override
  String get signInAmberButton => 'Iniciar sesión con Amber';

  @override
  String get createAccountButton => 'Crear una nueva cuenta';

  @override
  String get generatedAccountHint =>
      'Una cuenta generada solo se puede recuperar con su clave privada. Haz una copia de seguridad desde Ajustes después de la configuración.';

  @override
  String get importKeyButton => 'Importar una clave existente';

  @override
  String get importKeyFieldLabel => 'nsec o clave privada hexadecimal';

  @override
  String get importButton => 'Importar';

  @override
  String get storageFailureMessage =>
      'Kairos no pudo abrir su base de datos local cifrada. Reinicia la app. No borres los datos de la app; si el problema persiste, repórtalo de forma privada.';
}
