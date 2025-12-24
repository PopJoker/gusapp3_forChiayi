import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../utils/theme_colors.dart';
import '../../utils/api_service.dart';
import 'package:intl/intl.dart';
import '../../l10n/l10n.dart';

class HistoryDataWidget extends StatefulWidget {
  const HistoryDataWidget({
    super.key,
    required this.model,
    required this.serialNum,
  });

  final String model;
  final String serialNum;

  @override
  State<HistoryDataWidget> createState() => _HistoryDataWidgetState();
}

class _HistoryDataWidgetState extends State<HistoryDataWidget> {
  List<Map<String, dynamic>> historyData = [];
  List<Map<String, dynamic>> hourlySoc = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final result = await ApiService.getDeviceSummary(widget.serialNum);
    if (result != null) {
      // hourly SOC
      hourlySoc = List<Map<String, dynamic>>.from(result["hourlySoc"] ?? []);

      // daily energy & income
      historyData = List<Map<String, dynamic>>.from(result["dailyEnergy"] ?? [])
          .map((e) {
            final double charge = (e["chg"] ?? 0).toDouble();
            final double discharge = (e["dsg"] ?? 0).toDouble();
            final double revenue = (e["income"] ?? 0).toDouble();

            return {
              "date": e["date"],
              "ChargePower": double.parse(charge.toStringAsFixed(2)),
              "DischargePower": double.parse(discharge.toStringAsFixed(2)),
              "Revenue": double.parse(revenue.toStringAsFixed(2)),
            };
          })
          .toList();
    }
    setState(() => loading = false);
  }
  
  Color neonColor(bool isDark, String type) {
    switch (type) {
      case 'SOC':
        return isDark ? Colors.cyanAccent : Colors.blueAccent;
      case 'ChargePower':
        return isDark ? Colors.purpleAccent : Colors.purple;
      case 'DischargePower':
        return isDark ? Colors.redAccent : Colors.red;
      case 'Revenue':
        return isDark ? Colors.orangeAccent : Colors.orange;
      default:
        return isDark ? Colors.white : Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = ThemeProvider.themeMode.value == ThemeMode.dark;

    if (loading) return const Center(child: CircularProgressIndicator());

    if (historyData.isEmpty && hourlySoc.isEmpty) {
      return Center(child: Text(S.of(context)!.noHistoryData));
    }

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: [
              _buildSocChart(isDark),
              _buildPowerChart(isDark),
              _buildRevenueChart(isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocChart(bool isDark) {
    if (hourlySoc.isEmpty) return const SizedBox.shrink();

    List<Map<String, dynamic>> sortedData = List.from(hourlySoc)
      ..sort(
        (a, b) => DateTime.parse(
          a['timestamp'],
        ).compareTo(DateTime.parse(b['timestamp'])),
      );

    List<FlSpot> spots = sortedData.asMap().entries.map((e) {
      double x = e.key.toDouble();
      double y = (e.value['soc'] ?? 0).toDouble();
      return FlSpot(x, y);
    }).toList();

    Color bgColor = isDark ? Colors.grey[900]! : Colors.white;
    Color shadowColor = isDark ? Colors.black54 : Colors.grey.withOpacity(0.2);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context)!.socChart,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: neonColor(isDark, 'SOC'),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 220,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 10,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index < 0 || index >= sortedData.length)
                          return const SizedBox();
                        DateTime dt = DateTime.parse(
                          sortedData[index]['timestamp'],
                        ).toUtc().add(const Duration(hours: 8));
                        return Text(
                          DateFormat('HH:mm').format(dt),
                          style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.black54,
                            fontSize: 12,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: neonColor(isDark, 'SOC'),
                    barWidth: 3,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          neonColor(isDark, 'SOC').withOpacity(0.3),
                          Colors.transparent,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPowerChart(bool isDark) {
    if (historyData.isEmpty) return const SizedBox.shrink();

    Color bgColor = isDark ? Colors.grey[900]! : Colors.white;
    Color shadowColor = isDark ? Colors.black54 : Colors.grey.withOpacity(0.2);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
             S.of(context)!.powerChart,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: neonColor(isDark, 'ChargePower'),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 220,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceBetween,
                groupsSpace: 16,
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index < 0 || index >= historyData.length)
                          return const SizedBox();
                        String dateStr = historyData[index]['date'] ?? "";
                        DateTime dt =
                            DateTime.tryParse(dateStr) ?? DateTime.now();
                        return Text(
                          "${dt.month}/${dt.day}",
                          style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.black54,
                            fontSize: 12,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                barGroups: historyData.asMap().entries.map((e) {
                  double charge = e.value['ChargePower'].toDouble();
                  double discharge = e.value['DischargePower'].toDouble();
                  return BarChartGroupData(
                    x: e.key,
                    barRods: [
                      BarChartRodData(
                        toY: charge,
                        color: neonColor(isDark, 'ChargePower'),
                        width: 14,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      BarChartRodData(
                        toY: discharge,
                        color: neonColor(isDark, 'DischargePower'),
                        width: 14,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueChart(bool isDark) {
    if (historyData.isEmpty) return const SizedBox.shrink();

    double totalRevenue = historyData.fold(
      0,
      (sum, e) => sum + (e['Revenue'] as double),
    );

    Color bgColor = isDark ? Colors.grey[900]! : Colors.white;
    Color shadowColor = isDark ? Colors.black54 : Colors.grey.withOpacity(0.2);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${S.of(context)!.revenueChart} ${S.of(context)!.totalRevenue}: ${totalRevenue.toStringAsFixed(1)} ${S.of(context)!.currency}", 
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: neonColor(isDark, 'Revenue'),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 220,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceBetween,
                groupsSpace: 16,
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index < 0 || index >= historyData.length)
                          return const SizedBox();
                        String dateStr = historyData[index]['date'] ?? "";
                        DateTime dt =
                            DateTime.tryParse(dateStr) ?? DateTime.now();
                        return Text(
                          "${dt.month}/${dt.day}",
                          style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.black54,
                            fontSize: 12,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                barGroups: historyData.asMap().entries.map((e) {
                  double revenue = e.value['Revenue'].toDouble();
                  return BarChartGroupData(
                    x: e.key,
                    barRods: [
                      BarChartRodData(
                        toY: revenue,
                        color: neonColor(isDark, 'Revenue'),
                        width: 18,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
