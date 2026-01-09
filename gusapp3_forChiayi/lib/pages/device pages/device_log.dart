import 'package:flutter/material.dart';
import '../../utils/theme_colors.dart';
import '../../utils/api_service.dart';
import 'package:intl/intl.dart';
import '../../l10n/l10n.dart'; // 多語言支援
import 'package:translator/translator.dart'; // ← translator 套件

class LogDataWidget extends StatefulWidget {
  const LogDataWidget({super.key, required this.site});
  final Map<String, dynamic> site;

  @override
  State<LogDataWidget> createState() => _LogDataWidgetState();
}

class _LogDataWidgetState extends State<LogDataWidget> {
  List<Map<String, dynamic>> logs = [];
  int currentPage = 1;
  bool isLoading = false;
  bool hasMore = true;
  final int pageLimit = 10;
  final ScrollController _scrollController = ScrollController();
  final translator = GoogleTranslator(); // ← translator 實例

  Future<String> translateText(String text, String targetLang) async {
    try {
      var translation = await translator.translate(text, to: targetLang);
      return translation.text;
    } catch (e) {
      print("Translate error: $e");
      return text; // 失敗就返回原文
    }
  }

  Future<void> _fetchLogs() async {
    setState(() => isLoading = true);

    final result =
        await ApiService.getlog(widget.site['serial_number'], page: currentPage);

    if (result != null && result.isNotEmpty) {
      final locale = S.of(context)!.locale; // 取得 App 語系

      for (var e in result) {
        DateTime dtUtc = DateTime.parse(e['CreateTime'] ?? '');
        DateTime dtLocal = dtUtc.toLocal();
        String formattedTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(dtLocal);

        String title = e['Title'] ?? '';
        String description = e['Message'] ?? '';

        // 即時翻譯
        title = await translateText(title, locale);
        description = await translateText(description, locale);

        logs.add({
          "type": e['Type'] ?? '',
          "title": title,
          "description": description,
          "time": formattedTime,
        });
      }

      setState(() {
        currentPage++;
        if (result.length < pageLimit) hasMore = false;
      });
    } else {
      hasMore = false;
    }

    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    _fetchLogs();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100 &&
          !isLoading &&
          hasMore) {
        _fetchLogs();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;
    final theme = Theme.of(context);
    final isDark = ThemeProvider.themeMode.value == ThemeMode.dark;

    final textColor = isDark ? Colors.white70 : Colors.black87;
    final descColor = isDark ? Colors.white60 : Colors.black54;
    final backgroundColor = isDark ? Colors.black : Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text(
          s.deviceLog,
          style: TextStyle(
              color: textColor,
              shadows: [Shadow(color: Colors.cyanAccent.withOpacity(0.5), blurRadius: 4)]),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${s.serialNumber}：${widget.site['serial_number'] ?? s.unknown}",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: textColor,
                shadows: [Shadow(color: Colors.cyanAccent.withOpacity(0.5), blurRadius: 4)],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "${s.model}：${widget.site['model'] ?? s.unknownModel}",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: textColor,
                shadows: [Shadow(color: Colors.cyanAccent.withOpacity(0.3), blurRadius: 2)],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: logs.isEmpty
                  ? Center(
                      child: Text(
                        s.noLogs,
                        style: TextStyle(color: textColor, fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount: logs.length + (hasMore ? 0 : 1),
                      itemBuilder: (context, index) {
                        if (!hasMore && index == logs.length) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Center(
                              child: Text(
                                s.lastEntry,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: descColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        }

                        final log = logs[index];
                        final isWarning = log['type'] == 'Alarm';
                        final color = isWarning
                            ? (isDark ? Colors.redAccent : Colors.red)
                            : (isDark ? Colors.cyanAccent : Colors.blue);

                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: color, width: 1.2),
                            boxShadow: [
                              BoxShadow(color: color.withOpacity(0.4), blurRadius: 6, offset: const Offset(0, 2))
                            ],
                          ),
                          child: ExpansionTile(
                            leading: Icon(isWarning ? Icons.warning_amber_rounded : Icons.info_outline,
                                color: color),
                            title: Text(
                              log['title'],
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isDark ? color : Colors.black,
                                shadows: [Shadow(color: color.withOpacity(0.7), blurRadius: 4)],
                              ),
                            ),
                            children: [
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: isDark ? Colors.grey[900]?.withOpacity(0.2) : Colors.grey[100]?.withOpacity(0.2),
                                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      log['description'],
                                      style: theme.textTheme.bodySmall?.copyWith(color: descColor),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      log['time'],
                                      style: theme.textTheme.bodySmall?.copyWith(color: descColor),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}
