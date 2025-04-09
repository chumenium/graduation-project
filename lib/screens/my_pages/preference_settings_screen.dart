import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/theme_notifier.dart';

class PreferenceSettingsScreen extends StatelessWidget {
  const PreferenceSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('環境設定')),
      body: Column(
        children: [
          ListTile(
            title: const Text('テーマ'),
            subtitle: Text(themeNotifier.themeMode == ThemeMode.light
                ? 'ライト'
                : themeNotifier.themeMode == ThemeMode.dark
                    ? 'ダーク'
                    : 'システム'),
            trailing: DropdownButton<ThemeMode>(
              value: themeNotifier.themeMode,
              onChanged: (mode) {
                if (mode != null) {
                  themeNotifier.setTheme(mode);
                }
              },
              items: const [
                DropdownMenuItem(value: ThemeMode.system, child: Text('システム')),
                DropdownMenuItem(value: ThemeMode.light, child: Text('ライト')),
                DropdownMenuItem(value: ThemeMode.dark, child: Text('ダーク')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}