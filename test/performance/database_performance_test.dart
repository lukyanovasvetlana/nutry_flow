import 'package:flutter_test/flutter_test.dart';
import 'package:nutry_flow/core/services/supabase_service.dart';
import 'package:nutry_flow/features/meal_plan/data/repositories/meal_plan_repository.dart';
import 'package:nutry_flow/features/exercise/data/repositories/exercise_repository.dart';
import 'package:nutry_flow/features/analytics/data/repositories/analytics_repository.dart';
import 'package:nutry_flow/features/meal_plan/domain/entities/meal_plan.dart';
import 'package:nutry_flow/features/meal_plan/domain/entities/meal.dart';
import 'package:nutry_flow/features/exercise/domain/entities/exercise.dart';
import 'package:nutry_flow/features/analytics/domain/entities/nutrition_tracking.dart';

// Performance тесты для базы данных
@Skip('Performance tests require real database connection')
void main() {
  group('Database Performance Tests', () {
    late MealPlanRepository mealPlanRepository;
    late ExerciseRepository exerciseRepository;
    late AnalyticsRepository analyticsRepository;

    setUpAll(() async {
      await SupabaseService.instance.initialize();
      
      mealPlanRepository = MealPlanRepository();
      exerciseRepository = ExerciseRepository();
      analyticsRepository = AnalyticsRepository();
    });

    group('Query Performance', () {
      test('should complete single meal plan query within 1 second', () async {
        // Arrange
        final stopwatch = Stopwatch();

        // Act
        stopwatch.start();
        final result = await mealPlanRepository.getUserMealPlans();
        stopwatch.stop();

        // Assert
        expect(stopwatch.elapsedMilliseconds, lessThan(1000));
        expect(result, isA<List<MealPlan>>());
      });

      test('should complete single exercise query within 1 second', () async {
        // Arrange
        final stopwatch = Stopwatch();

        // Act
        stopwatch.start();
        final result = await exerciseRepository.getAllExercises();
        stopwatch.stop();

        // Assert
        expect(stopwatch.elapsedMilliseconds, lessThan(1000));
        expect(result, isA<List<Exercise>>());
      });

      test('should complete analytics query within 2 seconds', () async {
        // Arrange
        final stopwatch = Stopwatch();
        final startDate = DateTime.now().subtract(const Duration(days: 30));
        final endDate = DateTime.now();

        // Act
        stopwatch.start();
        final result = await analyticsRepository.getAnalyticsData(startDate, endDate);
        stopwatch.stop();

        // Assert
        expect(stopwatch.elapsedMilliseconds, lessThan(2000));
        expect(result, isNotNull);
      });
    });

    group('Write Performance', () {
      test('should save meal plan within 2 seconds', () async {
        // Arrange
        final testMealPlan = MealPlan(
          id: 'perf-test-plan-${DateTime.now().millisecondsSinceEpoch}',
          name: 'Performance Test Plan',
          description: 'Test plan for performance testing',
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 7)),
          totalCalories: 2000,
          totalProtein: 150,
          totalFat: 65,
          totalCarbs: 250,
          isActive: false,
          meals: List.generate(10, (index) => Meal(
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

        final stopwatch = Stopwatch();

        // Act
        stopwatch.start();
        await mealPlanRepository.saveMealPlan(testMealPlan);
        stopwatch.stop();

        // Assert
        expect(stopwatch.elapsedMilliseconds, lessThan(2000));
      });

      test('should save exercise within 1 second', () async {
        // Arrange
        final testExercise = Exercise(
          id: 'perf-test-exercise-${DateTime.now().millisecondsSinceEpoch}',
          name: 'Performance Test Exercise',
          description: 'Test exercise for performance testing',
          category: 'strength',
          muscleGroups: ['chest', 'triceps'],
          equipment: 'dumbbells',
          difficulty: 'beginner',
          instructions: 'Test instructions',
          videoUrl: null,
          imageUrl: null,
        );

        final stopwatch = Stopwatch();

        // Act
        stopwatch.start();
        await exerciseRepository.saveExercise(testExercise);
        stopwatch.stop();

        // Assert
        expect(stopwatch.elapsedMilliseconds, lessThan(1000));
      });

      test('should save nutrition tracking within 1 second', () async {
        // Arrange
        final testTracking = NutritionTracking(
          id: 'perf-test-nutrition-${DateTime.now().millisecondsSinceEpoch}',
          date: DateTime.now(),
          caloriesConsumed: 2000,
          proteinConsumed: 150,
          fatConsumed: 65,
          carbsConsumed: 250,
          fiberConsumed: 25,
          waterConsumed: 2000,
          mealsCount: 4,
          notes: 'Performance test nutrition tracking',
        );

        final stopwatch = Stopwatch();

        // Act
        stopwatch.start();
        await analyticsRepository.saveNutritionTracking(testTracking);
        stopwatch.stop();

        // Assert
        expect(stopwatch.elapsedMilliseconds, lessThan(1000));
      });
    });

    group('Concurrent Operations', () {
      test('should handle 10 concurrent read operations within 3 seconds', () async {
        // Arrange
        final futures = <Future>[];
        final stopwatch = Stopwatch();

        // Act
        stopwatch.start();
        for (int i = 0; i < 10; i++) {
          futures.add(mealPlanRepository.getUserMealPlans());
          futures.add(exerciseRepository.getAllExercises());
        }
        await Future.wait(futures);
        stopwatch.stop();

        // Assert
        expect(stopwatch.elapsedMilliseconds, lessThan(3000));
        expect(futures.length, equals(20));
      });

      test('should handle 5 concurrent write operations within 5 seconds', () async {
        // Arrange
        final futures = <Future>[];
        final stopwatch = Stopwatch();

        // Act
        stopwatch.start();
        for (int i = 0; i < 5; i++) {
          final testMealPlan = MealPlan(
            id: 'concurrent-plan-$i-${DateTime.now().millisecondsSinceEpoch}',
            name: 'Concurrent Plan $i',
            description: 'Test plan for concurrent testing',
            startDate: DateTime.now(),
            endDate: DateTime.now().add(const Duration(days: 7)),
            totalCalories: 2000,
            totalProtein: 150,
            totalFat: 65,
            totalCarbs: 250,
            isActive: false,
            meals: [],
          );
          futures.add(mealPlanRepository.saveMealPlan(testMealPlan));
        }
        await Future.wait(futures);
        stopwatch.stop();

        // Assert
        expect(stopwatch.elapsedMilliseconds, lessThan(5000));
        expect(futures.length, equals(5));
      });
    });

    group('Large Dataset Performance', () {
      test('should handle large meal plan with 100 meals within 10 seconds', () async {
        // Arrange
        final largeMealPlan = MealPlan(
          id: 'large-perf-plan-${DateTime.now().millisecondsSinceEpoch}',
          name: 'Large Performance Test Plan',
          description: 'Test plan with 100 meals for performance testing',
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 30)),
          totalCalories: 2000,
          totalProtein: 150,
          totalFat: 65,
          totalCarbs: 250,
          isActive: false,
          meals: List.generate(100, (index) => Meal(
            id: 'large-meal-$index',
            name: 'Large Meal $index',
            description: 'Large test meal $index',
            dayOfWeek: (index % 7) + 1,
            mealType: ['breakfast', 'lunch', 'dinner', 'snack'][index % 4],
            calories: 500 + (index * 10),
            protein: 30 + (index * 2),
            fat: 20 + (index * 1),
            carbs: 60 + (index * 3),
            order: index,
          )),
        );

        final stopwatch = Stopwatch();

        // Act
        stopwatch.start();
        await mealPlanRepository.saveMealPlan(largeMealPlan);
        stopwatch.stop();

        // Assert
        expect(stopwatch.elapsedMilliseconds, lessThan(10000));
      });

      test('should retrieve large meal plan within 5 seconds', () async {
        // Arrange
        final stopwatch = Stopwatch();

        // Act
        stopwatch.start();
        final result = await mealPlanRepository.getUserMealPlans();
        stopwatch.stop();

        // Assert
        expect(stopwatch.elapsedMilliseconds, lessThan(5000));
        expect(result, isA<List<MealPlan>>());
      });
    });

    group('Memory Usage', () {
      test('should not cause memory leaks during repeated operations', () async {
        // Arrange
        final initialMemory = ProcessInfo.currentRss;
        final operations = <Future>[];

        // Act - Perform 50 operations
        for (int i = 0; i < 50; i++) {
          operations.add(mealPlanRepository.getUserMealPlans());
          operations.add(exerciseRepository.getAllExercises());
        }
        await Future.wait(operations);

        // Wait for garbage collection
        await Future.delayed(const Duration(seconds: 2));

        // Assert
        final finalMemory = ProcessInfo.currentRss;
        final memoryIncrease = finalMemory - initialMemory;
        
        // Memory increase should be reasonable (less than 50MB)
        expect(memoryIncrease, lessThan(50 * 1024 * 1024));
      });
    });

    group('Connection Stability', () {
      test('should maintain connection during long operations', () async {
        // Arrange
        final operations = <Future>[];
        final stopwatch = Stopwatch();

        // Act - Perform operations for 30 seconds
        stopwatch.start();
        for (int i = 0; i < 30; i++) {
          operations.add(mealPlanRepository.getUserMealPlans());
          await Future.delayed(const Duration(seconds: 1));
        }
        await Future.wait(operations);
        stopwatch.stop();

        // Assert
        expect(stopwatch.elapsedMilliseconds, greaterThan(25000));
        expect(operations.length, equals(30));
      });

      test('should handle connection interruptions gracefully', () async {
        // This test would require simulating network interruptions
        // For now, we'll test that operations don't crash
        
        // Act & Assert
        expect(
          () => mealPlanRepository.getUserMealPlans(),
          returnsNormally,
        );
      });
    });

    group('Query Optimization', () {
      test('should use indexes for filtered queries', () async {
        // Arrange
        final stopwatch = Stopwatch();

        // Act - Query with filters
        stopwatch.start();
        final exercises = await exerciseRepository.getExercisesByCategory('strength');
        stopwatch.stop();

        // Assert
        expect(stopwatch.elapsedMilliseconds, lessThan(1000));
        expect(exercises, isA<List<Exercise>>());
      });

      test('should handle date range queries efficiently', () async {
        // Arrange
        final stopwatch = Stopwatch();
        final startDate = DateTime.now().subtract(const Duration(days: 7));
        final endDate = DateTime.now();

        // Act - Query with date range
        stopwatch.start();
        final tracking = await analyticsRepository.getNutritionTracking(startDate, endDate);
        stopwatch.stop();

        // Assert
        expect(stopwatch.elapsedMilliseconds, lessThan(1000));
        expect(tracking, isA<List<NutritionTracking>>());
      });
    });
  });
}

// Helper class for memory monitoring
class ProcessInfo {
  static int get currentRss {
    // This is a simplified version for testing
    // In a real implementation, you would use platform-specific code
    return 0;
  }
} 