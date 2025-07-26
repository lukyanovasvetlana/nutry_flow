import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/workout.dart';
import '../../domain/usecases/workout_usecases.dart';

// Events
abstract class WorkoutEvent extends Equatable {
  const WorkoutEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserWorkouts extends WorkoutEvent {
  final String userId;

  const LoadUserWorkouts(this.userId);

  @override
  List<Object?> get props => [userId];
}

class LoadWorkoutTemplates extends WorkoutEvent {
  final String userId;

  const LoadWorkoutTemplates(this.userId);

  @override
  List<Object?> get props => [userId];
}

class CreateWorkout extends WorkoutEvent {
  final Workout workout;

  const CreateWorkout(this.workout);

  @override
  List<Object?> get props => [workout];
}

class UpdateWorkout extends WorkoutEvent {
  final Workout workout;

  const UpdateWorkout(this.workout);

  @override
  List<Object?> get props => [workout];
}

class DeleteWorkout extends WorkoutEvent {
  final String workoutId;

  const DeleteWorkout(this.workoutId);

  @override
  List<Object?> get props => [workoutId];
}

class SaveWorkoutAsTemplate extends WorkoutEvent {
  final String workoutId;

  const SaveWorkoutAsTemplate(this.workoutId);

  @override
  List<Object?> get props => [workoutId];
}

class SearchWorkouts extends WorkoutEvent {
  final String userId;
  final String query;

  const SearchWorkouts(this.userId, this.query);

  @override
  List<Object?> get props => [userId, query];
}

class FilterWorkoutsByDifficulty extends WorkoutEvent {
  final String userId;
  final String difficulty;

  const FilterWorkoutsByDifficulty(this.userId, this.difficulty);

  @override
  List<Object?> get props => [userId, difficulty];
}

// States
abstract class WorkoutState extends Equatable {
  const WorkoutState();

  @override
  List<Object?> get props => [];
}

class WorkoutInitial extends WorkoutState {}

class WorkoutLoading extends WorkoutState {}

class WorkoutLoaded extends WorkoutState {
  final List<Workout> workouts;
  final List<Workout> templates;
  final String? searchQuery;
  final String? selectedDifficulty;

  const WorkoutLoaded({
    required this.workouts,
    required this.templates,
    this.searchQuery,
    this.selectedDifficulty,
  });

  @override
  List<Object?> get props => [
        workouts,
        templates,
        searchQuery,
        selectedDifficulty,
      ];

  WorkoutLoaded copyWith({
    List<Workout>? workouts,
    List<Workout>? templates,
    String? searchQuery,
    String? selectedDifficulty,
  }) {
    return WorkoutLoaded(
      workouts: workouts ?? this.workouts,
      templates: templates ?? this.templates,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedDifficulty: selectedDifficulty ?? this.selectedDifficulty,
    );
  }
}

class WorkoutError extends WorkoutState {
  final String message;

  const WorkoutError(this.message);

  @override
  List<Object?> get props => [message];
}

class WorkoutCreated extends WorkoutState {
  final Workout workout;

  const WorkoutCreated(this.workout);

  @override
  List<Object?> get props => [workout];
}

class WorkoutUpdated extends WorkoutState {
  final Workout workout;

  const WorkoutUpdated(this.workout);

  @override
  List<Object?> get props => [workout];
}

class WorkoutDeleted extends WorkoutState {
  final String workoutId;

  const WorkoutDeleted(this.workoutId);

  @override
  List<Object?> get props => [workoutId];
}

// BLoC
@injectable
class WorkoutBloc extends Bloc<WorkoutEvent, WorkoutState> {
  final GetUserWorkoutsUseCase _getUserWorkoutsUseCase;
  final GetWorkoutTemplatesUseCase _getWorkoutTemplatesUseCase;
  final CreateWorkoutUseCase _createWorkoutUseCase;
  final UpdateWorkoutUseCase _updateWorkoutUseCase;
  final DeleteWorkoutUseCase _deleteWorkoutUseCase;
  final SaveWorkoutAsTemplateUseCase _saveAsTemplateUseCase;
  final SearchWorkoutsUseCase _searchWorkoutsUseCase;
  final FilterWorkoutsByDifficultyUseCase _filterByDifficultyUseCase;

  WorkoutBloc(
    this._getUserWorkoutsUseCase,
    this._getWorkoutTemplatesUseCase,
    this._createWorkoutUseCase,
    this._updateWorkoutUseCase,
    this._deleteWorkoutUseCase,
    this._saveAsTemplateUseCase,
    this._searchWorkoutsUseCase,
    this._filterByDifficultyUseCase,
  ) : super(WorkoutInitial()) {
    on<LoadUserWorkouts>(_onLoadUserWorkouts);
    on<LoadWorkoutTemplates>(_onLoadWorkoutTemplates);
    on<CreateWorkout>(_onCreateWorkout);
    on<UpdateWorkout>(_onUpdateWorkout);
    on<DeleteWorkout>(_onDeleteWorkout);
    on<SaveWorkoutAsTemplate>(_onSaveWorkoutAsTemplate);
    on<SearchWorkouts>(_onSearchWorkouts);
    on<FilterWorkoutsByDifficulty>(_onFilterWorkoutsByDifficulty);
  }

