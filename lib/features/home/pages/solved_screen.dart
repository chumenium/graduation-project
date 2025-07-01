import 'package:flutter/material.dart';

class SolvedScreen extends StatelessWidget {
  const SolvedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('解決済み')),
      body: const Center(child: Text('解決済み画面')),
    );
  }
} 