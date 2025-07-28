import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutry_flow/features/profile/presentation/screens/profile_settings_screen.dart';
import 'package:nutry_flow/shared/theme/app_colors.dart';
import 'package:nutry_flow/app.dart';

void main() {
  group('Profile Settings Navigation Tests', () {
    testWidgets('Profile settings screen back button should navigate back', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          routes: {
            '/onboarding': (context) => const Scaffold(body: Text('Onboarding')),
            '/profile-settings': (context) => const ProfileSettingsScreen(),
          },
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileSettingsScreen()),
                ),
                child: const Text('Open Profile Settings'),
              ),
            ),
          ),
        ),
      );

      // Act - open profile settings
      await tester.tap(find.text('Open Profile Settings'));
      await tester.pumpAndSettle();

      // Verify we're on profile settings screen
      expect(find.text('Настройки профиля'), findsOneWidget);

      // Act - tap back button
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Assert - should go back to previous screen
      expect(find.text('Open Profile Settings'), findsOneWidget);
      expect(find.text('Настройки профиля'), findsNothing);
    });

    testWidgets('Profile settings screen should display correct title', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          routes: {
            '/onboarding': (context) => const Scaffold(body: Text('Onboarding')),
            '/profile-settings': (context) => const ProfileSettingsScreen(),
          },
          home: const ProfileSettingsScreen(),
        ),
      );

      // Assert
      expect(find.text('Настройки профиля'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('Profile settings screen should have correct AppBar styling', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          routes: {
            '/onboarding': (context) => const Scaffold(body: Text('Onboarding')),
            '/profile-settings': (context) => const ProfileSettingsScreen(),
          },
          home: const ProfileSettingsScreen(),
        ),
      );

      // Act
      final appBarFinder = find.byType(AppBar);
      final AppBar appBar = tester.widget(appBarFinder);

      // Assert
      expect(appBar.backgroundColor, const Color(0xFFF9F4F2));
      expect(appBar.elevation, 0);
      expect(appBar.centerTitle, isNull);
    });

    testWidgets('Profile settings screen should have correct background color', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          routes: {
            '/onboarding': (context) => const Scaffold(body: Text('Onboarding')),
            '/profile-settings': (context) => const ProfileSettingsScreen(),
          },
          home: const ProfileSettingsScreen(),
        ),
      );

      // Act
      final scaffoldFinder = find.byType(Scaffold);
      final Scaffold scaffold = tester.widget(scaffoldFinder);

      // Assert
      expect(scaffold.backgroundColor, const Color(0xFFF9F4F2));
    });

    testWidgets('Profile settings screen should display settings sections', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          routes: {
            '/onboarding': (context) => const Scaffold(body: Text('Onboarding')),
            '/profile-settings': (context) => const ProfileSettingsScreen(),
          },
          home: const ProfileSettingsScreen(),
        ),
      );

      // Assert
      expect(find.text('Личные данные'), findsOneWidget);
      expect(find.text('Уведомления'), findsOneWidget);
      expect(find.text('Редактировать профиль'), findsOneWidget);
      expect(find.text('Изменить пароль'), findsOneWidget);
    });
  });
} 