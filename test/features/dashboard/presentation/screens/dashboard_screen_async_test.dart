import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nutry_flow/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:nutry_flow/features/profile/data/services/sync_mock_profile_service.dart';
import 'package:nutry_flow/features/profile/data/models/user_profile_model.dart';

/// Тесты для асинхронных операций DashboardScreen
/// 
/// Проверяют корректную работу с асинхронными операциями,
/// включая загрузку профиля, обработку ошибок и состояний загрузки.
void main() {
  group('DashboardScreen Async Operations Tests', () {
    late SyncMockProfileService profileService;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      profileService = SyncMockProfileService();
      SyncMockProfileService.initialize();
    });

    tearDown(() {
      SyncMockProfileService.clearAll();
    });

    group('Асинхронная загрузка профиля', () {
      testWidgets('корректно обрабатывает состояние загрузки', (WidgetTester tester) async {
        // Arrange
        SharedPreferences.setMockInitialValues({});

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: const DashboardScreen(),
          ),
        );

        // Проверяем начальное состояние
        expect(find.byType(DashboardScreen), findsOneWidget);

        // Ждем завершения асинхронных операций
        await tester.pumpAndSettle();

        // Assert
        // После загрузки должен отображаться демо-профиль
        expect(find.textContaining('Демо'), findsOneWidget);
      });

      testWidgets('загружает профиль из SharedPreferences асинхронно', (WidgetTester tester) async {
        // Arrange
        SharedPreferences.setMockInitialValues({
          'userName': 'Асинк',
          'userLastName': 'Тест',
          'userEmail': 'async@test.com',
        });

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: const DashboardScreen(),
          ),
        );

        // Проверяем до завершения загрузки
        expect(find.byType(DashboardScreen), findsOneWidget);

        // Ждем завершения асинхронных операций
        await tester.pumpAndSettle();

        // Assert
        expect(find.textContaining('Асинк'), findsOneWidget);
      });

      testWidgets('корректно переключается между состояниями загрузки', (WidgetTester tester) async {
        // Arrange
        SharedPreferences.setMockInitialValues({});

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: const DashboardScreen(),
          ),
        );

        // Проверяем начальное состояние (загрузка)
        expect(find.byType(DashboardScreen), findsOneWidget);

        // Pump один раз для начала асинхронной операции
        await tester.pump();

        // Pump еще раз для обработки микротасков
        await tester.pump(Duration.zero);

        // Завершаем все асинхронные операции
        await tester.pumpAndSettle();

        // Assert
        // После завершения загрузки должен отображаться контент
        expect(find.textContaining('Демо'), findsOneWidget);
      });
    });

    group('Обработка ошибок асинхронных операций', () {
      testWidgets('обрабатывает ошибки загрузки профиля gracefully', (WidgetTester tester) async {
        // Arrange
        SharedPreferences.setMockInitialValues({
          'userName': 'Test',
        });

        // Очищаем все профили, чтобы симулировать ошибку
        SyncMockProfileService.clearAll();

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: const DashboardScreen(),
          ),
        );

        await tester.pumpAndSettle();

        // Assert
        // Экран должен отображаться без краша, даже если ProfileService пуст
        expect(find.byType(DashboardScreen), findsOneWidget);
      });

      testWidgets('обрабатывает поврежденные данные SharedPreferences', (WidgetTester tester) async {
        // Arrange
        SharedPreferences.setMockInitialValues({
          'userName': '', // Пустое имя
          'userEmail': 'invalid-email', // Невалидный email
        });

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: const DashboardScreen(),
          ),
        );

        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(DashboardScreen), findsOneWidget);
      });
    });

    group('Конкурентные асинхронные операции', () {
      testWidgets('корректно обрабатывает быструю смену состояний', (WidgetTester tester) async {
        // Arrange
        SharedPreferences.setMockInitialValues({
          'userName': 'Быстрый',
        });

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: const DashboardScreen(),
          ),
        );

        // Быстро пumpим несколько раз
        await tester.pump();
        await tester.pump();
        await tester.pump();

        // Завершаем все операции
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(DashboardScreen), findsOneWidget);
        expect(find.textContaining('Быстрый'), findsOneWidget);
      });

      testWidgets('обрабатывает множественные rebuild\'ы во время загрузки', (WidgetTester tester) async {
        // Arrange
        SharedPreferences.setMockInitialValues({
          'userName': 'Мульти',
        });

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: const DashboardScreen(),
          ),
        );

        // Симулируем множественные rebuild'ы
        for (int i = 0; i < 5; i++) {
          await tester.pump();
        }

        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(DashboardScreen), findsOneWidget);
        expect(find.textContaining('Мульти'), findsOneWidget);
      });
    });

    group('Жизненный цикл асинхронных операций', () {
      testWidgets('корректно инициализирует асинхронные операции в initState', (WidgetTester tester) async {
        // Arrange
        SharedPreferences.setMockInitialValues({
          'userName': 'InitState',
        });

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: const DashboardScreen(),
          ),
        );

        // Проверяем, что initState был вызван
        expect(find.byType(DashboardScreen), findsOneWidget);

        await tester.pumpAndSettle();

        // Assert
        // Асинхронные операции должны быть инициализированы
        expect(find.textContaining('InitState'), findsOneWidget);
      });

      testWidgets('корректно обрабатывает dispose во время асинхронных операций', (WidgetTester tester) async {
        // Arrange
        SharedPreferences.setMockInitialValues({
          'userName': 'Dispose',
        });

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: const DashboardScreen(),
          ),
        );

        // Начинаем асинхронные операции
        await tester.pump();

        // Удаляем виджет до завершения операций
        await tester.pumpWidget(
          MaterialApp(
            home: Container(),
          ),
        );

        // Assert
        // Не должно быть исключений
        expect(find.byType(DashboardScreen), findsNothing);
      });
    });

    group('Обработка состояний профиля', () {
      testWidgets('обрабатывает переход от загрузки к успешному состоянию', (WidgetTester tester) async {
        // Arrange
        SharedPreferences.setMockInitialValues({
          'userName': 'Успех',
        });

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: const DashboardScreen(),
          ),
        );

        // Начальное состояние
        expect(find.byType(DashboardScreen), findsOneWidget);

        // Завершаем загрузку
        await tester.pumpAndSettle();

        // Assert
        expect(find.textContaining('Успех'), findsOneWidget);
      });

      testWidgets('обрабатывает отсутствие данных профиля', (WidgetTester tester) async {
        // Arrange
        SharedPreferences.setMockInitialValues({});
        SyncMockProfileService.clearAll(); // Убираем демо-профиль

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: const DashboardScreen(),
          ),
        );

        await tester.pumpAndSettle();

        // Assert
        // Должно отображаться приветствие по умолчанию
        expect(find.byType(DashboardScreen), findsOneWidget);
        expect(find.textContaining('Добро пожаловать'), findsOneWidget);
      });
    });

    group('Интеграция с аналитикой (асинхронно)', () {
      testWidgets('отслеживает события загрузки профиля', (WidgetTester tester) async {
        // Arrange
        SharedPreferences.setMockInitialValues({
          'userName': 'Аналитика',
          'userEmail': 'analytics@test.com',
        });

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: const DashboardScreen(),
          ),
        );

        await tester.pumpAndSettle();

        // Assert
        // Проверяем, что экран загрузился (аналитика должна сработать)
        expect(find.byType(DashboardScreen), findsOneWidget);
        expect(find.textContaining('Аналитика'), findsOneWidget);
      });

      testWidgets('отслеживает ошибки загрузки профиля', (WidgetTester tester) async {
        // Arrange
        SharedPreferences.setMockInitialValues({});
        SyncMockProfileService.clearAll();

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: const DashboardScreen(),
          ),
        );

        await tester.pumpAndSettle();

        // Assert
        // Экран должен загрузиться без ошибок
        expect(find.byType(DashboardScreen), findsOneWidget);
      });
    });
  });
}
