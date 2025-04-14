import 'dart:io';

class UserProfile {
  final String? name;
  final String? bio;
  final List<String>? skills;
  final double? rating;
  final String? avatarUrl;        // URL（Firebase想定）
  final File? avatarFile;         // ローカル画像ファイル（テスト時用）

  UserProfile({
    this.name,
    this.bio,
    this.skills,
    this.rating,
    this.avatarUrl,
    this.avatarFile,
  });

  UserProfile copyWith({
    String? name,
    String? bio,
    List<String>? skills,
    double? rating,
    String? avatarUrl,
    File? avatarFile,
  }) {
    return UserProfile(
      name: name ?? this.name,
      bio: bio ?? this.bio,
      skills: skills ?? this.skills,
      rating: rating ?? this.rating,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      avatarFile: avatarFile ?? this.avatarFile,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'bio': bio,
      'skills': skills,
      'rating': rating,
      'avatarUrl': avatarUrl,
      // avatarFile は File 型なので通常の Firestore 送信対象外
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      name: map['name'],
      bio: map['bio'],
      skills: List<String>.from(map['skills'] ?? []),
      rating: (map['rating'] ?? 0).toDouble(),
      avatarUrl: map['avatarUrl'],
      avatarFile: null, // Firestoreには File 型を保存しない
    );
  }
}