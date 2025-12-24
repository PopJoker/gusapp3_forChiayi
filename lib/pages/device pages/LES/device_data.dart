import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../../utils/theme_colors.dart';
import '../../../widget/soc_card.dart';
import '../../../widget/flow_painter.dart';
import '../../../utils/api_service.dart';
import '../../../utils/refresh_timer.dart';
import '../../../l10n/l10n.dart';
import 'package:intl/intl.dart';

class DeviceDataWidget extends StatefulWidget {
  final String model;
  final String serialNum;

  const DeviceDataWidget({
    super.key,
    required this.model,
    required this.serialNum,
  });

  @override
  State<DeviceDataWidget> createState() => _DeviceDataWidgetState();
}

class _DeviceDataWidgetState extends State<DeviceDataWidget>
    with TickerProviderStateMixin {

  bool isCharging = true;
  late FlowPainter _flowPainter;

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

  Map<String, dynamic>? pcsStatus;
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
    fetchPCSStatus();
    _realtime.subscribe(widget.serialNum, _onDataReceived);
    
    _flowPainter = FlowPainter(
      isCharging: isCharging,
      pcsStatus: pcsStatus ?? {},
      animation: _controller,
      modeName: pcsStatus?['modeName']?.toString() ?? "未知模式",
    );
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

  Future<void> fetchPCSStatus() async {
    try {
      final result = await ApiService.getPCSNow(widget.serialNum);
      if (result != null) setState(() => pcsStatus = result);
    } catch (e) {
      debugPrint("PCS API Error: $e");
    }
  }

  int? _lastBatteryDir;
  int? _lastDcacDir;
  bool? _lastSolar1Active;
  bool? _lastSolar2Active;

  void _onDataReceived(Map<String, dynamic> data) {
    double batteryVal = double.tryParse(
            pcsStatus?['Batterypowerdirection']?.toString() ?? "0.0") ?? 0.0;
    int batteryDir = batteryVal.toInt();
    double dcacVal = double.tryParse(
            pcsStatus?['Linepowerdirection']?.toString() ?? "0.0") ?? 0.0;
    int dcacDir = dcacVal.toInt();
    double solar1Val = double.tryParse(
            pcsStatus?['Solar']?['input1']?['workStatus']?.toString() ?? "0.0") ?? 0.0;
    bool solar1Active = solar1Val != 0;
    double solar2Val = double.tryParse(
            pcsStatus?['Solar']?['input2']?['workStatus']?.toString() ?? "0.0") ?? 0.0;
    bool solar2Active = solar2Val != 0;
    
    bool flowChanged = batteryDir != _lastBatteryDir ||
                   dcacDir != _lastDcacDir ||
                   solar1Active != _lastSolar1Active ||
                   solar2Active != _lastSolar2Active;

    if (!mounted) return;
    setState(() {
      fakeData = data;
      weatherData = data['weather'];
      isCharging =
          safeStr(fakeData, "current_status", defaultValue: "discharging") ==
              "charging";
      powerOutage = data['powerOutage'] ?? [];

      String modeNameRaw = pcsStatus?['modeName']?.toString() ?? "未知模式";

      String modeName;
      switch (modeNameRaw) {
        case "備援模式":
          modeName = S.of(context)!.backupMode;
          break;
        case "一般模式":
          modeName = S.of(context)!.normalMode;
          break;
        case "經濟模式":
          modeName = S.of(context)!.ecoMode;
          break;
        default:
          modeName = S.of(context)!.unknownMode;
      }

      if (flowChanged) {
        _controller.reset();      // 將動畫重置到起點
        _controller.repeat();    // 從頭開始播放一次

        _lastBatteryDir = batteryDir;
        _lastDcacDir = dcacDir;
        _lastSolar1Active = solar1Active;
        _lastSolar2Active = solar2Active;
      }
      _flowPainter = FlowPainter(
        isCharging: isCharging,
        pcsStatus: pcsStatus,
        animation: _controller,
        modeName: modeName,
      );
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
    String lang = Localizations.localeOf(context).languageCode; // zh / en

    // 拆分天氣關鍵字
    List<String> keywords = weatherDescMap.keys
        .where((key) => desc.contains(key))
        .toList();

    if (keywords.isEmpty) return desc; // 沒找到就原樣回傳

    // 將找到的關鍵字翻譯後組合
    List<String> translated = keywords.map((k) {
      return weatherDescMap[k]?[lang] ?? k;
    }).toList();

    return translated.join(" / "); // 用 / 分隔多個天氣狀態
  }


  @override
  Widget build(BuildContext context) {
    String modeNameRaw = pcsStatus?['modeName']?.toString() ?? "未知模式";

      String modeName;
      switch (modeNameRaw) {
        case "備援模式":
          modeName = S.of(context)!.backupMode;
          break;
        case "一般模式":
          modeName = S.of(context)!.normalMode;
          break;
        case "經濟模式":
          modeName = S.of(context)!.ecoMode;
          break;
        default:
          modeName = S.of(context)!.unknownMode;
      }
    if (pcsStatus == null || pcsStatus!.isEmpty || pcsStatus!['modeName'] == S.of(context)!.unknownMode) {
      // 🔁 如果資料為 null → 觸發重新整理
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });

      // 顯示一個 loading / empty 畫面
      return const Center(
        child: CircularProgressIndicator(),
      );
    } 

    bool isDark = ThemeProvider.themeMode.value == ThemeMode.dark;
        _flowPainter = FlowPainter(
        isCharging: isCharging,
        pcsStatus: pcsStatus,
        animation: _controller,
        modeName: modeName,
      );
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
          Column(
            children: [
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
              const SizedBox(height: 20,),
              // ===== 中間 SOC & FlowPainter =====
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 8,
                  ),
                  child: GestureDetector(
                    onTapDown: (details) {
                      final tappedNode = _flowPainter.checkNodeTap(
                        details.localPosition,
                      );
                      if (tappedNode != null && pcsStatus != null) {
                        _showNodeSheet(tappedNode);
                      }
                    },
                    child: SizedBox(
                      width: double.infinity,
                      height: 200,
                      child: CustomPaint(
                        painter: _flowPainter
                          ..isDark = isDark, // FlowPainter 支援深色
                      ),
                    ),
                  ),
                ),
              ),

              // ===== 設備預警 + 機內溫度 =====
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: IntrinsicHeight( // <- 加這裡
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
                      const SizedBox(width: 12),
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
                ),
              ),
              // ===== 下方流向圖 =====
              Expanded(
                child: Center(
                  child: SOCCircle(
                    isCharging: isCharging,
                    data: fakeData,
                    size: MediaQuery.of(context).size.width,
                    isDark: isDark,
                  ),
                ),
              ),
            ],
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
                      Icon(Icons.wifi_off, color: Colors.redAccent, size: 64),
                      SizedBox(height: 16),
                      Text(
                        S.of(context)!.deviceOffline,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "離線時間: ${formatTaiwanTime(safeStr(fakeData, "lastTime"))}",
                        style: TextStyle(
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

  // ======== InfoCard ========
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
        boxShadow: [
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
                  maxLines: 2, // 最多兩行
                  overflow: TextOverflow.ellipsis, // 超過文字顯示...
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
  
  // ======== formatTaiwanTime ========
  String formatTaiwanTime(String utcTime) {
    if (utcTime == null || utcTime.isEmpty) return "";
    try {
      DateTime dt = DateTime.parse(utcTime).toUtc().add(Duration(hours: 8)); // UTC+8
      return DateFormat('yyyy/MM/dd HH:mm').format(dt);
    } catch (e) {
      return utcTime; // 如果解析失敗就直接回傳原字串
    }
  }

  // ======== AlarmDetailsSheet ========
  Widget _buildAlarmDetailsSheet() {
    bool isDark = ThemeProvider.themeMode.value == ThemeMode.dark;

    String alarmStatus = safeStr(
      fakeData,
      "alarm_status",
      defaultValue: "normal",
    );
    bool hasPowerOutage = powerOutage.isNotEmpty;
    String displayStatus = (alarmStatus != "normal" || hasPowerOutage)
        ? (alarmStatus != "normal" ? alarmStatus : S.of(context)!.deviceAlert)
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
            // 上方拖動條
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
              style: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
            ),
            const SizedBox(height: 12),
            if (hasPowerOutage) ...[
              Text(
                S.of(context)!.powerOutageList,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 6),
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
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                      Text(
                        "Summary: ${outage['work_summary'] ?? '--'}",
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                      Text(
                        "Expected Outage Time: ${outage['first_start_time'] ?? '--'}",
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  void _showNodeSheet(String title) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _buildNodeBottomSheet(title),
    );
  }

  Widget _buildNodeBottomSheet(String title) {
    bool isDark = ThemeProvider.themeMode.value == ThemeMode.dark;

    Color getStatusColor(dynamic value, {String type = ''}) {
      if (type == 'workStatus')
        return value > 0.01
            ? (isDark ? Colors.lightGreenAccent : Colors.green)
            : Colors.grey;
      if (type == 'power')
        return value > 300
            ? Colors.orangeAccent
            : (isDark ? Colors.cyanAccent : Colors.blueAccent);
      return isDark ? Colors.white70 : Colors.black87;
    }

    List<Widget> children = [];

    switch (title) {
      case 'Solar':
        final solar = pcsStatus?['Solar'] ?? {};
        final input1 = solar['input1'] ?? {};
        final input2 = solar['input2'] ?? {};

        Widget buildSolarRow(String label, Map<String, dynamic> input) {
          double _toDouble(dynamic value) {
            if (value == null) return 0.0;
            if (value is num) return value.toDouble();
            if (value is String) return double.tryParse(value) ?? 0.0;
            return 0.0;
          }

          double voltage = _toDouble(input['voltage']);
          double current = _toDouble(input['current']);
          double power = _toDouble(input['power']);
          double workStatus = _toDouble(input['workStatus']);

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
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: getStatusColor(1),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${S.of(context)!.voltage}: ${voltage.toStringAsFixed(1)} V",
                      style: TextStyle(color: getStatusColor(voltage)),
                    ),
                    Text(
                      "${S.of(context)!.current}: ${current.toStringAsFixed(1)} A",
                      style: TextStyle(color: getStatusColor(current)),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${S.of(context)!.power}: ${power.toStringAsFixed(1)} W",
                      style: TextStyle(
                        color: getStatusColor(power, type: 'power'),
                      ),
                    ),
                    Text(
                      workStatus > 0.01
                          ? S.of(context)!.running
                          : S.of(context)!.standby,
                      style: TextStyle(
                        color: getStatusColor(workStatus, type: 'workStatus'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
                children.add(buildSolarRow(S.of(context)!.solar1, input1));
                children.add(buildSolarRow(S.of(context)!.solar2, input2));
                break;

      case 'PCS':
        String modeNameRaw = pcsStatus?['modeName']?.toString() ?? "未知模式";
        String modeName;
        switch (modeNameRaw) {
          case "備援模式":
            modeName = S.of(context)!.backupMode;
            break;
          case "一般模式":
            modeName = S.of(context)!.normalMode;
            break;
          case "經濟模式":
            modeName = S.of(context)!.ecoMode;
            break;
          default:
            modeName = S.of(context)!.unknownMode;
        }
        children.addAll([
          _buildRowWithColor(
            S.of(context)!.mode,
            modeName ?? S.of(context)!.unknownMode,
            isDark: isDark,
          ),
        ]);
        break;

      case 'BAT':
        children.addAll([
          _buildRowWithColor(
            S.of(context)!.soc,
            "${safeStr(fakeData, "SOC")} %",
            isDark: isDark,
          ),
          _buildRowWithColor(
            S.of(context)!.current,
            "${safeStr(fakeData, "current")} A",
            isDark: isDark,
          ),
          _buildRowWithColor(
            S.of(context)!.voltage,
            "${safeStr(fakeData, "voltage")} V",
            isDark: isDark,
          ),
          _buildRowWithColor(
            S.of(context)!.power,
            "${safeStr(fakeData, "power")} kW",
            isDark: isDark,
          ),
        ]);
        break;

      case 'Grid':
        final acIn = pcsStatus?['ACinput'] ?? {};
        children.addAll([
          _buildRowWithColor(
            S.of(context)!.voltage,
            "${((acIn['voltageSum'] ?? 0)).toStringAsFixed(1)} V",
            isDark: isDark,
          ),
          _buildRowWithColor(
            S.of(context)!.power,
            "${((acIn['powerSum'] ?? 0 )/ 1000).toStringAsFixed(1)} kW",
            color: getStatusColor(acIn['powerSum'], type: 'power'),
          ),
        ]);
        break;

      case 'Load':
        final acOut = pcsStatus?['ACoutput'] ?? {};
        children.addAll([
          _buildRowWithColor(
            S.of(context)!.voltage,
            "${(acOut['voltageSum'] ?? 0).toStringAsFixed(1)} V",
            isDark: isDark,
          ),
          _buildRowWithColor(
            S.of(context)!.power,
            "${((acOut['powerSum'] ?? 0) / 1000).toStringAsFixed(1)} kW",
            color: getStatusColor(acOut['powerSum'], type: 'power'),
          ),
        ]);
        break;
      
      default:
        children.add(
          Text(
            S.of(context)!.noData,
            style: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
          ),
        );
        break;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
            "$title ${S.of(context)!.status}",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          ...children.map(
            (w) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: w,
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildRowWithColor(
    String title,
    String value, {
    Color? color,
    bool isDark = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color ?? (isDark ? Colors.white70 : Colors.black87),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: color ?? (isDark ? Colors.white70 : Colors.black87),
          ),
        ),
      ],
    );
  }
}

String safeStr(
  Map<String, dynamic> map,
  String key, {
  String defaultValue = "--",
}) {
  if (map == null) return defaultValue;
  final value = map[key];
  if (value == null) return defaultValue;
  return value.toString();
}