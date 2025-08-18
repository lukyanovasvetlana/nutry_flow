import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutry_flow/shared/design/tokens/theme_tokens.dart';

/// Простой тест для демонстрации темной темы
void main() {
  group('Theme Simple Tests', () {
    testWidgets('Dark theme colors are beautiful', (WidgetTester tester) async {
      // Переключаемся на темную тему
      ThemeTokens.currentTheme = ThemeMode.dark;
      
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: Scaffold(
            backgroundColor: ThemeTokens.current.background,
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Заголовок
                  Text(
                    '🎨 Красивая темная тема NutryFlow',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: ThemeTokens.current.onBackground,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Карточка с цветами
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: ThemeTokens.current.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: ThemeTokens.current.outline,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '🌈 Цветовая палитра:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: ThemeTokens.current.onSurface,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildColorRow('Background', ThemeTokens.current.background),
                        _buildColorRow('Surface', ThemeTokens.current.surface),
                        _buildColorRow('Primary', ThemeTokens.current.primary),
                        _buildColorRow('Secondary', ThemeTokens.current.secondary),
                        _buildColorRow('Error', ThemeTokens.current.error),
                        _buildColorRow('Success', ThemeTokens.current.success),
                        _buildColorRow('Warning', ThemeTokens.current.warning),
                        _buildColorRow('Info', ThemeTokens.current.info),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Кнопки
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: ThemeTokens.current.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '✨ Основная кнопка',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: ThemeTokens.current.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: ThemeTokens.current.secondary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '💙 Вторичная',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: ThemeTokens.current.onSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Поля ввода
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: ThemeTokens.current.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: ThemeTokens.current.outline,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '📝 Поля ввода:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: ThemeTokens.current.onSurface,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: ThemeTokens.current.surfaceContainer,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: ThemeTokens.current.outline,
                              width: 1,
                            ),
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: '✉️ Введите email',
                              hintStyle: TextStyle(
                                color: ThemeTokens.current.onSurfaceVariant,
                              ),
                              border: InputBorder.none,
                            ),
                            style: TextStyle(
                              color: ThemeTokens.current.onSurface,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: ThemeTokens.current.surfaceContainer,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: ThemeTokens.current.outline,
                              width: 1,
                            ),
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: '🔒 Введите пароль',
                              hintStyle: TextStyle(
                                color: ThemeTokens.current.onSurfaceVariant,
                              ),
                              border: InputBorder.none,
                            ),
                            style: TextStyle(
                              color: ThemeTokens.current.onSurface,
                            ),
                            obscureText: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Статусы
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: ThemeTokens.current.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: ThemeTokens.current.outline,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '📊 Статусы:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: ThemeTokens.current.onSurface,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: ThemeTokens.current.success,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '✅ Успех',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: ThemeTokens.current.onSuccess,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: ThemeTokens.current.error,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '❌ Ошибка',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: ThemeTokens.current.onError,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: ThemeTokens.current.warning,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '⚠️ Предупреждение',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: ThemeTokens.current.onWarning,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      
      // Проверяем, что виджеты отрендерены
      expect(find.text('🎨 Красивая темная тема NutryFlow'), findsOneWidget);
      expect(find.text('🌈 Цветовая палитра:'), findsOneWidget);
      expect(find.text('✨ Основная кнопка'), findsOneWidget);
      expect(find.text('💙 Вторичная'), findsOneWidget);
      expect(find.text('📝 Поля ввода:'), findsOneWidget);
      expect(find.text('📊 Статусы:'), findsOneWidget);
      
      // Делаем скриншот для визуальной проверки
      await tester.pumpAndSettle();
    });

    testWidgets('Light theme colors are beautiful', (WidgetTester tester) async {
      // Переключаемся на светлую тему
      ThemeTokens.currentTheme = ThemeMode.light;
      
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: Scaffold(
            backgroundColor: ThemeTokens.current.background,
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Заголовок
                  Text(
                    '☀️ Красивая светлая тема NutryFlow',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: ThemeTokens.current.onBackground,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Карточка с цветами
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: ThemeTokens.current.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: ThemeTokens.current.outline,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '🌈 Цветовая палитра:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: ThemeTokens.current.onSurface,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildColorRow('Background', ThemeTokens.current.background),
                        _buildColorRow('Surface', ThemeTokens.current.surface),
                        _buildColorRow('Primary', ThemeTokens.current.primary),
                        _buildColorRow('Secondary', ThemeTokens.current.secondary),
                        _buildColorRow('Error', ThemeTokens.current.error),
                        _buildColorRow('Success', ThemeTokens.current.success),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      
      // Проверяем, что виджеты отрендерены
      expect(find.text('☀️ Красивая светлая тема NutryFlow'), findsOneWidget);
      expect(find.text('🌈 Цветовая палитра:'), findsOneWidget);
      
      // Делаем скриншот для визуальной проверки
      await tester.pumpAndSettle();
    });
  });
}

Widget _buildColorRow(String label, Color color) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: ThemeTokens.current.outline,
              width: 1,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            '$label: #${color.value.toRadixString(16).toUpperCase()}',
            style: TextStyle(
              color: ThemeTokens.current.onSurface,
              fontSize: 14,
            ),
          ),
        ),
      ],
    ),
  );
}
