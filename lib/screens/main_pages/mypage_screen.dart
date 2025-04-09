import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MypageScreen extends StatefulWidget {
  const MypageScreen({super.key});

  @override
  State<MypageScreen> createState() => _MypageScreenState();
}

class _MypageScreenState extends State<MypageScreen> {
  User? user;
  bool isLoading = true;

  final List<_MypageItem> items = [
    _MypageItem(icon: Icons.history, title: '閲覧履歴', route: '/view_history'),
    _MypageItem(icon: Icons.check_circle_outline, title: '解決履歴', route: '/solved_history'),
    _MypageItem(icon: Icons.chat, title: '相談履歴', route: '/consulted_history'),
    _MypageItem(icon: Icons.card_giftcard, title: 'クーポン表示', route: '/coupon'),
    _MypageItem(icon: Icons.account_balance, title: '振込申請', route: '/payment_request'),
    _MypageItem(icon: Icons.edit, title: 'プロフィール設定', route: '/profile_settings'),
    _MypageItem(icon: Icons.notifications, title: 'お知らせ・機能設定', route: '/notification_settings'),
    _MypageItem(icon: Icons.settings, title: '環境設定', route: '/preference_settings'),
    _MypageItem(icon: Icons.article, title: '利用規約', route: '/terms'),
    _MypageItem(icon: Icons.privacy_tip, title: 'プライバシーポリシー', route: '/privacy_policy'),
  ];

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    setState(() => isLoading = true);
    user = FirebaseAuth.instance.currentUser;
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('マイページ')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                // ユーザー情報
                Padding(
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
                          Text(user?.displayName ?? 'ユーザー名',
                              style: const TextStyle(fontSize: 18)),
                          const SizedBox(height: 4),
                          const Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: 16),
                              SizedBox(width: 4),
                              Text('4.5 / 本人確認済み',
                                  style: TextStyle(fontSize: 14)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const Divider(),

                const ListTile(
                  leading: Icon(Icons.account_balance_wallet),
                  title: Text('残高: ¥5,000 / ポイント: 120pt'),
                ),

                const Divider(),

                ...items.map((item) => ListTile(
                      leading: Icon(item.icon),
                      title: Text(item.title),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => Navigator.pushNamed(context, item.route),
                    )),

                const Divider(),

                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('ログアウト'),
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    if (!mounted) return;
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                ),
              ],
            ),
    );
  }
}

class _MypageItem {
  final IconData icon;
  final String title;
  final String route;

  const _MypageItem({
    required this.icon,
    required this.title,
    required this.route,
  });
}