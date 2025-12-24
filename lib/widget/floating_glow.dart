import 'dart:math';
import 'package:flutter/material.dart';

class FloatingGlowPainter extends CustomPainter {
  final double animationValue;
  final bool isDark;
  final Color glowColor;

  FloatingGlowPainter({
    required this.animationValue,
    required this.isDark,
    required this.glowColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();
    final int pointCount = 6;
    final Random rand = Random(123);

    for (int i = 0; i < pointCount; i++) {
      double baseX = rand.nextDouble() * size.width;
      double baseY = rand.nextDouble() * size.height;
      double dx = sin(animationValue * 2 * pi + i) * 30;
      double dy = cos(animationValue * 2 * pi + i) * 30;
      double radius = 50 + rand.nextDouble() * 30;

      paint.shader =
          RadialGradient(
            colors: isDark
                ? [glowColor.withOpacity(0.05), Colors.transparent]
                : [glowColor.withOpacity(0.1), Colors.transparent],
            radius: 1.0,
          ).createShader(
            Rect.fromCircle(
              center: Offset(baseX + dx, baseY + dy),
              radius: radius,
            ),
          );

      canvas.drawCircle(Offset(baseX + dx, baseY + dy), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant FloatingGlowPainter oldDelegate) => true;
}
