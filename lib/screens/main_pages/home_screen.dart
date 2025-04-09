import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 仮データ（後でモデルとFirestore接続へ置き換え）
    final consultations = [
      {'category': 'Python', 'title': 'for文の使い方がわからない', 'user': '田中', 'date': '2時間前'},
      {'category': 'PC相談', 'title': 'SSD換装後にOSが起動しない', 'user': '佐藤', 'date': '1日前'},
      {'category': 'Flutter', 'title': 'ListViewがスクロールしない', 'user': '中村', 'date': '3日前'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('ホーム'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔍 検索ボックス
            TextField(
              decoration: InputDecoration(
                hintText: '相談内容や言語で検索',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),

            // 🔔 通知・取引ボタン
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/notifications');
                  },
                  icon: const Icon(Icons.notifications),
                  label: const Text('通知'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/transactions');
                  },
                  icon: const Icon(Icons.check),
                  label: const Text('取引一覧'),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 📝 相談カード一覧
            const Text('新着相談', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            Expanded(
              child: ListView.builder(
                itemCount: consultations.length,
                itemBuilder: (context, index) {
                  final c = consultations[index];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(c['category']![0]),
                      ),
                      title: Text(c['title'] ?? ''),
                      subtitle: Text('${c['user']}・${c['date']}'),
                      trailing: Text(c['category'] ?? '',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 0, 0, 0),
                          )),
                      onTap: () {
                        // TODO: 詳細画面へ遷移
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}