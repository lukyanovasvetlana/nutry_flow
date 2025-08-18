import 'package:flutter/material.dart';
import 'contrast_analyzer.dart';
import '../tokens/theme_tokens.dart';

/// Инструмент для анализа проблем с контрастностью в темах
class ThemeAnalyzer {
  /// Анализирует все цветовые пары в теме и возвращает отчет о проблемах
  static ThemeAnalysisResult analyzeTheme(BaseThemeTokens theme) {
    final List<ContrastIssue> issues = [];
    final List<ContrastReport> allAnalyses = [];

    // Анализируем основные цветовые пары
    final colorPairs = [
      ('Primary', theme.primary, theme.onPrimary),
      ('Secondary', theme.secondary, theme.onSecondary),
      ('Error', theme.error, theme.onError),
      ('Success', theme.success, theme.onSuccess),
      ('Warning', theme.warning, theme.onWarning),
      ('Info', theme.info, theme.onInfo),
      ('Background', theme.background, theme.onBackground),
      ('Surface', theme.surface, theme.onSurface),
      ('Surface Variant', theme.surfaceVariant, theme.onSurfaceVariant),
    ];

    for (final pair in colorPairs) {
      final analysis = ContrastAnalyzer.analyzeColorPair(pair.$2, pair.$3);
      allAnalyses.add(analysis);

      if (!analysis.meetsAA) {
        issues.add(ContrastIssue(
          colorName: pair.$1,
          foreground: pair.$2,
          background: pair.$3,
          contrastRatio: analysis.contrastRatio,
          recommendation: analysis.level,
        ));
      }
    }

    return ThemeAnalysisResult(
      issues: issues,
      allAnalyses: allAnalyses,
      totalPairs: colorPairs.length,
      failingPairs: issues.length,
    );
  }

  /// Анализирует обе темы и возвращает сравнительный отчет
  static ComparativeAnalysisResult analyzeBothThemes() {
    final lightAnalysis = analyzeTheme(ThemeTokens.light);
    final darkAnalysis = analyzeTheme(ThemeTokens.dark);

    return ComparativeAnalysisResult(
      lightTheme: lightAnalysis,
      darkTheme: darkAnalysis,
    );
  }

  /// Получает рекомендации по исправлению проблем с контрастностью
  static List<String> getFixingRecommendations(ContrastIssue issue) {
    final List<String> recommendations = [];

    if (issue.contrastRatio < 3.0) {
      recommendations.add(
          'Критическая проблема: контрастность ${issue.contrastRatio.toStringAsFixed(2)}');
      recommendations.add('Рекомендуется: увеличить контрастность до >= 4.5');
    } else if (issue.contrastRatio < 4.5) {
      recommendations.add(
          'Проблема: контрастность ${issue.contrastRatio.toStringAsFixed(2)}');
      recommendations.add('Рекомендуется: улучшить контрастность до >= 4.5');
    }

    // Специфические рекомендации для разных типов цветов
    if (issue.colorName.contains('Primary')) {
      recommendations.add(
          'Для Primary цветов: используйте более темный текст на светлом фоне');
    } else if (issue.colorName.contains('Background')) {
      recommendations
          .add('Для Background: проверьте читаемость текста на фоне');
    } else if (issue.colorName.contains('Surface')) {
      recommendations
          .add('Для Surface: убедитесь в достаточной контрастности элементов');
    }

    return recommendations;
  }

  /// Генерирует отчет в формате Markdown
  static String generateMarkdownReport(ComparativeAnalysisResult result) {
    final StringBuffer report = StringBuffer();

    report.writeln('# Отчет о контрастности тем');
    report.writeln();

    // Общая статистика
    report.writeln('## Общая статистика');
    report.writeln();
    report.writeln(
        '- **Светлая тема**: ${result.lightTheme.failingPairs}/${result.lightTheme.totalPairs} проблемных пар');
    report.writeln(
        '- **Темная тема**: ${result.darkTheme.failingPairs}/${result.darkTheme.totalPairs} проблемных пар');
    report.writeln();

    // Проблемы в светлой теме
    if (result.lightTheme.issues.isNotEmpty) {
      report.writeln('## Проблемы в светлой теме');
      report.writeln();
      for (final issue in result.lightTheme.issues) {
        report.writeln('### ${issue.colorName}');
        report.writeln(
            '- Контрастность: ${issue.contrastRatio.toStringAsFixed(2)}');
        report.writeln('- Рекомендация: ${issue.recommendation}');
        report.writeln();
      }
    }

    // Проблемы в темной теме
    if (result.darkTheme.issues.isNotEmpty) {
      report.writeln('## Проблемы в темной теме');
      report.writeln();
      for (final issue in result.darkTheme.issues) {
        report.writeln('### ${issue.colorName}');
        report.writeln(
            '- Контрастность: ${issue.contrastRatio.toStringAsFixed(2)}');
        report.writeln('- Рекомендация: ${issue.recommendation}');
        report.writeln();
      }
    }

    return report.toString();
  }
}

/// Результат анализа темы
class ThemeAnalysisResult {
  final List<ContrastIssue> issues;
  final List<ContrastReport> allAnalyses;
  final int totalPairs;
  final int failingPairs;

  const ThemeAnalysisResult({
    required this.issues,
    required this.allAnalyses,
    required this.totalPairs,
    required this.failingPairs,
  });

  bool get hasIssues => issues.isNotEmpty;
  double get passRate =>
      totalPairs > 0 ? (totalPairs - failingPairs) / totalPairs : 1.0;
}

/// Проблема с контрастностью
class ContrastIssue {
  final String colorName;
  final Color foreground;
  final Color background;
  final double contrastRatio;
  final String recommendation;

  const ContrastIssue({
    required this.colorName,
    required this.foreground,
    required this.background,
    required this.contrastRatio,
    required this.recommendation,
  });
}

/// Сравнительный результат анализа обеих тем
class ComparativeAnalysisResult {
  final ThemeAnalysisResult lightTheme;
  final ThemeAnalysisResult darkTheme;

  const ComparativeAnalysisResult({
    required this.lightTheme,
    required this.darkTheme,
  });

  bool get hasIssues => lightTheme.hasIssues || darkTheme.hasIssues;
}
