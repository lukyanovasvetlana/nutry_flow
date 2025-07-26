import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../entities/workout.dart';
import '../repositories/workout_repository.dart';

@injectable
class GetUserWorkoutsUseCase {
  final WorkoutRepository repository;

  GetUserWorkoutsUseCase(this.repository);

  Future<Either<String, List<Workout>>> call(String userId) async {
    return await repository.getUserWorkouts(userId);
  }
}

@injectable
class GetWorkoutByIdUseCase {
  final WorkoutRepository repository;

  GetWorkoutByIdUseCase(this.repository);

  Future<Either<String, Workout?>> call(String id) async {
    return await repository.getWorkoutById(id);
  }
}

@injectable
class GetWorkoutTemplatesUseCase {
  final WorkoutRepository repository;

  GetWorkoutTemplatesUseCase(this.repository);

  Future<Either<String, List<Workout>>> call(String userId) async {
    return await repository.getWorkoutTemplates(userId);
  }
}

@injectable
class CreateWorkoutUseCase {
  final WorkoutRepository repository;

  CreateWorkoutUseCase(this.repository);

  Future<Either<String, Workout>> call(Workout workout) async {
    return await repository.createWorkout(workout);
  }
}

@injectable
class UpdateWorkoutUseCase {
  final WorkoutRepository repository;

  UpdateWorkoutUseCase(this.repository);

  Future<Either<String, Workout>> call(Workout workout) async {
    return await repository.updateWorkout(workout);
  }
}

@injectable
class DeleteWorkoutUseCase {
  final WorkoutRepository repository;

  DeleteWorkoutUseCase(this.repository);

  Future<Either<String, void>> call(String id) async {
    return await repository.deleteWorkout(id);
  }
}

@injectable
class SaveWorkoutAsTemplateUseCase {
  final WorkoutRepository repository;

  SaveWorkoutAsTemplateUseCase(this.repository);

  Future<Either<String, void>> call(String workoutId) async {
    return await repository.saveAsTemplate(workoutId);
  }
}

@injectable
class SearchWorkoutsUseCase {
  final WorkoutRepository repository;

  SearchWorkoutsUseCase(this.repository);

  Future<Either<String, List<Workout>>> call(String userId, String query) async {
    if (query.trim().isEmpty) {
      return await repository.getUserWorkouts(userId);
    }
    return await repository.searchWorkouts(userId, query.trim());
  }
}

@injectable
class FilterWorkoutsByDifficultyUseCase {
  final WorkoutRepository repository;

  FilterWorkoutsByDifficultyUseCase(this.repository);

  Future<Either<String, List<Workout>>> call(String userId, String difficulty) async {
    return await repository.filterWorkoutsByDifficulty(userId, difficulty);
  }
} 