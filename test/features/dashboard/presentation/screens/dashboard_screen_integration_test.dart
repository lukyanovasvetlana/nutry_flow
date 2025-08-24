import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nutry_flow/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:nutry_flow/features/profile/data/services/sync_mock_profile_service.dart';
import 'package:nutry_flow/features/profile/data/models/user_profile_model.dart';
import 'package:nutry_flow/shared/design/components/cards/nutry_card.dart';

/// Интеграционные тесты для DashboardScreen
/// 
/// Проверяют полную функциональность экрана дашборда,
/// включая интеграцию с ProfileService, SharedPreferences
/// и корректную работу всех UI компонентов.
void main() {
  group('DashboardScreen Integration Tests', () {
    late SyncMockProfileService profileService;

    setUp(() {
      // Инициализируем SharedPreferences
      SharedPreferences.setMockInitialValues({});
      
      // Инициализируем синхронный mock сервис
      profileService = SyncMockProfileService();
      SyncMockProfileService.initialize();
    });

    tearDown(() {
      // Очищаем данные после каждого теста
      SyncMockProfileService.clearAll();
    });

    group('Базовая функциональность', () {
      testWidgets('отображает экран без ошибок', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: const DashboardScreen(),
          ),
        );

        // Act & Assert
        expect(find.byType(DashboardScreen), findsOneWidget);
        expect(find.byType(Scaffold), findsOneWidget);
      });

      testWidgets('отображает заголовок аналитики', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: const DashboardScreen(),
          ),
        );

        // Act & Assert
        expect(find.text('Аналитика питания'), findsOneWidget);
      });

      testWidgets('отображает карточки графиков', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: const DashboardScreen(),
          ),
        );

        // Act & Assert
        expect(find.byType(NutryCard), findsAtLeastNWidgets(1));
      });

      testWidgets('отображает плавающее меню', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: const DashboardScreen(),
          ),
        );

        // Act & Assert
        expect(find.byType(PopupMenuButton), findsOneWidget);
      });
    });

    group('Загрузка профиля из SharedPreferences', () {
      testWidgets('отображает имя пользователя из SharedPreferences', (WidgetTester tester) async {
        // Arrange
        SharedPreferences.setMockInitialValues({
          'userName': 'Анна',
          'userLastName': 'Иванова',
          'userEmail': 'anna@example.com',
        });

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: const DashboardScreen(),
          ),
        );

        // Ждем загрузки
        await tester.pumpAndSettle();

        // Assert
        // Проверяем, что экран загрузился корректно
        expect(find.byType(DashboardScreen), findsOneWidget);
        // Имя пользователя будет отображаться в приветствии
        expect(find.textContaining('Анна'), findsOneWidget);
      });

      testWidgets('корректно обрабатывает полные данные профиля', (WidgetTester tester) async {
        // Arrange
        SharedPreferences.setMockInitialValues({
          'userName': 'Иван',
          'userLastName': 'Петров',
          'userEmail': 'ivan.petrov@example.com',
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
        expect(find.textContaining('Иван'), findsOneWidget);
      });

      testWidgets('обрабатывает пустые SharedPreferences', (WidgetTester tester) async {
        // Arrange
        SharedPreferences.setMockInitialValues({});

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: const DashboardScreen(),
          ),
        );

        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(DashboardScreen), findsOneWidget);
        // Должно отображаться приветствие по умолчанию
        expect(find.textContaining('Добро пожаловать'), findsOneWidget);
      });
    });

    group('Интеграция с ProfileService', () {
      testWidgets('загружает демо-профиль при отсутствии локальных данных', (WidgetTester tester) async {
        // Arrange
        SharedPreferences.setMockInitialValues({});

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: const DashboardScreen(),
          ),
        );

        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(DashboardScreen), findsOneWidget);
        // Демо-профиль должен загрузиться
        expect(find.textContaining('Демо'), findsOneWidget);
      });

      testWidgets('приоритизирует локальные данные над демо-профилем', (WidgetTester tester) async {
        // Arrange
        SharedPreferences.setMockInitialValues({
          'userName': 'Локальный',
          'userEmail': 'local@example.com',
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
        // Локальные данные должны иметь приоритет
        expect(find.textContaining('Локальный'), findsOneWidget);
      });
    });

    group('Взаимодействие с UI', () {
      testWidgets('можно нажать на плавающее меню', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: const DashboardScreen(),
          ),
        );

        await tester.pumpAndSettle();

        // Act
        final menuButton = find.byType(PopupMenuButton);
        expect(menuButton, findsOneWidget);

        await tester.tap(menuButton);
        await tester.pumpAndSettle();

        // Assert
        // Меню должно открыться (проверяем наличие PopupMenuEntry)
        expect(find.byType(PopupMenuItem), findsAtLeastNWidgets(1));
      });

      testWidgets('отображает элементы меню', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: const DashboardScreen(),
          ),
        );

        await tester.pumpAndSettle();

        // Act
        await tester.tap(find.byType(PopupMenuButton));
        await tester.pumpAndSettle();

        // Assert
        // Проверяем наличие основных пунктов меню
        expect(find.text('Здоровое меню'), findsOneWidget);
        expect(find.text('Упражнения'), findsOneWidget);
        expect(find.text('Список покупок'), findsOneWidget);
      });

      testWidgets('корректно обрабатывает прокрутку', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: const DashboardScreen(),
          ),
        );

        await tester.pumpAndSettle();

        // Act
        final scrollView = find.byType(SingleChildScrollView);
        expect(scrollView, findsOneWidget);

        await tester.drag(scrollView, const Offset(0, -100));
        await tester.pumpAndSettle();

        // Assert
        // Прокрутка должна работать без ошибок
        expect(find.byType(DashboardScreen), findsOneWidget);
      });
    });

    group('Edge cases и обработка ошибок', () {
      testWidgets('обрабатывает очень длинные имена пользователей', (WidgetTester tester) async {
        // Arrange
        final longName = 'А' * 1000;
        SharedPreferences.setMockInitialValues({
          'userName': longName,
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

      testWidgets('обрабатывает специальные символы в именах', (WidgetTester tester) async {
        // Arrange
        SharedPreferences.setMockInitialValues({
          'userName': 'José-María O\'Connor',
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

      testWidgets('обрабатывает unicode символы', (WidgetTester tester) async {
        // Arrange
        SharedPreferences.setMockInitialValues({
          'userName': 'Анна-Мария Иванова-Петрова',
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

      testWidgets('обрабатывает отсутствующие значения в SharedPreferences', (WidgetTester tester) async {
        // Arrange
        SharedPreferences.setMockInitialValues({
          // Не добавляем 'userName' и 'userEmail' - они будут null
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

    group('Производительность', () {
      testWidgets('загружается в разумное время', (WidgetTester tester) async {
        // Arrange
        final stopwatch = Stopwatch()..start();

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: const DashboardScreen(),
          ),
        );

        await tester.pumpAndSettle();

        stopwatch.stop();

        // Assert
        expect(stopwatch.elapsed.inSeconds, lessThan(5));
        expect(find.byType(DashboardScreen), findsOneWidget);
      });

      testWidgets('корректно обрабатывает множественные rebuild\'ы', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: const DashboardScreen(),
          ),
        );

        await tester.pumpAndSettle();

        // Act
        for (int i = 0; i < 10; i++) {
          await tester.pump();
        }

        // Assert
        expect(find.byType(DashboardScreen), findsOneWidget);
      });
    });

    group('Адаптивность', () {
      testWidgets('адаптируется к разным размерам экрана', (WidgetTester tester) async {
        // Arrange - маленький экран
        await tester.binding.setSurfaceSize(const Size(320, 480));

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: const DashboardScreen(),
          ),
        );

        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(DashboardScreen), findsOneWidget);

        // Arrange - большой экран
        await tester.binding.setSurfaceSize(const Size(1024, 768));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(DashboardScreen), findsOneWidget);

        // Cleanup
        await tester.binding.setSurfaceSize(null);
      });
    });
  });
}
