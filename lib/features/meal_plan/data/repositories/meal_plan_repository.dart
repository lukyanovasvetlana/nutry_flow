import 'package:nutry_flow/core/services/supabase_service.dart';
import 'package:nutry_flow/features/meal_plan/domain/entities/meal_plan.dart';
import 'dart:developer' as developer;

class MealPlanRepository {
  final SupabaseService _supabaseService = SupabaseService.instance;

  /// Сохранение плана питания
  Future<void> saveMealPlan(MealPlan mealPlan) async {
    try {
      if (_supabaseService.isAvailable) {
        developer.log('🍽️ MealPlanRepository: Saving meal plan via Supabase',
            name: 'MealPlanRepository');

        final user = _supabaseService.currentUser;
        if (user == null) {
          throw Exception('User not authenticated');
        }

        await _supabaseService.saveUserData('meal_plans', {
          'user_id': user.id,
          'id': mealPlan.id,
          'name': mealPlan.name,
          'description': mealPlan.description,
          'start_date': mealPlan.startDate.toIso8601String(),
          'end_date': mealPlan.endDate.toIso8601String(),
          'is_active': true,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        });

        // Сохраняем блюда плана
        for (final meal in mealPlan.meals) {
          await _supabaseService.saveUserData('meal_plan_meals', {
            'meal_plan_id': mealPlan.id,
            'meal_id': meal.id,
            'date': meal.date.toIso8601String(),
            'meal_type': meal.mealType.name,
            'created_at': DateTime.now().toIso8601String(),
          });
        }

        developer.log('🍽️ MealPlanRepository: Meal plan saved successfully',
            name: 'MealPlanRepository');
      } else {
        developer.log(
            '🍽️ MealPlanRepository: Supabase not available, using mock',
            name: 'MealPlanRepository');
        await _saveMealPlanLocally(mealPlan);
      }
    } catch (e) {
      developer.log('🍽️ MealPlanRepository: Save meal plan failed: $e',
          name: 'MealPlanRepository');
      rethrow;
    }
  }

  /// Получение планов питания пользователя
  Future<List<MealPlan>> getUserMealPlans() async {
    try {
      if (_supabaseService.isAvailable) {
        developer.log('🍽️ MealPlanRepository: Getting meal plans via Supabase',
            name: 'MealPlanRepository');

        final user = _supabaseService.currentUser;
        if (user == null) {
          developer.log('🍽️ MealPlanRepository: User not authenticated',
              name: 'MealPlanRepository');
          return [];
        }

        final plansData =
            await _supabaseService.getUserData('meal_plans', userId: user.id);

        final List<MealPlan> mealPlans = [];

        for (final planData in plansData) {
          // Получаем блюда для этого плана
          final mealsData = await _supabaseService
              .getUserData('meal_plan_meals', userId: user.id);
          final planMeals = mealsData
              .where((meal) => meal['meal_plan_id'] == planData['id'])
              .toList();

          final meals = planMeals
              .map((mealData) => PlannedMeal(
                    id: mealData['meal_id'],
                    userId: planData['user_id'] ?? '',
                    date: DateTime.parse(
                        mealData['date'] ?? planData['start_date']),
                    mealType: MealType.values.firstWhere(
                      (e) => e.name == (mealData['meal_type'] ?? 'breakfast'),
                      orElse: () => MealType.breakfast,
                    ),
                    createdAt: DateTime.parse(
                        mealData['created_at'] ?? planData['start_date']),
                    updatedAt: DateTime.parse(
                        mealData['updated_at'] ?? planData['start_date']),
                  ))
              .toList();

          final mealPlan = MealPlan(
            id: planData['id'],
            userId: planData['user_id'] ?? '',
            startDate: DateTime.parse(planData['start_date']),
            endDate: DateTime.parse(planData['end_date']),
            name: planData['name'] ?? 'План питания',
            description: planData['description'] ?? '',
            meals: meals,
            createdAt: DateTime.parse(
                planData['created_at'] ?? planData['start_date']),
            updatedAt: DateTime.parse(
                planData['updated_at'] ?? planData['start_date']),
          );

          mealPlans.add(mealPlan);
        }

        developer.log(
            '🍽️ MealPlanRepository: Meal plans retrieved successfully',
            name: 'MealPlanRepository');
        return mealPlans;
      } else {
        developer.log(
            '🍽️ MealPlanRepository: Supabase not available, using mock',
            name: 'MealPlanRepository');
        return await _getMealPlansLocally();
      }
    } catch (e) {
      developer.log('🍽️ MealPlanRepository: Get meal plans failed: $e',
          name: 'MealPlanRepository');
      rethrow;
    }
  }

