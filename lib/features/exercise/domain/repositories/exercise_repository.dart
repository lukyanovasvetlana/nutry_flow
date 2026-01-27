import '../entities/exercise.dart';

/// Интерфейс репозитория для работы с упражнениями
abstract class ExerciseRepository {
  /// Сохранение упражнения
  Future<void> saveExercise(Exercise exercise);

  /// Получение всех упражнений
  Future<List<Exercise>> getAllExercises();

  /// Получение упражнений по категории
  Future<List<Exercise>> getExercisesByCategory(String category);

  /// Получение упражнения по ID
  Future<Exercise?> getExerciseById(String id);

  /// Удаление упражнения
  Future<void> deleteExercise(String exerciseId);
}
