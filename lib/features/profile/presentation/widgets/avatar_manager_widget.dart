import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/user_profile.dart';
import '../../data/services/avatar_picker_service.dart';
import '../../data/services/image_processing_service.dart';
import '../../domain/usecases/avatar_upload_usecase.dart';
import '../screens/avatar_crop_screen.dart';
import '../../../../shared/theme/app_colors.dart';

/// Widget for managing user avatar with full functionality
class AvatarManagerWidget extends StatefulWidget {
  final UserProfile userProfile;
  final Function(String avatarUrl) onAvatarUploaded;
  final Function() onAvatarDeleted;
  final VoidCallback? onError;
  final double size;
  final bool enableEdit;
  final bool showBorder;

  const AvatarManagerWidget({
    super.key,
    required this.userProfile,
    required this.onAvatarUploaded,
    required this.onAvatarDeleted,
    this.onError,
    this.size = 120,
    this.enableEdit = true,
    this.showBorder = true,
  });

  @override
  State<AvatarManagerWidget> createState() => _AvatarManagerWidgetState();
}

class _AvatarManagerWidgetState extends State<AvatarManagerWidget> {
  final AvatarPickerService _pickerService = AvatarPickerService();
  late final AvatarUploadUseCase _uploadUseCase;

  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    // This will be initialized properly when dependencies are set up
    // _uploadUseCase = AvatarUploadUseCase(...);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildAvatarDisplay(),
        if (widget.enableEdit) ...[
          const SizedBox(height: 16),
          _buildActionButtons(),
        ],
      ],
    );
  }

  Widget _buildAvatarDisplay() {
    return Stack(
      children: [
        // Main avatar
        Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: widget.showBorder
                ? Border.all(
                    color: AppColors.green,
                    width: 3,
                  )
                : null,
            boxShadow: widget.showBorder
                ? [
                    BoxShadow(
                      color: AppColors.green.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: ClipOval(
            child: _buildAvatarImage(),
          ),
        ),
        
        // Upload progress overlay
        if (_isUploading)
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black54,
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 3,
                ),
              ),
            ),
          ),

        // Edit button overlay
        if (widget.enableEdit && !_isUploading)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.green,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: _showAvatarOptions,
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAvatarImage() {
    if (widget.userProfile.avatarUrl != null) {
      return CachedNetworkImage(
        imageUrl: widget.userProfile.avatarUrl!,
        fit: BoxFit.cover,
        placeholder: (context, url) => _buildPlaceholder(),
        errorWidget: (context, url, error) => _buildPlaceholder(),
        fadeInDuration: const Duration(milliseconds: 200),
        fadeOutDuration: const Duration(milliseconds: 100),
      );
    } else {
      return _buildPlaceholder();
    }
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[200],
      child: widget.userProfile.initials.isNotEmpty
          ? Center(
              child: Text(
                widget.userProfile.initials,
                style: TextStyle(
                  fontSize: widget.size * 0.3,
                  fontWeight: FontWeight.bold,
                  color: AppColors.green,
                ),
              ),
            )
          : Icon(
              Icons.person,
              size: widget.size * 0.5,
              color: Colors.grey[400],
            ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildActionButton(
          icon: Icons.camera_alt,
          label: 'Камера',
          onTap: _pickFromCamera,
          enabled: !_isUploading,
        ),
        const SizedBox(width: 16),
        _buildActionButton(
          icon: Icons.photo_library,
          label: 'Галерея',
          onTap: _pickFromGallery,
          enabled: !_isUploading,
        ),
        if (widget.userProfile.avatarUrl != null) ...[
          const SizedBox(width: 16),
          _buildActionButton(
            icon: Icons.delete,
            label: 'Удалить',
            onTap: _deleteAvatar,
            enabled: !_isUploading,
            color: Colors.red,
          ),
        ],
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool enabled,
    Color? color,
  }) {
    final buttonColor = color ?? AppColors.green;
    
    return Material(
      color: enabled 
          ? buttonColor.withOpacity(0.1) 
          : Colors.grey.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              Icon(
                icon,
                color: enabled ? buttonColor : Colors.grey,
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: enabled ? buttonColor : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAvatarOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => AvatarOptionsBottomSheet(
        hasAvatar: widget.userProfile.avatarUrl != null,
        onCameraTap: () {
          Navigator.pop(context);
          _pickFromCamera();
        },
        onGalleryTap: () {
          Navigator.pop(context);
          _pickFromGallery();
        },
        onDeleteTap: widget.userProfile.avatarUrl != null
            ? () {
                Navigator.pop(context);
                _deleteAvatar();
              }
            : null,
      ),
    );
  }

  Future<void> _pickFromCamera() async {
    setState(() => _isUploading = true);

    try {
      final result = await _pickerService.pickFromCamera();
      await _handlePickerResult(result);
    } catch (e) {
      _showError('Ошибка при съемке: $e');
    } finally {
      setState(() => _isUploading = false);
    }
  }

  Future<void> _pickFromGallery() async {
    setState(() => _isUploading = true);

    try {
      final result = await _pickerService.pickFromGallery();
      await _handlePickerResult(result);
    } catch (e) {
      _showError('Ошибка выбора из галереи: $e');
    } finally {
      setState(() => _isUploading = false);
    }
  }

  Future<void> _handlePickerResult(AvatarPickerResult result) async {
    if (result.isPermissionDenied) {
      _showPermissionDialog(result.errorMessage!, result.shouldShowPermissionDialog);
      return;
    }

    if (result.isCancelled) {
      return;
    }

    if (!result.isSuccess) {
      _showError(result.errorMessage!);
      return;
    }

    // Show crop screen
    final croppedFile = await AvatarCropper.cropAvatar(
      context,
      result.imageFile!,
      title: 'Обрезка аватара',
    );

    if (croppedFile == null) {
      return;
    }

    // Process and upload
    await _processAndUpload(croppedFile);
  }

  Future<void> _processAndUpload(File imageFile) async {
    try {
      // Simulate upload for now - will be replaced with real implementation
      await Future.delayed(const Duration(seconds: 2));
      
      // Simulate success
      const mockAvatarUrl = 'https://example.com/avatar.jpg';
      widget.onAvatarUploaded(mockAvatarUrl);
      
      _showSuccess('Аватар успешно обновлен!');
    } catch (e) {
      _showError('Ошибка загрузки: $e');
    }
  }

  Future<void> _deleteAvatar() async {
    final confirmed = await _showDeleteConfirmation();
    if (!confirmed) return;

    setState(() => _isUploading = true);

    try {
      // Simulate delete
      await Future.delayed(const Duration(seconds: 1));
      widget.onAvatarDeleted();
      _showSuccess('Аватар удален');
    } catch (e) {
      _showError('Ошибка удаления: $e');
    } finally {
      setState(() => _isUploading = false);
    }
  }

  Future<bool> _showDeleteConfirmation() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить фото профиля?'),
        content: const Text('Это действие нельзя отменить.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Удалить'),
          ),
        ],
      ),
    ) ?? false;
  }

  void _showPermissionDialog(String message, bool canOpenSettings) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Разрешение требуется'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          if (canOpenSettings)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
              child: const Text('Настройки'),
            ),
        ],
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
    widget.onError?.call();
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

/// Bottom sheet for avatar options
class AvatarOptionsBottomSheet extends StatelessWidget {
  final bool hasAvatar;
  final VoidCallback onCameraTap;
  final VoidCallback onGalleryTap;
  final VoidCallback? onDeleteTap;

  const AvatarOptionsBottomSheet({
    super.key,
    required this.hasAvatar,
    required this.onCameraTap,
    required this.onGalleryTap,
    this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Выберите действие',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _buildOption(
            icon: Icons.camera_alt,
            title: 'Камера',
            subtitle: 'Сделать новое фото',
            onTap: onCameraTap,
          ),
          _buildOption(
            icon: Icons.photo_library,
            title: 'Галерея',
            subtitle: 'Выбрать из галереи',
            onTap: onGalleryTap,
          ),
          if (hasAvatar && onDeleteTap != null)
            _buildOption(
              icon: Icons.delete,
              title: 'Удалить',
              subtitle: 'Удалить текущее фото',
              onTap: onDeleteTap!,
              color: Colors.red,
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? color,
  }) {
    final optionColor = color ?? AppColors.green;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: optionColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: optionColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
} 