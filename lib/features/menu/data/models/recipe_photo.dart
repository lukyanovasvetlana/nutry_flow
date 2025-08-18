import 'dart:io';

/// Модель фотографии рецепта
class RecipePhoto {
  final String id;
  final String recipeId;
  final String url;
  final String? caption;
  final int order;
  final DateTime createdAt;
  final DateTime updatedAt;
  final File? file;

  const RecipePhoto({
    required this.id,
    required this.recipeId,
    required this.url,
    this.caption,
    required this.order,
    required this.createdAt,
    required this.updatedAt,
    this.file,
  });

  factory RecipePhoto.fromJson(Map<String, dynamic> json) {
    return RecipePhoto(
      id: json['id'] as String,
      recipeId: json['recipe_id'] as String,
      url: json['url'] as String,
      caption: json['caption'] as String?,
      order: json['order'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'recipe_id': recipeId,
      'url': url,
      'caption': caption,
      'order': order,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  RecipePhoto copyWith({
    String? id,
    String? recipeId,
    String? url,
    String? caption,
    int? order,
    DateTime? createdAt,
    DateTime? updatedAt,
    File? file,
  }) {
    return RecipePhoto(
      id: id ?? this.id,
      recipeId: recipeId ?? this.recipeId,
      url: url ?? this.url,
      caption: caption ?? this.caption,
      order: order ?? this.order,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      file: file ?? this.file,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RecipePhoto && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'RecipePhoto(id: $id, url: $url, order: $order)';
  }
}
