import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../utils/theme_colors.dart';
import '../../utils/api_service.dart';
import '../../widget/floating_message.dart';
import '../../widget/cyber_stytle.dart';
import '../../widget/dialog_message.dart';
import '../../l10n/l10n.dart';

class PCSSettingPageWidget extends StatefulWidget {
  const PCSSettingPageWidget({
    super.key,
    required this.model,
    required this.serialNum,
  });

  final String model;
  final String serialNum;

  @override
  State<PCSSettingPageWidget> createState() => _PCSSettingPageWidgetState();
}

class _PCSSettingPageWidgetState extends State<PCSSettingPageWidget> {
  int _selectedMode = 1;
  bool _isLoading = false;
  Map<String, dynamic>? pcsStatus;
  String? pcsScene;

  @override
  void initState() {
    super.initState();
    fetchPCSStatus();
  }

  TimeOfDay startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay endTime = const TimeOfDay(hour: 12, minute: 0);

  TimeOfDay _parseTime(double value) {
    int intValue = value.toInt();
    int hour = intValue ~/ 100;
    int minute = intValue % 100;
    return TimeOfDay(hour: hour, minute: minute);
  }

  int _apiToUiMode(int apiMode) {
    switch (apiMode) {
      case 1:
        return 0;
      case 2:
        return 1;
      case 3:
        return 2;
      default:
        return 2;
    }
  }

  int _uiToApiMode(int uiIndex) {
    switch (uiIndex) {
      case 0:
        return 1;
      case 1:
        return 2;
      case 2:
        return 3;
      default:
        return 1;
    }
  }

  String getPcsScene(Map<String, dynamic> pcsData) {
      final now = DateTime.now();
      final hour = now.hour;
      final isDay = hour >= 6 && hour < 18;

      // 解析太陽能與電池數據
      final solarPower = double.tryParse(pcsData['Solar']?['input1']?['power']?.toString() ?? '0') ?? 0;
      final batteryDir = pcsData['Batterypowerdirection']?.toString() ?? '0.00';

      if (isDay) {
        if (solarPower > 0) {
          return 'daysun';
        } else {
          return 'daynosun';
        }
      } else {
        if (batteryDir == '1.00') {
          return 'nightwithbat';
        } else {
          return 'nightnobat';
        }
      }
    }

  Future<void> fetchPCSStatus() async {
    try {
      final result = await ApiService.getPCSNow(widget.serialNum);
      if (result != null) {
        setState(() {
          pcsStatus = result;
          double pcsStartTime = double.tryParse(
                  pcsStatus!['StarttimeforenableACchargerworking']
                          ?.toString() ??
                      '0') ??
              0;
          double pcsEndTime = double.tryParse(
                  pcsStatus!['EndingtimeforenableACchargerworking']
                          ?.toString() ??
                      '0') ??
              0;
          startTime = _parseTime(pcsStartTime);
          endTime = _parseTime(pcsEndTime);

          int apiMode = (double.tryParse(
                      pcsStatus!['PCSpresentmode']?.toString() ?? '0') ??
                  0)
              .toInt();
          _selectedMode = apiMode;
          
          pcsScene = getPcsScene(pcsStatus!);
        });
      }
    } catch (e) {
      debugPrint("PCS API Error: $e");
    }
  }

