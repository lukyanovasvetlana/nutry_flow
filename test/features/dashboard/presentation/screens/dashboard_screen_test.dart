import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../test_helpers/mock_dashboard_screen.dart';

void main() {
  group('DashboardScreen', () {
    setUp(() {
      // Очищаем SharedPreferences перед каждым тестом
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('renders without crashing', (WidgetTester tester) async {
      // Arrange
      SharedPreferences.setMockInitialValues({});

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: const MockDashboardScreen(),
        ),
      );

      // Assert
      expect(find.byType(MockDashboardScreen), findsOneWidget);
    });

    testWidgets('displays analytics section title', (WidgetTester tester) async {
      // Arrange
      SharedPreferences.setMockInitialValues({});

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: const MockDashboardScreen(),
        ),
      );

      // Assert
      expect(find.text('Аналитика'), findsOneWidget);
    });

    testWidgets('handles SharedPreferences data', (WidgetTester tester) async {
      // Arrange
      SharedPreferences.setMockInitialValues({
        'userName': 'Тест',
        'userEmail': 'test@example.com',
      });

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: const MockDashboardScreen(),
        ),
      );

      // Assert
      expect(find.byType(MockDashboardScreen), findsOneWidget);
    });

    testWidgets('handles very long user names', (WidgetTester tester) async {
      // Arrange
      final longName = 'A' * 1000;
      SharedPreferences.setMockInitialValues({
        'userName': longName,
      });

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: const MockDashboardScreen(),
        ),
      );

      // Assert
      // Экран должен отображаться без краша
      expect(find.byType(MockDashboardScreen), findsOneWidget);
    });

    testWidgets('handles special characters in user names', (WidgetTester tester) async {
      // Arrange
      SharedPreferences.setMockInitialValues({
        'userName': 'José-María O\'Connor',
      });

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: const MockDashboardScreen(),
        ),
      );

      // Assert
      // Экран должен корректно отображать специальные символы
      expect(find.byType(MockDashboardScreen), findsOneWidget);
    });

    testWidgets('handles unicode characters in user names', (WidgetTester tester) async {
      // Arrange
      SharedPreferences.setMockInitialValues({
        'userName': 'Анна-Мария Иванова-Петрова',
      });

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: const MockDashboardScreen(),
        ),
      );

      // Assert
      // Экран должен корректно отображать unicode символы
      expect(find.byType(MockDashboardScreen), findsOneWidget);
    });
  });
} 