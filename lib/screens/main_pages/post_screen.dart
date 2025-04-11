import 'package:flutter/material.dart';
<<<<<<< HEAD
import '../post/new_consultation_screen.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("新規相談"),
      ),
      body: NewConsultationScreen(), // ← const を外す
=======
import '../../widgets/consultation_input_form.dart';
import '../../widgets/custom_button.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedCategory = 'プログラミング';

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

  void _resetForm() {
    _formKey.currentState?.reset();
    _titleController.clear();
    _descriptionController.clear();
    setState(() {
      _selectedCategory = 'プログラミング';
    });
  }

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

  Widget _buildSubmitButton() {
    return CustomButton(
      label: '相談を投稿する',
      onPressed: _submitForm,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("新規相談")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: [
            _buildForm(),
            const SizedBox(height: 20),
            _buildSubmitButton(),
          ],
        ),
      ),
>>>>>>> c5956d3c6543dd91f933e035c2b44e7e2c5969dc
    );
  }
}
