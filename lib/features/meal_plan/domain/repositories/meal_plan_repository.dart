import '../entities/meal_plan.dart';

/// Интерфейс репозитория для работы с планами питания
abstract class MealPlanRepository {
  /// Получает все планы питания пользователя
  Future<List<MealPlan>> getAllMealPlans();
  
  /// Получает активный план питания
  Future<MealPlan?> getActiveMealPlan();
  
  /// Получает план питания по ID
  Future<MealPlan?> getMealPlanById(String id);
  
  /// Создает новый план питания
  Future<MealPlan> createMealPlan(MealPlan mealPlan);
  
  /// Обновляет план питания
  Future<MealPlan> updateMealPlan(MealPlan mealPlan);
  
  /// Удаляет план питания
  Future<bool> deleteMealPlan(String id);
  
  /// Получает запланированные приемы пищи для даты
  Future<List<PlannedMeal>> getPlannedMealsForDate(DateTime date);
  
  /// Получает запланированные приемы пищи за период
  Future<List<PlannedMeal>> getPlannedMealsForDateRange(DateTime startDate, DateTime endDate);
  
  /// Создает запланированный прием пищи
  Future<PlannedMeal> createPlannedMeal(PlannedMeal plannedMeal);
  
  /// Обновляет запланированный прием пищи
  Future<PlannedMeal> updatePlannedMeal(PlannedMeal plannedMeal);
  
  /// Удаляет запланированный прием пищи
  Future<bool> deletePlannedMeal(String id);
  
  /// Отмечает прием пищи как выполненный
  Future<PlannedMeal> markMealAsCompleted(String id, bool isCompleted);
  
  /// Получает статистику по плану питания
  Future<Map<String, dynamic>> getMealPlanStatistics(String mealPlanId);
} 