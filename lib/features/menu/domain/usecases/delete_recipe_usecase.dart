import '../repositories/recipe_repository.dart';

/// Результат удаления рецепта
class DeleteRecipeResult {
  final String? error;
  final bool isSuccess;
  
  const DeleteRecipeResult.success() 
      : error = null, isSuccess = true;
  
  const DeleteRecipeResult.failure(this.error) 
      : isSuccess = false;
}

/// Use case для удаления рецепта
class DeleteRecipeUseCase {
  final RecipeRepository _repository;
  
  const DeleteRecipeUseCase(this._repository);
  
  /// Удаляет рецепт с подтверждением
  Future<DeleteRecipeResult> execute(String recipeId) async {
    try {
      if (recipeId.isEmpty) {
        return const DeleteRecipeResult.failure('ID рецепта не может быть пустым');
      }
      
      // Проверяем, существует ли рецепт
      final recipe = await _repository.getRecipeById(recipeId);
      if (recipe == null) {
        return const DeleteRecipeResult.failure('Рецепт не найден');
      }
      
      // Удаляем рецепт
      final success = await _repository.deleteRecipe(recipeId);
      
      if (success) {
        return const DeleteRecipeResult.success();
      } else {
        return const DeleteRecipeResult.failure('Не удалось удалить рецепт');
      }
      
    } catch (e) {
      return DeleteRecipeResult.failure(
        'Ошибка при удалении рецепта: ${e.toString()}'
      );
    }
  }
} 