import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_profile.dart';
import '../models/consultation_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // コレクション名の定数
  static const String usersCollection = 'users';
  static const String consultationsCollection = 'consultations';

  // 現在のユーザーIDを取得
  String? get currentUserId => _auth.currentUser?.uid;

  // ユーザープロフィール関連の操作
  // ==========================================

  // ユーザープロフィールを作成
  Future<void> createUserProfile(UserProfile profile) async {
    try {
      await _firestore
          .collection(usersCollection)
          .doc(profile.id)
          .set(profile.toFirestore());
    } catch (e) {
      throw Exception('ユーザープロフィールの作成に失敗しました: $e');
    }
  }

  // ユーザープロフィールを取得
  Future<UserProfile?> getUserProfile(String userId) async {
    try {
      final doc = await _firestore
          .collection(usersCollection)
          .doc(userId)
          .get();
      
      if (doc.exists) {
        return UserProfile.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('ユーザープロフィールの取得に失敗しました: $e');
    }
  }

  // 現在のユーザーのプロフィールを取得
  Future<UserProfile?> getCurrentUserProfile() async {
    final userId = currentUserId;
    if (userId == null) return null;
    return await getUserProfile(userId);
  }

  // ユーザープロフィールを更新
  Future<void> updateUserProfile(UserProfile profile) async {
    try {
      await _firestore
          .collection(usersCollection)
          .doc(profile.id)
          .update(profile.toFirestore());
    } catch (e) {
      throw Exception('ユーザープロフィールの更新に失敗しました: $e');
    }
  }

  // ユーザーの残高を更新
  Future<void> updateUserBalance(String userId, int newBalance) async {
    try {
      await _firestore
          .collection(usersCollection)
          .doc(userId)
          .update({
        'balance': newBalance,
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('残高の更新に失敗しました: $e');
    }
  }

  // 相談関連の操作
  // ==========================================

  // 相談を作成
  Future<String> createConsultation(Consultation consultation) async {
    try {
      final docRef = await _firestore
          .collection(consultationsCollection)
          .add(consultation.toFirestore());
      return docRef.id;
    } catch (e) {
      throw Exception('相談の作成に失敗しました: $e');
    }
  }

  // 相談を取得
  Future<Consultation?> getConsultation(String consultationId) async {
    try {
      final doc = await _firestore
          .collection(consultationsCollection)
          .doc(consultationId)
          .get();
      
      if (doc.exists) {
        return Consultation.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('相談の取得に失敗しました: $e');
    }
  }

  // 相談を更新
  Future<void> updateConsultation(Consultation consultation) async {
    try {
      await _firestore
          .collection(consultationsCollection)
          .doc(consultation.id)
          .update(consultation.toFirestore());
    } catch (e) {
      throw Exception('相談の更新に失敗しました: $e');
    }
  }

  // 相談を削除
  Future<void> deleteConsultation(String consultationId) async {
    try {
      await _firestore
          .collection(consultationsCollection)
          .doc(consultationId)
          .delete();
    } catch (e) {
      throw Exception('相談の削除に失敗しました: $e');
    }
  }

  // 公開中の相談一覧を取得
  Stream<List<Consultation>> getOpenConsultations() {
    return _firestore
        .collection(consultationsCollection)
        .where('status', isEqualTo: 'open')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Consultation.fromFirestore(doc))
            .toList());
  }

  // 特定のユーザーの相談一覧を取得
  Stream<List<Consultation>> getUserConsultations(String userId) {
    return _firestore
        .collection(consultationsCollection)
        .where('authorId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Consultation.fromFirestore(doc))
            .toList());
  }

  // 解決済みの相談一覧を取得
  Stream<List<Consultation>> getSolvedConsultations() {
    return _firestore
        .collection(consultationsCollection)
        .where('status', isEqualTo: 'solved')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Consultation.fromFirestore(doc))
            .toList());
  }

  // 相談の閲覧数を増加
  Future<void> incrementViewCount(String consultationId) async {
    try {
      await _firestore
          .collection(consultationsCollection)
          .doc(consultationId)
          .update({
        'viewCount': FieldValue.increment(1),
      });
    } catch (e) {
      throw Exception('閲覧数の更新に失敗しました: $e');
    }
  }

  // 相談に興味を示すユーザーを追加/削除
  Future<void> toggleInterest(String consultationId, String userId) async {
    try {
      final docRef = _firestore
          .collection(consultationsCollection)
          .doc(consultationId);
      
      final doc = await docRef.get();
      if (doc.exists) {
        final consultation = Consultation.fromFirestore(doc);
        final interestedUsers = List<String>.from(consultation.interestedUsers);
        
        if (interestedUsers.contains(userId)) {
          interestedUsers.remove(userId);
        } else {
          interestedUsers.add(userId);
        }
        
        await docRef.update({
          'interestedUsers': interestedUsers,
          'updatedAt': Timestamp.now(),
        });
      }
    } catch (e) {
      throw Exception('興味の更新に失敗しました: $e');
    }
  }

  // バックアップ関連の操作
  // ==========================================

  // ユーザーデータのバックアップを作成
  Future<void> createUserBackup(String userId) async {
    try {
      final userProfile = await getUserProfile(userId);
      if (userProfile != null) {
        final consultations = await _firestore
            .collection(consultationsCollection)
            .where('authorId', isEqualTo: userId)
            .get();
        
        final backupData = {
          'userProfile': userProfile.toFirestore(),
          'consultations': consultations.docs.map((doc) => doc.data()).toList(),
          'backupCreatedAt': Timestamp.now(),
        };
        
        await _firestore
            .collection('backups')
            .doc(userId)
            .set(backupData);
      }
    } catch (e) {
      throw Exception('バックアップの作成に失敗しました: $e');
    }
  }

  // バックアップからユーザーデータを復元
  Future<void> restoreUserBackup(String userId) async {
    try {
      final backupDoc = await _firestore
          .collection('backups')
          .doc(userId)
          .get();
      
      if (backupDoc.exists) {
        final backupData = backupDoc.data() as Map<String, dynamic>;
        
        // ユーザープロフィールを復元
        final userProfileData = backupData['userProfile'] as Map<String, dynamic>;
        await _firestore
            .collection(usersCollection)
            .doc(userId)
            .set(userProfileData);
        
        // 相談データを復元
        final consultationsData = backupData['consultations'] as List;
        for (final consultationData in consultationsData) {
          await _firestore
              .collection(consultationsCollection)
              .add(consultationData);
        }
      }
    } catch (e) {
      throw Exception('バックアップの復元に失敗しました: $e');
    }
  }
} 