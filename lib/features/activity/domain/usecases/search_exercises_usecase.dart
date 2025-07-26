import 'package:dartz/dartz.dart';
import '../entities/exercise.dart';
import '../repositories/exercise_repository.dart';

class SearchExercisesUseCase {
  final ExerciseRepository _repository;

  SearchExercisesUseCase(this._repository);

  Future<Either<String, List<Exercise>>> execute(String query) async {
    if (query.trim().isEmpty) {
      return await _repository.getAllExercises();
    }
    return await _repository.searchExercises(query.trim());
  }
} 