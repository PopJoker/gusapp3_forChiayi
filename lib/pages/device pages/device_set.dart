// device_set.dart
import 'package:flutter/material.dart';
import '../../utils/theme_colors.dart';
import '../../utils/api_service.dart';
import '../../utils/refresh_timer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widget/cyber_card.dart';
import '../../widget/floating_message.dart';
import '../../utils/map.dart';
import 'package:latlong2/latlong.dart';
import '../../l10n/l10n.dart';
import '../../global.dart';

class SettingPageWidget extends StatefulWidget {
  const SettingPageWidget({
    super.key,
    required this.model,
    required this.serialNum,
    this.initialDailyTarget = 80,
    this.initialMonthlyTarget = 1000,
  });

  final String model;
  final String serialNum;
  final int initialDailyTarget;
  final int initialMonthlyTarget;

  @override
  State<SettingPageWidget> createState() => _SettingPageWidgetState();
}

class _SettingPageWidgetState extends State<SettingPageWidget> {
  late FocusNode _nameFocus;
  late FocusNode _latFocus;
  late FocusNode _lngFocus;
  late FocusNode _areaFocus;

  bool _isRealtimeEnabled = false;
  int _updateFrequency = 5;
  Map<String, dynamic>? _latestData;
  final _realtime = RealtimeService();
  bool _isSaving = false;
  late bool hideIncome; 

  late TextEditingController _dailyTargetController;
  late TextEditingController _monthlyTargetController;
  late TextEditingController _nameController;
  late TextEditingController _latController;
  late TextEditingController _lngController;
  late TextEditingController _areaController;

  @override
  void initState() {
    super.initState();

    _dailyTargetController = TextEditingController();
    _monthlyTargetController = TextEditingController();
    _nameController = TextEditingController();
    _latController = TextEditingController();
    _lngController = TextEditingController();
    _areaController = TextEditingController();

    _nameFocus = FocusNode();
    _latFocus = FocusNode();
    _lngFocus = FocusNode();
    _areaFocus = FocusNode();

    _loadSavedTargets();

    _isRealtimeEnabled = _realtime.isEnabled(widget.serialNum);
    _updateFrequency = _realtime.getFrequency(widget.serialNum);

    if (_isRealtimeEnabled) {
      _realtime.start(widget.serialNum, widget.model, intervalSec: _updateFrequency);
    }
    _realtime.subscribe(widget.serialNum, _onDataReceived);

    // Focus listener 保護正在編輯
    _nameFocus.addListener(() => setState(() {}));
    _latFocus.addListener(() => setState(() {}));
    _lngFocus.addListener(() => setState(() {}));
    _areaFocus.addListener(() => setState(() {}));

    // 即時保存日/月目標
    _dailyTargetController.addListener(_saveDailyMonthlyTargets);
    _monthlyTargetController.addListener(_saveDailyMonthlyTargets);

    hideIncome = widget.model == 'HES';
  }

  Future<void> _loadSavedTargets() async {
    final prefs = await SharedPreferences.getInstance();
    int savedDaily = prefs.getInt('${widget.serialNum}_dailyTarget') ?? widget.initialDailyTarget;
    int savedMonthly = prefs.getInt('${widget.serialNum}_monthlyTarget') ?? widget.initialMonthlyTarget;

    _isRealtimeEnabled = prefs.getBool('${widget.serialNum}_realtimeEnabled') ?? false;
    _updateFrequency = prefs.getInt('${widget.serialNum}_updateFrequency') ?? 5;

    _dailyTargetController.text = savedDaily.toString();
    _monthlyTargetController.text = savedMonthly.toString();

    if (_latestData != null) {
      _nameController.text = _latestData?['name'] ?? '';
      _latController.text = _latestData?['gps_lat']?.toString() ?? '';
      _lngController.text = _latestData?['gps_lng']?.toString() ?? '';
      _areaController.text = _latestData?['area'] ?? '';
    }

    if (mounted) setState(() {});
  }

