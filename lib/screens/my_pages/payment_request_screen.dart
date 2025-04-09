import 'package:flutter/material.dart';

class PaymentRequestScreen extends StatelessWidget {
  const PaymentRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('振込申請'),
      ),
      body: const Center(
        child: Text('振込申請画面（未実装）'),
      ),
    );
  }
}