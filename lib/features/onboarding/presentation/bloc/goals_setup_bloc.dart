import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/user_goals.dart';
import '../../domain/usecases/save_user_goals_usecase.dart';
import '../../domain/usecases/get_user_goals_usecase.dart';

// Events
abstract class GoalsSetupEvent extends Equatable {
  const GoalsSetupEvent();

  @override
  List<Object?> get props => [];
}

class GoalSelected extends GoalsSetupEvent {
  final String goalId;

  const GoalSelected(this.goalId);

  @override
  List<Object?> get props => [goalId];
}

class TargetWeightChanged extends GoalsSetupEvent {
  final double? targetWeight;

  const TargetWeightChanged(this.targetWeight);

  @override
  List<Object?> get props => [targetWeight];
}

class SaveGoals extends GoalsSetupEvent {}

class LoadExistingGoals extends GoalsSetupEvent {}

class AllergenToggled extends GoalsSetupEvent {
  final String allergen;
  const AllergenToggled(this.allergen);
  @override
  List<Object?> get props => [allergen];
}

class WorkoutTypeToggled extends GoalsSetupEvent {
  final String workoutType;
  const WorkoutTypeToggled(this.workoutType);
  @override
  List<Object?> get props => [workoutType];
}

class WorkoutFrequencyChanged extends GoalsSetupEvent {
  final int frequency;
  const WorkoutFrequencyChanged(this.frequency);
  @override
  List<Object?> get props => [frequency];
}

class WorkoutDurationChanged extends GoalsSetupEvent {
  final int duration;
  const WorkoutDurationChanged(this.duration);
  @override
  List<Object?> get props => [duration];
}

// States
abstract class GoalsSetupState extends Equatable {
  const GoalsSetupState();

  @override
  List<Object?> get props => [];
}

class GoalsSetupInitial extends GoalsSetupState {}

class GoalsSetupLoading extends GoalsSetupState {}

class GoalsSetupLoaded extends GoalsSetupState {
  final UserGoals goals;
  final bool isValid;

  const GoalsSetupLoaded({
    required this.goals,
    required this.isValid,
  });

  @override
  List<Object?> get props => [goals, isValid];

  GoalsSetupLoaded copyWith({
    UserGoals? goals,
    bool? isValid,
  }) {
    return GoalsSetupLoaded(
      goals: goals ?? this.goals,
      isValid: isValid ?? this.isValid,
    );
  }
}

class GoalsSetupSaving extends GoalsSetupState {}

class GoalsSetupSaved extends GoalsSetupState {
  final UserGoals goals;

  const GoalsSetupSaved(this.goals);

  @override
  List<Object?> get props => [goals];
}

class GoalsSetupError extends GoalsSetupState {
  final String message;

