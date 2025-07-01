import 'package:flutter/material.dart';

class ConsultationDetailScreen extends StatefulWidget {
  final Map<String, String> post;
  const ConsultationDetailScreen({Key? key, required this.post}) : super(key: key);

  @override
  State<ConsultationDetailScreen> createState() => _ConsultationDetailScreenState();
}

class _Comment {
  final String userId;
  final String userName;
  final String userIconUrl;
  final String text;
  final bool isOwner;
  _Comment({required this.userId, required this.userName, required this.userIconUrl, required this.text, required this.isOwner});
}

class _ConsultationDetailScreenState extends State<ConsultationDetailScreen> {
  int likes = 0;
  bool liked = false;
  final List<_Comment> comments = [
    
    _Comment(userId: '1', userName: '出品者', userIconUrl: '', text: 'もちろんです。', isOwner: true),
    _Comment(userId: '2', userName: 'ユーザーA', userIconUrl: '', text: '詳細を教えてください', isOwner: false),
  ];
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  // 仮のログインユーザー情報（本来はFirebase Authから取得）
  final String currentUserId = '2';
  final String currentUserName = 'ユーザーA';
  final String currentUserIconUrl = '';
  final String ownerUserId = '1'; // 出品者ID（仮）

  @override
  void dispose() {
    _commentController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    return Scaffold(
      appBar: AppBar(
        title: const Text('相談詳細'),
        backgroundColor: Colors.white,
        elevation: 1,
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(post['title'] ?? '', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Chip(label: Text(post['category'] ?? '')),
                const SizedBox(width: 8),
                Text(post['user'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
                Text(post['date'] ?? '', style: const TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 16),
            Text(post['content'] ?? '', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            Row(
              children: [
                IconButton(
                  icon: Icon(liked ? Icons.favorite : Icons.favorite_border, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      liked = !liked;
                      likes += liked ? 1 : -1;
                    });
                  },
                ),
                Text('$likes いいね'),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    // 依頼を受ける処理
                  },
                  child: const Text('依頼を受ける'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: '希望金額を入力（円）',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    // 値段交渉処理
                  },
                  child: const Text('交渉'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text('コメント', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Container(
                padding: const EdgeInsets.all(8),
                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.4),
                child: ListView.builder(
                  shrinkWrap: true,
                  reverse: false,
                  itemCount: comments.length,
                  itemBuilder: (context, idx) {
                    final c = comments[idx];
                    return Align(
                      alignment: c.isOwner ? Alignment.centerLeft : Alignment.centerRight,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.all(10),
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                        decoration: BoxDecoration(
                          color: c.isOwner ? Colors.grey[200] : Colors.blue[100],
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(16),
                            topRight: const Radius.circular(16),
                            bottomLeft: c.isOwner ? const Radius.circular(0) : const Radius.circular(16),
                            bottomRight: c.isOwner ? const Radius.circular(16) : const Radius.circular(0),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (c.isOwner) ...[
                              _UserIconAndName(iconUrl: c.userIconUrl, userName: c.userName),
                              const SizedBox(width: 8),
                            ],
                            Expanded(child: Text(c.text)),
                            if (!c.isOwner) ...[
                              const SizedBox(width: 8),
                              _UserIconAndName(iconUrl: c.userIconUrl, userName: c.userName),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: 'コメントを入力',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (_commentController.text.isNotEmpty) {
                      setState(() {
                        comments.insert(0, _Comment(
                          userId: currentUserId,
                          userName: currentUserName,
                          userIconUrl: currentUserIconUrl,
                          text: _commentController.text,
                          isOwner: currentUserId == ownerUserId,
                        ));
                        _commentController.clear();
                      });
                    }
                  },
                  child: const Text('送信'),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/solved_history');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/post');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/payment_request');
              break;
            case 4:
              Navigator.pushReplacementNamed(context, '/profile_settings');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'ホーム'),
          BottomNavigationBarItem(icon: Icon(Icons.check), label: '解決済み'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: '投稿'),
          BottomNavigationBarItem(icon: Icon(Icons.payment), label: '決済'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'マイページ'),
        ],
      ),
    );
  }
}

class _UserIconAndName extends StatelessWidget {
  final String iconUrl;
  final String userName;
  const _UserIconAndName({required this.iconUrl, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: Colors.grey[300],
          backgroundImage: iconUrl.isNotEmpty ? NetworkImage(iconUrl) : null,
          child: iconUrl.isEmpty ? const Icon(Icons.person, size: 16, color: Colors.grey) : null,
        ),
        const SizedBox(width: 4),
        Text(userName, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }
} 