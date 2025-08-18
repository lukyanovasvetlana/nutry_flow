import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/workout.dart';
import '../../domain/repositories/workout_repository.dart';
import '../services/supabase_workout_service.dart';

@Injectable(as: WorkoutRepository)
class WorkoutRepositoryImpl implements WorkoutRepository {
  final SupabaseWorkoutService _workoutService;

  WorkoutRepositoryImpl(this._workoutService);

  @override
  Future<Either<String, List<Workout>>> getUserWorkouts(String userId) async {
    try {
      final workouts = await _workoutService.getUserWorkouts(userId);
      return Right(workouts);
    } catch (e) {
      return Left('Ошибка при получении тренировок: $e');
    }
  }

  @override
  Future<Either<String, Workout?>> getWorkoutById(String id) async {
    try {
      final workout = await _workoutService.getWorkoutById(id);
      return Right(workout);
    } catch (e) {
      return Left('Ошибка при получении тренировки: $e');
    }
  }

  @override
  Future<Either<String, List<Workout>>> getWorkoutTemplates(
      String userId) async {
    try {
      final templates = await _workoutService.getWorkoutTemplates(userId);
      return Right(templates);
    } catch (e) {
      return Left('Ошибка при получении шаблонов: $e');
    }
  }

  @override
  Future<Either<String, Workout>> createWorkout(Workout workout) async {
    try {
      final createdWorkout = await _workoutService.createWorkout(workout);
      return Right(createdWorkout);
    } catch (e) {
      return Left('Ошибка при создании тренировки: $e');
    }
  }

  @override
  Future<Either<String, Workout>> updateWorkout(Workout workout) async {
    try {
      final updatedWorkout = await _workoutService.updateWorkout(workout);
      return Right(updatedWorkout);
    } catch (e) {
      return Left('Ошибка при обновлении тренировки: $e');
    }
  }

  @override
  Future<Either<String, void>> deleteWorkout(String id) async {
    try {
      await _workoutService.deleteWorkout(id);
      return const Right(null);
    } catch (e) {
      return Left('Ошибка при удалении тренировки: $e');
    }
  }

  @override
  Future<Either<String, void>> saveAsTemplate(String workoutId) async {
    try {
      await _workoutService.saveAsTemplate(workoutId);
      return const Right(null);
    } catch (e) {
      return Left('Ошибка при сохранении шаблона: $e');
    }
  }

  @override
  Future<Either<String, List<Workout>>> searchWorkouts(
      String userId, String query) async {
    try {
      if (query.trim().isEmpty) {
        return await getUserWorkouts(userId);
      }
      final workouts =
          await _workoutService.searchWorkouts(userId, query.trim());
      return Right(workouts);
    } catch (e) {
      return Left('Ошибка при поиске тренировок: $e');
    }
  }

  @override
  Future<Either<String, List<Workout>>> filterWorkoutsByDifficulty(
      String userId, String difficulty) async {
    try {
      final workouts =
          await _workoutService.filterWorkoutsByDifficulty(userId, difficulty);
      return Right(workouts);
    } catch (e) {
      return Left('Ошибка при фильтрации тренировок: $e');
    }
  }
}
