class RecipeStep {
  final int order;
  final String description;
  final String? imageUrl;

  RecipeStep({
    required this.order,
    required this.description,
    this.imageUrl,
  });

  factory RecipeStep.fromJson(Map<String, dynamic> json) {
    return RecipeStep(
      order: json['order'] as int,
      description: json['description'] as String,
      imageUrl: json['image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order': order,
      'description': description,
      'image_url': imageUrl,
    };
  }
}
