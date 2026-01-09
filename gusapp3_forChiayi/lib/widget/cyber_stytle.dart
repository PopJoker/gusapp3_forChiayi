import 'package:flutter/material.dart';
class CyberpunkButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color color;
  final Color glow;

  const CyberpunkButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.color,
    required this.glow,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: color,
          shadows: [
            Shadow(
              blurRadius: 12,
              color: glow.withOpacity(0.8),
              offset: const Offset(0, 0),
            ),
          ],
        ),
      ),
    );
  }
}

class CyberpunkElevatedButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color color;
  final Color glow;

  const CyberpunkElevatedButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.color,
    required this.glow,
  });


  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        shadowColor: glow,
        elevation: 10,
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              blurRadius: 12,
              color: glow.withOpacity(0.8),
              offset: const Offset(0, 0),
            ),
          ],
        ),
      ),
    );
  }
}

