import 'package:flutter/material.dart';
import '../utils/theme_colors.dart';
import '../utils/api_service.dart';
import '../widget/floating_glow.dart';
import '../widget/device_card.dart';

class DevicePage extends StatefulWidget {
  const DevicePage({super.key});

  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  List<Map<String, dynamic>> devices = [];
  bool isLoading = true;
  late AnimationController _controller;

  final List<Map<String, dynamic>> fakeSites = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // 監聽生命周期
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
    fetchDevices();
  }

  @override
  void dispose() {
    _controller.dispose();
    WidgetsBinding.instance.removeObserver(this); // 移除監聽
    super.dispose();
  }

  // --- App 前景 / 背景 ---
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // App 回到前景
      fetchDevices();
    }
  }

  // --- 拉取資料 ---
  Future<void> fetchDevices() async {
    setState(() {
      isLoading = true;
    });
    try {
      final result = await ApiService.get("/devices/list");
      if (result["status"] == 200) {
        final List<dynamic> apiDevices = result["data"] ?? [];
        setState(() {
          devices = [
            ...fakeSites,
            ...apiDevices.map(
              (d) => {
                'name': d['name'] ?? '--',
                'serial_number': d['serial_number'] ?? '-',
                'model': d['model'] ?? d['device_model'] ?? '未知型號',
                'soc': double.tryParse(d['soc']?.toString() ?? '0')?.toInt() ?? 0,
                'status': d['status'] ?? 'IDLE',
                'day_income': d['day_income'] ?? 0.0,
                'month_income': d['month_income'] ?? 0.0,
                'chgday': d['chgday'] ?? 0.0,
                'dsgday': d['dsgday'] ?? 0.0,
                'soh': d['soh'] != null
                    ? double.tryParse(d['soh'].toString())?.toInt()
                    : 0,
                'remaining': d['remaining'] != null
                    ? double.tryParse(d['remaining'].toString())?.toInt()
                    : 0,
              },
            ),
          ];
          isLoading = false;
        });
      } else {
        setState(() {
          devices = fakeSites;
          isLoading = false;
        });
      }
    } catch (e) {
      print("Fetch error: $e");
      setState(() {
        devices = fakeSites;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color gusGreen = Color.fromARGB(255, 34, 212, 40);

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeProvider.themeMode,
      builder: (context, themeMode, child) {
        bool isDark = themeMode == ThemeMode.dark;
        Color textPrimary = isDark ? Colors.white : Colors.black87;
        Color textSecondary = isDark ? Colors.white54 : Colors.black54;

        if (isLoading) return const Center(child: CircularProgressIndicator());

        Color background = isDark
            ? const Color(0xFF010402)
            : const Color.fromARGB(255, 240, 255, 240);
        Color backgroundEnd = isDark
            ? const Color(0xFF081E12)
            : const Color.fromARGB(255, 200, 255, 200);

        return Scaffold(
          body: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [background, backgroundEnd],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              AnimatedBuilder(
                animation: _controller,
                builder: (_, __) {
                  return CustomPaint(
                    size: MediaQuery.of(context).size,
                    painter: FloatingGlowPainter(
                      animationValue: _controller.value,
                      isDark: isDark,
                      glowColor: gusGreen,
                    ),
                  );
                },
              ),
              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: devices
                        .map(
                          (site) => AnimatedTeslaCard(
                            site: site,
                            textPrimary: textPrimary,
                            textSecondary: textSecondary,
                            mainGreen: gusGreen,
                            dsgBlue: Colors.blueAccent,
                            animation: _controller,
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
