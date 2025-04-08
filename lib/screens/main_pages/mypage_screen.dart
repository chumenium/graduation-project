import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MypageScreen extends StatelessWidget {
  const MypageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('マイページ')),
      body: ListView(
        children: [
          // ユーザー情報
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: user?.photoURL != null
                      ? NetworkImage(user!.photoURL!)
                      : null,
                  child: user?.photoURL == null
                      ? const Icon(Icons.person, size: 30)
                      : null,
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user?.displayName ?? 'ユーザー名', style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 4),
                    const Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        Text('4.5 / 本人確認済み', style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(),

          // 残高・ポイント
          ListTile(
            leading: const Icon(Icons.account_balance_wallet),
            title: const Text('残高: ¥5,000 / ポイント: 120pt'),
            onTap: () {},
          ),

          const Divider(),

          // 履歴・クーポン・振込
          _sectionHeader('履歴・クーポン・申請'),
          _navItem(context, '閲覧履歴', '/view_history'),
          _navItem(context, '解決履歴', '/solved_history'),
          _navItem(context, '相談履歴', '/consulted_history'),
          _navItem(context, 'クーポン表示', '/coupon'),
          _navItem(context, '振込申請', '/payment_request'),

          const Divider(),

          // 設定関連
          _sectionHeader('設定'),
          _navItem(context, 'プロフィール設定', '/profile_settings'),
          _navItem(context, 'お知らせ・機能設定', '/notification_settings'),
          _navItem(context, '環境設定', '/preference_settings'),

          const Divider(),

          // 規約関連
          _navItem(context, '利用規約', '/terms'),
          _navItem(context, 'プライバシーポリシー', '/privacy_policy'),

          const Divider(),

          // ログアウト
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('ログアウト'),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }

  Widget _navItem(BuildContext context, String title, String route) {
    return ListTile(
      leading: const Icon(Icons.arrow_forward_ios, size: 16),
      title: Text(title),
      onTap: () => Navigator.pushNamed(context, route),
    );
  }
}
