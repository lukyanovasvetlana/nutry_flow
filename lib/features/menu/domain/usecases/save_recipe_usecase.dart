import '../entities/recipe.dart';
import '../repositories/recipe_repository.dart';

/// Результат сохранения рецепта
class SaveRecipeResult {
  final Recipe? recipe;
  final String? error;
  final bool isSuccess;
  
  const SaveRecipeResult.success(this.recipe) 
      : error = null, isSuccess = true;
  
  const SaveRecipeResult.failure(this.error) 
      : recipe = null, isSuccess = false;
}

/// Use case для сохранения рецепта
class SaveRecipeUseCase {
  final RecipeRepository _repository;
  
  const SaveRecipeUseCase(this._repository);
  
  /// Сохраняет рецепт с валидацией
  Future<SaveRecipeResult> execute(Recipe recipe) async {
    try {
      // Валидация рецепта
      final validationError = _validateRecipe(recipe);
      if (validationError != null) {
        return SaveRecipeResult.failure(validationError);
      }
      
      // Сохранение рецепта
      final savedRecipe = await _repository.saveRecipe(recipe);
      
      return SaveRecipeResult.success(savedRecipe);
      
    } catch (e) {
      return SaveRecipeResult.failure(
        'Ошибка при сохранении рецепта: ${e.toString()}'
      );
    }
  }
  
  /// Валидация рецепта
  String? _validateRecipe(Recipe recipe) {
    if (recipe.title.isEmpty) {
      return 'Название рецепта не может быть пустым';
    }
    
    if (recipe.title.length < 3) {
      return 'Название рецепта должно содержать минимум 3 символа';
    }
    
    if (recipe.ingredients.isEmpty) {
      return 'Рецепт должен содержать хотя бы один ингредиент';
    }
    
    if (recipe.steps.isEmpty) {
      return 'Рецепт должен содержать хотя бы один шаг приготовления';
    }
    
    // Проверка времени приготовления
    if (recipe.cookingTime <= 0) {
      return 'Время приготовления должно быть больше 0';
    }
    
    if (recipe.cookingTime > 1440) { // 24 часа в минутах
      return 'Время приготовления не может превышать 24 часа';
    }
    
    return null;
  }
} 