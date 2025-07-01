import 'package:flutter/material.dart';

class SolvedHistoryScreen extends StatelessWidget {
  const SolvedHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('解決履歴')),
      body: const Center(child: Text('解決履歴画面')),
    );
  }
} 