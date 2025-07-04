import 'package:flutter/material.dart';
import 'consultation_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  final List<Map<String, String>> _posts = [
    {
      'user': '山田太郎',
      'avatar': '',
      'title': 'Pythonのfor文について',
      'category': 'プログラミング',
      'content': 'for文の使い方が分かりません。',
      'date': '2025/04/10',
    },
    {
      'user': '佐藤花子',
      'avatar': '',
      'title': 'SSD換装後のトラブル',
      'category': 'PC相談',
      'content': 'SSDを換装したらOSが起動しません。',
      'date': '2025/04/09',
    },
    {
      'user': '田中一郎',
      'avatar': '',
      'title': 'Flutterで画像が表示されない',
      'category': 'プログラミング',
      'content': 'Image.assetで画像が出ません。',
      'date': '2025/04/08',
    },
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String normalize(String s) {
      return s
          .toLowerCase()
          .replaceAllMapped(RegExp(r'[Ａ-Ｚａ-ｚ０-９]'),
              (m) => String.fromCharCode(m.group(0)!.codeUnitAt(0) - 0xFEE0))
          .replaceAll(RegExp(r'\s+'), '');
    }

    final normalizedSearch = normalize(_searchText);
    final filteredPosts = _searchText.isEmpty
        ? _posts
        : _posts.where((p) {
            final title = normalize(p['title']!);
            final category = normalize(p['category']!);
            final content = normalize(p['content']!);
            return title.contains(normalizedSearch) ||
                category.contains(normalizedSearch) ||
                content.contains(normalizedSearch);
          }).toList();

    final theme = Theme.of(context);
    final cardColor = theme.cardColor;
    final textColor = theme.textTheme.bodyLarge?.color;
    final bgColor = theme.scaffoldBackgroundColor;
    final appBarColor =
        theme.appBarTheme.backgroundColor ?? theme.colorScheme.surface;
    final inputBgColor = theme.inputDecorationTheme.fillColor ??
        (theme.brightness == Brightness.dark
            ? Colors.grey[800]
            : Colors.grey[200]);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 1,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: inputBgColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const SizedBox(width: 8),
              Icon(Icons.search, color: theme.iconTheme.color),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: '相談タイトルで検索',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: theme.hintColor),
                  ),
                  style: TextStyle(fontSize: 16, color: textColor),
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.red),
            onPressed: () {
              Navigator.pushNamed(context, '/notifications');
            },
            tooltip: '通知',
          ),
          IconButton(
            icon: const Icon(Icons.forum, color: Colors.red),
            onPressed: () {
              Navigator.pushNamed(context, '/transactions');
            },
            tooltip: 'やり取り中',
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.red),
            onPressed: () {
              Navigator.pushNamed(context, '/profile_settings');
            },
            tooltip: 'プロフィール',
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: filteredPosts.length,
        itemBuilder: (context, index) {
          final post = filteredPosts[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ConsultationDetailScreen(post: post),
                ),
              );
            },
            child: Card(
              color: cardColor,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: theme.brightness == Brightness.dark
                              ? Colors.grey[800]
                              : Colors.grey[200],
                          child:
                              Icon(Icons.person, color: theme.iconTheme.color),
                        ),
                        const SizedBox(width: 8),
                        Text(post['user']!,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: textColor)),
                        const Spacer(),
                        Text(post['date']!,
                            style: TextStyle(
                                color: theme.hintColor, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: post['category'] == 'プログラミング'
                                ? (theme.brightness == Brightness.dark
                                    ? Colors.red[900]
                                    : Colors.red[50])
                                : (theme.brightness == Brightness.dark
                                    ? Colors.blue[900]
                                    : Colors.blue[50]),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(post['category']!,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: theme.colorScheme.primary)),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(post['title']!,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: textColor)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(post['content']!, style: TextStyle(color: textColor)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ユーザーページ（出品者ページ風）
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
