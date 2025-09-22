import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:nutry_flow/features/dashboard/presentation/widgets/expense_breakdown_chart.dart';

void main() {
  group('ExpenseBreakdownChart Tests', () {
    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: Scaffold(
          body: const ExpenseBreakdownChart(),
        ),
      );
    }

    group('Rendering', () {
      testWidgets('should render ExpenseBreakdownChart widget', (WidgetTester tester) async {
        // Arrange
        final widget = createWidgetUnderTest();

        // Act
        await tester.pumpWidget(widget);

        // Assert
        expect(find.byType(ExpenseBreakdownChart), findsOneWidget);
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
        expect(find.byType(ExpenseBreakdownChart), findsOneWidget);
      });
    });

    group('Responsive Design', () {
      testWidgets('should render in different screen sizes', (WidgetTester tester) async {
        // Arrange
        final widget = MaterialApp(
          home: Scaffold(
            body: const ExpenseBreakdownChart(),
          ),
        );

        // Act - Test with different screen sizes
        await tester.binding.setSurfaceSize(const Size(400, 800));
        await tester.pumpWidget(widget);
        expect(find.byType(ExpenseBreakdownChart), findsOneWidget);

        await tester.binding.setSurfaceSize(const Size(600, 1000));
        await tester.pumpWidget(widget);
        expect(find.byType(ExpenseBreakdownChart), findsOneWidget);

        await tester.binding.setSurfaceSize(const Size(800, 1200));
        await tester.pumpWidget(widget);
        expect(find.byType(ExpenseBreakdownChart), findsOneWidget);

        // Reset to default size
        await tester.binding.setSurfaceSize(null);
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle theme changes', (WidgetTester tester) async {
        // Arrange
        final widget = MaterialApp(
          theme: ThemeData.light(),
          home: const Scaffold(
            body: ExpenseBreakdownChart(),
          ),
        );

        // Act
        await tester.pumpWidget(widget);

        // Assert
        expect(find.byType(ExpenseBreakdownChart), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('should handle dark theme', (WidgetTester tester) async {
        // Arrange
        final widget = MaterialApp(
          theme: ThemeData.dark(),
          home: const Scaffold(
            body: ExpenseBreakdownChart(),
          ),
        );

        // Act
        await tester.pumpWidget(widget);

        // Assert
        expect(find.byType(ExpenseBreakdownChart), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    });
  });
}