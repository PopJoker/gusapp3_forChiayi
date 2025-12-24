import 'package:flutter/material.dart';
import '../utils/theme_colors.dart';
import '../l10n/l10n.dart'; // <-- 引入語系檔
import '../global.dart';    // <-- ThemeProvider

class CustomerServicePage extends StatelessWidget {
  const CustomerServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = ThemeProvider.themeMode.value == ThemeMode.dark;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context)!.needHelp, // 多語系
              style: theme.textTheme.headlineSmall?.copyWith(
                color: isDark ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              S.of(context)!.contactUsText, // 多語系
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.email, color: Colors.cyan),
              title: Text(S.of(context)!.customerEmail), // 多語系
              subtitle: const Text("support@gus.com"),
              onTap: () {
                // TODO: 打開信箱功能
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone, color: Colors.green),
              title: Text(S.of(context)!.customerPhone), // 多語系
              subtitle: const Text("03-451-2688"),
              onTap: () {
                // TODO: 撥打電話
              },
            ),
            ListTile(
              leading: const Icon(Icons.chat, color: Colors.blue),
              title: Text(S.of(context)!.onlineChat), // 多語系
              subtitle: Text(S.of(context)!.chatNow), // 多語系
              onTap: () {
                // TODO: WebSocket 聊天
              },
            ),
            const SizedBox(height: 24),
            Text(
              S.of(context)!.taipowerIssueTitle, // 多語系
              style: theme.textTheme.headlineSmall?.copyWith(
                color: isDark ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              S.of(context)!.taipowerIssueText, // 多語系
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.phone, color: Colors.green),
              title: Text(S.of(context)!.taipowerPhone), // 多語系
              subtitle: const Text("1911"),
              onTap: () {
                // TODO: 撥打電話
              },
            ),
          ],
        ),
      ),
    );
  }
}
