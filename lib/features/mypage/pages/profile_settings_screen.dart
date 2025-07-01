import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({Key? key}) : super(key: key);

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  final TextEditingController _nameController =
      TextEditingController(text: 'ユーザー名');
  final TextEditingController _bioController = TextEditingController(text: '');
  File? _imageFile;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _saveProfile() {
    // 保存処理（仮実装: SnackBar表示）
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('プロフィールを保存しました（モック）')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color;
    return Scaffold(
      appBar: AppBar(title: const Text('プロフィール設定')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 48,
                backgroundColor: theme.brightness == Brightness.dark
                    ? Colors.grey[800]
                    : Colors.grey[200],
                backgroundImage:
                    _imageFile != null ? FileImage(_imageFile!) : null,
                child: _imageFile == null
                    ? Icon(Icons.person, size: 48, color: theme.iconTheme.color)
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'ユーザー名',
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: textColor),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _bioController,
              decoration: const InputDecoration(
                labelText: '自己紹介文',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              style: TextStyle(color: textColor),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveProfile,
                child: const Text('保存'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
