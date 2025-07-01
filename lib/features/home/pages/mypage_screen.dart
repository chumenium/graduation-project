import 'package:flutter/material.dart';

class MypageScreen extends StatelessWidget {
  const MypageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('マイページ')),
      body: ListView(
        children: [
          // プロフィールエリア
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 32,
                  backgroundImage:
                      AssetImage('assets/default_avatar.png'), // 仮画像
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('ユーザー名',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('自己紹介文が入ります',
                          style: TextStyle(fontSize: 14, color: Colors.grey)),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          SizedBox(width: 4),
                          Text('4.8', style: TextStyle(fontSize: 14)),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // プロフィール編集画面へ遷移
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // メニューリスト
          _buildMenuSection(context, '履歴', [
            _MenuItem(Icons.history, '閲覧履歴', '/view_history'),
            _MenuItem(Icons.check_circle_outline, '解決履歴', '/solved_history'),
            _MenuItem(Icons.chat, '相談履歴', '/consulted_history'),
          ]),
          _buildMenuSection(context, '支払い', [
            _MenuItem(Icons.card_giftcard, 'クーポン表示', '/coupon'),
            _MenuItem(Icons.account_balance, '振込申請', '/payment_request'),
          ]),
          _buildMenuSection(context, '設定', [
            _MenuItem(Icons.edit, 'プロフィール設定', '/profile_settings'),
            _MenuItem(
                Icons.notifications, 'お知らせ・機能設定', '/notification_settings'),
            _MenuItem(Icons.settings, '環境設定', '/preference_settings'),
          ]),
          _buildMenuSection(context, '規約', [
            _MenuItem(Icons.article, '利用規約', '/terms'),
            _MenuItem(Icons.privacy_tip, 'プライバシーポリシー', '/privacy_policy'),
          ]),

          // ログアウト
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('ログアウト'),
            onTap: () {
              // ログアウト処理
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey[100],
    );
  }

  Widget _buildMenuSection(
      BuildContext context, String title, List<_MenuItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        ...items.map((item) => ListTile(
              leading: Icon(item.icon),
              title: Text(item.title),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.pushNamed(context, item.route);
              },
            )),
        const Divider(height: 1),
      ],
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final String route;
  const _MenuItem(this.icon, this.title, this.route);
}
