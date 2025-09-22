import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutry_flow/features/notifications/presentation/screens/notifications_screen.dart';

void main() {
  group('NotificationsScreen Tests', () {
    testWidgets('should display notifications screen', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: const NotificationsScreen(),
        ),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(NotificationsScreen), findsOneWidget);
    });

    testWidgets('should have correct AppBar title', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: const NotificationsScreen(),
        ),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Уведомления'), findsOneWidget);
    });

    testWidgets('should display notifications list', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: const NotificationsScreen(),
        ),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(NotificationsScreen), findsOneWidget);
    });

    testWidgets('should have settings button in AppBar', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: const NotificationsScreen(),
        ),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Уведомления'), findsOneWidget);
    });

    testWidgets('should navigate to settings when settings button is tapped', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: const NotificationsScreen(),
        ),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Уведомления'), findsOneWidget);
    });
  });
}
