import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutry_flow/features/meal_plan/presentation/screens/meal_details_screen.dart';

void main() {
  group('MealDetailsScreen Tests', () {
    testWidgets('should display meal details screen with loading state', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const MealDetailsScreen(mealName: 'Тестовое блюдо'),
        ),
      );

      // Проверяем, что экран загружается
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Детали блюда'), findsOneWidget);
      
      // Завершаем все таймеры
      await tester.pumpAndSettle();
    });

    testWidgets('should display meal details after loading', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const MealDetailsScreen(mealName: 'Тестовое блюдо'),
        ),
      );

      // Ждем завершения загрузки
      await tester.pumpAndSettle();

      // Проверяем, что данные загрузились
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Тестовое блюдо'), findsOneWidget);
      expect(find.text('Пищевая ценность'), findsOneWidget);
      expect(find.text('Ингредиенты'), findsOneWidget);
      expect(find.text('Инструкции по приготовлению'), findsOneWidget);
    });

    testWidgets('should display nutrition information', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const MealDetailsScreen(mealName: 'Тестовое блюдо'),
        ),
      );

      // Ждем завершения загрузки
      await tester.pumpAndSettle();

      // Проверяем пищевую ценность
      expect(find.text('Калории'), findsOneWidget);
      expect(find.text('Белки'), findsOneWidget);
      expect(find.text('Углеводы'), findsOneWidget);
      expect(find.text('Жиры'), findsOneWidget);
      expect(find.text('450'), findsOneWidget); // калории
    });

    testWidgets('should display ingredients list', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const MealDetailsScreen(mealName: 'Тестовое блюдо'),
        ),
      );

      // Ждем завершения загрузки
      await tester.pumpAndSettle();

      // Проверяем ингредиенты
      expect(find.text('Овсяные хлопья'), findsOneWidget);
      expect(find.text('Молоко'), findsOneWidget);
      expect(find.text('Банан'), findsOneWidget);
      expect(find.text('1 стакан'), findsOneWidget);
    });

    testWidgets('should display cooking instructions', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const MealDetailsScreen(mealName: 'Тестовое блюдо'),
        ),
      );

      // Ждем завершения загрузки
      await tester.pumpAndSettle();

      // Проверяем инструкции
      expect(find.text('Залейте овсяные хлопья молоком и оставьте на 5 минут'), findsOneWidget);
      expect(find.text('Нарежьте банан кольцами'), findsOneWidget);
    });

    testWidgets('should display action buttons', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const MealDetailsScreen(mealName: 'Тестовое блюдо'),
        ),
      );

      // Ждем завершения загрузки
      await tester.pumpAndSettle();

      // Проверяем кнопки действий
      expect(find.text('Добавить в план питания'), findsOneWidget);
      expect(find.text('Добавить в список покупок'), findsOneWidget);
    });

    testWidgets('should show snackbar when adding to meal plan', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const MealDetailsScreen(mealName: 'Тестовое блюдо'),
        ),
      );

      // Ждем завершения загрузки
      await tester.pumpAndSettle();

      // Прокручиваем до кнопки
      await tester.scrollUntilVisible(
        find.text('Добавить в план питания'),
        500.0,
      );

      // Нажимаем кнопку добавления в план питания
      await tester.tap(find.text('Добавить в план питания'));
      await tester.pump();

      // Проверяем появление snackbar
      expect(find.text('Добавлено в план питания!'), findsOneWidget);
    });

    testWidgets('should show snackbar when adding to shopping list', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const MealDetailsScreen(mealName: 'Тестовое блюдо'),
        ),
      );

      // Ждем завершения загрузки
      await tester.pumpAndSettle();

      // Прокручиваем до кнопки
      await tester.scrollUntilVisible(
        find.text('Добавить в список покупок'),
        500.0,
      );

      // Нажимаем кнопку добавления в список покупок
      await tester.tap(find.text('Добавить в список покупок'));
      await tester.pump();

      // Проверяем появление snackbar
      expect(find.text('Ингредиенты добавлены в список покупок!'), findsOneWidget);
    });

    testWidgets('should navigate back to dashboard when back button is pressed', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          initialRoute: '/meal-details',
          routes: {
            '/meal-details': (context) => const MealDetailsScreen(mealName: 'Тестовое блюдо'),
          },
        ),
      );

      // Ждем завершения загрузки
      await tester.pumpAndSettle();

      // Проверяем, что кнопка назад есть
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('should display quick info section', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const MealDetailsScreen(mealName: 'Тестовое блюдо'),
        ),
      );

      // Ждем завершения загрузки
      await tester.pumpAndSettle();

      // Проверяем быструю информацию
      expect(find.text('25 мин'), findsOneWidget);
      expect(find.text('2 порции'), findsOneWidget);
      expect(find.text('Средняя'), findsOneWidget);
      expect(find.text('Время'), findsOneWidget);
      expect(find.text('Порций'), findsOneWidget);
      expect(find.text('Сложность'), findsOneWidget);
    });

    testWidgets('should display nutrition tips', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const MealDetailsScreen(mealName: 'Тестовое блюдо'),
        ),
      );

      // Ждем завершения загрузки
      await tester.pumpAndSettle();

      // Проверяем советы по питанию
      expect(find.text('Полезные советы'), findsOneWidget);
      expect(find.text('Богат клетчаткой для улучшения пищеварения'), findsOneWidget);
      expect(find.text('Содержит полезные жиры для работы мозга'), findsOneWidget);
    });

    testWidgets('should display rating stars', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const MealDetailsScreen(mealName: 'Тестовое блюдо'),
        ),
      );

      // Ждем завершения загрузки
      await tester.pumpAndSettle();

      // Проверяем рейтинг
      expect(find.text('4.8 (127 отзывов)'), findsOneWidget);
      expect(find.byIcon(Icons.star), findsWidgets);
    });

    testWidgets('should display favorite and share buttons in app bar', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const MealDetailsScreen(mealName: 'Тестовое блюдо'),
        ),
      );

      // Проверяем кнопки в AppBar
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      expect(find.byIcon(Icons.share), findsOneWidget);
      
      // Завершаем все таймеры
      await tester.pumpAndSettle();
    });
  });
} 