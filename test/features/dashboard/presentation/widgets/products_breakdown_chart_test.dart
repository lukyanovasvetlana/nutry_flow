import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:nutry_flow/features/dashboard/presentation/widgets/products_breakdown_chart.dart';

void main() {
  group('ProductsBreakdownChart Tests', () {
    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: Scaffold(
          body: const ProductsBreakdownChart(),
        ),
      );
    }

    group('Rendering', () {
      testWidgets('should render ProductsBreakdownChart widget', (WidgetTester tester) async {
        // Arrange
        final widget = createWidgetUnderTest();

        // Act
        await tester.pumpWidget(widget);

        // Assert
        expect(find.byType(ProductsBreakdownChart), findsOneWidget);
      });

      testWidgets('should render pie chart', (WidgetTester tester) async {
        // Arrange
        final widget = createWidgetUnderTest();

        // Act
        await tester.pumpWidget(widget);

        // Assert
        expect(find.byType(PieChart), findsOneWidget);
      });
    });

    group('Layout', () {
      testWidgets('should have correct layout structure', (WidgetTester tester) async {
        // Arrange
        final widget = createWidgetUnderTest();

        // Act
        await tester.pumpWidget(widget);

        // Assert
        expect(find.byType(Column), findsAtLeastNWidgets(1));
        expect(find.byType(Row), findsAtLeastNWidgets(1));
        expect(find.byType(Expanded), findsAtLeastNWidgets(1));
      });

      testWidgets('should have proper spacing', (WidgetTester tester) async {
        // Arrange
        final widget = createWidgetUnderTest();

        // Act
        await tester.pumpWidget(widget);

        // Assert
        final sizedBoxes = find.byType(SizedBox);
        expect(sizedBoxes, findsAtLeastNWidgets(1));
      });
    });

    group('Chart Data', () {
      testWidgets('should display chart with data', (WidgetTester tester) async {
        // Arrange
        final widget = createWidgetUnderTest();

        // Act
        await tester.pumpWidget(widget);

        // Assert
        expect(find.byType(PieChart), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    });

    group('Interaction', () {
      testWidgets('should handle chart interaction', (WidgetTester tester) async {
        // Arrange
        final widget = createWidgetUnderTest();

        // Act
        await tester.pumpWidget(widget);
        // Try to tap on the chart area
        final chartFinder = find.byType(PieChart);
        if (chartFinder.evaluate().isNotEmpty) {
          await tester.tap(chartFinder);
          await tester.pumpAndSettle();
        }

        // Assert
        // Should not crash when interacted with
        expect(find.byType(ProductsBreakdownChart), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle theme changes', (WidgetTester tester) async {
        // Arrange
        final widget = MaterialApp(
          theme: ThemeData.light(),
          home: const Scaffold(
            body: ProductsBreakdownChart(),
          ),
        );

        // Act
        await tester.pumpWidget(widget);

        // Assert
        expect(find.byType(ProductsBreakdownChart), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    });
  });
}