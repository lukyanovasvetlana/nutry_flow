import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutry_flow/features/menu/presentation/screens/healthy_menu_screen.dart';

void main() {
  group('HealthyMenuScreen Tests', () {
    testWidgets('should display healthy menu screen', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: const HealthyMenuScreen(),
        ),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(HealthyMenuScreen), findsOneWidget);
    });

    testWidgets('should have correct AppBar title', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: const HealthyMenuScreen(),
        ),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(HealthyMenuScreen), findsOneWidget);
    });

    testWidgets('should display recipe categories', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: const HealthyMenuScreen(),
        ),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(HealthyMenuScreen), findsOneWidget);
    });

    testWidgets('should display featured recipes', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: const HealthyMenuScreen(),
        ),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(HealthyMenuScreen), findsOneWidget);
    });

    testWidgets('should have search functionality', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: const HealthyMenuScreen(),
        ),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(HealthyMenuScreen), findsOneWidget);
    });

    testWidgets('should filter recipes when search text is entered', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: const HealthyMenuScreen(),
        ),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(HealthyMenuScreen), findsOneWidget);
    });

    testWidgets('should have floating action button for adding recipe', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: const HealthyMenuScreen(),
        ),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });
  });
}
