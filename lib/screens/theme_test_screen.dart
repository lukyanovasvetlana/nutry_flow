import 'package:flutter/material.dart';
import '../shared/design/tokens/design_tokens.dart';
import '../shared/design/tokens/theme_tokens.dart';
import '../shared/design/components/forms/forms.dart';
import '../shared/design/components/buttons/nutry_button.dart';
import '../shared/design/components/cards/nutry_card.dart';
import '../shared/design/components/animations/animations.dart';

/// Тестовый экран для демонстрации темной темы
class ThemeTestScreen extends StatefulWidget {
  const ThemeTestScreen({super.key});

  @override
  State<ThemeTestScreen> createState() => _ThemeTestScreenState();
}

class _ThemeTestScreenState extends State<ThemeTestScreen> {
  bool _isDarkMode = false;
  String _selectedCategory = '';
  bool _notificationsEnabled = true;
  bool _isLoading = false;

  final List<NutrySelectOption<String>> _categories = [
    const NutrySelectOption(
        value: 'breakfast', label: 'Завтрак', icon: Icons.wb_sunny),
    const NutrySelectOption(
        value: 'lunch', label: 'Обед', icon: Icons.restaurant),
    const NutrySelectOption(
        value: 'dinner', label: 'Ужин', icon: Icons.nights_stay),
    const NutrySelectOption(
        value: 'snack', label: 'Перекус', icon: Icons.coffee),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.background,
      appBar: AppBar(
        title: Text(
          'Тест темной темы',
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
            _buildThemeInfo(),
            SizedBox(height: DesignTokens.spacing.lg),
            _buildColorPalette(),
            SizedBox(height: DesignTokens.spacing.lg),
            _buildComponentsTest(),
            SizedBox(height: DesignTokens.spacing.lg),
            _buildAnimationsTest(),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeInfo() {
    return NutryCard(
      title: 'Информация о теме',
      subtitle: 'Текущая тема и её настройки',
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
          NutryButton.primary(
            text: 'Переключить тему',
            onPressed: _toggleTheme,
            isLoading: _isLoading,
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

  Widget _buildColorPalette() {
    return NutryCard(
      title: 'Цветовая палитра',
      subtitle: 'Основные цвета текущей темы',
      child: Column(
        children: [
          _buildColorRow('Primary', context.primary, context.onPrimary),
          _buildColorRow('Secondary', context.secondary, context.onSecondary),
          _buildColorRow('Error', context.error, context.onError),
          _buildColorRow('Success', context.success, context.onSuccess),
          _buildColorRow('Warning', context.warning, context.onWarning),
          _buildColorRow('Info', context.info, context.onInfo),
          SizedBox(height: DesignTokens.spacing.md),
          _buildColorRow(
              'Background', context.background, context.onBackground),
          _buildColorRow('Surface', context.surface, context.onSurface),
          _buildColorRow('Surface Variant', context.surfaceVariant,
              context.onSurfaceVariant),
        ],
      ),
    );
  }

  Widget _buildColorRow(String name, Color color, Color textColor) {
    return Container(
      margin: EdgeInsets.only(bottom: DesignTokens.spacing.sm),
      padding: EdgeInsets.all(DesignTokens.spacing.sm),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(DesignTokens.borders.sm),
        border: Border.all(
          color: context.outline,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name,
              style: DesignTokens.typography.bodyMediumStyle.copyWith(
                color: textColor,
                fontWeight: DesignTokens.typography.medium,
              ),
            ),
          ),
          Text(
            '#${color.value.toRadixString(16).toUpperCase()}',
            style: DesignTokens.typography.bodySmallStyle.copyWith(
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComponentsTest() {
    return NutryCard(
      title: 'Тест компонентов',
      subtitle: 'Компоненты в текущей теме',
      child: Column(
        children: [
          // Тест полей ввода
          NutryInput.email(
            label: 'Email',
            hint: 'Введите ваш email',
            controller: TextEditingController(),
          ),
          SizedBox(height: DesignTokens.spacing.md),
          NutryInput.password(
            label: 'Пароль',
            hint: 'Введите ваш пароль',
            controller: TextEditingController(),
          ),
          SizedBox(height: DesignTokens.spacing.md),

          // Тест селекта
          NutrySelect.dropdown(
            label: 'Категория питания',
            options: _categories,
            value: _selectedCategory,
            onChanged: (value) =>
                setState(() => _selectedCategory = value ?? ''),
          ),
          SizedBox(height: DesignTokens.spacing.md),

          // Тест чекбоксов
          NutryCheckbox.standard(
            label: 'Согласен с условиями',
            value: true,
            onChanged: (value) {},
          ),
          SizedBox(height: DesignTokens.spacing.sm),
          NutryCheckbox.switch_(
            label: 'Уведомления',
            subtitle: 'Получать push-уведомления',
            value: _notificationsEnabled,
            onChanged: (value) =>
                setState(() => _notificationsEnabled = value ?? false),
          ),
          SizedBox(height: DesignTokens.spacing.sm),
          NutryCheckbox.radio(
            label: 'Мужской пол',
            value: true,
            onChanged: (value) {},
          ),
          SizedBox(height: DesignTokens.spacing.md),

          // Тест кнопок
          Row(
            children: [
              Expanded(
                child: NutryButton.primary(
                  text: 'Основная',
                  onPressed: () {},
                ),
              ),
              SizedBox(width: DesignTokens.spacing.sm),
              Expanded(
                child: NutryButton.secondary(
                  text: 'Вторичная',
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnimationsTest() {
    return NutryCard(
      title: 'Тест анимаций',
      subtitle: 'Анимации в текущей теме',
      child: Column(
        children: [
          // Анимированная иконка
          NutryAnimations.animatedIcon(
            icon: Icons.favorite,
            isActive: true,
            size: 32,
            color: context.primary,
          ),
          SizedBox(height: DesignTokens.spacing.md),

          // Анимированный текст
          NutryAnimations.animatedText(
            text: 'Анимированный текст',
            isVisible: true,
            style: DesignTokens.typography.titleMediumStyle.copyWith(
              color: context.onSurface,
            ),
          ),
          SizedBox(height: DesignTokens.spacing.md),

          // Анимированная кнопка
          NutryAnimations.animatedButton(
            child: NutryButton.outline(
              text: 'Нажми меня',
              onPressed: () {},
            ),
            isPressed: false,
          ),
          SizedBox(height: DesignTokens.spacing.md),

          // Анимированный прогресс
          Container(
            width: double.infinity,
            height: 8,
            decoration: BoxDecoration(
              color: context.surfaceVariant,
              borderRadius: BorderRadius.circular(4),
            ),
            child: NutryAnimations.animatedProgress(
              progress: 75,
              maxProgress: 100,
              color: context.primary,
              height: 8,
            ),
          ),
        ],
      ),
    );
  }

  void _toggleTheme() {
    setState(() {
      _isLoading = true;
    });

    // Имитация загрузки
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _isDarkMode = !_isDarkMode;
        _isLoading = false;
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
        ),
      );
    });
  }
}
