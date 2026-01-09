import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'l10n_en.dart';
import 'l10n_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of S
/// returned by `S.of(context)`.
///
/// Applications need to include `S.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/l10n.dart';
///
/// return MaterialApp(
///   localizationsDelegates: S.localizationsDelegates,
///   supportedLocales: S.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the S.supportedLocales
/// property.
abstract class S {
  S(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static S? of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  static const LocalizationsDelegate<S> delegate = _SDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh')
  ];

  /// No description provided for @locale.
  ///
  /// In en, this message translates to:
  /// **'en'**
  String get locale;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @keepLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'Keep me logged in'**
  String get keepLoggedIn;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @newAccount.
  ///
  /// In en, this message translates to:
  /// **'New Account'**
  String get newAccount;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @agreeTo.
  ///
  /// In en, this message translates to:
  /// **'I have read and agree to '**
  String get agreeTo;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **'and'**
  String get and;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @pleaseEnterAccountPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter account and password'**
  String get pleaseEnterAccountPassword;

  /// No description provided for @loginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Login successful!'**
  String get loginSuccess;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get loginFailed;

  /// No description provided for @pleaseFillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all fields'**
  String get pleaseFillAllFields;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get invalidEmail;

  /// No description provided for @passwordNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordNotMatch;

  /// No description provided for @registerSuccessWaitAdmin.
  ///
  /// In en, this message translates to:
  /// **'Registration successful, please wait for admin activation'**
  String get registerSuccessWaitAdmin;

  /// No description provided for @registerFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed'**
  String get registerFailed;

  /// No description provided for @cannotOpenUrl.
  ///
  /// In en, this message translates to:
  /// **'Cannot open URL: {url}'**
  String cannotOpenUrl(Object url);

  /// No description provided for @pleaseAgreeToTerms.
  ///
  /// In en, this message translates to:
  /// **'Please agree to the terms and privacy policy'**
  String get pleaseAgreeToTerms;

  /// No description provided for @energySystem.
  ///
  /// In en, this message translates to:
  /// **'Energy System'**
  String get energySystem;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @deviceList.
  ///
  /// In en, this message translates to:
  /// **'Device List'**
  String get deviceList;

  /// No description provided for @addOrRemoveBinding.
  ///
  /// In en, this message translates to:
  /// **'Add or Remove Binding'**
  String get addOrRemoveBinding;

  /// No description provided for @appSettings.
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get appSettings;

  /// No description provided for @customerService.
  ///
  /// In en, this message translates to:
  /// **'Customer Service'**
  String get customerService;

  /// No description provided for @tutorial.
  ///
  /// In en, this message translates to:
  /// **'Tutorial'**
  String get tutorial;

  /// No description provided for @aboutUs.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get aboutUs;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirmLogout.
  ///
  /// In en, this message translates to:
  /// **'Confirm logout?'**
  String get confirmLogout;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @addEnergyDevice.
  ///
  /// In en, this message translates to:
  /// **'Add Energy Device'**
  String get addEnergyDevice;

  /// No description provided for @deviceName.
  ///
  /// In en, this message translates to:
  /// **'Device Name'**
  String get deviceName;

  /// No description provided for @barcode.
  ///
  /// In en, this message translates to:
  /// **'Barcode'**
  String get barcode;

  /// No description provided for @latitude.
  ///
  /// In en, this message translates to:
  /// **'Latitude'**
  String get latitude;

  /// No description provided for @longitude.
  ///
  /// In en, this message translates to:
  /// **'Longitude'**
  String get longitude;

  /// No description provided for @deviceArea.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get deviceArea;

  /// No description provided for @addDevice.
  ///
  /// In en, this message translates to:
  /// **'Add Device'**
  String get addDevice;

  /// No description provided for @addedDevices.
  ///
  /// In en, this message translates to:
  /// **'Added Devices'**
  String get addedDevices;

  /// No description provided for @noDevicesYet.
  ///
  /// In en, this message translates to:
  /// **'No devices added yet'**
  String get noDevicesYet;

