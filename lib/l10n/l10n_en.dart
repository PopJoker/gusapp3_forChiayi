// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class SEn extends S {
  SEn([String locale = 'en']) : super(locale);

  @override
  String get locale => 'en';

  @override
  String get account => 'Account';

  @override
  String get password => 'Password';

  @override
  String get keepLoggedIn => 'Keep me logged in';

  @override
  String get login => 'Login';

  @override
  String get newAccount => 'New Account';

  @override
  String get newPassword => 'New Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get agreeTo => 'I have read and agree to ';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get and => 'and';

  @override
  String get register => 'Register';

  @override
  String get pleaseEnterAccountPassword => 'Please enter account and password';

  @override
  String get loginSuccess => 'Login successful!';

  @override
  String get loginFailed => 'Login failed';

  @override
  String get pleaseFillAllFields => 'Please fill in all fields';

  @override
  String get invalidEmail => 'Invalid email format';

  @override
  String get passwordNotMatch => 'Passwords do not match';

  @override
  String get registerSuccessWaitAdmin => 'Registration successful, please wait for admin activation';

  @override
  String get registerFailed => 'Registration failed';

  @override
  String cannotOpenUrl(Object url) {
    return 'Cannot open URL: $url';
  }

  @override
  String get pleaseAgreeToTerms => 'Please agree to the terms and privacy policy';

  @override
  String get energySystem => 'Energy System';

  @override
  String get menu => 'Menu';

  @override
  String get deviceList => 'Device List';

  @override
  String get addOrRemoveBinding => 'Add or Remove Binding';

  @override
  String get appSettings => 'App Settings';

  @override
  String get customerService => 'Customer Service';

  @override
  String get tutorial => 'Tutorial';

  @override
  String get aboutUs => 'About Us';

  @override
  String get logout => 'Logout';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirmLogout => 'Confirm logout?';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get language => 'Language';

  @override
  String get addEnergyDevice => 'Add Energy Device';

  @override
  String get deviceName => 'Device Name';

  @override
  String get barcode => 'Barcode';

  @override
  String get latitude => 'Latitude';

  @override
  String get longitude => 'Longitude';

  @override
  String get deviceArea => 'Area';

  @override
  String get addDevice => 'Add Device';

  @override
  String get addedDevices => 'Added Devices';

  @override
  String get noDevicesYet => 'No devices added yet';

  @override
  String get confirmUnbindTitle => 'Confirm Unbind?';

  @override
  String confirmUnbindContent(Object deviceName) {
    return 'Device $deviceName will be unbound';
  }

  @override
  String get confirm => 'Confirm';

  @override
  String scanFailed(Object error) {
    return 'Scan failed: $error';
  }

  @override
  String get barcodeExists => 'This barcode already exists!';

  @override
  String get latitudeInvalid => 'Latitude format error';

  @override
  String get longitudeInvalid => 'Longitude format error';

  @override
  String get bindSuccess => 'Device bound successfully!';

  @override
  String get bindFailed => 'Binding failed';

  @override
  String get unbindSuccess => 'Device unbound successfully!';

  @override
  String get unbindFailed => 'Unbinding failed';

  @override
  String get deviceListFetchFailed => 'Failed to fetch device list';

  @override
  String get hintUnbind => 'Hint: Swipe device or press unbind button to remove';

  @override
  String get needHelp => 'Need help?';

  @override
  String get contactUsText => 'You can contact us in the following ways:';

  @override
  String get customerEmail => 'Customer Email';

  @override
  String get customerPhone => 'Customer Phone';

  @override
  String get onlineChat => 'Online Chat';

  @override
  String get chatNow => 'Chat with our support staff now';

  @override
  String get taipowerIssueTitle => 'Concerned about Taipower power outage?';

  @override
  String get taipowerIssueText => 'You can call the following number to check:';

  @override
  String get taipowerPhone => 'Taipower Phone';

  @override
  String get tutorBindTitle => 'Bind + Unbind';

  @override
  String get tutorBindDesc => 'Step-by-step guide';

  @override
  String get tutorBindContent => '### Binding Steps\n1. Click the Bind button\n2. Select device\n3. Confirm binding\n\n### Unbinding Steps\n1. Select bound device\n2. Click Unbind';

  @override
  String get tutorListTitle => 'View List Details';

  @override
  String get tutorListDesc => 'How to view detailed info';

  @override
  String get tutorListContent => '### List Details\n- Enter the device list page\n- Click on each device to view details\n- Includes voltage, current, SOC, etc.';

  @override
  String get tutorDeviceTitle => 'View Device Data + PCS Data + Single/Multiple View';

  @override
  String get tutorDeviceDesc => 'Device and PCS data viewing method';

  @override
  String get tutorDeviceContent => '### Device Data\n- View real-time data on device detail page\n- Includes voltage, current, power, temperature, etc.\n\n### PCS Data\n- View PCS related info\n- Includes input/output status and power\n\n### Single / Multiple View\n- Single view: only one device\n- Multiple view: compare multiple devices at the same time';

  @override
  String get tutorHistoryTitle => 'View History Data';

  @override
  String get tutorHistoryDesc => 'How to view historical data';

  @override
  String get tutorHistoryContent => '### History Data\n1. Enter history page\n2. View historical voltage, current, power charts for devices';

  @override
  String get dayIncome => 'D-In';

  @override
  String get monthIncome => 'M-In';

  @override
  String get dayCharge => 'D-Chg';

  @override
  String get dayDischarge => 'D-Dsg';

  @override
  String get timeToFull => 'Time to Full';

  @override
  String get timeToEmpty => 'Time to Empty';

  @override
  String get serialNumber => 'Serial Number';

  @override
  String get realTimeData => 'Real-Time Data';

  @override
  String get historyData => 'History Data';

  @override
  String get deviceRevenue => 'Device Revenue';

  @override
  String get basicSetting => 'Basic Setting';

  @override
  String get logSetting => 'Log Setting';

  @override
  String get pcsSetting => 'PCS Setting';

  @override
  String get backToHome => 'Back to Home';

  @override
  String get deviceOffline => 'Device Offline';

  @override
  String get deviceAlert => 'Device Alert';

  @override
  String get noAlarm => 'No Alarm';

  @override
  String get internalTemperature => 'Internal Temp';

  @override
  String get powerOutageList => 'Power Outage List';

  @override
  String get running => 'Running';

  @override
  String get standby => 'Standby';

  @override
  String get status => 'Status';

  @override
  String get alarmDetails => 'Alarm Details';

  @override
  String get deviceStatus => 'Device Status';

  @override
  String get voltage => 'Voltage';

  @override
  String get current => 'Current';

  @override
  String get power => 'Power';

  @override
  String get soc => 'SOC';

  @override
  String get solar1 => 'Solar 1';

  @override
  String get solar2 => 'Solar 2';

  @override
  String get mode => 'Mode';

  @override
  String get unknownMode => 'Unknown Mode';

  @override
  String get noData => 'No Data';

  @override
  String get backupMode => 'Backup Mode';

  @override
  String get normalMode => 'Normal Mode';

  @override
  String get ecoMode => 'Eco Mode';

  @override
  String get socChart => 'SOC Line Chart';

  @override
  String get voltageChart => 'Voltage over the past 24 hours (Unit: V)';

  @override
  String get currentChart => 'Current over the past 24 hours (Unit: A)';

  @override
  String get powerChartinhirack => 'Power over the past 24 hours (Unit: W)';

  @override
  String get powerChart => 'Charge/Discharge Power';

  @override
  String get revenueChart => 'Revenue';

  @override
  String get totalRevenue => 'Total Revenue';

  @override
  String get currency => 'NT\\\$';

  @override
  String get noHistoryData => 'No history data';

  @override
  String get monthRevenue => 'Monthly Revenue';

  @override
  String get dailyRevenue => 'Daily Revenue';

  @override
  String get todayRevenue => 'Today\'s Revenue';

  @override
  String get dailyTarget => 'Daily Target';

  @override
  String get dayShort => 'D';

  @override
  String get day => 'Day';

  @override
  String get dailyTargetLabel => 'Daily Target';

  @override
  String dailyAccum(Object value) {
    return 'Today: $value NT\\\$';
  }

  @override
  String get monthlyTargetLabel => 'Monthly Target';

  @override
  String monthlyAccum(Object value) {
    return 'Month: $value NT\\\$';
  }

  @override
  String get economyMode => 'Economy Mode';

  @override
  String get reminder => 'Reminder';

  @override
  String switchModeConfirm(Object mode) {
    return 'Are you sure you want to switch to $mode?';
  }

  @override
  String get success => 'Success';

  @override
  String get failed => 'Failed';

  @override
  String get sendFail => 'Failed to send command';

  @override
  String get exception => 'Exception occurred';

  @override
  String get ok => 'OK';

  @override
  String get chargeTime => 'Charge Time';

  @override
  String get submitTime => 'Submit';

  @override
  String get timeInvalid => 'Invalid time range';

  @override
  String timeSetSuccess(Object end, Object start) {
    return 'Time set successfully: $start ~ $end';
  }

  @override
  String get timeSetFail => 'Failed to set time';

  @override
  String modeChanged(Object mode) {
    return 'PCS mode changed to $mode';
  }

  @override
  String get enableRealtime => 'Enable Realtime';

  @override
  String get updateFrequency => 'Update Frequency';

  @override
  String seconds(Object count) {
    return '$count seconds';
  }

  @override
  String get save => 'Save';

  @override
  String get deviceLog => 'Device Log';

  @override
  String get unknown => 'Unknown';

  @override
  String get model => 'Model';

  @override
  String get unknownModel => 'Unknown Model';

  @override
  String get noLogs => 'No log data available';

  @override
  String get lastEntry => 'This is the last entry';

  @override
  String get enterPassword => ' Enter Password';

  @override
  String get passwordError => 'Password Error';

  @override
  String get scanBarcode => 'Scan Barcode';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get confirmDeleteAccount => 'Are you sure you want to delete your account?';

  @override
  String get delete => 'Delete';

  @override
  String get accountDeletedSuccessfully => 'Account deleted successfully';

  @override
  String get deleteFailed => 'Delete failed';

  @override
  String get average => 'Average';
}
