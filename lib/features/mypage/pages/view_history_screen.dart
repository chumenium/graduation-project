import 'package:flutter/material.dart';

class ViewHistoryScreen extends StatelessWidget {
  const ViewHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('閲覧履歴')),
      body: const Center(child: Text('閲覧履歴画面')),
    );
  }
} 