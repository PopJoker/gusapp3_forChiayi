import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/mock_api_service.dart';

class ApiService {
  static const String baseUrl = "https://webems.gustech.com.tw/api1";
  static bool useMock = false;

  /// ===== JWT Token =====
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("jwt_token");
  }

  static Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("jwt_token", token);
  }

  /// ===== 自動刷新 Token =====
  static Future<bool> _refreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString("saved_email");
    final password = prefs.getString("saved_password");

    if (email == null || password == null) return false;

    final response = await http.post(
      Uri.parse("$baseUrl/auth/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data["token"] != null) {
        await _saveToken(data["token"]);
        return true;
      }
    }
    return false;
  }

  /// ===== 通用 HTTP 方法（可切換 Mock / 真實 API） =====
  static Future<Map<String, dynamic>> get(String endpoint) async {
    if (useMock) return _mockGet(endpoint);
    return _request("GET", endpoint);
  }

  static Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    if (useMock) {
      // 完全 Mock 登入 / 註冊
      if (endpoint == "/auth/login") {
        return MockApiService.mockLogin(body["email"], body["password"]);
      }
      if (endpoint == "/auth/register") {
        return MockApiService.mockRegister(body["email"], body["password"]);
      }
      // 其他 POST endpoint
      return _mockPost(endpoint, body);
    }

    // 真實 API
    return _request("POST", endpoint, body: body);
  }

  static Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    if (useMock) return _mockPost(endpoint, body);
    return _request("PUT", endpoint, body: body);
  }

  static Future<Map<String, dynamic>> patch(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    if (useMock) return _mockPost(endpoint, body);
    return _request("PATCH", endpoint, body: body);
  }

  static Future<Map<String, dynamic>> delete(String endpoint) async {
    if (useMock)
      return {
        "status": 200,
        "data": {"message": "刪除成功 (Mock)"},
      };
    return _request("DELETE", endpoint);
  }

  /// ===== 真實 API 請求 =====
  static Future<Map<String, dynamic>> _request(
    String method,
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    final token = await _getToken();
    late http.Response response;

    final headers = {"Content-Type": "application/json"};
    if (token != null) headers["Authorization"] = "Bearer $token";

    try {
      switch (method) {
        case "GET":
          response = await http.get(
            Uri.parse("$baseUrl$endpoint"),
            headers: headers,
          );
          break;
        case "POST":
          response = await http.post(
            Uri.parse("$baseUrl$endpoint"),
            headers: headers,
            body: jsonEncode(body),
          );
          break;
        case "PUT":
          response = await http.put(
            Uri.parse("$baseUrl$endpoint"),
            headers: headers,
            body: jsonEncode(body),
          );
          break;
        case "PATCH":
          response = await http.patch(
            Uri.parse("$baseUrl$endpoint"),
            headers: headers,
            body: jsonEncode(body),
          );
          break;
        case "DELETE":
          response = await http.delete(
            Uri.parse("$baseUrl$endpoint"),
            headers: headers,
          );
          break;
        default:
          throw Exception("Unsupported HTTP method");
      }

      var result = _handleResponse(response);

      // Token 過期或不存在，自動刷新
      if (result['status'] == 401) {
        bool refreshed = await _refreshToken();
        if (refreshed) return _request(method, endpoint, body: body);
        return {
          "status": 401,
          "data": {"message": "Token 過期或不存在，請重新登入"},
        };
      }

      return result;
    } catch (e) {
      return {
        "status": 500,
        "data": {"message": "請求失敗", "error": e.toString()},
      };
    }
  }

  /// ===== 處理回應 =====
  static Map<String, dynamic> _handleResponse(http.Response response) {
    try {
      final data = jsonDecode(response.body);
      return {"status": response.statusCode, "data": data};
    } catch (e) {
      return {
        "status": response.statusCode,
        "data": {"message": "回應格式錯誤", "error": e.toString()},
      };
    }
  }

  /// ===== Mock 方法 =====
  static Future<Map<String, dynamic>> _mockGet(String endpoint) async {
    if (endpoint.startsWith("/devices/nowdata")) {
      final parts = endpoint.split('/');
      return MockApiService.getDeviceNowData(parts[3], parts[4]);
    }
    if (endpoint.startsWith("/pcs/nowWhat")) {
      final serial = endpoint.split('/')[3];
      return MockApiService.getPCSNow(serial);
    }
    if (endpoint.startsWith("/log")) {
      final serial = endpoint.split('/')[2].split('?')[0];
      return MockApiService.getlog(serial);
    }
    if (endpoint.startsWith("/devices") && endpoint.contains("/summary")) {
      final serial = endpoint.split('/')[2];
      return MockApiService.getDeviceSummary(serial);
    }
    if (endpoint == "/devices/list") {
      final data = await MockApiService.getUserDevices(); // 回傳 Map 包含 List
      return {
        "status": 200,
        "data": data['data'], // 只取 List 部分
      };
    }
    return {
      "status": 404,
      "data": {"message": "Mock GET 未定義"},
    };
  }

  static Future<Map<String, dynamic>> _mockPost(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    switch (endpoint) {
      case "/auth/login":
        return MockApiService.mockLogin(body["email"], body["password"]);
      case "/auth/register":
        return MockApiService.mockRegister(body["email"], body["password"]);
      case "/pcs/control":
        return MockApiService.controlPCS(
          serialNumber: body["serialNumber"],
          mode: body["payload"]?.keys.first != null
              ? int.tryParse(body["payload"].keys.first)
              : null,
          payload: body["payload"]?.map((k, v) => MapEntry(k, v)),
        );
      case "/devices/update-info":
        return MockApiService.updateDeviceInfo(
          serialNumber: body["serial_number"],
          name: body["name"],
          latitude: body["latitude"],
          longitude: body["longitude"],
          area: body["area"],
        );
      default:
        return {
          "status": 404,
          "data": {"message": "Mock POST 未定義"},
        };
    }
  }

  /// ===== 保留原有方法名稱，不改頁面呼叫 =====
  static Future<Map<String, dynamic>> getDeviceNowData(
    String model,
    String serialNum,
  ) async {
    if (useMock) return MockApiService.getDeviceNowData(model, serialNum);
    final result = await get("/devices/nowdata/$model/$serialNum");
    if (result['status'] == 200 && result['data']['data'] != null) {
      return {"status": 200, "data": result['data']['data']};
    } else {
      return {
        "status": result['status'],
        "data": result['data'] ?? {"message": "沒有資料"},
      };
    }
  }

  static Future<Map<String, dynamic>> controlPCS({
    required String serialNumber,
    int? mode,
    Map<String, int>? payload,
  }) async {
    if (useMock)
      return MockApiService.controlPCS(
        serialNumber: serialNumber,
        mode: mode,
        payload: payload,
      );
    final Map<String, dynamic> body = {
      "serialNumber": serialNumber,
      "dataType": "PCS_Control",
    };
    if (mode != null) body["payload"] = {"$mode": (mode == 1 ? 100 : 0)};
    if (payload != null) body["payload"] = payload;
    return await post("/pcs/control", body);
  }

  static Future<Map<String, dynamic>?> getPCSNow(String serialNum) async {
    final result = await get("/pcs/nowWhat/$serialNum");
    if (result['status'] == 200) {
      // 對 Mock 和真實 API 做區分
      if (useMock) {
        return result['data']; // Mock 直接取 data
      } else {
        return result['data']['data']; // 真實 API 取 data.data
      }
    }
    return null;
  }

  static Future<List<dynamic>?> getlog(String serialNum, {int page = 1}) async {
    if (useMock) return (await MockApiService.getlog(serialNum))['data'];
    final result = await get("/log/$serialNum?page=$page");
    return (result['status'] == 200)
        ? result['data']['data'] as List<dynamic>
        : null;
  }

  static Future<Map<String, dynamic>?> getDeviceSummary(
    String serialNum,
  ) async {
    if (useMock) return MockApiService.getDeviceSummary(serialNum);
    final result = await get("/devices/$serialNum/summary");
    return (result['status'] == 200) ? result['data'] : null;
  }

  static Future<Map<String, dynamic>> updateDeviceInfo({
    required String serialNumber,
    String? name,
    double? latitude,
    double? longitude,
    String? area,
  }) async {
    if (useMock)
      return MockApiService.updateDeviceInfo(
        serialNumber: serialNumber,
        name: name,
        latitude: latitude,
        longitude: longitude,
        area: area,
      );
    final Map<String, dynamic> body = {
      'serial_number': serialNumber,
      if (name != null) 'name': name,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (area != null) 'area': area,
    };
    return await patch("/devices/update-info", body);
  }

}
