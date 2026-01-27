import 'package:flutter/material.dart';
import 'package:nutry_flow/shared/theme/app_colors.dart';
import 'package:nutry_flow/shared/theme/app_styles.dart';
import 'package:nutry_flow/shared/theme/theme_manager.dart';
import 'package:nutry_flow/shared/design/tokens/design_tokens.dart';
import 'package:nutry_flow/shared/design/components/cards/nutry_card.dart';
import 'package:nutry_flow/core/services/supabase_service.dart';
import 'package:nutry_flow/features/auth/data/services/auth_service.dart';
import 'dart:developer' as developer;

class ProfileScreen extends StatefulWidget {
  final VoidCallback? onBackPressed;

  const ProfileScreen({super.key, this.onBackPressed});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  String? _userName = 'Пользователь';
  String? _userEmail = 'user@example.com';
  String? _avatarUrl;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = SupabaseService.instance.client?.auth.currentUser;
      if (user != null) {
        setState(() {
          _userEmail = user.email;
          _userName = user.userMetadata?['name'] as String? ??
              user.userMetadata?['firstName'] as String? ??
              'Пользователь';
        });
      }
    } catch (e) {
      developer.log('Ошибка загрузки данных пользователя: $e',
          name: 'ProfileScreen');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = ThemeManager();

    return Scaffold(
      backgroundColor: AppColors.dynamicBackground,
      appBar: AppBar(
        backgroundColor: AppColors.dynamicBackground,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Профиль',
          style: AppStyles.headlineMedium.copyWith(
            color: AppColors.dynamicTextPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Фотография и информация профиля
              _buildProfileHeader(),

              const SizedBox(height: 24),

              // Редактирование профиля
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildSectionCard(
                  children: [
                    _buildSettingsTile(
                      icon: Icons.edit,
                      title: 'Редактировать профиль',
                      subtitle: 'Изменить имя, email, фото',
                      onTap: () {
                        Navigator.pushNamed(context, '/profile-settings');
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Переключение темы
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildSectionCard(
                  children: [
                    ListenableBuilder(
                      listenable: themeManager,
                      builder: (context, child) {
                        final isDark = themeManager.isDarkMode;
                        return _buildSwitchTile(
                          icon: isDark ? Icons.light_mode : Icons.dark_mode,
                          title: isDark ? 'Тёмная тема' : 'Светлая тема',
                          subtitle: isDark
                              ? 'Используется тёмная тема приложения'
                              : 'Использовать тёмную тему приложения',
                          value: isDark,
                          onChanged: (value) {
                            themeManager.toggleTheme();
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Тема изменена на ${value ? 'темную' : 'светлую'}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: AppColors.primary,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Настройки и безопасность
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildSectionCard(
                  title: 'Настройки и безопасность',
                  children: [
                    _buildSwitchTile(
                      icon: Icons.notifications,
                      title: 'Push-уведомления',
                      subtitle: 'Получать уведомления в приложении',
                      value: _pushNotifications,
                      onChanged: (value) {
                        setState(() {
                          _pushNotifications = value;
                        });
                      },
                    ),
                    _buildSwitchTile(
                      icon: Icons.email,
                      title: 'Email-уведомления',
                      subtitle: 'Получать уведомления на email',
                      value: _emailNotifications,
                      onChanged: (value) {
                        setState(() {
                          _emailNotifications = value;
                        });
                      },
                    ),
                    _buildSettingsTile(
                      icon: Icons.lock,
                      title: 'Смена пароля',
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
              ),

              const SizedBox(height: 16),

              // Юридическая информация
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildSectionCard(
                  title: 'Юридическая информация',
                  children: [
                    _buildSettingsTile(
                      icon: Icons.privacy_tip,
                      title: 'Политика конфиденциальности',
                      subtitle: 'Как мы используем ваши данные',
                      onTap: _showPrivacyPolicy,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          // Фотография профиля
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                backgroundImage:
                    _avatarUrl != null ? NetworkImage(_avatarUrl!) : null,
                child: _avatarUrl == null
                    ? Icon(
                        Icons.person,
                        size: 50,
                        color: AppColors.primary,
                      )
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.dynamicBackground,
                      width: 2,
                    ),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.camera_alt, size: 20),
                    color: Colors.white,
                    onPressed: _showPhotoPicker,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _userName ?? 'Пользователь',
            style: AppStyles.headlineSmall.copyWith(
              color: AppColors.dynamicTextPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _userEmail ?? '',
            style: AppStyles.bodyMedium.copyWith(
              color: AppColors.dynamicTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    String? title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
            child: Text(
              title,
              style: DesignTokens.typography.titleMediumStyle.copyWith(
                color: AppColors.dynamicTextPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
        NutryCard(
          child: Column(
            children: children,
          ),
        ),
      ],
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
      leading: Icon(
        icon,
        color: isDestructive ? AppColors.error : AppColors.primary,
      ),
      title: Text(
        title,
        style: DesignTokens.typography.bodyLargeStyle.copyWith(
          color: isDestructive ? AppColors.error : AppColors.dynamicTextPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: DesignTokens.typography.bodyMediumStyle.copyWith(
          color: isDestructive
              ? AppColors.error.withValues(alpha: 0.7)
              : AppColors.dynamicTextSecondary,
        ),
      ),
      trailing: onTap != null
          ? Icon(
              Icons.chevron_right,
              color: AppColors.dynamicTextSecondary,
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
      leading: Icon(
        icon,
        color: AppColors.primary,
      ),
      title: Text(
        title,
        style: DesignTokens.typography.bodyLargeStyle.copyWith(
          color: AppColors.dynamicTextPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: DesignTokens.typography.bodyMediumStyle.copyWith(
          color: AppColors.dynamicTextSecondary,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: AppColors.primary,
        activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
      ),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.dynamicSurface,
          title: Text(
            'Смена пароля',
            style: DesignTokens.typography.titleLargeStyle.copyWith(
              color: AppColors.dynamicTextPrimary,
            ),
          ),
          content: Text(
            'Для смены пароля мы отправим вам ссылку на email.',
            style: DesignTokens.typography.bodyMediumStyle.copyWith(
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
                style: DesignTokens.typography.bodyMediumStyle.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: Реализовать отправку ссылки для смены пароля
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text('Ссылка для смены пароля отправлена на email'),
                  ),
                );
              },
              child: Text(
                'Отправить',
                style: DesignTokens.typography.bodyMediumStyle.copyWith(
                  color: AppColors.primary,
                ),
              ),
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
          backgroundColor: AppColors.dynamicSurface,
          title: Text(
            'Выйти из аккаунта',
            style: DesignTokens.typography.titleLargeStyle.copyWith(
              color: AppColors.dynamicTextPrimary,
            ),
          ),
          content: Text(
            'Вы уверены, что хотите выйти из аккаунта?',
            style: DesignTokens.typography.bodyMediumStyle.copyWith(
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
                style: DesignTokens.typography.bodyMediumStyle.copyWith(
                  color: AppColors.primary,
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
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/welcome',
                    (route) => false,
                  );
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Вы вышли из аккаунта',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: AppColors.primary,
                    ),
                  );
                } catch (e) {
                  developer.log('Ошибка выхода из аккаунта: $e',
                      name: 'ProfileScreen');
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Ошибка выхода: $e'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              },
              child: Text(
                'Выйти',
                style: DesignTokens.typography.bodyMediumStyle.copyWith(
                  color: AppColors.error,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showPhotoPicker() {
    // TODO: Реализовать выбор фото
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Выбор фотографии в разработке'),
      ),
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.dynamicSurface,
          title: Text(
            'Политика конфиденциальности',
            style: DesignTokens.typography.titleLargeStyle.copyWith(
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
              style: DesignTokens.typography.bodyMediumStyle.copyWith(
                color: AppColors.dynamicTextSecondary,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Закрыть',
                style: DesignTokens.typography.bodyMediumStyle.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
