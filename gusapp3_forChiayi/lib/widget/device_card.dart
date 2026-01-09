import 'dart:math';
import 'package:flutter/material.dart';
import '../pages/device pages/device_home_page.dart';
import '../l10n/l10n.dart';

class AnimatedTeslaCard extends StatefulWidget {
  final Map<String, dynamic> site;
  final Color textPrimary;
  final Color textSecondary;
  final Color mainGreen;
  final Color dsgBlue;
  final AnimationController animation;

  const AnimatedTeslaCard({
    super.key,
    required this.site,
    required this.textPrimary,
    required this.textSecondary,
    required this.mainGreen,
    required this.dsgBlue,
    required this.animation,
  });

  @override
  State<AnimatedTeslaCard> createState() => _AnimatedTeslaCardState();
}

class _AnimatedTeslaCardState extends State<AnimatedTeslaCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _hoverAnimation;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _hoverAnimation = Tween<double>(begin: 0, end: 4).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  Color getStatusColor() {
    switch (widget.site['status']) {
      case 'CHG':
        return widget.mainGreen;
      case 'DSG':
        return widget.dsgBlue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    Color statusColor = getStatusColor();

    return AnimatedBuilder(
      animation: _hoverAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, sin(_hoverAnimation.value) * 2),
          child: GestureDetector(
            onTapDown: (_) => setState(() => _pressed = true),
            onTapUp: (_) {
              setState(() => _pressed = false);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DataHomePage(site: widget.site),
                ),
              );
            },
            onTapCancel: () => setState(() => _pressed = false),
            child: Transform.scale(
              scale: _pressed ? 0.97 : 1.0,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: Theme.of(context).brightness == Brightness.dark
                        ? [Colors.grey[850]!, Colors.grey[900]!]
                        : [
                            Colors.white,
                            const Color.fromARGB(151, 219, 219, 219),
                          ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // -------------------------
                    // SOC / 剩餘時間 / SOH 區塊 (直向)
                    // -------------------------
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // SOC
                        AnimatedBuilder(
                          animation: widget.animation,
                          builder: (context, child) {
                            return CustomPaint(
                              size: const Size(70, 70),
                              painter: GradientCircularPainter(
                                percentage: widget.site['soc'] / 100,
                                gradient: SweepGradient(
                                  colors: [
                                    statusColor,
                                    statusColor.withOpacity(0.3),
                                  ],
                                  startAngle: 0.0,
                                  endAngle: 2 * pi,
                                  transform: GradientRotation(
                                    widget.animation.value * 2 * pi,
                                  ),
                                ),
                              ),
                              child: SizedBox(
                                width: 70,
                                height: 70,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        widget.site['status'] == 'CHG'
                                            ? Icons.bolt
                                            : widget.site['status'] == 'DSG'
                                                ? Icons.power
                                                : Icons.pause,
                                        color: statusColor,
                                        size: 20,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${widget.site['soc']}%',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: widget.textPrimary,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 15),

                        // SOH
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              CircularProgressIndicator(
                                value: widget.site['soh'] / 100,
                                strokeWidth: 6,
                                backgroundColor: Colors.red.withOpacity(0.2),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.red,
                                ),
                              ),
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                      size: 16,
                                    ),
                                    Text(
                                      '${widget.site['soh']}%',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: widget.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10, width: 100),

                        // 剩餘時間 (動態顯示)
                        if (widget.site['status'] == 'CHG' ||
                            widget.site['status'] == 'DSG')
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 20,
                                color: widget.textSecondary,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                widget.site['status'] == 'CHG'
                                    ? '${S.of(context)!.timeToFull}: ${widget.site['remaining']}h'
                                    : '${S.of(context)!.timeToEmpty}: ${widget.site['remaining']}h',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: widget.textPrimary,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    // -------------------------
                    // 資訊區
                    // -------------------------
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.site['name'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: widget.textPrimary,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  widget.site['status'],
                                  style: TextStyle(
                                    color: statusColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${S.of(context)!.serialNumber}: ${widget.site['serial_number']}',
                            style: TextStyle(
                              fontSize: 11,
                              color: widget.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          // 2x2 InfoChip 排版
                          Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: InfoChip(
                                      icon: Icons.attach_money,
                                      label: S.of(context)!.dayIncome,
                                      value: '\$${widget.site['day_income']}',
                                      color: Colors.orangeAccent,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: InfoChip(
                                      icon: Icons.calendar_today,
                                      label: S.of(context)!.monthIncome,
                                      value: '\$${widget.site['month_income']}',
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: InfoChip(
                                      icon: Icons.bolt,
                                      label: S.of(context)!.dayCharge,
                                      value: '${widget.site['chgday']} kW',
                                      color: widget.mainGreen,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: InfoChip(
                                      icon: Icons.power,
                                      label: S.of(context)!.dayDischarge,
                                      value: '${widget.site['dsgday']} kW',
                                      color: widget.dsgBlue,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class InfoChip extends StatelessWidget {
  final IconData icon;
  final String label; // 右上文字
  final String value; // 右下數值
  final Color color;

  const InfoChip({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
Widget build(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: color),
            // 右上文字
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: DeviceCardColorExtension(color).darken(0.2),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        // 右下數值
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: DeviceCardColorExtension(color).darken(0.1),
            ),
          ),
        ),
      ],
    ),
  );
}
}
// 顏色擴展方法
extension DeviceCardColorExtension on Color {
  Color darken([double amount = .1]) {
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}

// -------------------------
// SOC/SOH 圓環動畫
// -------------------------
class GradientCircularPainter extends CustomPainter {
  final double percentage;
  final Gradient gradient;

  GradientCircularPainter({required this.percentage, required this.gradient});

  @override
  void paint(Canvas canvas, Size size) {
    double strokeWidth = 10;
    Rect rect = Offset.zero & size;
    Paint base = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    Paint progress = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      -pi / 2,
      2 * pi,
      false,
      base,
    );
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      -pi / 2,
      2 * pi * percentage,
      false,
      progress,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
