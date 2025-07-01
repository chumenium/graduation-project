import 'dart:io';
import 'package:flutter/material.dart';
import '../core/platform_utils.dart';
import '../data/models/user_profile.dart';

class ProfileAvatar extends StatelessWidget {
  final File? imageFile;       // モバイル/デスクトップ用ローカル画像ファイル
  final String? imageUrl;      // Web用 or Firebase用URL
  final double radius;

  const ProfileAvatar({
    super.key,
    this.imageFile,
    this.imageUrl,
    this.radius = 30,
  });

  @override
  Widget build(BuildContext context) {
    ImageProvider? provider;

    if (PlatformUtils.isWeb) {
      if (imageUrl != null && imageUrl!.isNotEmpty) {
        provider = NetworkImage(imageUrl!);
      }
    } else {
      if (imageFile != null) {
        provider = FileImage(imageFile!);
      } else if (imageUrl != null && imageUrl!.isNotEmpty) {
        provider = NetworkImage(imageUrl!);
      }
    }

    return CircleAvatar(
      radius: radius,
      backgroundImage: provider,
      child: provider == null
          ? Icon(Icons.person, size: radius)
          : null,
    );
  }
}