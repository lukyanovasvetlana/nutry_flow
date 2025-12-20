import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutry_flow/shared/theme/app_colors.dart';
import 'package:nutry_flow/shared/theme/theme_manager.dart';
import 'package:nutry_flow/shared/design/tokens/design_tokens.dart';
import 'package:nutry_flow/shared/design/tokens/theme_tokens.dart';
import 'package:nutry_flow/shared/design/components/cards/nutry_card.dart';
import 'package:nutry_flow/core/services/supabase_service.dart';
import 'package:nutry_flow/features/auth/data/services/auth_service.dart';
import 'package:nutry_flow/config/supabase_config.dart';
import '../blocs/profile_bloc.dart';
import '../../domain/entities/user_profile.dart';
import '../../di/profile_dependencies.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_info_card.dart';
import '../widgets/profile_stats_card.dart';
import '../widgets/profile_goals_card.dart';
import 'profile_edit_screen.dart';
import 'dart:developer' as developer;

/// Объединенный экран профиля с TabBar для переключения между
/// просмотром профиля и настройками
class UnifiedProfileScreen extends StatefulWidget {
  final VoidCallback? onBackPressed;

  const UnifiedProfileScreen({
    super.key,
    this.onBackPressed,
  });

  @override
  State<UnifiedProfileScreen> createState() => _UnifiedProfileScreenState();
}

class _UnifiedProfileScreenState extends State<UnifiedProfileScreen> {
  ProfileBloc? _profileBloc;
  String? _userId;
  bool _isLoadingUser = true;

  // Настройки уведомлений
  bool _pushNotifications = true;
  bool _emailNotifications = true;

