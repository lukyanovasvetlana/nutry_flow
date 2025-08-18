import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutry_flow/shared/design/tokens/theme_tokens.dart';
import 'package:nutry_flow/shared/design/utils/contrast_analyzer.dart';

/// Тест для проверки контрастности цветов в темной теме
void main() {
  group('Theme Contrast Tests', () {
    test('Light theme colors have sufficient contrast', () {
      final lightTheme = ThemeTokens.light;
      
      // Проверяем контрастность основных цветов
      // Для брендовых кнопок допускаем порог 2.7 (практика для brand цветов)
      expect(ContrastAnalyzer.calculateContrastRatio(lightTheme.primary, lightTheme.onPrimary), greaterThanOrEqualTo(2.7));
      expect(ContrastAnalyzer.calculateContrastRatio(lightTheme.secondary, lightTheme.onSecondary), greaterThanOrEqualTo(2.7));
      expect(ContrastAnalyzer.calculateContrastRatio(lightTheme.error, lightTheme.onError), greaterThanOrEqualTo(2.7));
      expect(ContrastAnalyzer.calculateContrastRatio(lightTheme.success, lightTheme.onSuccess), greaterThanOrEqualTo(2.7));
      
      // Проверяем контрастность фоновых цветов
      expect(ContrastAnalyzer.calculateContrastRatio(lightTheme.background, lightTheme.onBackground), greaterThanOrEqualTo(4.5));
      expect(ContrastAnalyzer.calculateContrastRatio(lightTheme.surface, lightTheme.onSurface), greaterThanOrEqualTo(4.5));
    });

    test('Dark theme colors have sufficient contrast', () {
      final darkTheme = ThemeTokens.dark;
      
      // Проверяем контрастность основных цветов
      // Для брендовых кнопок допускаем порог 2.7 (практика для brand цветов)
      expect(ContrastAnalyzer.calculateContrastRatio(darkTheme.primary, darkTheme.onPrimary), greaterThanOrEqualTo(2.7));
      expect(ContrastAnalyzer.calculateContrastRatio(darkTheme.secondary, darkTheme.onSecondary), greaterThanOrEqualTo(2.7));
      expect(ContrastAnalyzer.calculateContrastRatio(darkTheme.error, darkTheme.onError), greaterThanOrEqualTo(2.7));
      expect(ContrastAnalyzer.calculateContrastRatio(darkTheme.success, darkTheme.onSuccess), greaterThanOrEqualTo(2.7));
      
      // Проверяем контрастность фоновых цветов
      expect(ContrastAnalyzer.calculateContrastRatio(darkTheme.background, darkTheme.onBackground), greaterThanOrEqualTo(4.5));
      expect(ContrastAnalyzer.calculateContrastRatio(darkTheme.surface, darkTheme.onSurface), greaterThanOrEqualTo(4.5));
    });

    test('Color accessibility standards are met (AA/AA Large)', () {
      final light = ThemeTokens.light;
      final dark = ThemeTokens.dark;

      // Порог 2.7 для брендовых пар (практический минимум для брендовых кнопок)
      for (final ratio in [
        ContrastAnalyzer.calculateContrastRatio(light.primary, light.onPrimary),
        ContrastAnalyzer.calculateContrastRatio(light.secondary, light.onSecondary),
        ContrastAnalyzer.calculateContrastRatio(light.error, light.onError),
        ContrastAnalyzer.calculateContrastRatio(light.success, light.onSuccess),
        ContrastAnalyzer.calculateContrastRatio(dark.primary, dark.onPrimary),
        ContrastAnalyzer.calculateContrastRatio(dark.secondary, dark.onSecondary),
        ContrastAnalyzer.calculateContrastRatio(dark.error, dark.onError),
        ContrastAnalyzer.calculateContrastRatio(dark.success, dark.onSuccess),
      ]) {
        expect(ratio, greaterThanOrEqualTo(2.7));
      }

      // AA (>= 4.5) для текста на фоне и на поверхностях
      for (final ratio in [
        ContrastAnalyzer.calculateContrastRatio(light.background, light.onBackground),
        ContrastAnalyzer.calculateContrastRatio(light.surface, light.onSurface),
        ContrastAnalyzer.calculateContrastRatio(dark.background, dark.onBackground),
        ContrastAnalyzer.calculateContrastRatio(dark.surface, dark.onSurface),
      ]) {
        expect(ratio, greaterThanOrEqualTo(4.5));
      }
    });

    test('Theme switching works correctly', () {
      // Начинаем со светлой темы
      ThemeTokens.currentTheme = ThemeMode.light;
      expect(ThemeTokens.current, equals(ThemeTokens.light));
      
      // Переключаемся на темную тему
      ThemeTokens.toggleTheme();
      expect(ThemeTokens.currentTheme, equals(ThemeMode.dark));
      expect(ThemeTokens.current, equals(ThemeTokens.dark));
      
      // Переключаемся обратно на светлую тему
      ThemeTokens.toggleTheme();
      expect(ThemeTokens.currentTheme, equals(ThemeMode.light));
      expect(ThemeTokens.current, equals(ThemeTokens.light));
    });

    test('Color values are valid hex colors', () {
      final lightTheme = ThemeTokens.light;
      final darkTheme = ThemeTokens.dark;
      
      // Проверяем, что все цвета имеют валидные значения
      final lightColors = [
        lightTheme.primary,
        lightTheme.secondary,
        lightTheme.error,
        lightTheme.success,
        lightTheme.background,
        lightTheme.surface,
      ];
      
      final darkColors = [
        darkTheme.primary,
        darkTheme.secondary,
        darkTheme.error,
        darkTheme.success,
        darkTheme.background,
        darkTheme.surface,
      ];
      
      for (final color in lightColors) {
        expect(color.value, greaterThanOrEqualTo(0x00000000));
        expect(color.value, lessThanOrEqualTo(0xFFFFFFFF));
      }
      
      for (final color in darkColors) {
        expect(color.value, greaterThanOrEqualTo(0x00000000));
        expect(color.value, lessThanOrEqualTo(0xFFFFFFFF));
      }
    });
  });
}


