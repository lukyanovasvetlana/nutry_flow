import 'dart:io';
import 'dart:developer' as developer;
import '../models/menu_item.dart';
import '../models/ingredient.dart';
import '../models/recipe_step.dart';
import '../models/recipe_photo.dart';
import '../models/nutrition_facts.dart';
import '../models/nutrition_info.dart';

/// Мок-версия RecipeService для демо-режима
/// Возвращает тестовые данные вместо обращения к Supabase
class MockRecipeService {
  static final List<MenuItem> _mockRecipes = [
    MenuItem(
      id: '1',
      title: 'Овсяная каша с ягодами',
      description: 'Полезный завтрак с овсянкой и свежими ягодами',
      category: 'Завтрак',
      difficulty: 'Легко',
      rating: 4.5,
      photos: [
        RecipePhoto(
          id: '1',
          recipeId: '1',
          url:
              'https://images.unsplash.com/photo-1517686469429-8bdb88b9f907?w=400',
          order: 1,
          createdAt: DateTime(2023, 1, 1),
          updatedAt: DateTime(2023, 1, 1),
        ),
      ],
      ingredients: [
        Ingredient(
          name: 'Овсяные хлопья',
          amount: 50,
          unit: 'г',
          nutritionPer100g: NutritionInfo(
            calories: 389,
            protein: 16.9,
            fat: 6.9,
            carbs: 66.3,
          ),
        ),
        Ingredient(
          name: 'Молоко',
          amount: 200,
          unit: 'мл',
          nutritionPer100g: NutritionInfo(
            calories: 64,
            protein: 3.2,
            fat: 3.6,
            carbs: 4.8,
          ),
        ),
        Ingredient(
          name: 'Ягоды микс',
          amount: 100,
          unit: 'г',
          nutritionPer100g: NutritionInfo(
            calories: 43,
            protein: 1.4,
            fat: 0.3,
            carbs: 9.6,
          ),
        ),
      ],
      steps: [
        RecipeStep(
          id: 'step1',
          order: 1,
          description: 'Залить овсяные хлопья молоком и довести до кипения',
          createdAt: DateTime(2023, 1, 1),
          updatedAt: DateTime(2023, 1, 1),
        ),
        RecipeStep(
          id: 'step2',
          order: 2,
          description: 'Варить 5-7 минут на медленном огне, помешивая',
          createdAt: DateTime(2023, 1, 1),
          updatedAt: DateTime(2023, 1, 1),
        ),
        RecipeStep(
          id: 'step3',
          order: 3,
          description: 'Добавить ягоды и подавать горячим',
          createdAt: DateTime(2023, 1, 1),
          updatedAt: DateTime(2023, 1, 1),
        ),
      ],
      nutrition: NutritionFacts(
        calories: 350,
        protein: 12,
        fat: 8,
        carbs: 45,
        fiber: 6,
        sodium: 50,
        cholesterol: 15,
        sugar: 12,
        vitaminC: 25,
      ),
    ),
    MenuItem(
      id: '2',
      title: 'Греческий салат',
      description: 'Свежий салат с оливками, сыром фета и помидорами',
      category: 'Салат',
      difficulty: 'Легко',
      rating: 4.8,
      photos: [
        RecipePhoto(
          id: '2',
          recipeId: '2',
          url:
              'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=400',
          order: 1,
          createdAt: DateTime(2023, 1, 2),
          updatedAt: DateTime(2023, 1, 2),
        ),
      ],
      ingredients: [
        Ingredient(
          name: 'Помидоры',
          amount: 300,
          unit: 'г',
          nutritionPer100g: NutritionInfo(
            calories: 18,
            protein: 0.9,
            fat: 0.2,
            carbs: 3.9,
          ),
        ),
        Ingredient(
          name: 'Огурцы',
          amount: 200,
          unit: 'г',
          nutritionPer100g: NutritionInfo(
            calories: 16,
            protein: 0.7,
            fat: 0.1,
            carbs: 2.8,
          ),
        ),
        Ingredient(
          name: 'Сыр фета',
          amount: 100,
          unit: 'г',
          nutritionPer100g: NutritionInfo(
            calories: 264,
            protein: 14.2,
            fat: 21.3,
            carbs: 4.1,
          ),
        ),
      ],
      steps: [
        RecipeStep(
          id: 'step4',
          order: 1,
          description: 'Нарезать помидоры и огурцы крупными кусочками',
          createdAt: DateTime(2023, 1, 2),
          updatedAt: DateTime(2023, 1, 2),
        ),
        RecipeStep(
          id: 'step5',
          order: 2,
          description: 'Добавить кубики сыра фета и оливки',
          createdAt: DateTime(2023, 1, 2),
          updatedAt: DateTime(2023, 1, 2),
        ),
        RecipeStep(
          id: 'step6',
          order: 3,
          description: 'Заправить оливковым маслом и лимонным соком',
          createdAt: DateTime(2023, 1, 2),
          updatedAt: DateTime(2023, 1, 2),
        ),
      ],
      nutrition: NutritionFacts(
        calories: 280,
        protein: 15,
        fat: 22,
        carbs: 8,
        fiber: 4,
        sodium: 800,
        cholesterol: 45,
        sugar: 6,
        vitaminC: 40,
      ),
    ),
    MenuItem(
      id: '3',
      title: 'Куриная грудка с овощами',
      description: 'Запеченная куриная грудка с сезонными овощами',
      category: 'Основное блюдо',
      difficulty: 'Средне',
      rating: 4.6,
      photos: [
        RecipePhoto(
          id: '3',
          recipeId: '3',
          url:
              'https://images.unsplash.com/photo-1532550907401-a500c9a57435?w=400',
          order: 1,
          createdAt: DateTime(2023, 1, 3),
          updatedAt: DateTime(2023, 1, 3),
        ),
      ],
      ingredients: [
        Ingredient(
          name: 'Куриная грудка',
          amount: 400,
          unit: 'г',
          nutritionPer100g: NutritionInfo(
            calories: 165,
            protein: 31,
            fat: 3.6,
            carbs: 0,
          ),
        ),
        Ingredient(
          name: 'Брокколи',
          amount: 200,
          unit: 'г',
          nutritionPer100g: NutritionInfo(
            calories: 34,
            protein: 2.8,
            fat: 0.4,
            carbs: 6.6,
          ),
        ),
        Ingredient(
          name: 'Морковь',
          amount: 150,
          unit: 'г',
          nutritionPer100g: NutritionInfo(
            calories: 41,
            protein: 0.9,
            fat: 0.2,
            carbs: 9.6,
          ),
        ),
      ],
      steps: [
        RecipeStep(
          id: 'step7',
          order: 1,
          description: 'Разогреть духовку до 200°C',
          createdAt: DateTime(2023, 1, 3),
          updatedAt: DateTime(2023, 1, 3),
        ),
        RecipeStep(
          id: 'step8',
          order: 2,
          description: 'Приправить куриную грудку солью и специями',
          createdAt: DateTime(2023, 1, 3),
          updatedAt: DateTime(2023, 1, 3),
        ),
        RecipeStep(
          id: 'step9',
          order: 3,
          description: 'Выложить курицу и овощи на противень',
          createdAt: DateTime(2023, 1, 3),
          updatedAt: DateTime(2023, 1, 3),
        ),
        RecipeStep(
          id: 'step10',
          order: 4,
          description: 'Запекать 25-30 минут до готовности',
          createdAt: DateTime(2023, 1, 3),
          updatedAt: DateTime(2023, 1, 3),
        ),
      ],
      nutrition: NutritionFacts(
        calories: 520,
        protein: 65,
        fat: 18,
        carbs: 25,
        fiber: 8,
        sodium: 200,
        cholesterol: 180,
        sugar: 15,
        vitaminC: 80,
      ),
    ),
  ];

