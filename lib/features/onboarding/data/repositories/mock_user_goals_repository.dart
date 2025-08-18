import '../../domain/repositories/user_goals_repository.dart';
import '../../domain/entities/user_goals.dart';

/// Мок-реализация репозитория для работы с целями пользователя
/// Имитирует работу с Supabase без реального подключения
class MockUserGoalsRepository implements UserGoalsRepository {
  static final Map<String, UserGoals> _userGoals = {}; // userId -> UserGoals

  @override
  Future<UserGoals> saveUserGoals(UserGoals goals, String userId) async {
    // Имитируем задержку сети
    await Future.delayed(const Duration(milliseconds: 800));

    // Сохраняем цели в "памяти"
    _userGoals[userId] = goals;

    return goals;
  }

  @override
  Future<UserGoals?> getUserGoals(String userId) async {
    // Имитируем задержку сети
    await Future.delayed(const Duration(milliseconds: 500));

    final goals = _userGoals[userId];

    if (goals != null) {
    } else {}

    return goals;
  }

  @override
  Future<UserGoals> updateUserGoals(UserGoals goals, String userId) async {
    // Имитируем задержку сети
    await Future.delayed(const Duration(milliseconds: 700));

    // Обновляем цели в "памяти"
    _userGoals[userId] = goals;

    return goals;
  }

  @override
  Future<bool> deleteUserGoals(String userId) async {
    // Имитируем задержку сети
    await Future.delayed(const Duration(milliseconds: 400));

    // Удаляем цели из "памяти"
    final removed = _userGoals.remove(userId) != null;

    if (removed) {
    } else {}

    return removed;
  }

  /// Очищает все сохраненные цели (для тестирования)
  static void clearAll() {
    _userGoals.clear();
  }

  /// Получает количество сохраненных целей (для отладки)
  static int getStoredGoalsCount() {
    return _userGoals.length;
  }
}
