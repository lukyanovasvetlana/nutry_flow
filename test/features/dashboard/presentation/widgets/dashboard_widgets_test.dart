import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutry_flow/features/dashboard/presentation/widgets/workout_progress_card.dart';
import 'package:nutry_flow/features/dashboard/presentation/widgets/recent_activity_card.dart';
import 'package:nutry_flow/features/dashboard/presentation/widgets/recommended_menu_card.dart';
import 'package:nutry_flow/features/dashboard/presentation/widgets/recommended_exercises_card.dart';
import 'package:nutry_flow/features/dashboard/presentation/widgets/weight_card.dart';
import 'package:nutry_flow/features/dashboard/presentation/widgets/sleep_card.dart';
import 'package:nutry_flow/features/dashboard/presentation/widgets/steps_card.dart';
import 'package:nutry_flow/features/dashboard/presentation/widgets/water_card.dart';

void main() {
  group('Dashboard Widgets', () {
    group('WorkoutProgressCard', () {
      testWidgets('renders without crashing', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WorkoutProgressCard(),
            ),
          ),
        );

        // Assert
        expect(find.byType(WorkoutProgressCard), findsOneWidget);
      });
    });

    group('RecentActivityCard', () {
      testWidgets('renders without crashing', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: RecentActivityCard(),
            ),
          ),
        );

        // Assert
        expect(find.byType(RecentActivityCard), findsOneWidget);
      });
    });

    group('RecommendedMenuCard', () {
      testWidgets('renders without crashing', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: RecommendedMenuCard(),
            ),
          ),
        );

        // Assert
        expect(find.byType(RecommendedMenuCard), findsOneWidget);
      });
    });

    group('RecommendedExercisesCard', () {
      testWidgets('renders without crashing', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: RecommendedExercisesCard(),
            ),
          ),
        );

        // Assert
        expect(find.byType(RecommendedExercisesCard), findsOneWidget);
      });
    });

    group('WeightCard', () {
      testWidgets('renders without crashing', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WeightCard(),
            ),
          ),
        );

        // Assert
        expect(find.byType(WeightCard), findsOneWidget);
      });
    });

    group('SleepCard', () {
      testWidgets('renders without crashing', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SleepCard(),
            ),
          ),
        );

        // Assert
        expect(find.byType(SleepCard), findsOneWidget);
      });
    });

    group('StepsCard', () {
      testWidgets('renders without crashing', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StepsCard(),
            ),
          ),
        );

        // Assert
        expect(find.byType(StepsCard), findsOneWidget);
      });
    });

    group('WaterCard', () {
      testWidgets('renders without crashing', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WaterCard(),
            ),
          ),
        );

        // Assert
        expect(find.byType(WaterCard), findsOneWidget);
      });
    });
  });
}
