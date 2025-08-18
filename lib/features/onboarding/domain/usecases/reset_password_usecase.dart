import 'package:dartz/dartz.dart';
import '../repositories/auth_repository.dart';
import '../../../../core/error/failures.dart';

class ResetPasswordUseCase {
  final AuthRepository repository;

  ResetPasswordUseCase(this.repository);

  Future<Either<Failure, void>> call(String email) async {
    try {
      await repository.resetPassword(email);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
