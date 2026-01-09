import 'package:flutter/material.dart';
import '../l10n/l10n.dart';

Future<bool?> showCyberpunkConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  Color glowColor = Colors.pinkAccent,
  String? confirmText,
  String? cancelText,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final bgColor =
      isDark ? Colors.black.withOpacity(0.85) : Colors.white.withOpacity(0.95);
  final textShadowColor = glowColor.withOpacity(0.8);
  final confirmLabel = confirmText ?? S.of(context)!.ok;
  final cancelLabel = confirmText ?? S.of(context)!.cancel;

  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: glowColor.withOpacity(0.8), width: 2),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                blurRadius: 10,
                color: textShadowColor,
                offset: const Offset(0, 0),
              ),
            ],
          ),
        ),
        content: Text(
          message,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            shadows: [
              Shadow(
                blurRadius: 8,
                color: textShadowColor.withOpacity(0.6),
                offset: const Offset(0, 0),
              ),
            ],
          ),
        ),
        actions: [
          // 取消
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: TextButton.styleFrom(
              foregroundColor: isDark ? Colors.grey[400] : Colors.grey[800],
            ),
            child: Text(cancelLabel),
          ),
          // 確定
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: isDark ? Colors.black : Colors.white70,
              backgroundColor: glowColor.withOpacity(0.6),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: Text(
              confirmLabel,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    blurRadius: 8,
                    color: glowColor.withOpacity(0.7),
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    },
  );
}
