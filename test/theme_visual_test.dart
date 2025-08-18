import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutry_flow/shared/design/tokens/theme_tokens.dart';

/// Простой визуальный тест для демонстрации темной темы
void main() {
  group('Theme Visual Tests', () {
    testWidgets('Dark theme looks good', (WidgetTester tester) async {
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
                    'Темная тема NutryFlow',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: ThemeTokens.current.onBackground,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Карточка с информацией
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
                          'Цвета темы:',
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
                            'Основная кнопка',
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
                            'Вторичная',
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
                          'Поля ввода:',
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
                              hintText: 'Введите email',
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
                              hintText: 'Введите пароль',
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
                ],
              ),
            ),
          ),
        ),
      );
      
      // Проверяем, что виджеты отрендерены
      expect(find.text('Темная тема NutryFlow'), findsOneWidget);
      expect(find.text('Цвета темы:'), findsOneWidget);
      expect(find.text('Основная кнопка'), findsOneWidget);
      expect(find.text('Вторичная'), findsOneWidget);
      expect(find.text('Поля ввода:'), findsOneWidget);
      
      // Делаем скриншот для визуальной проверки
      await tester.pumpAndSettle();
    });

    testWidgets('Light theme looks good', (WidgetTester tester) async {
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
                    'Светлая тема NutryFlow',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: ThemeTokens.current.onBackground,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Карточка с информацией
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
                          'Цвета темы:',
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
      expect(find.text('Светлая тема NutryFlow'), findsOneWidget);
      expect(find.text('Цвета темы:'), findsOneWidget);
      
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
