import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

/// Результат валидации профиля
class ProfileValidationResult {
  final bool isValid;
  final List<String> errors;

  const ProfileValidationResult._({
    required this.isValid,
    required this.errors,
  });

  factory ProfileValidationResult.valid() => const ProfileValidationResult._(
        isValid: true,
        errors: [],
      );

  factory ProfileValidationResult.invalid(List<String> errors) =>
      ProfileValidationResult._(
        isValid: false,
        errors: errors,
      );
}

/// Результат выполнения UpdateUserProfileUseCase
class UpdateUserProfileResult {
  final UserProfile? profile;
  final String? error;
  final bool isSuccess;

  UpdateUserProfileResult._({
    this.profile,
    this.error,
    required this.isSuccess,
  });

  factory UpdateUserProfileResult.success(UserProfile profile) {
    return UpdateUserProfileResult._(
      profile: profile,
      isSuccess: true,
    );
  }

  factory UpdateUserProfileResult.failure(String error) {
    return UpdateUserProfileResult._(
      error: error,
      isSuccess: false,
    );
  }
}

/// Use case для обновления профиля пользователя
class UpdateUserProfileUseCase {
  final ProfileRepository _profileRepository;

  UpdateUserProfileUseCase(this._profileRepository);

  /// Обновляет профиль пользователя
  Future<UpdateUserProfileResult> execute(UserProfile profile) async {
    try {
      // Валидация данных
      final validationResult = _validateProfile(profile);
      if (!validationResult.isValid) {
        return UpdateUserProfileResult.failure(
            'Validation failed: ${validationResult.errors.join(', ')}');
      }

      // Обновляем профиль
      final updatedProfile =
          await _profileRepository.updateUserProfile(profile);

      return UpdateUserProfileResult.success(updatedProfile);
    } catch (e) {
      return UpdateUserProfileResult.failure('Failed to update profile: $e');
    }
  }

  /// Валидация профиля
  ProfileValidationResult _validateProfile(UserProfile profile) {
    final errors = <String>[];

    // Валидация email
    if (profile.email.isEmpty) {
      errors.add('Email is required');
    } else if (!_isValidEmail(profile.email)) {
      errors.add('Invalid email format');
    }

    // Валидация имени
    if (profile.firstName.isEmpty) {
      errors.add('First name is required');
    }

    if (profile.lastName.isEmpty) {
      errors.add('Last name is required');
    }

    // Валидация возраста
    if (profile.dateOfBirth != null) {
      final age = profile.age;
      if (age != null && (age < 13 || age > 120)) {
        errors.add('Age must be between 13 and 120');
      }
    }

    // Валидация роста
    if (profile.height != null) {
      if (profile.height! < 100.0 || profile.height! > 250.0) {
        errors.add('Height must be between 100 and 250 cm');
      }
    }

    // Валидация веса
    if (profile.weight != null) {
      if (profile.weight! < 30 || profile.weight! > 300) {
        errors.add('Weight must be between 30 and 300 kg');
      }
    }

    // Валидация телефона
    if (profile.phone?.isNotEmpty == true && !_isValidPhone(profile.phone!)) {
      errors.add('Invalid phone number format');
    }

    return errors.isEmpty
        ? ProfileValidationResult.valid()
        : ProfileValidationResult.invalid(errors);
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }

  bool _isValidPhone(String phone) {
    return RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(phone);
  }
}
