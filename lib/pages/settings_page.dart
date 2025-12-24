// settings_pages.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../utils/api_service.dart';
import '../widget/floating_message.dart';
import '../utils/theme_colors.dart';
import '../utils/map.dart';
import 'package:latlong2/latlong.dart';
import '../l10n/l10n.dart'; // <-- 語系檔
import '../global.dart'; // <-- currentLocale

class SettingsPage extends StatefulWidget {
  final List<Map<String, dynamic>> addedSites;
  final Function(Map<String, dynamic>) onSiteAdded;

  const SettingsPage({
    super.key,
    required this.addedSites,
    required this.onSiteAdded,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _siteNameController = TextEditingController();
  final TextEditingController _barcodeController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _siteAreaController = TextEditingController();
  String? _removingSiteBarcode;

  bool _hintShown = false;
  Map<String, bool> _showUnbindButton = {};

  @override
  void initState() {
    super.initState();
    fetchBoundDevices();
  }

  @override
  void dispose() {
    _siteNameController.dispose();
    _barcodeController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _siteAreaController.dispose();
    super.dispose();
  }

  Future<void> fetchBoundDevices() async {
    try {
      final result = await ApiService.get("/devices/list");
      if (result["status"] == 200) {
        final data = result["data"];
        List<Map<String, dynamic>> apiDevices = [];
        if (data is List) {
          apiDevices = data.map((d) => Map<String, dynamic>.from(d)).toList();
        }
        setState(() {
          widget.addedSites.clear();
          for (var d in apiDevices) {
            widget.addedSites.add({
              "barcode": d["serial_number"]?.toString() ?? '',
              "name":
                  d["name"]?.toString() ??
                  d["model"]?.toString() ??
                  d["serial_number"]?.toString() ??
                  '',
              "online": true,
            });
            _showUnbindButton[d["serial_number"]?.toString() ?? ''] = false;
          }
        });
      } else {
        FloatingMessage.show(
          context,
          S.of(context)!.deviceListFetchFailed,
          autoHide: true,
        );
      }
    } catch (e) {
      print("Fetch error: $e");
    }
  }

  Future<void> _addSite() async {
    String siteName = _siteNameController.text.trim();
    String barcode = _barcodeController.text.trim();
    double? latitude = double.tryParse(_latitudeController.text.trim());
    double? longitude = double.tryParse(_longitudeController.text.trim());
    String area = _siteAreaController.text.trim();
    if (siteName.isEmpty || barcode.isEmpty) return;

    bool exists = widget.addedSites.any((site) => site['barcode'] == barcode);
    if (exists) {
      FloatingMessage.show(context, S.of(context)!.barcodeExists, autoHide: true);
      return;
    }
    if (latitude == null || latitude < -90 || latitude > 90) {
      FloatingMessage.show(context, S.of(context)!.latitudeInvalid, autoHide: true);
      return;
    }
    if (longitude == null || longitude < -180 || longitude > 180) {
      FloatingMessage.show(context, S.of(context)!.longitudeInvalid, autoHide: true);
      return;
    }

    final result = await ApiService.post("/devices/bind", {
      "serial_number": barcode,
      "name": siteName,
      "latitude": latitude,
      "longitude": longitude,
      "area": area,
    });

    if (result["status"] == 200) {
      final site = {"barcode": barcode, "name": siteName, "online": true};
      widget.onSiteAdded(site);
      _showUnbindButton[barcode] = false;
      setState(() {});
      FloatingMessage.show(context, S.of(context)!.bindSuccess, autoHide: true);
      _siteNameController.clear();
      _barcodeController.clear();
      _latitudeController.clear();
      _longitudeController.clear();
      _siteAreaController.clear();
    } else {
      FloatingMessage.show(
        context,
        result["data"]["message"] ?? S.of(context)!.bindFailed,
        autoHide: true,
      );
    }
  }

  Future<void> _scanBarcode() async {
  String? scannedCode = await showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(S.of(context)!.scanBarcode),
      content: SizedBox(
        width: 300,
        height: 400,
        child: MobileScanner(
          onDetect: (capture) {
            final barcode = capture.barcodes.first;
            final String? code = barcode.rawValue;
            if (code != null && code.isNotEmpty) {
              Navigator.of(context).pop(code);
            }
          },
        ),
      ),
    ),
  );

  if (scannedCode != null && scannedCode.isNotEmpty) {
    setState(() {
      _barcodeController.text = scannedCode;
    });
  }
}

