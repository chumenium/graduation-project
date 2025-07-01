import 'package:flutter/material.dart';

class PaymentRequestScreen extends StatelessWidget {
  const PaymentRequestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('支払いリクエスト')),
      body: const Center(child: Text('支払いリクエスト画面')),
    );
  }
} 