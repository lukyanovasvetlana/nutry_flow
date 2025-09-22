import '../../domain/repositories/profile_repository.dart';
import '../../domain/entities/user_profile.dart';
import '../models/user_profile_model.dart';
import '../services/sync_mock_profile_service.dart';

/// Адаптер для SyncMockProfileService, реализующий ProfileRepository
///
/// Этот класс обеспечивает совместимость между SyncMockProfileService
/// и интерфейсом ProfileRepository для dependency injection.
class SyncMockProfileRepository implements ProfileRepository {
  final SyncMockProfileService _service;

  /// Создает репозиторий с указанным сервисом
  ///
  /// [service] - экземпляр SyncMockProfileService
  const SyncMockProfileRepository(this._service);

  /// Создает репозиторий с новым экземпляром SyncMockProfileService
  factory SyncMockProfileRepository.create() {
    return SyncMockProfileRepository(SyncMockProfileService());
  }

  @override
  Future<UserProfile?> getCurrentUserProfile() async {
    return _service.getCurrentUserProfile();
  }

  @override
  Future<UserProfile?> getUserProfile(String userId) async {
    return _service.getUserProfile(userId);
  }

  @override
  Future<UserProfile> createUserProfile(UserProfile profile) async {
    // Создаем UserProfileModel напрямую из UserProfile
    final profileModel = UserProfileModel(
      id: profile.id,
      firstName: profile.firstName,
      lastName: profile.lastName,
      email: profile.email,
      phone: profile.phone,
      dateOfBirth: profile.dateOfBirth,
      gender: profile.gender,
      height: profile.height,
      weight: profile.weight,
      activityLevel: profile.activityLevel,
      avatarUrl: profile.avatarUrl,
      dietaryPreferences: profile.dietaryPreferences,
      allergies: profile.allergies,
      healthConditions: profile.healthConditions,
      fitnessGoals: profile.fitnessGoals,
      targetWeight: profile.targetWeight,
      targetCalories: profile.targetCalories,
      targetProtein: profile.targetProtein,
      targetCarbs: profile.targetCarbs,
      targetFat: profile.targetFat,
      foodRestrictions: profile.foodRestrictions,
      pushNotificationsEnabled: profile.pushNotificationsEnabled,
      emailNotificationsEnabled: profile.emailNotificationsEnabled,
      createdAt: profile.createdAt,
      updatedAt: profile.updatedAt,
    );
    final createdModel = await _service.createUserProfile(profileModel);
    // Конвертируем обратно в UserProfile
    return UserProfile(
      id: createdModel.id,
      firstName: createdModel.firstName,
      lastName: createdModel.lastName,
      email: createdModel.email,
      phone: createdModel.phone,
      dateOfBirth: createdModel.dateOfBirth,
      gender: createdModel.gender,
      height: createdModel.height,
      weight: createdModel.weight,
      activityLevel: createdModel.activityLevel,
      avatarUrl: createdModel.avatarUrl,
      dietaryPreferences: createdModel.dietaryPreferences,
      allergies: createdModel.allergies,
      healthConditions: createdModel.healthConditions,
      fitnessGoals: createdModel.fitnessGoals,
      targetWeight: createdModel.targetWeight,
      targetCalories: createdModel.targetCalories,
      targetProtein: createdModel.targetProtein,
      targetCarbs: createdModel.targetCarbs,
      targetFat: createdModel.targetFat,
      foodRestrictions: createdModel.foodRestrictions,
      pushNotificationsEnabled: createdModel.pushNotificationsEnabled,
      emailNotificationsEnabled: createdModel.emailNotificationsEnabled,
      createdAt: createdModel.createdAt,
      updatedAt: createdModel.updatedAt,
    );
  }

  @override
  Future<UserProfile> updateUserProfile(UserProfile profile) async {
    // Создаем UserProfileModel напрямую из UserProfile
    final profileModel = UserProfileModel(
      id: profile.id,
      firstName: profile.firstName,
      lastName: profile.lastName,
      email: profile.email,
      phone: profile.phone,
      dateOfBirth: profile.dateOfBirth,
      gender: profile.gender,
      height: profile.height,
      weight: profile.weight,
      activityLevel: profile.activityLevel,
      avatarUrl: profile.avatarUrl,
      dietaryPreferences: profile.dietaryPreferences,
      allergies: profile.allergies,
      healthConditions: profile.healthConditions,
      fitnessGoals: profile.fitnessGoals,
      targetWeight: profile.targetWeight,
      targetCalories: profile.targetCalories,
      targetProtein: profile.targetProtein,
      targetCarbs: profile.targetCarbs,
      targetFat: profile.targetFat,
      foodRestrictions: profile.foodRestrictions,
      pushNotificationsEnabled: profile.pushNotificationsEnabled,
      emailNotificationsEnabled: profile.emailNotificationsEnabled,
      createdAt: profile.createdAt,
      updatedAt: profile.updatedAt,
    );
    final updatedModel = await _service.updateUserProfile(profileModel);
    // Конвертируем обратно в UserProfile
    return UserProfile(
      id: updatedModel.id,
      firstName: updatedModel.firstName,
      lastName: updatedModel.lastName,
      email: updatedModel.email,
      phone: updatedModel.phone,
      dateOfBirth: updatedModel.dateOfBirth,
      gender: updatedModel.gender,
      height: updatedModel.height,
      weight: updatedModel.weight,
      activityLevel: updatedModel.activityLevel,
      avatarUrl: updatedModel.avatarUrl,
      dietaryPreferences: updatedModel.dietaryPreferences,
      allergies: updatedModel.allergies,
      healthConditions: updatedModel.healthConditions,
      fitnessGoals: updatedModel.fitnessGoals,
      targetWeight: updatedModel.targetWeight,
      targetCalories: updatedModel.targetCalories,
      targetProtein: updatedModel.targetProtein,
      targetCarbs: updatedModel.targetCarbs,
      targetFat: updatedModel.targetFat,
      foodRestrictions: updatedModel.foodRestrictions,
      pushNotificationsEnabled: updatedModel.pushNotificationsEnabled,
      emailNotificationsEnabled: updatedModel.emailNotificationsEnabled,
      createdAt: updatedModel.createdAt,
      updatedAt: updatedModel.updatedAt,
    );
  }

  @override
  Future<void> deleteUserProfile(String userId) async {
    return _service.deleteUserProfile(userId);
  }

  @override
  Future<bool> isEmailAvailable(String email) async {
    return _service.isEmailAvailable(email);
  }

  @override
  Future<Map<String, dynamic>> getProfileStatistics(String userId) async {
    return _service.getProfileStatistics(userId);
  }

  @override
  Future<Map<String, dynamic>> exportProfileData(String userId) async {
    return _service.exportProfileData(userId);
  }
}
