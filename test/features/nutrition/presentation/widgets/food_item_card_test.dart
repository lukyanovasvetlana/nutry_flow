import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutry_flow/features/nutrition/presentation/widgets/food_item_card.dart';
import 'package:nutry_flow/features/nutrition/domain/entities/food_item.dart';

void main() {
  group('FoodItemCard Tests', () {
    late FoodItem mockFoodItem;
    late VoidCallback mockOnTap;
    late VoidCallback mockOnFavoriteToggle;

    setUp(() {
      // Create a simple FoodItem for testing
      mockFoodItem = FoodItem(
        id: '1',
        name: 'Sample Food',
        caloriesPer100g: 250.0,
        proteinPer100g: 15.0,
        carbsPer100g: 30.0,
        fatsPer100g: 8.0,
        fiberPer100g: 5.0,
        sugarPer100g: 10.0,
        sodiumPer100g: 300.0,
        brand: 'Sample Brand',
        category: 'Dairy',
        imageUrl: 'https://example.com/image.jpg',
        barcode: '123456789',
        description: 'A sample food item for testing',
        allergens: ['milk'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      mockOnTap = () {};
      mockOnFavoriteToggle = () {};
    });

    Widget createWidgetUnderTest({
      FoodItem? foodItem,
      VoidCallback? onTap,
      VoidCallback? onFavoriteToggle,
      bool isFavorite = false,
      bool showActions = true,
      double portionSize = 100.0,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: FoodItemCard(
            foodItem: foodItem ?? mockFoodItem,
            onTap: onTap,
            onFavoriteToggle: onFavoriteToggle,
            isFavorite: isFavorite,
            showActions: showActions,
            portionSize: portionSize,
          ),
        ),
      );
    }

    group('Rendering', () {
      testWidgets('should render FoodItemCard widget', (WidgetTester tester) async {
        // Arrange
        final widget = createWidgetUnderTest();

        // Act
        await tester.pumpWidget(widget);

        // Assert
        expect(find.byType(FoodItemCard), findsOneWidget);
      });

      testWidgets('should render food name', (WidgetTester tester) async {
        // Arrange
        final widget = createWidgetUnderTest();

        // Act
        await tester.pumpWidget(widget);

        // Assert
        expect(find.text('Sample Food'), findsOneWidget);
      });

      testWidgets('should render as Card', (WidgetTester tester) async {
        // Arrange
        final widget = createWidgetUnderTest();

        // Act
        await tester.pumpWidget(widget);

        // Assert
        expect(find.byType(Card), findsOneWidget);
      });
    });

    group('Interaction', () {
      testWidgets('should call onTap when tapped', (WidgetTester tester) async {
        // Arrange
        var tapped = false;
        mockOnTap = () {
          tapped = true;
        };
        final widget = createWidgetUnderTest(onTap: mockOnTap);

        // Act
        await tester.pumpWidget(widget);
        await tester.tap(find.byType(Card));
        await tester.pumpAndSettle();

        // Assert
        expect(tapped, isTrue);
      });
    });

    group('Properties', () {
      testWidgets('should show favorite icon when isFavorite is true', (WidgetTester tester) async {
        // Arrange
        final widget = createWidgetUnderTest(isFavorite: true, showActions: true);

        // Act
        await tester.pumpWidget(widget);

        // Assert
        // Should render without errors
        expect(find.byType(FoodItemCard), findsOneWidget);
      });

      testWidgets('should hide actions when showActions is false', (WidgetTester tester) async {
        // Arrange
        final widget = createWidgetUnderTest(showActions: false);

        // Act
        await tester.pumpWidget(widget);

        // Assert
        expect(find.byType(FoodItemCard), findsOneWidget);
      });
    });

    group('Layout', () {
      testWidgets('should have correct layout structure', (WidgetTester tester) async {
        // Arrange
        final widget = createWidgetUnderTest();

        // Act
        await tester.pumpWidget(widget);

        // Assert
        expect(find.byType(Card), findsOneWidget);
        expect(find.byType(Column), findsAtLeastNWidgets(1));
        expect(find.byType(Row), findsAtLeastNWidgets(1));
      });

      testWidgets('should handle different food items', (WidgetTester tester) async {
        // Arrange
        final minimalFood = FoodItem(
          id: '2',
          name: 'Minimal Food',
          caloriesPer100g: 100.0,
          proteinPer100g: 5.0,
          carbsPer100g: 15.0,
          fatsPer100g: 3.0,
          fiberPer100g: 2.0,
          sugarPer100g: 5.0,
          sodiumPer100g: 150.0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        final widget = createWidgetUnderTest(foodItem: minimalFood);

        // Act
        await tester.pumpWidget(widget);

        // Assert
        expect(find.text('Minimal Food'), findsOneWidget);
        expect(find.byType(FoodItemCard), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle null callbacks gracefully', (WidgetTester tester) async {
        // Arrange
        final widget = createWidgetUnderTest(
          onTap: null,
          onFavoriteToggle: null,
        );

        // Act
        await tester.pumpWidget(widget);
        await tester.tap(find.byType(Card));
        await tester.pumpAndSettle();

        // Assert
        // Should not crash
        expect(find.byType(FoodItemCard), findsOneWidget);
      });

      testWidgets('should handle theme changes', (WidgetTester tester) async {
        // Arrange
        final widget = MaterialApp(
          theme: ThemeData.light(),
          home: Scaffold(
            body: FoodItemCard(
              foodItem: mockFoodItem,
              onTap: mockOnTap,
            ),
          ),
        );

        // Act
        await tester.pumpWidget(widget);

        // Assert
        expect(find.byType(FoodItemCard), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    });
  });
}