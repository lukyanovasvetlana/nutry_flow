import '../entities/user_profile.dart';

/// Интерфейс репозитория для управления профилем пользователя
abstract class ProfileRepository {
  /// Получает профиль текущего пользователя
  /// Возвращает профиль или null, если профиль не найден
  Future<UserProfile?> getCurrentUserProfile();
  
  /// Получает профиль пользователя по ID
  /// [userId] - идентификатор пользователя
  /// Возвращает профиль или null, если профиль не найден
  Future<UserProfile?> getUserProfile(String userId);
  
  /// Создает новый профиль пользователя
  /// [profile] - данные профиля для создания
  /// Возвращает созданный профиль
  Future<UserProfile> createUserProfile(UserProfile profile);
  
  /// Обновляет существующий профиль пользователя
  /// [profile] - обновленные данные профиля
  /// Возвращает обновленный профиль
  Future<UserProfile> updateUserProfile(UserProfile profile);
  
  /// Удаляет профиль пользователя
  /// [userId] - идентификатор пользователя
  Future<void> deleteUserProfile(String userId);
  
  /// Загружает аватар пользователя
  /// [userId] - идентификатор пользователя
  /// [imagePath] - локальный путь к изображению
  /// Возвращает URL загруженного аватара
  Future<String> uploadAvatar(String userId, String imagePath);
  
  /// Удаляет аватар пользователя
  /// [userId] - идентификатор пользователя
  Future<void> deleteAvatar(String userId);
  
  /// Проверяет доступность email для регистрации
  /// [email] - email для проверки
  /// [excludeUserId] - ID пользователя для исключения из проверки (при обновлении)
  /// Возвращает true, если email доступен
  Future<bool> isEmailAvailable(String email, {String? excludeUserId});
  
  /// Получает статистику профиля
  /// [userId] - идентификатор пользователя
  /// Возвращает карту со статистикой
  Future<Map<String, dynamic>> getProfileStatistics(String userId);
  
  /// Экспортирует данные профиля
  /// [userId] - идентификатор пользователя
  /// Возвращает карту с данными профиля
  Future<Map<String, dynamic>> exportProfileData(String userId);
} 