import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../data/models/user_profile.dart';
import '../../../data/services/firestore_service.dart';

class UserProfileProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserProfile? _userProfile;
  bool _isLoading = false;
  String? _error;

  // ゲッター
  UserProfile? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _auth.currentUser != null;

  // 現在のユーザーIDを取得
  String? get currentUserId => _auth.currentUser?.uid;

  // ユーザープロフィールを設定
  void setUserProfile(UserProfile profile) {
    _userProfile = profile;
    _error = null;
    notifyListeners();
  }

  // ユーザープロフィールをクリア
  void clearUserProfile() {
    _userProfile = null;
    _error = null;
    notifyListeners();
  }

  // 現在のユーザーのプロフィールを読み込み
  Future<void> loadCurrentUserProfile() async {
    final userId = currentUserId;
    if (userId == null) {
      _error = 'ユーザーが認証されていません';
      notifyListeners();
      return;
    }

    _setLoading(true);
    try {
      final profile = await _firestoreService.getUserProfile(userId);
      if (profile != null) {
        _userProfile = profile;
        _error = null;
      } else {
        _error = 'ユーザープロフィールが見つかりません';
      }
    } catch (e) {
      _error = 'プロフィールの読み込みに失敗しました: $e';
    } finally {
      _setLoading(false);
    }
  }

  // ユーザープロフィールを更新
  Future<void> updateUserProfile(UserProfile updatedProfile) async {
    if (_userProfile == null) {
      _error = 'プロフィールが読み込まれていません';
      notifyListeners();
      return;
    }

    _setLoading(true);
    try {
      await _firestoreService.updateUserProfile(updatedProfile);
      _userProfile = updatedProfile;
      _error = null;
    } catch (e) {
      _error = 'プロフィールの更新に失敗しました: $e';
    } finally {
      _setLoading(false);
    }
  }

  // 表示名を更新
  Future<void> updateDisplayName(String displayName) async {
    if (_userProfile == null) return;

    final updatedProfile = _userProfile!.copyWith(displayName: displayName);
    await updateUserProfile(updatedProfile);
  }

  // 自己紹介を更新
  Future<void> updateBio(String bio) async {
    if (_userProfile == null) return;

    final updatedProfile = _userProfile!.copyWith(bio: bio);
    await updateUserProfile(updatedProfile);
  }

  // プロフィール画像URLを更新
  Future<void> updatePhotoURL(String photoURL) async {
    if (_userProfile == null) return;

    final updatedProfile = _userProfile!.copyWith(photoURL: photoURL);
    await updateUserProfile(updatedProfile);
  }

  // 残高を更新
  Future<void> updateBalance(int newBalance) async {
    if (_userProfile == null) return;

    final updatedProfile = _userProfile!.copyWith(balance: newBalance);
    await updateUserProfile(updatedProfile);
  }

  // 残高を増加
  Future<void> addBalance(int amount) async {
    if (_userProfile == null) return;

    final newBalance = _userProfile!.balance + amount;
    await updateBalance(newBalance);
  }

  // 残高を減少
  Future<void> subtractBalance(int amount) async {
    if (_userProfile == null) return;

    final newBalance = _userProfile!.balance - amount;
    if (newBalance < 0) {
      _error = '残高が不足しています';
      notifyListeners();
      return;
    }
    await updateBalance(newBalance);
  }

  // 設定を更新
  Future<void> updatePreferences(Map<String, dynamic> preferences) async {
    if (_userProfile == null) return;

    final updatedProfile = _userProfile!.copyWith(preferences: preferences);
    await updateUserProfile(updatedProfile);
  }

  // 相談履歴に追加
  Future<void> addToConsultationHistory(String consultationId) async {
    if (_userProfile == null) return;

    final updatedHistory = List<String>.from(_userProfile!.consultationHistory)
      ..add(consultationId);
    
    final updatedProfile = _userProfile!.copyWith(consultationHistory: updatedHistory);
    await updateUserProfile(updatedProfile);
  }

  // ログアウト
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      clearUserProfile();
    } catch (e) {
      _error = 'ログアウトに失敗しました: $e';
      notifyListeners();
    }
  }

  // エラーをクリア
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // ローディング状態を設定
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // 認証状態の変更を監視
  void listenToAuthChanges() {
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        clearUserProfile();
      } else {
        loadCurrentUserProfile();
      }
    });
  }
} 