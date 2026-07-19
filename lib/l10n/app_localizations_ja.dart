// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get settingsTitle => '設定';

  @override
  String get sectionAccount => 'アカウント';

  @override
  String get addAccountTitle => 'Nostrアカウントを追加';

  @override
  String get addAccountSubtitle => '現在オフライン、ローカルのみです。';

  @override
  String get backupKeyTitle => '秘密鍵をバックアップ';

  @override
  String get backupKeySubtitle => 'このNostrアカウントを復元するために必要です。';

  @override
  String get logOut => 'ログアウト';

  @override
  String get sectionSync => '同期';

  @override
  String get syncInfoTitle => '暗号化同期（任意）';

  @override
  String get syncInfoBody =>
      'タスクはNostrアカウントとリレーが1つ以上設定されている場合のみ同期されます。タスクの内容はデバイスから送信される前にNIP-44で暗号化されます。';

  @override
  String get sectionRelays => 'リレー';

  @override
  String get sectionAppearance => '外観';

  @override
  String get themeLabel => 'テーマ';

  @override
  String get sectionLanguage => '言語';

  @override
  String get langSystem => 'システム';

  @override
  String get sectionSupport => 'サポート';

  @override
  String get supportKairosTitle => 'Kairosを応援する';

  @override
  String lightningAddressCopied(String address) {
    return 'Lightningウォレットが見つかりません — アドレスをコピーしました: $address';
  }

  @override
  String get logoutConfirmTitle => 'ログアウトしますか？';

  @override
  String get logoutConfirmBody =>
      'タスクはこのデバイスに残ります。鍵がないと同期できなくなります — ログアウトする前にnsecのバックアップを必ず取ってください。';

  @override
  String get cancelButton => 'キャンセル';

  @override
  String get nsecDialogTitle => '秘密鍵（nsec）';

  @override
  String get nsecDialogWarning =>
      'この鍵を持つ人は誰でもあなたのアカウントを操作できます。パスワードマネージャーに保管し、絶対に他人と共有しないでください。';

  @override
  String get copyButton => 'コピー';

  @override
  String get doneButton => '完了';

  @override
  String get signedInWithAmber => 'Amberでサインイン済み';

  @override
  String signedInWithKey(String npub) {
    return 'サインイン済み · $npub';
  }

  @override
  String get relayInvalidUrlWss => '有効な暗号化されたwss://リレーURLを入力してください。';

  @override
  String get relayUrlHint => 'wss://あなたのリレー…';

  @override
  String get addRelayTooltip => 'リレーを追加';

  @override
  String get noRelaysConfigured => 'リレーが設定されていません。';

  @override
  String get removeRelayTooltip => 'リレーを削除';

  @override
  String get homeRelayTitle => '個人用ホームリレー';

  @override
  String get homeRelayConfiguredSubtitle => '暗号化タスクの追加バックアップ先';

  @override
  String get homeRelaySubtitle =>
      '任意：自分のリレーを追加のバックアップ先として設定できます。他のリレーと異なり、ローカルネットワーク上であれば暗号化されていないws://アドレスも使用できます。';

  @override
  String get removeHomeRelayTooltip => 'ホームリレーを削除';

  @override
  String get homeRelayUrlHint => 'wss://ホームリレー、またはLAN内ならws://';

  @override
  String get homeRelayInvalidUrl =>
      '有効なwss://リレーURLを入力してください（ws://は自分のネットワーク上のホームリレーにのみ使用できます）。';

  @override
  String get saveButton => '保存';

  @override
  String get onboardingSaveError => 'このデバイスに設定を保存できませんでした。';

  @override
  String get backButton => '戻る';

  @override
  String get getStartedButton => '始める';

  @override
  String get useOfflineButton => 'オフラインで使用';

  @override
  String get nextButton => '次へ';

  @override
  String welcomeTitle(String appName) {
    return '$appNameへようこそ';
  }

  @override
  String get welcomeSubtitle => 'Echoesエコシステムのプライベートで集中できるタスク管理アプリ。';

  @override
  String get featureLocalTitle => 'あなたのもの、あなたの端末に';

  @override
  String get featureLocalBody =>
      'タスクはまずローカルの暗号化データベースに保存されます。アプリは完全にオフラインで動作し、アカウントは不要です。';

  @override
  String get featureSyncTitle => 'Nostrによる同期';

  @override
  String get featureSyncBody =>
      'Nostrの鍵でサインインすると、選んだリレーを通じてタスクが複数のデバイス間で同期されます — 企業のサーバーは介在しません。';

  @override
  String get featureEncryptedTitle => 'エンドツーエンド暗号化';

  @override
  String get featureEncryptedBody =>
      'すべてのタスクはデバイスを離れる前に（NIP-44で）暗号化されます。リレーが目にするのは暗号文だけです。';

  @override
  String get featureAmberTitle => 'Amber対応';

  @override
  String get featureAmberBody =>
      'Androidでは鍵をAmberに保管できます。スイート全体を1回のサインインでカバーし、アプリが鍵そのものに触れることはありません。';

  @override
  String get loginPageTitle => 'サインインして暗号化タスクを同期';

  @override
  String get loginPageBody =>
      'Nostr IDを使えば複数デバイス間の同期を任意で利用できます。アカウントなしで続行し、すべてローカルに保つこともできます。';

  @override
  String get relaySetupTitle => 'リレーを選択';

  @override
  String get relaySetupBody =>
      'リレーは他のKairos端末との同期のために暗号化タスクを保存します。1つ以上追加するか、空のままにして後で同期を設定できます。';

  @override
  String get relaySettingsLoadError => 'リレー設定を読み込めませんでした。';

  @override
  String get taskGoneMessage => 'このタスクはもう存在しません。';

  @override
  String get taskDetailsTitle => 'タスク';

  @override
  String get editTooltip => '編集';

  @override
  String get deleteTooltip => '削除';

  @override
  String get dueDateLabel => '期限';

  @override
  String get noneLabel => 'なし';

  @override
  String get tagsLabel => 'タグ';

  @override
  String get priorityLabel => '優先度';

  @override
  String priorityValue(int priority) {
    return '$priority / 5';
  }

  @override
  String get colorLabel => '色';

  @override
  String get syncStatusLabel => '同期';

  @override
  String get syncedStatus => 'リレーに公開済み';

  @override
  String get notSyncedStatus => 'ローカルのみ（同期待ち）';

  @override
  String get linkedEventLabel => 'リンクされたカレンダーイベント';

  @override
  String createdUpdatedInfo(String created, String updated) {
    return '作成日 $created\n更新日 $updated';
  }

  @override
  String get deleteTaskConfirmTitle => 'このタスクを削除しますか？';

  @override
  String get deleteTaskConfirmBody => 'タスクはローカルから削除され、削除リクエストがリレーに送信されます。';

  @override
  String get deleteButton => '削除';

  @override
  String get deleteTaskError => 'タスクをローカルで削除できませんでした。';

  @override
  String get saveTaskError => 'タスクをローカルに保存できませんでした。';

  @override
  String get editTaskTitle => 'タスクを編集';

  @override
  String get newTaskTitle => '新規タスク';

  @override
  String get titleFieldLabel => 'タイトル';

  @override
  String get titleRequiredError => 'タイトルを入力してください。';

  @override
  String get titleTooLongError => 'タイトルが長すぎます。';

  @override
  String get descriptionFieldLabel => '説明（任意）';

  @override
  String get noDueDateLabel => '期限なし';

  @override
  String get optionalDeadlineHint => '任意の期限です。';

  @override
  String get clearDueDateTooltip => '期限をクリア';

  @override
  String get tagsFieldLabel => 'タグ（カンマ区切り、任意）';

  @override
  String get tagsFieldHint => '仕事, プライベート';

  @override
  String get tooManyTagsError => 'タグは最大32個までです。';

  @override
  String get tagTooLongError => '各タグは64文字以内にしてください。';

  @override
  String get priorityScaleHint => '1 = 低、5 = 高';

  @override
  String get syncNowTooltip => '今すぐ同期';

  @override
  String get settingsTooltip => '設定';

  @override
  String get newTaskTooltip => '新規タスク';

  @override
  String get loadTasksError => 'ローカルのタスクを読み込めませんでした。';

  @override
  String get emptyTasksTitle => 'まだタスクがありません';

  @override
  String get emptyTasksBody => '＋をタップして最初のタスクを追加しましょう。';

  @override
  String completedCount(int count) {
    return '完了済み（$count）';
  }

  @override
  String get invalidKeyError => 'その秘密鍵は無効です。確認してもう一度お試しください。';

  @override
  String get signInError => 'サインインできませんでした。もう一度お試しください。';

  @override
  String get signInAmberButton => 'Amberでサインイン';

  @override
  String get createAccountButton => '新しいアカウントを作成';

  @override
  String get generatedAccountHint =>
      '生成されたアカウントは秘密鍵でのみ復元できます。設定完了後、設定画面からバックアップを取ってください。';

  @override
  String get importKeyButton => '既存の鍵をインポート';

  @override
  String get importKeyFieldLabel => 'nsecまたは16進数の秘密鍵';

  @override
  String get importButton => 'インポート';

  @override
  String get storageFailureMessage =>
      'Kairosは暗号化されたローカルデータベースを開けませんでした。アプリを再起動してください。アプリのデータは消去せず、問題が続く場合は非公開で報告してください。';
}
