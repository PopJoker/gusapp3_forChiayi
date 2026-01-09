import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';
import 'package:flutter/foundation.dart';

typedef DataCallback = void Function(Map<String, dynamic> data);

class RealtimeService {
  static final RealtimeService _instance = RealtimeService._internal();
  factory RealtimeService() => _instance;
  RealtimeService._internal() {
    _loadPersistedState();
  }

  final Map<String, Timer> _timers = {};
  final Map<String, bool> _enabled = {};
  final Map<String, int> _frequency = {};
  final Map<String, List<DataCallback>> _listeners = {};
  final Map<String, String> _modelMap = {};

  int getFrequency(String serialNum) => _frequency[serialNum] ?? 5;
  // 初始化時載入 SharedPreferences
  Future<void> _loadPersistedState() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    for (var key in keys) {
      if (key.startsWith("enabled_")) {
        final serialNum = key.replaceFirst("enabled_", "");
        _enabled[serialNum] = prefs.getBool(key) ?? false;
      }
      if (key.startsWith("frequency_")) {
        final serialNum = key.replaceFirst("frequency_", "");
        _frequency[serialNum] = prefs.getInt(key) ?? 5;
      }
    }
  }

  Future<void> _saveEnabled(String serialNum, bool val) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("enabled_$serialNum", val);
  }

  Future<void> _saveFrequency(String serialNum, int sec) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("frequency_$serialNum", sec);
  }

  // 啟動 Timer
  void start(String serialNum, String model, {int? intervalSec}) {
    _enabled[serialNum] = true;
    _saveEnabled(serialNum, true);

    _modelMap[serialNum] = model;
    int sec = intervalSec ?? _frequency[serialNum] ?? 5;
    _frequency[serialNum] = sec;
    _saveFrequency(serialNum, sec);

    _timers[serialNum]?.cancel();
    _timers[serialNum] = Timer.periodic(Duration(seconds: sec), (timer) async {
      try {
        final data = await ApiService.getDeviceNowData(model, serialNum);
        debugPrint("[$serialNum] Timer API result: $data");
        if (_listeners[serialNum] != null) {
          for (var cb in _listeners[serialNum]!) cb(data['data']);
        }
      } catch (e) {
        debugPrint("[$serialNum] Timer API error: $e");
      }
    });
  }

  // 停止 Timer
  void stop(String serialNum) {
    _enabled[serialNum] = false;
    _saveEnabled(serialNum, false);

    _timers[serialNum]?.cancel();
    _timers.remove(serialNum);
  }

  // 設定更新頻率
  void setFrequency(String serialNum, int sec) {
    _frequency[serialNum] = sec;
    _saveFrequency(serialNum, sec);
    if (_enabled[serialNum] == true) start(serialNum, _modelMap[serialNum]!, intervalSec: sec);
  }

  bool isEnabled(String serialNum) => _enabled[serialNum] ?? false;

  // 訂閱資料更新
  void subscribe(String serialNum, DataCallback callback) {
    _listeners.putIfAbsent(serialNum, () => []);
    _listeners[serialNum]!.add(callback);
  }

  void unsubscribe(String serialNum, DataCallback callback) {
    _listeners[serialNum]?.remove(callback);
    if (_listeners[serialNum]?.isEmpty ?? false) _listeners.remove(serialNum);
  }

  // 停止所有 Timer
  void stopAll() {
    _timers.forEach((key, t) => t.cancel());
    _timers.clear();
    _enabled.keys.forEach((serialNum) => _saveEnabled(serialNum, false));
    _enabled.clear();
    _frequency.clear();
    _listeners.clear();
  }
}
