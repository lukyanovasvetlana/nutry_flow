import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

/// Service for processing and optimizing images
class ImageProcessingService {
  /// Compress and resize image for avatar use
  Future<ProcessingResult> processAvatarImage(
    File inputFile, {
    int targetSize = 512,
    int quality = 85,
  }) async {
    try {
      // Read image file
      final bytes = await inputFile.readAsBytes();
      final image = img.decodeImage(bytes);

      if (image == null) {
        return ProcessingResult.error('Failed to decode image');
      }

      // Resize image to square with target size
      final processedImage = _resizeToSquare(image, targetSize);

      // Encode with compression
      final compressedBytes = _encodeWithCompression(processedImage, quality);

      // Save to temporary file
      final outputFile = await _saveTempFile(compressedBytes, 'jpg');

      // Calculate compression stats
      final originalSize = bytes.length;
      final compressedSize = compressedBytes.length;
      final compressionRatio = (1 - (compressedSize / originalSize)) * 100;

      return ProcessingResult.success(
        outputFile: outputFile,
        originalSize: originalSize,
        compressedSize: compressedSize,
        compressionRatio: compressionRatio,
        dimensions: '${processedImage.width}x${processedImage.height}',
      );
    } catch (e) {
      return ProcessingResult.error('Failed to process image: $e');
    }
  }

  /// Create thumbnail from image
  Future<ProcessingResult> createThumbnail(
    File inputFile, {
    int size = 128,
    int quality = 75,
  }) async {
    try {
      final bytes = await inputFile.readAsBytes();
      final image = img.decodeImage(bytes);

      if (image == null) {
        return ProcessingResult.error('Failed to decode image');
      }

      // Create square thumbnail
      final thumbnail = _resizeToSquare(image, size);

      // Encode with higher compression for thumbnails
      final thumbnailBytes = _encodeWithCompression(thumbnail, quality);

      // Save to temporary file
      final outputFile = await _saveTempFile(thumbnailBytes, 'jpg');

      return ProcessingResult.success(
        outputFile: outputFile,
        originalSize: bytes.length,
        compressedSize: thumbnailBytes.length,
        compressionRatio: 0,
        dimensions: '${thumbnail.width}x${thumbnail.height}',
      );
    } catch (e) {
      return ProcessingResult.error('Failed to create thumbnail: $e');
    }
  }

  /// Validate image dimensions and format
  Future<ValidationResult> validateImage(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final image = img.decodeImage(bytes);

      if (image == null) {
        return ValidationResult.invalid('Invalid image format');
      }

      // Check minimum dimensions
      if (image.width < 100 || image.height < 100) {
        return ValidationResult.invalid(
          'Image too small. Minimum size is 100x100 pixels. Current: ${image.width}x${image.height}',
        );
      }

      // Check maximum dimensions
      if (image.width > 4096 || image.height > 4096) {
        return ValidationResult.invalid(
          'Image too large. Maximum size is 4096x4096 pixels. Current: ${image.width}x${image.height}',
        );
      }

      // Check file size
      final fileSizeBytes = await imageFile.length();
      const maxSizeBytes = 20 * 1024 * 1024; // 20MB
      if (fileSizeBytes > maxSizeBytes) {
        final sizeMB = (fileSizeBytes / (1024 * 1024)).toStringAsFixed(1);
        return ValidationResult.invalid(
            'Image file too large (${sizeMB}MB). Maximum size is 20MB.');
      }

      return ValidationResult.valid();
    } catch (e) {
      return ValidationResult.invalid('Failed to validate image: $e');
    }
  }

  /// Remove EXIF data from image for privacy
  Future<File> removeExifData(File inputFile) async {
    try {
      final bytes = await inputFile.readAsBytes();
      final image = img.decodeImage(bytes);

      if (image == null) {
        throw Exception('Failed to decode image');
      }

      // Re-encode without EXIF data
      final cleanBytes = img.encodeJpg(image, quality: 95);

      // Save to new temporary file
      return await _saveTempFile(cleanBytes, 'jpg');
    } catch (e) {
      throw Exception('Failed to remove EXIF data: $e');
    }
  }

  /// Resize image to square maintaining aspect ratio
  img.Image _resizeToSquare(img.Image image, int targetSize) {
    // Determine the smaller dimension to crop from center
    final minDimension =
        image.width < image.height ? image.width : image.height;

    // Calculate crop coordinates for center crop
    final cropX = (image.width - minDimension) ~/ 2;
    final cropY = (image.height - minDimension) ~/ 2;

    // Crop to square
    final cropped = img.copyCrop(
      image,
      x: cropX,
      y: cropY,
      width: minDimension,
      height: minDimension,
    );

    // Resize to target size with high quality
    return img.copyResize(
      cropped,
      width: targetSize,
      height: targetSize,
      interpolation: img.Interpolation.cubic,
    );
  }

  /// Encode image with compression
  Uint8List _encodeWithCompression(img.Image image, int quality) {
    return Uint8List.fromList(img.encodeJpg(image, quality: quality));
  }

  /// Save bytes to temporary file
  Future<File> _saveTempFile(Uint8List bytes, String extension) async {
    final tempDir = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = 'processed_avatar_$timestamp.$extension';
    final file = File(path.join(tempDir.path, fileName));

    await file.writeAsBytes(bytes);
    return file;
  }

  /// Clean up temporary files
  Future<void> cleanupTempFiles() async {
    try {
      final tempDir = await getTemporaryDirectory();
      final files = tempDir.listSync();

      for (final file in files) {
        if (file is File && file.path.contains('processed_avatar_')) {
          // Delete files older than 1 hour
          final stats = await file.stat();
          final age = DateTime.now().difference(stats.modified);
          if (age.inHours > 1) {
            await file.delete();
          }
        }
      }
    } catch (e) {
      // Ignore cleanup errors
    }
  }

  /// Get image info without processing
  Future<ImageInfo?> getImageInfo(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final image = img.decodeImage(bytes);

      if (image == null) {
        return null;
      }

      final fileSizeBytes = await imageFile.length();
      final format = _getImageFormat(imageFile.path);

      return ImageInfo(
        width: image.width,
        height: image.height,
        fileSizeBytes: fileSizeBytes,
        format: format,
        aspectRatio: image.width / image.height,
      );
    } catch (e) {
      return null;
    }
  }

  /// Get image format from file path
  String _getImageFormat(String filePath) {
    final extension = path.extension(filePath).toLowerCase();
    switch (extension) {
      case '.jpg':
      case '.jpeg':
        return 'JPEG';
      case '.png':
        return 'PNG';
      case '.webp':
        return 'WebP';
      case '.heic':
      case '.heif':
        return 'HEIC';
      default:
        return 'Unknown';
    }
  }
}

