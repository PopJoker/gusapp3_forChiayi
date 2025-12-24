import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/theme_colors.dart';
import '../l10n/l10n.dart';
import 'device_pages.dart';
import 'settings_page.dart';
import 'APP_set.dart';
import 'customer_service_page.dart';
import 'tutor.dart';
import 'login_page.dart';
import '../utils/api_service.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:http/http.dart' as http;


class DataPage extends StatefulWidget {
  final void Function(Locale locale)? onChangeLocale; // 語言切換回調
  const DataPage({super.key, this.onChangeLocale});

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  int _currentIndex = 0;
  List<Map<String, dynamic>> addedSites = [];
  late List<Widget> _pages;
  late SettingsPage settingsPage;

  @override
  void initState() {
    super.initState();
    settingsPage = SettingsPage(
      addedSites: addedSites,
      onSiteAdded: (site) {
        setState(() {
          addedSites.add(site);
        });
      },
    );

    _pages = [
      const DevicePage(),
      settingsPage,
      APPSettingPageWidget(),
      CustomerServicePage(),
      TutorPage(),
    ];
  }

  void _switchPage(int index) {
    setState(() => _currentIndex = index);
    Navigator.pop(context); // 關閉 Drawer
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeProvider.themeMode,
      builder: (context, themeMode, child) {
        bool isDark = themeMode == ThemeMode.dark;
        Color background = isDark ? Colors.black : Colors.white;
        Color accentColor = isDark
            ? const Color.fromARGB(255, 0, 255, 8)
            : const Color.fromARGB(221, 0, 168, 28);

        return Scaffold(
          backgroundColor: background,
          appBar: AppBar(
            backgroundColor: isDark ? Colors.black87 : Colors.white,
            title: Text(
              S.of(context)!.energySystem,
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
            ),
            centerTitle: true,
            iconTheme: IconThemeData(color: accentColor),
            actions: [
              IconButton(
                icon: Icon(isDark ? Icons.dark_mode : Icons.light_mode,
                    color: accentColor),
                onPressed: () => ThemeProvider.toggleTheme(),
              ),
            ],
          ),
          drawer: Drawer(
            child: Container(
              color: isDark ? Colors.black87 : Colors.white,
              child: Column(
                children: [
                  DrawerHeader(
                    decoration:
                        BoxDecoration(color: isDark ? Colors.black87 : Colors.white),
                    margin: EdgeInsets.zero,
                    padding: const EdgeInsets.only(top: 16, left: 16),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          left: 0,
                          child: Text(
                            S.of(context)!.menu,
                            style: TextStyle(
                                color: accentColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Positioned(
                          top: -20,
                          right: -70,
                          child: Opacity(
                            opacity: 0.15,
                            child: Image.asset(
                              isDark ? 'assets/GUSLOGO2.png' : 'assets/GUSLOGO.png',
                              width: 250,
                              height: 250,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        _buildDrawerTile(Icons.storage, S.of(context)!.deviceList, 0,
                            isDark, accentColor),
                        _buildDrawerTile(Icons.settings,
                            S.of(context)!.addOrRemoveBinding, 1, isDark, accentColor),
                        _buildDrawerTile(Icons.app_settings_alt,
                            S.of(context)!.appSettings, 2, isDark, accentColor),
                        Divider(color: accentColor),
                        _buildDrawerTile(Icons.support_agent,
                            S.of(context)!.customerService, 3, isDark, accentColor),
                        _buildDrawerTile(
                            Icons.school, S.of(context)!.tutorial, 4, isDark, accentColor),
                        _buildDrawerTile(
                            Icons.info, S.of(context)!.aboutUs, null, isDark, accentColor),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      children: [
                        Divider(color: accentColor),
                        // 登出按鈕
                        ListTile(
                          leading: const Icon(Icons.logout, color: Colors.red),
                          title:
                              Text(S.of(context)!.logout, style: const TextStyle(color: Colors.red)),
                          onTap: () {
                            _showLogoutDialog(isDark, accentColor);
                          },
                        ),
                        // 刪除帳號按鈕
                        ListTile(
                          leading: const Icon(Icons.delete_forever, color: Colors.red),
                          title: Text(S.of(context)!.deleteAccount,
                              style: const TextStyle(color: Colors.red)),
                          onTap: () {
                            _showDeleteAccountDialog(isDark, accentColor);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: _pages[_currentIndex],
        );
      },
    );
  }

  Widget _buildDrawerTile(
      IconData icon, String title, int? pageIndex, bool isDark, Color accentColor) {
    if (title == S.of(context)!.aboutUs) {
      return ListTile(
        leading: Icon(icon, color: isDark ? Colors.white : Colors.black87),
        title: Text(title, style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
        onTap: () async {
          String url;
          Locale locale = Localizations.localeOf(context);
          if (locale.languageCode == 'en') {
            url = "https://www.gustech.com/en";
          } else {
            url = "https://www.gustech.com/";
          }

          final Uri uri = Uri.parse(url);

          if (!await launchUrl(uri,
              mode: LaunchMode.externalApplication)) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(S.of(context)!.cannotOpenUrl(url))),
            );
          }

          Navigator.pop(context);
        },
      );
    }

    bool selected = pageIndex != null && _currentIndex == pageIndex;
    Color textColor = selected ? accentColor : (isDark ? Colors.white : Colors.black87);
    Color iconColor = textColor;

    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: TextStyle(color: textColor)),
      selected: selected,
      onTap: pageIndex != null ? () => _switchPage(pageIndex) : null,
    );
  }

  void _showLogoutDialog(bool isDark, Color accentColor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? Colors.black87 : Colors.white,
        title: Text(S.of(context)!.confirmLogout,
            style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
        actions: [
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.grey),
            onPressed: () => Navigator.pop(context),
            child: Text(S.of(context)!.cancel),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: accentColor),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const AuthPage()),
                (route) => false,
              );
            },
            child: Text(S.of(context)!.logout),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(bool isDark, Color accentColor) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: isDark ? Colors.black87 : Colors.white,
      title: Text(
        S.of(context)!.confirmDeleteAccount,
        style: TextStyle(color: isDark ? Colors.white : Colors.black87),
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(foregroundColor: Colors.grey),
          onPressed: () => Navigator.pop(context),
          child: Text(S.of(context)!.cancel),
        ),
        TextButton(
          style: TextButton.styleFrom(foregroundColor: accentColor),
          onPressed: () async {
            Navigator.pop(context); // 先關閉對話框

            // 呼叫 ApiService.delete 刪除帳號
            final result = await ApiService.post("/auth/delete", {});

            if (result['status'] == 200) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(S.of(context)!.accountDeletedSuccessfully)),
              );
              // 刪除成功導向登入頁
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const AuthPage()),
                (route) => false,
              );
            } else {
              String msg = result['data']['message'] ?? S.of(context)!.deleteFailed;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(msg)),
              );
            }
          },
          child: Text(S.of(context)!.delete),
        ),
      ],
    ),
  );
}
}
