import 'package:flutter/material.dart';

class NewConsultationScreen extends StatefulWidget {
  const NewConsultationScreen({super.key});

  @override
  State<NewConsultationScreen> createState() => _NewConsultationScreenState();
}

class _NewConsultationScreenState extends State<NewConsultationScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _category = 'プログラミング';
  String _description = '';

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    // 🔹 本来はFirebaseに送るが、いったんモックで表示
    print('[投稿内容]');
    print('タイトル: $_title');
    print('カテゴリ: $_category');
    print('内容: $_description');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('投稿完了（ダミー）')),
    );

    _formKey.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'タイトル'),
              onSaved: (value) => _title = value ?? '',
              validator: (value) =>
                  value == null || value.isEmpty ? 'タイトルを入力してください' : null,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _category,
              items: const [
                DropdownMenuItem(value: 'プログラミング', child: Text('プログラミング')),
                DropdownMenuItem(value: 'PCトラブル', child: Text('PCトラブル')),
              ],
              onChanged: (value) =>
                  setState(() => _category = value ?? 'プログラミング'),
              decoration: const InputDecoration(labelText: 'カテゴリ'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(labelText: '相談内容'),
              maxLines: 5,
              onSaved: (value) => _description = value ?? '',
              validator: (value) =>
                  value == null || value.isEmpty ? '相談内容を入力してください' : null,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('相談を投稿する'),
            ),
          ],
        ),
      ),
    );
  }
}
