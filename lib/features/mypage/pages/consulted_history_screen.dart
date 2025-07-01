import 'package:flutter/material.dart';

class ConsultedHistoryScreen extends StatelessWidget {
  const ConsultedHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('相談履歴')),
      body: const Center(child: Text('相談履歴画面')),
    );
  }
} 