// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get sectionAccount => 'Conta';

  @override
  String get addAccountTitle => 'Adicionar uma conta Nostr';

  @override
  String get addAccountSubtitle => 'Atualmente offline, apenas local.';

  @override
  String get backupKeyTitle => 'Fazer backup da chave privada';

  @override
  String get backupKeySubtitle => 'Necessária para recuperar esta conta Nostr.';

  @override
  String get logOut => 'Sair';

  @override
  String get sectionSync => 'Sincronização';

  @override
  String get syncInfoTitle => 'Sincronização criptografada opcional';

  @override
  String get syncInfoBody =>
      'As tarefas são sincronizadas somente quando uma conta Nostr e pelo menos um relay estão configurados. O conteúdo das tarefas é criptografado com NIP-44 antes de sair deste dispositivo.';

  @override
  String get sectionRelays => 'Relays';

  @override
  String get sectionAppearance => 'Aparência';

  @override
  String get themeLabel => 'Tema';

  @override
  String get sectionLanguage => 'Idioma';

  @override
  String get langSystem => 'Sistema';

  @override
  String get sectionSupport => 'Suporte';

  @override
  String get supportKairosTitle => 'Apoie o Kairos';

  @override
  String lightningAddressCopied(String address) {
    return 'Nenhuma carteira Lightning encontrada — endereço copiado: $address';
  }

  @override
  String get logoutConfirmTitle => 'Sair?';

  @override
  String get logoutConfirmBody =>
      'Suas tarefas permanecem neste dispositivo. Sem a chave, elas não poderão mais sincronizar — certifique-se de ter um backup do seu nsec antes de sair.';

  @override
  String get cancelButton => 'Cancelar';

  @override
  String get nsecDialogTitle => 'Sua chave privada (nsec)';

  @override
  String get nsecDialogWarning =>
      'Qualquer pessoa com esta chave controla sua conta. Guarde-a em um gerenciador de senhas e nunca a compartilhe.';

  @override
  String get copyButton => 'Copiar';

  @override
  String get doneButton => 'Concluído';

  @override
  String get signedInWithAmber => 'Conectado com Amber';

  @override
  String signedInWithKey(String npub) {
    return 'Conectado · $npub';
  }

  @override
  String get relayInvalidUrlWss =>
      'Insira um URL de relay wss:// criptografado válido.';

  @override
  String get relayUrlHint => 'wss://seu-relay…';

  @override
  String get addRelayTooltip => 'Adicionar relay';

  @override
  String get noRelaysConfigured => 'Nenhum relay configurado.';

  @override
  String get removeRelayTooltip => 'Remover relay';

  @override
  String get homeRelayTitle => 'Relay pessoal';

  @override
  String get homeRelayConfiguredSubtitle =>
      'Destino de backup extra para suas tarefas criptografadas';

  @override
  String get homeRelaySubtitle =>
      'Opcional: adicione seu próprio relay como destino de backup extra. Diferente dos outros relays, este também pode usar um endereço ws:// não criptografado se estiver na sua rede local.';

  @override
  String get removeHomeRelayTooltip => 'Remover relay pessoal';

  @override
  String get homeRelayUrlHint =>
      'wss://seu-relay-pessoal, ou ws:// na sua rede local';

  @override
  String get homeRelayInvalidUrl =>
      'Insira um URL de relay wss:// válido (ws:// só é permitido para um relay pessoal na sua própria rede).';

  @override
  String get saveButton => 'Salvar';

  @override
  String get onboardingSaveError =>
      'Não foi possível salvar a configuração neste dispositivo.';

  @override
  String get backButton => 'Voltar';

  @override
  String get getStartedButton => 'Começar';

  @override
  String get useOfflineButton => 'Usar offline';

  @override
  String get nextButton => 'Próximo';

  @override
  String welcomeTitle(String appName) {
    return 'Bem-vindo ao $appName';
  }

  @override
  String get welcomeSubtitle =>
      'Um gerenciador de tarefas privado e focado, no ecossistema Echoes.';

  @override
  String get featureLocalTitle => 'Seu, no seu dispositivo';

  @override
  String get featureLocalBody =>
      'As tarefas são armazenadas primeiro localmente em um banco de dados criptografado. O app funciona totalmente offline — nenhuma conta é necessária.';

  @override
  String get featureSyncTitle => 'Sincronização via Nostr';

  @override
  String get featureSyncBody =>
      'Entre com uma chave Nostr e suas tarefas sincronizam entre dispositivos através dos relays que você escolher — sem nenhum servidor de empresa no meio.';

  @override
  String get featureEncryptedTitle => 'Criptografia de ponta a ponta';

  @override
  String get featureEncryptedBody =>
      'Cada tarefa é criptografada (NIP-44) antes de sair do dispositivo. Os relays só veem texto cifrado.';

  @override
  String get featureAmberTitle => 'Suporte a Amber';

  @override
  String get featureAmberBody =>
      'No Android você pode manter sua chave no Amber: um único login para toda a suíte, e nenhum app chega a tocar na chave em si.';

  @override
  String get loginPageTitle =>
      'Entre para sincronizar suas tarefas criptografadas';

  @override
  String get loginPageBody =>
      'Use uma identidade Nostr para sincronização opcional entre dispositivos, ou continue sem uma conta e mantenha tudo local.';

  @override
  String get relaySetupTitle => 'Escolha seus relays';

  @override
  String get relaySetupBody =>
      'Os relays armazenam tarefas criptografadas para sincronização com o Kairos nos seus outros dispositivos. Adicione um ou mais, ou deixe em branco e configure a sincronização mais tarde.';

  @override
  String get relaySettingsLoadError =>
      'Não foi possível carregar as configurações dos relays.';

  @override
  String get taskGoneMessage => 'Esta tarefa não existe mais.';

  @override
  String get taskDetailsTitle => 'Tarefa';

  @override
  String get editTooltip => 'Editar';

  @override
  String get deleteTooltip => 'Excluir';

  @override
  String get dueDateLabel => 'Data de vencimento';

  @override
  String get noneLabel => 'Nenhuma';

  @override
  String get tagsLabel => 'Etiquetas';

  @override
  String get priorityLabel => 'Prioridade';

  @override
  String priorityValue(int priority) {
    return '$priority / 5';
  }

  @override
  String get colorLabel => 'Cor';

  @override
  String get syncStatusLabel => 'Sincronização';

  @override
  String get syncedStatus => 'Publicada nos relays';

  @override
  String get notSyncedStatus => 'Somente local (sincronização pendente)';

  @override
  String get linkedEventLabel => 'Evento de calendário vinculado';

  @override
  String createdUpdatedInfo(String created, String updated) {
    return 'Criada em $created\nAtualizada em $updated';
  }

  @override
  String get deleteTaskConfirmTitle => 'Excluir esta tarefa?';

  @override
  String get deleteTaskConfirmBody =>
      'A tarefa é removida localmente e uma solicitação de exclusão é enviada aos seus relays.';

  @override
  String get deleteButton => 'Excluir';

  @override
  String get deleteTaskError => 'Não foi possível excluir a tarefa localmente.';

  @override
  String get saveTaskError => 'Não foi possível salvar a tarefa localmente.';

  @override
  String get editTaskTitle => 'Editar tarefa';

  @override
  String get newTaskTitle => 'Nova tarefa';

  @override
  String get syncToNostrTitle => 'Sincronizar com o Nostr';

  @override
  String get syncToNostrSubtitle =>
      'Publica esta tarefa, encriptada, nos teus relays. Se desligado, fica apenas neste dispositivo.';

  @override
  String get syncTaskButton => 'Sincronizar tarefa';

  @override
  String get localOnlyStatus => 'Apenas local (sync desligada)';

  @override
  String get titleFieldLabel => 'Título';

  @override
  String get titleRequiredError => 'O título é obrigatório.';

  @override
  String get titleTooLongError => 'O título é muito longo.';

  @override
  String get descriptionFieldLabel => 'Descrição (opcional)';

  @override
  String get noDueDateLabel => 'Sem data de vencimento';

  @override
  String get optionalDeadlineHint => 'Prazo opcional.';

  @override
  String get clearDueDateTooltip => 'Limpar data de vencimento';

  @override
  String get tagsFieldLabel => 'Etiquetas (separadas por vírgula, opcional)';

  @override
  String get tagsFieldHint => 'trabalho, pessoal';

  @override
  String get tooManyTagsError => 'Use no máximo 32 etiquetas.';

  @override
  String get tagTooLongError =>
      'Cada etiqueta deve ter no máximo 64 caracteres.';

  @override
  String get priorityScaleHint => '1 = baixa, 5 = alta';

  @override
  String get syncNowTooltip => 'Sincronizar agora';

  @override
  String get settingsTooltip => 'Configurações';

  @override
  String get newTaskTooltip => 'Nova tarefa';

  @override
  String get loadTasksError => 'Não foi possível carregar as tarefas locais.';

  @override
  String get emptyTasksTitle => 'Ainda não há tarefas';

  @override
  String get emptyTasksBody => 'Toque em + para adicionar sua primeira tarefa.';

  @override
  String completedCount(int count) {
    return 'Concluídas ($count)';
  }

  @override
  String get invalidKeyError =>
      'Essa chave privada não é válida. Verifique-a e tente novamente.';

  @override
  String get signInError => 'Não foi possível entrar. Tente novamente.';

  @override
  String get signInAmberButton => 'Entrar com Amber';

  @override
  String get createAccountButton => 'Criar uma nova conta';

  @override
  String get generatedAccountHint =>
      'Uma conta gerada só pode ser recuperada com sua chave privada. Faça um backup dela em Configurações após a configuração.';

  @override
  String get importKeyButton => 'Importar uma chave existente';

  @override
  String get importKeyFieldLabel => 'nsec ou chave privada hexadecimal';

  @override
  String get importButton => 'Importar';

  @override
  String get storageFailureMessage =>
      'O Kairos não conseguiu abrir seu banco de dados local criptografado. Reinicie o app. Não limpe os dados do app; se o problema persistir, relate-o de forma privada.';
}