  /// No description provided for @confirmUnbindTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Unbind?'**
  String get confirmUnbindTitle;

  /// No description provided for @confirmUnbindContent.
  ///
  /// In en, this message translates to:
  /// **'Device {deviceName} will be unbound'**
  String confirmUnbindContent(Object deviceName);

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @scanFailed.
  ///
  /// In en, this message translates to:
  /// **'Scan failed: {error}'**
  String scanFailed(Object error);

  /// No description provided for @barcodeExists.
  ///
  /// In en, this message translates to:
  /// **'This barcode already exists!'**
  String get barcodeExists;

  /// No description provided for @latitudeInvalid.
  ///
  /// In en, this message translates to:
  /// **'Latitude format error'**
  String get latitudeInvalid;

  /// No description provided for @longitudeInvalid.
  ///
  /// In en, this message translates to:
  /// **'Longitude format error'**
  String get longitudeInvalid;

  /// No description provided for @bindSuccess.
  ///
  /// In en, this message translates to:
  /// **'Device bound successfully!'**
  String get bindSuccess;

  /// No description provided for @bindFailed.
  ///
  /// In en, this message translates to:
  /// **'Binding failed'**
  String get bindFailed;

  /// No description provided for @unbindSuccess.
  ///
  /// In en, this message translates to:
  /// **'Device unbound successfully!'**
  String get unbindSuccess;

  /// No description provided for @unbindFailed.
  ///
  /// In en, this message translates to:
  /// **'Unbinding failed'**
  String get unbindFailed;

  /// No description provided for @deviceListFetchFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch device list'**
  String get deviceListFetchFailed;

  /// No description provided for @hintUnbind.
  ///
  /// In en, this message translates to:
  /// **'Hint: Swipe device or press unbind button to remove'**
  String get hintUnbind;

  /// No description provided for @needHelp.
  ///
  /// In en, this message translates to:
  /// **'Need help?'**
  String get needHelp;

  /// No description provided for @contactUsText.
  ///
  /// In en, this message translates to:
  /// **'You can contact us in the following ways:'**
  String get contactUsText;

  /// No description provided for @customerEmail.
  ///
  /// In en, this message translates to:
  /// **'Customer Email'**
  String get customerEmail;

  /// No description provided for @customerPhone.
  ///
  /// In en, this message translates to:
  /// **'Customer Phone'**
  String get customerPhone;

  /// No description provided for @onlineChat.
  ///
  /// In en, this message translates to:
  /// **'Online Chat'**
  String get onlineChat;

  /// No description provided for @chatNow.
  ///
  /// In en, this message translates to:
  /// **'Chat with our support staff now'**
  String get chatNow;

  /// No description provided for @taipowerIssueTitle.
  ///
  /// In en, this message translates to:
  /// **'Concerned about Taipower power outage?'**
  String get taipowerIssueTitle;

  /// No description provided for @taipowerIssueText.
  ///
  /// In en, this message translates to:
  /// **'You can call the following number to check:'**
  String get taipowerIssueText;

  /// No description provided for @taipowerPhone.
  ///
  /// In en, this message translates to:
  /// **'Taipower Phone'**
  String get taipowerPhone;

  /// No description provided for @tutorBindTitle.
  ///
  /// In en, this message translates to:
  /// **'Bind + Unbind'**
  String get tutorBindTitle;

  /// No description provided for @tutorBindDesc.
  ///
  /// In en, this message translates to:
  /// **'Step-by-step guide'**
  String get tutorBindDesc;

  /// No description provided for @tutorBindContent.
  ///
  /// In en, this message translates to:
  /// **'### Binding Steps\n1. Click the Bind button\n2. Select device\n3. Confirm binding\n\n### Unbinding Steps\n1. Select bound device\n2. Click Unbind'**
  String get tutorBindContent;

  /// No description provided for @tutorListTitle.
  ///
  /// In en, this message translates to:
  /// **'View List Details'**
  String get tutorListTitle;

