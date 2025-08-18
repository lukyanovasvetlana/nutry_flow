import 'package:flutter/material.dart';
import '../shared/design/tokens/design_tokens.dart';
import '../shared/design/tokens/theme_tokens.dart';
import '../shared/design/components/cards/nutry_card.dart';
import '../shared/design/components/buttons/nutry_button.dart';
import '../features/profile/presentation/screens/profile_settings_screen.dart';

/// Демонстрационный экран для тестирования тумблера темной темы
class ThemeSwitchDemoScreen extends StatefulWidget {
  const ThemeSwitchDemoScreen({super.key});

  @override
  State<ThemeSwitchDemoScreen> createState() => _ThemeSwitchDemoScreenState();
}

class _ThemeSwitchDemoScreenState extends State<ThemeSwitchDemoScreen> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _isDarkMode = ThemeTokens.currentTheme == ThemeMode.dark;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.background,
      appBar: AppBar(
        title: Text(
          'Демо тумблера темной темы',
          style: DesignTokens.typography.titleLargeStyle.copyWith(
            color: context.onSurface,
          ),
        ),
        backgroundColor: context.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              _isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: context.onSurface,
            ),
            onPressed: _toggleTheme,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(DesignTokens.spacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard(),
            SizedBox(height: DesignTokens.spacing.lg),
            _buildThemeSwitchCard(),
            SizedBox(height: DesignTokens.spacing.lg),
            _buildSettingsDemoCard(),
            SizedBox(height: DesignTokens.spacing.lg),
            _buildThemeInfoCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return NutryCard(
      title: 'Информация о тумблере',
      subtitle: 'Демонстрация работы переключателя темной темы',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Этот экран демонстрирует работу тумблера темной темы в настройках пользователя.',
            style: DesignTokens.typography.bodyMediumStyle.copyWith(
              color: context.onSurfaceVariant,
            ),
          ),
          SizedBox(height: DesignTokens.spacing.md),
          Text(
            'Функции:',
            style: DesignTokens.typography.bodyLargeStyle.copyWith(
              color: context.onSurface,
              fontWeight: DesignTokens.typography.medium,
            ),
          ),
          SizedBox(height: DesignTokens.spacing.sm),
          _buildFeatureItem('Переключение между светлой и темной темой'),
          _buildFeatureItem('Автоматическое обновление UI'),
          _buildFeatureItem('Сохранение выбора пользователя'),
          _buildFeatureItem('Уведомления о смене темы'),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: DesignTokens.spacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
            color: context.success,
            size: 16,
          ),
          SizedBox(width: DesignTokens.spacing.sm),
          Expanded(
            child: Text(
              text,
              style: DesignTokens.typography.bodyMediumStyle.copyWith(
                color: context.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeSwitchCard() {
    return NutryCard(
      title: 'Тумблер темной темы',
      subtitle: 'Интерактивный переключатель',
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              _isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: context.primary,
            ),
            title: Text(
              'Тёмная тема',
              style: DesignTokens.typography.bodyLargeStyle.copyWith(
                color: context.onSurface,
                fontWeight: DesignTokens.typography.medium,
              ),
            ),
            subtitle: Text(
              _isDarkMode
                  ? 'Используется тёмная тема приложения'
                  : 'Использовать тёмную тему приложения',
              style: DesignTokens.typography.bodyMediumStyle.copyWith(
                color: context.onSurfaceVariant,
              ),
            ),
            trailing: Switch(
              value: _isDarkMode,
              onChanged: (value) {
                setState(() {
                  _isDarkMode = value;
                });

                // Переключение темы
                ThemeTokens.toggleTheme();

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
              activeColor: context.primary,
              activeTrackColor: context.primaryContainer,
              inactiveThumbColor: context.outline,
              inactiveTrackColor: context.surfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsDemoCard() {
    return NutryCard(
      title: 'Демо настроек',
      subtitle: 'Открыть экран настроек с тумблером',
      child: Column(
        children: [
          Text(
            'Нажмите кнопку ниже, чтобы открыть экран настроек пользователя с работающим тумблером темной темы.',
            style: DesignTokens.typography.bodyMediumStyle.copyWith(
              color: context.onSurfaceVariant,
            ),
          ),
          SizedBox(height: DesignTokens.spacing.md),
          NutryButton.primary(
            text: 'Открыть настройки',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileSettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildThemeInfoCard() {
    return NutryCard(
      title: 'Информация о теме',
      subtitle: 'Текущие настройки темы',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow('Текущая тема', _isDarkMode ? 'Темная' : 'Светлая'),
          _buildInfoRow('Background',
              '#${context.background.value.toRadixString(16).toUpperCase()}'),
          _buildInfoRow('Surface',
              '#${context.surface.value.toRadixString(16).toUpperCase()}'),
          _buildInfoRow('Primary',
              '#${context.primary.value.toRadixString(16).toUpperCase()}'),
          _buildInfoRow('On Surface',
              '#${context.onSurface.value.toRadixString(16).toUpperCase()}'),
          SizedBox(height: DesignTokens.spacing.md),
          Row(
            children: [
              Expanded(
                child: NutryButton.outline(
                  text: 'Светлая тема',
                  onPressed: () => _setTheme(ThemeMode.light),
                ),
              ),
              SizedBox(width: DesignTokens.spacing.sm),
              Expanded(
                child: NutryButton.outline(
                  text: 'Темная тема',
                  onPressed: () => _setTheme(ThemeMode.dark),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: DesignTokens.spacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: DesignTokens.typography.bodyMediumStyle.copyWith(
              color: context.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: DesignTokens.typography.bodyMediumStyle.copyWith(
              color: context.onSurface,
              fontWeight: DesignTokens.typography.medium,
            ),
          ),
        ],
      ),
    );
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });

    ThemeTokens.toggleTheme();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Тема изменена на ${_isDarkMode ? 'темную' : 'светлую'}',
          style: TextStyle(color: context.onPrimary),
        ),
        backgroundColor: context.primary,
      ),
    );
  }

  void _setTheme(ThemeMode themeMode) {
    setState(() {
      _isDarkMode = themeMode == ThemeMode.dark;
    });

    ThemeTokens.currentTheme = themeMode;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Тема установлена: ${themeMode == ThemeMode.dark ? 'темная' : 'светлая'}',
          style: TextStyle(color: context.onPrimary),
        ),
        backgroundColor: context.primary,
      ),
    );
  }
}
