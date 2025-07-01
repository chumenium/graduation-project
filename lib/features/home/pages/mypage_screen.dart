import 'package:flutter/material.dart';
import 'user_profile_screen.dart';

class MypageScreen extends StatelessWidget {
  const MypageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = theme.scaffoldBackgroundColor;
    final cardColor = theme.cardColor;
    final textColor = theme.textTheme.bodyLarge?.color;
    final subTextColor = theme.textTheme.bodySmall?.color?.withOpacity(0.7);

    return Scaffold(
      appBar: AppBar(title: const Text('マイページ')),
      body: ListView(
        children: [
          // プロフィールエリア
          Container(
            color: cardColor,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UserProfileScreen()),
                    );
                  },
                  child: CircleAvatar(
                    radius: 32,
                    backgroundColor:
                        isDark ? Colors.grey[800] : Colors.grey[200],
                    child:
                        const Icon(Icons.person, size: 40, color: Colors.grey),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const UserProfileScreen()),
                          );
                        },
                        child: Text('ユーザー名',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                                decoration: TextDecoration.underline)),
                      ),
                      const SizedBox(height: 4),
                      Text('自己紹介文が入ります',
                          style: TextStyle(fontSize: 14, color: subTextColor)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text('4.8',
                              style: TextStyle(fontSize: 14, color: textColor)),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit, color: theme.iconTheme.color),
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
            leading: Icon(Icons.logout, color: theme.iconTheme.color),
            title: Text('ログアウト', style: TextStyle(color: textColor)),
            onTap: () {
              // ログアウト処理
            },
          ),
        ],
      ),
      backgroundColor: bgColor,
    );
  }

  Widget _buildMenuSection(
      BuildContext context, String title, List<_MenuItem> items) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(title,
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
        ),
        ...items.map((item) => ListTile(
              leading: Icon(item.icon, color: theme.iconTheme.color),
              title: Text(item.title, style: TextStyle(color: textColor)),
              trailing: Icon(Icons.arrow_forward_ios,
                  size: 16, color: theme.iconTheme.color),
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

// 出品者ページ風の画面
class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = theme.cardColor;
    final textColor = theme.textTheme.bodyLarge?.color;
    // 仮の投稿リスト
    final List<Map<String, String>> posts = [
      {
        'title': 'Pythonのfor文について',
        'category': 'プログラミング',
        'content': 'for文の使い方が分かりません。'
      },
      {
        'title': 'SSD換装後のトラブル',
        'category': 'PC相談',
        'content': 'SSDを換装したらOSが起動しません。'
      },
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('ユーザーページ')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // プロフィール表示
          Card(
            color: cardColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: theme.brightness == Brightness.dark
                        ? Colors.grey[800]
                        : Colors.grey[200],
                    child:
                        const Icon(Icons.person, size: 40, color: Colors.grey),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ユーザー名',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: textColor)),
                        const SizedBox(height: 4),
                        Text('自己紹介文が入ります',
                            style: TextStyle(fontSize: 14, color: textColor)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.star,
                                color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text('4.8',
                                style:
                                    TextStyle(fontSize: 14, color: textColor)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('投稿一覧',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...posts.map((post) => Card(
                color: cardColor,
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  title:
                      Text(post['title']!, style: TextStyle(color: textColor)),
                  subtitle: Text('${post['category']}\n${post['content']}',
                      style: TextStyle(color: textColor)),
                ),
              )),
        ],
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
    );
  }
}
