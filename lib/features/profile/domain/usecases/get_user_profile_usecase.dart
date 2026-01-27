import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';
import 'package:nutry_flow/core/services/supabase_service.dart';
import 'dart:developer' as developer;

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
  /// Если профиль не найден, пытается создать базовый профиль из данных пользователя
  Future<GetUserProfileResult> execute(String userId) async {
    try {
      developer.log('🔵 GetUserProfileUseCase: Loading profile for userId: $userId', name: 'GetUserProfileUseCase');
      
      final profile = await _profileRepository.getUserProfile(userId);

      if (profile != null) {
        developer.log('🔵 GetUserProfileUseCase: Profile found: ${profile.firstName} ${profile.lastName}', name: 'GetUserProfileUseCase');
        return GetUserProfileResult.success(profile);
      }

      // Если профиль не найден, пытаемся создать базовый профиль
      developer.log('🔵 GetUserProfileUseCase: Profile not found, attempting to create default profile', name: 'GetUserProfileUseCase');
      
      final defaultProfile = await _createDefaultProfile(userId);
      if (defaultProfile != null) {
        developer.log('🔵 GetUserProfileUseCase: Default profile created successfully', name: 'GetUserProfileUseCase');
        return GetUserProfileResult.success(defaultProfile);
      }

      developer.log('🔴 GetUserProfileUseCase: Failed to create default profile', name: 'GetUserProfileUseCase');
      return GetUserProfileResult.failure('Profile not found and could not create default profile');
    } catch (e, stackTrace) {
      developer.log('🔴 GetUserProfileUseCase: Exception: $e', name: 'GetUserProfileUseCase');
      developer.log('🔴 GetUserProfileUseCase: Stack trace: $stackTrace', name: 'GetUserProfileUseCase');
      return GetUserProfileResult.failure('Failed to load profile: $e');
    }
  }

  /// Создает базовый профиль из данных текущего пользователя
  Future<UserProfile?> _createDefaultProfile(String userId) async {
    try {
      final currentUser = SupabaseService.instance.currentUser;
      if (currentUser == null) {
        developer.log('🔴 GetUserProfileUseCase: No current user found for creating default profile', name: 'GetUserProfileUseCase');
        return null;
      }

      // Создаем базовый профиль из данных пользователя
      final defaultProfile = UserProfile(
        id: userId,
        firstName: currentUser.userMetadata?['firstName'] as String? ?? 
                  currentUser.userMetadata?['name'] as String? ?? 
                  'Пользователь',
        lastName: currentUser.userMetadata?['lastName'] as String? ?? '',
        email: currentUser.email ?? 'user@example.com',
        phone: currentUser.phone,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Пытаемся сохранить профиль в репозитории
      try {
        final createdProfile = await _profileRepository.createUserProfile(defaultProfile);
        developer.log('🔵 GetUserProfileUseCase: Profile created in repository', name: 'GetUserProfileUseCase');
        return createdProfile;
      } catch (e) {
        // Если не удалось создать в репозитории, возвращаем локальный профиль
        developer.log('🔵 GetUserProfileUseCase: Could not save to repository, returning local profile: $e', name: 'GetUserProfileUseCase');
        return defaultProfile;
      }
    } catch (e) {
      developer.log('🔴 GetUserProfileUseCase: Error creating default profile: $e', name: 'GetUserProfileUseCase');
      return null;
    }
  }
}
