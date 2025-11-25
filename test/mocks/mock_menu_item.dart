import 'package:nutry_flow/features/menu/data/models/menu_item.dart';
import 'package:nutry_flow/features/menu/data/models/recipe_photo.dart';
import 'package:nutry_flow/features/menu/data/models/ingredient.dart';
import 'package:nutry_flow/features/menu/data/models/recipe_step.dart';
import 'package:nutry_flow/features/menu/data/models/nutrition_facts.dart';
import 'package:nutry_flow/features/menu/data/models/nutrition_info.dart';

class MockMenuItem extends MenuItem {
  MockMenuItem({
    required super.id,
    required super.title,
    required super.description,
    required super.category,
    required super.difficulty,
    required super.rating,
    required super.photos,
    required super.ingredients,
    required super.steps,
    required super.nutrition,
  });

  static MenuItem createSample() {
    final now = DateTime.now();
    return MockMenuItem(
      id: '1',
      title: 'Sample Recipe',
      description: 'A delicious sample recipe for testing',
      category: 'Main Course',
      difficulty: 'Easy',
      rating: 4.5,
      photos: [
        RecipePhoto(
          id: '1',
          recipeId: '1',
          url: 'https://example.com/photo1.jpg',
          order: 0,
          createdAt: now,
          updatedAt: now,
        ),
      ],
      ingredients: [
        Ingredient(
          name: 'ingredient1',
          amount: 100.0,
          unit: 'g',
          nutritionPer100g: NutritionInfo(
            calories: 100.0,
            protein: 5.0,
            fat: 2.0,
            carbs: 15.0,
          ),
        ),
      ],
      steps: [
        RecipeStep(
          id: '1',
          description: 'step1',
          order: 0,
          createdAt: now,
          updatedAt: now,
        ),
      ],
      nutrition: NutritionFacts(
        calories: 250.0,
        protein: 15.0,
        fat: 10.0,
        carbs: 30.0,
        fiber: 5.0,
        sodium: 300.0,
        cholesterol: 0.0,
        sugar: 10.0,
        vitaminC: 20.0,
      ),
    );
  }

  static MenuItem createMinimal() {
    final now = DateTime.now();
    return MockMenuItem(
      id: '2',
      title: 'Minimal Recipe',
      description: 'A minimal recipe',
      category: 'Dessert',
      difficulty: 'Easy',
      rating: 3.0,
      photos: [],
      ingredients: [
        Ingredient(
          name: 'ingredient1',
          amount: 50.0,
          unit: 'g',
          nutritionPer100g: NutritionInfo(
            calories: 50.0,
            protein: 2.5,
            fat: 1.0,
            carbs: 7.5,
          ),
        ),
      ],
      steps: [
        RecipeStep(
          id: '1',
          description: 'step1',
          order: 0,
          createdAt: now,
          updatedAt: now,
        ),
      ],
      nutrition: NutritionFacts(
        calories: 100.0,
        protein: 5.0,
        fat: 3.0,
        carbs: 15.0,
        fiber: 2.0,
        sodium: 150.0,
        cholesterol: 0.0,
        sugar: 5.0,
        vitaminC: 10.0,
      ),
    );
  }
}
