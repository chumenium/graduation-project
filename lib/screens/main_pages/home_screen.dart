import 'package:flutter/material.dart';
import '../../data/models/consultation_model.dart';
import '../../widgets/consultation_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Consultation> consultations = [
      Consultation(
        id: '1',
        title: 'for文の使い方がわからない',
        description: 'Pythonでループ処理を書きたいけど構文がわからないです。',
        category: 'プログラミング',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      Consultation(
        id: '2',
        title: 'SSD換装後にOSが起動しない',
        description: '新しく取り付けたSSDにWindowsを入れたのですが、うまく起動しません。',
        category: 'PC相談',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Consultation(
        id: '3',
        title: 'ListViewがスクロールしない',
        description: 'FlutterでListViewを使っていますが、要素が増えてもスクロールできません。',
        category: 'プログラミング',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
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
            _buildSearchBox(),
            const SizedBox(height: 12),
            _buildActionButtons(context),
            const SizedBox(height: 12),
            const Text(
              '新着相談',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: consultations.length,
                itemBuilder: (context, index) =>
                    ConsultationCard(consultation: consultations[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBox() => TextField(
        decoration: InputDecoration(
          hintText: '相談内容や言語で検索',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );

  Widget _buildActionButtons(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/notifications'),
            icon: const Icon(Icons.notifications),
            label: const Text('通知'),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/transactions'),
            icon: const Icon(Icons.check),
            label: const Text('取引一覧'),
          ),
        ],
      );
}