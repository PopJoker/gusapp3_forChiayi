import 'package:flutter/material.dart';
import '../../utils/theme_colors.dart';
import '../../global.dart'; // 引入全局 currentLocale
import 'package:shared_preferences/shared_preferences.dart';
import '../widget/cyber_card.dart';
import '../../l10n/l10n.dart'; // <- 這裡引入 S

class APPSettingPageWidget extends StatefulWidget {
  const APPSettingPageWidget({super.key});

  @override
  State<APPSettingPageWidget> createState() => _APPSettingPageWidgetState();
}

class _APPSettingPageWidgetState extends State<APPSettingPageWidget> {
  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    // neon 顏色
    Color neonPink = isDark ? const Color.fromARGB(255, 0, 255, 38) : const Color.fromARGB(255, 2, 161, 47);
    Color neonPurple = neonPink;
    Color cardBorder = isDark ? Color.fromARGB(255, 0, 255, 38).withOpacity(0.5) : Color.fromARGB(255, 2, 161, 47).withOpacity(0.5);
    Color backgroundColor = isDark ? Colors.black : Colors.white;
    Color neonCyan = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 深色模式切換
          CyberCard(
            neonCyan: neonCyan,
            neonPink: neonPink,
            neonPurple: neonPurple,
            cardBorder: cardBorder,
            backgroundColor: backgroundColor,
            child: SwitchListTile(
              title: Text(
                S.of(context)!.darkMode,
                style: TextStyle(color: neonCyan),
              ),
              value: ThemeProvider.themeMode.value == ThemeMode.dark,
              activeColor: neonPink,
              onChanged: (val) {
                ThemeProvider.toggleTheme();
              },
            ),
          ),

          const SizedBox(height: 16),

          // 語言切換
          ValueListenableBuilder<Locale>(
            valueListenable: currentLocale,
            builder: (context, locale, child) {
              return CyberCard(
                neonCyan: neonCyan,
                neonPink: neonPink,
                neonPurple: neonPurple,
                cardBorder: cardBorder,
                backgroundColor: backgroundColor,
                child: ListTile(
                  title: Text(
                    S.of(context)!.language,
                    style: TextStyle(color: neonCyan),
                  ),
                  trailing: DropdownButton<Locale>(
                    value: locale,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(value: Locale('en'), child: Text('English')),
                      DropdownMenuItem(value: Locale('zh'), child: Text('中文')),
                    ],
                    onChanged: (value) async {
                      if (value != null) {
                        currentLocale.value = value;
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setString('locale', value.languageCode);
                      }
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  }
