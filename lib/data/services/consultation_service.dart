import 'package:firebase_auth/firebase_auth.dart';
import '../models/consultation_model.dart';
import '../models/user_profile.dart';
import 'firestore_service.dart';

class ConsultationService {
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 現在のユーザーIDを取得
  String? get currentUserId => _auth.currentUser?.uid;

  // 相談を作成
  Future<String> createConsultation({
    required String title,
    required String description,
    required String category,
    int budget = 0,
    List<String> tags = const [],
  }) async {
    try {
      final userId = currentUserId;
      if (userId == null) {
        throw Exception('ユーザーが認証されていません');
      }

      // 現在のユーザープロフィールを取得
      final userProfile = await _firestoreService.getCurrentUserProfile();
      if (userProfile == null) {
        throw Exception('ユーザープロフィールが見つかりません');
      }

      // 新しい相談を作成
      final consultation = Consultation(
        id: '', // Firestoreで自動生成される
        title: title,
        description: description,
        category: category,
        authorId: userId,
        authorName: userProfile.displayName,
        authorPhotoURL: userProfile.photoURL,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        budget: budget,
        tags: tags,
      );

      // Firestoreに保存
      final consultationId = await _firestoreService.createConsultation(consultation);
      
      // ユーザーの相談履歴に追加
      final updatedHistory = List<String>.from(userProfile.consultationHistory)
        ..add(consultationId);
      
      final updatedProfile = userProfile.copyWith(
        consultationHistory: updatedHistory,
      );
      
      await _firestoreService.updateUserProfile(updatedProfile);

      return consultationId;
    } catch (e) {
      throw Exception('相談の作成に失敗しました: $e');
    }
  }

  // 公開中の相談一覧を取得
  Stream<List<Consultation>> getOpenConsultations() {
    return _firestoreService.getOpenConsultations();
  }

  // 特定のユーザーの相談一覧を取得
  Stream<List<Consultation>> getUserConsultations(String userId) {
    return _firestoreService.getUserConsultations(userId);
  }

  // 現在のユーザーの相談一覧を取得
  Stream<List<Consultation>> getCurrentUserConsultations() {
    final userId = currentUserId;
    if (userId == null) {
      return Stream.value([]);
    }
    return _firestoreService.getUserConsultations(userId);
  }

  // 解決済みの相談一覧を取得
  Stream<List<Consultation>> getSolvedConsultations() {
    return _firestoreService.getSolvedConsultations();
  }

  // 相談を取得
  Future<Consultation?> getConsultation(String consultationId) async {
    try {
      return await _firestoreService.getConsultation(consultationId);
    } catch (e) {
      throw Exception('相談の取得に失敗しました: $e');
    }
  }

  // 相談を更新
  Future<void> updateConsultation(Consultation consultation) async {
    try {
      // 更新者を確認
      final userId = currentUserId;
      if (userId == null || userId != consultation.authorId) {
        throw Exception('この相談を更新する権限がありません');
      }

      await _firestoreService.updateConsultation(consultation);
    } catch (e) {
      throw Exception('相談の更新に失敗しました: $e');
    }
  }

  // 相談を削除
  Future<void> deleteConsultation(String consultationId) async {
    try {
      // 相談の所有者を確認
      final consultation = await _firestoreService.getConsultation(consultationId);
      if (consultation == null) {
        throw Exception('相談が見つかりません');
      }

      final userId = currentUserId;
      if (userId == null || userId != consultation.authorId) {
        throw Exception('この相談を削除する権限がありません');
      }

      await _firestoreService.deleteConsultation(consultationId);
    } catch (e) {
      throw Exception('相談の削除に失敗しました: $e');
    }
  }

  // 相談の閲覧数を増加
  Future<void> incrementViewCount(String consultationId) async {
    try {
      await _firestoreService.incrementViewCount(consultationId);
    } catch (e) {
      throw Exception('閲覧数の更新に失敗しました: $e');
    }
  }

  // 相談に興味を示す/興味を削除
  Future<void> toggleInterest(String consultationId) async {
    try {
      final userId = currentUserId;
      if (userId == null) {
        throw Exception('ユーザーが認証されていません');
      }

      await _firestoreService.toggleInterest(consultationId, userId);
    } catch (e) {
      throw Exception('興味の更新に失敗しました: $e');
    }
  }

  // 相談のステータスを更新
  Future<void> updateConsultationStatus(String consultationId, String status) async {
    try {
      final consultation = await _firestoreService.getConsultation(consultationId);
      if (consultation == null) {
        throw Exception('相談が見つかりません');
      }

      final userId = currentUserId;
      if (userId == null || userId != consultation.authorId) {
        throw Exception('この相談を更新する権限がありません');
      }

      final updatedConsultation = consultation.copyWith(status: status);
      await _firestoreService.updateConsultation(updatedConsultation);
    } catch (e) {
      throw Exception('ステータスの更新に失敗しました: $e');
    }
  }

  // 相談を解決済みにマーク
  Future<void> markAsSolved(String consultationId) async {
    await updateConsultationStatus(consultationId, 'solved');
  }

  // 相談を進行中にマーク
  Future<void> markAsInProgress(String consultationId) async {
    await updateConsultationStatus(consultationId, 'in_progress');
  }

  // 相談を閉じる
  Future<void> closeConsultation(String consultationId) async {
    await updateConsultationStatus(consultationId, 'closed');
  }

  // カテゴリ別の相談を取得
  Stream<List<Consultation>> getConsultationsByCategory(String category) {
    return _firestoreService.getOpenConsultations().map((consultations) {
      return consultations.where((consultation) => consultation.category == category).toList();
    });
  }

  // 予算範囲内の相談を取得
  Stream<List<Consultation>> getConsultationsByBudgetRange(int minBudget, int maxBudget) {
    return _firestoreService.getOpenConsultations().map((consultations) {
      return consultations.where((consultation) => 
        consultation.budget >= minBudget && consultation.budget <= maxBudget
      ).toList();
    });
  }

  // タグで相談を検索
  Stream<List<Consultation>> searchConsultationsByTags(List<String> tags) {
    return _firestoreService.getOpenConsultations().map((consultations) {
      return consultations.where((consultation) => 
        tags.any((tag) => consultation.tags.contains(tag))
      ).toList();
    });
  }

  // 相談の統計情報を取得
  Future<Map<String, dynamic>> getConsultationStats(String userId) async {
    try {
      final consultations = await _firestoreService.getUserConsultations(userId).first;
      
      int totalConsultations = consultations.length;
      int openConsultations = consultations.where((c) => c.isOpen).length;
      int solvedConsultations = consultations.where((c) => c.isSolved).length;
      int inProgressConsultations = consultations.where((c) => c.isInProgress).length;
      int totalViews = consultations.fold(0, (sum, c) => sum + c.viewCount);
      int totalInterests = consultations.fold(0, (sum, c) => sum + c.interestedUsers.length);

      return {
        'totalConsultations': totalConsultations,
        'openConsultations': openConsultations,
        'solvedConsultations': solvedConsultations,
        'inProgressConsultations': inProgressConsultations,
        'totalViews': totalViews,
        'totalInterests': totalInterests,
      };
    } catch (e) {
      throw Exception('統計情報の取得に失敗しました: $e');
    }
  }
} 