  /// No description provided for @tutorListDesc.
  ///
  /// In en, this message translates to:
  /// **'How to view detailed info'**
  String get tutorListDesc;

  /// No description provided for @tutorListContent.
  ///
  /// In en, this message translates to:
  /// **'### List Details\n- Enter the device list page\n- Click on each device to view details\n- Includes voltage, current, SOC, etc.'**
  String get tutorListContent;

  /// No description provided for @tutorDeviceTitle.
  ///
  /// In en, this message translates to:
  /// **'View Device Data + PCS Data + Single/Multiple View'**
  String get tutorDeviceTitle;

  /// No description provided for @tutorDeviceDesc.
  ///
  /// In en, this message translates to:
  /// **'Device and PCS data viewing method'**
  String get tutorDeviceDesc;

  /// No description provided for @tutorDeviceContent.
  ///
  /// In en, this message translates to:
  /// **'### Device Data\n- View real-time data on device detail page\n- Includes voltage, current, power, temperature, etc.\n\n### PCS Data\n- View PCS related info\n- Includes input/output status and power\n\n### Single / Multiple View\n- Single view: only one device\n- Multiple view: compare multiple devices at the same time'**
  String get tutorDeviceContent;

  /// No description provided for @tutorHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'View History Data'**
  String get tutorHistoryTitle;

  /// No description provided for @tutorHistoryDesc.
  ///
  /// In en, this message translates to:
  /// **'How to view historical data'**
  String get tutorHistoryDesc;

  /// No description provided for @tutorHistoryContent.
  ///
  /// In en, this message translates to:
  /// **'### History Data\n1. Enter history page\n2. View historical voltage, current, power charts for devices'**
  String get tutorHistoryContent;

  /// No description provided for @dayIncome.
  ///
  /// In en, this message translates to:
  /// **'D-In'**
  String get dayIncome;

  /// No description provided for @monthIncome.
  ///
  /// In en, this message translates to:
  /// **'M-In'**
  String get monthIncome;

  /// No description provided for @dayCharge.
  ///
  /// In en, this message translates to:
  /// **'D-Chg'**
  String get dayCharge;

  /// No description provided for @dayDischarge.
  ///
  /// In en, this message translates to:
  /// **'D-Dsg'**
  String get dayDischarge;

  /// No description provided for @timeToFull.
  ///
  /// In en, this message translates to:
  /// **'Time to Full'**
  String get timeToFull;

  /// No description provided for @timeToEmpty.
  ///
  /// In en, this message translates to:
  /// **'Time to Empty'**
  String get timeToEmpty;

  /// No description provided for @serialNumber.
  ///
  /// In en, this message translates to:
  /// **'Serial Number'**
  String get serialNumber;

  /// No description provided for @realTimeData.
  ///
  /// In en, this message translates to:
  /// **'Real-Time Data'**
  String get realTimeData;

  /// No description provided for @historyData.
  ///
  /// In en, this message translates to:
  /// **'History Data'**
  String get historyData;

  /// No description provided for @deviceRevenue.
  ///
  /// In en, this message translates to:
  /// **'Device Revenue'**
  String get deviceRevenue;

  /// No description provided for @basicSetting.
  ///
  /// In en, this message translates to:
  /// **'Basic Setting'**
  String get basicSetting;

  /// No description provided for @logSetting.
  ///
  /// In en, this message translates to:
  /// **'Log Setting'**
  String get logSetting;

  /// No description provided for @pcsSetting.
  ///
  /// In en, this message translates to:
  /// **'PCS Setting'**
  String get pcsSetting;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;

  /// No description provided for @deviceOffline.
  ///
  /// In en, this message translates to:
  /// **'Device Offline'**
  String get deviceOffline;

  /// No description provided for @deviceAlert.
  ///
  /// In en, this message translates to:
  /// **'Device Alert'**
  String get deviceAlert;

  /// No description provided for @noAlarm.
  ///
  /// In en, this message translates to:
  /// **'No Alarm'**
  String get noAlarm;

