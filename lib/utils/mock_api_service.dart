import 'dart:math';
import 'dart:async';

class MockApiService {
  static final Random _rand = Random();

  /// ===== 取得設備即時資料 (假資料) =====
  static Future<Map<String, dynamic>> getDeviceNowData(
    String model,
    String serialNum,
  ) async {
    await Future.delayed(Duration(milliseconds: 500)); // 模擬網路延遲

    return {
      "status": 200,
      "data": {
        "alarm_status": ["normal", "warning", "critical"][_rand.nextInt(3)],
        "online_status": "online",
        "current_status": ["charging", "discharging", "idle"][_rand.nextInt(3)],
        "voltage": (_rand.nextDouble() * 10 + 50).toStringAsFixed(3),
        "current": (_rand.nextDouble() * -5).toStringAsFixed(3),
        "power": (_rand.nextDouble() * 5).toStringAsFixed(3),
        "temperature": (_rand.nextDouble() * 15 + 25).toStringAsFixed(2),
        "SOC": (_rand.nextDouble() * 100).toStringAsFixed(2),
        "SOH": (_rand.nextDouble() * 100).toStringAsFixed(2),
        "weather": {
          "temp": (_rand.nextDouble() * 15 + 20).toStringAsFixed(2),
          "humidity": _rand.nextInt(101),
          "desc": ["晴", "多雲", "陰", "雨"][_rand.nextInt(4)],
          "icon": "https://openweathermap.org/img/wn/01d@2x.png",
        },
        "powerOutage": List.generate(
          5,
          (i) => {
            "office": null,
            "request_no": "H${10000 + _rand.nextInt(90000)}",
            "work_summary": "高壓線路改善",
            "area": "桃園市中壢區月眉${i + 1}路",
            "first_start_time": "2025/10/22 00:00~05:00",
          },
        ),
      },
    };
  }

  /// ===== 取得 PCS 狀態 (假資料) =====
  static Future<Map<String, dynamic>> getPCSNow(String serialNum) async {
    await Future.delayed(Duration(milliseconds: 400));

    int mode = _rand.nextInt(4);
    String modeName;
    switch (mode) {
      case 0:
        modeName = '閒置模式';
        break;
      case 1:
        modeName = '充電模式';
        break;
      case 2:
        modeName = '放電模式';
        break;
      default:
        modeName = '一般模式';
        break;
    }

    double voltageSum = 220 + _rand.nextDouble() * 5;
    double powerSum = 50 + _rand.nextDouble() * 60;

    return {
      "status": 200,
      "data": {
        "PCSpresentmode": mode.toDouble(),
        "modeName": modeName,
        "Solar": {
          "input1": {
            "voltage": _rand.nextDouble() * 50,
            "current": _rand.nextDouble() * 10,
            "power": _rand.nextDouble() * 500,
            "workStatus": _rand.nextDouble(),
          },
          "input2": {
            "voltage": _rand.nextDouble() * 50,
            "current": _rand.nextDouble() * 10,
            "power": _rand.nextDouble() * 500,
            "workStatus": _rand.nextDouble(),
          },
        },
        "DCACpowerdirection": _rand.nextDouble() * 3,
        "Batterypowerdirection": _rand.nextDouble() * 3,
        "Linepowerdirection": _rand.nextDouble() * 3,
        "ACoutput": {
          "voltageSum": voltageSum,
          "powerSum": powerSum,
          "voltageR": voltageSum / 2,
          "voltageS": voltageSum / 2,
          "voltageT": 0.0,
          "powerR": powerSum / 2,
          "powerS": powerSum / 2,
          "powerT": 0.0,
        },
        "ACinput": {
          "voltageSum": voltageSum,
          "powerSum": powerSum,
          "voltageR": voltageSum / 2,
          "voltageS": voltageSum / 2,
          "voltageT": 0.0,
          "powerR": powerSum / 2,
          "powerS": powerSum / 2,
          "powerT": 0.0,
        },
      },
    };
  }

  /// ===== 取得 Log 資料 (假資料) =====
  static Future<Map<String, dynamic>> getlog(
    String serialNum, {
    int page = 1,
  }) async {
    await Future.delayed(Duration(milliseconds: 300));

    List<String> types = ["Notice", "Alarm"];
    List<String> titles = [
      "使用者取得即時數據",
      "使用者取得歷史數據",
      "查詢 PCS 狀態",
      "更改 PCS 模式",
      "狀態異常",
    ];
    List<String> messages = [
      "使用者取得即時數據，條碼：$serialNum",
      "使用者取得歷史數據，條碼：$serialNum",
      "使用者查詢了 PCS 狀態",
      "更改模式模式未知",
      "異常代碼：LoStatus1=0, LoStatus2=12288, LoStatus3=12288, LoStatus4=0, LoStatus5=0, LoStatus6=0, HiStatus1=0, HiStatus2=0, HiStatus3=0, HiStatus4=0, HiStatus5=0, HiStatus6=0",
    ];

    List<Map<String, dynamic>> logs = List.generate(10, (i) {
      int idx = _rand.nextInt(titles.length);
      DateTime time = DateTime.now().subtract(
        Duration(minutes: _rand.nextInt(60 * 24 * 30)),
      ); // 最近 30 天
      return {
        "id": 300 - i - (page - 1) * 10,
        "Serial_Number": serialNum,
        "Type": types[_rand.nextInt(2)],
        "Title": titles[idx],
        "Message": messages[idx],
        "CreateTime": time.toIso8601String(),
      };
    });

    return {"success": true, "data": logs};
  }

