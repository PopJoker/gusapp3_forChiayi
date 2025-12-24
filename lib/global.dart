import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

ValueNotifier<Locale> currentLocale = ValueNotifier(const Locale('en'));

class LocaleProvider {
  /// 初始化：從 SharedPreferences 讀取
  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    String code = prefs.getString('locale') ?? 'en';
    currentLocale.value = Locale(code);
  }

  /// 切換語言並保存
  static Future<void> changeLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    currentLocale.value = locale;
    await prefs.setString('locale', locale.languageCode);
  }
}