  /// No description provided for @internalTemperature.
  ///
  /// In en, this message translates to:
  /// **'Internal Temp'**
  String get internalTemperature;

  /// No description provided for @powerOutageList.
  ///
  /// In en, this message translates to:
  /// **'Power Outage List'**
  String get powerOutageList;

  /// No description provided for @running.
  ///
  /// In en, this message translates to:
  /// **'Running'**
  String get running;

  /// No description provided for @standby.
  ///
  /// In en, this message translates to:
  /// **'Standby'**
  String get standby;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @alarmDetails.
  ///
  /// In en, this message translates to:
  /// **'Alarm Details'**
  String get alarmDetails;

  /// No description provided for @deviceStatus.
  ///
  /// In en, this message translates to:
  /// **'Device Status'**
  String get deviceStatus;

  /// No description provided for @voltage.
  ///
  /// In en, this message translates to:
  /// **'Voltage'**
  String get voltage;

  /// No description provided for @current.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get current;

  /// No description provided for @power.
  ///
  /// In en, this message translates to:
  /// **'Power'**
  String get power;

  /// No description provided for @soc.
  ///
  /// In en, this message translates to:
  /// **'SOC'**
  String get soc;

  /// No description provided for @solar1.
  ///
  /// In en, this message translates to:
  /// **'Solar 1'**
  String get solar1;

  /// No description provided for @solar2.
  ///
  /// In en, this message translates to:
  /// **'Solar 2'**
  String get solar2;

  /// No description provided for @mode.
  ///
  /// In en, this message translates to:
  /// **'Mode'**
  String get mode;

  /// No description provided for @unknownMode.
  ///
  /// In en, this message translates to:
  /// **'Unknown Mode'**
  String get unknownMode;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No Data'**
  String get noData;

  /// No description provided for @backupMode.
  ///
  /// In en, this message translates to:
  /// **'Backup Mode'**
  String get backupMode;

  /// No description provided for @normalMode.
  ///
  /// In en, this message translates to:
  /// **'Normal Mode'**
  String get normalMode;

  /// No description provided for @ecoMode.
  ///
  /// In en, this message translates to:
  /// **'Eco Mode'**
  String get ecoMode;

  /// No description provided for @socChart.
  ///
  /// In en, this message translates to:
  /// **'SOC Line Chart'**
  String get socChart;

  /// No description provided for @voltageChart.
  ///
  /// In en, this message translates to:
  /// **'Voltage over the past 24 hours (Unit: V)'**
  String get voltageChart;

  /// No description provided for @currentChart.
  ///
  /// In en, this message translates to:
  /// **'Current over the past 24 hours (Unit: A)'**
  String get currentChart;

  /// No description provided for @powerChartinhirack.
  ///
  /// In en, this message translates to:
  /// **'Power over the past 24 hours (Unit: W)'**
  String get powerChartinhirack;

  /// No description provided for @powerChart.
  ///
  /// In en, this message translates to:
  /// **'Charge/Discharge Power'**
  String get powerChart;

  /// No description provided for @revenueChart.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get revenueChart;

  /// No description provided for @totalRevenue.
  ///
  /// In en, this message translates to:
  /// **'Total Revenue'**
  String get totalRevenue;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'NT\\\$'**
  String get currency;

  /// No description provided for @noHistoryData.
  ///
  /// In en, this message translates to:
  /// **'No history data'**
  String get noHistoryData;

  /// No description provided for @monthRevenue.
  ///
  /// In en, this message translates to:
  /// **'Monthly Revenue'**
  String get monthRevenue;

  /// No description provided for @dailyRevenue.
  ///
  /// In en, this message translates to:
  /// **'Daily Revenue'**
  String get dailyRevenue;

  /// No description provided for @todayRevenue.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Revenue'**
  String get todayRevenue;

  /// No description provided for @dailyTarget.
  ///
  /// In en, this message translates to:
  /// **'Daily Target'**
  String get dailyTarget;

  /// No description provided for @dayShort.
  ///
  /// In en, this message translates to:
  /// **'D'**
  String get dayShort;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get day;

