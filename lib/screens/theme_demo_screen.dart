import 'package:flutter/material.dart';
import '../shared/design/tokens/design_tokens.dart';
import '../shared/design/components/cards/nutry_card.dart';
import '../shared/design/components/buttons/nutry_button.dart';
import '../shared/theme/theme_manager.dart';

/// Демонстрационный экран для тестирования темной темы во всем приложении
class ThemeDemoScreen extends StatefulWidget {
  const ThemeDemoScreen({super.key});

  @override
  State<ThemeDemoScreen> createState() => _ThemeDemoScreenState();
}

class _ThemeDemoScreenState extends State<ThemeDemoScreen> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeManager(),
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text(
              'Демо темной темы',
              style: DesignTokens.typography.titleLargeStyle.copyWith(
                color: Theme.of(context).appBarTheme.foregroundColor,
              ),
            ),
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            elevation: 0,
            actions: [
              IconButton(
                icon: Icon(
                  ThemeManager().themeIcon,
                  color: Theme.of(context).appBarTheme.foregroundColor,
                ),
                onPressed: () {
                  ThemeManager().toggleTheme();
                },
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
                _buildComponentsDemo(),
                SizedBox(height: DesignTokens.spacing.lg),
                _buildNavigationDemo(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoCard() {
    return NutryCard(
      title: 'Информация о теме',
      subtitle: 'Текущие настройки темы',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow(
              'Текущая тема', ThemeManager().isDarkMode ? 'Темная' : 'Светлая'),
          _buildInfoRow('Background',
              '#${Theme.of(context).scaffoldBackgroundColor.value.toRadixString(16).toUpperCase()}'),
          _buildInfoRow('Surface',
              '#${Theme.of(context).cardTheme.color?.value.toRadixString(16).toUpperCase() ?? 'N/A'}'),
          _buildInfoRow('Primary',
              '#${Theme.of(context).primaryColor.value.toRadixString(16).toUpperCase()}'),
          _buildInfoRow('On Surface',
              '#${Theme.of(context).colorScheme.onSurface.value.toRadixString(16).toUpperCase()}'),
          SizedBox(height: DesignTokens.spacing.md),
          Row(
            children: [
              Expanded(
                child: NutryButton.outline(
                  text: 'Светлая тема',
                  onPressed: () {
                    ThemeManager().setTheme(ThemeMode.light);
                  },
                ),
              ),
              SizedBox(width: DesignTokens.spacing.sm),
              Expanded(
                child: NutryButton.outline(
                  text: 'Темная тема',
                  onPressed: () {
                    ThemeManager().setTheme(ThemeMode.dark);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildThemeSwitchCard() {
    return NutryCard(
      title: 'Переключатель темы',
      subtitle: 'Интерактивный тумблер',
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              ThemeManager().themeIcon,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(
              'Тёмная тема',
              style: DesignTokens.typography.bodyLargeStyle.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: DesignTokens.typography.medium,
              ),
            ),
            subtitle: Text(
              ThemeManager().isDarkMode
                  ? 'Используется тёмная тема приложения'
                  : 'Использовать тёмную тему приложения',
              style: DesignTokens.typography.bodyMediumStyle.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            trailing: Switch(
              value: ThemeManager().isDarkMode,
              onChanged: (value) {
                ThemeManager().toggleTheme();
              },
              activeThumbColor: Theme.of(context).primaryColor,
              activeTrackColor: Theme.of(context).colorScheme.primaryContainer,
              inactiveThumbColor: Theme.of(context).colorScheme.outline,
              inactiveTrackColor:
                  Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComponentsDemo() {
    return NutryCard(
      title: 'Демо компонентов',
      subtitle: 'Компоненты в текущей теме',
      child: Column(
        children: [
          // Кнопки
          Row(
            children: [
              Expanded(
                child: NutryButton.primary(
                  text: 'Основная кнопка',
                  onPressed: () {},
                ),
              ),
              SizedBox(width: DesignTokens.spacing.sm),
              Expanded(
                child: NutryButton.outline(
                  text: 'Контурная кнопка',
                  onPressed: () {},
                ),
              ),
            ],
          ),
          SizedBox(height: DesignTokens.spacing.md),

          // Карточки
          NutryCard(
            title: 'Вложенная карточка',
            subtitle: 'Демонстрация вложенности',
            child: Text(
              'Это вложенная карточка для демонстрации работы темной темы',
              style: DesignTokens.typography.bodyMediumStyle.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),

          SizedBox(height: DesignTokens.spacing.md),

          // Прогресс
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Прогресс',
                style: DesignTokens.typography.bodyMediumStyle.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: DesignTokens.typography.medium,
                ),
              ),
              SizedBox(height: DesignTokens.spacing.sm),
              LinearProgressIndicator(
                value: 0.7,
                backgroundColor:
                    Theme.of(context).colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationDemo() {
    return NutryCard(
      title: 'Навигация',
      subtitle: 'Демо навигационных элементов',
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              Icons.home,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(
              'Главная',
              style: DesignTokens.typography.bodyLargeStyle.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(
              'Настройки',
              style: DesignTokens.typography.bodyLargeStyle.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.person,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(
              'Профиль',
              style: DesignTokens.typography.bodyLargeStyle.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            onTap: () {},
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
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: DesignTokens.typography.bodyMediumStyle.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: DesignTokens.typography.medium,
            ),
          ),
        ],
      ),
    );
  }
}
