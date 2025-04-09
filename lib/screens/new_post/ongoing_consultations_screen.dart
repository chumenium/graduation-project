import 'package:flutter/material.dart';

class OngoingConsultationsScreen extends StatelessWidget {
  const OngoingConsultationsScreen({Key? key}) : super(key: key);

  final List<Map<String, String>> dummyConsultations = const [
    {
      'title': 'Flutterで画面遷移ができない',
      'description': 'Navigatorで画面遷移しようとするとエラーになります。',
      'category': 'プログラミング',
      'createdAt': '2025/04/09 10:30',
    },
    {
      'title': 'ノートPCの動作が遅い',
      'description': 'タスクマネージャーの見方を教えてください。',
      'category': 'PCトラブル',
      'createdAt': '2025/04/08 21:15',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: dummyConsultations.length,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      itemBuilder: (context, index) {
        final item = dummyConsultations[index];
        return _buildConsultationCard(item);
      },
    );
  }

  Widget _buildConsultationCard(Map<String, String> data) {
    final category = data['category'] ?? '';
    final color =
        category == 'プログラミング' ? Colors.blue.shade100 : Colors.green.shade100;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    category,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
                const Spacer(),
                Text(
                  data['createdAt'] ?? '',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              data['title'] ?? '',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              data['description'] ?? '',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
