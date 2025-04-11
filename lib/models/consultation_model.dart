class Consultation {
  final String id;
  final String title;
  final String category;
  final String description;
  final DateTime createdAt;

  Consultation({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.createdAt,
  });

  factory Consultation.fromMap(String id, Map<String, dynamic> data) {
    return Consultation(
      id: id,
      title: data['title'] ?? '',
      category: data['category'] ?? '',
      description: data['description'] ?? '',
      createdAt: (data['createdAt'] as DateTime?) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'category': category,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
