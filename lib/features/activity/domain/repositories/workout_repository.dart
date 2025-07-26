import 'package:dartz/dartz.dart';
import '../entities/workout.dart';

abstract class WorkoutRepository {
  Future<Either<String, List<Workout>>> getUserWorkouts(String userId);
  Future<Either<String, Workout?>> getWorkoutById(String id);
  Future<Either<String, List<Workout>>> getWorkoutTemplates(String userId);
  Future<Either<String, Workout>> createWorkout(Workout workout);
  Future<Either<String, Workout>> updateWorkout(Workout workout);
  Future<Either<String, void>> deleteWorkout(String id);
  Future<Either<String, void>> saveAsTemplate(String workoutId);
  Future<Either<String, List<Workout>>> searchWorkouts(String userId, String query);
  Future<Either<String, List<Workout>>> filterWorkoutsByDifficulty(String userId, String difficulty);
} 