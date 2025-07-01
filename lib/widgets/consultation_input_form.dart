import 'package:flutter/material.dart';

class ConsultationInputForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final String category;
  final void Function(String?) onCategoryChanged;

  const ConsultationInputForm({
    super.key,
    required this.formKey,
    required this.titleController,
    required this.descriptionController,
    required this.category,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            controller: titleController,
            decoration: const InputDecoration(labelText: 'タイトル'),
            validator: (value) =>
                value == null || value.isEmpty ? 'タイトルを入力してください' : null,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: category,
            items: const [
              DropdownMenuItem(value: 'プログラミング', child: Text('プログラミング')),
              DropdownMenuItem(value: 'PCトラブル', child: Text('PCトラブル')),
            ],
            onChanged: onCategoryChanged,
            decoration: const InputDecoration(labelText: 'カテゴリ'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: descriptionController,
            decoration: const InputDecoration(labelText: '相談内容'),
            maxLines: 5,
            validator: (value) =>
                value == null || value.isEmpty ? '相談内容を入力してください' : null,
          ),
        ],
      ),
    );
  }
}
