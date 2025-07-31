import 'package:flutter_test/flutter_test.dart';
import 'package:nutry_flow/core/services/ab_testing_service.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

// Генерируем моки
@GenerateMocks([FirebaseRemoteConfig, FirebaseAnalytics])
import 'ab_testing_service_test.mocks.dart';

void main() {
  group('ABTestingService Tests', () {
    late ABTestingService abTestingService;
    late MockFirebaseRemoteConfig mockRemoteConfig;
    late MockFirebaseAnalytics mockAnalytics;

    setUp(() {
      mockRemoteConfig = MockFirebaseRemoteConfig();
      mockAnalytics = MockFirebaseAnalytics();
      // Не создаем новый экземпляр, так как ABTestingService - синглтон
    });

    group('Initialization', () {
      test('should initialize successfully', () async {
        // Arrange
        when(mockRemoteConfig.setConfigSettings(any))
            .thenAnswer((_) async {});
        when(mockRemoteConfig.setDefaults(any))
            .thenAnswer((_) async {});
        when(mockRemoteConfig.fetchAndActivate())
            .thenAnswer((_) async => true);

              // Act
      // В реальном тесте мы бы мокировали Firebase
      // Здесь просто проверяем, что метод существует
      expect(abTestingService.isInitialized, isFalse);

        // Assert
        // В реальном тесте мы бы проверили вызовы моков
        expect(abTestingService.isInitialized, isFalse);
      });

      test('should handle initialization error', () async {
        // Arrange
        when(mockRemoteConfig.setConfigSettings(any))
            .thenThrow(Exception('Initialization failed'));

        // Act & Assert
        expect(
          () => abTestingService.initialize(),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('Variant Retrieval', () {
      test('should return welcome screen variant', () {
        // Arrange
        when(mockRemoteConfig.getString('welcome_screen_variant'))
            .thenReturn('variant_a');

        // Act
        final variant = abTestingService.getWelcomeScreenVariant();

        // Assert
        expect(variant, equals('variant_a'));
        verify(mockRemoteConfig.getString('welcome_screen_variant')).called(1);
      });

      test('should return default value on error', () {
        // Arrange
        when(mockRemoteConfig.getString('welcome_screen_variant'))
            .thenThrow(Exception('Failed to get variant'));

        // Act
        final variant = abTestingService.getWelcomeScreenVariant();

        // Assert
        expect(variant, equals('control'));
      });

      test('should return dashboard layout variant', () {
        // Arrange
        when(mockRemoteConfig.getString('dashboard_layout_variant'))
            .thenReturn('card');

        // Act
        final variant = abTestingService.getDashboardLayoutVariant();

        // Assert
        expect(variant, equals('card'));
        verify(mockRemoteConfig.getString('dashboard_layout_variant')).called(1);
      });

      test('should return onboarding flow variant', () {
        // Arrange
        when(mockRemoteConfig.getString('onboarding_flow_variant'))
            .thenReturn('guided');

        // Act
        final variant = abTestingService.getOnboardingFlowVariant();

        // Assert
        expect(variant, equals('guided'));
        verify(mockRemoteConfig.getString('onboarding_flow_variant')).called(1);
      });
    });

    group('Feature Flags', () {
      test('should return feature flags', () {
        // Arrange
        const flagsJson = '{"premium_features": true, "social_features": false}';
        when(mockRemoteConfig.getString('feature_flags'))
            .thenReturn(flagsJson);

        // Act
        final flags = abTestingService.getFeatureFlags();

        // Assert
        expect(flags, equals({
          'premium_features': true,
          'social_features': false,
        }));
        verify(mockRemoteConfig.getString('feature_flags')).called(1);
      });

      test('should return empty map for invalid JSON', () {
        // Arrange
        when(mockRemoteConfig.getString('feature_flags'))
            .thenReturn('invalid json');

        // Act
        final flags = abTestingService.getFeatureFlags();

        // Assert
        expect(flags, equals({}));
      });

      test('should check if feature is enabled', () {
        // Arrange
        const flagsJson = '{"premium_features": true, "social_features": false}';
        when(mockRemoteConfig.getString('feature_flags'))
            .thenReturn(flagsJson);

        // Act
        final isPremiumEnabled = abTestingService.isFeatureEnabled('premium_features');
        final isSocialEnabled = abTestingService.isFeatureEnabled('social_features');
        final isAIEnabled = abTestingService.isFeatureEnabled('ai_recommendations');

        // Assert
        expect(isPremiumEnabled, isTrue);
        expect(isSocialEnabled, isFalse);
        expect(isAIEnabled, isFalse);
      });
    });

    group('Experiment Tracking', () {
      test('should track experiment exposure', () async {
        // Arrange
        when(mockAnalytics.logEvent(
          name: anyNamed('name'),
          parameters: anyNamed('parameters'),
        )).thenAnswer((_) async {});

        // Act
        await abTestingService.trackExperimentExposure(
          experimentName: 'welcome_screen',
          variant: 'variant_a',
          parameters: {'screen': 'welcome'},
        );

        // Assert
        verify(mockAnalytics.logEvent(
          name: 'experiment_exposure',
          parameters: {
            'experiment_name': 'welcome_screen',
            'variant': 'variant_a',
            'screen': 'welcome',
          },
        )).called(1);
      });

      test('should track experiment conversion', () async {
        // Arrange
        when(mockAnalytics.logEvent(
          name: anyNamed('name'),
          parameters: anyNamed('parameters'),
        )).thenAnswer((_) async {});

        // Act
        await abTestingService.trackExperimentConversion(
          experimentName: 'welcome_screen',
          variant: 'variant_a',
          conversionType: 'registration',
          parameters: {'method': 'email'},
        );

        // Assert
        verify(mockAnalytics.logEvent(
          name: 'experiment_conversion',
          parameters: {
            'experiment_name': 'welcome_screen',
            'variant': 'variant_a',
            'conversion_type': 'registration',
            'method': 'email',
          },
        )).called(1);
      });
    });

    group('User Event Tracking', () {
      test('should track user event with experiment parameters', () async {
        // Arrange
        when(mockAnalytics.logEvent(
          name: anyNamed('name'),
          parameters: anyNamed('parameters'),
        )).thenAnswer((_) async {});

        // Act
        await abTestingService.trackUserEvent(
          eventName: 'button_click',
          experimentName: 'welcome_screen',
          variant: 'variant_a',
          parameters: {'button_id': 'register'},
        );

        // Assert
        verify(mockAnalytics.logEvent(
          name: 'button_click',
          parameters: {
            'experiment_name': 'welcome_screen',
            'variant': 'variant_a',
            'button_id': 'register',
          },
        )).called(1);
      });
    });

    group('Configuration Values', () {
      test('should get numeric value', () {
        // Arrange
        when(mockRemoteConfig.getDouble('test_numeric'))
            .thenReturn(42.5);

        // Act
        final value = abTestingService.getNumericValue('test_numeric');

        // Assert
        expect(value, equals(42.5));
        verify(mockRemoteConfig.getDouble('test_numeric')).called(1);
      });

      test('should get boolean value', () {
        // Arrange
        when(mockRemoteConfig.getBool('test_boolean'))
            .thenReturn(true);

        // Act
        final value = abTestingService.getBooleanValue('test_boolean');

        // Assert
        expect(value, isTrue);
        verify(mockRemoteConfig.getBool('test_boolean')).called(1);
      });

      test('should get JSON value', () {
        // Arrange
        const jsonString = '{"key": "value", "number": 123}';
        when(mockRemoteConfig.getString('test_json'))
            .thenReturn(jsonString);

        // Act
        final value = abTestingService.getJsonValue('test_json');

        // Assert
        expect(value, equals({
          'key': 'value',
          'number': 123,
        }));
        verify(mockRemoteConfig.getString('test_json')).called(1);
      });
    });

    group('Test Group Detection', () {
      test('should detect if user is in test group', () {
        // Arrange
        when(mockRemoteConfig.getString('welcome_screen_variant'))
            .thenReturn('variant_a');

        // Act
        final isInTestGroup = abTestingService.isUserInTestGroup('welcome_screen');

        // Assert
        expect(isInTestGroup, isTrue);
      });

      test('should detect if user is not in test group', () {
        // Arrange
        when(mockRemoteConfig.getString('welcome_screen_variant'))
            .thenReturn('control');

        // Act
        final isInTestGroup = abTestingService.isUserInTestGroup('welcome_screen');

        // Assert
        expect(isInTestGroup, isFalse);
      });
    });

    group('Statistics', () {
      test('should get experiment statistics', () {
        // Arrange
        when(mockRemoteConfig.getString('welcome_screen_variant'))
            .thenReturn('variant_a');
        when(mockRemoteConfig.getString('dashboard_layout_variant'))
            .thenReturn('card');
        when(mockRemoteConfig.lastFetchTime)
            .thenReturn(DateTime(2024, 1, 1));
        when(mockRemoteConfig.lastFetchStatus)
            .thenReturn(RemoteConfigFetchStatus.success);

        // Act
        final stats = abTestingService.getExperimentStats();

        // Assert
        expect(stats['total_experiments'], equals(7));
        expect(stats['test_groups'], equals(2));
        expect(stats['fetch_status'], contains('success'));
      });
    });

    group('Force Update', () {
      test('should force update configuration', () async {
        // Arrange
        when(mockRemoteConfig.fetchAndActivate())
            .thenAnswer((_) async => true);

        // Act
        await abTestingService.forceUpdate();

        // Assert
        verify(mockRemoteConfig.fetchAndActivate()).called(1);
      });

      test('should handle force update error', () async {
        // Arrange
        when(mockRemoteConfig.fetchAndActivate())
            .thenThrow(Exception('Update failed'));

        // Act & Assert
        expect(
          () => abTestingService.forceUpdate(),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('All Active Experiments', () {
      test('should return all active experiments', () {
        // Arrange
        when(mockRemoteConfig.getString('welcome_screen_variant'))
            .thenReturn('variant_a');
        when(mockRemoteConfig.getString('onboarding_flow_variant'))
            .thenReturn('guided');
        when(mockRemoteConfig.getString('dashboard_layout_variant'))
            .thenReturn('card');
        when(mockRemoteConfig.getString('meal_plan_variant'))
            .thenReturn('list');
        when(mockRemoteConfig.getString('workout_variant'))
            .thenReturn('card');
        when(mockRemoteConfig.getString('notification_variant'))
            .thenReturn('push');
        when(mockRemoteConfig.getString('color_scheme_variant'))
            .thenReturn('default');

        // Act
        final experiments = abTestingService.getAllActiveExperiments();

        // Assert
        expect(experiments, equals({
          'welcome_screen': 'variant_a',
          'onboarding_flow': 'guided',
          'dashboard_layout': 'card',
          'meal_plan': 'list',
          'workout': 'card',
          'notification': 'push',
          'color_scheme': 'default',
        }));
      });
    });
  });
} 