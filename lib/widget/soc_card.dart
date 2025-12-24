import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'dart:math';
import '../l10n/l10n.dart';

class SOCCircle extends StatefulWidget {
  final bool isCharging;
  final Map<String, dynamic> data;
  final double size;
  final bool isDark; // 新增主題模式開關

  const SOCCircle({
    super.key,
    required this.isCharging,
    required this.data,
    required this.size,
    this.isDark = false,
  });

  @override
  State<SOCCircle> createState() => _SOCCircleState();
}

class _SOCCircleState extends State<SOCCircle> with TickerProviderStateMixin {
  late AnimationController _controller;
  late PageController _pageController;
  bool _isSingleMode = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _pageController = PageController(viewportFraction: 1.0, initialPage: 0);
  }

  void _toggleMode() {
    setState(() {
      _isSingleMode = !_isSingleMode;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final mainColor = widget.isCharging
        ? (isDark ? const Color(0xff5cff59) : const Color(0xff11cd00))
        : (isDark ? Colors.blue.shade700 : Colors.blue.shade800);

    List<Widget> dataItems = [
      _DataItem(
        label: S.of(context)!.voltage,
        value: "${widget.data["voltage"] ?? "--"} V",
        icon: Icons.bolt,
        color: mainColor,
      ),
      _DataItem(
        label: S.of(context)!.current,
        value: "${widget.data["current"] ?? "--"} A",
        icon: Icons.flash_on,
        color: mainColor,
      ),
      _DataItem(
        label: S.of(context)!.power,
        value: "${widget.data["power"] ?? "--"} kW",
        icon: Icons.power,
        color: mainColor,
      ),
    ];

    return GestureDetector(
      onTap: _toggleMode,
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  size: Size(widget.size, widget.size),
                  painter: _SOCPainter(
                    isCharging: widget.isCharging,
                    rotation: _controller.value,
                    data: widget.data,
                    mainColor: mainColor,
                  ),
                );
              },
            ),
            if (_isSingleMode)
              SizedBox(
                width: widget.size,
                height: widget.size,
                child: PageView(
                  controller: _pageController,
                  physics: const BouncingScrollPhysics(),
                  children: dataItems,
                ),
              )
            else
              SizedBox(
                width: double.infinity,
                height: widget.size * 0.7,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: dataItems,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DataItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _DataItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 36, color: color),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color.withOpacity(0.85),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
            shadows: [Shadow(color: color.withOpacity(0.7), blurRadius: 6)],
          ),
        ),
      ],
    );
  }
}

class _SOCPainter extends CustomPainter {
  final bool isCharging;
  final double rotation;
  final Map<String, dynamic> data;
  final Color mainColor;

  _SOCPainter({
    required this.isCharging,
    required this.rotation,
    required this.data,
    required this.mainColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2 - 16;

    // 外圈光暈
    for (int i = 0; i < 3; i++) {
      final glowPaint = Paint()
        ..shader = ui.Gradient.radial(center, radius + i * 8, [
          mainColor.withOpacity(0.3 / (i + 1)),
          Colors.transparent,
        ])
        ..style = PaintingStyle.stroke
        ..strokeWidth = 12 + i * 4;
      canvas.drawCircle(center, radius + i * 8, glowPaint);
    }

    // 波浪
    double soc = double.tryParse(data["SOC"]?.toString() ?? '0') ?? 0;
    double baseY = size.height * (1 - soc / 100);

    List<Map<String, dynamic>> waves = [
      {"height": 6.0, "count": 1.0, "speed": 0.0, "opacity": 0.2},
      {"height": 10.0, "count": 1.3, "speed": 0.5, "opacity": 0.4},
      {"height": 14.0, "count": 1.5, "speed": 0.3, "opacity": 0.6},
    ];

    void drawWave(
      double waveHeight,
      double waveCount,
      double speedOffset,
      double opacity,
    ) {
      final path = Path();
      path.moveTo(0, size.height);
      path.lineTo(0, baseY);

      for (double x = 0; x <= size.width; x++) {
        double y =
            waveHeight *
                sin(
                  2 * pi * waveCount * x / size.width +
                      rotation * pi * 2 +
                      speedOffset,
                ) +
            baseY;
        path.lineTo(x, y);
      }

      path.lineTo(size.width, size.height);
      path.close();

      final wavePaint = Paint()
        ..shader = ui.Gradient.linear(Offset(0, size.height), Offset(0, 0), [
          mainColor.withOpacity(0.0),
          mainColor.withOpacity(opacity),
        ])
        ..style = PaintingStyle.fill;

      canvas.drawPath(path, wavePaint);
    }

    for (var w in waves) {
      drawWave(w["height"], w["count"], w["speed"], w["opacity"]);
    }
  }

  @override
  bool shouldRepaint(covariant _SOCPainter oldDelegate) => true;
}
