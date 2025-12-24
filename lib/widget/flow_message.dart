import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import '../utils/theme_colors.dart';

class FlowMessage {
  static void show(
    BuildContext context,
    Offset pos,
    String message, {
    int durationSeconds = 2,
  }) {
    final overlay = Overlay.of(context);
    if (overlay == null) return;

    final isDark = ThemeProvider.themeMode.value == ThemeMode.dark;

    final textColor = isDark ? const Color(0xff00ff3c) : Colors.green.shade700;
    final bgGradient = isDark
        ? [const Color(0xff001100), const Color(0xff004400)]
        : [const Color(0xffffffff), const Color(0xffc2ffc2)];

    final screenSize = MediaQuery.of(context).size;
    final maxWidth = screenSize.width * 0.6;
    final padding = 8.0;
    final estimatedHeight = 60.0;

    // 限制位置避免超出螢幕
    double left = pos.dx;
    double top = pos.dy;

    if (left + maxWidth + padding > screenSize.width) {
      left = screenSize.width - maxWidth - padding;
    }
    if (top + estimatedHeight + padding > screenSize.height) {
      top = screenSize.height - estimatedHeight - padding;
    }

    final entry = OverlayEntry(
      builder: (context) => Positioned(
        left: left,
        top: top,
        child: Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              // 提示框
              Container(
                margin: const EdgeInsets.only(top: 10),
                constraints: BoxConstraints(maxWidth: maxWidth),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: bgGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: textColor, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: textColor.withOpacity(0.7),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Text(
                  message,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    overlay.insert(entry);

    Future.delayed(Duration(seconds: durationSeconds), () {
      entry.remove();
    });
  }
}
