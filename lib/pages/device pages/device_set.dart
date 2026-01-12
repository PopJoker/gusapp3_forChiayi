// device_set.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/theme_colors.dart';
import '../../utils/refresh_timer.dart';
import '../../widget/cyber_card.dart';
import '../../widget/floating_message.dart';
import '../../l10n/l10n.dart';
import '../../global.dart'; // 用於 currentLocale

class SettingPageWidget extends StatefulWidget {
  const SettingPageWidget({
    super.key,
    required this.model,
    required this.serialNum,
    this.initialDailyTarget = 80,
    this.initialMonthlyTarget = 1000,
    this.onTargetsChanged,
  });

  final String model;
  final String serialNum;
  final int initialDailyTarget;
  final int initialMonthlyTarget;
  final void Function(int daily, int monthly)? onTargetsChanged;

  @override
  State<SettingPageWidget> createState() => _SettingPageWidgetState();
}

class _SettingPageWidgetState extends State<SettingPageWidget> {
  int _updateFrequency = 5;
  final _realtime = RealtimeService();
  late final DataCallback _realtimeCallback;
  bool _isSaving = false;
  late bool hideIncome;
  bool _isRealtimeEnabled = false;

  late TextEditingController _dailyTargetController;
  late TextEditingController _monthlyTargetController;

  @override
  void initState() {
    super.initState();
    _isRealtimeEnabled = _realtime.isEnabled(widget.serialNum);
    _dailyTargetController = TextEditingController();
    _monthlyTargetController = TextEditingController();

    hideIncome = widget.model == 'HES';

    _realtimeCallback = (_) {
      // Setting page 不處理即時資料
    };

    _loadSavedTargets();

    _updateFrequency = _realtime.getFrequency(widget.serialNum);

    if (_isRealtimeEnabled) {
      _realtime.start(
        widget.serialNum,
        widget.model,
        intervalSec: _updateFrequency,
      );
    }
    _realtime.subscribe(widget.serialNum, _realtimeCallback);

    _dailyTargetController.addListener(_saveDailyMonthlyTargets);
    _monthlyTargetController.addListener(_saveDailyMonthlyTargets);
  }

  Future<void> _loadSavedTargets() async {
    final prefs = await SharedPreferences.getInstance();
    int savedDaily =
        prefs.getInt('${widget.serialNum}_dailyTarget') ??
        widget.initialDailyTarget;
    int savedMonthly =
        prefs.getInt('${widget.serialNum}_monthlyTarget') ??
        widget.initialMonthlyTarget;

    _isRealtimeEnabled =
        prefs.getBool('${widget.serialNum}_realtimeEnabled') ?? false;
    _updateFrequency = prefs.getInt('${widget.serialNum}_updateFrequency') ?? 5;

    _dailyTargetController.text = savedDaily.toString();
    _monthlyTargetController.text = savedMonthly.toString();

    if (mounted) setState(() {});
  }

  Future<void> _saveTargets(int daily, int monthly) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('${widget.serialNum}_dailyTarget', daily);
    await prefs.setInt('${widget.serialNum}_monthlyTarget', monthly);
  }

  void _saveDailyMonthlyTargets() {
    int daily =
        int.tryParse(_dailyTargetController.text) ?? widget.initialDailyTarget;
    int monthly =
        int.tryParse(_monthlyTargetController.text) ??
        widget.initialMonthlyTarget;
    _saveTargets(daily, monthly);
  }

  void _toggleRealtime(bool val) async {
    setState(() {
      _isRealtimeEnabled = val;
      if (val) {
        _realtime.start(
          widget.serialNum,
          widget.model,
          intervalSec: _updateFrequency,
        );
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
    _realtime.unsubscribe(widget.serialNum, _realtimeCallback);
    _dailyTargetController.removeListener(_saveDailyMonthlyTargets);
    _dailyTargetController.dispose();
    _monthlyTargetController.dispose();
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
  }) {
    return TextField(
      controller: controller,
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
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 20,
        ),
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
    Color neonPink = isDark
        ? const Color.fromARGB(255, 0, 255, 38)
        : const Color.fromARGB(255, 2, 161, 47);
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
                  title: Text(
                    s.enableRealtime,
                    style: TextStyle(color: neonCyan),
                  ),
                  value: _isRealtimeEnabled,
                  activeColor: neonPink,
                  onChanged: _toggleRealtime,
                ),
                ListTile(
                  title: Text(
                    s.updateFrequency,
                    style: TextStyle(color: neonCyan),
                  ),
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
          const SizedBox(height: 16),

          // 語言切換
          CyberCard(
            neonCyan: neonCyan,
            neonPink: neonPink,
            neonPurple: neonPink,
            cardBorder: neonPink.withOpacity(0.5),
            backgroundColor: isDark ? Colors.black : Colors.white,
            child: ListTile(
              title: Text(s.language, style: TextStyle(color: neonCyan)),
              trailing: ValueListenableBuilder<Locale>(
                valueListenable: currentLocale,
                builder: (context, locale, child) {
                  return DropdownButton<Locale>(
                    value: currentLocale.value,
                    onChanged: (locale) {
                      if (locale != null) LocaleProvider.changeLocale(locale);
                    },
                    items: const [
                      DropdownMenuItem(
                        value: Locale('en'),
                        child: Text('English'),
                      ),
                      DropdownMenuItem(value: Locale('zh'), child: Text('中文')),
                    ],
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 日/月目標設定
          if (!hideIncome)
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
                    _inputField(
                      _dailyTargetController,
                      s.dailyTargetLabel,
                      Icons.trending_up,
                      neonCyan,
                      neonPink,
                      neonPink,
                      isDark ? Colors.black : Colors.white,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    _inputField(
                      _monthlyTargetController,
                      s.monthlyTargetLabel,
                      Icons.trending_up,
                      neonCyan,
                      neonPink,
                      neonPink,
                      isDark ? Colors.black : Colors.white,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isSaving
                          ? null
                          : () async {
                              setState(() => _isSaving = true);

                              final daily =
                                  int.tryParse(_dailyTargetController.text) ??
                                  widget.initialDailyTarget;
                              final monthly =
                                  int.tryParse(_monthlyTargetController.text) ??
                                  widget.initialMonthlyTarget;

                              await _saveTargets(daily, monthly);

                              widget.onTargetsChanged?.call(daily, monthly);

                              FloatingMessage.show(
                                context,
                                s.success,
                                autoHide: true,
                              );

                              setState(() => _isSaving = false);
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: neonPink,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: BorderSide(
                            color: neonPink,
                            width: 2,
                          ),
                        ),
                      ).copyWith(
                        overlayColor: MaterialStateProperty.resolveWith<Color?>(
                          (states) {
                            if (states.contains(MaterialState.pressed)) {
                              return neonPink.withOpacity(0.15);
                            }
                            if (states.contains(MaterialState.hovered)) {
                              return neonPink.withOpacity(0.08);
                            }
                            return null;
                          },
                        ),
                      ),
                      child: _isSaving
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: neonPink,
                              ),
                            )
                          : Text(
                              s.save,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.2,
                              ),
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
}
