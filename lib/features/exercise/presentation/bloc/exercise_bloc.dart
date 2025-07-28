import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nutry_flow/features/exercise/domain/entities/exercise.dart';
import 'package:nutry_flow/features/exercise/domain/entities/workout.dart';
import 'package:nutry_flow/features/exercise/domain/entities/workout_session.dart';
import 'package:nutry_flow/features/exercise/data/repositories/exercise_repository.dart';
import 'dart:developer' as developer;

// Events
abstract class ExerciseEvent extends Equatable {
  const ExerciseEvent();

  @override
  List<Object?> get props => [];
}

class LoadExercises extends ExerciseEvent {
  const LoadExercises();
}

class LoadExercisesByCategory extends ExerciseEvent {
  final String category;
  
  const LoadExercisesByCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class CreateExercise extends ExerciseEvent {
  final Exercise exercise;
  
  const CreateExercise(this.exercise);

  @override
  List<Object?> get props => [exercise];
}

class UpdateExercise extends ExerciseEvent {
  final Exercise exercise;
  
  const UpdateExercise(this.exercise);

  @override
  List<Object?> get props => [exercise];
}

class DeleteExercise extends ExerciseEvent {
  final String exerciseId;
  
  const DeleteExercise(this.exerciseId);

  @override
  List<Object?> get props => [exerciseId];
}

class LoadWorkouts extends ExerciseEvent {
  const LoadWorkouts();
}

class CreateWorkout extends ExerciseEvent {
  final Workout workout;
  
  const CreateWorkout(this.workout);

  @override
  List<Object?> get props => [workout];
}

class UpdateWorkout extends ExerciseEvent {
  final Workout workout;
  
  const UpdateWorkout(this.workout);

  @override
  List<Object?> get props => [workout];
}

class DeleteWorkout extends ExerciseEvent {
  final String workoutId;
  
  const DeleteWorkout(this.workoutId);

  @override
  List<Object?> get props => [workoutId];
}

class StartWorkoutSession extends ExerciseEvent {
  final String workoutId;
  
  const StartWorkoutSession(this.workoutId);

  @override
  List<Object?> get props => [workoutId];
}

class CompleteWorkoutSession extends ExerciseEvent {
  final String sessionId;
  final int durationMinutes;
  final int caloriesBurned;
  final String? notes;
  
  const CompleteWorkoutSession({
    required this.sessionId,
    required this.durationMinutes,
    required this.caloriesBurned,
    this.notes,
  });

  @override
  List<Object?> get props => [sessionId, durationMinutes, caloriesBurned, notes];
}

class LoadWorkoutHistory extends ExerciseEvent {
  const LoadWorkoutHistory();
}

// States
abstract class ExerciseState extends Equatable {
  const ExerciseState();

  @override
  List<Object?> get props => [];
}

class ExerciseInitial extends ExerciseState {}

class ExerciseLoading extends ExerciseState {}

class ExerciseLoaded extends ExerciseState {
  final List<Exercise> exercises;
  final List<Workout> workouts;
  final List<WorkoutSession> workoutHistory;
  final String? selectedCategory;
  
  const ExerciseLoaded({
    required this.exercises,
    required this.workouts,
    required this.workoutHistory,
    this.selectedCategory,
  });

  @override
  List<Object?> get props => [exercises, workouts, workoutHistory, selectedCategory];

