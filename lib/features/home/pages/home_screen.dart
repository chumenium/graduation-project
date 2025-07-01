import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = theme.cardColor;
    final textColor = theme.textTheme.bodyLarge?.color;
    // 仮の投稿リスト（他ユーザー含む）
    final List<Map<String, String>> posts = [
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

    return Scaffold(
      appBar: AppBar(title: const Text('ホーム')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return Card(
            color: cardColor,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UserProfileScreen()),
                  );
                },
                child: CircleAvatar(
                  backgroundColor: theme.brightness == Brightness.dark
                      ? Colors.grey[800]
                      : Colors.grey[200],
                  child: const Icon(Icons.person, color: Colors.grey),
                ),
              ),
              title: Text(post['title']!,
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: textColor)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: post['category'] == 'プログラミング'
                              ? Colors.blue[100]
                              : Colors.green[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(post['category']!,
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 8),
                      Text(post['user']!, style: const TextStyle(fontSize: 12)),
                      const Spacer(),
                      Text(post['date']!,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(post['content']!, style: TextStyle(color: textColor)),
                ],
              ),
              isThreeLine: true,
              onTap: () {
                // 投稿詳細画面などに遷移する場合はここで実装
              },
            ),
          );
        },
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
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
