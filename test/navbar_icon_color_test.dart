import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutry_flow/app.dart';
import 'package:nutry_flow/shared/widgets/bottom_navigation.dart';
import 'package:nutry_flow/shared/theme/app_colors.dart';

void main() {
  group('NavBar Icon Color Tests', () {
    testWidgets('AppContainer NavBar should have AppColors.button for selected items', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: const AppContainer(),
        ),
      );

      // Act
      final bottomNavBarFinder = find.byType(BottomNavigationBar);
      expect(bottomNavBarFinder, findsOneWidget);

      final BottomNavigationBar bottomNavBar = tester.widget(bottomNavBarFinder);

      // Assert
      expect(bottomNavBar.selectedItemColor, AppColors.button);
      expect(AppColors.button, const Color(0xFF4CAF50)); // Проверяем что это зеленый цвет
    });

    testWidgets('BottomNavigation widget should have AppColors.button for selected items', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: BottomNavigation(
              currentIndex: 0,
              onMenuTap: (index) {},
            ),
          ),
        ),
      );

      // Act
      final bottomNavBarFinder = find.byType(BottomNavigationBar);
      expect(bottomNavBarFinder, findsOneWidget);

      final BottomNavigationBar bottomNavBar = tester.widget(bottomNavBarFinder);

      // Assert
      expect(bottomNavBar.selectedItemColor, AppColors.button);
      expect(AppColors.button, const Color(0xFF4CAF50)); // Проверяем что это зеленый цвет
    });

    testWidgets('AppColors.button should be green color', (WidgetTester tester) async {
      // Assert - проверяем что AppColors.button имеет правильное значение
      expect(AppColors.button, const Color(0xFF4CAF50));
    });

    testWidgets('NavBar should have correct color scheme', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: const AppContainer(),
        ),
      );

      // Act
      final bottomNavBarFinder = find.byType(BottomNavigationBar);
      final BottomNavigationBar bottomNavBar = tester.widget(bottomNavBarFinder);

      // Assert - проверяем полную цветовую схему
      expect(bottomNavBar.backgroundColor, const Color(0xFFF9F4F2)); // Фон как у основного экрана
      expect(bottomNavBar.selectedItemColor, AppColors.button); // Активные иконки зеленые
      expect(bottomNavBar.unselectedItemColor, Colors.grey[600]); // Неактивные иконки серые
    });
  });
} 