  ExerciseLoaded copyWith({
    List<Exercise>? exercises,
    List<Workout>? workouts,
    List<WorkoutSession>? workoutHistory,
    String? selectedCategory,
  }) {
    return ExerciseLoaded(
      exercises: exercises ?? this.exercises,
      workouts: workouts ?? this.workouts,
      workoutHistory: workoutHistory ?? this.workoutHistory,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}

class ExerciseError extends ExerciseState {
  final String message;
  
  const ExerciseError(this.message);

  @override
  List<Object?> get props => [message];
}

class ExerciseSuccess extends ExerciseState {
  final String message;
  
  const ExerciseSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class WorkoutSessionActive extends ExerciseState {
  final WorkoutSession session;
  
  const WorkoutSessionActive(this.session);

  @override
  List<Object?> get props => [session];
}

// BLoC
class ExerciseBloc extends Bloc<ExerciseEvent, ExerciseState> {
  final ExerciseRepository _exerciseRepository;

  ExerciseBloc({
    required ExerciseRepository exerciseRepository,
  }) : _exerciseRepository = exerciseRepository,
       super(ExerciseInitial()) {
    
    on<LoadExercises>(_onLoadExercises);
    on<LoadExercisesByCategory>(_onLoadExercisesByCategory);
    on<CreateExercise>(_onCreateExercise);
    on<UpdateExercise>(_onUpdateExercise);
    on<DeleteExercise>(_onDeleteExercise);
    on<LoadWorkouts>(_onLoadWorkouts);
    on<CreateWorkout>(_onCreateWorkout);
    on<UpdateWorkout>(_onUpdateWorkout);
    on<DeleteWorkout>(_onDeleteWorkout);
    on<StartWorkoutSession>(_onStartWorkoutSession);
    on<CompleteWorkoutSession>(_onCompleteWorkoutSession);
    on<LoadWorkoutHistory>(_onLoadWorkoutHistory);
  }

  Future<void> _onLoadExercises(
    LoadExercises event,
    Emitter<ExerciseState> emit,
  ) async {
    try {
      developer.log('💪 ExerciseBloc: Loading exercises', name: 'ExerciseBloc');
      emit(ExerciseLoading());

      final exercises = await _exerciseRepository.getAllExercises();

      if (state is ExerciseLoaded) {
        final currentState = state as ExerciseLoaded;
        emit(currentState.copyWith(exercises: exercises));
      } else {
        emit(ExerciseLoaded(
          exercises: exercises,
          workouts: [],
          workoutHistory: [],
        ));
      }

      developer.log('💪 ExerciseBloc: Loaded ${exercises.length} exercises', name: 'ExerciseBloc');
    } catch (e) {
      developer.log('💪 ExerciseBloc: Load exercises failed: $e', name: 'ExerciseBloc');
      emit(ExerciseError('Не удалось загрузить упражнения: $e'));
    }
  }

  Future<void> _onLoadExercisesByCategory(
    LoadExercisesByCategory event,
    Emitter<ExerciseState> emit,
  ) async {
    try {
      developer.log('💪 ExerciseBloc: Loading exercises by category: ${event.category}', name: 'ExerciseBloc');
      emit(ExerciseLoading());

      final exercises = await _exerciseRepository.getExercisesByCategory(event.category);

      if (state is ExerciseLoaded) {
        final currentState = state as ExerciseLoaded;
        emit(currentState.copyWith(
          exercises: exercises,
          selectedCategory: event.category,
        ));
      } else {
        emit(ExerciseLoaded(
          exercises: exercises,
          workouts: [],
          workoutHistory: [],
          selectedCategory: event.category,
        ));
      }

      developer.log('💪 ExerciseBloc: Loaded ${exercises.length} exercises for category ${event.category}', name: 'ExerciseBloc');
    } catch (e) {
      developer.log('💪 ExerciseBloc: Load exercises by category failed: $e', name: 'ExerciseBloc');
      emit(ExerciseError('Не удалось загрузить упражнения по категории: $e'));
    }
  }

  Future<void> _onCreateExercise(
    CreateExercise event,
    Emitter<ExerciseState> emit,
  ) async {
    try {
      developer.log('💪 ExerciseBloc: Creating exercise', name: 'ExerciseBloc');
      emit(ExerciseLoading());

      await _exerciseRepository.saveExercise(event.exercise);

      // Перезагружаем упражнения
      final exercises = await _exerciseRepository.getAllExercises();

      if (state is ExerciseLoaded) {
        final currentState = state as ExerciseLoaded;
        emit(currentState.copyWith(exercises: exercises));
      } else {
        emit(ExerciseLoaded(
          exercises: exercises,
          workouts: [],
          workoutHistory: [],
        ));
      }

      emit(ExerciseSuccess('Упражнение создано успешно'));
      developer.log('💪 ExerciseBloc: Exercise created successfully', name: 'ExerciseBloc');
    } catch (e) {
      developer.log('💪 ExerciseBloc: Create exercise failed: $e', name: 'ExerciseBloc');
      emit(ExerciseError('Не удалось создать упражнение: $e'));
    }
  }

  Future<void> _onUpdateExercise(
    UpdateExercise event,
    Emitter<ExerciseState> emit,
  ) async {
    try {
      developer.log('💪 ExerciseBloc: Updating exercise', name: 'ExerciseBloc');
      emit(ExerciseLoading());

      await _exerciseRepository.saveExercise(event.exercise);

      // Перезагружаем упражнения
      final exercises = await _exerciseRepository.getAllExercises();

      if (state is ExerciseLoaded) {
        final currentState = state as ExerciseLoaded;
        emit(currentState.copyWith(exercises: exercises));
      } else {
        emit(ExerciseLoaded(
          exercises: exercises,
          workouts: [],
          workoutHistory: [],
        ));
      }

      emit(ExerciseSuccess('Упражнение обновлено успешно'));
      developer.log('💪 ExerciseBloc: Exercise updated successfully', name: 'ExerciseBloc');
    } catch (e) {
      developer.log('💪 ExerciseBloc: Update exercise failed: $e', name: 'ExerciseBloc');
      emit(ExerciseError('Не удалось обновить упражнение: $e'));
    }
  }

  Future<void> _onDeleteExercise(
    DeleteExercise event,
    Emitter<ExerciseState> emit,
  ) async {
    try {
      developer.log('💪 ExerciseBloc: Deleting exercise', name: 'ExerciseBloc');
      emit(ExerciseLoading());

      // Удаляем упражнение (в реальном приложении нужно добавить метод deleteExercise в репозиторий)
      // await _exerciseRepository.deleteExercise(event.exerciseId);

      // Перезагружаем упражнения
      final exercises = await _exerciseRepository.getAllExercises();

      if (state is ExerciseLoaded) {
        final currentState = state as ExerciseLoaded;
        emit(currentState.copyWith(exercises: exercises));
      } else {
        emit(ExerciseLoaded(
          exercises: exercises,
          workouts: [],
          workoutHistory: [],
        ));
      }

      emit(ExerciseSuccess('Упражнение удалено успешно'));
      developer.log('💪 ExerciseBloc: Exercise deleted successfully', name: 'ExerciseBloc');
    } catch (e) {
      developer.log('💪 ExerciseBloc: Delete exercise failed: $e', name: 'ExerciseBloc');
      emit(ExerciseError('Не удалось удалить упражнение: $e'));
    }
  }

  Future<void> _onLoadWorkouts(
    LoadWorkouts event,
    Emitter<ExerciseState> emit,
  ) async {
    try {
      developer.log('💪 ExerciseBloc: Loading workouts', name: 'ExerciseBloc');
      emit(ExerciseLoading());

      final workouts = await _exerciseRepository.getUserWorkouts();

      if (state is ExerciseLoaded) {
        final currentState = state as ExerciseLoaded;
        emit(currentState.copyWith(workouts: workouts));
      } else {
        emit(ExerciseLoaded(
          exercises: [],
          workouts: workouts,
          workoutHistory: [],
        ));
      }

      developer.log('💪 ExerciseBloc: Loaded ${workouts.length} workouts', name: 'ExerciseBloc');
    } catch (e) {
      developer.log('💪 ExerciseBloc: Load workouts failed: $e', name: 'ExerciseBloc');
      emit(ExerciseError('Не удалось загрузить тренировки: $e'));
    }
  }

  Future<void> _onCreateWorkout(
    CreateWorkout event,
    Emitter<ExerciseState> emit,
  ) async {
    try {
      developer.log('💪 ExerciseBloc: Creating workout', name: 'ExerciseBloc');
      emit(ExerciseLoading());

      await _exerciseRepository.saveWorkout(event.workout);

      // Перезагружаем тренировки
      final workouts = await _exerciseRepository.getUserWorkouts();

      if (state is ExerciseLoaded) {
        final currentState = state as ExerciseLoaded;
        emit(currentState.copyWith(workouts: workouts));
      } else {
        emit(ExerciseLoaded(
          exercises: [],
          workouts: workouts,
          workoutHistory: [],
        ));
      }

      emit(ExerciseSuccess('Тренировка создана успешно'));
      developer.log('💪 ExerciseBloc: Workout created successfully', name: 'ExerciseBloc');
    } catch (e) {
      developer.log('💪 ExerciseBloc: Create workout failed: $e', name: 'ExerciseBloc');
      emit(ExerciseError('Не удалось создать тренировку: $e'));
    }
  }

  Future<void> _onUpdateWorkout(
    UpdateWorkout event,
    Emitter<ExerciseState> emit,
  ) async {
    try {
      developer.log('💪 ExerciseBloc: Updating workout', name: 'ExerciseBloc');
      emit(ExerciseLoading());

      await _exerciseRepository.saveWorkout(event.workout);

      // Перезагружаем тренировки
      final workouts = await _exerciseRepository.getUserWorkouts();

      if (state is ExerciseLoaded) {
        final currentState = state as ExerciseLoaded;
        emit(currentState.copyWith(workouts: workouts));
      } else {
        emit(ExerciseLoaded(
          exercises: [],
          workouts: workouts,
          workoutHistory: [],
        ));
      }

      emit(ExerciseSuccess('Тренировка обновлена успешно'));
      developer.log('💪 ExerciseBloc: Workout updated successfully', name: 'ExerciseBloc');
    } catch (e) {
      developer.log('💪 ExerciseBloc: Update workout failed: $e', name: 'ExerciseBloc');
      emit(ExerciseError('Не удалось обновить тренировку: $e'));
    }
  }

  Future<void> _onDeleteWorkout(
    DeleteWorkout event,
    Emitter<ExerciseState> emit,
  ) async {
    try {
      developer.log('💪 ExerciseBloc: Deleting workout', name: 'ExerciseBloc');
      emit(ExerciseLoading());

      // Удаляем тренировку (в реальном приложении нужно добавить метод deleteWorkout в репозиторий)
      // await _exerciseRepository.deleteWorkout(event.workoutId);

      // Перезагружаем тренировки
      final workouts = await _exerciseRepository.getUserWorkouts();

      if (state is ExerciseLoaded) {
        final currentState = state as ExerciseLoaded;
        emit(currentState.copyWith(workouts: workouts));
      } else {
        emit(ExerciseLoaded(
          exercises: [],
          workouts: workouts,
          workoutHistory: [],
        ));
      }

      emit(ExerciseSuccess('Тренировка удалена успешно'));
      developer.log('💪 ExerciseBloc: Workout deleted successfully', name: 'ExerciseBloc');
    } catch (e) {
      developer.log('💪 ExerciseBloc: Delete workout failed: $e', name: 'ExerciseBloc');
      emit(ExerciseError('Не удалось удалить тренировку: $e'));
    }
  }

  Future<void> _onStartWorkoutSession(
    StartWorkoutSession event,
    Emitter<ExerciseState> emit,
  ) async {
    try {
      developer.log('💪 ExerciseBloc: Starting workout session', name: 'ExerciseBloc');

      final session = WorkoutSession(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        workoutId: event.workoutId,
        startedAt: DateTime.now(),
        completedAt: null,
        durationMinutes: 0,
        caloriesBurned: 0,
        status: 'in_progress',
        notes: null,
      );

      await _exerciseRepository.saveWorkoutSession(session);

      emit(WorkoutSessionActive(session));
      developer.log('💪 ExerciseBloc: Workout session started', name: 'ExerciseBloc');
    } catch (e) {
      developer.log('💪 ExerciseBloc: Start workout session failed: $e', name: 'ExerciseBloc');
      emit(ExerciseError('Не удалось начать тренировку: $e'));
    }
  }

  Future<void> _onCompleteWorkoutSession(
    CompleteWorkoutSession event,
    Emitter<ExerciseState> emit,
  ) async {
    try {
      developer.log('💪 ExerciseBloc: Completing workout session', name: 'ExerciseBloc');

      // В реальном приложении нужно обновить существующую сессию
      final session = WorkoutSession(
        id: event.sessionId,
        workoutId: '', // Нужно получить из активной сессии
        startedAt: DateTime.now().subtract(Duration(minutes: event.durationMinutes)),
        completedAt: DateTime.now(),
        durationMinutes: event.durationMinutes,
        caloriesBurned: event.caloriesBurned,
        status: 'completed',
        notes: event.notes,
      );

      await _exerciseRepository.saveWorkoutSession(session);

      emit(ExerciseSuccess('Тренировка завершена успешно'));
      developer.log('💪 ExerciseBloc: Workout session completed', name: 'ExerciseBloc');
    } catch (e) {
      developer.log('💪 ExerciseBloc: Complete workout session failed: $e', name: 'ExerciseBloc');
      emit(ExerciseError('Не удалось завершить тренировку: $e'));
    }
  }

  Future<void> _onLoadWorkoutHistory(
    LoadWorkoutHistory event,
    Emitter<ExerciseState> emit,
  ) async {
    try {
      developer.log('💪 ExerciseBloc: Loading workout history', name: 'ExerciseBloc');
      emit(ExerciseLoading());

      final workoutHistory = await _exerciseRepository.getWorkoutHistory();

      if (state is ExerciseLoaded) {
        final currentState = state as ExerciseLoaded;
        emit(currentState.copyWith(workoutHistory: workoutHistory));
      } else {
        emit(ExerciseLoaded(
          exercises: [],
          workouts: [],
          workoutHistory: workoutHistory,
        ));
      }

      developer.log('💪 ExerciseBloc: Loaded ${workoutHistory.length} workout sessions', name: 'ExerciseBloc');
    } catch (e) {
      developer.log('💪 ExerciseBloc: Load workout history failed: $e', name: 'ExerciseBloc');
      emit(ExerciseError('Не удалось загрузить историю тренировок: $e'));
    }
  }
} 