  Future<void> pickTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: (isStart ? startTime : endTime),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          startTime = picked;
        } else {
          endTime = picked;
        }
      });
    }
  }

  // Cyberpunk 密碼輸入對話框
  Future<String?> _showCyberpunkPasswordDialog(BuildContext context) async {
    final s = S.of(context)!;
    final TextEditingController pwdController = TextEditingController();
    bool isDark = ThemeProvider.themeMode.value == ThemeMode.dark;

    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor:
              isDark ? const Color(0xFF0B0B0B) : Colors.grey.shade200,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color.fromARGB(255, 255, 255, 255),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 17, 0, 255).withOpacity(0.5),
                  blurRadius: 12,
                  spreadRadius: 3,
                )
              ],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lock_outline, color: Color.fromARGB(255, 255, 255, 255), size: 48),
                const SizedBox(height: 12),
                Text(
                  s.enterPassword,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: pwdController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: s.enterPassword,
                    filled: true,
                    fillColor: isDark ? Colors.black45 : Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Colors.cyanAccent, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, null),
                      child: Text(s.cancel,
                          style: TextStyle(color: Colors.white70)),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 17, 0, 255),
                        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                      ),
                      onPressed: () =>
                          Navigator.pop(context, pwdController.text.trim()),
                      child: Text(s.ok),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && pcsStatus == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final s = S.of(context)!;
    bool isDark = ThemeProvider.themeMode.value == ThemeMode.dark;

    final List<Map<String, dynamic>> modes = [
      {
        'icon': Icons.battery_alert,
        'label': s.backupMode,
        'color': isDark
            ? const Color(0xFFF436EB)
            : const Color.fromARGB(255, 195, 43, 187),
        'glow': Colors.purpleAccent
      },
      {
        'icon': FontAwesomeIcons.piggyBank,
        'label': s.ecoMode,
        'color':
            isDark ? Colors.green : const Color.fromARGB(255, 39, 94, 40),
        'glow': Colors.limeAccent
      },
      {
        'icon': Icons.flash_on,
        'label': s.normalMode,
        'color':
            isDark ? Colors.blue : const Color.fromARGB(255, 0, 116, 211),
        'glow': Colors.cyanAccent
      },
    ];

    int uiIndex = _apiToUiMode(_selectedMode);
    Color baseColor = modes[uiIndex]['color'];
    Color glowColor = modes[uiIndex]['glow'];

    return SafeArea(
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    baseColor.withOpacity(0.05),
                    baseColor.withOpacity(0.2),
                    Colors.deepPurple.withOpacity(0.3)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  // 模式選擇區
                  Row(
                    children: modes.asMap().entries.map((entry) {
                      int idx = entry.key;
                      Map<String, dynamic> mode = entry.value;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            int targetApiMode = _uiToApiMode(idx);
                            if (_selectedMode == targetApiMode) return;

                            bool? confirmed = await showCyberpunkConfirmDialog(
                              context: context,
                              title: s.reminder,
                              message: s.switchModeConfirm(mode['label']),
                              glowColor: baseColor,
                            );
                            if (confirmed != true) return;

                            // === 密碼驗證 ===
                            final password =
                                await _showCyberpunkPasswordDialog(context);
                            if (password == null) return; // 按取消
                            if (password != "666666") {
                              await showCyberpunkConfirmDialog(
                                context: context,
                                title: s.failed,
                                message: s.passwordError,
                                glowColor: Colors.pinkAccent,
                                confirmText: s.ok,
                                cancelText: "",
                              );
                              return;
                            }

                            // === 執行切換 ===
                            setState(() => _isLoading = true);
                            try {
                              final res = await ApiService.controlPCS(
                                serialNumber: widget.serialNum,
                                mode: targetApiMode,
                              );

                              if (res['status'] == 200 &&
                                  res['data']['ack']['Status'] == 3) {
                                setState(() => _selectedMode = targetApiMode);
                                await showCyberpunkConfirmDialog(
                                  context: context,
                                  title: s.success,
                                  message: s.modeChanged(mode['label']),
                                  glowColor:
                                      const Color.fromARGB(255, 0, 255, 13),
                                  confirmText: s.ok,
                                  cancelText: "",
                                );
                              } else {
                                await showCyberpunkConfirmDialog(
                                  context: context,
                                  title: s.failed,
                                  message: s.sendFail,
                                  glowColor: Colors.pinkAccent,
                                  confirmText: s.ok,
                                  cancelText: "",
                                );
                              }
                            } catch (e) {
                              await showCyberpunkConfirmDialog(
                                context: context,
                                title: s.failed,
                                message: s.exception,
                                glowColor: Colors.pinkAccent,
                                confirmText: s.ok,
                                cancelText: "",
                              );
                            } finally {
                              setState(() => _isLoading = false);
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: uiIndex == idx
                                  ? mode['color']
                                  : (isDark ? Colors.black87 : Colors.white10),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: uiIndex == idx
                                  ? [
                                      BoxShadow(
                                        color: mode['glow'].withOpacity(0.7),
                                        blurRadius: 16,
                                        spreadRadius: 4,
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(mode['icon'], size: 40, color: uiIndex == idx ? (isDark ? Colors.black : Colors.white) : mode['color']),
                                const SizedBox(height: 8),
                                Text(
                                  mode['label'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: uiIndex == idx ? (isDark ? Colors.black : Colors.white) : mode['color'],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                        if (pcsScene != null)
                        Flexible(
                          child: Image.asset(
                            'assets/$pcsScene.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s.chargeTime),
                        Row(
                          children: [
                            CyberpunkButton(
                              label:
                                  "${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}",
                              onPressed: () => pickTime(context, true),
                              color: baseColor,
                              glow: glowColor,
                            ),
                            const Text("~"),
                            CyberpunkButton(
                              label:
                                  "${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}",
                              onPressed: () => pickTime(context, false),
                              color: baseColor,
                              glow: glowColor,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: CyberpunkElevatedButton(
                            label: s.submitTime,
                            onPressed: () async {
                              if (startTime.hour * 100 + startTime.minute >=
                                  endTime.hour * 100 + endTime.minute) {
                                FloatingMessage.show(context, s.timeInvalid,
                                    autoHide: true, durationSeconds: 2);
                                return;
                              }

                              // === 密碼驗證 ===
                              final password = await _showCyberpunkPasswordDialog(context);
                              if (password == null) return; // 按取消
                              if (password != "666666") {
                                await showCyberpunkConfirmDialog(
                                  context: context,
                                  title: s.failed,
                                  message: "密碼錯誤，請再試一次。",
                                  glowColor: Colors.pinkAccent,
                                  confirmText: s.ok,
                                  cancelText: "",
                                );
                                return;
                              }

                              // === 執行時間設定更新 ===
                              setState(() => _isLoading = true);
                              final payload = {
                                "StarttimeforenableACchargerworking":
                                    startTime.hour * 100 + startTime.minute,
                                "EndingtimeforenableACchargerworking":
                                    endTime.hour * 100 + endTime.minute,
                                "SecondaryStarttimeforenableACchargerworking":
                                    startTime.hour * 100 + startTime.minute,
                                "SecondaryEndingtimeforenableACchargerworking":
                                    endTime.hour * 100 + endTime.minute,
                              };

                              try {
                                final res = await ApiService.controlPCS(
                                  serialNumber: widget.serialNum,
                                  mode: null, // 只更新時間
                                  payload: payload,
                                );
                                if (res['status'] == 200 &&
                                    res['data']['ack']['Status'] == 3) {
                                  await showCyberpunkConfirmDialog(
                                    context: context,
                                    title: s.success,
                                    message: s.timeSetSuccess(
                                        "${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}",
                                        "${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}"),
                                    glowColor: const Color.fromARGB(255, 0, 255, 13),
                                    confirmText: s.ok,
                                    cancelText: "",
                                  );
                                } else {
                                  await showCyberpunkConfirmDialog(
                                    context: context,
                                    title: s.failed,
                                    message: s.timeSetFail,
                                    glowColor: Colors.pinkAccent,
                                    confirmText: s.ok,
                                    cancelText: "",
                                  );
                                }
                              } catch (e) {
                                await showCyberpunkConfirmDialog(
                                  context: context,
                                  title: s.failed,
                                  message: s.exception,
                                  glowColor: Colors.pinkAccent,
                                  confirmText: s.ok,
                                  cancelText: "",
                                );
                              } finally {
                                setState(() => _isLoading = false);
                              }
                            },
                            color: baseColor,
                            glow: glowColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.4),
                child:
                    const Center(child: CircularProgressIndicator(color: Colors.white)),
              ),
            ),
        ],
      ),
    );
  }
}


