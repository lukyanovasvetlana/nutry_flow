import '../../domain/entities/user_profile.dart';

/// Интерфейс репозитория профиля пользователя
abstract class ProfileRepository {
  /// Получает профиль текущего пользователя
  Future<UserProfile?> getCurrentUserProfile();

  /// Получает профиль пользователя по ID
  Future<UserProfile?> getUserProfile(String userId);

  /// Создает новый профиль пользователя
  Future<UserProfile> createUserProfile(UserProfile profile);

  /// Обновляет существующий профиль пользователя
  Future<UserProfile> updateUserProfile(UserProfile profile);

  /// Удаляет профиль пользователя
  Future<void> deleteUserProfile(String userId);

  /// Проверяет доступность email для регистрации
  Future<bool> isEmailAvailable(String email);

  /// Получает статистику профиля
  Future<Map<String, dynamic>> getProfileStatistics(String userId);

  /// Экспортирует данные профиля
  Future<Map<String, dynamic>> exportProfileData(String userId);
}
