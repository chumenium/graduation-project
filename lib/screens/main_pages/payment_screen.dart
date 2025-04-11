import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const int balance = 5000; // 円
    const int points = 120; // pt

    final List<Map<String, String>> recentTransactions = [
      {'title': 'プログラミング相談（Java）', 'date': '2025/04/09', 'amount': '¥2,000'},
      {'title': 'PC設定サポート', 'date': '2025/04/08', 'amount': '¥3,000'},
      {'title': 'Flutterエラー解決', 'date': '2025/04/07', 'amount': '¥1,500'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('支払い')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 残高・ポイント表示
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.account_balance_wallet),
                        SizedBox(width: 8),
                        Text('残高: ¥$balance', style: TextStyle(fontSize: 18)),
                        Icon(Icons.account_balance_wallet),
                        SizedBox(width: 8),
                        Text('残高: ¥$balance', style: TextStyle(fontSize: 18)),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.orange),
                        SizedBox(width: 8),
                        Text('ポイント: ${points}pt',
                            style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      '※ポイントは支払い金額の5%が自動還元され、次回以降の支払いに使用可能です。',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // PayPal入金ボタン
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.account_balance),
                label: const Text('PayPalで入金する'),
                onPressed: () {
                  // 今後 PayPal API 連携予定
                },
              ),
            ),

            const SizedBox(height: 10),

            // PayPal出金ボタン
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.upload),
                label: const Text('PayPalから出金する'),
                onPressed: () {
                  // 今後 PayPal API 連携予定（出金）
                },
              ),
            ),

            const SizedBox(height: 20),

            const Text('最近のご利用',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

            const SizedBox(height: 8),

            Expanded(
              child: ListView.builder(
                itemCount: recentTransactions.length,
                itemBuilder: (context, index) {
                  final transaction = recentTransactions[index];
                  return ListTile(
                    leading: const Icon(Icons.receipt_long),
                    title: Text(transaction['title']!),
                    subtitle: Text(transaction['date']!),
                    trailing: Text(transaction['amount']!),
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
