import 'package:flutter/material.dart';
import '../../../widget/soc_card.dart';
import '../../../utils/api_service.dart';
import '../../../l10n/l10n.dart';
import '../../../utils/refresh_timer.dart';
import 'device_data.dart'; // 請確認路徑正確

class DeviceSummaryWidget extends StatefulWidget {
  final String model;
  final String serialNum;

  const DeviceSummaryWidget({
    super.key,
    required this.model,
    required this.serialNum,
  });

  @override
  State<DeviceSummaryWidget> createState() => _DeviceSummaryWidgetState();
}

class _DeviceSummaryWidgetState extends State<DeviceSummaryWidget> {
  Map<String, dynamic> summaryData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSummaryData();
    RealtimeService().subscribe(widget.serialNum, _onDataReceived);
  }

  void _onDataReceived(Map<String, dynamic> data) {
    if (!mounted) return;
    if (data.containsKey("summary")) {
      setState(() {
        summaryData = Map<String, dynamic>.from(data["summary"]);
      });
    }
  }

  @override
  void dispose() {
    RealtimeService().unsubscribe(widget.serialNum, _onDataReceived);
    super.dispose();
  }

  Future<void> fetchSummaryData() async {
    setState(() => isLoading = true);
    try {
      final result = await ApiService.getDeviceNowData(
        widget.model,
        widget.serialNum,
      );
      if (result['status'] == 200 && result['data'].containsKey('summary')) {
        setState(() {
          summaryData = Map<String, dynamic>.from(result['data']['summary']);
        });
      }
    } catch (e) {
      debugPrint("Fetch Summary Data Error: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  double _num(dynamic v) {
    return double.tryParse(v?.toString() ?? "0") ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    Color bgStart = isDark ? const Color.fromARGB(255, 0, 0, 0) : const Color(0xFFCBFFCB);
    Color bgEnd = isDark ? const Color.fromARGB(255, 0, 59, 9) : Colors.white;
    final double current = _num(summaryData["current"]);
    final double soc = _num(summaryData["soc"]); // 注意大小寫對應後端
    final bool isCharging = current > 0;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [Colors.blueGrey.shade900.withOpacity(0.6), Colors.black.withOpacity(0.8)]
                    : [Colors.white.withOpacity(0.3), Colors.grey.shade200.withOpacity(0.3)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? const Color.fromARGB(255, 0, 255, 38).withOpacity(0.5)
                      : Colors.green.withOpacity(0.3),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
              ],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
          ),
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                S.of(context)!.realTimeData,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: isDark ? const Color.fromARGB(255, 24, 255, 36) : Colors.green,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${soc.toStringAsFixed(0)}%",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    isCharging ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 16,
                    color: isCharging ? Colors.greenAccent : Colors.orangeAccent,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    isCharging ? S.of(context)!.charging : S.of(context)!.discharging,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      // ===== Body：增加下滑進入 DeviceDataWidget =====
      body: GestureDetector(
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity != null && details.primaryVelocity! < -300) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DeviceDataWidget(
                  model: widget.model,
                  serialNum: widget.serialNum,
                ),
              ),
            );
          }
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [bgStart, bgEnd],
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 16),
              // SOC 圓形
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final double size = constraints.maxWidth;
                    return Center(
                      child: SOCCircle(
                        isCharging: isCharging,
                        data: summaryData,
                        size: size,
                        isDark: isDark,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              // Summary 資訊卡
              buildSummaryCards(summaryData, isDark),
              const SizedBox(height: 16),
              // 下滑提示
              Icon(
                Icons.keyboard_arrow_up,
                size: 32,
                color: isDark ? Colors.white54 : Colors.black45,
              ),
              Text(
                S.of(context)!.viewDetails,
                style: TextStyle(
                  color: isDark ? Colors.white54 : Colors.black45,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSummaryCards(Map<String, dynamic> data, bool isDark) {
    final neonGlow = isDark ? const Color.fromARGB(255, 0, 255, 38) : Colors.green.withOpacity(0.6);
    final baseColor = isDark ? const Color.fromARGB(220, 0, 3, 24) : Colors.white;
    final fontColor = isDark ? Colors.white : Colors.green;
    final double current = _num(data["current"]);

    String remainTitle = current > 0 ? S.of(context)!.timeToFull : S.of(context)!.timeToEmpty;

    final Map<String, Map<String, dynamic>> displayFields = {
      "chargePower": {"title": S.of(context)!.chargePower, "icon": Icons.bolt},
      "dischargePower": {"title": S.of(context)!.dischargePower, "icon": Icons.bolt_outlined},
      "ReminHour": {"title": remainTitle, "icon": Icons.access_time},
      "todayIncome": {"title": S.of(context)!.todayRevenue, "icon": Icons.attach_money},
    };

    List<Widget> cards = [];
    displayFields.forEach((key, meta) {
      if (data.containsKey(key) && data[key] != null) {
        String value = "${data[key]}";
        if (key == "ReminHour") value += " h";
        if (key == "chargePower" || key == "dischargePower" || key == "power") value += " kW";

        cards.add(
          Container(
            height: 140,
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: baseColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: neonGlow,
                  blurRadius: 16,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(meta['icon'], color: fontColor, size: 36),
                const SizedBox(height: 8),
                Text(
                  meta['title'],
                  style: TextStyle(
                    color: fontColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: fontColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        );
      }
    });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          const double maxCardWidth = 160;
          const double spacing = 8;
          int count = (constraints.maxWidth / (maxCardWidth + spacing)).floor();
          if (count < 1) count = 1;
          double cardWidth = (constraints.maxWidth - spacing * (count - 1)) / count;

          return Wrap(
            alignment: WrapAlignment.center,
            spacing: spacing,
            runSpacing: spacing,
            children: cards.map((card) => SizedBox(width: cardWidth, child: card)).toList(),
          );
        },
      ),
    );
  }
}
