import 'package:flutter/material.dart';
import '../../widgets/balance_display.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  static const int _balance = 5000; // 円
  static const int _points = 120; // pt

  final List<Map<String, String>> _recentTransactions = const [
    {'title': 'プログラミング相談（Java）', 'date': '2025/04/09', 'amount': '¥2,000'},
    {'title': 'PC設定サポート', 'date': '2025/04/08', 'amount': '¥3,000'},
    {'title': 'Flutterエラー解決', 'date': '2025/04/07', 'amount': '¥1,500'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('支払い')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBalanceCard(),
            const SizedBox(height: 20),
            _buildPaymentButtons(),
            const SizedBox(height: 20),
            _buildRecentTransactionsTitle(),
            const SizedBox(height: 8),
            _buildRecentTransactionsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BalanceDisplay(balance: _balance, points: _points),
            SizedBox(height: 12),
            Text(
              '※ポイントは支払い金額の5%が自動還元され、次回以降の支払いに使用可能です。',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentButtons() {
    return Column(
      children: [
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
      ],
    );
  }

  Widget _buildRecentTransactionsTitle() {
    return const Text(
      '最近のご利用',
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildRecentTransactionsList() {
    return Expanded(
      child: ListView.builder(
        itemCount: _recentTransactions.length,
        itemBuilder: (context, index) {
          final transaction = _recentTransactions[index];
          return ListTile(
            leading: const Icon(Icons.receipt_long),
            title: Text(transaction['title']!),
            subtitle: Text(transaction['date']!),
            trailing: Text(transaction['amount']!),
          );
        },
      ),
    );
  }
}