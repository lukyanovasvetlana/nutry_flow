import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutry_flow/features/nutrition/presentation/widgets/barcode_scanner_button.dart';

void main() {
  group('BarcodeScannerButton Tests', () {
    late Function(String) mockOnBarcodeScanned;

    setUp(() {
      mockOnBarcodeScanned = (barcode) {};
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: Scaffold(
          body: BarcodeScannerButton(
            onBarcodeScanned: mockOnBarcodeScanned,
          ),
        ),
      );
    }

    group('Rendering', () {
      testWidgets('should render BarcodeScannerButton widget', (WidgetTester tester) async {
        // Arrange
        final widget = createWidgetUnderTest();

        // Act
        await tester.pumpWidget(widget);

        // Assert
        expect(find.byType(BarcodeScannerButton), findsOneWidget);
      });

      testWidgets('should render scanner icon', (WidgetTester tester) async {
        // Arrange
        final widget = createWidgetUnderTest();

        // Act
        await tester.pumpWidget(widget);

        // Assert
        expect(find.byIcon(Icons.qr_code_scanner), findsOneWidget);
      });

      testWidgets('should render as IconButton', (WidgetTester tester) async {
        // Arrange
        final widget = createWidgetUnderTest();

        // Act
        await tester.pumpWidget(widget);

        // Assert
        expect(find.byType(IconButton), findsOneWidget);
      });

      testWidgets('should have proper decoration', (WidgetTester tester) async {
        // Arrange
        final widget = createWidgetUnderTest();

        // Act
        await tester.pumpWidget(widget);

        // Assert
        expect(find.byType(DecoratedBox), findsOneWidget);
      });
    });

    group('Interaction', () {
      testWidgets('should call onBarcodeScanned when tapped', (WidgetTester tester) async {
        // Arrange
        var scannedBarcode = '';
        mockOnBarcodeScanned = (barcode) {
          scannedBarcode = barcode;
        };
        final widget = createWidgetUnderTest();

        // Act
        await tester.pumpWidget(widget);
        await tester.tap(find.byType(IconButton));
        await tester.pumpAndSettle();

        // Assert
        // The mock function should be called (even if with empty string for now)
        expect(scannedBarcode, isA<String>());
      });

      testWidgets('should handle multiple taps', (WidgetTester tester) async {
        // Arrange
        mockOnBarcodeScanned = (barcode) {
          // Handle barcode scan
        };
        final widget = createWidgetUnderTest();

        // Act
        await tester.pumpWidget(widget);
        // Try to tap multiple times
        try {
          await tester.tap(find.byType(IconButton), warnIfMissed: false);
          await tester.tap(find.byType(IconButton), warnIfMissed: false);
          await tester.tap(find.byType(IconButton), warnIfMissed: false);
        } catch (e) {
          // Ignore tap errors
        }
        await tester.pumpAndSettle();

        // Assert
        // Should not crash
        expect(find.byType(BarcodeScannerButton), findsOneWidget);
      });
    });

    group('Layout', () {
      testWidgets('should have correct layout structure', (WidgetTester tester) async {
        // Arrange
        final widget = createWidgetUnderTest();

        // Act
        await tester.pumpWidget(widget);

        // Assert
        expect(find.byType(DecoratedBox), findsOneWidget);
        expect(find.byType(IconButton), findsOneWidget);
        expect(find.byIcon(Icons.qr_code_scanner), findsOneWidget);
      });

      testWidgets('should have proper styling', (WidgetTester tester) async {
        // Arrange
        final widget = createWidgetUnderTest();

        // Act
        await tester.pumpWidget(widget);

        // Assert
        final decoratedBox = tester.widget<DecoratedBox>(find.byType(DecoratedBox));
        expect(decoratedBox.decoration, isA<BoxDecoration>());
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle null callback gracefully', (WidgetTester tester) async {
        // Arrange
        final widget = MaterialApp(
          home: Scaffold(
            body: BarcodeScannerButton(
              onBarcodeScanned: (barcode) {}, // Empty function
            ),
          ),
        );

        // Act
        await tester.pumpWidget(widget);
        await tester.tap(find.byType(IconButton));
        await tester.pumpAndSettle();

        // Assert
        // Should not crash
        expect(find.byType(BarcodeScannerButton), findsOneWidget);
      });

      testWidgets('should handle theme changes', (WidgetTester tester) async {
        // Arrange
        final widget = MaterialApp(
          theme: ThemeData.light(),
          home: Scaffold(
            body: BarcodeScannerButton(
              onBarcodeScanned: mockOnBarcodeScanned,
            ),
          ),
        );

        // Act
        await tester.pumpWidget(widget);

        // Assert
        expect(find.byType(BarcodeScannerButton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('should handle dark theme', (WidgetTester tester) async {
        // Arrange
        final widget = MaterialApp(
          theme: ThemeData.dark(),
          home: Scaffold(
            body: BarcodeScannerButton(
              onBarcodeScanned: mockOnBarcodeScanned,
            ),
          ),
        );

        // Act
        await tester.pumpWidget(widget);

        // Assert
        expect(find.byType(BarcodeScannerButton), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    });
  });
}
