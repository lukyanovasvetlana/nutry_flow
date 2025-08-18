import 'dart:io';
import 'package:nutry_flow/shared/design/utils/theme_analyzer.dart';

/// Скрипт для анализа проблем с контрастностью в темах
void main() {
  print('🔍 Анализ контрастности тем NutryFlow...\n');
  
  try {
    // Анализируем обе темы
    final result = ThemeAnalyzer.analyzeBothThemes();
    
    // Выводим общую статистику
    print('📊 ОБЩАЯ СТАТИСТИКА');
    print('=' * 50);
    print('Светлая тема: ${result.lightTheme.failingPairs}/${result.lightTheme.totalPairs} проблемных пар');
    print('Темная тема: ${result.darkTheme.failingPairs}/${result.darkTheme.totalPairs} проблемных пар');
    print('');
    
    // Проблемы в светлой теме
    if (result.lightTheme.issues.isNotEmpty) {
      print('⚠️  ПРОБЛЕМЫ В СВЕТЛОЙ ТЕМЕ');
      print('=' * 50);
      for (final issue in result.lightTheme.issues) {
        print('🔴 ${issue.colorName}');
        print('   Контрастность: ${issue.contrastRatio.toStringAsFixed(2)}');
        print('   Рекомендация: ${issue.recommendation}');
        print('');
      }
          } else {
        print('✅ СВЕТЛАЯ ТЕМА: Проблем с контрастностью не найдено');
        print('');
      }
    
    // Проблемы в темной теме
    if (result.darkTheme.issues.isNotEmpty) {
      print('⚠️  ПРОБЛЕМЫ В ТЕМНОЙ ТЕМЕ');
      print('=' * 50);
      for (final issue in result.darkTheme.issues) {
        print('🔴 ${issue.colorName}');
        print('   Контрастность: ${issue.contrastRatio.toStringAsFixed(2)}');
        print('   Рекомендация: ${issue.recommendation}');
        print('');
      }
          } else {
        print('✅ ТЕМНАЯ ТЕМА: Проблем с контрастностью не найдено');
        print('');
      }
    
    // Генерируем детальный отчет
    final report = ThemeAnalyzer.generateMarkdownReport(result);
    
    // Сохраняем отчет в файл
    final reportFile = File('docs/theme-contrast-analysis-report.md');
    reportFile.writeAsStringSync(report);
    print('📄 Отчет сохранен в: docs/theme-contrast-analysis-report.md');
    
    // Выводим итоговый результат
    if (result.hasIssues) {
      print('\n❌ НАЙДЕНЫ ПРОБЛЕМЫ С КОНТРАСТНОСТЬЮ');
      print('Рекомендуется исправить проблемы перед релизом');
      exit(1);
    } else {
      print('\n✅ ВСЕ ТЕСТЫ КОНТРАСТНОСТИ ПРОЙДЕНЫ');
      print('Темы соответствуют стандартам WCAG 2.1 AA');
    }
    
  } catch (e) {
    print('❌ Ошибка при анализе: $e');
    exit(1);
  }
}
