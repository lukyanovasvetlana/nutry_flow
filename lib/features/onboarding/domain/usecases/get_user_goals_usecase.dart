import '../entities/user_goals.dart';
import '../repositories/user_goals_repository.dart';
import '../repositories/auth_repository.dart';

/// Результат получения целей пользователя
class GetUserGoalsResult {
  final UserGoals? goals;
  final String? error;
  final bool isSuccess;

  const GetUserGoalsResult.success(this.goals)
      : error = null,
        isSuccess = true;

  const GetUserGoalsResult.failure(this.error)
      : goals = null,
        isSuccess = false;

  const GetUserGoalsResult.notFound()
      : goals = null,
        error = null,
        isSuccess = true;
}

/// Use case для получения пользовательских целей
class GetUserGoalsUseCase {
  final UserGoalsRepository _userGoalsRepository;
  final AuthRepository _authRepository;

  const GetUserGoalsUseCase(
    this._userGoalsRepository,
    this._authRepository,
  );

  /// Получает цели текущего пользователя
  /// Возвращает результат операции
  Future<GetUserGoalsResult> execute() async {
    try {
      // Получение текущего пользователя
      final currentUser = await _authRepository.getCurrentUser();
      if (currentUser == null) {
        return const GetUserGoalsResult.failure(
            'Пользователь не аутентифицирован');
      }

      // Получение целей
      final goals = await _userGoalsRepository.getUserGoals(currentUser.id);

      if (goals == null) {
        return const GetUserGoalsResult.notFound();
      }

      return GetUserGoalsResult.success(goals);
    } catch (e) {
      return GetUserGoalsResult.failure(
          'Ошибка при получении целей: ${e.toString()}');
    }
  }
}
