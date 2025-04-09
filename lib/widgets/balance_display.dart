import 'package:flutter/material.dart';

class BalanceDisplay extends StatelessWidget {
  final int balance;
  final int points;

  const BalanceDisplay(
      {super.key, required this.balance, required this.points});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            const Text("残高", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("¥$balance", style: const TextStyle(fontSize: 18)),
          ],
        ),
        Column(
          children: [
            const Text("ポイント", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("$points pt", style: const TextStyle(fontSize: 18)),
          ],
        )
      ],
    );
  }
}
