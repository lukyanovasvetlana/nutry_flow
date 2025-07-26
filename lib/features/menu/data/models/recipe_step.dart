/// Модель шага рецепта
class RecipeStep {
  final String id;
  final String description;
  final int? duration; // в минутах
  final int? temperature; // в градусах Цельсия
  final int order;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? imageUrl;

  const RecipeStep({
    required this.id,
    required this.description,
    this.duration,
    this.temperature,
    required this.order,
    required this.createdAt,
    required this.updatedAt,
    this.imageUrl,
  });

  factory RecipeStep.fromJson(Map<String, dynamic> json) {
    return RecipeStep(
      id: json['id'] as String,
      description: json['description'] as String,
      duration: json['duration'] as int?,
      temperature: json['temperature'] as int?,
      order: json['order'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      imageUrl: json['image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'duration': duration,
      'temperature': temperature,
      'order': order,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'image_url': imageUrl,
    };
  }

  RecipeStep copyWith({
    String? id,
    String? description,
    int? duration,
    int? temperature,
    int? order,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? imageUrl,
  }) {
    return RecipeStep(
      id: id ?? this.id,
      description: description ?? this.description,
      duration: duration ?? this.duration,
      temperature: temperature ?? this.temperature,
      order: order ?? this.order,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RecipeStep && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'RecipeStep(id: $id, description: $description, order: $order)';
  }
} 