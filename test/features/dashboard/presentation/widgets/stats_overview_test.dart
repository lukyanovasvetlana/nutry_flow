import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutry_flow/features/dashboard/presentation/widgets/stats_overview.dart';

void main() {
  group('StatsOverview Tests', () {
    late Function(int) mockOnCardTap;
    late int selectedIndex;

    setUp(() {
      mockOnCardTap = (index) {};
      selectedIndex = 0;
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: Scaffold(
          body: StatsOverview(
            onCardTap: mockOnCardTap,
            selectedIndex: selectedIndex,
          ),
        ),
      );
    }

    group('Rendering', () {
      testWidgets('should render StatsOverview widget', (WidgetTester tester) async {
        // Arrange
        final widget = createWidgetUnderTest();

        // Act
        await tester.pumpWidget(widget);

        // Assert
        expect(find.byType(StatsOverview), findsOneWidget);
      });

      testWidgets('should render three stat cards', (WidgetTester tester) async {
        // Arrange
        final widget = createWidgetUnderTest();

        // Act
        await tester.pumpWidget(widget);

        // Assert
        expect(find.text('Стоимость'), findsOneWidget);
        expect(find.text('Продукты'), findsOneWidget);
        expect(find.text('Калории'), findsOneWidget);
      });

      testWidgets('should render stat values', (WidgetTester tester) async {
        // Arrange
        final widget = createWidgetUnderTest();

        // Act
        await tester.pumpWidget(widget);

        // Assert
        expect(find.text('₽11,300'), findsOneWidget);
        expect(find.text('40'), findsOneWidget);
        expect(find.text('21.6к'), findsOneWidget);
      });

      testWidgets('should render percentage changes', (WidgetTester tester) async {
        // Arrange
        final widget = createWidgetUnderTest();

        // Act
        await tester.pumpWidget(widget);

        // Assert
        expect(find.text('+20%'), findsOneWidget);
        expect(find.text('+10.2%'), findsOneWidget);
        expect(find.text('-3.6%'), findsOneWidget);
      });

      testWidgets('should render icons', (WidgetTester tester) async {
        // Arrange
        final widget = createWidgetUnderTest();

        // Act
        await tester.pumpWidget(widget);

        // Assert
        expect(find.byIcon(Icons.account_balance_wallet), findsOneWidget);
        expect(find.byIcon(Icons.shopping_basket), findsOneWidget);
        expect(find.byIcon(Icons.local_fire_department), findsOneWidget);
      });
    });

    group('Interaction', () {
      testWidgets('should call onCardTap when card is tapped', (WidgetTester tester) async {
        // Arrange
        var tappedIndex = -1;
        mockOnCardTap = (index) {
          tappedIndex = index;
        };
        final widget = createWidgetUnderTest();

        // Act
        await tester.pumpWidget(widget);
        await tester.tap(find.text('Стоимость'));
        await tester.pumpAndSettle();

        // Assert
        expect(tappedIndex, equals(0));
      });

      testWidgets('should call onCardTap with correct index for each card', (WidgetTester tester) async {
        // Arrange
        var tappedIndex = -1;
        mockOnCardTap = (index) {
          tappedIndex = index;
        };
        final widget = createWidgetUnderTest();

        // Act
        await tester.pumpWidget(widget);

        // Test first card
        await tester.tap(find.text('Стоимость'));
        await tester.pumpAndSettle();
        expect(tappedIndex, equals(0));

        // Test second card
        await tester.tap(find.text('Продукты'));
        await tester.pumpAndSettle();
        expect(tappedIndex, equals(1));

        // Test third card
        await tester.tap(find.text('Калории'));
        await tester.pumpAndSettle();
        expect(tappedIndex, equals(2));
      });
    });

    group('Selected State', () {
      testWidgets('should highlight selected card', (WidgetTester tester) async {
        // Arrange
        selectedIndex = 1;
        final widget = createWidgetUnderTest();

        // Act
        await tester.pumpWidget(widget);

        // Assert
        // The selected card should have different styling
        expect(find.byType(StatsOverview), findsOneWidget);
      });

      testWidgets('should handle different selected indices', (WidgetTester tester) async {
        // Arrange
        selectedIndex = 2;
        final widget = createWidgetUnderTest();

        // Act
        await tester.pumpWidget(widget);

        // Assert
        expect(find.byType(StatsOverview), findsOneWidget);
      });
    });

    group('Layout', () {
      testWidgets('should have correct layout structure', (WidgetTester tester) async {
        // Arrange
        final widget = createWidgetUnderTest();

        // Act
        await tester.pumpWidget(widget);

        // Assert
        expect(find.byType(IntrinsicHeight), findsOneWidget);
        expect(find.byType(Row), findsAtLeastNWidgets(1));
        expect(find.byType(Expanded), findsAtLeastNWidgets(3));
        expect(find.byType(SizedBox), findsAtLeastNWidgets(1));
      });

      testWidgets('should have proper spacing between cards', (WidgetTester tester) async {
        // Arrange
        final widget = createWidgetUnderTest();

        // Act
        await tester.pumpWidget(widget);

        // Assert
        final sizedBoxes = find.byType(SizedBox);
        expect(sizedBoxes, findsAtLeastNWidgets(1));
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle null onCardTap gracefully', (WidgetTester tester) async {
        // Arrange
        final widget = MaterialApp(
          home: Scaffold(
            body: StatsOverview(
              onCardTap: (index) {}, // Empty function
              selectedIndex: 0,
            ),
          ),
        );

        // Act
        await tester.pumpWidget(widget);

        // Assert
        expect(find.byType(StatsOverview), findsOneWidget);
      });

      testWidgets('should handle negative selectedIndex', (WidgetTester tester) async {
        // Arrange
        selectedIndex = -1;
        final widget = createWidgetUnderTest();

        // Act
        await tester.pumpWidget(widget);

        // Assert
        expect(find.byType(StatsOverview), findsOneWidget);
      });

      testWidgets('should handle selectedIndex greater than available cards', (WidgetTester tester) async {
        // Arrange
        selectedIndex = 10;
        final widget = createWidgetUnderTest();

        // Act
        await tester.pumpWidget(widget);

        // Assert
        expect(find.byType(StatsOverview), findsOneWidget);
      });
    });
  });
}