  Future<void> _onLoadUserWorkouts(LoadUserWorkouts event, Emitter<WorkoutState> emit) async {
    emit(WorkoutLoading());

    final result = await _getUserWorkoutsUseCase(event.userId);

    result.fold(
      (error) => emit(WorkoutError(error)),
      (workouts) {
        if (state is WorkoutLoaded) {
          final currentState = state as WorkoutLoaded;
          emit(currentState.copyWith(workouts: workouts));
        } else {
          emit(WorkoutLoaded(
            workouts: workouts,
            templates: [],
          ));
        }
      },
    );
  }

  Future<void> _onLoadWorkoutTemplates(LoadWorkoutTemplates event, Emitter<WorkoutState> emit) async {
    emit(WorkoutLoading());

    final result = await _getWorkoutTemplatesUseCase(event.userId);

    result.fold(
      (error) => emit(WorkoutError(error)),
      (templates) {
        if (state is WorkoutLoaded) {
          final currentState = state as WorkoutLoaded;
          emit(currentState.copyWith(templates: templates));
        } else {
          emit(WorkoutLoaded(
            workouts: [],
            templates: templates,
          ));
        }
      },
    );
  }

  Future<void> _onCreateWorkout(CreateWorkout event, Emitter<WorkoutState> emit) async {
    emit(WorkoutLoading());

    final result = await _createWorkoutUseCase(event.workout);

    result.fold(
      (error) => emit(WorkoutError(error)),
      (workout) {
        emit(WorkoutCreated(workout));
        // Перезагружаем список тренировок
        add(LoadUserWorkouts(event.workout.userId));
      },
    );
  }

  Future<void> _onUpdateWorkout(UpdateWorkout event, Emitter<WorkoutState> emit) async {
    emit(WorkoutLoading());

    final result = await _updateWorkoutUseCase(event.workout);

    result.fold(
      (error) => emit(WorkoutError(error)),
      (workout) {
        emit(WorkoutUpdated(workout));
        // Перезагружаем список тренировок
        add(LoadUserWorkouts(event.workout.userId));
      },
    );
  }

  Future<void> _onDeleteWorkout(DeleteWorkout event, Emitter<WorkoutState> emit) async {
    emit(WorkoutLoading());

    final result = await _deleteWorkoutUseCase(event.workoutId);

    result.fold(
      (error) => emit(WorkoutError(error)),
      (_) {
        emit(WorkoutDeleted(event.workoutId));
        // Перезагружаем список тренировок
        if (state is WorkoutLoaded) {
          final currentState = state as WorkoutLoaded;
          // Находим userId из текущих тренировок
          if (currentState.workouts.isNotEmpty) {
            add(LoadUserWorkouts(currentState.workouts.first.userId));
          }
        }
      },
    );
  }

  Future<void> _onSaveWorkoutAsTemplate(SaveWorkoutAsTemplate event, Emitter<WorkoutState> emit) async {
    final result = await _saveAsTemplateUseCase(event.workoutId);

    result.fold(
      (error) => emit(WorkoutError(error)),
      (_) {
        // Перезагружаем шаблоны
        if (state is WorkoutLoaded) {
          final currentState = state as WorkoutLoaded;
          if (currentState.workouts.isNotEmpty) {
            add(LoadWorkoutTemplates(currentState.workouts.first.userId));
          }
        }
      },
    );
  }

  Future<void> _onSearchWorkouts(SearchWorkouts event, Emitter<WorkoutState> emit) async {
    emit(WorkoutLoading());

    final result = await _searchWorkoutsUseCase(event.userId, event.query);

    result.fold(
      (error) => emit(WorkoutError(error)),
      (workouts) {
        if (state is WorkoutLoaded) {
          final currentState = state as WorkoutLoaded;
          emit(currentState.copyWith(
            workouts: workouts,
            searchQuery: event.query,
            selectedDifficulty: null,
          ));
        } else {
          emit(WorkoutLoaded(
            workouts: workouts,
            templates: [],
            searchQuery: event.query,
          ));
        }
      },
    );
  }

  Future<void> _onFilterWorkoutsByDifficulty(FilterWorkoutsByDifficulty event, Emitter<WorkoutState> emit) async {
    emit(WorkoutLoading());

    final result = await _filterByDifficultyUseCase(event.userId, event.difficulty);

    result.fold(
      (error) => emit(WorkoutError(error)),
      (workouts) {
        if (state is WorkoutLoaded) {
          final currentState = state as WorkoutLoaded;
          emit(currentState.copyWith(
            workouts: workouts,
            selectedDifficulty: event.difficulty,
            searchQuery: null,
          ));
        } else {
          emit(WorkoutLoaded(
            workouts: workouts,
            templates: [],
            selectedDifficulty: event.difficulty,
          ));
        }
      },
    );
  }
} 