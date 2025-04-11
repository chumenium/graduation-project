class UserProfile {
  final String name;
  final String? avatarUrl;
  final String bio;
  final List<String> skills;
  final double rating;

  UserProfile({
    required this.name,
    this.avatarUrl,
    required this.bio,
    required this.skills,
    this.rating = 0.0,
  });
}