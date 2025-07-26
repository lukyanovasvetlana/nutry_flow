import 'ingredient.dart';
import 'recipe_step.dart';
import 'recipe_photo.dart';
import 'nutrition_facts.dart';

class MenuItem {
  final String id;
  final String title;
  final String description;
  final String category;
  final String difficulty;
  final double rating;
  final List<RecipePhoto> photos;
  final List<Ingredient> ingredients;
  final List<RecipeStep> steps;
  final NutritionFacts? nutrition;
  
  // Дополнительные поля для совместимости
  final int cookingTime; // в минутах
  final int servings;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;

  MenuItem({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.difficulty,
    this.rating = 0,
    required this.photos,
    required this.ingredients,
    required this.steps,
    this.nutrition,
    this.cookingTime = 30,
    this.servings = 1,
    this.tags = const [],
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      difficulty: json['difficulty'] as String,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      photos: (json['photos'] as List? ?? []).map((p) => RecipePhoto.fromJson(p)).toList(),
      ingredients: (json['ingredients'] as List? ?? []).map((i) => Ingredient.fromJson(i)).toList(),
      steps: (json['steps'] as List? ?? []).map((s) => RecipeStep.fromJson(s)).toList(),
      nutrition: json['nutrition'] != null ? NutritionFacts.fromJson(json['nutrition']) : null,
      cookingTime: json['cooking_time'] as int? ?? 30,
      servings: json['servings'] as int? ?? 1,
      tags: List<String>.from(json['tags'] ?? []),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'difficulty': difficulty,
      'rating': rating,
      'photos': photos.map((p) => p.toJson()).toList(),
      'ingredients': ingredients.map((i) => i.toJson()).toList(),
      'steps': steps.map((s) => s.toJson()).toList(),
      'nutrition': nutrition?.toJson(),
      'cooking_time': cookingTime,
      'servings': servings,
      'tags': tags,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
} 