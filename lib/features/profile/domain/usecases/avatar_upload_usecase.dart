import 'dart:io';
import '../repositories/profile_repository.dart';
import '../../data/services/image_processing_service.dart';

/// Результат выполнения AvatarUploadUseCase
class AvatarUploadResult {
  final String? avatarUrl;
  final String? error;
  final bool isSuccess;

  AvatarUploadResult._({
    this.avatarUrl,
    this.error,
    required this.isSuccess,
  });

  factory AvatarUploadResult.success(String avatarUrl) {
    return AvatarUploadResult._(
      avatarUrl: avatarUrl,
      isSuccess: true,
    );
  }

  factory AvatarUploadResult.failure(String error) {
    return AvatarUploadResult._(
      error: error,
      isSuccess: false,
    );
  }
}

/// Use case для загрузки аватара пользователя
class AvatarUploadUseCase {
  final ProfileRepository _profileRepository;
  final ImageProcessingService _imageProcessingService;

  AvatarUploadUseCase(this._profileRepository, this._imageProcessingService);

  /// Загружает аватар пользователя
  Future<AvatarUploadResult> execute(File imageFile, String userId) async {
    try {
      // Валидация файла изображения
      final validationResult =
          await _imageProcessingService.validateImage(imageFile);
      if (!validationResult.isValid) {
        return AvatarUploadResult.failure(
            validationResult.error ?? 'Invalid image');
      }

      // Обработка изображения
      final processingResult =
          await _imageProcessingService.processAvatarImage(imageFile);
      if (!processingResult.isSuccess) {
        return AvatarUploadResult.failure(
            processingResult.error ?? 'Failed to process image');
      }

      // Загрузка обработанного изображения
      final avatarUrl =
          await _uploadProcessedImage(processingResult.outputFile!, userId);

      // Обновление профиля пользователя
      await _updateUserAvatar(userId, avatarUrl);

      return AvatarUploadResult.success(avatarUrl);
    } catch (e) {
      return AvatarUploadResult.failure('Failed to upload avatar: $e');
    }
  }

  /// Загружает обработанное изображение в хранилище
  Future<String> _uploadProcessedImage(File imageFile, String userId) async {
    // Здесь должна быть логика загрузки в Supabase Storage или другое хранилище
    // Пока возвращаем временный URL
    return 'https://example.com/avatars/$userId.jpg';
  }

  /// Обновляет аватар пользователя в профиле
  Future<void> _updateUserAvatar(String userId, String avatarUrl) async {
    // Получаем текущий профиль
    final currentProfile = await _profileRepository.getUserProfile(userId);
    if (currentProfile != null) {
      // Создаем обновленный профиль с новым аватаром
      final updatedProfile = currentProfile.copyWith(avatarUrl: avatarUrl);
      await _profileRepository.updateUserProfile(updatedProfile);
    }
  }

  /// Валидирует файл изображения
  Future<ValidationResult> validateImageFile(File imageFile) async {
    return _imageProcessingService.validateImage(imageFile);
  }

  /// Обрабатывает изображение для аватара
  Future<ProcessingResult> processImageFile(File imageFile) async {
    return _imageProcessingService.processAvatarImage(imageFile);
  }

  /// Создает миниатюру изображения
  Future<ProcessingResult> createThumbnail(File imageFile) async {
    return _imageProcessingService.createThumbnail(imageFile);
  }

  /// Удаляет EXIF данные из изображения
  Future<File> removeExifData(File imageFile) async {
    return _imageProcessingService.removeExifData(imageFile);
  }

  /// Получает информацию об изображении
  Future<ImageInfo?> getImageInfo(File imageFile) async {
    return _imageProcessingService.getImageInfo(imageFile);
  }

  /// Очищает временные файлы
  Future<void> cleanupTempFiles() async {
    await _imageProcessingService.cleanupTempFiles();
  }
}
