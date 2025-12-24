import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart'; // <- 新增
import 'l10n/l10n.dart'; // 語系檔（自動生成的）
import 'pages/login_page.dart';
import 'utils/theme_colors.dart';
import 'widget/floating_message.dart';
import 'global.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  String code = prefs.getString('locale') ?? 'en';
  currentLocale.value = Locale(code);

  await LocaleProvider.init();
  await ThemeProvider.init();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en'); // 預設語言：英文

  @override
  void initState() {
    super.initState();
    _loadSavedLocale(); // 初始化時載入保存的語言
  }

  // 讀取 SharedPreferences 的語言設定
  Future<void> _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString('locale');
    if (code != null) {
      setState(() {
        _locale = Locale(code);
      });
    }
  }

  // 切換語言並保存
  void _changeLanguage(Locale locale) async {
    setState(() {
      _locale = locale;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', locale.languageCode);
  }

 @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: currentLocale,
      builder: (context, locale, child) {
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: ThemeProvider.themeMode,
          builder: (context, themeMode, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'GUS App',
              locale: locale,
              localizationsDelegates: const [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: S.supportedLocales,
              theme: ThemeData.light().copyWith(
                primaryColor: Colors.green,
                scaffoldBackgroundColor: Colors.white,
              ),
              darkTheme: ThemeData.dark().copyWith(
                primaryColor: Colors.green,
                scaffoldBackgroundColor: Colors.black,
              ),
              themeMode: themeMode,
              home: const AuthPage(),
            );
          },
        );
      },
    );
  }
}
