// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get settingsTitle => '设置';

  @override
  String get sectionAccount => '账户';

  @override
  String get addAccountTitle => '添加 Nostr 账户';

  @override
  String get addAccountSubtitle => '当前处于离线状态，仅本地使用。';

  @override
  String get backupKeyTitle => '备份私钥';

  @override
  String get backupKeySubtitle => '恢复此 Nostr 账户所必需。';

  @override
  String get logOut => '退出登录';

  @override
  String get sectionSync => '同步';

  @override
  String get syncInfoTitle => '可选的加密同步';

  @override
  String get syncInfoBody =>
      '只有在配置了 Nostr 账户和至少一个中继服务器后，任务才会同步。任务内容在离开设备前会使用 NIP-44 加密。';

  @override
  String get sectionRelays => '中继服务器';

  @override
  String get sectionAppearance => '外观';

  @override
  String get themeLabel => '主题';

  @override
  String get sectionLanguage => '语言';

  @override
  String get langSystem => '系统';

  @override
  String get sectionSupport => '支持';

  @override
  String get supportKairosTitle => '支持 Kairos';

  @override
  String lightningAddressCopied(String address) {
    return '未找到闪电钱包 — 地址已复制：$address';
  }

  @override
  String get logoutConfirmTitle => '要退出登录吗？';

  @override
  String get logoutConfirmBody =>
      '您的任务会保留在此设备上。没有密钥，它们将无法再同步——退出登录前请确保已备份您的 nsec。';

  @override
  String get cancelButton => '取消';

  @override
  String get nsecDialogTitle => '您的私钥（nsec）';

  @override
  String get nsecDialogWarning => '任何拥有此密钥的人都能控制您的账户。请将其保存在密码管理器中，切勿与他人分享。';

  @override
  String get copyButton => '复制';

  @override
  String get doneButton => '完成';

  @override
  String get signedInWithAmber => '已使用 Amber 登录';

  @override
  String signedInWithKey(String npub) {
    return '已登录 · $npub';
  }

  @override
  String get relayInvalidUrlWss => '请输入有效的加密 wss:// 中继地址。';

  @override
  String get relayUrlHint => 'wss://你的中继服务器…';

  @override
  String get addRelayTooltip => '添加中继服务器';

  @override
  String get noRelaysConfigured => '未配置任何中继服务器。';

  @override
  String get removeRelayTooltip => '移除中继服务器';

  @override
  String get homeRelayTitle => '个人主中继服务器';

  @override
  String get homeRelayConfiguredSubtitle => '为您的加密任务提供额外的备份目标';

  @override
  String get homeRelaySubtitle =>
      '可选：添加您自己的中继服务器作为额外的备份目标。与其他中继服务器不同，如果它位于您的本地网络中，也可以使用未加密的 ws:// 地址。';

  @override
  String get removeHomeRelayTooltip => '移除主中继服务器';

  @override
  String get homeRelayUrlHint => 'wss://你的主中继服务器，或局域网内的 ws://';

  @override
  String get homeRelayInvalidUrl =>
      '请输入有效的 wss:// 中继地址（ws:// 仅允许用于您自己网络中的主中继服务器）。';

  @override
  String get saveButton => '保存';

  @override
  String get onboardingSaveError => '无法在此设备上保存设置。';

  @override
  String get backButton => '返回';

  @override
  String get getStartedButton => '开始使用';

  @override
  String get useOfflineButton => '离线使用';

  @override
  String get nextButton => '下一步';

  @override
  String welcomeTitle(String appName) {
    return '欢迎使用 $appName';
  }

  @override
  String get welcomeSubtitle => 'Echoes 生态系统中一款私密、专注的任务管理应用。';

  @override
  String get featureLocalTitle => '属于你，就在你的设备上';

  @override
  String get featureLocalBody => '任务首先存储在本地的加密数据库中。应用可完全离线运行——无需账户。';

  @override
  String get featureSyncTitle => '通过 Nostr 同步';

  @override
  String get featureSyncBody =>
      '使用 Nostr 密钥登录后，您的任务将通过您选择的中继服务器在设备间同步——中间没有任何公司服务器。';

  @override
  String get featureEncryptedTitle => '端到端加密';

  @override
  String get featureEncryptedBody => '每个任务在离开设备前都会被加密（NIP-44）。中继服务器只能看到密文。';

  @override
  String get featureAmberTitle => '支持 Amber';

  @override
  String get featureAmberBody =>
      '在 Android 上，您可以将密钥保存在 Amber 中：整个应用套件只需登录一次，且任何应用都不会接触密钥本身。';

  @override
  String get loginPageTitle => '登录以同步您的加密任务';

  @override
  String get loginPageBody => '使用 Nostr 身份进行可选的多设备同步，或不使用账户继续，将所有内容保留在本地。';

  @override
  String get relaySetupTitle => '选择您的中继服务器';

  @override
  String get relaySetupBody =>
      '中继服务器存储加密任务，用于与您其他设备上的 Kairos 同步。可添加一个或多个，也可留空稍后再配置同步。';

  @override
  String get relaySettingsLoadError => '无法加载中继服务器设置。';

  @override
  String get taskGoneMessage => '此任务已不存在。';

  @override
  String get taskDetailsTitle => '任务';

  @override
  String get editTooltip => '编辑';

  @override
  String get deleteTooltip => '删除';

  @override
  String get dueDateLabel => '截止日期';

  @override
  String get noneLabel => '无';

  @override
  String get tagsLabel => '标签';

  @override
  String get priorityLabel => '优先级';

  @override
  String priorityValue(int priority) {
    return '$priority / 5';
  }

  @override
  String get colorLabel => '颜色';

  @override
  String get syncStatusLabel => '同步';

  @override
  String get syncedStatus => '已发布到中继服务器';

  @override
  String get notSyncedStatus => '仅本地（待同步）';

  @override
  String get linkedEventLabel => '已关联的日历事件';

  @override
  String createdUpdatedInfo(String created, String updated) {
    return '创建于 $created\n更新于 $updated';
  }

  @override
  String get deleteTaskConfirmTitle => '要删除此任务吗？';

  @override
  String get deleteTaskConfirmBody => '任务将从本地移除，并向您的中继服务器发送删除请求。';

  @override
  String get deleteButton => '删除';

  @override
  String get deleteTaskError => '无法在本地删除该任务。';

  @override
  String get saveTaskError => '无法在本地保存该任务。';

  @override
  String get editTaskTitle => '编辑任务';

  @override
  String get newTaskTitle => '新建任务';

  @override
  String get titleFieldLabel => '标题';

  @override
  String get titleRequiredError => '标题为必填项。';

  @override
  String get titleTooLongError => '标题过长。';

  @override
  String get descriptionFieldLabel => '描述（可选）';

  @override
  String get noDueDateLabel => '无截止日期';

  @override
  String get optionalDeadlineHint => '可选的截止时间。';

  @override
  String get clearDueDateTooltip => '清除截止日期';

  @override
  String get tagsFieldLabel => '标签（用逗号分隔，可选）';

  @override
  String get tagsFieldHint => '工作, 个人';

  @override
  String get tooManyTagsError => '最多使用 32 个标签。';

  @override
  String get tagTooLongError => '每个标签最多 64 个字符。';

  @override
  String get priorityScaleHint => '1 = 低，5 = 高';

  @override
  String get syncNowTooltip => '立即同步';

  @override
  String get settingsTooltip => '设置';

  @override
  String get newTaskTooltip => '新建任务';

  @override
  String get loadTasksError => '无法加载本地任务。';

  @override
  String get emptyTasksTitle => '暂无任务';

  @override
  String get emptyTasksBody => '点击 + 添加您的第一个任务。';

  @override
  String completedCount(int count) {
    return '已完成（$count）';
  }

  @override
  String get invalidKeyError => '该私钥无效。请检查后重试。';

  @override
  String get signInError => '无法登录，请重试。';

  @override
  String get signInAmberButton => '使用 Amber 登录';

  @override
  String get createAccountButton => '创建新账户';

  @override
  String get generatedAccountHint => '生成的账户只能通过其私钥恢复。请在设置完成后，从设置中进行备份。';

  @override
  String get importKeyButton => '导入现有密钥';

  @override
  String get importKeyFieldLabel => 'nsec 或十六进制私钥';

  @override
  String get importButton => '导入';

  @override
  String get storageFailureMessage =>
      'Kairos 无法打开其本地加密数据库。请重启应用。请勿清除应用数据；如果问题持续存在，请私下反馈。';
}
