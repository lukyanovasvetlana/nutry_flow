class InsightVideo {
  final String id;
  final String title;
  final String description;
  final String author;
  final String authorAvatar;
  final String category;
  final String duration;
  final String date;
  final String thumbnailUrl;
  final String videoUrl;
  final bool isRecommended;
  final List<String> tags;

  const InsightVideo({
    required this.id,
    required this.title,
    required this.description,
    required this.author,
    required this.authorAvatar,
    required this.category,
    required this.duration,
    required this.date,
    required this.thumbnailUrl,
    required this.videoUrl,
    this.isRecommended = false,
    this.tags = const [],
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is InsightVideo && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
