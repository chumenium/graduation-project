import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../widgets/profile_avatar.dart';
import '../../widgets/section_title.dart';

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
    return Scaffold(
      appBar: AppBar(title: const Text('マイページ')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                _buildUserInfoSection(),
                const Divider(),
                _buildBalanceSection(),
                const Divider(),
                _buildMenuSection('履歴', historyItems),
                const Divider(),
                _buildMenuSection('支払い関係', paymentItems),
                const Divider(),
                _buildMenuSection('設定', settingItems),
                const Divider(),
                _buildMenuSection('規約', policyItems),
                const Divider(),
                _buildLogoutTile(),
              ],
            ),
    );
  }

  Widget _buildUserInfoSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          ProfileAvatar(imageUrl: user?.photoURL, size: 60),
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
                  Text('4.5 / 本人確認済み', style: TextStyle(fontSize: 14)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceSection() {
    return const ListTile(
      leading: Icon(Icons.account_balance_wallet),
      title: Text('残高: ¥5,000 / ポイント: 120pt'),
    );
  }

  Widget _buildMenuSection(String title, List<_MypageItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(text: title),
        ...items.map(_buildListTile),
      ],
    );
  }

  Widget _buildLogoutTile() {
    return ListTile(
      leading: const Icon(Icons.logout),
      title: const Text('ログアウト'),
      onTap: () async {
        await FirebaseAuth.instance.signOut();
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/login');
      },
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

  const _MypageItem({
    required this.icon,
    required this.title,
    required this.route,
  });
}
