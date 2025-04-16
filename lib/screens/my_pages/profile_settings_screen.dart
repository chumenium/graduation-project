import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../models/user_profile.dart';
import '../../providers/user_profile_provider.dart';
import '../../widgets/profile_avatar.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  File? _selectedImage;

  String? _selectedLanguage;
  String? _selectedFramework;

  final List<String> _selectedSkills = [];

  final List<String> languages = [
    'Python', 'JavaScript', 'Java', 'C#', 'C++', 'Dart',
    'Ruby', 'Go', 'Swift', 'Kotlin',
  ];

  final List<String> frameworks = [
    'Flutter', 'React', 'Vue.js', 'Angular', 'Laravel',
    'Spring', 'Django', 'Next.js', 'Node.js', '.NET',
  ];

  @override
  void initState() {
    super.initState();
    final existing = context.read<UserProfileProvider>().profile;
    if (existing != null) {
      _nameController.text = existing.name ?? '';
      _bioController.text = existing.bio ?? '';
      _selectedSkills.addAll(existing.skills ?? []);
      _selectedImage = existing.avatarFile;
    }
  }

  void _addSkill(String skill) {
    if (_selectedSkills.length >= 10 || _selectedSkills.contains(skill)) return;
    setState(() {
      _selectedSkills.add(skill);
    });
  }

  void _removeSkill(String skill) {
    setState(() {
      _selectedSkills.remove(skill);
    });
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() => _selectedImage = File(image.path));
      }
    } catch (e) {
      print('画像の選択に失敗しました: $e');
    }
  }

  void _saveProfile() {
    if (!_formKey.currentState!.validate()) return;

    final newProfile = UserProfile(
      name: _nameController.text,
      bio: _bioController.text,
      skills: List.from(_selectedSkills),
      rating: 4.5, // 仮データ
      avatarFile: _selectedImage,
    );

    context.read<UserProfileProvider>().updateProfile(newProfile);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('プロフィール設定')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Center(
                  child: ProfileAvatar(
                    imageFile: _selectedImage,
                    radius: 40,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'ユーザー名'),
                validator: (value) =>
                    value == null || value.isEmpty ? '入力してください' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _bioController,
                decoration: const InputDecoration(labelText: '自己紹介'),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: '使用言語'),
                items: languages.map((lang) {
                  return DropdownMenuItem(
                    value: lang,
                    child: Text(lang),
                  );
                }).toList(),
                onChanged: (value) {
                  _selectedLanguage = value;
                  if (value != null) _addSkill(value);
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: '使用フレームワーク'),
                items: frameworks.map((fw) {
                  return DropdownMenuItem(
                    value: fw,
                    child: Text(fw),
                  );
                }).toList(),
                onChanged: (value) {
                  _selectedFramework = value;
                  if (value != null) _addSkill(value);
                },
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: _selectedSkills
                    .map((s) => Chip(
                          label: Text(s),
                          onDeleted: () => _removeSkill(s),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveProfile,
                child: const Text('保存'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}