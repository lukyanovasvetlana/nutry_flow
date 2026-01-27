import '../entities/exercise.dart';
import '../repositories/exercise_repository.dart';

/// Use case для сохранения упражнения
class SaveExerciseUseCase {
  final ExerciseRepository _repository;

  SaveExerciseUseCase(this._repository);

  Future<void> call(Exercise exercise) {
    return _repository.saveExercise(exercise);
  }
}
