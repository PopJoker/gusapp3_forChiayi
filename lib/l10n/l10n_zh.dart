// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class SZh extends S {
  SZh([String locale = 'zh']) : super(locale);

  @override
  String get locale => 'zh';

  @override
  String get account => '帳號';

  @override
  String get password => '密碼';

  @override
  String get keepLoggedIn => '保持登入';

  @override
  String get login => '登入';

  @override
  String get newAccount => '新帳號';

  @override
  String get newPassword => '新密碼';

  @override
  String get confirmPassword => '確認密碼';

  @override
  String get agreeTo => '我已閱讀並同意 ';

  @override
  String get termsOfService => '使用協議';

  @override
  String get privacyPolicy => '隱私權保護政策';

  @override
  String get and => '與';

  @override
  String get register => '註冊';

  @override
  String get pleaseEnterAccountPassword => '請輸入帳號與密碼';

  @override
  String get loginSuccess => '登入成功！';

  @override
  String get loginFailed => '登入失敗';

  @override
  String get pleaseFillAllFields => '請填寫所有欄位';

  @override
  String get invalidEmail => '請輸入正確的 Email 格式';

  @override
  String get passwordNotMatch => '兩次輸入的密碼不一致';

  @override
  String get registerSuccessWaitAdmin => '註冊成功，請等待管理員啟用';

  @override
  String get registerFailed => '註冊失敗';

  @override
  String cannotOpenUrl(Object url) {
    return '無法開啟官網: $url';
  }

  @override
  String get pleaseAgreeToTerms => '請先同意使用協議與隱私權保護政策';

  @override
  String get energySystem => '儲能系統';

  @override
  String get menu => '選單';

  @override
  String get deviceList => '儲能設備列表';

  @override
  String get addOrRemoveBinding => '新增與取消綁定';

  @override
  String get appSettings => 'APP設置';

  @override
  String get customerService => '客服';

  @override
  String get tutorial => '教學';

  @override
  String get aboutUs => '關於我們';

  @override
  String get logout => '登出';

  @override
  String get cancel => '取消';

  @override
  String get confirmLogout => '確認登出？';

  @override
  String get darkMode => '深色模式';

  @override
  String get language => '語言切換';

  @override
  String get addEnergyDevice => '新增儲能設備';

  @override
  String get deviceName => '設備名稱';

  @override
  String get barcode => 'Barcode';

  @override
  String get latitude => '緯度';

  @override
  String get longitude => '經度';

  @override
  String get deviceArea => '區域';

  @override
  String get addDevice => '新增設備';

  @override
  String get addedDevices => '已接入儲能設備';

  @override
  String get noDevicesYet => '尚未新增儲能設備';

  @override
  String get confirmUnbindTitle => '確認取消綁定？';

  @override
  String confirmUnbindContent(Object deviceName) {
    return '設備 $deviceName 將被取消綁定';
  }

  @override
  String get confirm => '確認';

  @override
  String scanFailed(Object error) {
    return '掃描失敗: $error';
  }

  @override
  String get barcodeExists => '此 Barcode 已存在！';

  @override
  String get latitudeInvalid => '緯度格式錯誤';

  @override
  String get longitudeInvalid => '經度格式錯誤';

  @override
  String get bindSuccess => '裝置綁定成功！';

  @override
  String get bindFailed => '綁定失敗';

  @override
  String get unbindSuccess => '裝置取消綁定成功！';

  @override
  String get unbindFailed => '取消綁定失敗';

  @override
  String get deviceListFetchFailed => '取得裝置列表失敗';

  @override
  String get hintUnbind => '提示：滑動設備或按下取消綁定按鈕即可解除';

  @override
  String get needHelp => '需要幫助嗎？';

  @override
  String get contactUsText => '您可以透過以下方式聯絡我們：';

  @override
  String get customerEmail => '客服信箱';

  @override
  String get customerPhone => '客服電話';

  @override
  String get onlineChat => '線上客服';

  @override
  String get chatNow => '立即與客服人員聊天';

  @override
  String get taipowerIssueTitle => '對台電斷電有疑慮嗎?';

  @override
  String get taipowerIssueText => '可以撥打下方電話進行確認確認：';

  @override
  String get taipowerPhone => '台電公司電話';

  @override
  String get tutorBindTitle => '綁定 + 取消綁定';

  @override
  String get tutorBindDesc => '教學步驟說明';

  @override
  String get tutorBindContent => '### 綁定步驟\n1. 點擊綁定按鈕\n2. 選擇設備\n3. 確認綁定\n\n### 取消綁定步驟\n1. 選擇已綁定設備\n2. 點擊取消綁定';

  @override
  String get tutorListTitle => '查看列表細項數據';

  @override
  String get tutorListDesc => '如何查看列表詳細資訊';

  @override
  String get tutorListContent => '### 查看列表細項數據\n- 進入設備列表頁\n- 點擊每個設備可查看詳細數據\n- 包含電壓、電流、SOC 等';

  @override
  String get tutorDeviceTitle => '查看設備數據 + PCS數據查看 + 單顯示多顯示查看';

  @override
  String get tutorDeviceDesc => '設備與 PCS 數據查看方法';

  @override
  String get tutorDeviceContent => '### 查看設備數據\n- 在設備詳情頁查看即時數據\n- 包含電壓、電流、功率、溫度等\n\n### PCS數據查看\n- 可查看 PCS 相關資訊\n- 包含輸入/輸出狀態及功率\n\n### 單顯示 / 多顯示\n- 單顯示模式：只看一個設備\n- 多顯示模式：同時比對多個設備';

  @override
  String get tutorHistoryTitle => '查看歷史數據';

  @override
  String get tutorHistoryDesc => '如何查看歷史數據';

  @override
  String get tutorHistoryContent => '### 查看歷史數據\n1. 進入歷史數據頁面\n2. 查看設備的歷史電壓、電流、功率等數據曲線';

  @override
  String get dayIncome => '日收益';

  @override
  String get monthIncome => '月收益';

  @override
  String get dayCharge => '日充';

  @override
  String get dayDischarge => '日放';

  @override
  String get timeToFull => '距離充滿';

  @override
  String get timeToEmpty => '距離沒電';

  @override
  String get serialNumber => '裝置序號';

  @override
  String get realTimeData => '即時數據';

  @override
  String get historyData => '歷史數據';

  @override
  String get deviceRevenue => '設備收益';

  @override
  String get basicSetting => '基本設定';

  @override
  String get logSetting => '日誌設定';

  @override
  String get pcsSetting => 'PCS設置';

  @override
  String get backToHome => '返回首頁';

  @override
  String get deviceOffline => '設備離線';

  @override
  String get deviceAlert => '設備預警';

  @override
  String get noAlarm => '目前無警報';

  @override
  String get internalTemperature => '機內溫度';

  @override
  String get powerOutageList => '停電列表';

  @override
  String get running => '運行中';

  @override
  String get standby => '待機';

  @override
  String get status => '狀態';

  @override
  String get alarmDetails => '警報詳細';

  @override
  String get deviceStatus => '狀態';

  @override
  String get voltage => '電壓';

  @override
  String get current => '電流';

  @override
  String get power => '功率';

  @override
  String get soc => 'SOC';

  @override
  String get solar1 => 'Solar1';

  @override
  String get solar2 => 'Solar2';

  @override
  String get mode => '模式';

  @override
  String get unknownMode => '未知模式';

  @override
  String get noData => '無資料';

  @override
  String get backupMode => '備援模式';

  @override
  String get normalMode => '一般模式';

  @override
  String get ecoMode => '經濟模式';

  @override
  String get socChart => 'SOC 折線圖';

  @override
  String get voltageChart => '過去24小時電壓顯示(單位：V)';

  @override
  String get currentChart => '過去24小時電流顯示(單位：A)';

  @override
  String get powerChartinhirack => '過去24小時功率顯示(單位：W)';

  @override
  String get powerChart => '充/放電功率 (前七天)';

  @override
  String get revenueChart => '電費收益 (前七天)';

  @override
  String get totalRevenue => '總收益';

  @override
  String get currency => '元';

  @override
  String get noHistoryData => '沒有歷史資料';

  @override
  String get monthRevenue => '本月收益';

  @override
  String get dailyRevenue => '日收益';

  @override
  String get todayRevenue => '本日收益';

  @override
  String get dailyTarget => '日目標';

  @override
  String get dayShort => 'D';

  @override
  String get day => '日';

  @override
  String get dailyTargetLabel => '今日目標';

  @override
  String dailyAccum(Object value) {
    return '今日累積 $value 元';
  }

  @override
  String get monthlyTargetLabel => '本月目標';

  @override
  String monthlyAccum(Object value) {
    return '本月累積 $value 元';
  }

  @override
  String get economyMode => '經濟模式';

  @override
  String get reminder => '提醒';

  @override
  String switchModeConfirm(Object mode) {
    return '確定要切換到 $mode？';
  }

  @override
  String get success => '成功';

  @override
  String get failed => '失敗';

  @override
  String get sendFail => '指令發送失敗';

  @override
  String get exception => '發生例外狀況';

  @override
  String get ok => '確定';

  @override
  String get chargeTime => '充電時間';

  @override
  String get submitTime => '送出';

  @override
  String get timeInvalid => '時間範圍無效';

  @override
  String timeSetSuccess(Object end, Object start) {
    return '時間設定成功：$start ~ $end';
  }

  @override
  String get timeSetFail => '時間設定失敗';

  @override
  String modeChanged(Object mode) {
    return '已更改 PCS 模式為 $mode';
  }

  @override
  String get enableRealtime => '啟用即時更新';

  @override
  String get updateFrequency => '更新頻率';

  @override
  String seconds(Object count) {
    return '$count 秒';
  }

  @override
  String get save => '儲存';

  @override
  String get deviceLog => '設備日誌';

  @override
  String get unknown => '未知';

  @override
  String get model => '型號';

  @override
  String get unknownModel => '未知型號';

  @override
  String get noLogs => '目前沒有日誌資料';

  @override
  String get lastEntry => '已經是最後一筆了';

  @override
  String get enterPassword => '請輸入密碼';

  @override
  String get passwordError => '密碼錯誤';

  @override
  String get scanBarcode => '掃描條碼';

  @override
  String get deleteAccount => '刪除帳號';

  @override
  String get confirmDeleteAccount => '確定要刪除帳號嗎？';

  @override
  String get delete => '刪除';

  @override
  String get accountDeletedSuccessfully => '帳號已刪除';

  @override
  String get deleteFailed => '刪除失敗';
}
