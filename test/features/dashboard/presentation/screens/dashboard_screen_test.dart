import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nutry_flow/features/dashboard/presentation/screens/dashboard_screen.dart';

void main() {
  group('DashboardScreen', () {
    setUp(() {
      // Очищаем SharedPreferences перед каждым тестом
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('displays user name when available', (WidgetTester tester) async {
      // Arrange
      SharedPreferences.setMockInitialValues({
        'userName': 'Анна',
      });

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: const DashboardScreen(),
        ),
      );

      // Wait for async operations to complete
      await tester.pumpAndSettle();

      // Assert
      expect(find.textContaining('Привет, Анна!'), findsOneWidget);
    });

    testWidgets('displays default greeting when user name is not available', (WidgetTester tester) async {
      // Arrange
      SharedPreferences.setMockInitialValues({});

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: const DashboardScreen(),
        ),
      );

      // Wait for async operations to complete
      await tester.pumpAndSettle();

      // Assert
      expect(find.textContaining('Привет, Гость!'), findsOneWidget);
    });

    testWidgets('displays welcome message', (WidgetTester tester) async {
      // Arrange
      SharedPreferences.setMockInitialValues({
        'userName': 'Тест',
      });

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: const DashboardScreen(),
        ),
      );

      // Wait for async operations to complete
      await tester.pumpAndSettle();

      // Assert
      expect(find.textContaining('Давай начнем наш путь по улучшению здоровья'), findsOneWidget);
    });

    testWidgets('displays logo', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: const DashboardScreen(),
        ),
      );

      // Wait for async operations to complete
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(Image), findsOneWidget);
    });
  });
} 