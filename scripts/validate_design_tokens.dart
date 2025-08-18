import 'dart:io';
import 'package:nutry_flow/shared/design/utils/token_validator.dart';

void main() {
  print('🔍 Валидация дизайн-токенов NutryFlow...\n');
  
  try {
    final result = TokenValidator.validateAllTokens();
    
    // Вывод результатов
    print(result.report);
    
    // Сохранение отчета в файл
    final reportFile = File('docs/design-tokens-validation-report.md');
    final markdownReport = _generateMarkdownReport(result);
    reportFile.writeAsStringSync(markdownReport);
    
    print('\n📄 Отчет сохранен в: docs/design-tokens-validation-report.md');
    
    // Выход с кодом ошибки, если есть критические проблемы
    if (result.hasErrors) {
      print('\n❌ НАЙДЕНЫ КРИТИЧЕСКИЕ ПРОБЛЕМЫ');
      print('Количество ошибок: ${result.errors.length}');
      print('Количество предупреждений: ${result.warnings.length}');
      exit(1);
    } else if (result.hasWarnings) {
      print('\n⚠️ НАЙДЕНЫ ПРЕДУПРЕЖДЕНИЯ');
      print('Количество предупреждений: ${result.warnings.length}');
      print('Рекомендуется исправить предупреждения для улучшения качества дизайна');
    } else {
      print('\n✅ ВСЕ ТОКЕНЫ ПРОШЛИ ВАЛИДАЦИЮ');
      print('Дизайн-токены соответствуют стандартам качества');
    }
    
  } catch (e) {
    print('❌ Ошибка при валидации: $e');
    exit(1);
  }
}

String _generateMarkdownReport(ValidationResult result) {
  final buffer = StringBuffer();
  
  buffer.writeln('# Отчет валидации дизайн-токенов NutryFlow');
  buffer.writeln();
  buffer.writeln('**Дата проверки:** ${DateTime.now().toIso8601String()}');
  buffer.writeln('**Статус:** ${result.isValid ? "✅ Прошел" : "❌ Не прошел"}');
  buffer.writeln();
  
  // Статистика
  buffer.writeln('## 📊 Статистика');
  buffer.writeln();
  buffer.writeln('- **Ошибки:** ${result.errors.length}');
  buffer.writeln('- **Предупреждения:** ${result.warnings.length}');
  buffer.writeln('- **Рекомендации:** ${result.recommendations.length}');
  buffer.writeln();
  
  // Детальные результаты
  if (result.errors.isNotEmpty) {
    buffer.writeln('## 🚨 Критические ошибки');
    buffer.writeln();
    for (final error in result.errors) {
      buffer.writeln('- $error');
    }
    buffer.writeln();
  }
  
  if (result.warnings.isNotEmpty) {
    buffer.writeln('## ⚠️ Предупреждения');
    buffer.writeln();
    for (final warning in result.warnings) {
      buffer.writeln('- $warning');
    }
    buffer.writeln();
  }
  
  if (result.recommendations.isNotEmpty) {
    buffer.writeln('## 💡 Рекомендации по улучшению');
    buffer.writeln();
    for (final recommendation in result.recommendations) {
      buffer.writeln('- $recommendation');
    }
    buffer.writeln();
  }
  
  // Сводка
  buffer.writeln('## 📋 Сводка');
  buffer.writeln();
  
  if (result.isValid) {
    buffer.writeln('✅ Все дизайн-токены прошли валидацию и соответствуют стандартам качества.');
  } else {
    buffer.writeln('❌ Обнаружены проблемы, требующие исправления:');
    buffer.writeln();
    buffer.writeln('1. **Исправьте критические ошибки** - они могут привести к проблемам с доступностью и UX');
    buffer.writeln('2. **Рассмотрите предупреждения** - они могут улучшить качество дизайна');
    buffer.writeln('3. **Примените рекомендации** - для оптимизации дизайн-системы');
  }
  
  buffer.writeln();
  buffer.writeln('## 🔧 Как исправить проблемы');
  buffer.writeln();
  buffer.writeln('### Цвета и контрастность');
  buffer.writeln('- Используйте инструменты для проверки контрастности');
  buffer.writeln('- Убедитесь, что текст читаем на всех фонах');
  buffer.writeln('- Следуйте стандартам WCAG 2.1');
  buffer.writeln();
  
  buffer.writeln('### Типографика');
  buffer.writeln('- Проверьте размеры шрифтов (минимум 10px)');
  buffer.writeln('- Убедитесь в правильности весов шрифтов');
  buffer.writeln('- Проверьте высоту строки (1.0-2.0)');
  buffer.writeln();
  
  buffer.writeln('### Отступы и размеры');
  buffer.writeln('- Используйте кратные 4 значения (4, 8, 12, 16, etc.)');
  buffer.writeln('- Избегайте отрицательных значений');
  buffer.writeln('- Не используйте слишком большие отступы (>100px)');
  buffer.writeln();
  
  buffer.writeln('### Радиусы скругления');
  buffer.writeln('- Избегайте отрицательных значений');
  buffer.writeln('- Не используйте слишком большие радиусы (>50px)');
  buffer.writeln('- Следуйте консистентности в дизайн-системе');
  buffer.writeln();
  
  buffer.writeln('---');
  buffer.writeln('*Отчет создан автоматически системой валидации дизайн-токенов NutryFlow*');
  
  return buffer.toString();
}