  @override
  void initState() {
    super.initState();
    // Загружаем пользователя после построения виджета
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCurrentUser();
    });
  }

  Future<void> _loadCurrentUser() async {
    try {
      // В демо-режиме используем фиктивный ID пользователя
      final isDemo = SupabaseConfig.isDemo;
      String? userId;
      
      if (isDemo) {
        // В демо-режиме создаем фиктивного пользователя
        userId = 'demo-user-id';
        developer.log('🔵 UnifiedProfileScreen: Demo mode, using demo user ID', name: 'UnifiedProfileScreen');
      } else {
        final user = SupabaseService.instance.currentUser;
        userId = user?.id;
      }
      
      if (userId != null) {
        developer.log('🔵 UnifiedProfileScreen: User ID set to $userId', name: 'UnifiedProfileScreen');
        setState(() {
          _userId = userId;
          _isLoadingUser = false;
        });
        
        // Убеждаемся, что ProfileDependencies инициализирован
        try {
          await ProfileDependencies.instance.initialize();
          developer.log('🔵 UnifiedProfileScreen: ProfileDependencies initialized', name: 'UnifiedProfileScreen');
        } catch (e) {
          developer.log('🔴 UnifiedProfileScreen: ProfileDependencies already initialized or error: $e', name: 'UnifiedProfileScreen');
        }
        
        _profileBloc = ProfileDependencies.createProfileBloc();
        developer.log('🔵 UnifiedProfileScreen: ProfileBloc created, loading profile for $userId', name: 'UnifiedProfileScreen');
        _profileBloc!.add(LoadProfile(_userId!));
      } else {
        setState(() {
          _isLoadingUser = false;
        });
        // Если пользователь не авторизован, перенаправляем на welcome
        if (mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/welcome',
                (route) => false,
              );
            }
          });
        }
      }
    } catch (e) {
      developer.log('Ошибка загрузки пользователя: $e', name: 'UnifiedProfileScreen');
      setState(() {
        _isLoadingUser = false;
      });
    }
  }

  @override
  void dispose() {
    _profileBloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingUser || _userId == null) {
      return Scaffold(
        backgroundColor: AppColors.dynamicBackground,
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              DesignTokens.colors.primary,
            ),
          ),
        ),
      );
    }

    if (_profileBloc == null) {
      return Scaffold(
        backgroundColor: AppColors.dynamicBackground,
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              DesignTokens.colors.primary,
            ),
          ),
        ),
      );
    }

    return BlocProvider<ProfileBloc>.value(
      value: _profileBloc!,
      child: Scaffold(
        backgroundColor: AppColors.dynamicBackground,
        appBar: AppBar(
          backgroundColor: AppColors.dynamicCard,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text(
            'Профиль',
            style: TextStyle(
              color: context.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: _buildProfileContent(),
      ),
    );
  }

  /// Основной контент профиля
  Widget _buildProfileContent() {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message,
                style: TextStyle(color: DesignTokens.colors.onError),
              ),
              backgroundColor: DesignTokens.colors.error,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is ProfileLoading) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                DesignTokens.colors.primary,
              ),
            ),
          );
        }

        if (state is ProfileError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: DesignTokens.colors.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'Ошибка загрузки профиля',
                  style: DesignTokens.typography.titleMediumStyle.copyWith(
                    color: DesignTokens.colors.onSurface,
                    fontWeight: DesignTokens.typography.semiBold,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    state.message,
                    style: DesignTokens.typography.bodyMediumStyle.copyWith(
                      color: DesignTokens.colors.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  decoration: BoxDecoration(
                    gradient: DesignTokens.colors.primaryGradient,
                    borderRadius: BorderRadius.circular(
                      DesignTokens.borders.md,
                    ),
                    boxShadow: DesignTokens.shadows.md,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_userId != null && _profileBloc != null) {
                        _profileBloc!.add(LoadProfile(_userId!));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      foregroundColor: DesignTokens.colors.onPrimary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          DesignTokens.borders.md,
                        ),
                      ),
                    ),
                    child: const Text('Повторить'),
                  ),
                ),
              ],
            ),
          );
        }

        if (state is ProfileLoaded ||
            state is ProfileUpdating ||
            state is ProfileUpdated) {
          final profile = state is ProfileLoaded
              ? state.profile
              : state is ProfileUpdating
                  ? state.profile
                  : (state as ProfileUpdated).profile;

          return RefreshIndicator(
            onRefresh: () async {
              if (_userId != null && _profileBloc != null) {
                _profileBloc!.add(RefreshProfile(_userId!));
              }
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Заголовок профиля: фото слева, имя и фамилия справа
                  _buildProfileHeader(profile),

                  const SizedBox(height: 12),

                  // Контейнер "Редактировать профиль"
                  _buildEditProfileCard(profile),

                  const SizedBox(height: 8),

                  // Контейнер "Оформление"
                  _buildThemeCard(),

                  const SizedBox(height: 8),

                  // Контейнер "Безопасность и настройки"
                  _buildSecurityAndSettingsCard(),

                  const SizedBox(height: 8),

                  // Контейнер "Юридическая информация"
                  _buildLegalInfoCard(),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  /// Заголовок профиля: фото слева, имя и фамилия справа, email и телефон ниже
  Widget _buildProfileHeader(UserProfile profile) {
    return NutryCard(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Фото профиля слева
          GestureDetector(
            onTap: () => _showAvatarOptions(context, profile),
            child: Stack(
              children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: DesignTokens.colors.primary.withValues(alpha: 0.1),
                    backgroundImage: profile.avatarUrl != null
                        ? NetworkImage(profile.avatarUrl!)
                        : null,
                    child: profile.avatarUrl == null
                        ? Icon(
                            Icons.person,
                            size: 32,
                            color: DesignTokens.colors.primary,
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: DesignTokens.colors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.dynamicCard,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        size: 14,
                        color: DesignTokens.colors.onPrimary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(width: DesignTokens.spacing.sm),
          // Имя, фамилия, email и телефон справа
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  // Имя и фамилия
                  Text(
                    '${profile.firstName} ${profile.lastName}',
                    style: DesignTokens.typography.titleMediumStyle.copyWith(
                      color: DesignTokens.colors.onSurface,
                      fontWeight: DesignTokens.typography.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Email
                  Row(
                    children: [
                      Icon(
                        Icons.email,
                        size: 14,
                        color: DesignTokens.colors.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          profile.email,
                          style: DesignTokens.typography.bodySmallStyle.copyWith(
                            color: DesignTokens.colors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  // Телефон
                  Row(
                    children: [
                      Icon(
                        Icons.phone,
                        size: 14,
                        color: DesignTokens.colors.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          profile.phone ?? 'Не указан',
                          style: DesignTokens.typography.bodySmallStyle.copyWith(
                            color: DesignTokens.colors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Контейнер "Редактировать профиль"
  Widget _buildEditProfileCard(UserProfile profile) {
    return _buildSectionCard(
      children: [
        _buildSettingsTile(
          icon: Icons.edit,
          title: 'Редактировать профиль',
          subtitle: 'Изменить имя, email, фото',
          onTap: () => _navigateToEditProfile(context, profile),
        ),
      ],
    );
  }

  /// Контейнер "Оформление"
  Widget _buildThemeCard() {
    final themeManager = ThemeManager();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Оформление'),
        _buildSectionCard(
          children: [
            ListenableBuilder(
              listenable: themeManager,
              builder: (context, child) {
                final isDark = themeManager.isDarkMode;
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  dense: true,
                  leading: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.dynamicPrimary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(DesignTokens.borders.sm),
                    ),
                    child: Icon(
                      isDark ? Icons.light_mode : Icons.dark_mode,
                      color: AppColors.dynamicPrimary,
                      size: 18,
                    ),
                  ),
                  title: Text(
                    'Тема приложения',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.dynamicTextPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    isDark
                        ? 'Используется тёмная тема приложения'
                        : 'Использовать тёмную тему приложения',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.dynamicTextSecondary,
                    ),
                  ),
                  trailing: Switch(
                    value: isDark,
                    onChanged: (value) {
                      themeManager.toggleTheme();
                    },
                    activeThumbColor: AppColors.dynamicPrimary,
                    activeTrackColor: AppColors.dynamicPrimary.withValues(alpha: 0.5),
                    inactiveThumbColor: AppColors.dynamicPrimary.withValues(alpha: 0.5),
                    inactiveTrackColor: AppColors.dynamicPrimary.withValues(alpha: 0.2),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  /// Контейнер "Безопасность и настройки"
  Widget _buildSecurityAndSettingsCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Безопасность и настройки'),
        _buildSectionCard(
          children: [
            _buildSettingsTile(
              icon: Icons.notifications,
              title: 'Настройки уведомлений',
              subtitle: 'Управление push и email уведомлениями',
              onTap: () {
                _showNotificationSettingsDialog();
              },
            ),
            _buildSettingsTile(
              icon: Icons.lock,
              title: 'Сменить пароль',
              subtitle: 'Обновить пароль аккаунта',
              onTap: _showChangePasswordDialog,
            ),
            _buildSettingsTile(
              icon: Icons.logout,
              title: 'Выйти из аккаунта',
              subtitle: 'Завершить текущую сессию',
              onTap: _showLogoutDialog,
              isDestructive: true,
            ),
          ],
        ),
      ],
    );
  }

  /// Контейнер "Юридическая информация"
  Widget _buildLegalInfoCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Юридическая информация'),
        _buildSectionCard(
          children: [
            _buildSettingsTile(
              icon: Icons.privacy_tip,
              title: 'Политика конфиденциальности',
              subtitle: 'Как мы используем ваши данные',
              onTap: _showPrivacyPolicy,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: DesignTokens.spacing.sm,
        left: DesignTokens.spacing.xs,
      ),
      child: Text(
        title,
        style: DesignTokens.typography.titleMediumStyle.copyWith(
          color: DesignTokens.colors.onSurface,
          fontWeight: DesignTokens.typography.semiBold,
        ),
      ),
    );
  }

  Widget _buildSectionCard({required List<Widget> children}) {
    return NutryCard(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback? onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      dense: true,
      leading: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: (isDestructive
                  ? DesignTokens.colors.error
                  : DesignTokens.colors.primary)
              .withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(DesignTokens.borders.sm),
        ),
        child: Icon(
          icon,
          color: isDestructive
              ? DesignTokens.colors.error
              : DesignTokens.colors.primary,
          size: 18,
        ),
      ),
      title: Text(
        title,
        style: DesignTokens.typography.bodyMediumStyle.copyWith(
          color: isDestructive
              ? DesignTokens.colors.error
              : DesignTokens.colors.onSurface,
          fontWeight: DesignTokens.typography.medium,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: DesignTokens.typography.bodySmallStyle.copyWith(
          color: isDestructive
              ? DesignTokens.colors.error.withValues(alpha: 0.7)
              : DesignTokens.colors.onSurfaceVariant,
        ),
      ),
      trailing: onTap != null
          ? Icon(
              Icons.chevron_right,
              color: DesignTokens.colors.onSurfaceVariant,
              size: 18,
            )
          : null,
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      dense: true,
      leading: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AppColors.dynamicPrimary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(DesignTokens.borders.sm),
        ),
        child: Icon(
          icon,
          color: AppColors.dynamicPrimary,
          size: 18,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          color: AppColors.dynamicTextPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: AppColors.dynamicTextSecondary,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: AppColors.dynamicPrimary,
        activeTrackColor: AppColors.dynamicPrimary.withValues(alpha: 0.5),
        inactiveThumbColor: AppColors.dynamicBorder,
        inactiveTrackColor: AppColors.dynamicSurfaceVariant,
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, UserProfile profile) {
    return NutryCard(
      child: Padding(
        padding: EdgeInsets.all(DesignTokens.spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: DesignTokens.colors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(DesignTokens.borders.sm),
                  ),
                  child: Icon(
                    Icons.flash_on,
                    color: DesignTokens.colors.primary,
                    size: 18,
                  ),
                ),
                SizedBox(width: DesignTokens.spacing.sm),
                Text(
                  'Быстрые действия',
                  style: DesignTokens.typography.titleMediumStyle.copyWith(
                    color: DesignTokens.colors.onSurface,
                    fontWeight: DesignTokens.typography.semiBold,
                  ),
                ),
              ],
            ),
            SizedBox(height: DesignTokens.spacing.md),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    context,
                    icon: Icons.edit,
                    label: 'Редактировать',
                    color: DesignTokens.colors.primary,
                    onTap: () => _navigateToEditProfile(context, profile),
                  ),
                ),
                SizedBox(width: DesignTokens.spacing.sm),
                Expanded(
                  child: _buildActionButton(
                    context,
                    icon: Icons.camera_alt,
                    label: 'Фото',
                    color: DesignTokens.colors.secondary,
                    onTap: () => _showAvatarOptions(context, profile),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(DesignTokens.borders.md),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: DesignTokens.spacing.md),
          decoration: BoxDecoration(
            gradient: color == DesignTokens.colors.primary
                ? DesignTokens.colors.primaryGradient
                : DesignTokens.colors.secondaryGradient,
            borderRadius: BorderRadius.circular(DesignTokens.borders.md),
            boxShadow: DesignTokens.shadows.sm,
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: DesignTokens.colors.onPrimary,
                size: DesignTokens.spacing.iconMedium,
              ),
              SizedBox(height: DesignTokens.spacing.xs),
              Text(
                label,
                style: DesignTokens.typography.bodySmallStyle.copyWith(
                  fontWeight: DesignTokens.typography.semiBold,
                  color: DesignTokens.colors.onPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToEditProfile(BuildContext context, UserProfile profile) {
    if (_profileBloc == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: _profileBloc!,
          child: ProfileEditScreen(userProfile: profile),
        ),
      ),
    ).then((updated) {
      if (updated == true && _userId != null && _profileBloc != null) {
        _profileBloc!.add(RefreshProfile(_userId!));
      }
    });
  }

  void _showAvatarOptions(BuildContext context, UserProfile profile) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(DesignTokens.borders.lg),
        ),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(DesignTokens.spacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: DesignTokens.colors.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: DesignTokens.spacing.md),
            Text(
              'Изменить фото профиля',
              style: DesignTokens.typography.titleMediumStyle.copyWith(
                color: DesignTokens.colors.onSurface,
                fontWeight: DesignTokens.typography.semiBold,
              ),
            ),
            SizedBox(height: DesignTokens.spacing.lg),
            Row(
              children: [
                Expanded(
                  child: _buildAvatarOption(
                    context,
                    icon: Icons.camera_alt,
                    label: 'Камера',
                    onTap: () {
                      Navigator.pop(context);
                      _uploadAvatar(context, 'camera');
                    },
                  ),
                ),
                SizedBox(width: DesignTokens.spacing.md),
                Expanded(
                  child: _buildAvatarOption(
                    context,
                    icon: Icons.photo_library,
                    label: 'Галерея',
                    onTap: () {
                      Navigator.pop(context);
                      _uploadAvatar(context, 'gallery');
                    },
                  ),
                ),
                SizedBox(width: DesignTokens.spacing.md),
                Expanded(
                  child: _buildAvatarOption(
                    context,
                    icon: Icons.delete,
                    label: 'Удалить',
                    color: DesignTokens.colors.error,
                    onTap: () {
                      Navigator.pop(context);
                      _deleteAvatar(context);
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: DesignTokens.spacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    final optionColor = color ?? DesignTokens.colors.primary;

    return Material(
      color: optionColor.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(DesignTokens.borders.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(DesignTokens.borders.md),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: DesignTokens.spacing.md),
          child: Column(
            children: [
              Icon(
                icon,
                color: optionColor,
                size: DesignTokens.spacing.iconLarge,
              ),
              SizedBox(height: DesignTokens.spacing.sm),
              Text(
                label,
                style: DesignTokens.typography.bodyMediumStyle.copyWith(
                  fontWeight: DesignTokens.typography.medium,
                  color: optionColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _uploadAvatar(BuildContext context, String source) {
    if (_userId == null || _profileBloc == null) return;

    // TODO: Реализовать выбор фото из камеры/галереи
    final imagePath =
        source == 'camera' ? '/camera/image.jpg' : '/gallery/image.jpg';

    _profileBloc!.add(UploadAvatar(_userId!, imagePath));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Загрузка фото...',
          style: TextStyle(color: DesignTokens.colors.onPrimary),
        ),
        backgroundColor: DesignTokens.colors.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _deleteAvatar(BuildContext context) {
    if (_userId == null || _profileBloc == null) return;

    _profileBloc!.add(DeleteAvatar(_userId!));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Фото удалено',
          style: TextStyle(color: DesignTokens.colors.onSecondary),
        ),
        backgroundColor: DesignTokens.colors.secondary,
      ),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.dynamicCard,
          title: Text(
            'Смена пароля',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.dynamicTextPrimary,
            ),
          ),
          content: Text(
            'Для смены пароля мы отправим вам ссылку на email.',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.dynamicTextSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Отмена',
                style: TextStyle(
                  color: AppColors.dynamicTextPrimary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: Реализовать отправку ссылки для смены пароля
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Ссылка для смены пароля отправлена на email',
                        style: TextStyle(
                          color: AppColors.dynamicOnPrimary,
                        ),
                      ),
                      backgroundColor: AppColors.dynamicPrimary,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.dynamicPrimary,
                foregroundColor: AppColors.dynamicOnPrimary,
              ),
              child: const Text('Отправить'),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: DesignTokens.colors.surface,
          title: Text(
            'Выйти из аккаунта',
            style: DesignTokens.typography.titleLargeStyle.copyWith(
              color: DesignTokens.colors.onSurface,
            ),
          ),
          content: Text(
            'Вы уверены, что хотите выйти из аккаунта?',
            style: DesignTokens.typography.bodyMediumStyle.copyWith(
              color: DesignTokens.colors.onSurfaceVariant,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Отмена',
                style: DesignTokens.typography.bodyMediumStyle.copyWith(
                  color: DesignTokens.colors.onSurfaceVariant,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  final authService = AuthService();
                  await authService.signOut();
                  if (!mounted) return;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        '/welcome',
                        (route) => false,
                      );
                    }
                  });
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Вы вышли из аккаунта',
                        style: TextStyle(
                          color: DesignTokens.colors.onPrimary,
                        ),
                      ),
                      backgroundColor: DesignTokens.colors.primary,
                    ),
                  );
                } catch (e) {
                  developer.log(
                    'Ошибка выхода из аккаунта: $e',
                    name: 'UnifiedProfileScreen',
                  );
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Ошибка выхода: $e',
                        style: TextStyle(
                          color: DesignTokens.colors.onError,
                        ),
                      ),
                      backgroundColor: DesignTokens.colors.error,
                    ),
                  );
                }
              },
              child: Text(
                'Выйти',
                style: DesignTokens.typography.bodyMediumStyle.copyWith(
                  color: DesignTokens.colors.error,
                  fontWeight: DesignTokens.typography.semiBold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showNotificationSettingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        bool pushNotifications = _pushNotifications;
        bool emailNotifications = _emailNotifications;
        
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: AppColors.dynamicCard,
              title: Text(
                'Настройки уведомлений',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.dynamicTextPrimary,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildSwitchTile(
                      icon: Icons.notifications,
                      title: 'Push-уведомления',
                      subtitle: 'Получать уведомления в приложении',
                      value: pushNotifications,
                      onChanged: (value) {
                        setDialogState(() {
                          pushNotifications = value;
                        });
                      },
                    ),
                    _buildSwitchTile(
                      icon: Icons.email,
                      title: 'Email-уведомления',
                      subtitle: 'Получать уведомления на email',
                      value: emailNotifications,
                      onChanged: (value) {
                        setDialogState(() {
                          emailNotifications = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Отмена',
                    style: TextStyle(
                      color: AppColors.dynamicTextPrimary,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _pushNotifications = pushNotifications;
                      _emailNotifications = emailNotifications;
                    });
                    Navigator.of(context).pop();
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Настройки уведомлений сохранены',
                            style: TextStyle(
                              color: AppColors.dynamicOnPrimary,
                            ),
                          ),
                          backgroundColor: AppColors.dynamicPrimary,
                        ),
                      );
                    }
                  },
                  child: Text(
                    'Сохранить',
                    style: TextStyle(
                      color: AppColors.dynamicPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.dynamicCard,
          title: Text(
            'Политика конфиденциальности',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.dynamicTextPrimary,
            ),
          ),
          content: SingleChildScrollView(
            child: Text(
              'NutryFlow уважает вашу конфиденциальность и обязуется защищать ваши личные данные.\n\n'
              'Мы собираем только необходимую информацию для предоставления наших услуг:\n'
              '• Данные профиля (имя, email, фото)\n'
              '• Данные о здоровье и питании\n'
              '• Настройки приложения\n\n'
              'Мы не передаем ваши данные третьим лицам без вашего согласия.\n\n'
              'Все данные хранятся в зашифрованном виде и защищены современными методами безопасности.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.dynamicTextSecondary,
                height: 1.5,
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.dynamicPrimary,
                foregroundColor: AppColors.dynamicOnPrimary,
              ),
              child: const Text('Закрыть'),
            ),
          ],
        );
      },
    );
  }
}


