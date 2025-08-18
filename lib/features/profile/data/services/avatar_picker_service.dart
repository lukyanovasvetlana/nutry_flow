import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'image_processing_service.dart' show ValidationResult;

/// Service for picking images from camera or gallery with permission handling
class AvatarPickerService {
  final ImagePicker _imagePicker = ImagePicker();

  /// Pick image from camera
  Future<AvatarPickerResult> pickFromCamera() async {
    try {
      // Check camera permission
      final permissionResult = await _requestCameraPermission();
      if (!permissionResult.isGranted) {
        return AvatarPickerResult.permissionDenied(
          'Camera access is required to take photos',
          permissionResult.shouldShowDialog,
        );
      }

      // Pick image from camera
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (pickedFile == null) {
        return AvatarPickerResult.cancelled();
      }

      final file = File(pickedFile.path);
      if (!await file.exists()) {
        return AvatarPickerResult.error('Captured image file not found');
      }

      return AvatarPickerResult.success(file);
    } catch (e) {
      return AvatarPickerResult.error('Failed to capture image: $e');
    }
  }

  /// Pick image from gallery
  Future<AvatarPickerResult> pickFromGallery() async {
    try {
      // Check photo library permission
      final permissionResult = await _requestPhotoLibraryPermission();
      if (!permissionResult.isGranted) {
        return AvatarPickerResult.permissionDenied(
          'Photo library access is required to select images',
          permissionResult.shouldShowDialog,
        );
      }

      // Pick image from gallery
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
        maxWidth: 2048,
        maxHeight: 2048,
      );

      if (pickedFile == null) {
        return AvatarPickerResult.cancelled();
      }

      final file = File(pickedFile.path);
      if (!await file.exists()) {
        return AvatarPickerResult.error('Selected image file not found');
      }

      // Validate file
      final validation = await _validateImageFile(file);
      if (!validation.isValid) {
        return AvatarPickerResult.error(validation.error!);
      }

      return AvatarPickerResult.success(file);
    } catch (e) {
      return AvatarPickerResult.error('Failed to pick image: $e');
    }
  }

  /// Request camera permission
  Future<PermissionResult> _requestCameraPermission() async {
    final status = await Permission.camera.request();

    switch (status) {
      case PermissionStatus.granted:
        return PermissionResult.granted();
      case PermissionStatus.denied:
        return PermissionResult.denied(shouldShowDialog: false);
      case PermissionStatus.permanentlyDenied:
        return PermissionResult.denied(shouldShowDialog: true);
      case PermissionStatus.restricted:
        return PermissionResult.denied(shouldShowDialog: true);
      default:
        return PermissionResult.denied(shouldShowDialog: false);
    }
  }

  /// Request photo library permission
  Future<PermissionResult> _requestPhotoLibraryPermission() async {
    Permission permission;

    if (Platform.isIOS) {
      permission = Permission.photos;
    } else {
      // Android 13+ uses different permissions
      final photosStatus = await Permission.photos.status;
      if (photosStatus == PermissionStatus.denied) {
        permission = Permission.photos;
      } else {
        permission = Permission.storage;
      }
    }

    final status = await permission.request();

    switch (status) {
      case PermissionStatus.granted:
      case PermissionStatus.limited: // iOS limited access
        return PermissionResult.granted();
      case PermissionStatus.denied:
        return PermissionResult.denied(shouldShowDialog: false);
      case PermissionStatus.permanentlyDenied:
        return PermissionResult.denied(shouldShowDialog: true);
      case PermissionStatus.restricted:
        return PermissionResult.denied(shouldShowDialog: true);
      default:
        return PermissionResult.denied(shouldShowDialog: false);
    }
  }

  /// Validate image file
  Future<ValidationResult> _validateImageFile(File file) async {
    try {
      // Check file exists
      if (!await file.exists()) {
        return ValidationResult.invalid('Image file does not exist');
      }

      // Check file size (max 10MB)
      final fileSize = await file.length();
      const maxSizeBytes = 10 * 1024 * 1024; // 10MB
      if (fileSize > maxSizeBytes) {
        final sizeMB = (fileSize / (1024 * 1024)).toStringAsFixed(1);
        return ValidationResult.invalid(
            'Image is too large (${sizeMB}MB). Maximum size is 10MB.');
      }

      // Check file extension
      final extension = file.path.split('.').last.toLowerCase();
      const allowedExtensions = ['jpg', 'jpeg', 'png', 'heic', 'webp'];
      if (!allowedExtensions.contains(extension)) {
        return ValidationResult.invalid(
            'Unsupported file format. Please use JPG, PNG, HEIC, or WebP.');
      }

      return ValidationResult.valid();
    } catch (e) {
      return ValidationResult.invalid('Failed to validate image: $e');
    }
  }

  /// Check if camera is available
  Future<bool> isCameraAvailable() async {
    try {
      return _imagePicker.supportsImageSource(ImageSource.camera);
    } catch (e) {
      return false;
    }
  }

  /// Check if gallery is available
  Future<bool> isGalleryAvailable() async {
    try {
      return _imagePicker.supportsImageSource(ImageSource.gallery);
    } catch (e) {
      return false;
    }
  }

  /// Open app settings for permission
  Future<bool> openSettings() async {
    return openAppSettings();
  }
}

/// Result of avatar picking operation
class AvatarPickerResult {
  final AvatarPickerStatus status;
  final File? imageFile;
  final String? errorMessage;
  final bool shouldShowPermissionDialog;

  const AvatarPickerResult._({
    required this.status,
    this.imageFile,
    this.errorMessage,
    this.shouldShowPermissionDialog = false,
  });

  factory AvatarPickerResult.success(File imageFile) => AvatarPickerResult._(
        status: AvatarPickerStatus.success,
        imageFile: imageFile,
      );

  factory AvatarPickerResult.cancelled() => const AvatarPickerResult._(
        status: AvatarPickerStatus.cancelled,
      );

  factory AvatarPickerResult.error(String message) => AvatarPickerResult._(
        status: AvatarPickerStatus.error,
        errorMessage: message,
      );

  factory AvatarPickerResult.permissionDenied(
    String message,
    bool shouldShowDialog,
  ) =>
      AvatarPickerResult._(
        status: AvatarPickerStatus.permissionDenied,
        errorMessage: message,
        shouldShowPermissionDialog: shouldShowDialog,
      );

  bool get isSuccess => status == AvatarPickerStatus.success;
  bool get isCancelled => status == AvatarPickerStatus.cancelled;
  bool get isError => status == AvatarPickerStatus.error;
  bool get isPermissionDenied => status == AvatarPickerStatus.permissionDenied;
}

enum AvatarPickerStatus {
  success,
  cancelled,
  error,
  permissionDenied,
}

/// Permission request result
class PermissionResult {
  final bool isGranted;
  final bool shouldShowDialog;

  const PermissionResult._({
    required this.isGranted,
    required this.shouldShowDialog,
  });

  factory PermissionResult.granted() => const PermissionResult._(
        isGranted: true,
        shouldShowDialog: false,
      );

  factory PermissionResult.denied({required bool shouldShowDialog}) =>
      PermissionResult._(
        isGranted: false,
        shouldShowDialog: shouldShowDialog,
      );
}
