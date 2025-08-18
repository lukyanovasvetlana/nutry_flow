import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nutry_flow/features/meal_plan/domain/entities/meal_plan.dart';
import 'package:nutry_flow/features/meal_plan/data/repositories/meal_plan_repository.dart';
import 'dart:developer' as developer;

// Events
abstract class MealPlanEvent extends Equatable {
  const MealPlanEvent();

  @override
  List<Object?> get props => [];
}

class LoadMealPlans extends MealPlanEvent {
  const LoadMealPlans();
}

class CreateMealPlan extends MealPlanEvent {
  final MealPlan mealPlan;

  const CreateMealPlan(this.mealPlan);

  @override
  List<Object?> get props => [mealPlan];
}

class UpdateMealPlan extends MealPlanEvent {
  final MealPlan mealPlan;

  const UpdateMealPlan(this.mealPlan);

  @override
  List<Object?> get props => [mealPlan];
}

class DeleteMealPlan extends MealPlanEvent {
  final String mealPlanId;

  const DeleteMealPlan(this.mealPlanId);

  @override
  List<Object?> get props => [mealPlanId];
}

class ActivateMealPlan extends MealPlanEvent {
  final String mealPlanId;

  const ActivateMealPlan(this.mealPlanId);

  @override
  List<Object?> get props => [mealPlanId];
}

class LoadActiveMealPlan extends MealPlanEvent {
  const LoadActiveMealPlan();
}

class AddMealToPlan extends MealPlanEvent {
  final String mealPlanId;
  final PlannedMeal meal;

  const AddMealToPlan(this.mealPlanId, this.meal);

  @override
  List<Object?> get props => [mealPlanId, meal];
}

class RemoveMealFromPlan extends MealPlanEvent {
  final String mealPlanId;
  final String mealId;

  const RemoveMealFromPlan(this.mealPlanId, this.mealId);

  @override
  List<Object?> get props => [mealPlanId, mealId];
}

// States
abstract class MealPlanState extends Equatable {
  const MealPlanState();

  @override
  List<Object?> get props => [];
}

class MealPlanInitial extends MealPlanState {}

class MealPlanLoading extends MealPlanState {}

class MealPlanLoaded extends MealPlanState {
  final List<MealPlan> mealPlans;
  final MealPlan? activeMealPlan;

  const MealPlanLoaded({
    required this.mealPlans,
    this.activeMealPlan,
  });

  @override
  List<Object?> get props => [mealPlans, activeMealPlan];

  MealPlanLoaded copyWith({
    List<MealPlan>? mealPlans,
    MealPlan? activeMealPlan,
  }) {
    return MealPlanLoaded(
      mealPlans: mealPlans ?? this.mealPlans,
      activeMealPlan: activeMealPlan ?? this.activeMealPlan,
    );
  }
}

class MealPlanError extends MealPlanState {
  final String message;

  const MealPlanError(this.message);

  @override
  List<Object?> get props => [message];
}

class MealPlanSuccess extends MealPlanState {
  final String message;

