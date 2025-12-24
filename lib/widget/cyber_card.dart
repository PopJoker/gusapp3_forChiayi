import 'package:flutter/material.dart';

class CyberCard extends StatelessWidget {
  const CyberCard({
    super.key,
    required this.child,
    required this.neonCyan,
    required this.neonPink,
    required this.neonPurple,
    required this.cardBorder,
    required this.backgroundColor,
  });

  final Widget child;
  final Color neonCyan;
  final Color neonPink;
  final Color neonPurple;
  final Color cardBorder;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: neonPink.withOpacity(0.3),
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: neonPurple.withOpacity(0.2),
                  blurRadius: 32,
                  spreadRadius: 4,
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [backgroundColor.withOpacity(0.7), backgroundColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: cardBorder, width: 1.5),
          ),
          child: child,
        ),
      ],
    );
  }
}
