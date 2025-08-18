import 'package:flutter/material.dart';

import '../shared/design/tokens/design_tokens.dart';
import '../shared/design/tokens/theme_tokens.dart';
import '../shared/design/components/cards/nutry_card.dart';
import '../shared/design/components/buttons/nutry_button.dart';

class DarkThemeTestScreen extends StatefulWidget {
  const DarkThemeTestScreen({super.key});

  @override
  State<DarkThemeTestScreen> createState() => _DarkThemeTestScreenState();
}

class _DarkThemeTestScreenState extends State<DarkThemeTestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeTokens.current.background,
      appBar: AppBar(
        backgroundColor: ThemeTokens.current.surface,
        elevation: 0,
        title: Text(
          'Тест темной темы',
          style: DesignTokens.typography.titleLargeStyle.copyWith(
            color: ThemeTokens.current.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.brightness_6,
              color: ThemeTokens.current.onSurface,
            ),
            onPressed: () {
              setState(ThemeTokens.toggleTheme);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок
            Text(
              'Демонстрация темной темы',
              style: DesignTokens.typography.headlineLargeStyle.copyWith(
                color: ThemeTokens.current.onBackground,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Текущая тема: ${ThemeTokens.currentTheme == ThemeMode.light ? "Светлая" : "Темная"}',
              style: DesignTokens.typography.bodyMediumStyle.copyWith(
                color: ThemeTokens.current.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),

            // Карточки с цветами
            _buildColorCards(),
            const SizedBox(height: 24),

            // Кнопки
            _buildButtons(),
            const SizedBox(height: 24),

            // Тексты
            _buildTexts(),
            const SizedBox(height: 24),

            // Градиенты
            _buildGradients(),
          ],
        ),
      ),
    );
  }

  Widget _buildColorCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Цвета темы',
          style: DesignTokens.typography.titleLargeStyle.copyWith(
            color: ThemeTokens.current.onBackground,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildColorCard(
                'Primary',
                ThemeTokens.current.primary,
                ThemeTokens.current.onPrimary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildColorCard(
                'Secondary',
                ThemeTokens.current.secondary,
                ThemeTokens.current.onSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildColorCard(
                'Surface',
                ThemeTokens.current.surface,
                ThemeTokens.current.onSurface,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildColorCard(
                'Background',
                ThemeTokens.current.background,
                ThemeTokens.current.onBackground,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildColorCard(String title, Color backgroundColor, Color textColor) {
    return NutryCard(
      backgroundColor: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: DesignTokens.typography.titleMediumStyle.copyWith(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Цвет фона и текста',
              style: DesignTokens.typography.bodySmallStyle.copyWith(
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Кнопки',
          style: DesignTokens.typography.titleLargeStyle.copyWith(
            color: ThemeTokens.current.onBackground,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: NutryButton.primary(
                onPressed: () {},
                text: 'Primary',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: NutryButton.secondary(
                onPressed: () {},
                text: 'Secondary',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: NutryButton.outline(
                onPressed: () {},
                text: 'Outline',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: NutryButton.destructive(
                onPressed: () {},
                text: 'Destructive',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTexts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Типографика',
          style: DesignTokens.typography.titleLargeStyle.copyWith(
            color: ThemeTokens.current.onBackground,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Headline Large',
          style: DesignTokens.typography.headlineLargeStyle.copyWith(
            color: ThemeTokens.current.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Title Large',
          style: DesignTokens.typography.titleLargeStyle.copyWith(
            color: ThemeTokens.current.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Body Large',
          style: DesignTokens.typography.bodyLargeStyle.copyWith(
            color: ThemeTokens.current.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Body Medium',
          style: DesignTokens.typography.bodyMediumStyle.copyWith(
            color: ThemeTokens.current.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Body Small',
          style: DesignTokens.typography.bodySmallStyle.copyWith(
            color: ThemeTokens.current.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildGradients() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Градиенты',
          style: DesignTokens.typography.titleLargeStyle.copyWith(
            color: ThemeTokens.current.onBackground,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 100,
          decoration: BoxDecoration(
            gradient: ThemeTokens.current.primaryGradient,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              'Primary Gradient',
              style: DesignTokens.typography.titleMediumStyle.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 100,
          decoration: BoxDecoration(
            gradient: ThemeTokens.current.secondaryGradient,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              'Secondary Gradient',
              style: DesignTokens.typography.titleMediumStyle.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