  /// ===== 取得 歷史 資料 (假資料) =====
  static Future<Map<String, dynamic>> getDeviceSummary(String serialNum) async {
    await Future.delayed(Duration(milliseconds: 400));

    // 每小時 SOC (最近 24 小時)
    List<Map<String, dynamic>> hourlySoc = List.generate(24, (i) {
      DateTime time = DateTime.now().subtract(Duration(hours: i));
      return {
        "timestamp": time.toIso8601String(),
        "soc": 50 + _rand.nextInt(51), // 50~100%
      };
    });

    // 每日能量 (最近 7 天)
    List<Map<String, dynamic>> dailyEnergy = List.generate(7, (i) {
      DateTime day = DateTime.now().subtract(Duration(days: i));
      return {
        "date":
            "${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}",
        "totalCharge_kWh": double.parse(
          (_rand.nextDouble() * 50).toStringAsFixed(3),
        ),
        "totalDischarge_kWh": double.parse(
          (_rand.nextDouble() * 20).toStringAsFixed(3),
        ),
      };
    });

    return {"hourlySoc": hourlySoc, "dailyEnergy": dailyEnergy};
  }

  /// ===== 控制 PCS (假資料) =====
  static Future<Map<String, dynamic>> controlPCS({
    required String serialNumber,
    int? mode,
    Map<String, int>? payload,
  }) async {
    await Future.delayed(Duration(milliseconds: 300));
    return {
      "status": 200,
      "data": {
        "message": "指令已送出",
        "serialNumber": serialNumber,
        "mode": mode,
        "payload": payload,
      },
    };
  }

  /// ===== 更新裝置資訊 (假資料) =====
  static Future<Map<String, dynamic>> updateDeviceInfo({
    required String serialNumber,
    String? name,
    double? latitude,
    double? longitude,
    String? area,
  }) async {
    await Future.delayed(Duration(milliseconds: 300));
    return {
      "status": 200,
      "data": {
        "message": "更新成功",
        "serialNumber": serialNumber,
        "name": name,
        "latitude": latitude,
        "longitude": longitude,
        "area": area,
      },
    };
  }

  /// ===== 登入 =====
  static Future<Map<String, dynamic>> mockLogin(
    String email,
    String password,
  ) async {
    await Future.delayed(Duration(milliseconds: 500));
    if (email == "234@234.com" && password == "234") {
      return {
        "status": 200,
        "data": {"token": "FAKE_JWT_TOKEN"},
      };
    }
    return {
      "status": 401,
      "data": {"message": "帳號或密碼錯誤"},
    };
  }

  /// ===== 註冊 =====
  static Future<Map<String, dynamic>> mockRegister(
    String email,
    String password,
  ) async {
    await Future.delayed(Duration(milliseconds: 500));
    return {
      "status": 201,
      "data": {"message": "註冊成功，請等待管理員啟用"},
    };
  }

  /// ===== 設備資料 =====
  static Future<Map<String, dynamic>> getUserDevices() async {
    await Future.delayed(Duration(milliseconds: 300));
    final rand = Random();

    return {
      "status": 200,
      "data": List.generate(
        5,
        (i) => {
          "serial_number": "MD062500000${i + 1}",
          "name": "電池櫃 ${i + 1}",
          "model": "LES",
          "soc": (50 + rand.nextInt(51)).toStringAsFixed(2),
          "status": ["CHG", "DSG", "IDLE"][rand.nextInt(3)],
          "remaining": (rand.nextDouble() * 10).toStringAsFixed(1),
          "day_income": double.parse(
            (rand.nextDouble() * 20).toStringAsFixed(1),
          ),
          "month_income": double.parse(
            (rand.nextDouble() * 1000).toStringAsFixed(0),
          ),
          "chgday": rand.nextInt(2),
          "dsgday": rand.nextInt(2),
          "soh": rand.nextBool()
              ? (rand.nextDouble() * 100).toStringAsFixed(1)
              : null,
          "temperature": (25 + rand.nextDouble() * 15).toStringAsFixed(2),
          "current": (-10 + rand.nextDouble() * 10).toStringAsFixed(2),
        },
      ),
    };
  }

  /// ===== 綁定 =====
  static Future<Map<String, dynamic>> bindDevice(
    Map<String, dynamic> payload,
  ) async {
    await Future.delayed(Duration(milliseconds: 300));
    return {
      "status": 200,
      "data": {"message": "綁定成功", ...payload},
    };
  }

  /// ===== 取消綁定 =====
  static Future<Map<String, dynamic>> unbindDevice(String serialNumber) async {
    await Future.delayed(Duration(milliseconds: 300));
    return {
      "status": 200,
      "data": {"message": "取消綁定成功", "serial_number": serialNumber},
    };
  }
}
