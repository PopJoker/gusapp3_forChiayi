// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'zh';

  static String m0(url) => "無法開啟官網: ${url}";

  static String m1(deviceName) => "設備 ${deviceName} 將被取消綁定";

  static String m2(value) => "今日累積 ${value} 元";

  static String m3(mode) => "已更改 PCS 模式為 ${mode}";

  static String m4(value) => "本月累積 ${value} 元";

  static String m5(error) => "掃描失敗: ${error}";

  static String m6(count) => "${count} 秒";

  static String m7(mode) => "確定要切換到 ${mode}？";

  static String m8(start, end) => "時間設定成功：${start} ~ ${end}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "aboutUs": MessageLookupByLibrary.simpleMessage("關於我們"),
    "account": MessageLookupByLibrary.simpleMessage("帳號"),
    "accountDeleted": MessageLookupByLibrary.simpleMessage("帳號已刪除"),
    "addDevice": MessageLookupByLibrary.simpleMessage("新增設備"),
    "addEnergyDevice": MessageLookupByLibrary.simpleMessage("新增儲能設備"),
    "addOrRemoveBinding": MessageLookupByLibrary.simpleMessage("新增與取消綁定"),
    "addedDevices": MessageLookupByLibrary.simpleMessage("已接入儲能設備"),
    "agreeTo": MessageLookupByLibrary.simpleMessage("我已閱讀並同意 "),
    "alarmDetails": MessageLookupByLibrary.simpleMessage("警報詳細"),
    "and": MessageLookupByLibrary.simpleMessage("與"),
    "appSettings": MessageLookupByLibrary.simpleMessage("APP設置"),
    "backToHome": MessageLookupByLibrary.simpleMessage("返回首頁"),
    "backupMode": MessageLookupByLibrary.simpleMessage("備援模式"),
    "barcode": MessageLookupByLibrary.simpleMessage("Barcode"),
    "barcodeExists": MessageLookupByLibrary.simpleMessage("此 Barcode 已存在！"),
    "basicSetting": MessageLookupByLibrary.simpleMessage("基本設定"),
    "bindFailed": MessageLookupByLibrary.simpleMessage("綁定失敗"),
    "bindSuccess": MessageLookupByLibrary.simpleMessage("裝置綁定成功！"),
    "cancel": MessageLookupByLibrary.simpleMessage("取消"),
    "cannotOpenUrl": m0,
    "chargeTime": MessageLookupByLibrary.simpleMessage("充電時間"),
    "chatNow": MessageLookupByLibrary.simpleMessage("立即與客服人員聊天"),
    "confirm": MessageLookupByLibrary.simpleMessage("確認"),
    "confirmDeleteAccount": MessageLookupByLibrary.simpleMessage("確認刪除帳號"),
    "confirmLogout": MessageLookupByLibrary.simpleMessage("確認登出？"),
    "confirmPassword": MessageLookupByLibrary.simpleMessage("確認密碼"),
    "confirmUnbindContent": m1,
    "confirmUnbindTitle": MessageLookupByLibrary.simpleMessage("確認取消綁定？"),
    "contactUsText": MessageLookupByLibrary.simpleMessage("您可以透過以下方式聯絡我們："),
    "currency": MessageLookupByLibrary.simpleMessage("元"),
    "customerEmail": MessageLookupByLibrary.simpleMessage("客服信箱"),
    "customerPhone": MessageLookupByLibrary.simpleMessage("客服電話"),
    "customerService": MessageLookupByLibrary.simpleMessage("客服"),
    "dailyAccum": m2,
    "dailyRevenue": MessageLookupByLibrary.simpleMessage("日收益"),
    "dailyTarget": MessageLookupByLibrary.simpleMessage("日目標"),
    "dailyTargetLabel": MessageLookupByLibrary.simpleMessage("今日目標"),
    "darkMode": MessageLookupByLibrary.simpleMessage("深色模式"),
    "day": MessageLookupByLibrary.simpleMessage("日"),
    "dayCharge": MessageLookupByLibrary.simpleMessage("日充"),
    "dayDischarge": MessageLookupByLibrary.simpleMessage("日放"),
    "dayIncome": MessageLookupByLibrary.simpleMessage("日收益"),
    "dayShort": MessageLookupByLibrary.simpleMessage("D"),
    "deleteAccount": MessageLookupByLibrary.simpleMessage("刪除帳號"),
    "deleteFailed": MessageLookupByLibrary.simpleMessage("刪除帳號失敗"),
    "deviceAlert": MessageLookupByLibrary.simpleMessage("設備預警"),
    "deviceArea": MessageLookupByLibrary.simpleMessage("區域"),
    "deviceList": MessageLookupByLibrary.simpleMessage("儲能設備列表"),
    "deviceListFetchFailed": MessageLookupByLibrary.simpleMessage("取得裝置列表失敗"),
    "deviceLog": MessageLookupByLibrary.simpleMessage("設備日誌"),
    "deviceName": MessageLookupByLibrary.simpleMessage("設備名稱"),
    "deviceOffline": MessageLookupByLibrary.simpleMessage("設備離線"),
    "deviceRevenue": MessageLookupByLibrary.simpleMessage("設備收益"),
    "deviceStatus": MessageLookupByLibrary.simpleMessage("狀態"),
    "ecoMode": MessageLookupByLibrary.simpleMessage("經濟模式"),
    "economyMode": MessageLookupByLibrary.simpleMessage("經濟模式"),
    "enableRealtime": MessageLookupByLibrary.simpleMessage("啟用即時更新"),
    "energySystem": MessageLookupByLibrary.simpleMessage("儲能系統"),
    "enterPassword": MessageLookupByLibrary.simpleMessage("請輸入密碼"),
    "exception": MessageLookupByLibrary.simpleMessage("發生例外狀況"),
    "failed": MessageLookupByLibrary.simpleMessage("失敗"),
    "hintUnbind": MessageLookupByLibrary.simpleMessage("提示：滑動設備或按下取消綁定按鈕即可解除"),
    "historyData": MessageLookupByLibrary.simpleMessage("歷史數據"),
    "internalTemperature": MessageLookupByLibrary.simpleMessage("機內溫度"),
    "invalidEmail": MessageLookupByLibrary.simpleMessage("請輸入正確的 Email 格式"),
    "keepLoggedIn": MessageLookupByLibrary.simpleMessage("保持登入"),
    "language": MessageLookupByLibrary.simpleMessage("語言切換"),
    "lastEntry": MessageLookupByLibrary.simpleMessage("已經是最後一筆了"),
    "latitude": MessageLookupByLibrary.simpleMessage("緯度"),
    "latitudeInvalid": MessageLookupByLibrary.simpleMessage("緯度格式錯誤"),
    "locale": MessageLookupByLibrary.simpleMessage("zh"),
    "logSetting": MessageLookupByLibrary.simpleMessage("日誌設定"),
    "login": MessageLookupByLibrary.simpleMessage("登入"),
    "loginFailed": MessageLookupByLibrary.simpleMessage("登入失敗"),
    "loginSuccess": MessageLookupByLibrary.simpleMessage("登入成功！"),
    "logout": MessageLookupByLibrary.simpleMessage("登出"),
    "longitude": MessageLookupByLibrary.simpleMessage("經度"),
    "longitudeInvalid": MessageLookupByLibrary.simpleMessage("經度格式錯誤"),
    "menu": MessageLookupByLibrary.simpleMessage("選單"),
    "mode": MessageLookupByLibrary.simpleMessage("模式"),
    "modeChanged": m3,
    "model": MessageLookupByLibrary.simpleMessage("型號"),
    "monthIncome": MessageLookupByLibrary.simpleMessage("月收益"),
    "monthRevenue": MessageLookupByLibrary.simpleMessage("本月收益"),
    "monthlyAccum": m4,
    "monthlyTargetLabel": MessageLookupByLibrary.simpleMessage("本月目標"),
    "needHelp": MessageLookupByLibrary.simpleMessage("需要幫助嗎？"),
    "newAccount": MessageLookupByLibrary.simpleMessage("新帳號"),
    "newPassword": MessageLookupByLibrary.simpleMessage("新密碼"),
    "noAlarm": MessageLookupByLibrary.simpleMessage("目前無警報"),
    "noData": MessageLookupByLibrary.simpleMessage("無資料"),
    "noDevicesYet": MessageLookupByLibrary.simpleMessage("尚未新增儲能設備"),
    "noHistoryData": MessageLookupByLibrary.simpleMessage("沒有歷史資料"),
    "noLogs": MessageLookupByLibrary.simpleMessage("目前沒有日誌資料"),
    "normalMode": MessageLookupByLibrary.simpleMessage("一般模式"),
    "ok": MessageLookupByLibrary.simpleMessage("確定"),
    "onlineChat": MessageLookupByLibrary.simpleMessage("線上客服"),
    "password": MessageLookupByLibrary.simpleMessage("密碼"),
    "passwordCannotBeEmpty": MessageLookupByLibrary.simpleMessage("密碼不能為空"),
    "passwordError": MessageLookupByLibrary.simpleMessage("密碼錯誤"),
    "passwordNotMatch": MessageLookupByLibrary.simpleMessage("兩次輸入的密碼不一致"),
    "pcsSetting": MessageLookupByLibrary.simpleMessage("PCS設置"),
    "pleaseAgreeToTerms": MessageLookupByLibrary.simpleMessage(
      "請先同意使用協議與隱私權保護政策",
    ),
    "pleaseEnterAccountPassword": MessageLookupByLibrary.simpleMessage(
      "請輸入帳號與密碼",
    ),
    "pleaseFillAllFields": MessageLookupByLibrary.simpleMessage("請填寫所有欄位"),
    "power": MessageLookupByLibrary.simpleMessage("功率"),
    "powerChart": MessageLookupByLibrary.simpleMessage("充/放電功率 (前七天)"),
    "powerOutageList": MessageLookupByLibrary.simpleMessage("停電列表"),
    "privacyPolicy": MessageLookupByLibrary.simpleMessage("隱私權保護政策"),
    "realTimeData": MessageLookupByLibrary.simpleMessage("即時數據"),
    "register": MessageLookupByLibrary.simpleMessage("註冊"),
    "registerFailed": MessageLookupByLibrary.simpleMessage("註冊失敗"),
    "registerSuccessWaitAdmin": MessageLookupByLibrary.simpleMessage(
      "註冊成功，請等待管理員啟用",
    ),
    "reminder": MessageLookupByLibrary.simpleMessage("提醒"),
    "revenueChart": MessageLookupByLibrary.simpleMessage("電費收益 (前七天)"),
    "running": MessageLookupByLibrary.simpleMessage("運行中"),
    "save": MessageLookupByLibrary.simpleMessage("儲存"),
    "scanBarcode": MessageLookupByLibrary.simpleMessage("掃描條碼"),
    "scanFailed": m5,
    "seconds": m6,
    "sendFail": MessageLookupByLibrary.simpleMessage("指令發送失敗"),
    "serialNumber": MessageLookupByLibrary.simpleMessage("裝置序號"),
    "soc": MessageLookupByLibrary.simpleMessage("SOC"),
    "socChart": MessageLookupByLibrary.simpleMessage("SOC 折線圖"),
    "solar1": MessageLookupByLibrary.simpleMessage("Solar1"),
    "solar2": MessageLookupByLibrary.simpleMessage("Solar2"),
    "standby": MessageLookupByLibrary.simpleMessage("待機"),
    "status": MessageLookupByLibrary.simpleMessage("狀態"),
    "submitTime": MessageLookupByLibrary.simpleMessage("送出"),
    "success": MessageLookupByLibrary.simpleMessage("成功"),
    "switchModeConfirm": m7,
    "taipowerIssueText": MessageLookupByLibrary.simpleMessage(
      "可以撥打下方電話進行確認確認：",
    ),
    "taipowerIssueTitle": MessageLookupByLibrary.simpleMessage("對台電斷電有疑慮嗎?"),
    "taipowerPhone": MessageLookupByLibrary.simpleMessage("台電公司電話"),
    "termsOfService": MessageLookupByLibrary.simpleMessage("使用協議"),
    "timeInvalid": MessageLookupByLibrary.simpleMessage("時間範圍無效"),
    "timeSetFail": MessageLookupByLibrary.simpleMessage("時間設定失敗"),
    "timeSetSuccess": m8,
    "timeToEmpty": MessageLookupByLibrary.simpleMessage("距離沒電"),
    "timeToFull": MessageLookupByLibrary.simpleMessage("距離充滿"),
    "todayRevenue": MessageLookupByLibrary.simpleMessage("本日收益"),
    "totalRevenue": MessageLookupByLibrary.simpleMessage("總收益"),
    "tutorBindContent": MessageLookupByLibrary.simpleMessage(
      "### 綁定步驟\n1. 點擊綁定按鈕\n2. 選擇設備\n3. 確認綁定\n\n### 取消綁定步驟\n1. 選擇已綁定設備\n2. 點擊取消綁定",
    ),
    "tutorBindDesc": MessageLookupByLibrary.simpleMessage("教學步驟說明"),
    "tutorBindTitle": MessageLookupByLibrary.simpleMessage("綁定 + 取消綁定"),
    "tutorDeviceContent": MessageLookupByLibrary.simpleMessage(
      "### 查看設備數據\n- 在設備詳情頁查看即時數據\n- 包含電壓、電流、功率、溫度等\n\n### PCS數據查看\n- 可查看 PCS 相關資訊\n- 包含輸入/輸出狀態及功率\n\n### 單顯示 / 多顯示\n- 單顯示模式：只看一個設備\n- 多顯示模式：同時比對多個設備",
    ),
    "tutorDeviceDesc": MessageLookupByLibrary.simpleMessage("設備與 PCS 數據查看方法"),
    "tutorDeviceTitle": MessageLookupByLibrary.simpleMessage(
      "查看設備數據 + PCS數據查看 + 單顯示多顯示查看",
    ),
    "tutorHistoryContent": MessageLookupByLibrary.simpleMessage(
      "### 查看歷史數據\n1. 進入歷史數據頁面\n2. 查看設備的歷史電壓、電流、功率等數據曲線",
    ),
    "tutorHistoryDesc": MessageLookupByLibrary.simpleMessage("如何查看歷史數據"),
    "tutorHistoryTitle": MessageLookupByLibrary.simpleMessage("查看歷史數據"),
    "tutorListContent": MessageLookupByLibrary.simpleMessage(
      "### 查看列表細項數據\n- 進入設備列表頁\n- 點擊每個設備可查看詳細數據\n- 包含電壓、電流、SOC 等",
    ),
    "tutorListDesc": MessageLookupByLibrary.simpleMessage("如何查看列表詳細資訊"),
    "tutorListTitle": MessageLookupByLibrary.simpleMessage("查看列表細項數據"),
    "tutorial": MessageLookupByLibrary.simpleMessage("教學"),
    "unbindFailed": MessageLookupByLibrary.simpleMessage("取消綁定失敗"),
    "unbindSuccess": MessageLookupByLibrary.simpleMessage("裝置取消綁定成功！"),
    "unknown": MessageLookupByLibrary.simpleMessage("未知"),
    "unknownMode": MessageLookupByLibrary.simpleMessage("未知模式"),
    "unknownModel": MessageLookupByLibrary.simpleMessage("未知型號"),
    "updateFrequency": MessageLookupByLibrary.simpleMessage("更新頻率"),
    "voltage": MessageLookupByLibrary.simpleMessage("電壓"),
  };
}
