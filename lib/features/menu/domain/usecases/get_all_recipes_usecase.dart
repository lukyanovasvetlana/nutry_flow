import '../entities/recipe.dart';
import '../repositories/recipe_repository.dart';

/// Результат получения рецептов
class GetAllRecipesResult {
  final List<Recipe> recipes;
  final String? error;
  final bool isSuccess;
  
  const GetAllRecipesResult.success(this.recipes) 
      : error = null, isSuccess = true;
  
  const GetAllRecipesResult.failure(this.error) 
      : recipes = const [], isSuccess = false;
}

/// Use case для получения всех рецептов
class GetAllRecipesUseCase {
  final RecipeRepository _repository;
  
  const GetAllRecipesUseCase(this._repository);
  
  /// Получает все рецепты с сортировкой и фильтрацией
  Future<GetAllRecipesResult> execute({
    String? searchQuery,
    String? category,
    bool? onlyFavorites,
  }) async {
    try {
      List<Recipe> recipes;
      
      if (onlyFavorites == true) {
        recipes = await _repository.getFavoriteRecipes();
      } else if (searchQuery != null && searchQuery.isNotEmpty) {
        recipes = await _repository.searchRecipes(searchQuery);
      } else if (category != null && category.isNotEmpty) {
        recipes = await _repository.getRecipesByCategory(category);
      } else {
        recipes = await _repository.getAllRecipes();
      }
      
      return GetAllRecipesResult.success(recipes);
      
    } catch (e) {
      return GetAllRecipesResult.failure(
        'Ошибка при получении рецептов: ${e.toString()}'
      );
    }
  }
} 