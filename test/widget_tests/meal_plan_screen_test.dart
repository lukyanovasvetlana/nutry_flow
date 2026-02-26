import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutry_flow/features/meal_plan/presentation/screens/meal_plan_screen.dart';
import 'package:nutry_flow/shared/theme/app_colors.dart';

void main() {
  group('MealPlanScreen Widget Tests', () {
    testWidgets('should display meal plan screen with correct title', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: const MealPlanScreen(),
        ),
      );

      // Assert
      expect(find.text('Сегодня'), findsOneWidget);
    });

    testWidgets('should have correct title style', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: const MealPlanScreen(),
        ),
      );

      // Act
      final titleFinder = find.text('Сегодня');
      expect(titleFinder, findsOneWidget);
      final Text titleWidget = tester.widget(titleFinder);

      // Assert
      expect(titleWidget.style?.color, AppColors.dynamicTextPrimary);
      expect(titleWidget.style?.fontWeight, FontWeight.bold);
    });

    testWidgets('should have correct screen background color', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: const MealPlanScreen(),
        ),
      );

      // Act
      final scaffoldFinder = find.byType(Scaffold);
      final Scaffold scaffoldWidget = tester.widget(scaffoldFinder);

      // Assert
      expect(scaffoldWidget.backgroundColor, AppColors.dynamicBackground);
    });
  });
} 