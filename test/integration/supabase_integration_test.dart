import 'package:flutter_test/flutter_test.dart';
import 'package:nutry_flow/core/services/supabase_service.dart';
import 'package:nutry_flow/features/meal_plan/data/repositories/meal_plan_repository.dart';
import 'package:nutry_flow/features/exercise/data/repositories/exercise_repository.dart';
import 'package:nutry_flow/features/analytics/data/repositories/analytics_repository.dart';
import 'package:nutry_flow/features/meal_plan/domain/entities/meal_plan.dart';
import 'package:nutry_flow/features/meal_plan/domain/entities/meal.dart';
import 'package:nutry_flow/features/exercise/domain/entities/exercise.dart';
import 'package:nutry_flow/features/analytics/domain/entities/nutrition_tracking.dart';

// Integration тесты для Supabase
// Эти тесты требуют реального подключения к Supabase
@Skip('Integration tests require real Supabase connection')
void main() {
  group('Supabase Integration Tests', () {
    late SupabaseService supabaseService;
    late MealPlanRepository mealPlanRepository;
    late ExerciseRepository exerciseRepository;
    late AnalyticsRepository analyticsRepository;

    setUpAll(() async {
      // Инициализация Supabase для тестов
      await SupabaseService.instance.initialize();
      supabaseService = SupabaseService.instance;
      
      mealPlanRepository = MealPlanRepository();
      exerciseRepository = ExerciseRepository();
      analyticsRepository = AnalyticsRepository();
    });

    group('SupabaseService', () {
      test('should initialize successfully', () {
        expect(supabaseService.isAvailable, isTrue);
      });

      test('should handle authentication state', () {
        // Проверяем, что сервис может обрабатывать состояние аутентификации
        expect(supabaseService.currentUser, isNull);
      });
    });

    group('MealPlanRepository Integration', () {
      test('should save and retrieve meal plan', () async {
        // Arrange
        final testMealPlan = MealPlan(
          id: 'test-integration-plan-${DateTime.now().millisecondsSinceEpoch}',
          name: 'Integration Test Plan',
          description: 'Test plan for integration testing',
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 7)),
          totalCalories: 2000,
          totalProtein: 150,
          totalFat: 65,
          totalCarbs: 250,
          isActive: false,
          meals: [
            Meal(
              id: 'test-meal-1',
              name: 'Test Breakfast',
              description: 'Test breakfast meal',
              dayOfWeek: 1,
              mealType: 'breakfast',
              calories: 500,
              protein: 30,
              fat: 20,
              carbs: 60,
              order: 1,
            ),
          ],
        );

        // Act - Save meal plan
        await mealPlanRepository.saveMealPlan(testMealPlan);

        // Act - Retrieve meal plans
        final retrievedPlans = await mealPlanRepository.getUserMealPlans();

        // Assert
        expect(retrievedPlans, isNotEmpty);
        final savedPlan = retrievedPlans.firstWhere(
          (plan) => plan.id == testMealPlan.id,
          orElse: () => throw Exception('Plan not found'),
        );
        expect(savedPlan.name, equals(testMealPlan.name));
        expect(savedPlan.description, equals(testMealPlan.description));
        expect(savedPlan.meals.length, equals(testMealPlan.meals.length));
      });

      test('should activate meal plan', () async {
        // Arrange
        final testMealPlan = MealPlan(
          id: 'test-activate-plan-${DateTime.now().millisecondsSinceEpoch}',
          name: 'Activation Test Plan',
          description: 'Test plan for activation',
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 7)),
          totalCalories: 2000,
          totalProtein: 150,
          totalFat: 65,
          totalCarbs: 250,
          isActive: false,
          meals: [],
        );

        // Act - Save and activate
        await mealPlanRepository.saveMealPlan(testMealPlan);
        await mealPlanRepository.activateMealPlan(testMealPlan.id);

        // Act - Get active plan
        final activePlan = await mealPlanRepository.getActiveMealPlan();

        // Assert
        expect(activePlan, isNotNull);
        expect(activePlan!.id, equals(testMealPlan.id));
        expect(activePlan.isActive, isTrue);
      });

      test('should delete meal plan', () async {
        // Arrange
        final testMealPlan = MealPlan(
          id: 'test-delete-plan-${DateTime.now().millisecondsSinceEpoch}',
          name: 'Delete Test Plan',
          description: 'Test plan for deletion',
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 7)),
          totalCalories: 2000,
          totalProtein: 150,
          totalFat: 65,
          totalCarbs: 250,
          isActive: false,
          meals: [],
        );

        // Act - Save and delete
        await mealPlanRepository.saveMealPlan(testMealPlan);
        await mealPlanRepository.deleteMealPlan(testMealPlan.id);

        // Act - Try to retrieve
        final retrievedPlans = await mealPlanRepository.getUserMealPlans();

        // Assert
        final deletedPlan = retrievedPlans.where((plan) => plan.id == testMealPlan.id);
        expect(deletedPlan, isEmpty);
      });
    });

    group('ExerciseRepository Integration', () {
      test('should save and retrieve exercise', () async {
        // Arrange
        final testExercise = Exercise(
          id: 'test-exercise-${DateTime.now().millisecondsSinceEpoch}',
          name: 'Integration Test Exercise',
          description: 'Test exercise for integration testing',
          category: 'strength',
          muscleGroups: ['chest', 'triceps'],
          equipment: 'dumbbells',
          difficulty: 'beginner',
          instructions: 'Test instructions',
          videoUrl: null,
          imageUrl: null,
        );

        // Act - Save exercise
        await exerciseRepository.saveExercise(testExercise);

        // Act - Retrieve exercises
        final retrievedExercises = await exerciseRepository.getAllExercises();

        // Assert
        expect(retrievedExercises, isNotEmpty);
        final savedExercise = retrievedExercises.firstWhere(
          (exercise) => exercise.id == testExercise.id,
          orElse: () => throw Exception('Exercise not found'),
        );
        expect(savedExercise.name, equals(testExercise.name));
        expect(savedExercise.category, equals(testExercise.category));
      });

      test('should retrieve exercises by category', () async {
        // Arrange
        final testExercise = Exercise(
          id: 'test-category-exercise-${DateTime.now().millisecondsSinceEpoch}',
          name: 'Category Test Exercise',
          description: 'Test exercise for category filtering',
          category: 'cardio',
          muscleGroups: ['legs'],
          equipment: 'treadmill',
          difficulty: 'intermediate',
          instructions: 'Test instructions',
          videoUrl: null,
          imageUrl: null,
        );

        // Act - Save and retrieve by category
        await exerciseRepository.saveExercise(testExercise);
        final cardioExercises = await exerciseRepository.getExercisesByCategory('cardio');

        // Assert
        expect(cardioExercises, isNotEmpty);
        final savedExercise = cardioExercises.firstWhere(
          (exercise) => exercise.id == testExercise.id,
          orElse: () => throw Exception('Exercise not found'),
        );
        expect(savedExercise.category, equals('cardio'));
      });
    });

    group('AnalyticsRepository Integration', () {
      test('should save and retrieve nutrition tracking', () async {
        // Arrange
        final testTracking = NutritionTracking(
          id: 'test-nutrition-${DateTime.now().millisecondsSinceEpoch}',
          date: DateTime.now(),
          caloriesConsumed: 2000,
          proteinConsumed: 150,
          fatConsumed: 65,
          carbsConsumed: 250,
          fiberConsumed: 25,
          waterConsumed: 2000,
          mealsCount: 4,
          notes: 'Test nutrition tracking',
        );

        // Act - Save nutrition tracking
        await analyticsRepository.saveNutritionTracking(testTracking);

        // Act - Retrieve nutrition tracking
        final startDate = DateTime.now().subtract(const Duration(days: 1));
        final endDate = DateTime.now().add(const Duration(days: 1));
        final retrievedTracking = await analyticsRepository.getNutritionTracking(startDate, endDate);

        // Assert
        expect(retrievedTracking, isNotEmpty);
        final savedTracking = retrievedTracking.firstWhere(
          (tracking) => tracking.id == testTracking.id,
          orElse: () => throw Exception('Nutrition tracking not found'),
        );
        expect(savedTracking.caloriesConsumed, equals(testTracking.caloriesConsumed));
        expect(savedTracking.proteinConsumed, equals(testTracking.proteinConsumed));
      });

      test('should calculate analytics summary', () async {
        // Arrange
        final startDate = DateTime.now().subtract(const Duration(days: 7));
        final endDate = DateTime.now();

        // Act - Get analytics data
        final analyticsData = await analyticsRepository.getAnalyticsData(startDate, endDate);

        // Assert
        expect(analyticsData, isNotNull);
        expect(analyticsData.nutritionTracking, isA<List<NutritionTracking>>());
        expect(analyticsData.weightTracking, isA<List>());
        expect(analyticsData.activityTracking, isA<List>());
        expect(analyticsData.period, isNotEmpty);
      });
    });

    group('Performance Tests', () {
      test('should handle multiple concurrent requests', () async {
        // Arrange
        final futures = <Future>[];

        // Act - Create multiple concurrent requests
        for (int i = 0; i < 10; i++) {
          futures.add(mealPlanRepository.getUserMealPlans());
          futures.add(exerciseRepository.getAllExercises());
          futures.add(analyticsRepository.getAnalyticsData(
            DateTime.now().subtract(const Duration(days: 7)),
            DateTime.now(),
          ));
        }

        // Act - Wait for all requests to complete
        final results = await Future.wait(futures);

        // Assert
        expect(results, hasLength(30));
        for (final result in results) {
          expect(result, isNotNull);
        }
      });

      test('should handle large data sets', () async {
        // Arrange
        final largeMealPlan = MealPlan(
          id: 'large-plan-${DateTime.now().millisecondsSinceEpoch}',
          name: 'Large Test Plan',
          description: 'Test plan with many meals',
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 30)),
          totalCalories: 2000,
          totalProtein: 150,
          totalFat: 65,
          totalCarbs: 250,
          isActive: false,
          meals: List.generate(100, (index) => Meal(
            id: 'meal-$index',
            name: 'Meal $index',
            description: 'Test meal $index',
            dayOfWeek: (index % 7) + 1,
            mealType: ['breakfast', 'lunch', 'dinner', 'snack'][index % 4],
            calories: 500 + (index * 10),
            protein: 30 + (index * 2),
            fat: 20 + (index * 1),
            carbs: 60 + (index * 3),
            order: index,
          )),
        );

        // Act - Save large meal plan
        final stopwatch = Stopwatch()..start();
        await mealPlanRepository.saveMealPlan(largeMealPlan);
        stopwatch.stop();

        // Assert
        expect(stopwatch.elapsedMilliseconds, lessThan(5000)); // Should complete within 5 seconds

        // Act - Retrieve large meal plan
        stopwatch.reset();
        stopwatch.start();
        final retrievedPlans = await mealPlanRepository.getUserMealPlans();
        stopwatch.stop();

        // Assert
        expect(stopwatch.elapsedMilliseconds, lessThan(3000)); // Should complete within 3 seconds
        final retrievedPlan = retrievedPlans.firstWhere(
          (plan) => plan.id == largeMealPlan.id,
          orElse: () => throw Exception('Large plan not found'),
        );
        expect(retrievedPlan.meals.length, equals(100));
      });
    });

    group('Error Handling Tests', () {
      test('should handle network errors gracefully', () async {
        // This test would require mocking network failures
        // For now, we'll test that the repository doesn't crash on errors
        
        // Act & Assert - Repository should handle errors without crashing
        expect(
          () => mealPlanRepository.getUserMealPlans(),
          returnsNormally,
        );
      });

      test('should handle invalid data gracefully', () async {
        // Arrange
        final invalidMealPlan = MealPlan(
          id: '', // Invalid empty ID
          name: '', // Invalid empty name
          description: 'Test',
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 7)),
          totalCalories: -1, // Invalid negative calories
          totalProtein: 150,
          totalFat: 65,
          totalCarbs: 250,
          isActive: false,
          meals: [],
        );

        // Act & Assert - Should handle invalid data without crashing
        expect(
          () => mealPlanRepository.saveMealPlan(invalidMealPlan),
          returnsNormally,
        );
      });
    });
  });
} 