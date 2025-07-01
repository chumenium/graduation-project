import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/user_profile.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;

  // ユーザープロフィールを保存
  Future<void> saveUserProfile(String uid, UserProfile profile) async {
    await _db.collection('users').doc(uid).set(profile.toMap());
  }

  // ユーザープロフィールを取得
  Future<UserProfile?> getUserProfile(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserProfile.fromMap(doc.data()!);
    }
    return null;
  }
}