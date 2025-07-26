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
  final NutritionFacts nutrition;

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
    required this.nutrition,
  });

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
      nutrition: NutritionFacts.fromJson(json['nutrition']),
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
      'nutrition': nutrition.toJson(),
    };
  }
} 