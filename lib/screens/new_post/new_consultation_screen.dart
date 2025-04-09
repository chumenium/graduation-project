import 'package:flutter/material.dart';
import '../../widgets/consultation_input_form.dart';
import '../../widgets/custom_button.dart';

class NewConsultationScreen extends StatefulWidget {
  const NewConsultationScreen({Key? key}) : super(key: key);

  @override
  State<NewConsultationScreen> createState() => _NewConsultationScreenState();
}

class _NewConsultationScreenState extends State<NewConsultationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedCategory = 'プログラミング';

  /// 投稿処理（モック版）
  void _submitForm() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final title = _titleController.text;
    final description = _descriptionController.text;

    // 🔸 本来は Firebase に送信予定
    print('[新規相談]');
    print('タイトル: $title');
    print('カテゴリ: $_selectedCategory');
    print('内容: $description');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('相談を投稿しました（モック）')),
    );

    _resetForm();
  }

  /// フォームリセット
  void _resetForm() {
    _formKey.currentState?.reset();
    _titleController.clear();
    _descriptionController.clear();
    setState(() {
      _selectedCategory = 'プログラミング';
    });
  }

  /// 入力フォームUI
  Widget _buildForm() {
    return ConsultationInputForm(
      formKey: _formKey,
      titleController: _titleController,
      descriptionController: _descriptionController,
      category: _selectedCategory,
      onCategoryChanged: (val) {
        setState(() {
          _selectedCategory = val ?? 'プログラミング';
        });
      },
    );
  }

  /// 投稿ボタンUI
  Widget _buildSubmitButton() {
    return CustomButton(
      label: '相談を投稿する',
      onPressed: _submitForm,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        children: [
          _buildForm(),
          const SizedBox(height: 20),
          _buildSubmitButton(),
        ],
      ),
    );
  }
}
