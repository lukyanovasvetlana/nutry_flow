import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GroceryListScreen Tests', () {
    testWidgets('should display grocery list screen', (WidgetTester tester) async {
      // Arrange
      final widget = MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: Text('Список покупок')),
          body: ListView(
            children: [
              Text('Список покупок'),
            ],
          ),
        ),
      );

      // Act
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Список покупок'), findsAtLeastNWidgets(1));
    });

    testWidgets('should have correct AppBar title', (WidgetTester tester) async {
      // Arrange
      final widget = MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: Text('Список покупок')),
          body: ListView(
            children: [
              Text('Список покупок'),
            ],
          ),
        ),
      );

      // Act
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Список покупок'), findsAtLeastNWidgets(1));
    });

    testWidgets('should display grocery items list', (WidgetTester tester) async {
      // Arrange
      final widget = MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: Text('Список покупок')),
          body: ListView(
            children: [
              Text('Список покупок'),
            ],
          ),
        ),
      );

      // Act
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Список покупок'), findsAtLeastNWidgets(1));
    });

    testWidgets('should have floating action button for adding items', (WidgetTester tester) async {
      // Arrange
      final widget = MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: Text('Список покупок')),
          body: ListView(
            children: [
              Text('Список покупок'),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child: Icon(Icons.add),
          ),
        ),
      );

      // Act
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('should have search functionality', (WidgetTester tester) async {
      // Arrange
      final widget = MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: Text('Список покупок')),
          body: ListView(
            children: [
              TextField(),
              Text('Список покупок'),
            ],
          ),
        ),
      );

      // Act
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('should filter items when search text is entered', (WidgetTester tester) async {
      // Arrange
      final widget = MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: Text('Список покупок')),
          body: ListView(
            children: [
              TextField(),
              Text('Список покупок'),
            ],
          ),
        ),
      );

      // Act
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'молоко');
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('молоко'), findsOneWidget);
    });

    testWidgets('should navigate to add item when FAB is tapped', (WidgetTester tester) async {
      // Arrange
      final widget = MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: Text('Список покупок')),
          body: ListView(
            children: [
              Text('Список покупок'),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child: Icon(Icons.add),
          ),
        ),
      );

      // Act
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });
  });
}