  const MealPlanSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class MealPlanBloc extends Bloc<MealPlanEvent, MealPlanState> {
  final MealPlanRepository _mealPlanRepository;

  MealPlanBloc({
    required MealPlanRepository mealPlanRepository,
  })  : _mealPlanRepository = mealPlanRepository,
        super(MealPlanInitial()) {
    on<LoadMealPlans>(_onLoadMealPlans);
    on<CreateMealPlan>(_onCreateMealPlan);
    on<UpdateMealPlan>(_onUpdateMealPlan);
    on<DeleteMealPlan>(_onDeleteMealPlan);
    on<ActivateMealPlan>(_onActivateMealPlan);
    on<LoadActiveMealPlan>(_onLoadActiveMealPlan);
    on<AddMealToPlan>(_onAddMealToPlan);
    on<RemoveMealFromPlan>(_onRemoveMealFromPlan);
  }

  Future<void> _onLoadMealPlans(
    LoadMealPlans event,
    Emitter<MealPlanState> emit,
  ) async {
    try {
      developer.log('🍽️ MealPlanBloc: Loading meal plans',
          name: 'MealPlanBloc');
      emit(MealPlanLoading());

      final mealPlans = await _mealPlanRepository.getUserMealPlans();
      final activeMealPlan = await _mealPlanRepository.getActiveMealPlan();

      emit(MealPlanLoaded(
        mealPlans: mealPlans,
        activeMealPlan: activeMealPlan,
      ));

      developer.log('🍽️ MealPlanBloc: Loaded ${mealPlans.length} meal plans',
          name: 'MealPlanBloc');
    } catch (e) {
      developer.log('🍽️ MealPlanBloc: Load meal plans failed: $e',
          name: 'MealPlanBloc');
      emit(MealPlanError('Не удалось загрузить планы питания: $e'));
    }
  }

  Future<void> _onCreateMealPlan(
    CreateMealPlan event,
    Emitter<MealPlanState> emit,
  ) async {
    try {
      developer.log('🍽️ MealPlanBloc: Creating meal plan',
          name: 'MealPlanBloc');
      emit(MealPlanLoading());

      await _mealPlanRepository.saveMealPlan(event.mealPlan);

      // Перезагружаем планы
      final mealPlans = await _mealPlanRepository.getUserMealPlans();
      final activeMealPlan = await _mealPlanRepository.getActiveMealPlan();

      emit(MealPlanLoaded(
        mealPlans: mealPlans,
        activeMealPlan: activeMealPlan,
      ));

      emit(MealPlanSuccess('План питания создан успешно'));
      developer.log('🍽️ MealPlanBloc: Meal plan created successfully',
          name: 'MealPlanBloc');
    } catch (e) {
      developer.log('🍽️ MealPlanBloc: Create meal plan failed: $e',
          name: 'MealPlanBloc');
      emit(MealPlanError('Не удалось создать план питания: $e'));
    }
  }

  Future<void> _onUpdateMealPlan(
    UpdateMealPlan event,
    Emitter<MealPlanState> emit,
  ) async {
    try {
      developer.log('🍽️ MealPlanBloc: Updating meal plan',
          name: 'MealPlanBloc');
      emit(MealPlanLoading());

      await _mealPlanRepository.saveMealPlan(event.mealPlan);

      // Перезагружаем планы
      final mealPlans = await _mealPlanRepository.getUserMealPlans();
      final activeMealPlan = await _mealPlanRepository.getActiveMealPlan();

      emit(MealPlanLoaded(
        mealPlans: mealPlans,
        activeMealPlan: activeMealPlan,
      ));

      emit(MealPlanSuccess('План питания обновлен успешно'));
      developer.log('🍽️ MealPlanBloc: Meal plan updated successfully',
          name: 'MealPlanBloc');
    } catch (e) {
      developer.log('🍽️ MealPlanBloc: Update meal plan failed: $e',
          name: 'MealPlanBloc');
      emit(MealPlanError('Не удалось обновить план питания: $e'));
    }
  }

  Future<void> _onDeleteMealPlan(
    DeleteMealPlan event,
    Emitter<MealPlanState> emit,
  ) async {
    try {
      developer.log('🍽️ MealPlanBloc: Deleting meal plan',
          name: 'MealPlanBloc');
      emit(MealPlanLoading());

      await _mealPlanRepository.deleteMealPlan(event.mealPlanId);

      // Перезагружаем планы
      final mealPlans = await _mealPlanRepository.getUserMealPlans();
      final activeMealPlan = await _mealPlanRepository.getActiveMealPlan();

      emit(MealPlanLoaded(
        mealPlans: mealPlans,
        activeMealPlan: activeMealPlan,
      ));

      emit(MealPlanSuccess('План питания удален успешно'));
      developer.log('🍽️ MealPlanBloc: Meal plan deleted successfully',
          name: 'MealPlanBloc');
    } catch (e) {
      developer.log('🍽️ MealPlanBloc: Delete meal plan failed: $e',
          name: 'MealPlanBloc');
      emit(MealPlanError('Не удалось удалить план питания: $e'));
    }
  }

  Future<void> _onActivateMealPlan(
    ActivateMealPlan event,
    Emitter<MealPlanState> emit,
  ) async {
    try {
      developer.log('🍽️ MealPlanBloc: Activating meal plan',
          name: 'MealPlanBloc');
      emit(MealPlanLoading());

      await _mealPlanRepository.activateMealPlan(event.mealPlanId);

      // Перезагружаем планы
      final mealPlans = await _mealPlanRepository.getUserMealPlans();
      final activeMealPlan = await _mealPlanRepository.getActiveMealPlan();

      emit(MealPlanLoaded(
        mealPlans: mealPlans,
        activeMealPlan: activeMealPlan,
      ));

      emit(MealPlanSuccess('План питания активирован успешно'));
      developer.log('🍽️ MealPlanBloc: Meal plan activated successfully',
          name: 'MealPlanBloc');
    } catch (e) {
      developer.log('🍽️ MealPlanBloc: Activate meal plan failed: $e',
          name: 'MealPlanBloc');
      emit(MealPlanError('Не удалось активировать план питания: $e'));
    }
  }

  Future<void> _onLoadActiveMealPlan(
    LoadActiveMealPlan event,
    Emitter<MealPlanState> emit,
  ) async {
    try {
      developer.log('🍽️ MealPlanBloc: Loading active meal plan',
          name: 'MealPlanBloc');
      emit(MealPlanLoading());

      final activeMealPlan = await _mealPlanRepository.getActiveMealPlan();

      if (state is MealPlanLoaded) {
        final currentState = state as MealPlanLoaded;
        emit(currentState.copyWith(activeMealPlan: activeMealPlan));
      } else {
        final mealPlans = await _mealPlanRepository.getUserMealPlans();
        emit(MealPlanLoaded(
          mealPlans: mealPlans,
          activeMealPlan: activeMealPlan,
        ));
      }

      developer.log('🍽️ MealPlanBloc: Active meal plan loaded',
          name: 'MealPlanBloc');
    } catch (e) {
      developer.log('🍽️ MealPlanBloc: Load active meal plan failed: $e',
          name: 'MealPlanBloc');
      emit(MealPlanError('Не удалось загрузить активный план питания: $e'));
    }
  }

  Future<void> _onAddMealToPlan(
    AddMealToPlan event,
    Emitter<MealPlanState> emit,
  ) async {
    try {
      developer.log('🍽️ MealPlanBloc: Adding meal to plan',
          name: 'MealPlanBloc');
      emit(MealPlanLoading());

      // Находим план и добавляем блюдо
      if (state is MealPlanLoaded) {
        final currentState = state as MealPlanLoaded;
        final mealPlanIndex = currentState.mealPlans.indexWhere(
          (plan) => plan.id == event.mealPlanId,
        );

        if (mealPlanIndex != -1) {
          final updatedMealPlan =
              currentState.mealPlans[mealPlanIndex].copyWith(
            meals: [...currentState.mealPlans[mealPlanIndex].meals, event.meal],
          );

          await _mealPlanRepository.saveMealPlan(updatedMealPlan);

          // Обновляем список планов
          final updatedPlans = List<MealPlan>.from(currentState.mealPlans);
          updatedPlans[mealPlanIndex] = updatedMealPlan;

          emit(MealPlanLoaded(
            mealPlans: updatedPlans,
            activeMealPlan: currentState.activeMealPlan,
          ));

          emit(MealPlanSuccess('Блюдо добавлено в план питания'));
          developer.log('🍽️ MealPlanBloc: Meal added to plan successfully',
              name: 'MealPlanBloc');
        }
      }
    } catch (e) {
      developer.log('🍽️ MealPlanBloc: Add meal to plan failed: $e',
          name: 'MealPlanBloc');
      emit(MealPlanError('Не удалось добавить блюдо в план питания: $e'));
    }
  }

  Future<void> _onRemoveMealFromPlan(
    RemoveMealFromPlan event,
    Emitter<MealPlanState> emit,
  ) async {
    try {
      developer.log('🍽️ MealPlanBloc: Removing meal from plan',
          name: 'MealPlanBloc');
      emit(MealPlanLoading());

      // Находим план и удаляем блюдо
      if (state is MealPlanLoaded) {
        final currentState = state as MealPlanLoaded;
        final mealPlanIndex = currentState.mealPlans.indexWhere(
          (plan) => plan.id == event.mealPlanId,
        );

        if (mealPlanIndex != -1) {
          final updatedMeals = currentState.mealPlans[mealPlanIndex].meals
              .where((meal) => meal.id != event.mealId)
              .toList();

          final updatedMealPlan =
              currentState.mealPlans[mealPlanIndex].copyWith(
            meals: updatedMeals,
          );

          await _mealPlanRepository.saveMealPlan(updatedMealPlan);

          // Обновляем список планов
          final updatedPlans = List<MealPlan>.from(currentState.mealPlans);
          updatedPlans[mealPlanIndex] = updatedMealPlan;

          emit(MealPlanLoaded(
            mealPlans: updatedPlans,
            activeMealPlan: currentState.activeMealPlan,
          ));

          emit(MealPlanSuccess('Блюдо удалено из плана питания'));
          developer.log('🍽️ MealPlanBloc: Meal removed from plan successfully',
              name: 'MealPlanBloc');
        }
      }
    } catch (e) {
      developer.log('🍽️ MealPlanBloc: Remove meal from plan failed: $e',
          name: 'MealPlanBloc');
      emit(MealPlanError('Не удалось удалить блюдо из плана питания: $e'));
    }
  }
}
