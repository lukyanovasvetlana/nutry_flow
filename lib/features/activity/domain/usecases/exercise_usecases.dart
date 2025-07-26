import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../entities/exercise.dart';
import '../repositories/exercise_repository.dart';

@injectable
class GetExercisesUseCase {
  final ExerciseRepository repository;

  GetExercisesUseCase(this.repository);

  Future<Either<String, List<Exercise>>> call() async {
    return await repository.getAllExercises();
  }
}

@injectable
class GetExerciseByIdUseCase {
  final ExerciseRepository repository;

  GetExerciseByIdUseCase(this.repository);

  Future<Either<String, Exercise?>> call(String id) async {
    return await repository.getExerciseById(id);
  }
}

@injectable
class SearchExercisesUseCase {
  final ExerciseRepository repository;

  SearchExercisesUseCase(this.repository);

  Future<Either<String, List<Exercise>>> call(String query) async {
    if (query.trim().isEmpty) {
      return await repository.getAllExercises();
    }
    return await repository.searchExercises(query.trim());
  }
}

@injectable
class FilterExercisesByCategoryUseCase {
  final ExerciseRepository repository;

  FilterExercisesByCategoryUseCase(this.repository);

  Future<Either<String, List<Exercise>>> call(String category) async {
    return await repository.filterByCategory(category);
  }
}

@injectable
class FilterExercisesByDifficultyUseCase {
  final ExerciseRepository repository;

  FilterExercisesByDifficultyUseCase(this.repository);

  Future<Either<String, List<Exercise>>> call(String difficulty) async {
    return await repository.filterByDifficulty(difficulty);
  }
}

@injectable
class GetFavoriteExercisesUseCase {
  final ExerciseRepository repository;

  GetFavoriteExercisesUseCase(this.repository);

  Future<Either<String, List<Exercise>>> call(String userId) async {
    return await repository.getFavoriteExercises(userId);
  }
}

@injectable
class ToggleFavoriteExerciseUseCase {
  final ExerciseRepository repository;

  ToggleFavoriteExerciseUseCase(this.repository);

  Future<Either<String, void>> call(String userId, String exerciseId) async {
    return await repository.toggleFavorite(userId, exerciseId);
  }
}

@injectable
class GetExerciseCategoriesUseCase {
  final ExerciseRepository repository;

  GetExerciseCategoriesUseCase(this.repository);

  Future<Either<String, List<String>>> call() async {
    return await repository.getCategories();
  }
}

@injectable
class GetExerciseDifficultiesUseCase {
  final ExerciseRepository repository;

  GetExerciseDifficultiesUseCase(this.repository);

  Future<Either<String, List<String>>> call() async {
    return await repository.getDifficulties();
  }
} 