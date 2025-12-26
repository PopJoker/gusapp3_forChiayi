import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../utils/theme_colors.dart';
import '../../utils/api_service.dart';
import 'package:intl/intl.dart';
import '../../l10n/l10n.dart';
import '../../utils/refresh_timer.dart';

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

    // 訂閱 RealtimeService
    RealtimeService().subscribe(widget.serialNum, _onDataReceived);

    // 如果想要第一次就拉一次資料，可以先 fetch
    _fetchData();
  }

  void _onDataReceived(Map<String, dynamic> data) {
    if (!mounted) return;

    // 只更新 hourly SOC 最後一筆
    Map<String, dynamic> lastHourSoc = {};
    data.forEach((key, value) {
      if (key.contains('_soc')) lastHourSoc[key] = value;
    });

    setState(() {
      if (hourlySoc.isNotEmpty) {
        hourlySoc[hourlySoc.length - 1].addAll(lastHourSoc);
      }
    });
  }


  @override
  void dispose() {
    RealtimeService().unsubscribe(widget.serialNum, _onDataReceived);
    super.dispose();
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
            ],
          ),
        ),
      ),
    );
  }

  /// --- SOC 線圖（每個 Storage + 平均線 + 圖例） ---
Widget _buildSocChart(bool isDark) {
  if (hourlySoc.isEmpty) return const SizedBox.shrink();

  List<Map<String, dynamic>> sortedData = List.from(hourlySoc)
    ..sort((a, b) => DateTime.parse(a['timestamp']).compareTo(DateTime.parse(b['timestamp'])));

  // 找出所有 Storage 名稱
  List<String> storages = [];
  if (sortedData.isNotEmpty) {
    sortedData.first.keys.forEach((k) {
      if (k.endsWith('_soc')) storages.add(k);
    });
  }

  // 每個 Storage 的 FlSpot
  Map<String, List<FlSpot>> storageSpots = {};
  storages.forEach((s) {
    storageSpots[s] = sortedData.asMap().entries.map((e) {
      double x = e.key.toDouble();
      double y = (e.value[s] ?? 0).toDouble();
      return FlSpot(x, y);
    }).toList();
  });

  // 平均線
  List<FlSpot> avgSpots = sortedData.asMap().entries.map((e) {
    double x = e.key.toDouble();
    double sum = 0;
    int count = 0;
    storages.forEach((s) {
      if (e.value[s] != null) {
        sum += (e.value[s] as num).toDouble();
        count++;
      }
    });
    return FlSpot(x, count > 0 ? sum / count : 0);
  }).toList();

  Color bgColor = isDark ? Colors.grey[900]! : Colors.white;
  Color shadowColor = isDark ? Colors.black54 : Colors.grey.withOpacity(0.2);

  // 顏色對應 Storage
  List<Color> storageColors = [const Color.fromARGB(255, 252, 49, 252), Colors.blue, Colors.green, Colors.orange];

  return _buildChartContainer(
      bgColor,
      shadowColor,
      title: S.of(context)!.socChart,
      titleColor: neonColor(isDark, 'SOC'),
      child: Column(
        children: [
          SizedBox(
            height: 220,
            child: LineChart(
              LineChartData(
                minY: 0,      
                maxY: 100,
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index < 0 || index >= sortedData.length) return const SizedBox();
                        DateTime dt = DateTime.parse(sortedData[index]['timestamp']).toLocal();
                        return Text(DateFormat('HH:mm').format(dt),
                            style: TextStyle(color: isDark ? Colors.white70 : Colors.black54, fontSize: 12));
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                lineBarsData: [
                  // 各 Storage 線
                  ...storages.asMap().entries.map((e) {
                    String s = e.value;
                    Color c = e.key < storageColors.length ? storageColors[e.key] : Colors.grey;
                    return LineChartBarData(
                      spots: storageSpots[s]!,
                      isCurved: true,
                      color: c,
                      barWidth: 2,
                      dotData: FlDotData(show: false),
                    );
                  }),
                  // 平均線
                  LineChartBarData(
                    spots: avgSpots,
                    isCurved: true,
                    color: Colors.grey,
                    barWidth: 3,
                    dotData: FlDotData(show: false),
                    dashArray: [5, 5],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          // 圖例 Legend
          Wrap(
            spacing: 12,
            runSpacing: 4,
            children: [
              ...storages.asMap().entries.map((e) {
                String s = e.value;
                Color c = e.key < storageColors.length ? storageColors[e.key] : Colors.grey;
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(width: 12, height: 12, color: c),
                    const SizedBox(width: 4),
                    Text(s.replaceAll('_soc', ''), style: TextStyle(color: isDark ? Colors.white70 : Colors.black54)),
                  ],
                );
              }),
              // 平均線圖例
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 12, height: 2, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(S.of(context)!.average, style: TextStyle(color: isDark ? Colors.white70 : Colors.black54)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }


  /// --- Charge / Discharge 柱狀圖 ---
  Widget _buildPowerChart(bool isDark) {
    if (historyData.isEmpty) return const SizedBox.shrink();

    Color bgColor = isDark ? Colors.grey[900]! : Colors.white;
    Color shadowColor = isDark ? Colors.black54 : Colors.grey.withOpacity(0.2);

    return _buildChartContainer(
      bgColor,
      shadowColor,
      title: S.of(context)!.powerChart,
      titleColor: neonColor(isDark, 'ChargePower'),
      child: SizedBox(
        height: 220,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceBetween,
            groupsSpace: 16,
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    int index = value.toInt();
                    if (index < 0 || index >= historyData.length) return const SizedBox();
                    DateTime dt = DateTime.tryParse(historyData[index]['date'])?.toLocal() ?? DateTime.now();
                    return Text("${dt.month}/${dt.day}", style: TextStyle(color: isDark ? Colors.white70 : Colors.black54, fontSize: 12));
                  },
                ),
              ),
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            barGroups: historyData.asMap().entries.map((e) {
              return BarChartGroupData(
                x: e.key,
                barRods: [
                  BarChartRodData(toY: e.value['ChargePower'].toDouble(), color: neonColor(isDark, 'ChargePower'), width: 14, borderRadius: BorderRadius.circular(6)),
                  BarChartRodData(toY: e.value['DischargePower'].toDouble(), color: neonColor(isDark, 'DischargePower'), width: 14, borderRadius: BorderRadius.circular(6)),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  /// --- Revenue 柱狀圖 ---
  Widget _buildRevenueChart(bool isDark) {
    if (historyData.isEmpty) return const SizedBox.shrink();

    double totalRevenue = historyData.fold(0, (sum, e) => sum + (e['Revenue'] as double));

    Color bgColor = isDark ? Colors.grey[900]! : Colors.white;
    Color shadowColor = isDark ? Colors.black54 : Colors.grey.withOpacity(0.2);

    return _buildChartContainer(
      bgColor,
      shadowColor,
      title: "${S.of(context)!.revenueChart} ${S.of(context)!.totalRevenue}: ${totalRevenue.toStringAsFixed(1)} ${S.of(context)!.currency}",
      titleColor: neonColor(isDark, 'Revenue'),
      child: SizedBox(
        height: 220,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceBetween,
            groupsSpace: 16,
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    int index = value.toInt();
                    if (index < 0 || index >= historyData.length) return const SizedBox();
                    DateTime dt = DateTime.tryParse(historyData[index]['date'])?.toLocal() ?? DateTime.now();
                    return Text("${dt.month}/${dt.day}", style: TextStyle(color: isDark ? Colors.white70 : Colors.black54, fontSize: 12));
                  },
                ),
              ),
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            barGroups: historyData.asMap().entries.map((e) {
              return BarChartGroupData(
                x: e.key,
                barRods: [
                  BarChartRodData(toY: e.value['Revenue'].toDouble(), color: neonColor(isDark, 'Revenue'), width: 18, borderRadius: BorderRadius.circular(6)),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  /// --- 共用 Chart 容器 ---
  Widget _buildChartContainer(Color bgColor, Color shadowColor, {required String title, required Color titleColor, required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: shadowColor, blurRadius: 12, offset: const Offset(0, 6))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: titleColor)),
        const SizedBox(height: 12),
        child,
      ]),
    );
  }
}
