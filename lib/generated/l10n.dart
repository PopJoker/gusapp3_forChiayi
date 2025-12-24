// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `en`
  String get locale {
    return Intl.message('en', name: 'locale', desc: '', args: []);
  }

  /// `Account`
  String get account {
    return Intl.message('Account', name: 'account', desc: '', args: []);
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Keep me logged in`
  String get keepLoggedIn {
    return Intl.message(
      'Keep me logged in',
      name: 'keepLoggedIn',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `New Account`
  String get newAccount {
    return Intl.message('New Account', name: 'newAccount', desc: '', args: []);
  }

  /// `New Password`
  String get newPassword {
    return Intl.message(
      'New Password',
      name: 'newPassword',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `I have read and agree to `
  String get agreeTo {
    return Intl.message(
      'I have read and agree to ',
      name: 'agreeTo',
      desc: '',
      args: [],
    );
  }

  /// `Terms of Service`
  String get termsOfService {
    return Intl.message(
      'Terms of Service',
      name: 'termsOfService',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get privacyPolicy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `and`
  String get and {
    return Intl.message('and', name: 'and', desc: '', args: []);
  }

  /// `Register`
  String get register {
    return Intl.message('Register', name: 'register', desc: '', args: []);
  }

  /// `Please enter account and password`
  String get pleaseEnterAccountPassword {
    return Intl.message(
      'Please enter account and password',
      name: 'pleaseEnterAccountPassword',
      desc: '',
      args: [],
    );
  }

  /// `Login successful!`
  String get loginSuccess {
    return Intl.message(
      'Login successful!',
      name: 'loginSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Login failed`
  String get loginFailed {
    return Intl.message(
      'Login failed',
      name: 'loginFailed',
      desc: '',
      args: [],
    );
  }

  /// `Please fill in all fields`
  String get pleaseFillAllFields {
    return Intl.message(
      'Please fill in all fields',
      name: 'pleaseFillAllFields',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email format`
  String get invalidEmail {
    return Intl.message(
      'Invalid email format',
      name: 'invalidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get passwordNotMatch {
    return Intl.message(
      'Passwords do not match',
      name: 'passwordNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `Registration successful, please wait for admin activation`
  String get registerSuccessWaitAdmin {
    return Intl.message(
      'Registration successful, please wait for admin activation',
      name: 'registerSuccessWaitAdmin',
      desc: '',
      args: [],
    );
  }

  /// `Registration failed`
  String get registerFailed {
    return Intl.message(
      'Registration failed',
      name: 'registerFailed',
      desc: '',
      args: [],
    );
  }

  /// `Cannot open URL: {url}`
  String cannotOpenUrl(Object url) {
    return Intl.message(
      'Cannot open URL: $url',
      name: 'cannotOpenUrl',
      desc: '',
      args: [url],
    );
  }

  /// `Please agree to the terms and privacy policy`
  String get pleaseAgreeToTerms {
    return Intl.message(
      'Please agree to the terms and privacy policy',
      name: 'pleaseAgreeToTerms',
      desc: '',
      args: [],
    );
  }

  /// `Delete Account`
  String get deleteAccount {
    return Intl.message(
      'Delete Account',
      name: 'deleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Account Deletion`
  String get confirmDeleteAccount {
    return Intl.message(
      'Confirm Account Deletion',
      name: 'confirmDeleteAccount',
      desc: '',
      args: [],
    );
  }

  /// ` Enter Password`
  String get enterPassword {
    return Intl.message(
      ' Enter Password',
      name: 'enterPassword',
      desc: '',
      args: [],
    );
  }

  /// `Password cannot be empty`
  String get passwordCannotBeEmpty {
    return Intl.message(
      'Password cannot be empty',
      name: 'passwordCannotBeEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Account deleted`
  String get accountDeleted {
    return Intl.message(
      'Account deleted',
      name: 'accountDeleted',
      desc: '',
      args: [],
    );
  }

  /// `Failed to delete account`
  String get deleteFailed {
    return Intl.message(
      'Failed to delete account',
      name: 'deleteFailed',
      desc: '',
      args: [],
    );
  }

  /// `Energy System`
  String get energySystem {
    return Intl.message(
      'Energy System',
      name: 'energySystem',
      desc: '',
      args: [],
    );
  }

  /// `Menu`
  String get menu {
    return Intl.message('Menu', name: 'menu', desc: '', args: []);
  }

  /// `Device List`
  String get deviceList {
    return Intl.message('Device List', name: 'deviceList', desc: '', args: []);
  }

  /// `Add or Remove Binding`
  String get addOrRemoveBinding {
    return Intl.message(
      'Add or Remove Binding',
      name: 'addOrRemoveBinding',
      desc: '',
      args: [],
    );
  }

  /// `App Settings`
  String get appSettings {
    return Intl.message(
      'App Settings',
      name: 'appSettings',
      desc: '',
      args: [],
    );
  }

  /// `Customer Service`
  String get customerService {
    return Intl.message(
      'Customer Service',
      name: 'customerService',
      desc: '',
      args: [],
    );
  }

  /// `Tutorial`
  String get tutorial {
    return Intl.message('Tutorial', name: 'tutorial', desc: '', args: []);
  }

  /// `About Us`
  String get aboutUs {
    return Intl.message('About Us', name: 'aboutUs', desc: '', args: []);
  }

  /// `Logout`
  String get logout {
    return Intl.message('Logout', name: 'logout', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Confirm logout?`
  String get confirmLogout {
    return Intl.message(
      'Confirm logout?',
      name: 'confirmLogout',
      desc: '',
      args: [],
    );
  }

  /// `Dark Mode`
  String get darkMode {
    return Intl.message('Dark Mode', name: 'darkMode', desc: '', args: []);
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `Add Energy Device`
  String get addEnergyDevice {
    return Intl.message(
      'Add Energy Device',
      name: 'addEnergyDevice',
      desc: '',
      args: [],
    );
  }

  /// `Device Name`
  String get deviceName {
    return Intl.message('Device Name', name: 'deviceName', desc: '', args: []);
  }

  /// `Barcode`
  String get barcode {
    return Intl.message('Barcode', name: 'barcode', desc: '', args: []);
  }

  /// `Latitude`
  String get latitude {
    return Intl.message('Latitude', name: 'latitude', desc: '', args: []);
  }

  /// `Longitude`
  String get longitude {
    return Intl.message('Longitude', name: 'longitude', desc: '', args: []);
  }

  /// `Area`
  String get deviceArea {
    return Intl.message('Area', name: 'deviceArea', desc: '', args: []);
  }

  /// `Add Device`
  String get addDevice {
    return Intl.message('Add Device', name: 'addDevice', desc: '', args: []);
  }

  /// `Added Devices`
  String get addedDevices {
    return Intl.message(
      'Added Devices',
      name: 'addedDevices',
      desc: '',
      args: [],
    );
  }

  /// `No devices added yet`
  String get noDevicesYet {
    return Intl.message(
      'No devices added yet',
      name: 'noDevicesYet',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Unbind?`
  String get confirmUnbindTitle {
    return Intl.message(
      'Confirm Unbind?',
      name: 'confirmUnbindTitle',
      desc: '',
      args: [],
    );
  }

  /// `Device {deviceName} will be unbound`
  String confirmUnbindContent(Object deviceName) {
    return Intl.message(
      'Device $deviceName will be unbound',
      name: 'confirmUnbindContent',
      desc: '',
      args: [deviceName],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message('Confirm', name: 'confirm', desc: '', args: []);
  }

  /// `Scan failed: {error}`
  String scanFailed(Object error) {
    return Intl.message(
      'Scan failed: $error',
      name: 'scanFailed',
      desc: '',
      args: [error],
    );
  }

  /// `This barcode already exists!`
  String get barcodeExists {
    return Intl.message(
      'This barcode already exists!',
      name: 'barcodeExists',
      desc: '',
      args: [],
    );
  }

  /// `Latitude format error`
  String get latitudeInvalid {
    return Intl.message(
      'Latitude format error',
      name: 'latitudeInvalid',
      desc: '',
      args: [],
    );
  }

  /// `Longitude format error`
  String get longitudeInvalid {
    return Intl.message(
      'Longitude format error',
      name: 'longitudeInvalid',
      desc: '',
      args: [],
    );
  }

  /// `Device bound successfully!`
  String get bindSuccess {
    return Intl.message(
      'Device bound successfully!',
      name: 'bindSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Binding failed`
  String get bindFailed {
    return Intl.message(
      'Binding failed',
      name: 'bindFailed',
      desc: '',
      args: [],
    );
  }

  /// `Device unbound successfully!`
  String get unbindSuccess {
    return Intl.message(
      'Device unbound successfully!',
      name: 'unbindSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Unbinding failed`
  String get unbindFailed {
    return Intl.message(
      'Unbinding failed',
      name: 'unbindFailed',
      desc: '',
      args: [],
    );
  }

  /// `Failed to fetch device list`
  String get deviceListFetchFailed {
    return Intl.message(
      'Failed to fetch device list',
      name: 'deviceListFetchFailed',
      desc: '',
      args: [],
    );
  }

  /// `Hint: Swipe device or press unbind button to remove`
  String get hintUnbind {
    return Intl.message(
      'Hint: Swipe device or press unbind button to remove',
      name: 'hintUnbind',
      desc: '',
      args: [],
    );
  }

  /// `Need help?`
  String get needHelp {
    return Intl.message('Need help?', name: 'needHelp', desc: '', args: []);
  }

  /// `You can contact us in the following ways:`
  String get contactUsText {
    return Intl.message(
      'You can contact us in the following ways:',
      name: 'contactUsText',
      desc: '',
      args: [],
    );
  }

  /// `Customer Email`
  String get customerEmail {
    return Intl.message(
      'Customer Email',
      name: 'customerEmail',
      desc: '',
      args: [],
    );
  }

  /// `Customer Phone`
  String get customerPhone {
    return Intl.message(
      'Customer Phone',
      name: 'customerPhone',
      desc: '',
      args: [],
    );
  }

  /// `Online Chat`
  String get onlineChat {
    return Intl.message('Online Chat', name: 'onlineChat', desc: '', args: []);
  }

  /// `Chat with our support staff now`
  String get chatNow {
    return Intl.message(
      'Chat with our support staff now',
      name: 'chatNow',
      desc: '',
      args: [],
    );
  }

  /// `Concerned about Taipower power outage?`
  String get taipowerIssueTitle {
    return Intl.message(
      'Concerned about Taipower power outage?',
      name: 'taipowerIssueTitle',
      desc: '',
      args: [],
    );
  }

  /// `You can call the following number to check:`
  String get taipowerIssueText {
    return Intl.message(
      'You can call the following number to check:',
      name: 'taipowerIssueText',
      desc: '',
      args: [],
    );
  }

  /// `Taipower Phone`
  String get taipowerPhone {
    return Intl.message(
      'Taipower Phone',
      name: 'taipowerPhone',
      desc: '',
      args: [],
    );
  }

  /// `Bind + Unbind`
  String get tutorBindTitle {
    return Intl.message(
      'Bind + Unbind',
      name: 'tutorBindTitle',
      desc: '',
      args: [],
    );
  }

  /// `Step-by-step guide`
  String get tutorBindDesc {
    return Intl.message(
      'Step-by-step guide',
      name: 'tutorBindDesc',
      desc: '',
      args: [],
    );
  }

  /// `### Binding Steps\n1. Click the Bind button\n2. Select device\n3. Confirm binding\n\n### Unbinding Steps\n1. Select bound device\n2. Click Unbind`
  String get tutorBindContent {
    return Intl.message(
      '### Binding Steps\n1. Click the Bind button\n2. Select device\n3. Confirm binding\n\n### Unbinding Steps\n1. Select bound device\n2. Click Unbind',
      name: 'tutorBindContent',
      desc: '',
      args: [],
    );
  }

  /// `View List Details`
  String get tutorListTitle {
    return Intl.message(
      'View List Details',
      name: 'tutorListTitle',
      desc: '',
      args: [],
    );
  }

  /// `How to view detailed info`
  String get tutorListDesc {
    return Intl.message(
      'How to view detailed info',
      name: 'tutorListDesc',
      desc: '',
      args: [],
    );
  }

  /// `### List Details\n- Enter the device list page\n- Click on each device to view details\n- Includes voltage, current, SOC, etc.`
  String get tutorListContent {
    return Intl.message(
      '### List Details\n- Enter the device list page\n- Click on each device to view details\n- Includes voltage, current, SOC, etc.',
      name: 'tutorListContent',
      desc: '',
      args: [],
    );
  }

  /// `View Device Data + PCS Data + Single/Multiple View`
  String get tutorDeviceTitle {
    return Intl.message(
      'View Device Data + PCS Data + Single/Multiple View',
      name: 'tutorDeviceTitle',
      desc: '',
      args: [],
    );
  }

  /// `Device and PCS data viewing method`
  String get tutorDeviceDesc {
    return Intl.message(
      'Device and PCS data viewing method',
      name: 'tutorDeviceDesc',
      desc: '',
      args: [],
    );
  }

  /// `### Device Data\n- View real-time data on device detail page\n- Includes voltage, current, power, temperature, etc.\n\n### PCS Data\n- View PCS related info\n- Includes input/output status and power\n\n### Single / Multiple View\n- Single view: only one device\n- Multiple view: compare multiple devices at the same time`
  String get tutorDeviceContent {
    return Intl.message(
      '### Device Data\n- View real-time data on device detail page\n- Includes voltage, current, power, temperature, etc.\n\n### PCS Data\n- View PCS related info\n- Includes input/output status and power\n\n### Single / Multiple View\n- Single view: only one device\n- Multiple view: compare multiple devices at the same time',
      name: 'tutorDeviceContent',
      desc: '',
      args: [],
    );
  }

  /// `View History Data`
  String get tutorHistoryTitle {
    return Intl.message(
      'View History Data',
      name: 'tutorHistoryTitle',
      desc: '',
      args: [],
    );
  }

  /// `How to view historical data`
  String get tutorHistoryDesc {
    return Intl.message(
      'How to view historical data',
      name: 'tutorHistoryDesc',
      desc: '',
      args: [],
    );
  }

  /// `### History Data\n1. Enter history page\n2. View historical voltage, current, power charts for devices`
  String get tutorHistoryContent {
    return Intl.message(
      '### History Data\n1. Enter history page\n2. View historical voltage, current, power charts for devices',
      name: 'tutorHistoryContent',
      desc: '',
      args: [],
    );
  }

  /// `D-In`
  String get dayIncome {
    return Intl.message('D-In', name: 'dayIncome', desc: '', args: []);
  }

  /// `M-In`
  String get monthIncome {
    return Intl.message('M-In', name: 'monthIncome', desc: '', args: []);
  }

  /// `D-Chg`
  String get dayCharge {
    return Intl.message('D-Chg', name: 'dayCharge', desc: '', args: []);
  }

  /// `D-Dsg`
  String get dayDischarge {
    return Intl.message('D-Dsg', name: 'dayDischarge', desc: '', args: []);
  }

  /// `Time to Full`
  String get timeToFull {
    return Intl.message('Time to Full', name: 'timeToFull', desc: '', args: []);
  }

  /// `Time to Empty`
  String get timeToEmpty {
    return Intl.message(
      'Time to Empty',
      name: 'timeToEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Serial Number`
  String get serialNumber {
    return Intl.message(
      'Serial Number',
      name: 'serialNumber',
      desc: '',
      args: [],
    );
  }

  /// `Real-Time Data`
  String get realTimeData {
    return Intl.message(
      'Real-Time Data',
      name: 'realTimeData',
      desc: '',
      args: [],
    );
  }

  /// `History Data`
  String get historyData {
    return Intl.message(
      'History Data',
      name: 'historyData',
      desc: '',
      args: [],
    );
  }

  /// `Device Revenue`
  String get deviceRevenue {
    return Intl.message(
      'Device Revenue',
      name: 'deviceRevenue',
      desc: '',
      args: [],
    );
  }

  /// `Basic Setting`
  String get basicSetting {
    return Intl.message(
      'Basic Setting',
      name: 'basicSetting',
      desc: '',
      args: [],
    );
  }

  /// `Log Setting`
  String get logSetting {
    return Intl.message('Log Setting', name: 'logSetting', desc: '', args: []);
  }

  /// `PCS Setting`
  String get pcsSetting {
    return Intl.message('PCS Setting', name: 'pcsSetting', desc: '', args: []);
  }

  /// `Back to Home`
  String get backToHome {
    return Intl.message('Back to Home', name: 'backToHome', desc: '', args: []);
  }

  /// `Device Offline`
  String get deviceOffline {
    return Intl.message(
      'Device Offline',
      name: 'deviceOffline',
      desc: '',
      args: [],
    );
  }

  /// `Device Alert`
  String get deviceAlert {
    return Intl.message(
      'Device Alert',
      name: 'deviceAlert',
      desc: '',
      args: [],
    );
  }

  /// `No Alarm`
  String get noAlarm {
    return Intl.message('No Alarm', name: 'noAlarm', desc: '', args: []);
  }

  /// `Internal Temp`
  String get internalTemperature {
    return Intl.message(
      'Internal Temp',
      name: 'internalTemperature',
      desc: '',
      args: [],
    );
  }

  /// `Power Outage List`
  String get powerOutageList {
    return Intl.message(
      'Power Outage List',
      name: 'powerOutageList',
      desc: '',
      args: [],
    );
  }

  /// `Running`
  String get running {
    return Intl.message('Running', name: 'running', desc: '', args: []);
  }

  /// `Standby`
  String get standby {
    return Intl.message('Standby', name: 'standby', desc: '', args: []);
  }

  /// `Status`
  String get status {
    return Intl.message('Status', name: 'status', desc: '', args: []);
  }

  /// `Alarm Details`
  String get alarmDetails {
    return Intl.message(
      'Alarm Details',
      name: 'alarmDetails',
      desc: '',
      args: [],
    );
  }

  /// `Device Status`
  String get deviceStatus {
    return Intl.message(
      'Device Status',
      name: 'deviceStatus',
      desc: '',
      args: [],
    );
  }

  /// `Voltage`
  String get voltage {
    return Intl.message('Voltage', name: 'voltage', desc: '', args: []);
  }

  // skipped getter for the 'current' key

  /// `Power`
  String get power {
    return Intl.message('Power', name: 'power', desc: '', args: []);
  }

  /// `SOC`
  String get soc {
    return Intl.message('SOC', name: 'soc', desc: '', args: []);
  }

  /// `Solar 1`
  String get solar1 {
    return Intl.message('Solar 1', name: 'solar1', desc: '', args: []);
  }

  /// `Solar 2`
  String get solar2 {
    return Intl.message('Solar 2', name: 'solar2', desc: '', args: []);
  }

  /// `Mode`
  String get mode {
    return Intl.message('Mode', name: 'mode', desc: '', args: []);
  }

  /// `Unknown Mode`
  String get unknownMode {
    return Intl.message(
      'Unknown Mode',
      name: 'unknownMode',
      desc: '',
      args: [],
    );
  }

  /// `No Data`
  String get noData {
    return Intl.message('No Data', name: 'noData', desc: '', args: []);
  }

  /// `Backup Mode`
  String get backupMode {
    return Intl.message('Backup Mode', name: 'backupMode', desc: '', args: []);
  }

  /// `Normal Mode`
  String get normalMode {
    return Intl.message('Normal Mode', name: 'normalMode', desc: '', args: []);
  }

  /// `Eco Mode`
  String get ecoMode {
    return Intl.message('Eco Mode', name: 'ecoMode', desc: '', args: []);
  }

  /// `SOC Line Chart`
  String get socChart {
    return Intl.message('SOC Line Chart', name: 'socChart', desc: '', args: []);
  }

  /// `Charge/Discharge Power`
  String get powerChart {
    return Intl.message(
      'Charge/Discharge Power',
      name: 'powerChart',
      desc: '',
      args: [],
    );
  }

  /// `Revenue`
  String get revenueChart {
    return Intl.message('Revenue', name: 'revenueChart', desc: '', args: []);
  }

  /// `Total Revenue`
  String get totalRevenue {
    return Intl.message(
      'Total Revenue',
      name: 'totalRevenue',
      desc: '',
      args: [],
    );
  }

  /// `NT\$`
  String get currency {
    return Intl.message('NT\\\$', name: 'currency', desc: '', args: []);
  }

  /// `No history data`
  String get noHistoryData {
    return Intl.message(
      'No history data',
      name: 'noHistoryData',
      desc: '',
      args: [],
    );
  }

  /// `Monthly Revenue`
  String get monthRevenue {
    return Intl.message(
      'Monthly Revenue',
      name: 'monthRevenue',
      desc: '',
      args: [],
    );
  }

  /// `Daily Revenue`
  String get dailyRevenue {
    return Intl.message(
      'Daily Revenue',
      name: 'dailyRevenue',
      desc: '',
      args: [],
    );
  }

  /// `Today's Revenue`
  String get todayRevenue {
    return Intl.message(
      'Today\'s Revenue',
      name: 'todayRevenue',
      desc: '',
      args: [],
    );
  }

  /// `Daily Target`
  String get dailyTarget {
    return Intl.message(
      'Daily Target',
      name: 'dailyTarget',
      desc: '',
      args: [],
    );
  }

  /// `D`
  String get dayShort {
    return Intl.message('D', name: 'dayShort', desc: '', args: []);
  }

  /// `Day`
  String get day {
    return Intl.message('Day', name: 'day', desc: '', args: []);
  }

  /// `Daily Target`
  String get dailyTargetLabel {
    return Intl.message(
      'Daily Target',
      name: 'dailyTargetLabel',
      desc: '',
      args: [],
    );
  }

  /// `Today: {value} NT\$`
  String dailyAccum(Object value) {
    return Intl.message(
      'Today: $value NT\\\$',
      name: 'dailyAccum',
      desc: '',
      args: [value],
    );
  }

  /// `Monthly Target`
  String get monthlyTargetLabel {
    return Intl.message(
      'Monthly Target',
      name: 'monthlyTargetLabel',
      desc: '',
      args: [],
    );
  }

  /// `Month: {value} NT\$`
  String monthlyAccum(Object value) {
    return Intl.message(
      'Month: $value NT\\\$',
      name: 'monthlyAccum',
      desc: '',
      args: [value],
    );
  }

  /// `Economy Mode`
  String get economyMode {
    return Intl.message(
      'Economy Mode',
      name: 'economyMode',
      desc: '',
      args: [],
    );
  }

  /// `Reminder`
  String get reminder {
    return Intl.message('Reminder', name: 'reminder', desc: '', args: []);
  }

  /// `Are you sure you want to switch to {mode}?`
  String switchModeConfirm(Object mode) {
    return Intl.message(
      'Are you sure you want to switch to $mode?',
      name: 'switchModeConfirm',
      desc: '',
      args: [mode],
    );
  }

  /// `Success`
  String get success {
    return Intl.message('Success', name: 'success', desc: '', args: []);
  }

  /// `Failed`
  String get failed {
    return Intl.message('Failed', name: 'failed', desc: '', args: []);
  }

  /// `Failed to send command`
  String get sendFail {
    return Intl.message(
      'Failed to send command',
      name: 'sendFail',
      desc: '',
      args: [],
    );
  }

  /// `Exception occurred`
  String get exception {
    return Intl.message(
      'Exception occurred',
      name: 'exception',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message('OK', name: 'ok', desc: '', args: []);
  }

  /// `Charge Time`
  String get chargeTime {
    return Intl.message('Charge Time', name: 'chargeTime', desc: '', args: []);
  }

  /// `Submit`
  String get submitTime {
    return Intl.message('Submit', name: 'submitTime', desc: '', args: []);
  }

  /// `Invalid time range`
  String get timeInvalid {
    return Intl.message(
      'Invalid time range',
      name: 'timeInvalid',
      desc: '',
      args: [],
    );
  }

  /// `Time set successfully: {start} ~ {end}`
  String timeSetSuccess(Object start, Object end) {
    return Intl.message(
      'Time set successfully: $start ~ $end',
      name: 'timeSetSuccess',
      desc: '',
      args: [start, end],
    );
  }

  /// `Failed to set time`
  String get timeSetFail {
    return Intl.message(
      'Failed to set time',
      name: 'timeSetFail',
      desc: '',
      args: [],
    );
  }

  /// `PCS mode changed to {mode}`
  String modeChanged(Object mode) {
    return Intl.message(
      'PCS mode changed to $mode',
      name: 'modeChanged',
      desc: '',
      args: [mode],
    );
  }

  /// `Enable Realtime`
  String get enableRealtime {
    return Intl.message(
      'Enable Realtime',
      name: 'enableRealtime',
      desc: 'Toggle to enable realtime updates',
      args: [],
    );
  }

  /// `Update Frequency`
  String get updateFrequency {
    return Intl.message(
      'Update Frequency',
      name: 'updateFrequency',
      desc: 'Frequency of device updates',
      args: [],
    );
  }

  /// `{count} seconds`
  String seconds(Object count) {
    return Intl.message(
      '$count seconds',
      name: 'seconds',
      desc: 'Label for seconds, with count',
      args: [count],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: 'Button label to save settings',
      args: [],
    );
  }

  /// `Device Log`
  String get deviceLog {
    return Intl.message('Device Log', name: 'deviceLog', desc: '', args: []);
  }

  /// `Unknown`
  String get unknown {
    return Intl.message('Unknown', name: 'unknown', desc: '', args: []);
  }

  /// `Model`
  String get model {
    return Intl.message('Model', name: 'model', desc: '', args: []);
  }

  /// `Unknown Model`
  String get unknownModel {
    return Intl.message(
      'Unknown Model',
      name: 'unknownModel',
      desc: '',
      args: [],
    );
  }

  /// `No log data available`
  String get noLogs {
    return Intl.message(
      'No log data available',
      name: 'noLogs',
      desc: '',
      args: [],
    );
  }

  /// `This is the last entry`
  String get lastEntry {
    return Intl.message(
      'This is the last entry',
      name: 'lastEntry',
      desc: '',
      args: [],
    );
  }

  /// `Password Error`
  String get passwordError {
    return Intl.message(
      'Password Error',
      name: 'passwordError',
      desc: '',
      args: [],
    );
  }

  /// `Scan Barcode`
  String get scanBarcode {
    return Intl.message(
      'Scan Barcode',
      name: 'scanBarcode',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[Locale.fromSubtags(languageCode: 'en')];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
