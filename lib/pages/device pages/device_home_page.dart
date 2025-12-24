import 'package:flutter/material.dart';
import 'LES/device_data.dart';
import 'HES/device_data.dart';
import 'device_history.dart';
import 'device_money.dart';
import 'device_pcs.dart';
import 'device_set.dart';
import 'device_log.dart';
import '../../utils/theme_colors.dart';
import '../../l10n/l10n.dart';
import '../../global.dart';

class DataHomePage extends StatefulWidget {
  const DataHomePage({super.key, required this.site});
  final Map<String, dynamic> site;

  @override
  State<DataHomePage> createState() => _DataHomePageState();
}

class _DataHomePageState extends State<DataHomePage> with WidgetsBindingObserver {
  int _currentIndex = 0;
  double _menuWidth = 60;
  final double _minWidth = 60;
  final double _maxWidth = 180;

  bool get _isFullyExpanded => _menuWidth > _minWidth;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // 監聽生命周期
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // 移除監聽
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // App 從背景或鎖螢幕回到前景，退回上一頁
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _menuWidth += details.delta.dx;
      if (_menuWidth < _minWidth) _menuWidth = _minWidth;
      if (_menuWidth > _maxWidth) _menuWidth = _maxWidth;
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    setState(() {
      if (_menuWidth < (_minWidth + _maxWidth) / 2) {
        _menuWidth = _minWidth;
      } else {
        _menuWidth = _maxWidth;
      }
    });
  }

  void _onTapCollapsed() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _menuTitles.length;
    });
  }

  // 預設為空，等 switch 給值
  late List<String> _menuTitles;
  late List<IconData> _menuIcons;
  late List<Widget> _pages;

  void _buildModelMenu(BuildContext context) {
    final model = (widget.site['model'] ?? "").toString().toUpperCase();

    switch (model) {
      case "LES":
        _menuTitles = [
          S.of(context)!.realTimeData,
          S.of(context)!.historyData,
          S.of(context)!.deviceRevenue,
          S.of(context)!.basicSetting,
          S.of(context)!.logSetting,
          S.of(context)!.pcsSetting,
        ];

        _menuIcons = [
          Icons.storage,
          Icons.history,
          Icons.attach_money,
          Icons.settings_applications,
          Icons.read_more,
          Icons.build,
        ];

        _pages = [
          DeviceDataWidget(
            model: widget.site['model'] ?? "未知型號",
            serialNum: widget.site['serial_number'] ?? "0000",
          ),
          HistoryDataWidget(
            model: widget.site['model'] ?? "未知型號",
            serialNum: widget.site['serial_number'] ?? "0000",
          ),
          RevenuePageWidget(site: widget.site),
          SettingPageWidget(
            model: widget.site['model'] ?? "未知型號",
            serialNum: widget.site['serial_number'] ?? "0000",
          ),
          LogDataWidget(site: widget.site),
          PCSSettingPageWidget(
            model: widget.site['model'] ?? "未知型號",
            serialNum: widget.site['serial_number'] ?? "0000",
          ),
        ];
        break;

      case "HES":
        _menuTitles = [
          S.of(context)!.realTimeData,
          // S.of(context)!.historyData,
          // S.of(context)!.deviceRevenue,
          S.of(context)!.basicSetting,
          S.of(context)!.logSetting,
        ];

        _menuIcons = [
          Icons.storage,
          // Icons.history,
          // Icons.attach_money,
          Icons.settings_applications,
          Icons.read_more,
        ];

        _pages = [
          HesDeviceDataWidget(
            model: widget.site['model'] ?? "未知型號",
            serialNum: widget.site['serial_number'] ?? "0000",
          ),
          // HistoryDataWidget(
          //   model: widget.site['model'] ?? "未知型號",
          //   serialNum: widget.site['serial_number'] ?? "0000",
          // ),
          // RevenuePageWidget(site: widget.site),
           SettingPageWidget(
             model: widget.site['model'] ?? "未知型號",
             serialNum: widget.site['serial_number'] ?? "0000",
          ),
          LogDataWidget(site: widget.site),
        ];
        break;

      default:
        // 預設：不明型號
        _menuTitles = [
          S.of(context)!.realTimeData,
          S.of(context)!.historyData,
          S.of(context)!.basicSetting,
        ];
        _menuIcons = [
          Icons.storage,
          Icons.history,
          Icons.settings_applications,
        ];
        _pages = [
          DeviceDataWidget(
            model: widget.site['model'] ?? "未知型號",
            serialNum: widget.site['serial_number'] ?? "0000",
          ),
          HistoryDataWidget(
            model: widget.site['model'] ?? "未知型號",
            serialNum: widget.site['serial_number'] ?? "0000",
          ),
          SettingPageWidget(
            model: widget.site['model'] ?? "未知型號",
            serialNum: widget.site['serial_number'] ?? "0000",
          ),
        ];
    }

    // 防止 index 超出範圍
    if (_currentIndex >= _pages.length) {
      _currentIndex = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    _buildModelMenu(context); // 在 build 內根據 model 動態設定

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeProvider.themeMode,
      builder: (context, themeMode, child) {
        bool isDark = themeMode == ThemeMode.dark;
        Color backgroundStart = isDark ? const Color(0xFF010402) : const Color(0xFFF0FFF0);
        Color backgroundEnd = isDark ? const Color(0xFF081E12) : const Color(0xFFC8FFC8);
        Color menuBase = isDark ? Colors.black87 : Colors.white70;
        Color menuActive = isDark ? const Color(0xFF00FF00) : const Color(0xFF00A81C);
        Color menuInactive =
            isDark ? const Color.fromARGB(121, 255, 255, 255) : const Color.fromARGB(118, 0, 0, 0);

        return Scaffold(
          body: Stack(
            children: [
              // 背景
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [backgroundStart, backgroundEnd],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),

              // 主畫面
              IndexedStack(index: _currentIndex, children: _pages),

              // 側邊選單
              Positioned(
                top: 10,
                left: 0,
                bottom: 0,
                child: GestureDetector(
                  onTap: _isFullyExpanded ? null : _onTapCollapsed,
                  onHorizontalDragUpdate: _onHorizontalDragUpdate,
                  onHorizontalDragEnd: _onHorizontalDragEnd,
                  child: _isFullyExpanded
                      ? Container(
                          alignment: Alignment.center,
                          width: _menuWidth,
                          height: MediaQuery.of(context).size.height,
                          color: menuBase,
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: _menuTitles.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      leading: Icon(
                                        _menuIcons[index],
                                        color: _currentIndex == index
                                            ? menuActive
                                            : menuInactive,
                                      ),
                                      title: Text(
                                        _menuTitles[index],
                                        style: TextStyle(
                                          color: _currentIndex == index
                                              ? menuActive
                                              : menuInactive,
                                        ),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          _currentIndex = index;
                                          _menuWidth = _minWidth;
                                        });
                                      },
                                    );
                                  },
                                ),
                              ),
                              ListTile(
                                leading: Icon(Icons.arrow_back, color: menuInactive),
                                title: Text(S.of(context)!.backToHome,
                                    style: TextStyle(color: menuInactive)),
                                onTap: () => Navigator.pop(context),
                              ),
                              const SizedBox(height: 50),
                            ],
                          ),
                        )
                      : Container(
                          margin: const EdgeInsets.only(top: 20,  right: 8),
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: menuBase,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: const Offset(2, 2),
                              )
                            ],
                          ),
                          child: Icon(
                            _menuIcons[_currentIndex],
                            color: menuActive,
                            size: 24,
                          ),
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
