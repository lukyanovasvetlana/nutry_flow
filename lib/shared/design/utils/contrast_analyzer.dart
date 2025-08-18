import 'package:flutter/material.dart';
import 'dart:math';

/// Утилита для анализа контрастности цветов
/// Использует стандарты WCAG 2.1 для вычисления контрастности
class ContrastAnalyzer {
  ContrastAnalyzer._();

  /// Вычисляет соотношение контрастности между двумя цветами
  /// Использует формулу WCAG 2.1
  static double calculateContrastRatio(Color color1, Color color2) {
    final luminance1 = _calculateRelativeLuminance(color1);
    final luminance2 = _calculateRelativeLuminance(color2);

    final lighter = luminance1 > luminance2 ? luminance1 : luminance2;
    final darker = luminance1 > luminance2 ? luminance2 : luminance1;

    return (lighter + 0.05) / (darker + 0.05);
  }

  /// Вычисляет относительную яркость цвета
  /// Использует формулу WCAG 2.1
  static double _calculateRelativeLuminance(Color color) {
    final red = _normalizeColorComponent(color.red);
    final green = _normalizeColorComponent(color.green);
    final blue = _normalizeColorComponent(color.blue);

    return 0.2126 * red + 0.7152 * green + 0.0722 * blue;
  }

  /// Нормализует компонент цвета для вычисления яркости
  static double _normalizeColorComponent(int component) {
    final normalized = component / 255.0;

    if (normalized <= 0.03928) {
      return normalized / 12.92;
    } else {
      return pow((normalized + 0.055) / 1.055, 2.4).toDouble();
    }
  }

  /// Проверяет, соответствует ли контрастность стандарту AA
  static bool meetsAAContrast(Color color1, Color color2) {
    return calculateContrastRatio(color1, color2) >= 4.5;
  }

  /// Проверяет, соответствует ли контрастность стандарту AAA
  static bool meetsAAAContrast(Color color1, Color color2) {
    return calculateContrastRatio(color1, color2) >= 7.0;
  }

  /// Получает уровень контрастности в виде строки
  static String getContrastLevel(Color color1, Color color2) {
    final ratio = calculateContrastRatio(color1, color2);

    if (ratio >= 7.0) {
      return 'AAA (Excellent)';
    } else if (ratio >= 4.5) {
      return 'AA (Good)';
    } else if (ratio >= 3.0) {
      return 'A (Acceptable)';
    } else {
      return 'Fail (Poor)';
    }
  }

  /// Анализирует цветовую пару и возвращает отчет
  static ContrastReport analyzeColorPair(Color background, Color foreground) {
    final ratio = calculateContrastRatio(background, foreground);
    final level = getContrastLevel(background, foreground);
    final meetsAA = meetsAAContrast(background, foreground);
    final meetsAAA = meetsAAAContrast(background, foreground);

    return ContrastReport(
      background: background,
      foreground: foreground,
      contrastRatio: ratio,
      level: level,
      meetsAA: meetsAA,
      meetsAAA: meetsAAA,
    );
  }

  /// Анализирует все цветовые пары в теме
  static List<ContrastReport> analyzeTheme({
    required Color primary,
    required Color onPrimary,
    required Color secondary,
    required Color onSecondary,
    required Color error,
    required Color onError,
    required Color success,
    required Color onSuccess,
    required Color background,
    required Color onBackground,
    required Color surface,
    required Color onSurface,
  }) {
    return [
      analyzeColorPair(primary, onPrimary),
      analyzeColorPair(secondary, onSecondary),
      analyzeColorPair(error, onError),
      analyzeColorPair(success, onSuccess),
      analyzeColorPair(background, onBackground),
      analyzeColorPair(surface, onSurface),
    ];
  }
}

/// Отчет о контрастности цветовой пары
class ContrastReport {
  final Color background;
  final Color foreground;
  final double contrastRatio;
  final String level;
  final bool meetsAA;
  final bool meetsAAA;

  const ContrastReport({
    required this.background,
    required this.foreground,
    required this.contrastRatio,
    required this.level,
    required this.meetsAA,
    required this.meetsAAA,
  });

  @override
  String toString() {
    return 'ContrastReport('
        'background: #${background.value.toRadixString(16).toUpperCase()}, '
        'foreground: #${foreground.value.toRadixString(16).toUpperCase()}, '
        'ratio: ${contrastRatio.toStringAsFixed(2)}, '
        'level: $level)';
  }
}
