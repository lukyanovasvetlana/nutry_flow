import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

/// Результат выполнения GetUserProfileUseCase
class GetUserProfileResult {
  final UserProfile? profile;
  final String? error;
  final bool isSuccess;

  GetUserProfileResult._({
    this.profile,
    this.error,
    required this.isSuccess,
  });

  factory GetUserProfileResult.success(UserProfile profile) {
    return GetUserProfileResult._(
      profile: profile,
      isSuccess: true,
    );
  }

  factory GetUserProfileResult.failure(String error) {
    return GetUserProfileResult._(
      error: error,
      isSuccess: false,
    );
  }
}

/// Use case для получения профиля пользователя
class GetUserProfileUseCase {
  final ProfileRepository _profileRepository;

  GetUserProfileUseCase(this._profileRepository);

  /// Получает профиль пользователя по ID
  Future<GetUserProfileResult> execute(String userId) async {
    
    try {
      final profile = await _profileRepository.getUserProfile(userId);
      
      if (profile != null) {
        return GetUserProfileResult.success(profile);
      } else {
        return GetUserProfileResult.failure('Profile not found');
      }
    } catch (e) {
      return GetUserProfileResult.failure('Failed to load profile: $e');
    }
  }
} 