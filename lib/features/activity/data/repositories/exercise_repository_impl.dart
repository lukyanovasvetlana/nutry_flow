import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/exercise.dart';
import '../../domain/repositories/exercise_repository.dart';
import '../services/supabase_exercise_service.dart';

@Injectable(as: ExerciseRepository)
class ExerciseRepositoryImpl implements ExerciseRepository {
  final SupabaseExerciseService _exerciseService;

  ExerciseRepositoryImpl(this._exerciseService);

  @override
  Future<Either<String, List<Exercise>>> getAllExercises() async {
    try {
      final exercises = await _exerciseService.getAllExercises();
      return Right(exercises);
    } catch (e) {
      return Left('Ошибка при получении упражнений: $e');
    }
  }

  @override
  Future<Either<String, Exercise?>> getExerciseById(String id) async {
    try {
      final exercise = await _exerciseService.getExerciseById(id);
      return Right(exercise);
    } catch (e) {
      return Left('Ошибка при получении упражнения: $e');
    }
  }

  @override
  Future<Either<String, List<Exercise>>> searchExercises(String query) async {
    try {
      final exercises = await _exerciseService.searchExercises(query);
      return Right(exercises);
    } catch (e) {
      return Left('Ошибка при поиске упражнений: $e');
    }
  }

  @override
  Future<Either<String, List<Exercise>>> filterByCategory(
      String category) async {
    try {
      if (category == 'All') {
        return await getAllExercises();
      }
      final exercises = await _exerciseService.filterByCategory(category);
      return Right(exercises);
    } catch (e) {
      return Left('Ошибка при фильтрации по категории: $e');
    }
  }

  @override
  Future<Either<String, List<Exercise>>> filterByDifficulty(
      String difficulty) async {
    try {
      if (difficulty == 'All') {
        return await getAllExercises();
      }
      final exercises = await _exerciseService.filterByDifficulty(difficulty);
      return Right(exercises);
    } catch (e) {
      return Left('Ошибка при фильтрации по сложности: $e');
    }
  }

  @override
  Future<Either<String, List<Exercise>>> getFavoriteExercises(
      String userId) async {
    try {
      final exercises = await _exerciseService.getFavoriteExercises(userId);
      return Right(exercises);
    } catch (e) {
      return Left('Ошибка при получении избранных упражнений: $e');
    }
  }

  @override
  Future<Either<String, void>> toggleFavorite(
      String userId, String exerciseId) async {
    try {
      await _exerciseService.toggleFavorite(userId, exerciseId);
      return const Right(null);
    } catch (e) {
      return Left('Ошибка при изменении избранного: $e');
    }
  }

  @override
  Future<Either<String, List<String>>> getCategories() async {
    try {
      final categories = await _exerciseService.getCategories();
      return Right(categories);
    } catch (e) {
      return Left('Ошибка при получении категорий: $e');
    }
  }

  @override
  Future<Either<String, List<String>>> getDifficulties() async {
    try {
      final difficulties = await _exerciseService.getDifficulties();
      return Right(difficulties);
    } catch (e) {
      return Left('Ошибка при получении уровней сложности: $e');
    }
  }
}
