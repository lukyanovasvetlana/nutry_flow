class InsightArticle {
  final String id;
  final String title;
  final String description;
  final String author;
  final String authorAvatar;
  final String category;
  final String readTime;
  final String date;
  final String imageUrl;
  final bool isRecommended;
  final bool isFeatured;
  final bool isPopular;
  final List<String> tags;

  const InsightArticle({
    required this.id,
    required this.title,
    required this.description,
    required this.author,
    required this.authorAvatar,
    required this.category,
    required this.readTime,
    required this.date,
    required this.imageUrl,
    this.isRecommended = false,
    this.isFeatured = false,
    this.isPopular = false,
    this.tags = const [],
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is InsightArticle && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
