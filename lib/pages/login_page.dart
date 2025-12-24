import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'home_page.dart';
import '../utils/api_service.dart';
import '../widget/floating_message.dart';
import '../utils/theme_colors.dart';
import '../l10n/l10n.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../global.dart'; // 引入全局語言管理

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  int _currentIndex = 0;

  final TextEditingController _loginUserController = TextEditingController();
  final TextEditingController _loginPassController = TextEditingController();
  final TextEditingController _regUserController = TextEditingController();
  final TextEditingController _regPassController = TextEditingController();
  final TextEditingController _regRePassController = TextEditingController();

  bool _agreed = false;
  bool _loading = false;
  bool _keepLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _loadSavedLogin();
  }

  Future<void> _loadSavedLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString("saved_email");
    final savedPassword = prefs.getString("saved_password");
    final keepLoggedIn = prefs.getBool("keep_logged_in") ?? false;

    if (savedEmail != null && savedPassword != null && keepLoggedIn) {
      setState(() {
        _loginUserController.text = savedEmail;
        _loginPassController.text = savedPassword;
        _keepLoggedIn = true;
      });
    }
  }

  void _switchPage(int index) => setState(() => _currentIndex = index);

  bool _isEmailValid(String email) {
    final emailReg = RegExp(r"^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$");
    return emailReg.hasMatch(email);
  }

  Future<void> _login() async {
    final email = _loginUserController.text.trim();
    final password = _loginPassController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      FloatingMessage.show(context,  S.of(context)!.pleaseEnterAccountPassword, autoHide: true);
      return;
    }

    setState(() => _loading = true);
    final result = await ApiService.post("/auth/login", {"email": email, "password": password});
    setState(() => _loading = false);

    if (result["status"] == 200 && result["data"]["token"] != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("jwt_token", result["data"]["token"]);
      await prefs.setBool("keep_logged_in", _keepLoggedIn);
      if (_keepLoggedIn) {
        await prefs.setString("saved_email", email);
        await prefs.setString("saved_password", password);
      } else {
        await prefs.remove("saved_email");
        await prefs.remove("saved_password");
      }
      FloatingMessage.show(context,  S.of(context)!.loginSuccess, autoHide: true);
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DataPage()));
      });
    } else {
      FloatingMessage.show(context, result["data"]["message"] ??  S.of(context)!.loginFailed, autoHide: true);
    }
  }

  Future<void> _register() async {
    final email = _regUserController.text.trim();
    final password = _regPassController.text.trim();
    final rePass = _regRePassController.text.trim();

    if (email.isEmpty || password.isEmpty || rePass.isEmpty) {
      FloatingMessage.show(context,  S.of(context)!.pleaseFillAllFields, autoHide: true);
      return;
    }
    if (!_isEmailValid(email)) {
      FloatingMessage.show(context,  S.of(context)!.invalidEmail, autoHide: true);
      return;
    }
    if (password != rePass) {
      FloatingMessage.show(context,  S.of(context)!.passwordNotMatch, autoHide: true);
      return;
    }

    setState(() => _loading = true);
    final result = await ApiService.post("/auth/register", {"email": email, "password": password});
    setState(() => _loading = false);

    if (result["status"] == 201) {
      FloatingMessage.show(context,  S.of(context)!.registerSuccessWaitAdmin, autoHide: true);
      _switchPage(0);
    } else {
      FloatingMessage.show(context, result["data"]["message"] ??  S.of(context)!.registerFailed, autoHide: true);
    }
  }

  Future<void> _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      FloatingMessage.show(context,  S.of(context)!.cannotOpenUrl(url), autoHide: true);
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
        Color primaryColor = isDark ? Color.fromARGB(255, 34, 212, 40) : Colors.green[700]!;

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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _tabButton(S.of(context)!.login, 0, primaryColor),
                            _tabButton(S.of(context)!.register, 1, primaryColor),
                          ],
                        ),
                        const SizedBox(height: 24),
                        AnimatedCrossFade(
                          firstChild: _buildLoginTab(textColor, hintColor, primaryColor, cardColor),
                          secondChild: _buildRegisterTab(textColor, hintColor, primaryColor, cardColor),
                          crossFadeState: _currentIndex == 0 ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                          duration: const Duration(milliseconds: 300),
                        ),
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
                                ));
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                ThemeProvider.themeMode.value == ThemeMode.dark
                                    ? Icons.dark_mode
                                    : Icons.light_mode,
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

  Widget _tabButton(String text, int index, Color primaryColor) {
    bool selected = _currentIndex == index;
    return GestureDetector(
      onTap: () => _switchPage(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 28),
        decoration: BoxDecoration(
          color: selected ? primaryColor : primaryColor.withOpacity(0.3),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(text, style: TextStyle(color: selected ? Colors.white : Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }

  Widget _inputField(TextEditingController controller, String hint, IconData icon, Color textColor, Color hintColor, Color primaryColor, Color fillColor,
      {bool obscure = false}) {
    return TextField(
      controller: controller,
      obscureText: obscure,
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

  Widget _actionButton(String text, VoidCallback onPressed, Color primaryColor, Color textcolor) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)), backgroundColor: primaryColor),
        child: Text(text, style: TextStyle(color: textcolor, fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildLoginTab(Color textColor, Color hintColor, Color primaryColor, Color cardColor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _inputField(_loginUserController, S.of(context)!.account, Icons.person, textColor, hintColor, primaryColor, cardColor),
        const SizedBox(height: 16),
        _inputField(_loginPassController, S.of(context)!.password, Icons.lock, textColor, hintColor, primaryColor, cardColor, obscure: true),
        const SizedBox(height: 16),
        CheckboxListTile(
          value: _keepLoggedIn,
          onChanged: (val) => setState(() => _keepLoggedIn = val ?? false),
          controlAffinity: ListTileControlAffinity.leading,
          title: Text(S.of(context)!.keepLoggedIn, style: TextStyle(color: textColor)),
          activeColor: primaryColor,
          checkColor: Colors.white,
        ),
        const SizedBox(height: 16),
        _actionButton(S.of(context)!.login, _login, primaryColor, textColor),
      ],
    );
  }

  Widget _buildRegisterTab(Color textColor, Color hintColor, Color primaryColor, Color cardColor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _inputField(_regUserController, S.of(context)!.newAccount, Icons.person_add, textColor, hintColor, primaryColor, cardColor),
        const SizedBox(height: 16),
        _inputField(_regPassController, S.of(context)!.newPassword, Icons.lock_outline, textColor, hintColor, primaryColor, cardColor, obscure: true),
        const SizedBox(height: 16),
        _inputField(_regRePassController, S.of(context)!.confirmPassword, Icons.lock_outline, textColor, hintColor, primaryColor, cardColor, obscure: true),
        const SizedBox(height: 16),
        CheckboxListTile(
          value: _agreed,
          onChanged: (val) => setState(() => _agreed = val ?? false),
          controlAffinity: ListTileControlAffinity.leading,
          title: Wrap(
            children: [
              Text(S.of(context)!.agreeTo, style: TextStyle(color: textColor)),
              GestureDetector(onTap: () => _launchURL("https://www.gustech.com/privacy"), child: Text(S.of(context)!.termsOfService, style: TextStyle(color: primaryColor, decoration: TextDecoration.underline))),
              Text(" ${S.of(context)!.and} ", style: TextStyle(color: textColor)),
              GestureDetector(onTap: () => _launchURL("https://www.gustech.com/privacy"), child: Text(S.of(context)!.privacyPolicy, style: TextStyle(color: primaryColor, decoration: TextDecoration.underline))),
            ],
          ),
          activeColor: primaryColor,
          checkColor: Colors.white,
        ),
        const SizedBox(height: 16),
        _actionButton(
          S.of(context)!.register,
          _agreed ? _register : () => FloatingMessage.show(context, S.of(context)!.pleaseAgreeToTerms, autoHide: true),
          primaryColor,
          textColor,
        ),
      ],
    );
  }
}