  Future<List<MenuItem>> getAllRecipes() async {
    developer.log('🍽️ MockRecipeService: getAllRecipes called',
        name: 'MockRecipeService');

    // Имитируем задержку сети
    await Future.delayed(const Duration(milliseconds: 1000));

    developer.log(
        '🍽️ MockRecipeService: Returning ${_mockRecipes.length} mock recipes',
        name: 'MockRecipeService');
    return List.from(_mockRecipes);
  }

  Future<void> saveRecipe(MenuItem recipe, List<File> photos) async {
    developer.log('🍽️ MockRecipeService: saveRecipe called - ${recipe.title}',
        name: 'MockRecipeService');

    // Имитируем задержку сети
    await Future.delayed(const Duration(milliseconds: 1500));

    // Добавляем рецепт в мок-список
    _mockRecipes.add(recipe);

    developer.log('🍽️ MockRecipeService: Recipe saved successfully',
        name: 'MockRecipeService');
  }

  Future<void> updateRecipe(MenuItem recipe,
      {List<File>? newPhotos, List<String>? photosToDelete}) async {
    developer.log(
        '🍽️ MockRecipeService: updateRecipe called - ${recipe.title}',
        name: 'MockRecipeService');

    // Имитируем задержку сети
    await Future.delayed(const Duration(milliseconds: 1200));

    // Обновляем рецепт в мок-списке
    final index = _mockRecipes.indexWhere((r) => r.id == recipe.id);
    if (index != -1) {
      _mockRecipes[index] = recipe;
      developer.log('🍽️ MockRecipeService: Recipe updated successfully',
          name: 'MockRecipeService');
    } else {
      developer.log('🍽️ MockRecipeService: Recipe not found for update',
          name: 'MockRecipeService');
    }
  }

  Future<void> deleteRecipe(String recipeId) async {
    developer.log('🍽️ MockRecipeService: deleteRecipe called - $recipeId',
        name: 'MockRecipeService');

    // Имитируем задержку сети
    await Future.delayed(const Duration(milliseconds: 800));

    // Удаляем рецепт из мок-списка
    final initialLength = _mockRecipes.length;
    _mockRecipes.removeWhere((r) => r.id == recipeId);
    final removed = initialLength - _mockRecipes.length;

    if (removed > 0) {
      developer.log('🍽️ MockRecipeService: Recipe deleted successfully',
          name: 'MockRecipeService');
    } else {
      developer.log('🍽️ MockRecipeService: Recipe not found for deletion',
          name: 'MockRecipeService');
    }
  }

  /// Очищает все мок-рецепты (для тестирования)
  static void clearAll() {
    _mockRecipes.clear();
  }

  /// Получает количество мок-рецептов (для отладки)
  static int getRecipesCount() {
    return _mockRecipes.length;
  }
}
