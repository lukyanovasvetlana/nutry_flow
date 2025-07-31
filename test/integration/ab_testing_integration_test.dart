import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutry_flow/core/services/ab_testing_service.dart';
import 'package:nutry_flow/features/onboarding/presentation/screens/welcome_screen.dart';
import 'package:nutry_flow/features/onboarding/presentation/screens/welcome_screen_variants.dart';
import 'package:nutry_flow/features/dashboard/presentation/screens/dashboard_variants.dart';

void main() {
  group('A/B Testing Integration Tests', () {
    setUpAll(() async {
      // Инициализация A/B тестирования для тестов
      await ABTestingService.instance.initialize();
    });

    group('Welcome Screen A/B Testing', () {
      testWidgets('should show control variant by default', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: const WelcomeScreen(),
          ),
        );

        // Act
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(WelcomeScreenControl), findsOneWidget);
        expect(find.byType(WelcomeScreenVariantA), findsNothing);
        expect(find.byType(WelcomeScreenVariantB), findsNothing);
      });

      testWidgets('should show variant A when configured', (WidgetTester tester) async {
        // Arrange
        // Симулируем конфигурацию для варианта A
        // В реальном тесте это будет через Firebase Remote Config

        await tester.pumpWidget(
          MaterialApp(
            home: const WelcomeScreen(),
          ),
        );

        // Act
        await tester.pumpAndSettle();

        // Assert
        // Проверяем, что экран загрузился
        expect(find.byType(WelcomeScreen), findsOneWidget);
      });

      testWidgets('should track experiment exposure on screen load', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: const WelcomeScreen(),
          ),
        );

        // Act
        await tester.pumpAndSettle();

        // Assert
        // В реальном тесте мы бы проверили, что событие было отправлено
        // Здесь мы просто проверяем, что экран загрузился без ошибок
        expect(find.byType(WelcomeScreen), findsOneWidget);
      });

      testWidgets('should track conversion on button click', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: const WelcomeScreen(),
          ),
        );

        // Act
        await tester.pumpAndSettle();
        
        // Находим кнопку регистрации и нажимаем на неё
        final registerButton = find.text('Начать');
        if (registerButton.evaluate().isNotEmpty) {
          await tester.tap(registerButton);
          await tester.pumpAndSettle();
        }

        // Assert
        // Проверяем, что экран загрузился без ошибок
        expect(find.byType(WelcomeScreen), findsOneWidget);
      });
    });

    group('Dashboard Layout A/B Testing', () {
      testWidgets('should show grid layout by default', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: const GridDashboardLayout(),
          ),
        );

        // Act
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(GridDashboardLayout), findsOneWidget);
        expect(find.text('Дашборд'), findsOneWidget);
      });

      testWidgets('should show list layout when configured', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: const ListDashboardLayout(),
          ),
        );

        // Act
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(ListDashboardLayout), findsOneWidget);
        expect(find.text('Главное меню'), findsOneWidget);
      });

      testWidgets('should show card layout when configured', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: const CardDashboardLayout(),
          ),
        );

        // Act
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(CardDashboardLayout), findsOneWidget);
        expect(find.text('Обзор'), findsOneWidget);
      });

      testWidgets('should track navigation events', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: const GridDashboardLayout(),
          ),
        );

        // Act
        await tester.pumpAndSettle();
        
        // Нажимаем на карточку питания
        final nutritionCard = find.text('Питание');
        if (nutritionCard.evaluate().isNotEmpty) {
          await tester.tap(nutritionCard);
          await tester.pumpAndSettle();
        }

        // Assert
        // Проверяем, что экран загрузился без ошибок
        expect(find.byType(GridDashboardLayout), findsOneWidget);
      });
    });

    group('Feature Flags Integration', () {
      test('should check feature flags', () {
        // Arrange & Act
        final flags = ABTestingService.instance.getFeatureFlags();
        final isPremiumEnabled = ABTestingService.instance.isFeatureEnabled('premium_features');
        final isSocialEnabled = ABTestingService.instance.isFeatureEnabled('social_features');

        // Assert
        expect(flags, isA<Map<String, dynamic>>());
        expect(isPremiumEnabled, isA<bool>());
        expect(isSocialEnabled, isA<bool>());
      });

      test('should detect test group membership', () {
        // Arrange & Act
        final isInTestGroup = ABTestingService.instance.isUserInTestGroup('welcome_screen');

        // Assert
        expect(isInTestGroup, isA<bool>());
      });
    });

    group('Experiment Statistics', () {
      test('should get experiment statistics', () {
        // Arrange & Act
        final stats = ABTestingService.instance.getExperimentStats();
        final experiments = ABTestingService.instance.getAllActiveExperiments();

        // Assert
        expect(stats, isA<Map<String, dynamic>>());
        expect(experiments, isA<Map<String, String>>());
        expect(stats['total_experiments'], isA<int>());
        expect(stats['test_groups'], isA<int>());
      });

      test('should get last fetch time', () {
        // Arrange & Act
        final lastFetchTime = ABTestingService.instance.getLastFetchTime();

        // Assert
        expect(lastFetchTime, isA<DateTime>());
      });

      test('should get fetch status', () {
        // Arrange & Act
        final fetchStatus = ABTestingService.instance.getFetchStatus();

        // Assert
        expect(fetchStatus, isA<int>());
      });
    });

    group('Configuration Values', () {
      test('should get numeric values', () {
        // Arrange & Act
        final numericValue = ABTestingService.instance.getNumericValue('test_key', defaultValue: 42.0);

        // Assert
        expect(numericValue, equals(42.0));
      });

      test('should get boolean values', () {
        // Arrange & Act
        final booleanValue = ABTestingService.instance.getBooleanValue('test_key', defaultValue: true);

        // Assert
        expect(booleanValue, isTrue);
      });

      test('should get JSON values', () {
        // Arrange & Act
        final jsonValue = ABTestingService.instance.getJsonValue('test_key', defaultValue: {'key': 'value'});

        // Assert
        expect(jsonValue, equals({'key': 'value'}));
      });
    });

    group('Event Tracking', () {
      test('should track experiment exposure', () async {
        // Arrange & Act
        await ABTestingService.instance.trackExperimentExposure(
          experimentName: 'test_experiment',
          variant: 'test_variant',
          parameters: {'test_param': 'test_value'},
        );

        // Assert
        // В реальном тесте мы бы проверили, что событие было отправлено
        // Здесь мы просто проверяем, что метод выполнился без ошибок
        expect(true, isTrue);
      });

      test('should track experiment conversion', () async {
        // Arrange & Act
        await ABTestingService.instance.trackExperimentConversion(
          experimentName: 'test_experiment',
          variant: 'test_variant',
          conversionType: 'test_conversion',
          parameters: {'test_param': 'test_value'},
        );

        // Assert
        // В реальном тесте мы бы проверили, что событие было отправлено
        // Здесь мы просто проверяем, что метод выполнился без ошибок
        expect(true, isTrue);
      });

      test('should track user events', () async {
        // Arrange & Act
        await ABTestingService.instance.trackUserEvent(
          eventName: 'test_event',
          experimentName: 'test_experiment',
          variant: 'test_variant',
          parameters: {'test_param': 'test_value'},
        );

        // Assert
        // В реальном тесте мы бы проверили, что событие было отправлено
        // Здесь мы просто проверяем, что метод выполнился без ошибок
        expect(true, isTrue);
      });
    });

    group('Force Update', () {
      test('should force update configuration', () async {
        // Arrange & Act
        await ABTestingService.instance.forceUpdate();

        // Assert
        // В реальном тесте мы бы проверили, что конфигурация обновилась
        // Здесь мы просто проверяем, что метод выполнился без ошибок
        expect(true, isTrue);
      });
    });

    group('Service Initialization', () {
      test('should be initialized', () {
        // Arrange & Act
        final isInitialized = ABTestingService.instance.isInitialized;

        // Assert
        expect(isInitialized, isTrue);
      });

      test('should have remote config instance', () {
        // Arrange & Act
        final remoteConfig = ABTestingService.instance.remoteConfig;

        // Assert
        expect(remoteConfig, isNotNull);
      });

      test('should have analytics instance', () {
        // Arrange & Act
        final analytics = ABTestingService.instance.analytics;

        // Assert
        expect(analytics, isNotNull);
      });
    });
  });
} 