  const GoalsSetupError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class GoalsSetupBloc extends Bloc<GoalsSetupEvent, GoalsSetupState> {
  final SaveUserGoalsUseCase _saveUserGoalsUseCase;
  final GetUserGoalsUseCase _getUserGoalsUseCase;

  GoalsSetupBloc(
    this._saveUserGoalsUseCase,
    this._getUserGoalsUseCase,
  ) : super(GoalsSetupInitial()) {
    on<GoalSelected>(_onGoalSelected);
    on<TargetWeightChanged>(_onTargetWeightChanged);
    on<SaveGoals>(_onSaveGoals);
    on<LoadExistingGoals>(_onLoadExistingGoals);
    on<AllergenToggled>(_onAllergenToggled);
    on<WorkoutTypeToggled>(_onWorkoutTypeToggled);
    on<WorkoutFrequencyChanged>(_onWorkoutFrequencyChanged);
    on<WorkoutDurationChanged>(_onWorkoutDurationChanged);
  }

  void _onGoalSelected(GoalSelected event, Emitter<GoalsSetupState> emit) {
    if (state is GoalsSetupLoaded) {
      final currentState = state as GoalsSetupLoaded;
      final updatedGoals = currentState.goals.copyWith(
        fitnessGoals: [event.goalId],
        targetCalories: (currentState.goals.targetCalories != null && currentState.goals.targetCalories! >= 800 && currentState.goals.targetCalories! <= 5000)
          ? currentState.goals.targetCalories
          : 2000,
        targetProtein: 30,
        updatedAt: DateTime.now(),
      );
      emit(currentState.copyWith(
        goals: updatedGoals,
        isValid: updatedGoals.isValid,
      ));
    } else {
      final goals = UserGoals(
        id: 'goals1',
        userId: 'user1',
        fitnessGoals: [event.goalId],
        targetCalories: 2000,
        targetProtein: 30,
        dietaryPreferences: const [],
        healthConditions: const [],
        workoutTypes: const [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      emit(GoalsSetupLoaded(goals: goals, isValid: goals.isValid));
    }
  }

  void _onTargetWeightChanged(TargetWeightChanged event, Emitter<GoalsSetupState> emit) {
    if (state is GoalsSetupLoaded) {
      final currentState = state as GoalsSetupLoaded;
      final updatedGoals = currentState.goals.copyWith(
        targetWeight: event.targetWeight,
      );
      emit(currentState.copyWith(
        goals: updatedGoals,
        isValid: updatedGoals.isValid,
      ));
    } else {
      final goals = UserGoals(
        id: 'goals2',
        userId: 'user1',
        fitnessGoals: const [],
        dietaryPreferences: const [],
        healthConditions: const [],
        workoutTypes: const [],
        targetWeight: event.targetWeight,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      emit(GoalsSetupLoaded(goals: goals, isValid: goals.isValid));
    }
  }

  void _onSaveGoals(SaveGoals event, Emitter<GoalsSetupState> emit) async {
    print('🟤 GoalsSetupBloc: SaveGoals event received');
    
    if (state is GoalsSetupLoaded) {
      final currentState = state as GoalsSetupLoaded;
      print('🟤 GoalsSetupBloc: Current state is GoalsSetupLoaded');
      print('🟤 GoalsSetupBloc: Goals valid: ${currentState.isValid}');
      print('🟤 GoalsSetupBloc: Goals: ${currentState.goals}');
      
      emit(GoalsSetupSaving());
      print('🟤 GoalsSetupBloc: Emitted GoalsSetupSaving');
      
      try {
        print('🟤 GoalsSetupBloc: Calling saveUserGoalsUseCase.execute');
        final result = await _saveUserGoalsUseCase.execute(currentState.goals);
        
        print('🟤 GoalsSetupBloc: SaveUserGoalsUseCase result - isSuccess: ${result.isSuccess}');
        
        if (result.isSuccess) {
          print('🟤 GoalsSetupBloc: Goals saved successfully');
          emit(GoalsSetupSaved(currentState.goals));
        } else {
          print('🟤 GoalsSetupBloc: Failed to save goals - error:  [38;5;9m${result.error} [0m');
          emit(GoalsSetupError(result.error!));
        }
      } catch (e) {
        print('🟤 GoalsSetupBloc: Exception in SaveGoals: $e');
        emit(GoalsSetupError('Ошибка сохранения целей: ${e.toString()}'));
      }
    } else {
      print('🟤 GoalsSetupBloc: State is not GoalsSetupLoaded - ${state.runtimeType}');
      emit(GoalsSetupError('Неверное состояние для сохранения целей'));
    }
  }

  void _onLoadExistingGoals(LoadExistingGoals event, Emitter<GoalsSetupState> emit) async {
    emit(GoalsSetupLoading());
    
    final result = await _getUserGoalsUseCase.execute();
    
    if (result.isSuccess && result.goals != null) {
      int safeCalories = (result.goals!.targetCalories != null && result.goals!.targetCalories! >= 800 && result.goals!.targetCalories! <= 5000)
        ? result.goals!.targetCalories!
        : 2000;
      emit(GoalsSetupLoaded(
        goals: result.goals!.copyWith(targetCalories: safeCalories),
        isValid: result.goals!.isValid,
      ));
    } else if (result.error != null) {
      emit(GoalsSetupError(result.error!));
    } else {
      // Нет существующих целей, создаем новые
      emit(GoalsSetupLoaded(
        goals: UserGoals(
          id: 'goals10',
          userId: 'user1',
          fitnessGoals: const [],
          dietaryPreferences: const [],
          healthConditions: const [],
          workoutTypes: const [],
          targetCalories: 2000,
          createdAt: DateTime(2023, 1, 1),
          updatedAt: DateTime(2023, 1, 1),
        ),
        isValid: false,
      ));
    }
  }

  void _onAllergenToggled(AllergenToggled event, Emitter<GoalsSetupState> emit) {
    if (state is GoalsSetupLoaded) {
      final currentState = state as GoalsSetupLoaded;
      final allergens = List<String>.from(currentState.goals.healthConditions);
      if (allergens.contains(event.allergen)) {
        allergens.remove(event.allergen);
      } else {
        allergens.add(event.allergen);
      }
      final updatedGoals = currentState.goals.copyWith(healthConditions: allergens, updatedAt: DateTime.now());
      emit(currentState.copyWith(goals: updatedGoals, isValid: updatedGoals.isValid));
    }
  }

  void _onWorkoutTypeToggled(WorkoutTypeToggled event, Emitter<GoalsSetupState> emit) {
    if (state is GoalsSetupLoaded) {
      final currentState = state as GoalsSetupLoaded;
      final types = List<String>.from(currentState.goals.workoutTypes);
      if (types.contains(event.workoutType)) {
        types.remove(event.workoutType);
      } else {
        types.add(event.workoutType);
      }
      final updatedGoals = currentState.goals.copyWith(workoutTypes: types, updatedAt: DateTime.now());
      emit(currentState.copyWith(goals: updatedGoals, isValid: updatedGoals.isValid));
    }
  }

  void _onWorkoutFrequencyChanged(WorkoutFrequencyChanged event, Emitter<GoalsSetupState> emit) {
    if (state is GoalsSetupLoaded) {
      final currentState = state as GoalsSetupLoaded;
      final updatedGoals = currentState.goals.copyWith(workoutFrequency: event.frequency, updatedAt: DateTime.now());
      emit(currentState.copyWith(goals: updatedGoals, isValid: updatedGoals.isValid));
    }
  }

  void _onWorkoutDurationChanged(WorkoutDurationChanged event, Emitter<GoalsSetupState> emit) {
    if (state is GoalsSetupLoaded) {
      final currentState = state as GoalsSetupLoaded;
      final updatedGoals = currentState.goals.copyWith(targetProtein: event.duration.toDouble(), updatedAt: DateTime.now());
      emit(currentState.copyWith(goals: updatedGoals, isValid: updatedGoals.isValid));
    }
  }
} 