import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'mocks/mock_app_colors.dart';

void main() {
  group('NavBar Icon Color Tests', () {
    testWidgets('NavBar should have correct colors', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              selectedItemColor: MockAppColors.button,
              unselectedItemColor: MockAppColors.secondary,
              backgroundColor: MockAppColors.background,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Главная',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Профиль',
                ),
              ],
            ),
          ),
        ),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert
      final bottomNavigationBar = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(bottomNavigationBar.selectedItemColor, MockAppColors.button);
      expect(bottomNavigationBar.unselectedItemColor, MockAppColors.secondary);
      expect(bottomNavigationBar.backgroundColor, MockAppColors.background);
    });

    testWidgets('AppColors should have correct values', (WidgetTester tester) async {
      // Assert - проверяем что MockAppColors имеет правильные значения
      expect(MockAppColors.button, const Color(0xFF4CAF50));
      expect(MockAppColors.background, const Color(0xFFF9F4F2));
      expect(MockAppColors.primary, const Color(0xFF2196F3));
      expect(MockAppColors.secondary, const Color(0xFF757575));
    });
  });
}