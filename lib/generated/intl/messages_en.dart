// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(url) => "Cannot open URL: ${url}";

  static String m1(deviceName) => "Device ${deviceName} will be unbound";

  static String m2(value) => "Today: ${value} NT\\\$";

  static String m3(mode) => "PCS mode changed to ${mode}";

  static String m4(value) => "Month: ${value} NT\\\$";

  static String m5(error) => "Scan failed: ${error}";

  static String m6(count) => "${count} seconds";

  static String m7(mode) => "Are you sure you want to switch to ${mode}?";

  static String m8(start, end) => "Time set successfully: ${start} ~ ${end}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "aboutUs": MessageLookupByLibrary.simpleMessage("About Us"),
    "account": MessageLookupByLibrary.simpleMessage("Account"),
    "accountDeleted": MessageLookupByLibrary.simpleMessage("Account deleted"),
    "addDevice": MessageLookupByLibrary.simpleMessage("Add Device"),
    "addEnergyDevice": MessageLookupByLibrary.simpleMessage(
      "Add Energy Device",
    ),
    "addOrRemoveBinding": MessageLookupByLibrary.simpleMessage(
      "Add or Remove Binding",
    ),
    "addedDevices": MessageLookupByLibrary.simpleMessage("Added Devices"),
    "agreeTo": MessageLookupByLibrary.simpleMessage(
      "I have read and agree to ",
    ),
    "alarmDetails": MessageLookupByLibrary.simpleMessage("Alarm Details"),
    "and": MessageLookupByLibrary.simpleMessage("and"),
    "appSettings": MessageLookupByLibrary.simpleMessage("App Settings"),
    "backToHome": MessageLookupByLibrary.simpleMessage("Back to Home"),
    "backupMode": MessageLookupByLibrary.simpleMessage("Backup Mode"),
    "barcode": MessageLookupByLibrary.simpleMessage("Barcode"),
    "barcodeExists": MessageLookupByLibrary.simpleMessage(
      "This barcode already exists!",
    ),
    "basicSetting": MessageLookupByLibrary.simpleMessage("Basic Setting"),
    "bindFailed": MessageLookupByLibrary.simpleMessage("Binding failed"),
    "bindSuccess": MessageLookupByLibrary.simpleMessage(
      "Device bound successfully!",
    ),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "cannotOpenUrl": m0,
    "chargeTime": MessageLookupByLibrary.simpleMessage("Charge Time"),
    "chatNow": MessageLookupByLibrary.simpleMessage(
      "Chat with our support staff now",
    ),
    "confirm": MessageLookupByLibrary.simpleMessage("Confirm"),
    "confirmDeleteAccount": MessageLookupByLibrary.simpleMessage(
      "Confirm Account Deletion",
    ),
    "confirmLogout": MessageLookupByLibrary.simpleMessage("Confirm logout?"),
    "confirmPassword": MessageLookupByLibrary.simpleMessage("Confirm Password"),
    "confirmUnbindContent": m1,
    "confirmUnbindTitle": MessageLookupByLibrary.simpleMessage(
      "Confirm Unbind?",
    ),
    "contactUsText": MessageLookupByLibrary.simpleMessage(
      "You can contact us in the following ways:",
    ),
    "currency": MessageLookupByLibrary.simpleMessage("NT\\\$"),
    "customerEmail": MessageLookupByLibrary.simpleMessage("Customer Email"),
    "customerPhone": MessageLookupByLibrary.simpleMessage("Customer Phone"),
    "customerService": MessageLookupByLibrary.simpleMessage("Customer Service"),
    "dailyAccum": m2,
    "dailyRevenue": MessageLookupByLibrary.simpleMessage("Daily Revenue"),
    "dailyTarget": MessageLookupByLibrary.simpleMessage("Daily Target"),
    "dailyTargetLabel": MessageLookupByLibrary.simpleMessage("Daily Target"),
    "darkMode": MessageLookupByLibrary.simpleMessage("Dark Mode"),
    "day": MessageLookupByLibrary.simpleMessage("Day"),
    "dayCharge": MessageLookupByLibrary.simpleMessage("D-Chg"),
    "dayDischarge": MessageLookupByLibrary.simpleMessage("D-Dsg"),
    "dayIncome": MessageLookupByLibrary.simpleMessage("D-In"),
    "dayShort": MessageLookupByLibrary.simpleMessage("D"),
    "deleteAccount": MessageLookupByLibrary.simpleMessage("Delete Account"),
    "deleteFailed": MessageLookupByLibrary.simpleMessage(
      "Failed to delete account",
    ),
    "deviceAlert": MessageLookupByLibrary.simpleMessage("Device Alert"),
    "deviceArea": MessageLookupByLibrary.simpleMessage("Area"),
    "deviceList": MessageLookupByLibrary.simpleMessage("Device List"),
    "deviceListFetchFailed": MessageLookupByLibrary.simpleMessage(
      "Failed to fetch device list",
    ),
    "deviceLog": MessageLookupByLibrary.simpleMessage("Device Log"),
    "deviceName": MessageLookupByLibrary.simpleMessage("Device Name"),
    "deviceOffline": MessageLookupByLibrary.simpleMessage("Device Offline"),
    "deviceRevenue": MessageLookupByLibrary.simpleMessage("Device Revenue"),
    "deviceStatus": MessageLookupByLibrary.simpleMessage("Device Status"),
    "ecoMode": MessageLookupByLibrary.simpleMessage("Eco Mode"),
    "economyMode": MessageLookupByLibrary.simpleMessage("Economy Mode"),
    "enableRealtime": MessageLookupByLibrary.simpleMessage("Enable Realtime"),
    "energySystem": MessageLookupByLibrary.simpleMessage("Energy System"),
    "enterPassword": MessageLookupByLibrary.simpleMessage(" Enter Password"),
    "exception": MessageLookupByLibrary.simpleMessage("Exception occurred"),
    "failed": MessageLookupByLibrary.simpleMessage("Failed"),
    "hintUnbind": MessageLookupByLibrary.simpleMessage(
      "Hint: Swipe device or press unbind button to remove",
    ),
    "historyData": MessageLookupByLibrary.simpleMessage("History Data"),
    "internalTemperature": MessageLookupByLibrary.simpleMessage(
      "Internal Temp",
    ),
    "invalidEmail": MessageLookupByLibrary.simpleMessage(
      "Invalid email format",
    ),
    "keepLoggedIn": MessageLookupByLibrary.simpleMessage("Keep me logged in"),
    "language": MessageLookupByLibrary.simpleMessage("Language"),
    "lastEntry": MessageLookupByLibrary.simpleMessage("This is the last entry"),
    "latitude": MessageLookupByLibrary.simpleMessage("Latitude"),
    "latitudeInvalid": MessageLookupByLibrary.simpleMessage(
      "Latitude format error",
    ),
    "locale": MessageLookupByLibrary.simpleMessage("en"),
    "logSetting": MessageLookupByLibrary.simpleMessage("Log Setting"),
    "login": MessageLookupByLibrary.simpleMessage("Login"),
    "loginFailed": MessageLookupByLibrary.simpleMessage("Login failed"),
    "loginSuccess": MessageLookupByLibrary.simpleMessage("Login successful!"),
    "logout": MessageLookupByLibrary.simpleMessage("Logout"),
    "longitude": MessageLookupByLibrary.simpleMessage("Longitude"),
    "longitudeInvalid": MessageLookupByLibrary.simpleMessage(
      "Longitude format error",
    ),
    "menu": MessageLookupByLibrary.simpleMessage("Menu"),
    "mode": MessageLookupByLibrary.simpleMessage("Mode"),
    "modeChanged": m3,
    "model": MessageLookupByLibrary.simpleMessage("Model"),
    "monthIncome": MessageLookupByLibrary.simpleMessage("M-In"),
    "monthRevenue": MessageLookupByLibrary.simpleMessage("Monthly Revenue"),
    "monthlyAccum": m4,
    "monthlyTargetLabel": MessageLookupByLibrary.simpleMessage(
      "Monthly Target",
    ),
    "needHelp": MessageLookupByLibrary.simpleMessage("Need help?"),
    "newAccount": MessageLookupByLibrary.simpleMessage("New Account"),
    "newPassword": MessageLookupByLibrary.simpleMessage("New Password"),
    "noAlarm": MessageLookupByLibrary.simpleMessage("No Alarm"),
    "noData": MessageLookupByLibrary.simpleMessage("No Data"),
    "noDevicesYet": MessageLookupByLibrary.simpleMessage(
      "No devices added yet",
    ),
    "noHistoryData": MessageLookupByLibrary.simpleMessage("No history data"),
    "noLogs": MessageLookupByLibrary.simpleMessage("No log data available"),
    "normalMode": MessageLookupByLibrary.simpleMessage("Normal Mode"),
    "ok": MessageLookupByLibrary.simpleMessage("OK"),
    "onlineChat": MessageLookupByLibrary.simpleMessage("Online Chat"),
    "password": MessageLookupByLibrary.simpleMessage("Password"),
    "passwordCannotBeEmpty": MessageLookupByLibrary.simpleMessage(
      "Password cannot be empty",
    ),
    "passwordError": MessageLookupByLibrary.simpleMessage("Password Error"),
    "passwordNotMatch": MessageLookupByLibrary.simpleMessage(
      "Passwords do not match",
    ),
    "pcsSetting": MessageLookupByLibrary.simpleMessage("PCS Setting"),
    "pleaseAgreeToTerms": MessageLookupByLibrary.simpleMessage(
      "Please agree to the terms and privacy policy",
    ),
    "pleaseEnterAccountPassword": MessageLookupByLibrary.simpleMessage(
      "Please enter account and password",
    ),
    "pleaseFillAllFields": MessageLookupByLibrary.simpleMessage(
      "Please fill in all fields",
    ),
    "power": MessageLookupByLibrary.simpleMessage("Power"),
    "powerChart": MessageLookupByLibrary.simpleMessage(
      "Charge/Discharge Power",
    ),
    "powerOutageList": MessageLookupByLibrary.simpleMessage(
      "Power Outage List",
    ),
    "privacyPolicy": MessageLookupByLibrary.simpleMessage("Privacy Policy"),
    "realTimeData": MessageLookupByLibrary.simpleMessage("Real-Time Data"),
    "register": MessageLookupByLibrary.simpleMessage("Register"),
    "registerFailed": MessageLookupByLibrary.simpleMessage(
      "Registration failed",
    ),
    "registerSuccessWaitAdmin": MessageLookupByLibrary.simpleMessage(
      "Registration successful, please wait for admin activation",
    ),
    "reminder": MessageLookupByLibrary.simpleMessage("Reminder"),
    "revenueChart": MessageLookupByLibrary.simpleMessage("Revenue"),
    "running": MessageLookupByLibrary.simpleMessage("Running"),
    "save": MessageLookupByLibrary.simpleMessage("Save"),
    "scanBarcode": MessageLookupByLibrary.simpleMessage("Scan Barcode"),
    "scanFailed": m5,
    "seconds": m6,
    "sendFail": MessageLookupByLibrary.simpleMessage("Failed to send command"),
    "serialNumber": MessageLookupByLibrary.simpleMessage("Serial Number"),
    "soc": MessageLookupByLibrary.simpleMessage("SOC"),
    "socChart": MessageLookupByLibrary.simpleMessage("SOC Line Chart"),
    "solar1": MessageLookupByLibrary.simpleMessage("Solar 1"),
    "solar2": MessageLookupByLibrary.simpleMessage("Solar 2"),
    "standby": MessageLookupByLibrary.simpleMessage("Standby"),
    "status": MessageLookupByLibrary.simpleMessage("Status"),
    "submitTime": MessageLookupByLibrary.simpleMessage("Submit"),
    "success": MessageLookupByLibrary.simpleMessage("Success"),
    "switchModeConfirm": m7,
    "taipowerIssueText": MessageLookupByLibrary.simpleMessage(
      "You can call the following number to check:",
    ),
    "taipowerIssueTitle": MessageLookupByLibrary.simpleMessage(
      "Concerned about Taipower power outage?",
    ),
    "taipowerPhone": MessageLookupByLibrary.simpleMessage("Taipower Phone"),
    "termsOfService": MessageLookupByLibrary.simpleMessage("Terms of Service"),
    "timeInvalid": MessageLookupByLibrary.simpleMessage("Invalid time range"),
    "timeSetFail": MessageLookupByLibrary.simpleMessage("Failed to set time"),
    "timeSetSuccess": m8,
    "timeToEmpty": MessageLookupByLibrary.simpleMessage("Time to Empty"),
    "timeToFull": MessageLookupByLibrary.simpleMessage("Time to Full"),
    "todayRevenue": MessageLookupByLibrary.simpleMessage("Today\'s Revenue"),
    "totalRevenue": MessageLookupByLibrary.simpleMessage("Total Revenue"),
    "tutorBindContent": MessageLookupByLibrary.simpleMessage(
      "### Binding Steps\n1. Click the Bind button\n2. Select device\n3. Confirm binding\n\n### Unbinding Steps\n1. Select bound device\n2. Click Unbind",
    ),
    "tutorBindDesc": MessageLookupByLibrary.simpleMessage("Step-by-step guide"),
    "tutorBindTitle": MessageLookupByLibrary.simpleMessage("Bind + Unbind"),
    "tutorDeviceContent": MessageLookupByLibrary.simpleMessage(
      "### Device Data\n- View real-time data on device detail page\n- Includes voltage, current, power, temperature, etc.\n\n### PCS Data\n- View PCS related info\n- Includes input/output status and power\n\n### Single / Multiple View\n- Single view: only one device\n- Multiple view: compare multiple devices at the same time",
    ),
    "tutorDeviceDesc": MessageLookupByLibrary.simpleMessage(
      "Device and PCS data viewing method",
    ),
    "tutorDeviceTitle": MessageLookupByLibrary.simpleMessage(
      "View Device Data + PCS Data + Single/Multiple View",
    ),
    "tutorHistoryContent": MessageLookupByLibrary.simpleMessage(
      "### History Data\n1. Enter history page\n2. View historical voltage, current, power charts for devices",
    ),
    "tutorHistoryDesc": MessageLookupByLibrary.simpleMessage(
      "How to view historical data",
    ),
    "tutorHistoryTitle": MessageLookupByLibrary.simpleMessage(
      "View History Data",
    ),
    "tutorListContent": MessageLookupByLibrary.simpleMessage(
      "### List Details\n- Enter the device list page\n- Click on each device to view details\n- Includes voltage, current, SOC, etc.",
    ),
    "tutorListDesc": MessageLookupByLibrary.simpleMessage(
      "How to view detailed info",
    ),
    "tutorListTitle": MessageLookupByLibrary.simpleMessage("View List Details"),
    "tutorial": MessageLookupByLibrary.simpleMessage("Tutorial"),
    "unbindFailed": MessageLookupByLibrary.simpleMessage("Unbinding failed"),
    "unbindSuccess": MessageLookupByLibrary.simpleMessage(
      "Device unbound successfully!",
    ),
    "unknown": MessageLookupByLibrary.simpleMessage("Unknown"),
    "unknownMode": MessageLookupByLibrary.simpleMessage("Unknown Mode"),
    "unknownModel": MessageLookupByLibrary.simpleMessage("Unknown Model"),
    "updateFrequency": MessageLookupByLibrary.simpleMessage("Update Frequency"),
    "voltage": MessageLookupByLibrary.simpleMessage("Voltage"),
  };
}
