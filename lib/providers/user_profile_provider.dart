import 'dart:io';

import 'package:flutter/material.dart';
import '../data/models/user_profile.dart';

class UserProfileProvider with ChangeNotifier {
  UserProfile? _profile;

  UserProfile? get profile => _profile;

  void updateProfile(UserProfile profile) {
    _profile = profile;
    notifyListeners();
  }

  void updateAvatarFile(File file) {
    if (_profile != null) {
      _profile = _profile!.copyWith(avatarFile: file);
      notifyListeners();
    }
  }

  void clearProfile() {
    _profile = null;
    notifyListeners();
  }
}