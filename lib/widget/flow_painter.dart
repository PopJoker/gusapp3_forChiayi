import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'dart:math';

class FlowPainter extends CustomPainter {
  bool isCharging;
  Map<String, dynamic>? pcsStatus;
  final Animation<double> animation;
  bool isDark; // 主題開關
  final String modeName;

  FlowPainter({
    required this.isCharging,
    this.pcsStatus,
    required this.animation,
    this.isDark = false,
    required this.modeName,
  }) : super(repaint: animation);

  final int pointCount = 16;
  final double tailSpacing = 0.04; // 尾巴點間距縮小
  final double nodeRadius = 24; // 節點半徑

  // 節點位置
  late Offset solar;
  late Offset pcs;
  late Offset bat;
  late Offset grid;
  late Offset load;

  late Map<String, Offset> nodes;

  void _initPositions(Size size) {
    solar = Offset(size.width * 0.15, size.height * 0.25);
    pcs = Offset(size.width * 0.5, size.height * 0.25);
    bat = Offset(size.width * 0.85, size.height * 0.25);
    grid = Offset(size.width * 0.3, size.height * 0.7);
    load = Offset(size.width * 0.7, size.height * 0.7);

    nodes = {
      "Solar": solar,
      "PCS": pcs,
      "BAT": bat,
      "Grid": grid,
      "Load": load,
    };
  }

