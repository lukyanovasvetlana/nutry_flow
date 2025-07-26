import '../../domain/entities/recipe.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../../../onboarding/data/services/supabase_service.dart';
import '../../../onboarding/data/services/local_storage_service.dart';

/// Реализация репозитория для работы с рецептами
class RecipeRepositoryImpl implements RecipeRepository {
  final SupabaseService _supabaseService;
  final LocalStorageService _localStorageService;
  
  static const String _tableName = 'recipes';
  static const String _cacheKey = 'recipes_cache';
  
  RecipeRepositoryImpl(
    this._supabaseService,
    this._localStorageService,
  );
  
  @override
  Future<List<Recipe>> getAllRecipes() async {
    try {
      // Получаем из Supabase
      final response = await _supabaseService.selectData(_tableName);
      
      final recipes = response.map((data) => _mapToRecipe(data)).toList();
      
      // Кэшируем результат
      await _cacheRecipes(recipes);
      
      return recipes;
      
    } catch (e) {
      // Fallback к кэшу
      return await _getCachedRecipes();
    }
  }
  
  @override
  Future<Recipe?> getRecipeById(String id) async {
    try {
      final response = await _supabaseService.selectData(
        _tableName,
        column: 'id',
        value: id,
      );
      
      if (response.isEmpty) return null;
      
      return _mapToRecipe(response.first);
      
    } catch (e) {
      // Ищем в кэше
      final cachedRecipes = await _getCachedRecipes();
      return cachedRecipes.firstWhere(
        (recipe) => recipe.id == id,
        orElse: () => throw Exception('Recipe not found'),
      );
    }
  }
  
  @override
  Future<Recipe> saveRecipe(Recipe recipe) async {
    try {
      final data = _mapFromRecipe(recipe);
      
      final response = await _supabaseService.insertData(_tableName, data);
      
      if (response.isEmpty) {
        throw Exception('Failed to save recipe');
      }
      
      final savedRecipe = _mapToRecipe(response.first);
      
      // Обновляем кэш
      await _updateCacheAfterSave(savedRecipe);
      
      return savedRecipe;
      
    } catch (e) {
      throw Exception('Failed to save recipe: $e');
    }
  }
  
  @override
  Future<Recipe> updateRecipe(Recipe recipe) async {
    try {
      final data = _mapFromRecipe(recipe);
      
      final response = await _supabaseService.updateData(
        _tableName,
        data,
        'id',
        recipe.id,
      );
      
      if (response.isEmpty) {
        throw Exception('Failed to update recipe');
      }
      
      final updatedRecipe = _mapToRecipe(response.first);
      
      // Обновляем кэш
      await _updateCacheAfterUpdate(updatedRecipe);
      
      return updatedRecipe;
      
    } catch (e) {
      throw Exception('Failed to update recipe: $e');
    }
  }
  
  @override
  Future<bool> deleteRecipe(String id) async {
    try {
      final response = await _supabaseService.deleteData(
        _tableName,
        'id',
        id,
      );
      
      if (response.isEmpty) {
        throw Exception('Failed to delete recipe');
      }
      
      // Удаляем из кэша
      await _removeFromCache(id);
      
      return true;
      
    } catch (e) {
      throw Exception('Failed to delete recipe: $e');
    }
  }
  
  @override
  Future<List<Recipe>> searchRecipes(String query) async {
    try {
      // Простой поиск по названию (можно расширить)
      final allRecipes = await getAllRecipes();
      
      return allRecipes.where((recipe) => 
        recipe.title.toLowerCase().contains(query.toLowerCase()) ||
        recipe.description.toLowerCase().contains(query.toLowerCase())
      ).toList();
      
    } catch (e) {
      throw Exception('Failed to search recipes: $e');
    }
  }
  
  @override
  Future<List<Recipe>> getRecipesByCategory(String category) async {
    try {
      final response = await _supabaseService.selectData(
        _tableName,
        column: 'category',
        value: category,
      );
      
      return response.map((data) => _mapToRecipe(data)).toList();
      
    } catch (e) {
      throw Exception('Failed to get recipes by category: $e');
    }
  }
  
  @override
  Future<List<Recipe>> getFavoriteRecipes() async {
    try {
      final response = await _supabaseService.selectData(
        _tableName,
        column: 'is_favorite',
        value: true,
      );
      
      return response.map((data) => _mapToRecipe(data)).toList();
      
    } catch (e) {
      throw Exception('Failed to get favorite recipes: $e');
    }
  }
  
  @override
  Future<bool> toggleFavorite(String recipeId, bool isFavorite) async {
    try {
      final response = await _supabaseService.updateData(
        _tableName,
        {'is_favorite': isFavorite},
        'id',
        recipeId,
      );
      
      return response.isNotEmpty;
      
    } catch (e) {
      throw Exception('Failed to toggle favorite: $e');
    }
  }
  
  // Приватные методы для работы с кэшем и маппингом
  
  Recipe _mapToRecipe(Map<String, dynamic> data) {
    return Recipe(
      id: data['id'] as String,
      title: data['title'] as String,
      description: data['description'] as String? ?? '',
      category: data['category'] as String? ?? '',
      difficulty: data['difficulty'] as String? ?? 'Средняя',
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      photos: [], // Пока пустой список
      ingredients: [], // Нужно будет получить из связанной таблицы
      steps: [], // Нужно будет получить из связанной таблицы
      nutrition: null, // Пока null
      cookingTime: data['cooking_time'] as int? ?? 30,
      servings: data['servings'] as int? ?? 1,
      tags: List<String>.from(data['tags'] ?? []),
      createdAt: DateTime.parse(data['created_at'] as String),
      updatedAt: DateTime.parse(data['updated_at'] as String),
    );
  }
  
  Map<String, dynamic> _mapFromRecipe(Recipe recipe) {
    return {
      'id': recipe.id,
      'title': recipe.title,
      'description': recipe.description,
      'category': recipe.category,
      'difficulty': recipe.difficulty,
      'rating': recipe.rating,
      'cooking_time': recipe.cookingTime,
      'servings': recipe.servings,
      'tags': recipe.tags,
      'created_at': recipe.createdAt.toIso8601String(),
      'updated_at': recipe.updatedAt.toIso8601String(),
    };
  }
  
  Future<void> _cacheRecipes(List<Recipe> recipes) async {
    // Кэшируем рецепты локально
    // Реализация зависит от структуры кэша
  }
  
  Future<List<Recipe>> _getCachedRecipes() async {
    // Получаем рецепты из кэша
    // Возвращаем пустой список если кэш пуст
    return [];
  }
  
  Future<void> _updateCacheAfterSave(Recipe recipe) async {
    // Обновляем кэш после сохранения
  }
  
  Future<void> _updateCacheAfterUpdate(Recipe recipe) async {
    // Обновляем кэш после обновления
  }
  
  Future<void> _removeFromCache(String recipeId) async {
    // Удаляем из кэша
  }
} 