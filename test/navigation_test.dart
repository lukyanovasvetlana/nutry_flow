import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutry_flow/features/calendar/presentation/screens/calendar_screen.dart';
import 'package:nutry_flow/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:nutry_flow/features/meal_plan/presentation/screens/meal_plan_screen.dart';
import 'package:nutry_flow/features/profile/presentation/screens/profile_settings_screen.dart';
import 'package:nutry_flow/shared/theme/app_colors.dart';

void main() {
  group('Navigation Tests', () {
    testWidgets('Calendar screen should display correctly', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: const CalendarScreen(),
        ),
      );

      // Assert
      expect(find.byType(CalendarScreen), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('Notifications screen should display correctly', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: const NotificationsScreen(),
        ),
      );

      // Assert
      expect(find.byType(NotificationsScreen), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('Meal plan screen should display correctly', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: const MealPlanScreen(),
        ),
      );

      // Assert
      expect(find.byType(MealPlanScreen), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('Profile settings screen should display correctly', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: const ProfileSettingsScreen(),
        ),
      );

      // Assert
      expect(find.byType(ProfileSettingsScreen), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('Meal plan screen title should have correct color', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: const MealPlanScreen(),
        ),
      );

      // Act & Assert
      final titleFinder = find.text('План питания');
      expect(titleFinder, findsOneWidget);
      
      final Text titleWidget = tester.widget(titleFinder);
      expect(titleWidget.style?.color, AppColors.textPrimary);
    });
  });
} 