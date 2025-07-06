import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String id;
  final String email;
  final String? displayName;
  final String? photoURL;
  final String? bio;
  final int balance;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> consultationHistory;
  final Map<String, dynamic> preferences;

  UserProfile({
    required this.id,
    required this.email,
    this.displayName,
    this.photoURL,
    this.bio,
    this.balance = 0,
    required this.createdAt,
    required this.updatedAt,
    this.consultationHistory = const [],
    this.preferences = const {},
  });

  // Firestoreからデータを取得するためのファクトリメソッド
  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserProfile(
      id: doc.id,
      email: data['email'] ?? '',
      displayName: data['displayName'],
      photoURL: data['photoURL'],
      bio: data['bio'],
      balance: data['balance'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      consultationHistory: List<String>.from(data['consultationHistory'] ?? []),
      preferences: Map<String, dynamic>.from(data['preferences'] ?? {}),
    );
  }

  // Firestoreに保存するためのMapに変換
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'bio': bio,
      'balance': balance,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'consultationHistory': consultationHistory,
      'preferences': preferences,
    };
  }

  // プロフィールを更新するためのコピーメソッド
  UserProfile copyWith({
    String? displayName,
    String? photoURL,
    String? bio,
    int? balance,
    List<String>? consultationHistory,
    Map<String, dynamic>? preferences,
  }) {
    return UserProfile(
      id: id,
      email: email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      bio: bio ?? this.bio,
      balance: balance ?? this.balance,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      consultationHistory: consultationHistory ?? this.consultationHistory,
      preferences: preferences ?? this.preferences,
    );
  }
} 