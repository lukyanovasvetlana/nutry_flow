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
      expect(find.text('План питания'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('should have correct title color in AppBar', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: const MealPlanScreen(),
        ),
      );

      // Act
      final titleFinder = find.text('План питания');
      final Text titleWidget = tester.widget(titleFinder);

      // Assert
      expect(titleWidget.style?.color, AppColors.textPrimary);
      expect(titleWidget.style?.fontWeight, FontWeight.bold);
      expect(titleWidget.style?.fontSize, 20);
    });

    testWidgets('should have correct AppBar background', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: const MealPlanScreen(),
        ),
      );

      // Act
      final appBarFinder = find.byType(AppBar);
      final AppBar appBarWidget = tester.widget(appBarFinder);

      // Assert
      expect(appBarWidget.backgroundColor, isNotNull);
      expect(appBarWidget.elevation, 0);
    });

    testWidgets('should have centered title', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: const MealPlanScreen(),
        ),
      );

      // Act
      final appBarFinder = find.byType(AppBar);
      final AppBar appBarWidget = tester.widget(appBarFinder);

      // Assert
      expect(appBarWidget.centerTitle, true);
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
      expect(scaffoldWidget.backgroundColor, AppColors.background);
    });
  });
} 