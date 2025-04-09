import 'package:flutter/material.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('お知らせ・機能設定'),
      ),
      body: const Center(
        child: Text('お知らせ・機能設定画面（未実装）'),
      ),
    );
  }
}