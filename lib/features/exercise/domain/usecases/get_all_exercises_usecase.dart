import '../entities/exercise.dart';
import '../repositories/exercise_repository.dart';

/// Use case для получения всех упражнений
class GetAllExercisesUseCase {
  final ExerciseRepository _repository;

  GetAllExercisesUseCase(this._repository);

  Future<List<Exercise>> call() {
    return _repository.getAllExercises();
  }
}
