import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme_notifier.dart';

class PreferenceSettingsScreen extends StatelessWidget {
  const PreferenceSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('環境設定')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('テーマ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<ThemeMode>(
              value: themeNotifier.themeMode,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: ThemeMode.system, child: Text('システム')),
                DropdownMenuItem(value: ThemeMode.light, child: Text('ライト')),
                DropdownMenuItem(value: ThemeMode.dark, child: Text('ダーク')),
              ],
              onChanged: (mode) {
                if (mode != null) {
                  themeNotifier.setTheme(mode);
                }
              },
            ),
            const SizedBox(height: 24),
            // 他の設定項目をここに追加可能
          ],
        ),
      ),
    );
  }
}
