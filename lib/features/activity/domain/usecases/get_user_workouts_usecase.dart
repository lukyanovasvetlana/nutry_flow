import 'package:dartz/dartz.dart';
import '../entities/workout.dart';
import '../repositories/workout_repository.dart';

class GetUserWorkoutsUseCase {
  final WorkoutRepository _repository;

  GetUserWorkoutsUseCase(this._repository);

  Future<Either<String, List<Workout>>> execute(String userId) async {
    return _repository.getUserWorkouts(userId);
  }
}
