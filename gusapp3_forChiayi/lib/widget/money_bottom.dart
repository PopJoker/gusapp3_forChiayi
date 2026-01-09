import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../l10n/l10n.dart';

class BottomRevenueCard extends StatelessWidget {
  final bool isDark;
  final List<Map<String, dynamic>> last7DaysRevenue;
  final int dailyTarget;
  final int monthlyTarget;
  
  const BottomRevenueCard({
    super.key,
    required this.isDark,
    required this.last7DaysRevenue,
    this.dailyTarget = 0,
    this.monthlyTarget = 0,
  });

  @override
  Widget build(BuildContext context) {
    final S locale = S.of(context)!;

    Color neonDay = isDark ? Colors.orangeAccent : Colors.orange;
    Color neonMonth = isDark ? Colors.purpleAccent : Colors.purple;

    double todayAccum = last7DaysRevenue.last['dayRevenue'].toDouble();
    double todayEstimate = dailyTarget.toDouble();
    double monthAccum = last7DaysRevenue.last['monthRevenue'].toDouble();
    double monthEstimate = monthlyTarget.toDouble();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // 今日預估
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: isDark
                    ? const LinearGradient(
                        colors: [Colors.black87, Colors.black54],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : LinearGradient(
                        colors: [Colors.white, Colors.grey.shade100],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                border: Border.all(color: isDark ? Colors.white24 : Colors.black26),
                boxShadow: [
                  BoxShadow(
                    color: neonDay.withOpacity(0.5),
                    blurRadius: 12,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    locale.dailyTargetLabel,
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold, color: neonDay),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "${todayEstimate.toInt()} \$",
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: neonDay,
                        shadows: [Shadow(color: neonDay, blurRadius: 8)]),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: (todayAccum / todayEstimate).clamp(0, 1),
                    color: neonDay,
                    backgroundColor: Colors.white12,
                    minHeight: 8,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    locale.dailyAccum(todayAccum.toInt()),
                    style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white54 : Colors.black45),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          // 本月預估
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: isDark
                    ? const LinearGradient(
                        colors: [Colors.black87, Colors.black54],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : LinearGradient(
                        colors: [Colors.white, Colors.grey.shade100],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                border: Border.all(color: isDark ? Colors.white24 : Colors.black26),
                boxShadow: [
                  BoxShadow(
                    color: neonMonth.withOpacity(0.5),
                    blurRadius: 12,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    locale.monthlyTargetLabel,
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold, color: neonMonth),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "${monthEstimate.toInt()} \$",
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: neonMonth,
                        shadows: [Shadow(color: neonMonth, blurRadius: 8)]),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: (monthAccum / monthEstimate).clamp(0, 1),
                    color: neonMonth,
                    backgroundColor: Colors.white12,
                    minHeight: 8,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    locale.monthlyAccum(monthAccum.toInt()),
                    style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white54 : Colors.black45),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
