import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ダミーデータ（後でFirebaseから取得）
    final transactions = [
      {'title': '相談報酬の受け取り', 'amount': '+500円', 'date': '2025/04/08'},
      {'title': '出金処理（PayPal）', 'amount': '-1,000円', 'date': '2025/04/06'},
      {'title': 'ポイント購入', 'amount': '+100pt', 'date': '2025/04/04'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('支払い'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 残高表示
            const Text(
              '現在の残高',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('¥5,000', style: TextStyle(fontSize: 24)),
                Text('120 pt', style: TextStyle(fontSize: 24)),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: PayPal連携処理
              },
              icon: const Icon(Icons.attach_money),
              label: const Text('PayPalに出金'),
            ),
            const SizedBox(height: 24),

            // 利用履歴
            const Text(
              '最近のご利用履歴',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                itemCount: transactions.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final tx = transactions[index];
                  return ListTile(
                    title: Text(tx['title']!),
                    subtitle: Text(tx['date']!),
                    trailing: Text(tx['amount']!),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
