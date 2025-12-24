import 'package:flutter/material.dart';
import '../../utils/theme_colors.dart';

class FloatingMessage {
  static OverlayEntry? _currentEntry; // 管理當前浮動訊息

  /// 顯示浮動訊息
  static void show(
    BuildContext context,
    String msg, {
    bool autoHide = false,
    int durationSeconds = 1,
    Color? lineColor,
    Color? textColor,
    Color? backgroundColor,
  }) {
    final overlay = Overlay.of(context);
    if (overlay == null) return;

    // 判斷主題，如果外部沒傳顏色就自動使用 Theme
    final isDark = ThemeProvider.themeMode.value == ThemeMode.dark;

    lineColor ??= isDark
        ? const Color.fromARGB(255, 0, 255, 13)
        : const Color.fromARGB(255, 4, 143, 22);
    textColor ??= isDark ? Colors.white : Colors.black;
    backgroundColor ??= isDark
        ? const Color.fromARGB(255, 0, 0, 0)
        : const Color.fromARGB(255, 255, 255, 255);

    // 移除舊訊息
    _currentEntry?.remove();

    _currentEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).size.height * 0.4,
        left: 24,
        right: 24,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: lineColor!, width: 2),
            ),
            child: Center(
              child: Text(
                msg,
                style: TextStyle(color: lineColor, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(_currentEntry!);

    if (autoHide) {
      Future.delayed(Duration(seconds: durationSeconds), () {
        _currentEntry?.remove();
        _currentEntry = null;
      });
    }
  }
}
