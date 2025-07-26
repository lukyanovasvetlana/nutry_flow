import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutry_flow/features/dashboard/presentation/widgets/meal_plan_card.dart';
import 'package:nutry_flow/features/meal_plan/presentation/screens/meal_plan_screen.dart';

void main() {
  group('Meal Plan Navigation Tests', () {
    testWidgets('MealPlanCard should be tappable and navigate to meal plan screen', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(MaterialApp(
        routes: {
          '/': (context) => Scaffold(body: MealPlanCard()),
          '/meal-plan': (context) => const MealPlanScreen(),
        },
        initialRoute: '/',
      ));

      // Act - tap on the meal plan card
      await tester.tap(find.byType(GestureDetector));
      await tester.pumpAndSettle();

      // Assert - verify that navigation was successful
      expect(find.byType(MealPlanScreen), findsOneWidget);
      expect(find.text('План питания'), findsOneWidget);
    });

    testWidgets('MealPlanCard should display correct content', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: MealPlanCard(),
        ),
      ));

      // Assert
      expect(find.text('План питания'), findsOneWidget);
      expect(find.text('Ваш персональный план питания на неделю'), findsOneWidget);
      expect(find.text('Неделя 2'), findsOneWidget);
      expect(find.byIcon(Icons.restaurant_menu), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward_ios), findsOneWidget);
    });

    testWidgets('MealPlanScreen should have back button', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(MaterialApp(
        home: const MealPlanScreen(),
      ));

      // Assert
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.text('План питания'), findsOneWidget);
    });
  });
} 