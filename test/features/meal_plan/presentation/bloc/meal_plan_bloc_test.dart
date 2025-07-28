import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:nutry_flow/features/meal_plan/data/repositories/meal_plan_repository.dart';
import 'package:nutry_flow/features/meal_plan/presentation/bloc/meal_plan_bloc.dart';
import 'package:nutry_flow/features/meal_plan/domain/entities/meal_plan.dart';
import 'package:nutry_flow/features/meal_plan/domain/entities/meal.dart';

import 'meal_plan_bloc_test.mocks.dart';

@GenerateMocks([MealPlanRepository])
void main() {
  group('MealPlanBloc', () {
    late MealPlanBloc bloc;
    late MockMealPlanRepository mockRepository;

    setUp(() {
      mockRepository = MockMealPlanRepository();
      bloc = MealPlanBloc(mealPlanRepository: mockRepository);
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state is MealPlanInitial', () {
      expect(bloc.state, isA<MealPlanInitial>());
    });

    group('LoadMealPlans', () {
      final testMealPlans = [
        MealPlan(
          id: 'plan-1',
          name: 'Test Plan 1',
          description: 'Test Description 1',
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 7)),
          totalCalories: 2000,
          totalProtein: 150,
          totalFat: 65,
          totalCarbs: 250,
          isActive: true,
          meals: [],
        ),
        MealPlan(
          id: 'plan-2',
          name: 'Test Plan 2',
          description: 'Test Description 2',
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 7)),
          totalCalories: 1800,
          totalProtein: 120,
          totalFat: 55,
          totalCarbs: 200,
          isActive: false,
          meals: [],
        ),
      ];

      blocTest<MealPlanBloc, MealPlanState>(
        'emits [MealPlanLoading, MealPlanLoaded] when LoadMealPlans is added',
        build: () {
          when(mockRepository.getUserMealPlans())
              .thenAnswer((_) async => testMealPlans);
          when(mockRepository.getActiveMealPlan())
              .thenAnswer((_) async => testMealPlans.first);
          return bloc;
        },
        act: (bloc) => bloc.add(LoadMealPlans()),
        expect: () => [
          isA<MealPlanLoading>(),
          isA<MealPlanLoaded>().having(
            (state) => state.mealPlans.length,
            'mealPlans.length',
            2,
          ),
        ],
      );

      blocTest<MealPlanBloc, MealPlanState>(
        'emits [MealPlanLoading, MealPlanError] when LoadMealPlans fails',
        build: () {
          when(mockRepository.getUserMealPlans())
              .thenThrow(Exception('Failed to load meal plans'));
          return bloc;
        },
        act: (bloc) => bloc.add(LoadMealPlans()),
        expect: () => [
          isA<MealPlanLoading>(),
          isA<MealPlanError>().having(
            (state) => state.message,
            'message',
            contains('Не удалось загрузить планы питания'),
          ),
        ],
      );
    });

    group('CreateMealPlan', () {
      final testMealPlan = MealPlan(
        id: 'new-plan',
        name: 'New Test Plan',
        description: 'New Test Description',
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 7)),
        totalCalories: 2000,
        totalProtein: 150,
        totalFat: 65,
        totalCarbs: 250,
        isActive: false,
        meals: [],
      );

      blocTest<MealPlanBloc, MealPlanState>(
        'emits [MealPlanLoading, MealPlanLoaded, MealPlanSuccess] when CreateMealPlan succeeds',
        build: () {
          when(mockRepository.saveMealPlan(any))
              .thenAnswer((_) async {});
          when(mockRepository.getUserMealPlans())
              .thenAnswer((_) async => [testMealPlan]);
          when(mockRepository.getActiveMealPlan())
              .thenAnswer((_) async => null);
          return bloc;
        },
        act: (bloc) => bloc.add(CreateMealPlan(testMealPlan)),
        expect: () => [
          isA<MealPlanLoading>(),
          isA<MealPlanLoaded>(),
          isA<MealPlanSuccess>().having(
            (state) => state.message,
            'message',
            'План питания создан успешно',
          ),
        ],
      );

      blocTest<MealPlanBloc, MealPlanState>(
        'emits [MealPlanLoading, MealPlanError] when CreateMealPlan fails',
        build: () {
          when(mockRepository.saveMealPlan(any))
              .thenThrow(Exception('Failed to create meal plan'));
          return bloc;
        },
        act: (bloc) => bloc.add(CreateMealPlan(testMealPlan)),
        expect: () => [
          isA<MealPlanLoading>(),
          isA<MealPlanError>().having(
            (state) => state.message,
            'message',
            contains('Не удалось создать план питания'),
          ),
        ],
      );
    });

    group('UpdateMealPlan', () {
      final updatedMealPlan = MealPlan(
        id: 'plan-1',
        name: 'Updated Test Plan',
        description: 'Updated Test Description',
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 7)),
        totalCalories: 2000,
        totalProtein: 150,
        totalFat: 65,
        totalCarbs: 250,
        isActive: true,
        meals: [],
      );

      blocTest<MealPlanBloc, MealPlanState>(
        'emits [MealPlanLoading, MealPlanLoaded, MealPlanSuccess] when UpdateMealPlan succeeds',
        build: () {
          when(mockRepository.saveMealPlan(any))
              .thenAnswer((_) async {});
          when(mockRepository.getUserMealPlans())
              .thenAnswer((_) async => [updatedMealPlan]);
          when(mockRepository.getActiveMealPlan())
              .thenAnswer((_) async => updatedMealPlan);
          return bloc;
        },
        act: (bloc) => bloc.add(UpdateMealPlan(updatedMealPlan)),
        expect: () => [
          isA<MealPlanLoading>(),
          isA<MealPlanLoaded>(),
          isA<MealPlanSuccess>().having(
            (state) => state.message,
            'message',
            'План питания обновлен успешно',
          ),
        ],
      );
    });

    group('DeleteMealPlan', () {
      blocTest<MealPlanBloc, MealPlanState>(
        'emits [MealPlanLoading, MealPlanLoaded, MealPlanSuccess] when DeleteMealPlan succeeds',
        build: () {
          when(mockRepository.deleteMealPlan(any))
              .thenAnswer((_) async {});
          when(mockRepository.getUserMealPlans())
              .thenAnswer((_) async => []);
          when(mockRepository.getActiveMealPlan())
              .thenAnswer((_) async => null);
          return bloc;
        },
        act: (bloc) => bloc.add(DeleteMealPlan('plan-1')),
        expect: () => [
          isA<MealPlanLoading>(),
          isA<MealPlanLoaded>(),
          isA<MealPlanSuccess>().having(
            (state) => state.message,
            'message',
            'План питания удален успешно',
          ),
        ],
      );
    });

    group('ActivateMealPlan', () {
      blocTest<MealPlanBloc, MealPlanState>(
        'emits [MealPlanLoading, MealPlanLoaded, MealPlanSuccess] when ActivateMealPlan succeeds',
        build: () {
          when(mockRepository.activateMealPlan(any))
              .thenAnswer((_) async {});
          when(mockRepository.getUserMealPlans())
              .thenAnswer((_) async => []);
          when(mockRepository.getActiveMealPlan())
              .thenAnswer((_) async => null);
          return bloc;
        },
        act: (bloc) => bloc.add(ActivateMealPlan('plan-1')),
        expect: () => [
          isA<MealPlanLoading>(),
          isA<MealPlanLoaded>(),
          isA<MealPlanSuccess>().having(
            (state) => state.message,
            'message',
            'План питания активирован успешно',
          ),
        ],
      );
    });

    group('LoadActiveMealPlan', () {
      final activeMealPlan = MealPlan(
        id: 'active-plan',
        name: 'Active Test Plan',
        description: 'Active Test Description',
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 7)),
        totalCalories: 2000,
        totalProtein: 150,
        totalFat: 65,
        totalCarbs: 250,
        isActive: true,
        meals: [],
      );

      blocTest<MealPlanBloc, MealPlanState>(
        'emits [MealPlanLoading, MealPlanLoaded] when LoadActiveMealPlan succeeds',
        build: () {
          when(mockRepository.getActiveMealPlan())
              .thenAnswer((_) async => activeMealPlan);
          when(mockRepository.getUserMealPlans())
              .thenAnswer((_) async => [activeMealPlan]);
          return bloc;
        },
        act: (bloc) => bloc.add(LoadActiveMealPlan()),
        expect: () => [
          isA<MealPlanLoading>(),
          isA<MealPlanLoaded>().having(
            (state) => state.activeMealPlan?.id,
            'activeMealPlan.id',
            'active-plan',
          ),
        ],
      );
    });

    group('AddMealToPlan', () {
      final testMeal = Meal(
        id: 'new-meal',
        name: 'New Test Meal',
        description: 'New Test Meal Description',
        dayOfWeek: 1,
        mealType: 'breakfast',
        calories: 500,
        protein: 30,
        fat: 20,
        carbs: 60,
        order: 1,
      );

      final existingMealPlan = MealPlan(
        id: 'plan-1',
        name: 'Test Plan',
        description: 'Test Description',
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 7)),
        totalCalories: 2000,
        totalProtein: 150,
        totalFat: 65,
        totalCarbs: 250,
        isActive: false,
        meals: [],
      );

      blocTest<MealPlanBloc, MealPlanState>(
        'emits [MealPlanLoading, MealPlanLoaded, MealPlanSuccess] when AddMealToPlan succeeds',
        build: () {
          when(mockRepository.saveMealPlan(any))
              .thenAnswer((_) async {});
          when(mockRepository.getUserMealPlans())
              .thenAnswer((_) async => [existingMealPlan]);
          when(mockRepository.getActiveMealPlan())
              .thenAnswer((_) async => null);
          return bloc;
        },
        seed: () => MealPlanLoaded(
          mealPlans: [existingMealPlan],
          activeMealPlan: null,
        ),
        act: (bloc) => bloc.add(AddMealToPlan('plan-1', testMeal)),
        expect: () => [
          isA<MealPlanLoading>(),
          isA<MealPlanLoaded>(),
          isA<MealPlanSuccess>().having(
            (state) => state.message,
            'message',
            'Блюдо добавлено в план питания',
          ),
        ],
      );
    });

    group('RemoveMealFromPlan', () {
      final testMeal = Meal(
        id: 'meal-to-remove',
        name: 'Meal to Remove',
        description: 'Test meal to remove',
        dayOfWeek: 1,
        mealType: 'breakfast',
        calories: 500,
        protein: 30,
        fat: 20,
        carbs: 60,
        order: 1,
      );

      final existingMealPlan = MealPlan(
        id: 'plan-1',
        name: 'Test Plan',
        description: 'Test Description',
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 7)),
        totalCalories: 2000,
        totalProtein: 150,
        totalFat: 65,
        totalCarbs: 250,
        isActive: false,
        meals: [testMeal],
      );

      blocTest<MealPlanBloc, MealPlanState>(
        'emits [MealPlanLoading, MealPlanLoaded, MealPlanSuccess] when RemoveMealFromPlan succeeds',
        build: () {
          when(mockRepository.saveMealPlan(any))
              .thenAnswer((_) async {});
          when(mockRepository.getUserMealPlans())
              .thenAnswer((_) async => [existingMealPlan]);
          when(mockRepository.getActiveMealPlan())
              .thenAnswer((_) async => null);
          return bloc;
        },
        seed: () => MealPlanLoaded(
          mealPlans: [existingMealPlan],
          activeMealPlan: null,
        ),
        act: (bloc) => bloc.add(RemoveMealFromPlan('plan-1', 'meal-to-remove')),
        expect: () => [
          isA<MealPlanLoading>(),
          isA<MealPlanLoaded>(),
          isA<MealPlanSuccess>().having(
            (state) => state.message,
            'message',
            'Блюдо удалено из плана питания',
          ),
        ],
      );
    });
  });
} 