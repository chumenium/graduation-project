import 'package:flutter/material.dart';

class CouponScreen extends StatelessWidget {
  const CouponScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('クーポン')),
      body: const Center(child: Text('クーポン画面')),
    );
  }
} 