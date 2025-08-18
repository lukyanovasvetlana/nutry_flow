import 'package:dartz/dartz.dart';
import '../entities/exercise.dart';

abstract class ExerciseRepository {
  Future<Either<String, List<Exercise>>> getAllExercises();
  Future<Either<String, Exercise?>> getExerciseById(String id);
  Future<Either<String, List<Exercise>>> searchExercises(String query);
  Future<Either<String, List<Exercise>>> filterByCategory(String category);
  Future<Either<String, List<Exercise>>> filterByDifficulty(String difficulty);
  Future<Either<String, List<Exercise>>> getFavoriteExercises(String userId);
  Future<Either<String, void>> toggleFavorite(String userId, String exerciseId);
  Future<Either<String, List<String>>> getCategories();
  Future<Either<String, List<String>>> getDifficulties();
}
