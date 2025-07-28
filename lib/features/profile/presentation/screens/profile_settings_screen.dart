import 'package:flutter/material.dart';
import 'package:nutry_flow/shared/theme/app_colors.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({Key? key}) : super(key: key);

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _weeklyReports = false;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F4F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F4F2),
        elevation: 0,
        title: const Text(
          'Настройки профиля',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
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
                      const SnackBar(content: Text('Редактирование профиля в разработке')),
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
                      const SnackBar(content: Text('Смена пароля в разработке')),
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
                  icon: Icons.dark_mode,
                  title: 'Тёмная тема',
                  subtitle: 'Использовать тёмную тему приложения',
                  value: _darkMode,
                  onChanged: (value) {
                    setState(() {
                      _darkMode = value;
                    });
                    // TODO: Применить тёмную тему
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
                  onTap: () {
                    _showLogoutDialog();
                  },
                  isDestructive: true,
                ),
                _buildSettingsTile(
                  icon: Icons.delete_forever,
                  title: 'Удалить аккаунт',
                  subtitle: 'Безвозвратно удалить аккаунт и все данные',
                  onTap: () {
                    _showDeleteAccountDialog();
                  },
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
                      const SnackBar(content: Text('Политика конфиденциальности в разработке')),
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
                      const SnackBar(content: Text('Условия использования в разработке')),
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
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
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
        color: isDestructive ? Colors.red : AppColors.green,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Colors.red : Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: isDestructive ? Colors.red.withValues(alpha: 0.7) : Colors.grey[600],
        ),
      ),
      trailing: onTap != null
          ? const Icon(Icons.chevron_right, color: Colors.grey)
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
        color: AppColors.green,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.grey[600],
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.green,
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Выйти из аккаунта'),
          content: const Text('Вы уверены, что хотите выйти из аккаунта?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: Реализовать выход из аккаунта
                Navigator.of(context).pushNamedAndRemoveUntil('/welcome', (route) => false);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Вы вышли из аккаунта')),
                );
              },
              child: const Text(
                'Выйти',
                style: TextStyle(color: Colors.red),
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
          title: const Text('Удалить аккаунт'),
          content: const Text(
            'Это действие нельзя отменить. Все ваши данные будут безвозвратно удалены.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: Реализовать удаление аккаунта
                Navigator.of(context).pushNamedAndRemoveUntil('/welcome', (route) => false);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Аккаунт удалён')),
                );
              },
              child: const Text(
                'Удалить',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
} 