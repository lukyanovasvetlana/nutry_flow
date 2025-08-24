import 'dart:io';
import '../models/user_profile_model.dart';
import '../../domain/entities/user_profile.dart';

/// Синхронная версия MockProfileService для тестирования
/// 
/// Этот сервис не использует Future.delayed, что позволяет избежать
/// проблем с pending timers в тестах Flutter.
/// 
/// Использование:
/// ```dart
/// final profileService = SyncMockProfileService();
/// final profile = await profileService.getCurrentUserProfile();
/// ```
class SyncMockProfileService {
  static final Map<String, UserProfileModel> _profiles = {};
  static final Map<String, String> _avatars = {};
  
  static final UserProfileModel _demoProfile = UserProfileModel(
    id: 'demo-user-id',
    firstName: 'Демо',
    lastName: 'Пользователь',
    email: 'demo@nutryflow.com',
    phone: '+7 900 123-45-67',
    dateOfBirth: DateTime(1990, 5, 15),
    gender: Gender.female,
    height: 165.0,
    weight: 60.0,
    activityLevel: ActivityLevel.moderatelyActive,
    avatarUrl: 'https://example.com/avatars/demo.jpg',
    dietaryPreferences: [DietaryPreference.vegetarian, DietaryPreference.glutenFree],
    allergies: ['nuts'],
    healthConditions: [],
    fitnessGoals: ['weight_loss', 'muscle_gain'],
    targetWeight: 55.0,
    targetCalories: 1800,
    targetProtein: 120,
    targetCarbs: 200,
    targetFat: 60,
    foodRestrictions: 'Не ем орехи',
    pushNotificationsEnabled: true,
    emailNotificationsEnabled: false,
    createdAt: DateTime.now().subtract(const Duration(days: 30)),
    updatedAt: DateTime.now().subtract(const Duration(days: 1)),
  );

  /// Инициализация сервиса с демо-данными
  static void initialize() {
    _profiles['demo-user-id'] = _demoProfile;
    _avatars['demo-user-id'] = 'https://example.com/avatars/demo.jpg';
  }

  /// Получает профиль текущего пользователя (синхронно)
  /// 
  /// Returns профиль демо-пользователя или null
  Future<UserProfileModel?> getCurrentUserProfile() async {
    return _demoProfile;
  }

  /// Получает профиль пользователя по ID (синхронно)
  /// 
  /// [userId] - уникальный идентификатор пользователя
  /// 
  /// Returns профиль пользователя или null если не найден
  Future<UserProfileModel?> getUserProfile(String userId) async {
    return _profiles[userId];
  }

  /// Создает новый профиль пользователя (синхронно)
  /// 
  /// [profile] - данные профиля для создания
  /// 
  /// Returns созданный профиль с обновленными датами
  /// 
  /// Throws [Exception] если профиль уже существует
  Future<UserProfileModel> createUserProfile(UserProfileModel profile) async {
    if (_profiles.containsKey(profile.id)) {
      throw Exception('Profile already exists');
    }

    final newProfile = profile.copyWith(
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _profiles[profile.id] = newProfile;
    return newProfile;
  }

  /// Обновляет существующий профиль пользователя (синхронно)
  /// 
  /// [profile] - обновленные данные профиля
  /// 
  /// Returns обновленный профиль
  /// 
  /// Throws [Exception] если профиль не найден
  Future<UserProfileModel> updateUserProfile(UserProfileModel profile) async {
    if (!_profiles.containsKey(profile.id)) {
      throw Exception('Profile not found');
    }

    final updatedProfile = profile.copyWith(
      updatedAt: DateTime.now(),
    );

    _profiles[profile.id] = updatedProfile;
    return updatedProfile;
  }

  /// Удаляет профиль пользователя (синхронно)
  /// 
  /// [userId] - уникальный идентификатор пользователя
  /// 
  /// Throws [Exception] если профиль не найден
  Future<void> deleteUserProfile(String userId) async {
    if (!_profiles.containsKey(userId)) {
      throw Exception('Profile not found');
    }

    _profiles.remove(userId);
    _avatars.remove(userId);
  }

  /// Проверяет доступность email (синхронно)
  /// 
  /// [email] - email для проверки
  /// 
  /// Returns true если email доступен для регистрации
  Future<bool> isEmailAvailable(String email) async {
    return !_profiles.values.any((profile) => profile.email == email);
  }

  /// Получает статистику профилей (синхронно)
  /// 
  /// [userId] - идентификатор пользователя
  /// 
  /// Returns карта со статистикой профиля
  Future<Map<String, dynamic>> getProfileStatistics(String userId) async {
    final profile = _profiles[userId];
    if (profile == null) {
      throw Exception('Profile not found');
    }

    return {
      'profile_completeness': profile.profileCompleteness,
      'days_since_created': DateTime.now().difference(profile.createdAt!).inDays,
      'last_updated': profile.updatedAt,
      'has_avatar': profile.avatarUrl != null,
      'goals_count': profile.fitnessGoals.length,
      'dietary_preferences_count': profile.dietaryPreferences.length,
      'allergies_count': profile.allergies.length,
      'health_conditions_count': profile.healthConditions.length,
    };
  }

  /// Экспортирует данные профиля (синхронно)
  /// 
  /// [userId] - идентификатор пользователя
  /// 
  /// Returns карта с данными профиля для экспорта
  Future<Map<String, dynamic>> exportProfileData(String userId) async {
    final profile = _profiles[userId];
    if (profile == null) {
      throw Exception('Profile not found');
    }

    final statistics = await getProfileStatistics(userId);

    return {
      'profile': profile.toJson(),
      'statistics': statistics,
      'exported_at': DateTime.now().toIso8601String(),
      'export_version': '1.0.0',
    };
  }

  /// Очищает все данные (для тестирования)
  static void clearAll() {
    _profiles.clear();
    _avatars.clear();
  }

  /// Получает количество профилей (для тестирования)
  static int get profileCount => _profiles.length;

  /// Добавляет тестовый профиль (для тестирования)
  static void addTestProfile(UserProfileModel profile) {
    _profiles[profile.id] = profile;
  }
}
