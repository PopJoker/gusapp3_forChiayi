import 'package:flutter/material.dart';
import '../../../widget/soc_card.dart';
import '../../../utils/api_service.dart';

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
    fetchDeviceData();
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

    Widget storageDropdown = DropdownButton<String>(
      value: selectedStorage,
      items: allStorages.keys.map((key) {
        return DropdownMenuItem<String>(
          value: key,
          child: Text(key),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            selectedStorage = value;
            fakeData = allStorages[selectedStorage] ?? {};
          });
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Battery Status"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          children: [
            // Storage 選擇
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Select Storage: "),
                storageDropdown,
              ],
            ),
            const SizedBox(height: 16),
            // SOC 圓形填滿中間
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double size = constraints.biggest.shortestSide;
                  return Center(
                    child: SOCCircle(
                      isCharging: fakeData["current_status"] == "charging",
                      data: fakeData,
                      size: size,
                      isDark: isDark,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            // 資訊卡
            Expanded(
              child: ListView(
                children: [
                  _buildInfoRow("Temperature", "${fakeData["temperature"]} ℃"),
                  _buildInfoRow("SOC", "${fakeData["SOC"]} %"),
                  _buildInfoRow("SOH", "${fakeData["SOH"]} %"),
                  _buildInfoRow(
                      "Last Update",
                      fakeData["lastUpdate"] != null
                          ? DateTime.parse(fakeData["lastUpdate"])
                              .toLocal()
                              .toString()
                          : "--"),
                ],
              ),
            ),
          ],
        ),
      ),
    );

  }

  Widget _buildInfoRow(String title, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: Text(value),
      ),
    );
  }
}
