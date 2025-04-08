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

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    setState(() {
      isLoading = true;
    });
    user = FirebaseAuth.instance.currentUser;
    await Future.delayed(const Duration(milliseconds: 500)); // UI表示を安定させるため
    if (mounted) {
      setState(() {
        isLoading = false;
      });
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

                // 残高・ポイント
                const ListTile(
                  leading: Icon(Icons.account_balance_wallet),
                  title: Text('残高: ¥5,000 / ポイント: 120pt'),
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

                _sectionHeader('設定'),
                _navItem(context, 'プロフィール設定', '/profile_settings'),
                _navItem(context, 'お知らせ・機能設定', '/notification_settings'),
                _navItem(context, '環境設定', '/preference_settings'),

                const Divider(),

                _navItem(context, '利用規約', '/terms'),
                _navItem(context, 'プライバシーポリシー', '/privacy_policy'),

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

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
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