import '../repositories/exercise_repository.dart';

/// Use case для удаления упражнения
class DeleteExerciseUseCase {
  final ExerciseRepository _repository;

  DeleteExerciseUseCase(this._repository);

  Future<void> call(String exerciseId) {
    return _repository.deleteExercise(exerciseId);
  }
}
