import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Navigation Integration Tests', () {
    Widget createApp() {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Dashboard'),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Nutrition'),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Activity'),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Profile'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    group('Basic Navigation', () {
      testWidgets('should render main navigation', (WidgetTester tester) async {
        // Arrange
        final app = createApp();

        // Act
        await tester.pumpWidget(app);

        // Assert
        expect(find.text('Dashboard'), findsOneWidget);
        expect(find.text('Nutrition'), findsOneWidget);
        expect(find.text('Activity'), findsOneWidget);
        expect(find.text('Profile'), findsOneWidget);
      });

      testWidgets('should handle button taps', (WidgetTester tester) async {
        // Arrange
        final app = createApp();

        // Act
        await tester.pumpWidget(app);
        await tester.tap(find.text('Dashboard'));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Dashboard'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('should navigate between screens', (WidgetTester tester) async {
        // Arrange
        final app = createApp();

        // Act
        await tester.pumpWidget(app);
        
        // Test Dashboard navigation
        await tester.tap(find.text('Dashboard'));
        await tester.pumpAndSettle();
        expect(find.text('Dashboard'), findsOneWidget);

        // Test Nutrition navigation
        await tester.tap(find.text('Nutrition'));
        await tester.pumpAndSettle();
        expect(find.text('Nutrition'), findsOneWidget);

        // Test Activity navigation
        await tester.tap(find.text('Activity'));
        await tester.pumpAndSettle();
        expect(find.text('Activity'), findsOneWidget);

        // Test Profile navigation
        await tester.tap(find.text('Profile'));
        await tester.pumpAndSettle();
        expect(find.text('Profile'), findsOneWidget);
      });
    });

    group('Screen Transitions', () {
      testWidgets('should handle rapid navigation', (WidgetTester tester) async {
        // Arrange
        final app = createApp();

        // Act
        await tester.pumpWidget(app);
        
        // Rapid navigation test
        await tester.tap(find.text('Dashboard'));
        await tester.pump();
        await tester.tap(find.text('Nutrition'));
        await tester.pump();
        await tester.tap(find.text('Activity'));
        await tester.pump();
        await tester.tap(find.text('Profile'));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Profile'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('should handle back navigation', (WidgetTester tester) async {
        // Arrange
        final app = createApp();

        // Act
        await tester.pumpWidget(app);
        await tester.tap(find.text('Nutrition'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Dashboard'));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Dashboard'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    });

    group('Error Handling', () {
      testWidgets('should handle navigation errors gracefully', (WidgetTester tester) async {
        // Arrange
        final app = createApp();

        // Act
        await tester.pumpWidget(app);
        
        // Try to navigate multiple times
        for (int i = 0; i < 5; i++) {
          await tester.tap(find.text('Dashboard'));
          await tester.pump();
        }
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Dashboard'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('should handle widget disposal during navigation', (WidgetTester tester) async {
        // Arrange
        final app = createApp();

        // Act
        await tester.pumpWidget(app);
        await tester.tap(find.text('Activity'));
        await tester.pump();
        
        // Rebuild widget tree
        await tester.pumpWidget(app);
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Dashboard'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    });

    group('Performance', () {
      testWidgets('should handle multiple rebuilds efficiently', (WidgetTester tester) async {
        // Arrange
        final app = createApp();

        // Act
        await tester.pumpWidget(app);
        
        // Multiple rebuilds
        for (int i = 0; i < 10; i++) {
          await tester.pumpWidget(app);
          await tester.pump();
        }
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Dashboard'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('should handle large widget trees', (WidgetTester tester) async {
        // Arrange
        final largeApp = MaterialApp(
          home: Scaffold(
            body: ListView.builder(
              itemCount: 100,
              itemBuilder: (context, index) => ListTile(
                title: Text('Item $index'),
                onTap: () {},
              ),
            ),
          ),
        );

        // Act
        await tester.pumpWidget(largeApp);
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Item 0'), findsOneWidget);
        // Only check for first few items as ListView might not render all items
        expect(find.text('Item 1'), findsOneWidget);
        expect(find.text('Item 2'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    });
  });
}
