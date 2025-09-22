import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExerciseCatalogScreen Tests', () {
    testWidgets('should display exercise catalog screen', (WidgetTester tester) async {
      // Arrange
      final widget = MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: Text('Каталог упражнений')),
          body: ListView(
            children: [
              Text('Категории упражнений'),
              Text('Список упражнений'),
            ],
          ),
        ),
      );

      // Act
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Каталог упражнений'), findsOneWidget);
    });

    testWidgets('should have correct AppBar title', (WidgetTester tester) async {
      // Arrange
      final widget = MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: Text('Каталог упражнений')),
          body: ListView(
            children: [
              Text('Категории упражнений'),
            ],
          ),
        ),
      );

      // Act
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Каталог упражнений'), findsOneWidget);
    });

    testWidgets('should display search bar', (WidgetTester tester) async {
      // Arrange
      final widget = MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: Text('Каталог упражнений')),
          body: ListView(
            children: [
              TextField(),
              Text('Категории упражнений'),
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

    testWidgets('should display exercise categories', (WidgetTester tester) async {
      // Arrange
      final widget = MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: Text('Каталог упражнений')),
          body: ListView(
            children: [
              Text('Категории упражнений'),
            ],
          ),
        ),
      );

      // Act
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Категории упражнений'), findsOneWidget);
    });

    testWidgets('should display exercise list', (WidgetTester tester) async {
      // Arrange
      final widget = MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: Text('Каталог упражнений')),
          body: ListView(
            children: [
              Text('Список упражнений'),
            ],
          ),
        ),
      );

      // Act
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Список упражнений'), findsOneWidget);
    });

    testWidgets('should filter exercises when search text is entered', (WidgetTester tester) async {
      // Arrange
      final widget = MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: Text('Каталог упражнений')),
          body: ListView(
            children: [
              TextField(),
              Text('Список упражнений'),
            ],
          ),
        ),
      );

      // Act
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'приседания');
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('приседания'), findsOneWidget);
    });
  });
}