import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import '../../../../shared/theme/app_colors.dart';

/// Screen for cropping avatar images
class AvatarCropScreen extends StatefulWidget {
  final File imageFile;
  final String? title;

  const AvatarCropScreen({
    super.key,
    required this.imageFile,
    this.title,
  });

  @override
  State<AvatarCropScreen> createState() => _AvatarCropScreenState();
}

class _AvatarCropScreenState extends State<AvatarCropScreen> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.title ?? 'Обрезать фото',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          if (!_isProcessing)
            TextButton(
              onPressed: _cropImage,
              child: const Text(
                'Готово',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          if (_isProcessing)
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child:
                _isProcessing ? _buildProcessingView() : _buildImagePreview(),
          ),
          if (!_isProcessing) _buildInstructions(),
        ],
      ),
    );
  }

  Widget _buildImagePreview() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.file(
          widget.imageFile,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildProcessingView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          SizedBox(height: 16),
          Text(
            'Обрабатываем изображение...',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructions() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.crop,
                  color: AppColors.green,
                  size: 24,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Изображение будет обрезано до квадрата',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Row(
              children: [
                Icon(
                  Icons.touch_app,
                  color: Colors.white70,
                  size: 20,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Нажмите "Готово" для продолжения',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _cropImage() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: widget.imageFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Обрезка аватара',
            toolbarColor: AppColors.green,
            toolbarWidgetColor: Colors.white,
            backgroundColor: Colors.black,
            activeControlsWidgetColor: AppColors.green,
            dimmedLayerColor: Colors.black.withValues(alpha: 0.8),
            cropFrameColor: AppColors.green,
            cropGridColor: AppColors.green.withValues(alpha: 0.3),
            showCropGrid: true,
            lockAspectRatio: true,
            hideBottomControls: false,
            initAspectRatio: CropAspectRatioPreset.square,
          ),
          IOSUiSettings(
            title: 'Обрезка аватара',
            doneButtonTitle: 'Готово',
            cancelButtonTitle: 'Отмена',
            aspectRatioLockEnabled: true,
            resetAspectRatioEnabled: false,
            aspectRatioPickerButtonHidden: true,
            rotateButtonsHidden: false,
            rotateClockwiseButtonHidden: false,
            hidesNavigationBar: true,
            rectX: 0,
            rectY: 0,
            rectWidth: 300,
            rectHeight: 300,
          ),
        ],
      );

      if (mounted) {
        setState(() {
          _isProcessing = false;
        });

        if (croppedFile != null) {
          // Return cropped file
          Navigator.of(context).pop(File(croppedFile.path));
        } else {
          // User cancelled cropping
          _showMessage('Обрезка отменена');
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
        _showErrorDialog('Ошибка при обрезке изображения: $e');
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ошибка'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

/// Helper class to launch avatar crop screen
class AvatarCropper {
  /// Show crop screen and return cropped file
  static Future<File?> cropAvatar(
    BuildContext context,
    File imageFile, {
    String? title,
  }) async {
    return Navigator.of(context).push<File>(
      MaterialPageRoute(
        builder: (context) => AvatarCropScreen(
          imageFile: imageFile,
          title: title,
        ),
      ),
    );
  }

  /// Quick crop without showing UI (for automatic processing)
  static Future<File?> quickCrop(File imageFile) async {
    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 90,
        maxWidth: 512,
        maxHeight: 512,
        compressFormat: ImageCompressFormat.jpg,
        uiSettings: [
          AndroidUiSettings(
            lockAspectRatio: true,
            hideBottomControls: true,
          ),
          IOSUiSettings(
            aspectRatioLockEnabled: true,
            resetAspectRatioEnabled: false,
            aspectRatioPickerButtonHidden: true,
            hidesNavigationBar: true,
          ),
        ],
      );

      return croppedFile != null ? File(croppedFile.path) : null;
    } catch (e) {
      return null;
    }
  }
}
