import '../entities/recipe.dart';

/// Интерфейс репозитория для работы с рецептами
abstract class RecipeRepository {
  /// Получает все рецепты пользователя
  Future<List<Recipe>> getAllRecipes();

  /// Получает рецепт по ID
  Future<Recipe?> getRecipeById(String id);

  /// Сохраняет новый рецепт
  Future<Recipe> saveRecipe(Recipe recipe);

  /// Обновляет существующий рецепт
  Future<Recipe> updateRecipe(Recipe recipe);

  /// Удаляет рецепт
  Future<bool> deleteRecipe(String id);

  /// Ищет рецепты по названию или ингредиентам
  Future<List<Recipe>> searchRecipes(String query);

  /// Получает рецепты по категории
  Future<List<Recipe>> getRecipesByCategory(String category);

  /// Получает избранные рецепты
  Future<List<Recipe>> getFavoriteRecipes();

  /// Добавляет/удаляет рецепт из избранного
  Future<bool> toggleFavorite(String recipeId, bool isFavorite);
}
