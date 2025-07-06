import 'package:cloud_firestore/cloud_firestore.dart';

class Consultation {
  final String id;
  final String title;
  final String description;
  final String category;
  final String authorId;
  final String? authorName;
  final String? authorPhotoURL;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String status; // 'open', 'in_progress', 'solved', 'closed'
  final int budget;
  final List<String> tags;
  final Map<String, dynamic> metadata;
  final int viewCount;
  final List<String> interestedUsers;

  Consultation({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.authorId,
    this.authorName,
    this.authorPhotoURL,
    required this.createdAt,
    required this.updatedAt,
    this.status = 'open',
    this.budget = 0,
    this.tags = const [],
    this.metadata = const {},
    this.viewCount = 0,
    this.interestedUsers = const [],
  });

  // Firestoreからデータを取得するためのファクトリメソッド
  factory Consultation.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Consultation(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      authorId: data['authorId'] ?? '',
      authorName: data['authorName'],
      authorPhotoURL: data['authorPhotoURL'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      status: data['status'] ?? 'open',
      budget: data['budget'] ?? 0,
      tags: List<String>.from(data['tags'] ?? []),
      metadata: Map<String, dynamic>.from(data['metadata'] ?? {}),
      viewCount: data['viewCount'] ?? 0,
      interestedUsers: List<String>.from(data['interestedUsers'] ?? []),
    );
  }

  // Firestoreに保存するためのMapに変換
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'authorId': authorId,
      'authorName': authorName,
      'authorPhotoURL': authorPhotoURL,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'status': status,
      'budget': budget,
      'tags': tags,
      'metadata': metadata,
      'viewCount': viewCount,
      'interestedUsers': interestedUsers,
    };
  }

  // 相談を更新するためのコピーメソッド
  Consultation copyWith({
    String? title,
    String? description,
    String? category,
    String? status,
    int? budget,
    List<String>? tags,
    Map<String, dynamic>? metadata,
    int? viewCount,
    List<String>? interestedUsers,
  }) {
    return Consultation(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      authorId: authorId,
      authorName: authorName,
      authorPhotoURL: authorPhotoURL,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      status: status ?? this.status,
      budget: budget ?? this.budget,
      tags: tags ?? this.tags,
      metadata: metadata ?? this.metadata,
      viewCount: viewCount ?? this.viewCount,
      interestedUsers: interestedUsers ?? this.interestedUsers,
    );
  }

  // 相談が解決済みかどうかを判定
  bool get isSolved => status == 'solved';
  
  // 相談が公開中かどうかを判定
  bool get isOpen => status == 'open';
  
  // 相談が進行中かどうかを判定
  bool get isInProgress => status == 'in_progress';
}
