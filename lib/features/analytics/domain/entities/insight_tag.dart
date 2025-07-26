class InsightTag {
  final String id;
  final String name;
  final String category;
  final int articleCount;
  final bool isTrending;
  final String color;

  const InsightTag({
    required this.id,
    required this.name,
    required this.category,
    required this.articleCount,
    this.isTrending = false,
    this.color = '#4CAF50',
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is InsightTag && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
} 