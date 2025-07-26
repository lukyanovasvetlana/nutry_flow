import 'package:dartz/dartz.dart';
import '../entities/exercise.dart';
import '../repositories/exercise_repository.dart';

class GetAllExercisesUseCase {
  final ExerciseRepository _repository;

  GetAllExercisesUseCase(this._repository);

  Future<Either<String, List<Exercise>>> execute() async {
    return await _repository.getAllExercises();
  }
} 