import 'package:flutter/material.dart';
import '../../../../shared/design/tokens/design_tokens.dart';
import '../../../../shared/design/tokens/theme_tokens.dart';
import '../../../../shared/design/components/cards/nutry_card.dart';
import '../../../../shared/theme/theme_manager.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _weeklyReports = false;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _isDarkMode = ThemeManager().isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.background,
      appBar: AppBar(
        backgroundColor: context.surface,
        elevation: 0,
        title: Text(
          'Настройки профиля',
          style: DesignTokens.typography.titleLargeStyle.copyWith(
            color: context.onSurface,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.onSurface),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Личные данные
              _buildSectionHeader('Личные данные'),
              _buildSettingsCard([
                _buildSettingsTile(
                  icon: Icons.person,
                  title: 'Редактировать профиль',
                  subtitle: 'Изменить имя, email, фото',
                  onTap: () {
                    // TODO: Переход на экран редактирования профиля
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Редактирование профиля в разработке')),
                    );
                  },
                ),
                _buildSettingsTile(
                  icon: Icons.lock,
                  title: 'Изменить пароль',
                  subtitle: 'Обновить пароль аккаунта',
                  onTap: () {
                    // TODO: Переход на экран смены пароля
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Смена пароля в разработке')),
                    );
                  },
                ),
              ]),

              const SizedBox(height: 24),

              // Уведомления
              _buildSectionHeader('Уведомления'),
              _buildSettingsCard([
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
                _buildSwitchTile(
                  icon: Icons.assessment,
                  title: 'Еженедельные отчёты',
                  subtitle: 'Получать отчёты о прогрессе',
                  value: _weeklyReports,
                  onChanged: (value) {
                    setState(() {
                      _weeklyReports = value;
                    });
                  },
                ),
              ]),

              const SizedBox(height: 24),

              // Внешний вид
              _buildSectionHeader('Внешний вид'),
              _buildSettingsCard([
                _buildSwitchTile(
                  icon: _isDarkMode ? Icons.light_mode : Icons.dark_mode,
                  title: 'Тёмная тема',
                  subtitle: _isDarkMode
                      ? 'Используется тёмная тема приложения'
                      : 'Использовать тёмную тему приложения',
                  value: _isDarkMode,
                  onChanged: (value) async {
                    setState(() {
                      _isDarkMode = value;
                    });

                    // Переключение темы через ThemeManager
                    await ThemeManager().toggleTheme();

                    // Показать уведомление
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Тема изменена на ${_isDarkMode ? 'темную' : 'светлую'}',
                          style: TextStyle(color: context.onPrimary),
                        ),
                        backgroundColor: context.primary,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ]),

              const SizedBox(height: 24),

              // Аккаунт
              _buildSectionHeader('Аккаунт'),
              _buildSettingsCard([
                _buildSettingsTile(
                  icon: Icons.logout,
                  title: 'Выйти из аккаунта',
                  subtitle: 'Завершить текущую сессию',
                  onTap: _showLogoutDialog,
                  isDestructive: true,
                ),
                _buildSettingsTile(
                  icon: Icons.delete_forever,
                  title: 'Удалить аккаунт',
                  subtitle: 'Безвозвратно удалить аккаунт и все данные',
                  onTap: _showDeleteAccountDialog,
                  isDestructive: true,
                ),
              ]),

              const SizedBox(height: 24),

              // Информация о приложении
              _buildSectionHeader('О приложении'),
              _buildSettingsCard([
                _buildSettingsTile(
                  icon: Icons.info,
                  title: 'Версия приложения',
                  subtitle: '1.0.0',
                  onTap: null,
                ),
                _buildSettingsTile(
                  icon: Icons.privacy_tip,
                  title: 'Политика конфиденциальности',
                  subtitle: 'Как мы используем ваши данные',
                  onTap: () {
                    // TODO: Открыть политику конфиденциальности
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text('Политика конфиденциальности в разработке')),
                    );
                  },
                ),
                _buildSettingsTile(
                  icon: Icons.description,
                  title: 'Условия использования',
                  subtitle: 'Правила использования приложения',
                  onTap: () {
                    // TODO: Открыть условия использования
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Условия использования в разработке')),
                    );
                  },
                ),
              ]),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
      child: Text(
        title,
        style: DesignTokens.typography.titleMediumStyle.copyWith(
          color: context.onSurface,
          fontWeight: DesignTokens.typography.semiBold,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return NutryCard(
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
      leading: Icon(
        icon,
        color: isDestructive ? context.error : context.primary,
      ),
      title: Text(
        title,
        style: DesignTokens.typography.bodyLargeStyle.copyWith(
          color: isDestructive ? context.error : context.onSurface,
          fontWeight: DesignTokens.typography.medium,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: DesignTokens.typography.bodyMediumStyle.copyWith(
          color: isDestructive
              ? context.error.withOpacity(0.7)
              : context.onSurfaceVariant,
        ),
      ),
      trailing: onTap != null
          ? Icon(Icons.chevron_right, color: context.onSurfaceVariant)
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
        color: context.primary,
      ),
      title: Text(
        title,
        style: DesignTokens.typography.bodyLargeStyle.copyWith(
          color: context.onSurface,
          fontWeight: DesignTokens.typography.medium,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: DesignTokens.typography.bodyMediumStyle.copyWith(
          color: context.onSurfaceVariant,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: context.primary,
        activeTrackColor: context.primaryContainer,
        inactiveThumbColor: context.outline,
        inactiveTrackColor: context.surfaceVariant,
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: context.surface,
          title: Text(
            'Выйти из аккаунта',
            style: DesignTokens.typography.titleLargeStyle.copyWith(
              color: context.onSurface,
            ),
          ),
          content: Text(
            'Вы уверены, что хотите выйти из аккаунта?',
            style: DesignTokens.typography.bodyMediumStyle.copyWith(
              color: context.onSurfaceVariant,
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
                  color: context.primary,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: Реализовать выход из аккаунта
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/welcome', (route) => false);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Вы вышли из аккаунта',
                      style: TextStyle(color: context.onPrimary),
                    ),
                    backgroundColor: context.primary,
                  ),
                );
              },
              child: Text(
                'Выйти',
                style: DesignTokens.typography.bodyMediumStyle.copyWith(
                  color: context.error,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: context.surface,
          title: Text(
            'Удалить аккаунт',
            style: DesignTokens.typography.titleLargeStyle.copyWith(
              color: context.onSurface,
            ),
          ),
          content: Text(
            'Это действие нельзя отменить. Все ваши данные будут безвозвратно удалены.',
            style: DesignTokens.typography.bodyMediumStyle.copyWith(
              color: context.onSurfaceVariant,
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
                  color: context.primary,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: Реализовать удаление аккаунта
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/welcome', (route) => false);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Аккаунт удалён',
                      style: TextStyle(color: context.onPrimary),
                    ),
                    backgroundColor: context.primary,
                  ),
                );
              },
              child: Text(
                'Удалить',
                style: DesignTokens.typography.bodyMediumStyle.copyWith(
                  color: context.error,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
