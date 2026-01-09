import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider {
  static ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.light);

  /// 初始化：從 SharedPreferences 讀取
  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    bool isDark = prefs.getBool('isDarkMode') ?? false;
    themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  /// 切換主題並保存
  static Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    if (themeMode.value == ThemeMode.dark) {
      themeMode.value = ThemeMode.light;
      await prefs.setBool('isDarkMode', false);
    } else {
      themeMode.value = ThemeMode.dark;
      await prefs.setBool('isDarkMode', true);
    }
  }
}
