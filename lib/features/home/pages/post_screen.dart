import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/services/consultation_service.dart';
import '../../../features/mypage/provider/user_profile_provider.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _budgetController = TextEditingController();
  final _tagsController = TextEditingController();
  final _consultationService = ConsultationService();
  
  String _selectedCategory = 'プログラミング';
  bool _isLoading = false;

  final List<String> _categories = [
    'プログラミング',
    'PC相談',
    'ネットワーク',
    'デザイン',
    'マーケティング',
    'その他',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _budgetController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // タグを解析
      final tags = _tagsController.text
          .split(',')
          .map((tag) => tag.trim())
          .where((tag) => tag.isNotEmpty)
          .toList();

      // 予算を解析
      int budget = 0;
      if (_budgetController.text.isNotEmpty) {
        budget = int.tryParse(_budgetController.text) ?? 0;
      }

      // 相談を作成
      final consultationId = await _consultationService.createConsultation(
        title: _titleController.text.trim(),
        description: _contentController.text.trim(),
        category: _selectedCategory,
        budget: budget,
        tags: tags,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('相談を投稿しました！ID: $consultationId'),
            backgroundColor: Colors.green,
          ),
        );

        // フォームをリセット
        _formKey.currentState!.reset();
        _titleController.clear();
        _contentController.clear();
        _budgetController.clear();
        _tagsController.clear();
        setState(() {
          _selectedCategory = _categories[0];
        });

        // ホーム画面に戻る
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('投稿に失敗しました: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = theme.cardColor;
    final textColor = theme.textTheme.bodyLarge?.color;

    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            theme.appBarTheme.backgroundColor ?? theme.colorScheme.surface,
        elevation: 1,
        title: const Text('相談を投稿'),
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
        child: Card(
          color: cardColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('タイトル',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '例）Pythonのfor文について',
                    ),
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'タイトルを入力してください'
                        : null,
                  ),
                  const SizedBox(height: 20),
                  const Text('カテゴリー',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration:
                        const InputDecoration(border: OutlineInputBorder()),
                    items: _categories
                        .map((cat) =>
                            DropdownMenuItem(value: cat, child: Text(cat)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedCategory = val);
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text('予算（円）',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _budgetController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '例）5000（任意）',
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('タグ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _tagsController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '例）Python, 初心者, エラー（カンマ区切り）',
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('相談内容',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _contentController,
                    maxLines: 6,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '相談内容を詳しく入力してください',
                    ),
                    validator: (value) =>
                        (value == null || value.isEmpty) ? '内容を入力してください' : null,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submit,
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const Text('相談を投稿する'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
    );
  }
}
