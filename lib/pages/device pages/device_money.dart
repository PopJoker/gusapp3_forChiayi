import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../utils/theme_colors.dart';
import '../../widget/money_bottom.dart';
import '../device pages/device_set.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../l10n/l10n.dart';
import '../../utils/api_service.dart';

class RevenuePageWidget extends StatefulWidget {
  const RevenuePageWidget({super.key, required this.site});
  final Map<String, dynamic> site;

  @override
  State<RevenuePageWidget> createState() => _RevenuePageWidgetState();
}

class _RevenuePageWidgetState extends State<RevenuePageWidget>
    with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> last7DaysRevenue = [];
  late final AnimationController _controller;
  int? dailyTarget;
  int? monthlyTarget;

  Future<void> fetchRevenue() async {
    final result = await ApiService.getDeviceNowData(
      widget.site['model'],
      widget.site['serial_number'],
    );
    if (result['status'] == 200) {
      final income = result['data']['income'];
      if (income != null) {
        final List last7 = income['last7Days'] ?? [];
        final monthRevenue = (income['month'] as num?)?.toDouble() ?? 0.0;

        last7DaysRevenue.clear();
        for (var day in last7) {
          last7DaysRevenue.add({
            'dayRevenue': (day['income'] as num?)?.toDouble() ?? 0.0,
            'monthRevenue': monthRevenue,
          });
        }
      }

      if (mounted) setState(() {});
    }
  }


  @override
  void initState() {
    super.initState();
    fetchRevenue();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();

    _loadSavedTargetsAndSetState();
    _loadRevenueFromNowData();
  }

  Future<void> _loadSavedTargetsAndSetState() async {
    final prefs = await SharedPreferences.getInstance();
    int savedDaily =
        prefs.getInt('${widget.site['serial_number']}_dailyTarget') ?? 80;
    int savedMonthly =
        prefs.getInt('${widget.site['serial_number']}_monthlyTarget') ?? 1000;

    if (!mounted) return;

    setState(() {
      dailyTarget = savedDaily;
      monthlyTarget = savedMonthly;
    });
  }

  void _loadRevenueFromNowData() {
    final income = widget.site['data']?['income'];
    if (income == null) return;

    final List last7 = income['last7Days'] ?? [];
    final monthRevenue = (income['month'] as num?)?.toDouble() ?? 0.0;

    last7DaysRevenue.clear();
    for (var day in last7) {
      last7DaysRevenue.add({
        'dayRevenue': (day['income'] as num?)?.toDouble() ?? 0.0,
        'monthRevenue': monthRevenue,
      });
    }

    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void openSettings() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SettingPageWidget(
          model: widget.site['model'],
          serialNum: widget.site['serial_number'],
          initialDailyTarget: dailyTarget ?? 80,
          initialMonthlyTarget: monthlyTarget ?? 1000,
        ),
      ),
    );

    await _loadSavedTargetsAndSetState();

    if (result != null) {
      setState(() {
        dailyTarget = result['dailyTarget'];
        monthlyTarget = result['monthlyTarget'];
      });
    }
  }

  Color neonColor(bool isDark, String type) {
    switch (type) {
      case 'DayRevenue':
        return isDark ? Colors.orangeAccent : Colors.orange;
      case 'MonthRevenue':
        return isDark ? Colors.purpleAccent : Colors.purple;
      default:
        return isDark ? Colors.white : Colors.black;
    }
  }

  Widget buildMiniCard({
    required String title,
    required String value,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
              shadows: [Shadow(blurRadius: 10, color: color)],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBarChartWithBorder(bool isDark) {
    if (dailyTarget == null || last7DaysRevenue.isEmpty) return const SizedBox();

    // 計算最大值，保證目標線可見
    final maxDayRevenue = last7DaysRevenue
        .map((e) => (e['dayRevenue'] as double?)?.toInt() ?? 0)
        .reduce((a, b) => a > b ? a : b);
    final maxY = (dailyTarget! > maxDayRevenue ? dailyTarget! + 10 : maxDayRevenue + 10).toDouble();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              neonColor(isDark, 'DayRevenue'),
              neonColor(isDark, 'MonthRevenue'),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: isDark
                  ? const LinearGradient(
                      colors: [Colors.black, Colors.black],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : LinearGradient(
                      colors: [Colors.white, Colors.grey.shade100],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    S.of(context)!.dailyRevenue,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
                Expanded(
                  child: BarChart(
                    BarChartData(
                      maxY: maxY,
                      alignment: BarChartAlignment.spaceAround,
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            return BarTooltipItem(
                              "${S.of(context)!.day} ${groupIndex + 1}: ${rod.toY.toInt()} ${S.of(context)!.currency}",
                              const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                      ),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 20,
                            getTitlesWidget: (value, meta) => Text(
                              value.toInt().toString(),
                              style: TextStyle(
                                fontSize: 10,
                                color: isDark ? Colors.white54 : Colors.black45,
                              ),
                            ),
                            reservedSize: 28,
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              int index = value.toInt();
                              if (index < 0 || index >= 7) return const SizedBox();
                              return Text(
                                "${S.of(context)!.dayShort}${index + 1}",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark ? Colors.white70 : Colors.black54,
                                ),
                              );
                            },
                            reservedSize: 28,
                          ),
                        ),
                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      gridData: FlGridData(
                        show: true,
                        drawHorizontalLine: true,
                        getDrawingHorizontalLine: (value) =>
                            const FlLine(color: Colors.white12, strokeWidth: 1),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: last7DaysRevenue
                          .asMap()
                          .entries
                          .map(
                            (e) => BarChartGroupData(
                              x: e.key,
                              barRods: [
                                BarChartRodData(
                                  toY: (e.value['dayRevenue'] as double?)?.toInt().toDouble() ?? 0,
                                  color: neonColor(isDark, 'DayRevenue'),
                                  width: 16,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                      extraLinesData: ExtraLinesData(
                        horizontalLines: [
                          HorizontalLine(
                            y: dailyTarget!.toDouble(),
                            color: Colors.redAccent,
                            strokeWidth: 2,
                            dashArray: [5, 5],
                            label: HorizontalLineLabel(
                              show: true,
                              alignment: Alignment.topCenter,
                              padding: const EdgeInsets.only(bottom: 6),
                              labelResolver: (_) =>
                                  '${S.of(context)!.dailyTarget} $dailyTarget',
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                shadows: [
                                  Shadow(
                                    color: Colors.redAccent.withOpacity(0.7),
                                    blurRadius: 8,
                                    offset: const Offset(0, 0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    }
    
  @override
  Widget build(BuildContext context) {
    bool isDark = ThemeProvider.themeMode.value == ThemeMode.dark;

    if (dailyTarget == null || monthlyTarget == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return SafeArea(
      child: Column(
        children: [
          Flexible(
            flex: 3,
            child: GestureDetector(
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 4,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
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
                    boxShadow: [
                      BoxShadow(
                        color: neonColor(isDark, 'DayRevenue').withOpacity(0.4),
                        blurRadius: 30,
                        spreadRadius: 3,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            return Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.003)
                                ..rotateY(_controller.value * 2 * 3.1415),
                              child: Text(
                                "\$", 
                                style: TextStyle(
                                  fontSize: 100,
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? const Color.fromARGB(255, 255, 215, 0)
                                      : const Color.fromARGB(255, 230, 190, 20),
                                  shadows: [
                                    Shadow(
                                        blurRadius: 10,
                                        color: isDark
                                            ? const Color.fromARGB(255, 255, 215, 0)
                                            : const Color.fromARGB(255, 230, 190, 20),
                                        offset: const Offset(0, 0)),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        left: 16,
                        bottom: 16,
                        child: buildMiniCard(
                          title: S.of(context)!.todayRevenue,
                          value:
                            "${(last7DaysRevenue.isNotEmpty ? (last7DaysRevenue.last['dayRevenue'] as double?)?.toInt() ?? 0 : 0)} ${S.of(context)!.currency}",
                          color: neonColor(isDark, 'DayRevenue'),
                          isDark: isDark,
                        ),
                      ),
                      Positioned(
                        right: 16,
                        bottom: 16,
                        child: buildMiniCard(
                          title: S.of(context)!.monthRevenue,
                          value:
                            "${(last7DaysRevenue.isNotEmpty ? (last7DaysRevenue.last['monthRevenue'] as double?)?.toInt() ?? 0 : 0)} ${S.of(context)!.currency}",
                          color: neonColor(isDark, 'MonthRevenue'),
                          isDark: isDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 6,
            child: buildBarChartWithBorder(isDark),
          ),
          Flexible(
            flex: 3,
            child: BottomRevenueCard(
              isDark: isDark,
              last7DaysRevenue: last7DaysRevenue,
              dailyTarget: dailyTarget!,
              monthlyTarget: monthlyTarget!,
            ),
          ),
        ],
      ),
    );
  }
}
