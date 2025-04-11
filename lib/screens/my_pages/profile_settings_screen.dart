import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/section_title.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final List<String> _languages = [
    'Dart',
    'Python',
    'JavaScript',
    'C++',
    'Java'
  ];
  final List<String> _frameworks = [
    'Flutter',
    'React',
    'Vue',
    'Laravel',
    'Django'
  ];
  final List<String> _selectedTechs = [];

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_formKey.currentState?.validate() ?? false) {
      // 仮の保存処理
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('プロフィールを保存しました')),
      );
    }
  }

  Widget _buildChips(List<String> options) {
    return Wrap(
      spacing: 8,
      children: options.map((tech) {
        final isSelected = _selectedTechs.contains(tech);
        return FilterChip(
          label: Text(tech),
          selected: isSelected,
          onSelected: (bool selected) {
            setState(() {
              if (selected) {
                if (_selectedTechs.length < 10) _selectedTechs.add(tech);
              } else {
                _selectedTechs.remove(tech);
              }
            });
          },
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('プロフィール設定')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionTitle(text: 'ユーザー名'),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(hintText: '表示名を入力'),
                  validator: (value) =>
                      value == null || value.isEmpty ? '名前を入力してください' : null,
                ),
                const SectionTitle(text: '自己紹介'),
                TextFormField(
                  controller: _bioController,
                  maxLines: 3,
                  decoration: const InputDecoration(hintText: '自己紹介を入力'),
                ),
                const SectionTitle(text: '使用言語'),
                _buildChips(_languages),
                const SizedBox(height: 12),
                const SectionTitle(text: '使用フレームワーク'),
                _buildChips(_frameworks),
                const SizedBox(height: 24),
                CustomButton(label: '保存する', onPressed: _saveProfile),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
