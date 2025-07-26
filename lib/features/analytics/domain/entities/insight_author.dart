class InsightAuthor {
  final String id;
  final String name;
  final String title;
  final String avatar;
  final String bio;
  final int articlesCount;
  final int followersCount;
  final bool isVerified;

  const InsightAuthor({
    required this.id,
    required this.name,
    required this.title,
    required this.avatar,
    required this.bio,
    required this.articlesCount,
    required this.followersCount,
    this.isVerified = false,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is InsightAuthor && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
} 