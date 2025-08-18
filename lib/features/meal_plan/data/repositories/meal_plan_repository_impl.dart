import '../../domain/entities/meal_plan.dart';
import '../../domain/repositories/meal_plan_repository.dart';
import '../../../onboarding/data/services/supabase_service.dart';

/// Реализация репозитория для работы с планами питания
class MealPlanRepositoryImpl implements MealPlanRepository {
  final SupabaseService _supabaseService;

  static const String _mealPlansTable = 'meal_plans';
  static const String _plannedMealsTable = 'planned_meals';

  MealPlanRepositoryImpl(
    this._supabaseService,
  );

  @override
  Future<List<MealPlan>> getAllMealPlans() async {
    try {
      final response = await _supabaseService.selectData(_mealPlansTable);
      return response.map(MealPlan.fromJson).toList();
    } catch (e) {
      throw Exception('Failed to get meal plans: $e');
    }
  }

  @override
  Future<MealPlan?> getActiveMealPlan() async {
    try {
      // Получаем планы и находим активный
      final allPlans = await getAllMealPlans();
      return allPlans.firstWhere(
        (plan) => plan.isActive,
        orElse: () => throw Exception('No active meal plan found'),
      );
    } catch (e) {
      return null; // Возвращаем null если активного плана нет
    }
  }

  @override
  Future<MealPlan?> getMealPlanById(String id) async {
    try {
      final response = await _supabaseService.selectData(
        _mealPlansTable,
        column: 'id',
        value: id,
      );

      if (response.isEmpty) return null;

      return MealPlan.fromJson(response.first);
    } catch (e) {
      throw Exception('Failed to get meal plan by id: $e');
    }
  }

  @override
  Future<MealPlan> createMealPlan(MealPlan mealPlan) async {
    try {
      final data = mealPlan.toJson();
      final response = await _supabaseService.insertData(_mealPlansTable, data);

      if (response.isEmpty) {
        throw Exception('Failed to create meal plan');
      }

      return MealPlan.fromJson(response.first);
    } catch (e) {
      throw Exception('Failed to create meal plan: $e');
    }
  }

  @override
  Future<MealPlan> updateMealPlan(MealPlan mealPlan) async {
    try {
      final data = mealPlan.toJson();
      final response = await _supabaseService.updateData(
        _mealPlansTable,
        data,
        'id',
        mealPlan.id,
      );

      if (response.isEmpty) {
        throw Exception('Failed to update meal plan');
      }

      return MealPlan.fromJson(response.first);
    } catch (e) {
      throw Exception('Failed to update meal plan: $e');
    }
  }

  @override
  Future<bool> deleteMealPlan(String id) async {
    try {
      final response = await _supabaseService.deleteData(
        _mealPlansTable,
        'id',
        id,
      );

      return response.isNotEmpty;
    } catch (e) {
      throw Exception('Failed to delete meal plan: $e');
    }
  }

  @override
  Future<List<PlannedMeal>> getPlannedMealsForDate(DateTime date) async {
    try {
      // Заглушка - в реальности будет запрос к базе с фильтрацией по дате
      return [];
    } catch (e) {
      throw Exception('Failed to get planned meals for date: $e');
    }
  }

  @override
  Future<List<PlannedMeal>> getPlannedMealsForDateRange(
      DateTime startDate, DateTime endDate) async {
    try {
      // Заглушка - в реальности будет запрос к базе с фильтрацией по периоду
      return [];
    } catch (e) {
      throw Exception('Failed to get planned meals for date range: $e');
    }
  }

  @override
  Future<PlannedMeal> createPlannedMeal(PlannedMeal plannedMeal) async {
    try {
      final data = plannedMeal.toJson();
      final response =
          await _supabaseService.insertData(_plannedMealsTable, data);

      if (response.isEmpty) {
        throw Exception('Failed to create planned meal');
      }

      return PlannedMeal.fromJson(response.first);
    } catch (e) {
      throw Exception('Failed to create planned meal: $e');
    }
  }

  @override
  Future<PlannedMeal> updatePlannedMeal(PlannedMeal plannedMeal) async {
    try {
      final data = plannedMeal.toJson();
      final response = await _supabaseService.updateData(
        _plannedMealsTable,
        data,
        'id',
        plannedMeal.id,
      );

      if (response.isEmpty) {
        throw Exception('Failed to update planned meal');
      }

      return PlannedMeal.fromJson(response.first);
    } catch (e) {
      throw Exception('Failed to update planned meal: $e');
    }
  }

  @override
  Future<bool> deletePlannedMeal(String id) async {
    try {
      final response = await _supabaseService.deleteData(
        _plannedMealsTable,
        'id',
        id,
      );

      return response.isNotEmpty;
    } catch (e) {
      throw Exception('Failed to delete planned meal: $e');
    }
  }

  @override
  Future<PlannedMeal> markMealAsCompleted(String id, bool isCompleted) async {
    try {
      final response = await _supabaseService.updateData(
        _plannedMealsTable,
        {
          'is_completed': isCompleted,
          'updated_at': DateTime.now().toIso8601String(),
        },
        'id',
        id,
      );

      if (response.isEmpty) {
        throw Exception('Failed to mark meal as completed');
      }

      return PlannedMeal.fromJson(response.first);
    } catch (e) {
      throw Exception('Failed to mark meal as completed: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getMealPlanStatistics(String mealPlanId) async {
    try {
      // Заглушка для статистики
      return {
        'total_meals': 0,
        'completed_meals': 0,
        'completion_percentage': 0.0,
      };
    } catch (e) {
      throw Exception('Failed to get meal plan statistics: $e');
    }
  }
}
