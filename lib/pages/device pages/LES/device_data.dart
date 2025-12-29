import 'package:flutter/material.dart';
import '../../../widget/soc_card.dart';
import '../../../utils/api_service.dart';
import '../../../l10n/l10n.dart';
import '../../../utils/refresh_timer.dart';

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

class _DeviceDataWidgetState extends State<DeviceDataWidget> {
  Map<String, dynamic> fakeData = {};
  Map<String, dynamic> allStorages = {};
  String selectedStorage = "Storage1";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    RealtimeService().subscribe(widget.serialNum, _onDataReceived);
    fetchDeviceData();
  }

  void _onDataReceived(Map<String, dynamic> data) {
    if (!mounted) return;
    setState(() {
      allStorages = Map<String, dynamic>.from(data);
      fakeData = allStorages[selectedStorage] ?? {};
    });
  }

  @override
  void dispose() {
    RealtimeService().unsubscribe(widget.serialNum, _onDataReceived);
    super.dispose();
  }

  Future<void> fetchDeviceData() async {
    setState(() => isLoading = true);
    try {
      final result = await ApiService.getDeviceNowData(
        widget.model,
        widget.serialNum,
      );
      if (result['status'] == 200) {
        setState(() {
          allStorages = Map<String, dynamic>.from(result['data']);
          fakeData = allStorages[selectedStorage] ?? {};
        });
      }
    } catch (e) {
      debugPrint("Fetch Device Data Error: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    Color bgStart = isDark ? const Color.fromARGB(255, 0, 0, 0) : const Color(0xFFCBFFCB);
    Color bgEnd = isDark ? const Color.fromARGB(255, 0, 59, 9) : Colors.white;

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
                  offset: const Offset(0, 0),
                ),
              ],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
          ),
          title: Text(
            S.of(context)!.realTimeData,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: isDark ? const Color.fromARGB(255, 24, 255, 36) : Colors.green,
              shadows: [
                Shadow(
                  blurRadius: 8,
                  color: isDark ? Colors.cyanAccent.withOpacity(0.6) : Colors.green.withOpacity(0.6),
                  offset: const Offset(0, 0),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [bgStart, bgEnd],
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxHeight = constraints.maxHeight;
            final socHeight = maxHeight * 0.5;
            final infoHeight = maxHeight * 0.3;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Storage list
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: buildHorizontalSelector(
                      selectedStorage,
                      allStorages.keys.toList(),
                      isDark,
                      (value) {
                        if (value != null) {
                          setState(() {
                            selectedStorage = value;
                            fakeData = allStorages[selectedStorage] ?? {};
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  // SOC 圓形
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: socHeight,
                    child: Center(
                      child: SOCCircle(
                        isCharging: fakeData["current_status"] == "charging",
                        data: fakeData,
                        size: socHeight < MediaQuery.of(context).size.width ? socHeight : MediaQuery.of(context).size.width,
                        isDark: isDark,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // 資訊卡區域
                  ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: infoHeight),
                    child: buildInfoCardGrid(fakeData, isDark),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      // 離線遮罩
      extendBody: true,
      floatingActionButton: (fakeData["online_status"] != "online")
          ? Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.55),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.sync_problem, color: Colors.redAccent, size: 72),
                      const SizedBox(height: 16),
                      Text(
                        S.of(context)!.deviceOffline,
                        style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        fakeData["lastUpdate"] != null
                            ? "Last update: ${DateTime.parse(fakeData["lastUpdate"]).toLocal()}"
                            : "--",
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : null,
    );
  }

  Widget buildInfoCardGrid(Map<String, dynamic> data, bool isDark) {
    final neonGlow = isDark ? const Color.fromARGB(255, 0, 255, 38) : Colors.green.withOpacity(0.6);
    final baseColor = isDark
        ? const Color.fromARGB(220, 0, 3, 24)
        : const Color.fromARGB(255, 255, 255, 255);
    final fontColor = isDark ? const Color.fromARGB(255, 255, 255, 255) : Colors.green;

    final Map<String, Map<String, dynamic>> displayFields = {
      "temperature": {"title": S.of(context)!.internalTemperature, "icon": Icons.thermostat},
      "SOC": {"title": S.of(context)!.soc, "icon": Icons.battery_full},
      "ReminHour": {
        "title": (data["current_status"] == "charging") ? S.of(context)!.timeToFull : S.of(context)!.timeToEmpty,
        "icon": Icons.favorite
      },
      "current_status": {"title": S.of(context)!.status, "icon": Icons.power},
    };

    List<Widget> cards = [];
    displayFields.forEach((key, meta) {
      if (data.containsKey(key) && data[key] != null) {
        String value = "${data[key]}";
        if (key == "SOC" || key == "SOH") value += " %";
        if (key == "ReminHour") value += " h";

        cards.add(
          Container(
            width: 140,
            height: 140,
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: baseColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: neonGlow, blurRadius: 16, spreadRadius: 1)],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(meta['icon'], color: fontColor, size: 36),
                const SizedBox(height: 8),
                Text(meta['title'], style: TextStyle(color: fontColor, fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(value, style: TextStyle(color: fontColor, fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
          ),
        );
      }
    });

    return Wrap(
      alignment: WrapAlignment.start,
      spacing: 8,
      runSpacing: 8,
      children: cards,
    );
  }

  Widget buildHorizontalSelector(
    String selected,
    List<String> items,
    bool isDark,
    ValueChanged<String> onChanged,
  ) {
    final baseColor = isDark ? Colors.blueGrey.shade900 : Colors.white;
    final neonGlow = isDark ? const Color.fromARGB(255, 24, 255, 36) : Colors.green;

    return Row(
      children: items.map((item) {
        bool isSelected = item == selected;
        return GestureDetector(
          onTap: () => onChanged(item),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: isSelected ? neonGlow : baseColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: isSelected ? [BoxShadow(color: neonGlow.withOpacity(0.5), blurRadius: 8)] : null,
            ),
            child: Text(
              item,
              style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        );
      }).toList(),
    );
  }
}
