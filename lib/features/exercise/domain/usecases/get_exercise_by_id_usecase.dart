import '../entities/exercise.dart';
import '../repositories/exercise_repository.dart';

/// Use case для получения упражнения по ID
class GetExerciseByIdUseCase {
  final ExerciseRepository _repository;

  GetExerciseByIdUseCase(this._repository);

  Future<Exercise?> call(String id) {
    return _repository.getExerciseById(id);
  }
}
