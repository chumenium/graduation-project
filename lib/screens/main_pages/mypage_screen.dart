import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:graduation_project/providers/user_profile_provider.dart';
import 'package:graduation_project/widgets/profile_avatar.dart';

class MypageScreen extends StatefulWidget {
  const MypageScreen({super.key});

  @override
  State<MypageScreen> createState() => _MypageScreenState();
}

class _MypageScreenState extends State<MypageScreen> {
  User? user;
  bool isLoading = true;

  final List<_MypageItem> historyItems = const [
    _MypageItem(icon: Icons.history, title: '閲覧履歴', route: '/view_history'),
    _MypageItem(icon: Icons.check_circle_outline, title: '解決履歴', route: '/solved_history'),
    _MypageItem(icon: Icons.chat, title: '相談履歴', route: '/consulted_history'),
  ];

  final List<_MypageItem> paymentItems = const [
    _MypageItem(icon: Icons.card_giftcard, title: 'クーポン表示', route: '/coupon'),
    _MypageItem(icon: Icons.account_balance, title: '振込申請', route: '/payment_request'),
  ];

  final List<_MypageItem> settingItems = const [
    _MypageItem(icon: Icons.edit, title: 'プロフィール設定', route: '/profile_settings'),
    _MypageItem(icon: Icons.notifications, title: 'お知らせ・機能設定', route: '/notification_settings'),
    _MypageItem(icon: Icons.settings, title: '環境設定', route: '/preference_settings'),
  ];

  final List<_MypageItem> policyItems = const [
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
    final profile = context.watch<UserProfileProvider>().profile;

    return Scaffold(
      appBar: AppBar(title: const Text('マイページ')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      ProfileAvatar(
                        imageFile: profile?.avatarFile,
                        imageUrl: user?.photoURL,
                        radius: 30,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile?.name?.isNotEmpty == true
                                  ? profile!.name!
                                  : user?.displayName ?? 'ユーザー名',
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              profile?.bio ?? '',
                              style: const TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                            const SizedBox(height: 4),
                            if ((profile?.skills ?? []).isNotEmpty)
                              Wrap(
                                spacing: 6,
                                children: profile!.skills!
                                    .map((skill) => Chip(
                                          label: Text(skill, style: const TextStyle(fontSize: 12)),
                                        ))
                                    .toList(),
                              ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 16),
                                const SizedBox(width: 4),
                                Text('${profile?.rating ?? '4.5'} / 本人確認済み',
                                    style: const TextStyle(fontSize: 14)),
                              ],
                            ),
                          ],
                        ),
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

                _buildSectionTitle('履歴'),
                ...historyItems.map(_buildListTile),
                const Divider(),

                _buildSectionTitle('支払い関係'),
                ...paymentItems.map(_buildListTile),
                const Divider(),

                _buildSectionTitle('設定'),
                ...settingItems.map(_buildListTile),
                const Divider(),

                _buildSectionTitle('規約'),
                ...policyItems.map(_buildListTile),
                const Divider(),

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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildListTile(_MypageItem item) {
    return ListTile(
      leading: Icon(item.icon),
      title: Text(item.title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => Navigator.pushNamed(context, item.route),
    );
  }
}

class _MypageItem {
  final IconData icon;
  final String title;
  final String route;

  const _MypageItem({required this.icon, required this.title, required this.route});
}