  Future<void> _unbindSite(String barcode) async {
    final result = await ApiService.post("/devices/unbind", {
      "serial_number": barcode,
    });
    if (result["status"] == 200) {
      FloatingMessage.show(context, S.of(context)!.unbindSuccess, autoHide: true);
      setState(() {
        widget.addedSites.removeWhere((site) => site['barcode'] == barcode);
        _showUnbindButton.remove(barcode);
      });
    } else {
      FloatingMessage.show(
        context,
        result["data"]["message"] ?? S.of(context)!.unbindFailed,
        autoHide: true,
      );
    }
  }

  void _showUnbindDialog(Map<String, dynamic> site) {
    bool isDark = ThemeProvider.themeMode.value == ThemeMode.dark;
    Color textColor = isDark ? Colors.white : Colors.black87;
    Color accentColor = isDark
        ? const Color.fromARGB(255, 0, 255, 8)
        : const Color.fromARGB(221, 0, 168, 28);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? Colors.black87 : Colors.white,
        title: Text(
          S.of(context)!.confirmUnbindTitle,
          style: TextStyle(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          "${S.of(context)!.confirmUnbindContent} ${site['name']} ?"
,
          style: TextStyle(color: textColor, fontSize: 20),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.grey),
            onPressed: () => Navigator.pop(context),
            child: Text(S.of(context)!.cancel),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: accentColor),
            onPressed: () {
              Navigator.pop(context);
              _unbindSite(site['barcode']);
            },
            child: Text(S.of(context)!.confirm),
          ),
        ],
      ),
    );
  }

  Widget _modernGlassCard({required Widget child}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.5),
            Colors.white.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Padding(padding: const EdgeInsets.all(20), child: child),
        ),
      ),
    );
  }

  Widget _inputField(
    TextEditingController controller,
    String hint,
    IconData icon,
    Color textColor,
    Color hintColor,
    Color accentColor, {
    bool obscure = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: TextStyle(color: textColor, fontSize: 16),
      cursorColor: accentColor,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: accentColor),
        hintText: hint,
        hintStyle: TextStyle(color: hintColor),
        filled: true,
        fillColor: Colors.white.withOpacity(0.15),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: accentColor, width: 2),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeProvider.themeMode,
      builder: (context, themeMode, child) {
        bool isDark = themeMode == ThemeMode.dark;
        Color background = isDark
            ? const Color(0xFF010402)
            : const Color.fromARGB(255, 240, 255, 240);
        Color backgroundEnd = isDark
            ? const Color(0xFF002200)
            : const Color.fromARGB(255, 200, 255, 200);
        Color textColor = isDark ? Colors.white : Colors.black87;
        Color hintColor = isDark ? Colors.white54 : Colors.black45;
        Color accentColor = isDark
            ? const Color.fromARGB(255, 0, 255, 8)
            : const Color.fromARGB(221, 0, 168, 28);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (widget.addedSites.isNotEmpty && !_hintShown) {
            FloatingMessage.show(
              context,
              S.of(context)!.hintUnbind,
              autoHide: true,
            );
            _hintShown = true;
          }
        });

        return Scaffold(
          backgroundColor: background,
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [background, backgroundEnd],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // 新增設備
                    _modernGlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            S.of(context)!.addEnergyDevice,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: accentColor,
                            ),
                          ),
                          const SizedBox(height: 15),
                          _inputField(
                            _siteNameController,
                            S.of(context)!.deviceName,
                            Icons.device_hub,
                            textColor,
                            hintColor,
                            accentColor,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _inputField(
                                  _barcodeController,
                                  S.of(context)!.barcode,
                                  Icons.qr_code,
                                  textColor,
                                  hintColor,
                                  accentColor,
                                ),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: _scanBarcode,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: accentColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.all(16),
                                ),
                                child: const Icon(
                                  Icons.qr_code_scanner,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _inputField(
                                  _latitudeController,
                                  S.of(context)!.latitude,
                                  Icons.my_location,
                                  textColor,
                                  hintColor,
                                  accentColor,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _inputField(
                                  _longitudeController,
                                  S.of(context)!.longitude,
                                  Icons.map,
                                  textColor,
                                  hintColor,
                                  accentColor,
                                ),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () async {
                                  LatLng? result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => MapPickerPage(
                                        initialLat: double.tryParse(
                                          _latitudeController.text,
                                        ),
                                        initialLng: double.tryParse(
                                          _longitudeController.text,
                                        ),
                                      ),
                                    ),
                                  );
                                  if (result != null) {
                                    setState(() {
                                      _latitudeController.text = result.latitude
                                          .toStringAsFixed(6);
                                      _longitudeController.text = result
                                          .longitude
                                          .toStringAsFixed(6);
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: accentColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.all(16),
                                ),
                                child: const Icon(
                                  Icons.map,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _inputField(
                            _siteAreaController,
                            S.of(context)!.deviceArea,
                            Icons.location_city,
                            textColor,
                            hintColor,
                            accentColor,
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _addSite,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: accentColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                S.of(context)!.addDevice,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 已接入設備
                    _modernGlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            S.of(context)!.addedDevices,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: accentColor,
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (widget.addedSites.isEmpty)
                            Center(
                              child: Text(
                                S.of(context)!.noDevicesYet,
                                style: TextStyle(
                                  color: textColor.withOpacity(0.5),
                                ),
                              ),
                            ),
                          ...widget.addedSites.map((site) {
                            String barcode = site['barcode'];
                            bool online = site['online'] ?? true;

                            return GestureDetector(
                              onLongPress: () => setState(
                                () => _showUnbindButton[barcode] = true,
                              ),
                              child: AnimatedSize(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                child: AnimatedOpacity(
                                  duration: const Duration(milliseconds: 300),
                                  opacity: _removingSiteBarcode == barcode
                                      ? 0.0
                                      : 1.0,
                                  child: Dismissible(
                                    key: Key(barcode),
                                    direction: DismissDirection.endToStart,
                                    background: Container(
                                      alignment: Alignment.centerRight,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                      ),
                                      color: Colors.redAccent,
                                      child: const Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                    ),
                                    confirmDismiss: (direction) async {
                                      return await showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          backgroundColor: isDark
                                              ? Colors.black87
                                              : Colors.white,
                                          title: Text(
                                            S.of(context)!.confirmUnbindTitle,
                                            style: TextStyle(
                                              color: textColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          content: Text(
                                            "${S.of(context)!.confirmUnbindContent} ${site['name']} ?"
,
                                            style: TextStyle(color: textColor),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, false),
                                              child: Text(S.of(context)!.cancel),
                                            ),
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, true),
                                              child: Text(
                                                S.of(context)!.confirm,
                                                style: const TextStyle(
                                                  color: Colors.redAccent,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    onDismissed: (direction) =>
                                        _unbindSite(barcode),
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors:
                                              (_showUnbindButton[barcode] ?? false)
                                              ? [
                                                  Colors.red.withOpacity(0.3),
                                                  Colors.red.withOpacity(0.1),
                                                ]
                                              : [
                                                  Colors.white.withOpacity(0.15),
                                                  Colors.white.withOpacity(0.05),
                                                ],
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.battery_charging_full,
                                          color: online
                                              ? accentColor
                                              : Colors.red,
                                          size: 30,
                                        ),
                                        title: Text(
                                          site['name'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: textColor,
                                          ),
                                        ),
                                        subtitle: Text(
                                          site['barcode'],
                                          style: TextStyle(color: textColor),
                                        ),
                                        trailing: IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.redAccent,
                                          ),
                                          onPressed: () async {
                                            bool confirm = await showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                backgroundColor: isDark
                                                    ? Colors.black87
                                                    : Colors.white,
                                                title: Text(
                                                  S.of(context)!.confirmUnbindTitle,
                                                  style: TextStyle(
                                                    color: textColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                content: Text(
                                                  "${S.of(context)!.confirmUnbindContent} ${site['name']} ?"
,
                                                  style: TextStyle(
                                                    color: textColor,
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context, false),
                                                    child: Text(S.of(context)!.cancel),
                                                  ),
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context, true),
                                                    child: Text(
                                                      S.of(context)!.confirm,
                                                      style: const TextStyle(
                                                        color: Colors.redAccent,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                            if (confirm) {
                                              setState(
                                                () => _removingSiteBarcode =
                                                    barcode,
                                              );
                                              await Future.delayed(
                                                const Duration(
                                                  milliseconds: 300,
                                                ),
                                              );
                                              _unbindSite(barcode);
                                              setState(
                                                () =>
                                                    _removingSiteBarcode = null,
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