/// Result of image processing operation
class ProcessingResult {
  final bool isSuccess;
  final File? outputFile;
  final String? error;
  final int originalSize;
  final int compressedSize;
  final double compressionRatio;
  final String dimensions;

  const ProcessingResult._({
    required this.isSuccess,
    this.outputFile,
    this.error,
    this.originalSize = 0,
    this.compressedSize = 0,
    this.compressionRatio = 0,
    this.dimensions = '',
  });

  factory ProcessingResult.success({
    required File outputFile,
    required int originalSize,
    required int compressedSize,
    required double compressionRatio,
    required String dimensions,
  }) =>
      ProcessingResult._(
        isSuccess: true,
        outputFile: outputFile,
        originalSize: originalSize,
        compressedSize: compressedSize,
        compressionRatio: compressionRatio,
        dimensions: dimensions,
      );

  factory ProcessingResult.error(String error) => ProcessingResult._(
        isSuccess: false,
        error: error,
      );

  String get compressionText {
    if (compressionRatio > 0) {
      return '${compressionRatio.toStringAsFixed(1)}% smaller';
    }
    return 'No compression';
  }

  String get fileSizeText {
    final sizeKB = (compressedSize / 1024).toStringAsFixed(1);
    return '${sizeKB}KB';
  }
}

/// Image validation result
class ValidationResult {
  final bool isValid;
  final String? error;

  const ValidationResult._({required this.isValid, this.error});

  factory ValidationResult.valid() => const ValidationResult._(isValid: true);
  factory ValidationResult.invalid(String error) =>
      ValidationResult._(isValid: false, error: error);
}

/// Image information
class ImageInfo {
  final int width;
  final int height;
  final int fileSizeBytes;
  final String format;
  final double aspectRatio;

  const ImageInfo({
    required this.width,
    required this.height,
    required this.fileSizeBytes,
    required this.format,
    required this.aspectRatio,
  });

  String get dimensions => '${width}x$height';

  String get fileSize {
    if (fileSizeBytes < 1024) {
      return '${fileSizeBytes}B';
    } else if (fileSizeBytes < 1024 * 1024) {
      return '${(fileSizeBytes / 1024).toStringAsFixed(1)}KB';
    } else {
      return '${(fileSizeBytes / (1024 * 1024)).toStringAsFixed(1)}MB';
    }
  }

  bool get isSquare => width == height;
  bool get isLandscape => width > height;
  bool get isPortrait => height > width;
}
