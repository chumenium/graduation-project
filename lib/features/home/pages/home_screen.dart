import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/services/consultation_service.dart';
import '../../../data/models/consultation_model.dart';
import '../../../features/mypage/provider/user_profile_provider.dart';
import 'consultation_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ConsultationService _consultationService = ConsultationService();
  String _searchText = '';
  String _selectedCategory = 'すべて';

  final List<String> _categories = [
    'すべて',
    'プログラミング',
    'PC相談',
    'ネットワーク',
    'デザイン',
    'マーケティング',
    'その他',
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
      body: Column(
        children: [
          // カテゴリフィルター
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                  ),
                );
              },
            ),
          ),
          
          // 相談一覧
          Expanded(
            child: StreamBuilder<List<Consultation>>(
              stream: _selectedCategory == 'すべて'
                  ? _consultationService.getOpenConsultations()
                  : _consultationService.getConsultationsByCategory(_selectedCategory),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        Text('エラーが発生しました: ${snapshot.error}'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => setState(() {}),
                          child: const Text('再試行'),
                        ),
                      ],
                    ),
                  );
                }

                final consultations = snapshot.data ?? [];
                
                // 検索フィルターを適用
                final normalizedSearch = normalize(_searchText);
                final filteredConsultations = _searchText.isEmpty
                    ? consultations
                    : consultations.where((consultation) {
                        final title = normalize(consultation.title);
                        final category = normalize(consultation.category);
                        final description = normalize(consultation.description);
                        final tags = consultation.tags.map((tag) => normalize(tag)).join('');
                        return title.contains(normalizedSearch) ||
                            category.contains(normalizedSearch) ||
                            description.contains(normalizedSearch) ||
                            tags.contains(normalizedSearch);
                      }).toList();

                if (filteredConsultations.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off, size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          _searchText.isEmpty ? '相談がありません' : '検索結果がありません',
                          style: const TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: filteredConsultations.length,
                  itemBuilder: (context, index) {
                    final consultation = filteredConsultations[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConsultationDetailScreen(consultation: consultation),
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
                                    backgroundImage: consultation.authorPhotoURL != null
                                        ? NetworkImage(consultation.authorPhotoURL!)
                                        : null,
                                    child: consultation.authorPhotoURL == null
                                        ? Icon(Icons.person, color: theme.iconTheme.color)
                                        : null,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          consultation.authorName ?? '匿名ユーザー',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold, color: textColor),
                                        ),
                                        Text(
                                          _formatDate(consultation.createdAt),
                                          style: TextStyle(
                                              color: theme.hintColor, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (consultation.budget > 0)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.green.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        '¥${consultation.budget.toString()}',
                                        style: const TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: _getCategoryColor(consultation.category, theme),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(consultation.category,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: theme.colorScheme.primary)),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(consultation.title,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: textColor)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                consultation.description,
                                style: TextStyle(color: textColor),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (consultation.tags.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 4,
                                  children: consultation.tags.map((tag) => Chip(
                                    label: Text(tag, style: const TextStyle(fontSize: 10)),
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    visualDensity: VisualDensity.compact,
                                  )).toList(),
                                ),
                              ],
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.visibility, size: 16, color: theme.hintColor),
                                  const SizedBox(width: 4),
                                  Text(
                                    consultation.viewCount.toString(),
                                    style: TextStyle(color: theme.hintColor, fontSize: 12),
                                  ),
                                  const SizedBox(width: 16),
                                  Icon(Icons.favorite_border, size: 16, color: theme.hintColor),
                                  const SizedBox(width: 4),
                                  Text(
                                    consultation.interestedUsers.length.toString(),
                                    style: TextStyle(color: theme.hintColor, fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}日前';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}時間前';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}分前';
    } else {
      return '今';
    }
  }

  Color _getCategoryColor(String category, ThemeData theme) {
    switch (category) {
      case 'プログラミング':
        return theme.brightness == Brightness.dark ? Colors.red[900]! : Colors.red[50]!;
      case 'PC相談':
        return theme.brightness == Brightness.dark ? Colors.blue[900]! : Colors.blue[50]!;
      case 'ネットワーク':
        return theme.brightness == Brightness.dark ? Colors.green[900]! : Colors.green[50]!;
      case 'デザイン':
        return theme.brightness == Brightness.dark ? Colors.purple[900]! : Colors.purple[50]!;
      case 'マーケティング':
        return theme.brightness == Brightness.dark ? Colors.orange[900]! : Colors.orange[50]!;
      default:
        return theme.brightness == Brightness.dark ? Colors.grey[800]! : Colors.grey[200]!;
    }
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
