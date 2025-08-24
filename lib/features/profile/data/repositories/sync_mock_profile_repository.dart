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
    // Конвертируем UserProfile в UserProfileModel
    final profileModel = UserProfileModel.fromEntity(profile);
    final createdModel = await _service.createUserProfile(profileModel);
    return createdModel.toEntity();
  }

  @override
  Future<UserProfile> updateUserProfile(UserProfile profile) async {
    // Конвертируем UserProfile в UserProfileModel
    final profileModel = UserProfileModel.fromEntity(profile);
    final updatedModel = await _service.updateUserProfile(profileModel);
    return updatedModel.toEntity();
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
