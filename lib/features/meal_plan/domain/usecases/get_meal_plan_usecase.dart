import '../entities/meal_plan.dart';
import '../repositories/meal_plan_repository.dart';
import '../../../onboarding/domain/repositories/auth_repository.dart';

/// Результат получения плана питания
class GetMealPlanResult {
  final MealPlan? mealPlan;
  final List<PlannedMeal> plannedMeals;
  final String? error;
  final bool isSuccess;

  const GetMealPlanResult.success(this.mealPlan, this.plannedMeals)
      : error = null,
        isSuccess = true;

  const GetMealPlanResult.failure(this.error)
      : mealPlan = null,
        plannedMeals = const [],
        isSuccess = false;
}

/// Use case для получения плана питания
class GetMealPlanUseCase {
  final MealPlanRepository _repository;
  final AuthRepository _authRepository;

  const GetMealPlanUseCase(
    this._repository,
    this._authRepository,
  );

  /// Получает активный план питания пользователя
  Future<GetMealPlanResult> execute({
    DateTime? startDate,
    DateTime? endDate,
    bool? onlyActive,
  }) async {
    try {
      // Проверяем аутентификацию
      final currentUser = await _authRepository.getCurrentUser();
      if (currentUser == null) {
        return const GetMealPlanResult.failure(
            'Пользователь не аутентифицирован');
      }

      MealPlan? mealPlan;
      List<PlannedMeal> plannedMeals = [];

      if (onlyActive == true) {
        // Получаем активный план
        mealPlan = await _repository.getActiveMealPlan();
        if (mealPlan != null) {
          plannedMeals = mealPlan.meals;
        }
      } else if (startDate != null && endDate != null) {
        // Получаем запланированные приемы пищи за период
        plannedMeals =
            await _repository.getPlannedMealsForDateRange(startDate, endDate);
      } else if (startDate != null) {
        // Получаем запланированные приемы пищи на дату
        plannedMeals = await _repository.getPlannedMealsForDate(startDate);
      } else {
        // Получаем активный план по умолчанию
        mealPlan = await _repository.getActiveMealPlan();
        if (mealPlan != null) {
          plannedMeals = mealPlan.meals;
        }
      }

      return GetMealPlanResult.success(mealPlan, plannedMeals);
    } catch (e) {
      return GetMealPlanResult.failure(
          'Ошибка при получении плана питания: ${e.toString()}');
    }
  }
}
