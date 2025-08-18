import '../entities/user_goals.dart';
import '../repositories/user_goals_repository.dart';
import '../repositories/auth_repository.dart';

/// Результат выполнения SaveUserGoalsUseCase
class SaveUserGoalsResult {
  final bool isSuccess;
  final String? error;

  SaveUserGoalsResult._({
    required this.isSuccess,
    this.error,
  });

  factory SaveUserGoalsResult.success() {
    return SaveUserGoalsResult._(isSuccess: true);
  }

  factory SaveUserGoalsResult.failure(String error) {
    return SaveUserGoalsResult._(isSuccess: false, error: error);
  }
}

/// Use case для сохранения целей пользователя
class SaveUserGoalsUseCase {
  final UserGoalsRepository _userGoalsRepository;
  final AuthRepository _authRepository;

  SaveUserGoalsUseCase(this._userGoalsRepository, this._authRepository);

  /// Сохраняет цели пользователя
  Future<SaveUserGoalsResult> execute(UserGoals goals) async {
    try {
      // Валидация целей
      if (!goals.isValid) {
        return SaveUserGoalsResult.failure('Invalid goals data');
      }

      // Получаем текущего пользователя
      final currentUser = await _authRepository.getCurrentUser();
      if (currentUser == null) {
        return SaveUserGoalsResult.failure('User not authenticated');
      }

      // Валидация бизнес-правил
      final validationError = _validateBusinessRules(goals);
      if (validationError != null) {
        return SaveUserGoalsResult.failure(validationError);
      }

      // Сохраняем цели
      await _userGoalsRepository.saveUserGoals(goals, currentUser.id);

      return SaveUserGoalsResult.success();
    } catch (e) {
      return SaveUserGoalsResult.failure('Failed to save goals: $e');
    }
  }

  /// Валидация бизнес-правил
  String? _validateBusinessRules(UserGoals goals) {
    // Проверка целевого веса
    if (goals.targetWeight != null) {
      if (goals.targetWeight! < 30 || goals.targetWeight! > 300) {
        return 'Target weight must be between 30 and 300 kg';
      }
    }

    // Проверка целевых калорий
    if (goals.targetCalories != null) {
      if (goals.targetCalories! < 800 || goals.targetCalories! > 5000) {
        return 'Target calories must be between 800 and 5000';
      }
    }

    return null;
  }
}