  Future<void> _saveTargets(int daily, int monthly) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('${widget.serialNum}_dailyTarget', daily);
    await prefs.setInt('${widget.serialNum}_monthlyTarget', monthly);
  }

  void _saveDailyMonthlyTargets() {
    int daily = int.tryParse(_dailyTargetController.text) ?? widget.initialDailyTarget;
    int monthly = int.tryParse(_monthlyTargetController.text) ?? widget.initialMonthlyTarget;
    _saveTargets(daily, monthly);
  }

  void _onDataReceived(Map<String, dynamic> data) {
    if (!mounted || _isSaving) return;

    _latestData = data;

    // 只更新目前空的欄位，避免覆蓋使用者輸入
    if (_nameController.text.isEmpty && data['name'] != null) {
      _nameController.text = data['name'];
    }
    if (_latController.text.isEmpty && data['gps_lat'] != null) {
      _latController.text = data['gps_lat'].toString();
    }
    if (_lngController.text.isEmpty && data['gps_lng'] != null) {
      _lngController.text = data['gps_lng'].toString();
    }
    if (_areaController.text.isEmpty && data['area'] != null) {
      _areaController.text = data['area'];
    }
  }
  
  void _toggleRealtime(bool val) async  {
    setState(() {
      _isRealtimeEnabled = val;
      if (val) {
        _realtime.start(widget.serialNum, widget.model, intervalSec: _updateFrequency);
      } else {
        _realtime.stop(widget.serialNum);
      }
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('${widget.serialNum}_realtimeEnabled', val);
  }

  void _changeFrequency(int sec) async {
    setState(() {
      _updateFrequency = sec;
      _realtime.setFrequency(widget.serialNum, sec);
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('${widget.serialNum}_updateFrequency', sec);
  }

  @override
  void dispose() {
    _realtime.unsubscribe(widget.serialNum, _onDataReceived);

    _dailyTargetController.removeListener(_saveDailyMonthlyTargets);
    _dailyTargetController.dispose();
    _monthlyTargetController.dispose();
    _nameController.dispose();
    _latController.dispose();
    _lngController.dispose();
    _areaController.dispose();

    _nameFocus.dispose();
    _latFocus.dispose();
    _lngFocus.dispose();
    _areaFocus.dispose();

    super.dispose();
  }

  Widget _inputField(
    TextEditingController controller,
    String hint,
    IconData icon,
    Color textColor,
    Color hintColor,
    Color accentColor,
    Color fillColor, {
    bool obscure = false,
    TextInputType? keyboardType,
    FocusNode? focusNode,
  }) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: TextStyle(color: textColor, fontSize: 16),
      cursorColor: accentColor,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: accentColor),
        hintText: hint,
        hintStyle: TextStyle(color: hintColor),
        filled: true,
        fillColor: fillColor,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: accentColor, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: accentColor, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: accentColor, width: 3),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color neonPink = isDark ? const Color.fromARGB(255, 0, 255, 38) : const Color.fromARGB(255, 2, 161, 47);
    Color neonCyan = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 60),

          // 深色模式
          CyberCard(
            neonCyan: neonCyan,
            neonPink: neonPink,
            neonPurple: neonPink,
            cardBorder: neonPink.withOpacity(0.5),
            backgroundColor: isDark ? Colors.black : Colors.white,
            child: SwitchListTile(
              title: Text(s.darkMode, style: TextStyle(color: neonCyan)),
              value: ThemeProvider.themeMode.value == ThemeMode.dark,
              activeColor: neonPink,
              onChanged: (val) => setState(() => ThemeProvider.toggleTheme()),
            ),
          ),
          const SizedBox(height: 16),

          // 即時更新設定
          CyberCard(
            neonCyan: neonCyan,
            neonPink: neonPink,
            neonPurple: neonPink,
            cardBorder: neonPink.withOpacity(0.5),
            backgroundColor: isDark ? Colors.black : Colors.white,
            child: Column(
              children: [
                SwitchListTile(
                  title: Text(s.enableRealtime, style: TextStyle(color: neonCyan)),
                  value: _isRealtimeEnabled,
                  activeColor: neonPink,
                  onChanged: _toggleRealtime,
                ),
                ListTile(
                  title: Text(s.updateFrequency, style: TextStyle(color: neonCyan)),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: neonPink),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<int>(
                      value: _updateFrequency,
                      dropdownColor: isDark ? Colors.black87 : Colors.white,
                      underline: const SizedBox(),
                      style: TextStyle(color: neonCyan),
                      items: [
                        DropdownMenuItem(value: 5, child: Text(s.seconds(5))),
                        DropdownMenuItem(value: 10, child: Text(s.seconds(10))),
                        DropdownMenuItem(value: 30, child: Text(s.seconds(30))),
                      ],
                      onChanged: (val) => _changeFrequency(val!),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 裝置資訊 + 日/月目標設定
          CyberCard(
            neonCyan: neonCyan,
            neonPink: neonPink,
            neonPurple: neonPink,
            cardBorder: neonPink.withOpacity(0.5),
            backgroundColor: isDark ? Colors.black : Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _inputField(_nameController, s.deviceName, Icons.label, neonCyan, neonPink, neonPink, isDark ? Colors.black : Colors.white, focusNode: _nameFocus),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 4,
                        child: Row(
                          children: [
                            Expanded(
                              child: _inputField(
                                _latController,
                                s.latitude,
                                Icons.my_location,
                                neonCyan,
                                neonPink,
                                neonPink,
                                isDark ? Colors.black : Colors.white,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                focusNode: _latFocus,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _inputField(
                                _lngController,
                                s.longitude,
                                Icons.map,
                                neonCyan,
                                neonPink,
                                neonPink,
                                isDark ? Colors.black : Colors.white,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                focusNode: _lngFocus,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () async {
                            LatLng? result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MapPickerPage(
                                  initialLat: _latController.text.isNotEmpty ? double.tryParse(_latController.text) : null,
                                  initialLng: _lngController.text.isNotEmpty ? double.tryParse(_lngController.text) : null,
                                ),
                              ),
                            );

                            if (result != null) {
                              setState(() {
                                _latController.text = result.latitude.toStringAsFixed(6);
                                _lngController.text = result.longitude.toStringAsFixed(6);
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: neonPink,
                            foregroundColor: Colors.black,
                            minimumSize: const Size(50, 48),
                          ),
                          child: const Icon(Icons.map),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _inputField(_areaController, s.deviceArea, Icons.location_city, neonCyan, neonPink, neonPink, isDark ? Colors.black : Colors.white, focusNode: _areaFocus),
                  const SizedBox(height: 16),
                  if (!hideIncome)...{
                    _inputField(_dailyTargetController, s.dailyTargetLabel, Icons.trending_up, neonCyan, neonPink, neonPink, isDark ? Colors.black : Colors.white, keyboardType: TextInputType.number),
                    const SizedBox(height: 12),
                    _inputField(_monthlyTargetController, s.monthlyTargetLabel, Icons.trending_up, neonCyan, neonPink, neonPink, isDark ? Colors.black : Colors.white, keyboardType: TextInputType.number),
                    const SizedBox(height: 16)
                  },
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: neonPink,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                    ),
                    onPressed: () async {
                      final name = _nameController.text.isNotEmpty ? _nameController.text : null;
                      final latitude = _latController.text.isNotEmpty ? double.tryParse(_latController.text) : null;
                      final longitude = _lngController.text.isNotEmpty ? double.tryParse(_lngController.text) : null;
                      final area = _areaController.text.isNotEmpty ? _areaController.text : null;

                      if ((_latController.text.isNotEmpty && latitude == null) ||
                          (_lngController.text.isNotEmpty && longitude == null)) {
                        FloatingMessage.show(context, s.latitudeInvalid, autoHide: true);
                        return;
                      }

                      final dailyTarget = int.tryParse(_dailyTargetController.text) ?? widget.initialDailyTarget;
                      final monthlyTarget = int.tryParse(_monthlyTargetController.text) ?? widget.initialMonthlyTarget;

                      try {
                        final result = await ApiService.updateDeviceInfo(
                          serialNumber: widget.serialNum,
                          name: name,
                          latitude: latitude,
                          longitude: longitude,
                          area: area,
                        );

                        if (result['status'] == 200) {
                          _isSaving = true;
                          _nameController.text = name ?? '';
                          _latController.text = latitude?.toString() ?? '';
                          _lngController.text = longitude?.toString() ?? '';
                          _areaController.text = area ?? '';
                          await _saveTargets(dailyTarget, monthlyTarget);
                          _isSaving = false;

                          FloatingMessage.show(context, s.success, autoHide: true);
                        } else {
                          final msg = result['data']?['message'] ?? s.failed;
                          FloatingMessage.show(context, "${s.failed}: $msg", autoHide: true);
                        }
                      } catch (e) {
                        FloatingMessage.show(context, "${s.exception}: $e", autoHide: true);
                      }
                    },
                    child: Text(s.save),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
