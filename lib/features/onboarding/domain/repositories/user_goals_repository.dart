import '../entities/user_goals.dart';

/// Интерфейс репозитория для работы с целями пользователя
/// Определяет контракт для сохранения и получения пользовательских целей
abstract class UserGoalsRepository {
  /// Сохраняет цели пользователя
  /// [goals] - цели пользователя для сохранения
  /// [userId] - идентификатор пользователя
  /// Возвращает сохраненные цели или выбрасывает исключение
  Future<UserGoals> saveUserGoals(UserGoals goals, String userId);
  
  /// Получает цели пользователя по ID
  /// [userId] - идентификатор пользователя
  /// Возвращает цели пользователя или null, если не найдены
  Future<UserGoals?> getUserGoals(String userId);
  
  /// Обновляет существующие цели пользователя
  /// [goals] - обновленные цели
  /// [userId] - идентификатор пользователя
  /// Возвращает обновленные цели
  Future<UserGoals> updateUserGoals(UserGoals goals, String userId);
  
  /// Удаляет цели пользователя
  /// [userId] - идентификатор пользователя
  /// Возвращает true при успешном удалении
  Future<bool> deleteUserGoals(String userId);
} 