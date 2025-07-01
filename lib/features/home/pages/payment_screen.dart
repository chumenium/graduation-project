import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardColor = theme.cardColor;
    final textColor = theme.textTheme.bodyLarge?.color;

    // 仮データ
    const int balance = 5000; // 円
    const int points = 120; // pt
    final List<Map<String, String>> recentTransactions = [
      {'title': 'プログラミング相談（Java）', 'date': '2025/04/09', 'amount': '¥2,000'},
      {'title': 'PC設定サポート', 'date': '2025/04/08', 'amount': '¥3,000'},
      {'title': 'Flutterエラー解決', 'date': '2025/04/07', 'amount': '¥1,500'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('決済')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 残高・ポイント表示
          Card(
            color: cardColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      const Text('残高',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('¥$balance',
                          style: TextStyle(fontSize: 18, color: textColor)),
                    ],
                  ),
                  Column(
                    children: [
                      const Text('ポイント',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('$points pt',
                          style: TextStyle(fontSize: 18, color: textColor)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // 入金ボタン
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.account_balance),
              label: const Text('PayPayで入金する'),
              onPressed: () {
                // 今後 PayPay API 連携予定
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('入金機能は未実装です')),
                );
              },
            ),
          ),
          const SizedBox(height: 10),

          // 出金ボタン
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.upload),
              label: const Text('銀行口座に出金する'),
              onPressed: () {
                // 今後 銀行API連携予定
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('出金機能は未実装です')),
                );
              },
            ),
          ),
          const SizedBox(height: 20),

          const Text('最近の取引履歴',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),

          // 取引履歴リスト
          ...recentTransactions.map((transaction) => Card(
                color: cardColor,
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  leading: const Icon(Icons.receipt_long),
                  title: Text(transaction['title']!,
                      style: TextStyle(color: textColor)),
                  subtitle: Text(transaction['date']!),
                  trailing: Text(transaction['amount']!,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              )),
        ],
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
    );
  }
}
