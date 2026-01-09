import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../utils/theme_colors.dart';
import '../../../utils/api_service.dart';
import '../../../utils/refresh_timer.dart';
import '../../../l10n/l10n.dart';
import 'package:intl/intl.dart';

class HesDeviceDataWidget extends StatefulWidget {
  final String model;
  final String serialNum;

  const HesDeviceDataWidget({
    super.key,
    required this.model,
    required this.serialNum,
  });

  @override
  State<HesDeviceDataWidget> createState() => _DeviceDataWidgetState();
}

class _DeviceDataWidgetState extends State<HesDeviceDataWidget>
    with TickerProviderStateMixin {
  bool isCharging = true;

  Map<String, dynamic> fakeData = {
    "voltage": "55.811",
    "current": "-0.844",
    "SOC": "58.00",
    "temperature": "36.60",
    "alarm_status": "normal",
    "power": "10",
    "SOH": "99",
    "lastTime": "2025-09-24T10:33:00.000Z",
  };

  List<dynamic> voltageHistory = [];
  List<dynamic> powerOutage = [];
  Map<String, dynamic>? weatherData;

  late AnimationController _controller;
  late String alarmText;
  final _realtime = RealtimeService();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    fetchDeviceData();
    _realtime.subscribe(widget.serialNum, _onDataReceived);

  }

  @override
  void dispose() {
    _controller.dispose();
    _realtime.unsubscribe(widget.serialNum, _onDataReceived);
    super.dispose();
  }

  Future<void> fetchDeviceData() async {
    final result = await ApiService.getDeviceNowData(
      widget.model,
      widget.serialNum,
    );
    if (result['status'] == 200) _onDataReceived(result['data']);
  }

  void _onDataReceived(Map<String, dynamic> data) {
    if (!mounted) return;
    setState(() {
      fakeData = data;
      weatherData = data['weather'];
      isCharging =
          safeStr(fakeData, "current_status", defaultValue: "discharging") ==
              "charging";
      powerOutage = data['powerOutage'] ?? [];

      voltageHistory = data['voltageHistory'] ?? [];
    });
  }

  final Map<String, Map<String, String>> weatherDescMap = {
    "晴": {"en": "Sunny", "zh": "晴"},
    "少雲": {"en": "Clouds", "zh": "少雲"},
    "零散雲": {"en": "Clouds", "zh": "零散雲"},
    "多雲": {"en": "Clouds", "zh": "多雲"},
    "陣雨": {"en": "Rain", "zh": "陣雨"},
    "小雨": {"en": "Rain", "zh": "小雨"},
    "下雨": {"en": "Rain", "zh": "下雨"},
    "雷雨": {"en": "Thunderstorm", "zh": "雷雨"},
    "下雪": {"en": "Snow", "zh": "下雪"},
    "霧": {"en": "Mist", "zh": "霧"},
  };

  String getWeatherDesc(String? desc, BuildContext context) {
    if (desc == null) return "--";
    String lang = Localizations.localeOf(context).languageCode;

    List<String> keywords = weatherDescMap.keys
        .where((key) => desc.contains(key))
        .toList();

    if (keywords.isEmpty) return desc;

    List<String> translated = keywords.map((k) {
      return weatherDescMap[k]?[lang] ?? k;
    }).toList();

    return translated.join(" / ");
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = ThemeProvider.themeMode.value == ThemeMode.dark;

    String alarmStatus = safeStr(
      fakeData,
      "alarm_status",
      defaultValue: "normal",
    );
    bool hasPowerOutage = powerOutage.isNotEmpty;
    alarmText = (alarmStatus != "normal" || hasPowerOutage)
        ? (alarmStatus != "normal" ? alarmStatus : S.of(context)!.deviceAlert)
        : S.of(context)!.noAlarm;
    Color alarmColor = (alarmStatus != "normal" || hasPowerOutage)
        ? Colors.redAccent
        : (isDark ? Colors.blueAccent : Colors.blue);

    Color textColor = isDark ? Colors.white70 : Colors.black87;
    Color cardBorder = isDark ? Colors.white24 : Colors.grey.shade300;

    Color background = isDark
        ? const Color(0xFF010402)
        : const ui.Color.fromARGB(255, 203, 255, 203);
    Color backgroundEnd = isDark
        ? const ui.Color.fromARGB(255, 17, 17, 114)
        : const ui.Color.fromARGB(255, 255, 255, 255);

    double minV = 0;
    double maxV = 1;

    if (voltageHistory.isNotEmpty) {
      List<double> voltages = voltageHistory
          .map((e) => (e['voltage'] as num).toDouble())
          .toList();
      minV = voltages.reduce((a, b) => a < b ? a : b);
      maxV = voltages.reduce((a, b) => a > b ? a : b);
    }

    double interval = (maxV - minV) / 2;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [background, backgroundEnd],
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(  
            child: Column(
              children: [
               const SizedBox(height: 20),
               // ===== 上方 Bar: 天氣 + 電量 =====
                Container(
                height: 80,
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [Colors.black87, Colors.black54]
                        : [
                            const ui.Color.fromARGB(255, 0, 197, 7),
                            Colors.grey.shade200,
                          ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark
                        ? const ui.Color.fromARGB(255, 0, 255, 0)
                        : Colors.green,
                    width: 2,
                  ),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // 天氣圖示 + 描述
                      Row(
                        children: [
                          weatherData != null && weatherData!['icon'] != null
                              ? Image.network(
                                  weatherData!['icon'],
                                  width: 32,
                                  height: 32,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(Icons.cloud, size: 32, color: textColor),
                                )
                              : Icon(Icons.cloud, size: 32, color: textColor),
                          const SizedBox(width: 6),
                          Text(
                            getWeatherDesc(weatherData?['desc'], context),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Container(width: 1, height: 40, color: cardBorder),
                      const SizedBox(width: 12),

                      // 溫度
                      Text(
                        weatherData != null
                            ? "${safeStr(weatherData!, "temp")} °C"
                            : "-- °C",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(width: 1, height: 40, color: cardBorder),
                      const SizedBox(width: 12),

                      // 濕度
                      Text(
                        weatherData != null
                            ? "${safeStr(weatherData!, "humidity")}%RH"
                            : "-- %RH",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(width: 1, height: 40, color: cardBorder),
                      const SizedBox(width: 12),

                      // SOC
                      Row(
                        children: [
                          Icon(
                            Icons.battery_full,
                            color: isDark ? Colors.cyanAccent : Colors.green,
                            size: 24,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${safeStr(fakeData, "SOC")} %",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.cyanAccent : Colors.green.shade700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
                // ===== 電池資訊 + 溫度與警報 =====
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Column(
                    children: [
                      // 電壓 + 電流
                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoCard(
                              icon: Icons.bolt,
                              title: S.of(context)!.voltage,
                              value: "${safeStr(fakeData, "voltage")} V",
                              gradientColors: [Colors.greenAccent, background],
                              borderColor: cardBorder,
                              isDark: isDark,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildInfoCard(
                              icon: Icons.flash_on,
                              title: S.of(context)!.current,
                              value: "${safeStr(fakeData, "current")} A",
                              gradientColors: [Colors.blueAccent, background],
                              borderColor: cardBorder,
                              isDark: isDark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // 功率
                      _buildInfoCard(
                        icon: Icons.power,
                        title: S.of(context)!.power,
                        value: "${safeStr(fakeData, "power")} kW",
                        gradientColors: [Colors.orangeAccent, background],
                        borderColor: cardBorder,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 8),
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildInfoCard(
                                icon: Icons.warning,
                                title: alarmText,
                                gradientColors: isDark
                                    ? [
                                        Colors.red.shade900.withOpacity(0.8),
                                        Colors.redAccent.shade700.withOpacity(0.8),
                                      ]
                                    : [Colors.red.shade200, Colors.red.shade400],
                                borderColor: alarmColor,
                                isDark: isDark,
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    backgroundColor: Colors.transparent,
                                    builder: (_) => _buildAlarmDetailsSheet(),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildInfoCard(
                                icon: Icons.thermostat,
                                title: S.of(context)!.internalTemperature,
                                value: "${safeStr(fakeData, "temperature")} °C",
                                gradientColors: isDark
                                    ? [
                                        Colors.orange.shade900.withOpacity(0.8),
                                        Colors.deepOrangeAccent.withOpacity(0.8),
                                      ]
                                    : [Colors.orange.shade200, Colors.yellow.shade400],
                                borderColor: Colors.orangeAccent,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                // ===== Voltage / Current / Power History Charts =====

                       if (voltageHistory.isNotEmpty)
                    _buildLineChart(
                      title: S.of(context)!.voltageChart,
                      data: voltageHistory.cast<Map<String, dynamic>>(),
                      keyName: 'voltage',
                      isDark: isDark,
                      lineColor: Colors.greenAccent.shade400,
                      minY: 480,
                      maxY: 640,
                      intervalY: 40,
                    ),
                  if (fakeData['currenteHistory'] != null)
                    _buildLineChart(
                      title: S.of(context)!.currentChart,
                      data: (fakeData['currenteHistory'] as List<dynamic>)
                          .cast<Map<String, dynamic>>(),
                      keyName: 'current',
                      isDark: isDark,
                      lineColor: Colors.blueAccent.shade400,
                      minY: -100,
                      maxY: 100,
                      intervalY: 50,
                    ),
                  if (fakeData['powerHistory'] != null)
                    _buildLineChart(
                      title: S.of(context)!.powerChartinhirack,
                      data: (fakeData['powerHistory'] as List<dynamic>)
                          .cast<Map<String, dynamic>>(),
                      keyName: 'power',
                      isDark: isDark,
                      lineColor:  Colors.orangeAccent.shade400,
                      minY: -64000,
                      maxY: 64000,
                      intervalY: 32000,
                    ),
              ],
            ),
            ),

            // 離線遮罩
            if (safeStr(fakeData, "online_status") == "offline")
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.wifi_off,
                            color: Colors.redAccent, size: 64),
                        const SizedBox(height: 16),
                        Text(
                          S.of(context)!.deviceOffline,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "離線時間: ${formatTaiwanTime(safeStr(fakeData, "lastTime"))}",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
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
    );
  }

  // ===== InfoCard =====
  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    String? value,
    required List<Color> gradientColors,
    required Color borderColor,
    bool isDark = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1.5),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 36, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black87,
                      fontSize: 18,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (value != null)
                    Text(
                      value,
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===== 折線圖 =====
  Widget _buildLineChart({
    required String title,
    required List<Map<String, dynamic>> data,
    required String keyName,
    required bool isDark,
    Color? lineColor,
    double? minY,
    double? maxY,
    double? intervalY,
  }) {
    if (data.isEmpty) return const SizedBox.shrink();

    final Color bgColor =
        isDark ? const Color(0xFF010402) : const Color(0xFFCBFFCB);
    final Color shadowColor =
        isDark ? Colors.black54 : Colors.grey.withOpacity(0.2);

    final intervalX =
        data.length > 6 ? (data.length / 6).floorToDouble() : 1;

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
          Text(title,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: lineColor)),
          const SizedBox(height: 12),
          SizedBox(
            height: 220,
            child: LineChart(
              LineChartData(
                lineTouchData: LineTouchData(enabled: true),
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: intervalY,
                      getTitlesWidget: (value, _) {
                        String text;
                        if (keyName == 'power' && value.abs() >= 1000) {
                          text = "${(value / 1000).toInt()}k"; // 64000 -> 64k
                        } else {
                          text = value.toInt().toString();
                        }
                        return Text(
                          text,
                          style: TextStyle(
                            fontSize: 10,
                            color: isDark ? Colors.white70 : Colors.black54,
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false), // ⬅️ 右方隱藏
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false), // ⬅️ 上方隱藏
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: intervalX.toDouble(),
                      getTitlesWidget: (value, _) {
                        int idx = value.toInt();
                        if (idx < 0 || idx >= data.length)
                          return const SizedBox();
                        DateTime time = DateTime.parse(
                                data[idx]['timestamp'])
                            .toUtc()
                            .add(const Duration(hours: 8));
                        return Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            "${time.hour}:00",
                            style: TextStyle(
                                fontSize: 10,
                                color: isDark
                                    ? Colors.white70
                                    : Colors.black54),
                          ),
                        );
                      },
                    ),
                  ),
                
                ),
                minY: minY,
                maxY: maxY,
                minX: 0,
                maxX: data.length.toDouble() - 1,
                lineBarsData: [
                  LineChartBarData(
                    spots: data
                        .asMap()
                        .entries
                        .map((e) {
                          final rawValue = (e.value[keyName] as num).toDouble();
                          final fixedValue = double.parse(rawValue.toStringAsFixed(2)); // 保留二位小數
                          return FlSpot(e.key.toDouble(), fixedValue);
                        })
                        .toList(),
                    isCurved: true,
                    color: lineColor,
                    barWidth: 3,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          (lineColor ?? Colors.greenAccent)
                              .withOpacity(0.3),
                          Colors.transparent
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
  
  String formatTaiwanTime(String utcTime) {
    if (utcTime.isEmpty) return "";
    try {
      DateTime dt =
          DateTime.parse(utcTime).toUtc().add(const Duration(hours: 8));
      return DateFormat('yyyy/MM/dd HH:mm').format(dt);
    } catch (e) {
      return utcTime;
    }
  }

  Widget _buildAlarmDetailsSheet() {
    bool isDark = ThemeProvider.themeMode.value == ThemeMode.dark;

    String alarmStatus = safeStr(fakeData, "alarm_status",
        defaultValue: "normal");
    bool hasPowerOutage = powerOutage.isNotEmpty;
    String displayStatus = (alarmStatus != "normal" || hasPowerOutage)
        ? (alarmStatus != "normal"
            ? alarmStatus
            : S.of(context)!.deviceAlert)
        : S.of(context)!.noAlarm;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 50,
                height: 5,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Text(
              S.of(context)!.alarmDetails,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "${S.of(context)!.status}: $displayStatus",
              style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black87),
            ),
            const SizedBox(height: 12),
            if (hasPowerOutage)
              ...powerOutage.map((outage) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[800] : Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${S.of(context)!.deviceArea}: ${outage['area'] ?? '--'}",
                        style: TextStyle(
                          color:
                              isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                      Text(
                        "Summary: ${outage['work_summary'] ?? '--'}",
                        style: TextStyle(
                          color:
                              isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                      Text(
                        "Expected Outage Time: ${outage['first_start_time'] ?? '--'}",
                        style: TextStyle(
                          color:
                              isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
          ],
        ),
      ),
    );
  }
}

String safeStr(Map<String, dynamic> map, String key,
    {String defaultValue = "--"}) {
  final value = map[key];
  if (value == null) return defaultValue;
  return value.toString();
}