  void _drawBackground(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // 背景漸層
    final bgGradient = isDark
        ? ui.Gradient.linear(Offset(0, 0), Offset(size.width, size.height), [
            const Color.fromARGB(25, 30, 30, 30),
            const Color.fromARGB(15, 0, 0, 0),
          ])
        : ui.Gradient.linear(Offset(0, 0), Offset(size.width, size.height), [
            const ui.Color.fromARGB(32, 200, 230, 255),
            const ui.Color.fromARGB(26, 240, 250, 255),
          ]);

    final paint = Paint()..shader = bgGradient;
    canvas.drawRect(rect, paint);

    if (isDark) {
      // 星星
      final starPaint = Paint()..color = Colors.white54;
      final rand = Random(42);
      for (int i = 0; i < 100; i++) {
        final x = rand.nextDouble() * size.width;
        final y = rand.nextDouble() * size.height;
        final radius = rand.nextDouble() * 1.5;
        canvas.drawCircle(Offset(x, y), radius, starPaint);
      }
    } else {
      // 雲朵
      final cloudPaint = Paint()..color = Colors.white.withOpacity(0.4);
      final rand = Random(42);
      for (int i = 0; i < 15; i++) {
        final x = rand.nextDouble() * size.width;
        final y = size.height * 0.3 + rand.nextDouble() * size.height * 0.4; 
        // 將雲朵起始 y 軸改到中間偏下
        final cloudWidth = 60 + rand.nextDouble() * 80;
        final cloudHeight = 20 + rand.nextDouble() * 30;

        for (int j = 0; j < 5; j++) {
          final offsetX = x + j * (cloudWidth / 5);
          final offsetY = y + (j % 2) * 5;
          final radius = cloudHeight * (0.8 + rand.nextDouble() * 0.4);
          canvas.drawCircle(Offset(offsetX, offsetY), radius, cloudPaint);
        }
      }
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    _initPositions(size);

    // 背景
    _drawBackground(canvas, size);

    // 電池方向
    double batteryVal = double.tryParse(
        pcsStatus?['Batterypowerdirection']?.toString() ?? "0.0") ?? 0.0;
    int batteryDir = batteryVal.toInt(); // 直接轉成 int

    // DC/AC 線路方向
    double dcacVal = double.tryParse(
        pcsStatus?['Linepowerdirection']?.toString() ?? "0.0") ?? 0.0;
    int dcacDir = dcacVal.toInt(); // 直接轉成 int

    // 太陽能板 1 工作狀態
    double solar1Val = double.tryParse(
        pcsStatus?['Solar']?['input1']?['workStatus']?.toString() ?? "0.0") ?? 0.0;
    bool solar1Active = solar1Val != 0; // 直接轉 int

    // 太陽能板 2 工作狀態
    double solar2Val = double.tryParse(
        pcsStatus?['Solar']?['input2']?['workStatus']?.toString() ?? "0.0") ?? 0.0;
    bool solar2Active = solar2Val != 0; // 直接轉 int



    Map<String, double> curveHeights = {
      "solar1": 50,
      "solar2": 30,
      "bat_to_pcs": 40,
      "pcs_to_bat": 25,
      "grid_to_pcs": 60,
      "pcs_to_grid": 45,
      "pcs_to_load": 50,
      "load_to_pcs": 40,
    };

    List<Color> _getColors(Color base) {
      return isDark
          ? [Colors.white, Colors.white]  // 深色模式白線
          : [Colors.black, Colors.black]; // 淺色模式黑線
    }


    // 流向線
    void drawFlowLine(
      Offset start,
      Offset end,
      bool active,
      List<Color> colors, {
      double curveHeight = 40,
      double strokeWidth = 4,
      bool arrow = true,
    }) {
      final path = Path()
        ..moveTo(start.dx, start.dy)
        ..quadraticBezierTo(
          (start.dx + end.dx) / 2,
          (start.dy + end.dy) / 2 - curveHeight,
          end.dx,
          end.dy,
        );

      final linePaint = Paint()
        ..shader = ui.Gradient.linear(start, end, colors)
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke;
      canvas.drawPath(path, linePaint);

      if (!active) return;

      Offset bezierPoint(double t) {
        final c = Offset(
          (start.dx + end.dx) / 2,
          (start.dy + end.dy) / 2 - curveHeight,
        );
        return Offset(
          (1 - t) * (1 - t) * start.dx +
              2 * (1 - t) * t * c.dx +
              t * t * end.dx,
          (1 - t) * (1 - t) * start.dy +
              2 * (1 - t) * t * c.dy +
              t * t * end.dy,
        );
      }

      for (int i = 0; i < pointCount; i++) {
        double t = (animation.value - i * tailSpacing) % 1.0;
        final pos = bezierPoint(t);
        final opacity = (1 - i / pointCount) * 0.9 + 0.1;
        final pointPaint = Paint()
          ..shader = ui.Gradient.radial(
            pos,
            6,
            colors.map((c) => c.withOpacity(opacity)).toList(),
          )
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;
        canvas.drawPoints(ui.PointMode.points, [pos], pointPaint);

        if (arrow && i == 0) {
          final next = bezierPoint((t + 0.02) % 1.0);
          final angle = atan2(next.dy - pos.dy, next.dx - pos.dx);
          final arrowSize = 6.0;
          final arrowPath = Path()
            ..moveTo(pos.dx, pos.dy)
            ..lineTo(
              pos.dx - arrowSize * cos(angle - pi / 6),
              pos.dy - arrowSize * sin(angle - pi / 6),
            )
            ..moveTo(pos.dx, pos.dy)
            ..lineTo(
              pos.dx - arrowSize * cos(angle + pi / 6),
              pos.dy - arrowSize * sin(angle + pi / 6),
            );
          final arrowPaint = Paint()
            ..color = isDark ? const Color.fromARGB(255, 0, 255, 0) : Colors.green
            ..strokeWidth = strokeWidth
            ..style = PaintingStyle.stroke;
          canvas.drawPath(arrowPath, arrowPaint);

        }
      }
    }

    drawFlowLine(
      solar,
      pcs,
      solar1Active,
      _getColors(Colors.yellow),
      curveHeight: curveHeights["solar1"]!,
    );
    drawFlowLine(
      solar,
      pcs,
      solar2Active,
      _getColors(Colors.orange),
      curveHeight: curveHeights["solar2"]!,
    );
    drawFlowLine(
      pcs,
      bat,
      batteryDir == 1,
      _getColors(Colors.green),
      curveHeight: curveHeights["bat_to_pcs"]!,
    );
    drawFlowLine(
      bat,
      pcs,
      batteryDir == 2,
      _getColors(Colors.orange),
      curveHeight: curveHeights["pcs_to_bat"]!,
    );

    if (dcacDir == 1) {
      drawFlowLine(
        grid,
        pcs,
        true,
        _getColors(Colors.blue),
        curveHeight: curveHeights["grid_to_pcs"]!,
      );
      drawFlowLine(
        pcs,
        load,
        true,
        _getColors(Colors.cyan),
        curveHeight: curveHeights["pcs_to_load"]!,
      );
    } else if (dcacDir == 2) {
      drawFlowLine(
        pcs,
        grid,
        true,
        _getColors(Colors.blue),
        curveHeight: curveHeights["pcs_to_grid"]!,
      );
      drawFlowLine(
        load,
        pcs,
        true,
        _getColors(Colors.cyan),
        curveHeight: curveHeights["load_to_pcs"]!,
      );
    }

    // 節點顏色
    Color _nodeColor(Color base) =>
        isDark ? const Color.fromARGB(255, 0, 255, 0) : Colors.green;

    // 節點光暈
    void _drawGlow(Offset pos, Color color) {
      final glowPaint = Paint()
        ..shader = ui.Gradient.radial(
          pos,
          nodeRadius * 2.0, // 光暈半徑略小
          [
            isDark
                ? color.withOpacity(0.5)   // 深色模式中心光暈亮
                : Colors.yellow.withOpacity(0.3), // 淺色模式淡黃色光暈
            isDark
                ? color.withOpacity(0.2)   // 深色模式中間淡化
                : Colors.yellow.withOpacity(0.1), // 淺色模式更淡
            Colors.transparent,           // 外圍透明
          ],
          [0.0, 0.5, 1.0],
        )
        ..style = PaintingStyle.fill;

      canvas.drawCircle(pos, nodeRadius * 2.0, glowPaint);
    }


    void drawNode(
      Offset pos,
      IconData icon,
      String label,
      Color color, {
      bool isTop = false,
    }) {
      _drawGlow(pos, color); // 光暈

      final textPainter = TextPainter(
        text: TextSpan(
          text: label,
          style: TextStyle(
            fontSize: 14,
            color: isDark ? Colors.white70 : Colors.black87,
          ),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      )..layout();

      final circlePaint = Paint()
        ..color = _nodeColor(color)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(pos, nodeRadius, circlePaint);

      final iconPainter = TextPainter(
        text: TextSpan(
          text: String.fromCharCode(icon.codePoint),
          style: TextStyle(
            fontSize: 36,
            fontFamily: icon.fontFamily,
            color: isDark
                ? const ui.Color.fromARGB(255, 73, 73, 73):Colors.white,
                
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      iconPainter.paint(
        canvas,
        Offset(pos.dx - iconPainter.width / 2, pos.dy - 18),
      );

      final labelOffsetY = isTop ? pos.dy - 40 : pos.dy + 30;
      textPainter.paint(
        canvas,
        Offset(pos.dx - textPainter.width / 2, labelOffsetY),
      );
    }

    drawNode(solar, Icons.wb_sunny, "Solar", _nodeColor(Colors.green));
    drawNode(pcs, Icons.memory, "PCS", _nodeColor(Colors.green));
    drawNode(bat, Icons.battery_full, "BAT", _nodeColor(Colors.green));
    drawNode(grid, Icons.electric_bolt, "Grid", _nodeColor(Colors.green), );
    drawNode(
      load,
      Icons.home_work_outlined,
      "Load",
      _nodeColor(Colors.green)
    );



    final modePainter = TextPainter(
      text: TextSpan(
        text: modeName,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white70 : Colors.black87,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
      maxLines: 1,
      ellipsis: "...",
    )..layout(minWidth: 0, maxWidth: 200); // 限制寬度


    modePainter.paint(
      canvas,
      Offset(pcs.dx - modePainter.width / 2, pcs.dy - 80),
    );
  }

  @override
  bool shouldRepaint(covariant FlowPainter oldDelegate) => true;

  String? checkNodeTap(Offset tapPos) {
    for (var entry in nodes.entries) {
      if ((tapPos - entry.value).distance <= nodeRadius + 6) {
        return entry.key;
      }
    }
    return null;
  }
}