import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../tokens/design_tokens.dart';
import 'contrast_analyzer.dart';

/// Результат валидации токена
class ValidationResult {
  final bool isValid;
  final List<String> errors;
  final List<String> warnings;
  final List<String> recommendations;

  const ValidationResult({
    required this.isValid,
    this.errors = const [],
    this.warnings = const [],
    this.recommendations = const [],
  });

  /// Проверяет, есть ли критические ошибки
  bool get hasErrors => errors.isNotEmpty;

  /// Проверяет, есть ли предупреждения
  bool get hasWarnings => warnings.isNotEmpty;

  /// Полный отчет о валидации
  String get report {
    final buffer = StringBuffer();

    if (isValid) {
      buffer.writeln('✅ Токен прошел валидацию');
    } else {
      buffer.writeln('❌ Токен не прошел валидацию');
    }

    if (errors.isNotEmpty) {
      buffer.writeln('\n🚨 Ошибки:');
      for (final error in errors) {
        buffer.writeln('  • $error');
      }
    }

    if (warnings.isNotEmpty) {
      buffer.writeln('\n⚠️ Предупреждения:');
      for (final warning in warnings) {
        buffer.writeln('  • $warning');
      }
    }

    if (recommendations.isNotEmpty) {
      buffer.writeln('\n💡 Рекомендации:');
      for (final recommendation in recommendations) {
        buffer.writeln('  • $recommendation');
      }
    }

    return buffer.toString();
  }
}

/// Валидатор дизайн-токенов
/// Проверяет корректность цветов, контрастности и других параметров
class TokenValidator {
  // Prevent instantiation
  TokenValidator._();

