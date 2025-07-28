import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:nutry_flow/core/services/supabase_service.dart';
import 'package:nutry_flow/features/meal_plan/data/repositories/meal_plan_repository.dart';
import 'package:nutry_flow/features/meal_plan/domain/entities/meal_plan.dart';
import 'package:nutry_flow/features/meal_plan/domain/entities/meal.dart';

import 'meal_plan_repository_test.mocks.dart';

@GenerateMocks([SupabaseService])
void main() {
  group('MealPlanRepository', () {
    late MealPlanRepository repository;
    late MockSupabaseService mockSupabaseService;

    setUp(() {
      mockSupabaseService = MockSupabaseService();
      repository = MealPlanRepository();
    });

    group('saveMealPlan', () {
      test('should save meal plan successfully when Supabase is available', () async {
        // Arrange
        final mealPlan = MealPlan(
          id: 'test-plan-1',
          name: 'Test Plan',
          description: 'Test Description',
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 7)),
          totalCalories: 2000,
          totalProtein: 150,
          totalFat: 65,
          totalCarbs: 250,
          isActive: true,
          meals: [
            Meal(
              id: 'meal-1',
              name: 'Breakfast',
              description: 'Morning meal',
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

        when(mockSupabaseService.isAvailable).thenReturn(true);
        when(mockSupabaseService.currentUser).thenReturn(
          User(id: 'user-1', email: 'test@example.com'),
        );
        when(mockSupabaseService.saveUserData(any, any)).thenAnswer((_) async {});

        // Act
        await repository.saveMealPlan(mealPlan);

        // Assert
        verify(mockSupabaseService.saveUserData('meal_plans', any)).called(1);
        verify(mockSupabaseService.saveUserData('meal_plan_meals', any)).called(1);
      });

      test('should throw exception when user is not authenticated', () async {
        // Arrange
        final mealPlan = MealPlan(
          id: 'test-plan-1',
          name: 'Test Plan',
          description: 'Test Description',
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 7)),
          totalCalories: 2000,
          totalProtein: 150,
          totalFat: 65,
          totalCarbs: 250,
          isActive: true,
          meals: [],
        );

        when(mockSupabaseService.isAvailable).thenReturn(true);
        when(mockSupabaseService.currentUser).thenReturn(null);

        // Act & Assert
        expect(
          () => repository.saveMealPlan(mealPlan),
          throwsA(isA<Exception>()),
        );
      });

      test('should use mock when Supabase is not available', () async {
        // Arrange
        final mealPlan = MealPlan(
          id: 'test-plan-1',
          name: 'Test Plan',
          description: 'Test Description',
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 7)),
          totalCalories: 2000,
          totalProtein: 150,
          totalFat: 65,
          totalCarbs: 250,
          isActive: true,
          meals: [],
        );

        when(mockSupabaseService.isAvailable).thenReturn(false);

        // Act
        await repository.saveMealPlan(mealPlan);

        // Assert
        verifyNever(mockSupabaseService.saveUserData(any, any));
      });
    });

    group('getUserMealPlans', () {
      test('should return meal plans when Supabase is available', () async {
        // Arrange
        final mockData = [
          {
            'id': 'plan-1',
            'name': 'Test Plan 1',
            'description': 'Test Description 1',
            'start_date': DateTime.now().toIso8601String(),
            'end_date': DateTime.now().add(const Duration(days: 7)).toIso8601String(),
            'total_calories': 2000,
            'total_protein': 150,
            'total_fat': 65,
            'total_carbs': 250,
            'is_active': true,
          },
        ];

        when(mockSupabaseService.isAvailable).thenReturn(true);
        when(mockSupabaseService.currentUser).thenReturn(
          User(id: 'user-1', email: 'test@example.com'),
        );
        when(mockSupabaseService.getUserData('meal_plans', userId: 'user-1'))
            .thenAnswer((_) async => mockData);
        when(mockSupabaseService.getUserData('meal_plan_meals', userId: 'user-1'))
            .thenAnswer((_) async => []);

        // Act
        final result = await repository.getUserMealPlans();

        // Assert
        expect(result, isA<List<MealPlan>>());
        expect(result.length, equals(1));
        expect(result.first.name, equals('Test Plan 1'));
      });

      test('should return empty list when user is not authenticated', () async {
        // Arrange
        when(mockSupabaseService.isAvailable).thenReturn(true);
        when(mockSupabaseService.currentUser).thenReturn(null);

        // Act
        final result = await repository.getUserMealPlans();

        // Assert
        expect(result, isEmpty);
      });

      test('should use mock when Supabase is not available', () async {
        // Arrange
        when(mockSupabaseService.isAvailable).thenReturn(false);

        // Act
        final result = await repository.getUserMealPlans();

        // Assert
        expect(result, isEmpty);
        verifyNever(mockSupabaseService.getUserData(any, userId: any));
      });
    });

    group('getActiveMealPlan', () {
      test('should return active meal plan when available', () async {
        // Arrange
        final mockData = [
          {
            'id': 'plan-1',
            'name': 'Active Plan',
            'description': 'Active Description',
            'start_date': DateTime.now().toIso8601String(),
            'end_date': DateTime.now().add(const Duration(days: 7)).toIso8601String(),
            'total_calories': 2000,
            'total_protein': 150,
            'total_fat': 65,
            'total_carbs': 250,
            'is_active': true,
          },
        ];

        when(mockSupabaseService.isAvailable).thenReturn(true);
        when(mockSupabaseService.currentUser).thenReturn(
          User(id: 'user-1', email: 'test@example.com'),
        );
        when(mockSupabaseService.getUserData('meal_plans', userId: 'user-1'))
            .thenAnswer((_) async => mockData);
        when(mockSupabaseService.getUserData('meal_plan_meals', userId: 'user-1'))
            .thenAnswer((_) async => []);

        // Act
        final result = await repository.getActiveMealPlan();

        // Assert
        expect(result, isNotNull);
        expect(result!.name, equals('Active Plan'));
        expect(result.isActive, isTrue);
      });

      test('should return null when no active meal plan', () async {
        // Arrange
        final mockData = [
          {
            'id': 'plan-1',
            'name': 'Inactive Plan',
            'description': 'Inactive Description',
            'start_date': DateTime.now().toIso8601String(),
            'end_date': DateTime.now().add(const Duration(days: 7)).toIso8601String(),
            'total_calories': 2000,
            'total_protein': 150,
            'total_fat': 65,
            'total_carbs': 250,
            'is_active': false,
          },
        ];

        when(mockSupabaseService.isAvailable).thenReturn(true);
        when(mockSupabaseService.currentUser).thenReturn(
          User(id: 'user-1', email: 'test@example.com'),
        );
        when(mockSupabaseService.getUserData('meal_plans', userId: 'user-1'))
            .thenAnswer((_) async => mockData);
        when(mockSupabaseService.getUserData('meal_plan_meals', userId: 'user-1'))
            .thenAnswer((_) async => []);

        // Act
        final result = await repository.getActiveMealPlan();

        // Assert
        expect(result, isNull);
      });
    });

    group('activateMealPlan', () {
      test('should activate meal plan successfully', () async {
        // Arrange
        when(mockSupabaseService.isAvailable).thenReturn(true);
        when(mockSupabaseService.currentUser).thenReturn(
          User(id: 'user-1', email: 'test@example.com'),
        );
        when(mockSupabaseService.saveUserData(any, any)).thenAnswer((_) async {});

        // Act
        await repository.activateMealPlan('plan-1');

        // Assert
        verify(mockSupabaseService.saveUserData('meal_plans', any)).called(2);
      });

      test('should throw exception when user is not authenticated', () async {
        // Arrange
        when(mockSupabaseService.isAvailable).thenReturn(true);
        when(mockSupabaseService.currentUser).thenReturn(null);

        // Act & Assert
        expect(
          () => repository.activateMealPlan('plan-1'),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('deleteMealPlan', () {
      test('should delete meal plan successfully', () async {
        // Arrange
        when(mockSupabaseService.isAvailable).thenReturn(true);
        when(mockSupabaseService.currentUser).thenReturn(
          User(id: 'user-1', email: 'test@example.com'),
        );
        when(mockSupabaseService.deleteUserData(any, any)).thenAnswer((_) async {});

        // Act
        await repository.deleteMealPlan('plan-1');

        // Assert
        verify(mockSupabaseService.deleteUserData('meal_plan_meals', 'plan-1')).called(1);
        verify(mockSupabaseService.deleteUserData('meal_plans', 'plan-1')).called(1);
      });
    });
  });
}

// Mock User class for testing
class User {
  final String id;
  final String email;

  User({required this.id, required this.email});
} 