  /// Получение активного плана питания
  Future<MealPlan?> getActiveMealPlan() async {
    try {
      final mealPlans = await getUserMealPlans();
      return mealPlans.where((plan) => plan.isActive).firstOrNull;
    } catch (e) {
      developer.log('🍽️ MealPlanRepository: Get active meal plan failed: $e',
          name: 'MealPlanRepository');
      rethrow;
    }
  }

  /// Активация плана питания
  Future<void> activateMealPlan(String mealPlanId) async {
    try {
      if (_supabaseService.isAvailable) {
        developer.log(
            '🍽️ MealPlanRepository: Activating meal plan via Supabase',
            name: 'MealPlanRepository');

        final user = _supabaseService.currentUser;
        if (user == null) {
          throw Exception('User not authenticated');
        }

        // Деактивируем все планы
        await _supabaseService.saveUserData('meal_plans', {
          'user_id': user.id,
          'is_active': false,
          'updated_at': DateTime.now().toIso8601String(),
        });

        // Активируем выбранный план
        await _supabaseService.saveUserData('meal_plans', {
          'user_id': user.id,
          'id': mealPlanId,
          'is_active': true,
          'updated_at': DateTime.now().toIso8601String(),
        });

        developer.log(
            '🍽️ MealPlanRepository: Meal plan activated successfully',
            name: 'MealPlanRepository');
      } else {
        developer.log(
            '🍽️ MealPlanRepository: Supabase not available, using mock',
            name: 'MealPlanRepository');
        await _activateMealPlanLocally(mealPlanId);
      }
    } catch (e) {
      developer.log('🍽️ MealPlanRepository: Activate meal plan failed: $e',
          name: 'MealPlanRepository');
      rethrow;
    }
  }

  /// Удаление плана питания
  Future<void> deleteMealPlan(String mealPlanId) async {
    try {
      if (_supabaseService.isAvailable) {
        developer.log('🍽️ MealPlanRepository: Deleting meal plan via Supabase',
            name: 'MealPlanRepository');

        // Удаляем блюда плана
        await _supabaseService.deleteUserData('meal_plan_meals', mealPlanId);

        // Удаляем сам план
        await _supabaseService.deleteUserData('meal_plans', mealPlanId);

        developer.log('🍽️ MealPlanRepository: Meal plan deleted successfully',
            name: 'MealPlanRepository');
      } else {
        developer.log(
            '🍽️ MealPlanRepository: Supabase not available, using mock',
            name: 'MealPlanRepository');
        await _deleteMealPlanLocally(mealPlanId);
      }
    } catch (e) {
      developer.log('🍽️ MealPlanRepository: Delete meal plan failed: $e',
          name: 'MealPlanRepository');
      rethrow;
    }
  }

  // Mock методы для fallback
  Future<void> _saveMealPlanLocally(MealPlan mealPlan) async {
    // TODO: Реализовать локальное сохранение через SharedPreferences
    developer.log('🍽️ MealPlanRepository: Mock save meal plan',
        name: 'MealPlanRepository');
  }

  Future<List<MealPlan>> _getMealPlansLocally() async {
    // TODO: Реализовать локальное получение через SharedPreferences
    developer.log('🍽️ MealPlanRepository: Mock get meal plans',
        name: 'MealPlanRepository');
    return [];
  }

  Future<void> _activateMealPlanLocally(String mealPlanId) async {
    // TODO: Реализовать локальную активацию через SharedPreferences
    developer.log('🍽️ MealPlanRepository: Mock activate meal plan',
        name: 'MealPlanRepository');
  }

  Future<void> _deleteMealPlanLocally(String mealPlanId) async {
    // TODO: Реализовать локальное удаление через SharedPreferences
    developer.log('🍽️ MealPlanRepository: Mock delete meal plan',
        name: 'MealPlanRepository');
  }
}