  /// Валидирует цвет
  static ValidationResult validateColor(Color color, String tokenName) {
    final errors = <String>[];
    final warnings = <String>[];
    final recommendations = <String>[];

    // Проверка на null (не нужно в Dart с null safety)

    // Проверка на прозрачность
    if (color.opacity < 0.1) {
      warnings.add(
          'Цвет слишком прозрачный (opacity: ${color.opacity.toStringAsFixed(2)})');
    }

    // Проверка на слишком светлый цвет
    if (color.computeLuminance() > 0.9) {
      warnings.add(
          'Цвет слишком светлый (luminance: ${color.computeLuminance().toStringAsFixed(3)})');
    }

    // Проверка на слишком темный цвет
    if (color.computeLuminance() < 0.1) {
      warnings.add(
          'Цвет слишком темный (luminance: ${color.computeLuminance().toStringAsFixed(3)})');
    }

    // Проверка на серый цвет (возможно, неинтересный)
    final hsl = HSLColor.fromColor(color);
    if (hsl.saturation < 0.1) {
      recommendations
          .add('Цвет очень ненасыщенный, возможно стоит добавить больше цвета');
    }

    return ValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      warnings: warnings,
      recommendations: recommendations,
    );
  }

  /// Валидирует пару цветов на контрастность
  static ValidationResult validateColorPair(
      Color foreground, Color background, String pairName) {
    final errors = <String>[];
    final warnings = <String>[];
    final recommendations = <String>[];

    // Проверка контрастности
    final contrastRatio =
        ContrastAnalyzer.calculateContrastRatio(foreground, background);

    if (!ContrastAnalyzer.meetsAAContrast(foreground, background)) {
      errors.add(
          'Контрастность не соответствует стандарту AA (${contrastRatio.toStringAsFixed(2)}:1)');
    } else if (!ContrastAnalyzer.meetsAAAContrast(foreground, background)) {
      warnings.add(
          'Контрастность не соответствует стандарту AAA (${contrastRatio.toStringAsFixed(2)}:1)');
    }

    // Проверка на одинаковые цвета
    if (foreground == background) {
      errors.add('Цвета переднего плана и фона одинаковые');
    }

    // Проверка на слишком близкие цвета
    final colorDistance = _calculateColorDistance(foreground, background);
    if (colorDistance < 50) {
      warnings.add(
          'Цвета слишком похожи (distance: ${colorDistance.toStringAsFixed(1)})');
    }

    return ValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      warnings: warnings,
      recommendations: recommendations,
    );
  }

  /// Валидирует типографику
  static ValidationResult validateTypography(
      TextStyle style, String tokenName) {
    final errors = <String>[];
    final warnings = <String>[];
    final recommendations = <String>[];

    // Проверка размера шрифта
    if (style.fontSize != null) {
      if (style.fontSize! < 10) {
        errors.add('Размер шрифта слишком маленький (${style.fontSize})');
      } else if (style.fontSize! > 72) {
        warnings.add('Размер шрифта очень большой (${style.fontSize})');
      }
    }

    // Проверка веса шрифта
    if (style.fontWeight != null) {
      if (style.fontWeight!.index < FontWeight.w100.index ||
          style.fontWeight!.index > FontWeight.w900.index) {
        errors.add('Недопустимый вес шрифта (${style.fontWeight})');
      }
    }

    // Проверка высоты строки
    if (style.height != null) {
      if (style.height! < 1.0) {
        warnings.add('Высота строки слишком маленькая (${style.height})');
      } else if (style.height! > 2.0) {
        warnings.add('Высота строки слишком большая (${style.height})');
      }
    }

    return ValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      warnings: warnings,
      recommendations: recommendations,
    );
  }

  /// Валидирует отступы
  static ValidationResult validateSpacing(double spacing, String tokenName) {
    final errors = <String>[];
    final warnings = <String>[];
    final recommendations = <String>[];

    // Проверка на отрицательные значения
    if (spacing < 0) {
      errors.add('Отступ не может быть отрицательным ($spacing)');
    }

    // Проверка на слишком большие значения
    if (spacing > 100) {
      warnings.add('Отступ очень большой ($spacing)');
    }

    // Проверка на дробные значения (должны быть кратны 4 или 8)
    if (spacing % 4 != 0) {
      recommendations.add(
          'Отступ не кратен 4 ($spacing), рекомендуется использовать 4, 8, 12, 16, etc.');
    }

    return ValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      warnings: warnings,
      recommendations: recommendations,
    );
  }

  /// Валидирует радиусы скругления
  static ValidationResult validateBorderRadius(
      double radius, String tokenName) {
    final errors = <String>[];
    final warnings = <String>[];
    final recommendations = <String>[];

    // Проверка на отрицательные значения
    if (radius < 0) {
      errors.add('Радиус не может быть отрицательным ($radius)');
    }

    // Проверка на слишком большие значения
    if (radius > 50) {
      warnings.add('Радиус очень большой ($radius)');
    }

    return ValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      warnings: warnings,
      recommendations: recommendations,
    );
  }

  /// Валидирует все дизайн-токены
  static ValidationResult validateAllTokens() {
    final errors = <String>[];
    final warnings = <String>[];
    final recommendations = <String>[];

    // Валидация цветов
    final colorTokens = [
      (DesignTokens.colors.primary, 'primary'),
      (DesignTokens.colors.secondary, 'secondary'),
      (DesignTokens.colors.accent, 'accent'),
      (DesignTokens.colors.background, 'background'),
      (DesignTokens.colors.surface, 'surface'),
      (DesignTokens.colors.onSurface, 'onSurface'),
      (DesignTokens.colors.error, 'error'),
      (DesignTokens.colors.success, 'success'),
      (DesignTokens.colors.warning, 'warning'),
      (DesignTokens.colors.info, 'info'),
    ];

    for (final (color, name) in colorTokens) {
      final result = validateColor(color, name);
      errors.addAll(result.errors.map((e) => '$name: $e'));
      warnings.addAll(result.warnings.map((w) => '$name: $w'));
      recommendations.addAll(result.recommendations.map((r) => '$name: $r'));
    }

    // Валидация пар цветов
    final colorPairs = [
      (
        DesignTokens.colors.onSurface,
        DesignTokens.colors.surface,
        'onSurface/surface'
      ),
      (
        DesignTokens.colors.onPrimary,
        DesignTokens.colors.primary,
        'onPrimary/primary'
      ),
      (DesignTokens.colors.onError, DesignTokens.colors.error, 'onError/error'),
      (
        DesignTokens.colors.onSuccess,
        DesignTokens.colors.success,
        'onSuccess/success'
      ),
    ];

    for (final (foreground, background, name) in colorPairs) {
      final result = validateColorPair(foreground, background, name);
      errors.addAll(result.errors.map((e) => '$name: $e'));
      warnings.addAll(result.warnings.map((w) => '$name: $w'));
      recommendations.addAll(result.recommendations.map((r) => '$name: $r'));
    }

    // Валидация типографики
    final typographyTokens = [
      (DesignTokens.typography.headlineLargeStyle, 'headlineLarge'),
      (DesignTokens.typography.headlineMediumStyle, 'headlineMedium'),
      (DesignTokens.typography.titleLargeStyle, 'titleLarge'),
      (DesignTokens.typography.titleMediumStyle, 'titleMedium'),
      (DesignTokens.typography.bodyLargeStyle, 'bodyLarge'),
      (DesignTokens.typography.bodyMediumStyle, 'bodyMedium'),
      (DesignTokens.typography.bodySmallStyle, 'bodySmall'),
    ];

    for (final (style, name) in typographyTokens) {
      final result = validateTypography(style, name);
      errors.addAll(result.errors.map((e) => '$name: $e'));
      warnings.addAll(result.warnings.map((w) => '$name: $w'));
      recommendations.addAll(result.recommendations.map((r) => '$name: $r'));
    }

    // Валидация отступов
    final spacingTokens = [
      (DesignTokens.spacing.xs, 'xs'),
      (DesignTokens.spacing.sm, 'sm'),
      (DesignTokens.spacing.md, 'md'),
      (DesignTokens.spacing.lg, 'lg'),
      (DesignTokens.spacing.xl, 'xl'),
      (DesignTokens.spacing.xxl, 'xxl'),
    ];

    for (final (spacing, name) in spacingTokens) {
      final result = validateSpacing(spacing, name);
      errors.addAll(result.errors.map((e) => 'spacing.$name: $e'));
      warnings.addAll(result.warnings.map((w) => 'spacing.$name: $w'));
      recommendations
          .addAll(result.recommendations.map((r) => 'spacing.$name: $r'));
    }

    // Валидация радиусов
    final borderRadiusTokens = [
      (DesignTokens.borders.xs, 'xs'),
      (DesignTokens.borders.sm, 'sm'),
      (DesignTokens.borders.md, 'md'),
      (DesignTokens.borders.lg, 'lg'),
      (DesignTokens.borders.xl, 'xl'),
    ];

    for (final (radius, name) in borderRadiusTokens) {
      final result = validateBorderRadius(radius, name);
      errors.addAll(result.errors.map((e) => 'borders.$name: $e'));
      warnings.addAll(result.warnings.map((w) => 'borders.$name: $w'));
      recommendations
          .addAll(result.recommendations.map((r) => 'borders.$name: $r'));
    }

    return ValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      warnings: warnings,
      recommendations: recommendations,
    );
  }

  /// Вычисляет расстояние между цветами в RGB пространстве
  static double _calculateColorDistance(Color color1, Color color2) {
    final r1 = color1.red;
    final g1 = color1.green;
    final b1 = color1.blue;

    final r2 = color2.red;
    final g2 = color2.green;
    final b2 = color2.blue;

    return math.sqrt(
        math.pow(r1 - r2, 2) + math.pow(g1 - g2, 2) + math.pow(b1 - b2, 2));
  }
}
