import '../entities/exercise.dart';
import '../repositories/exercise_repository.dart';

/// Use case для получения упражнений по категории
class GetExercisesByCategoryUseCase {
  final ExerciseRepository _repository;

  GetExercisesByCategoryUseCase(this._repository);

  Future<List<Exercise>> call(String category) {
    return _repository.getExercisesByCategory(category);
  }
}
