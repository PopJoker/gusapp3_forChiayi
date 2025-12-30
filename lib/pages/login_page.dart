import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'device pages/device_home_page.dart';
import '../utils/api_service.dart';
import '../widget/floating_message.dart';
import '../utils/theme_colors.dart';
import '../l10n/l10n.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../global.dart'; // 全局語言管理
import 'package:flutter/services.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _serialController = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadSavedSerial();
    
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
    );
  }

  Future<void> _loadSavedSerial() async {
    final prefs = await SharedPreferences.getInstance();
    final savedSerial = prefs.getString("saved_serial");
    if (savedSerial != null) {
      _serialController.text = savedSerial;
    }
  }

  Future<void> _login() async {
    final serial = _serialController.text.trim();

    if (serial.isEmpty) {
      FloatingMessage.show(context, S.of(context)!.pleaseEnterAccountPassword, autoHide: true);
      return;
    }

    setState(() => _loading = true);
    final result = await ApiService.post("/auth/login", {"serial_number": serial});
    setState(() => _loading = false);

    if (result["status"] == 200 && result["data"]["token"] != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("jwt_token", result["data"]["token"]);
      await prefs.setString("saved_serial", serial);
      FloatingMessage.show(context, S.of(context)!.loginSuccess, autoHide: true);

      // 直接建立最小 site 資料
      final Map<String, dynamic> site = {
        "serial_number": serial,
        "name": serial,
        "model": "LES", // 這裡可以預設，也可以改成 HES 或其他
        "status": "CHG", // 預設狀態
        "soc": 0,
        "soh": 0,
        "remaining": 0,
        "day_income": 0,
        "month_income": 0,
        "chgday": 0,
        "dsgday": 0,
      };

      // 直接進 DataHomePage
      Future.delayed(const Duration(milliseconds: 300), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DataHomePage(site: site)),
        );
      });
    } else {
      FloatingMessage.show(
        context,
        result["data"]["message"] ?? S.of(context)!.loginFailed,
        autoHide: true,
      );
    }
  }

  Future<void> _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      FloatingMessage.show(context, S.of(context)!.cannotOpenUrl(url), autoHide: true);
    }
  }

  Future<void> _scanSerial() async {
    String? scannedCode = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context)!.scanBarcode),
        content: SizedBox(
          width: 300,
          height: 400,
          child: MobileScanner(
            onDetect: (capture) {
              final barcode = capture.barcodes.first;
              final String? code = barcode.rawValue;
              if (code != null && code.isNotEmpty) {
                Navigator.of(context).pop(code);
              }
            },
          ),
        ),
      ),
    );

    if (scannedCode != null && scannedCode.isNotEmpty) {
      setState(() {
        _serialController.text = scannedCode;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeProvider.themeMode,
      builder: (context, themeMode, child) {
        bool isDark = themeMode == ThemeMode.dark;

        Color cardColor = isDark ? Colors.grey[900]! : Colors.grey[100]!;
        Color textColor = isDark ? Colors.white : Colors.black87;
        Color hintColor = isDark ? Colors.white54 : Colors.black45;
        Color primaryColor = isDark ? const Color.fromARGB(255, 34, 212, 40) : Colors.green[700]!;

        return Scaffold(
          body: Stack(
            children: [
              Positioned.fill(
                child: Image.asset('assets/BGP.jpg', fit: BoxFit.cover),
              ),
              Positioned.fill(
                child: Container(
                  color: isDark ? Colors.black.withOpacity(0.5) : Colors.white.withOpacity(0.5),
                ),
              ),
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxWidth: 400),
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: cardColor.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, 6))],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          isDark ? 'assets/GUSLOGO2.png' : 'assets/GUSLOGO.png',
                          width: 100,
                          height: 100,
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: _inputField(_serialController, S.of(context)!.serialNumber, Icons.qr_code, textColor, hintColor, primaryColor, cardColor),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: _scanSerial,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                padding: const EdgeInsets.all(12),
                              ),
                              child: const Icon(Icons.qr_code_scanner, color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _actionButton(S.of(context)!.login, _login, primaryColor, textColor),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ValueListenableBuilder<Locale>(
                              valueListenable: currentLocale,
                              builder: (context, locale, child) {
                                return DropdownButtonHideUnderline(
                                  child: DropdownButton<Locale>(
                                    value: currentLocale.value,
                                    onChanged: (locale) {
                                      if (locale != null) LocaleProvider.changeLocale(locale);
                                    },
                                    items: const [
                                      DropdownMenuItem(value: Locale('en'), child: Text('English')),
                                      DropdownMenuItem(value: Locale('zh'), child: Text('中文')),
                                    ],
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                ThemeProvider.themeMode.value == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode,
                                color: primaryColor,
                              ),
                              onPressed: () => ThemeProvider.toggleTheme(),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: _loading
              ? FloatingActionButton(
                  onPressed: () {},
                  backgroundColor: primaryColor,
                  child: const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white)),
                )
              : null,
        );
      },
    );
  }

  Widget _inputField(TextEditingController controller, String hint, IconData icon, Color textColor, Color hintColor, Color primaryColor, Color fillColor) {
    return TextField(
      controller: controller,
      style: TextStyle(color: textColor),
      cursorColor: primaryColor,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: primaryColor),
        hintText: hint,
        hintStyle: TextStyle(color: hintColor),
        filled: true,
        fillColor: fillColor,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide(color: primaryColor, width: 2)),
      ),
    );
  }

  Widget _actionButton(String text, VoidCallback onPressed, Color primaryColor, Color textColor) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          backgroundColor: primaryColor,
        ),
        child: Text(text, style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