  /// No description provided for @dailyTargetLabel.
  ///
  /// In en, this message translates to:
  /// **'Daily Target'**
  String get dailyTargetLabel;

  /// No description provided for @dailyAccum.
  ///
  /// In en, this message translates to:
  /// **'Today: {value} NT\\\$'**
  String dailyAccum(Object value);

  /// No description provided for @monthlyTargetLabel.
  ///
  /// In en, this message translates to:
  /// **'Monthly Target'**
  String get monthlyTargetLabel;

  /// No description provided for @monthlyAccum.
  ///
  /// In en, this message translates to:
  /// **'Month: {value} NT\\\$'**
  String monthlyAccum(Object value);

  /// No description provided for @economyMode.
  ///
  /// In en, this message translates to:
  /// **'Economy Mode'**
  String get economyMode;

  /// No description provided for @reminder.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get reminder;

  /// No description provided for @switchModeConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to switch to {mode}?'**
  String switchModeConfirm(Object mode);

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @failed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get failed;

  /// No description provided for @sendFail.
  ///
  /// In en, this message translates to:
  /// **'Failed to send command'**
  String get sendFail;

  /// No description provided for @exception.
  ///
  /// In en, this message translates to:
  /// **'Exception occurred'**
  String get exception;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @chargeTime.
  ///
  /// In en, this message translates to:
  /// **'Charge Time'**
  String get chargeTime;

  /// No description provided for @submitTime.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submitTime;

  /// No description provided for @timeInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid time range'**
  String get timeInvalid;

  /// No description provided for @timeSetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Time set successfully: {start} ~ {end}'**
  String timeSetSuccess(Object end, Object start);

  /// No description provided for @timeSetFail.
  ///
  /// In en, this message translates to:
  /// **'Failed to set time'**
  String get timeSetFail;

  /// No description provided for @modeChanged.
  ///
  /// In en, this message translates to:
  /// **'PCS mode changed to {mode}'**
  String modeChanged(Object mode);

  /// Toggle to enable realtime updates
  ///
  /// In en, this message translates to:
  /// **'Enable Realtime'**
  String get enableRealtime;

  /// Frequency of device updates
  ///
  /// In en, this message translates to:
  /// **'Update Frequency'**
  String get updateFrequency;

  /// Label for seconds, with count
  ///
  /// In en, this message translates to:
  /// **'{count} seconds'**
  String seconds(Object count);

  /// Button label to save settings
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @deviceLog.
  ///
  /// In en, this message translates to:
  /// **'Device Log'**
  String get deviceLog;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @model.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get model;

  /// No description provided for @unknownModel.
  ///
  /// In en, this message translates to:
  /// **'Unknown Model'**
  String get unknownModel;

  /// No description provided for @noLogs.
  ///
  /// In en, this message translates to:
  /// **'No log data available'**
  String get noLogs;

  /// No description provided for @lastEntry.
  ///
  /// In en, this message translates to:
  /// **'This is the last entry'**
  String get lastEntry;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **' Enter Password'**
  String get enterPassword;

  /// No description provided for @passwordError.
  ///
  /// In en, this message translates to:
  /// **'Password Error'**
  String get passwordError;

  /// No description provided for @scanBarcode.
  ///
  /// In en, this message translates to:
  /// **'Scan Barcode'**
  String get scanBarcode;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @confirmDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account?'**
  String get confirmDeleteAccount;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @accountDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Account deleted successfully'**
  String get accountDeletedSuccessfully;

  /// No description provided for @deleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Delete failed'**
  String get deleteFailed;

  /// No description provided for @average.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get average;
}

class _SDelegate extends LocalizationsDelegate<S> {
  const _SDelegate();

  @override
  Future<S> load(Locale locale) {
    return SynchronousFuture<S>(lookupS(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_SDelegate old) => false;
}

S lookupS(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return SEn();
    case 'zh': return SZh();
  }

  throw FlutterError(
    'S.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
