import 'package:flutter/material.dart';
import 'LES/device_data.dart';
import 'HES/device_data.dart';
import 'LES/device_summary.dart';
import 'device_history.dart';
import 'device_money.dart';
import 'device_set.dart';
import 'device_log.dart';
import '../../utils/theme_colors.dart';
import '../../l10n/l10n.dart';
import '../../global.dart';
import 'package:flutter/services.dart';

/// =========================
/// 外層 Wrapper 控制整頁刷新
/// =========================
class DataHomePageWrapper extends StatefulWidget {
  final Map<String, dynamic> site;
  const DataHomePageWrapper({super.key, required this.site});

  @override
  State<DataHomePageWrapper> createState() => _DataHomePageWrapperState();
}

class _DataHomePageWrapperState extends State<DataHomePageWrapper>
    with WidgetsBindingObserver {
  Key _pageKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // App 從背景回到前景，刷新整個頁面
      setState(() {
        _pageKey = UniqueKey();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DataHomePage(
      key: _pageKey,
      site: widget.site,
    );
  }
}

/// =========================
/// 原本的 DataHomePage
/// =========================
class DataHomePage extends StatefulWidget {
  const DataHomePage({super.key, required this.site});
  final Map<String, dynamic> site;

  @override
  State<DataHomePage> createState() => _DataHomePageState();
}

class _DataHomePageState extends State<DataHomePage>
    with WidgetsBindingObserver {
  int _currentIndex = 0;
  double _menuWidth = 60;
  final double _minWidth = 60;
  final double _maxWidth = 180;

  bool get _isFullyExpanded => _menuWidth > _minWidth;

  Key _revenuePageKey = UniqueKey();

  late List<String> _menuTitles;
  late List<IconData> _menuIcons;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// 手勢控制側邊欄
  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _menuWidth += details.delta.dx;
      if (_menuWidth < _minWidth) _menuWidth = _minWidth;
      if (_menuWidth > _maxWidth) _menuWidth = _maxWidth;
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    setState(() {
      _menuWidth = _menuWidth < (_minWidth + _maxWidth) / 2
          ? _minWidth
          : _maxWidth;
    });
  }

  void _onTapCollapsed() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _menuTitles.length;
    });
  }

  /// 根據機型建立側邊選單與頁面
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
        ];

        _menuIcons = [
          Icons.storage,
          Icons.history,
          Icons.attach_money,
          Icons.settings_applications,
          Icons.read_more,
        ];

        _pages = [
          DeviceSummaryWidget(
            model: widget.site['model'] ?? "未知型號",
            serialNum: widget.site['serial_number'] ?? "0000",
          ),
          HistoryDataWidget(
            model: widget.site['model'] ?? "未知型號",
            serialNum: widget.site['serial_number'] ?? "0000",
          ),
          RevenuePageWidget(key: _revenuePageKey, site: widget.site),
          SettingPageWidget(
            model: widget.site['model'] ?? "未知型號",
            serialNum: widget.site['serial_number'] ?? "0000",
            onTargetsChanged: (daily, monthly) {
              setState(() {
                _revenuePageKey = UniqueKey(); // 只刷新 RevenuePage
              });
            },
          ),
          LogDataWidget(site: widget.site),
        ];
        break;

      case "HES":
        _menuTitles = [
          S.of(context)!.realTimeData,
          S.of(context)!.basicSetting,
          S.of(context)!.logSetting,
        ];

        _menuIcons = [
          Icons.storage,
          Icons.settings_applications,
          Icons.read_more,
        ];

        _pages = [
          HesDeviceDataWidget(
            model: widget.site['model'] ?? "未知型號",
            serialNum: widget.site['serial_number'] ?? "0000",
          ),
          SettingPageWidget(
            model: widget.site['model'] ?? "未知型號",
            serialNum: widget.site['serial_number'] ?? "0000",
            onTargetsChanged: (daily, monthly) {
              setState(() {
                _revenuePageKey = UniqueKey();
                _currentIndex = _menuTitles.indexOf(
                  S.of(context)!.deviceRevenue,
                );
              });
            },
          ),
          LogDataWidget(site: widget.site),
        ];
        break;

      default:
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
            onTargetsChanged: (daily, monthly) {
              setState(() {
                _revenuePageKey = UniqueKey();
                _currentIndex = _menuTitles.indexOf(
                  S.of(context)!.deviceRevenue,
                );
              });
            },
          ),
        ];
    }

    if (_currentIndex >= _pages.length) {
      _currentIndex = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    _buildModelMenu(context);

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeProvider.themeMode,
      builder: (context, themeMode, child) {
        bool isDark = themeMode == ThemeMode.dark;
        Color backgroundStart = isDark ? const Color(0xFF010402) : const Color(0xFFF0FFF0);
        Color backgroundEnd = isDark ? const Color(0xFF081E12) : const Color(0xFFC8FFC8);
        Color menuBase = isDark ? Colors.black87 : Colors.white70;
        Color menuActive = isDark ? const Color(0xFF00FF00) : const Color(0xFF00A81C);
        Color menuInactive = isDark ? const Color.fromARGB(121, 255, 255, 255) : const Color.fromARGB(118, 0, 0, 0);

        return Scaffold(
          body: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [backgroundStart, backgroundEnd],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              IndexedStack(index: _currentIndex, children: _pages),
              Positioned(
                top: 0,
                left: 0,
                bottom: 0,
                child: GestureDetector(
                  onTap: _isFullyExpanded ? null : _onTapCollapsed,
                  onHorizontalDragUpdate: _onHorizontalDragUpdate,
                  onHorizontalDragEnd: _onHorizontalDragEnd,
                  child: _isFullyExpanded
                      ? Container(
                          width: _menuWidth,
                          color: menuBase,
                          child: Column(
                            children: [
                              const Spacer(),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _menuTitles.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    leading: Icon(
                                      _menuIcons[index],
                                      color: _currentIndex == index ? menuActive : menuInactive,
                                    ),
                                    title: Text(
                                      _menuTitles[index],
                                      style: TextStyle(
                                        color: _currentIndex == index ? menuActive : menuInactive,
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
                              const Spacer(),
                            ],
                          ),
                        )
                      : Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: menuBase,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _menuIcons[_currentIndex],
                            color: menuActive,
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
