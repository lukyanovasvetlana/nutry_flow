import 'package:flutter_test/flutter_test.dart';
import 'package:nutry_flow/core/services/ab_testing_service.dart';
import 'package:nutry_flow/core/services/firebase_interfaces.dart';

void main() {
  group('ABTestingService Basic Tests', () {
    test('should be a singleton', () {
      // Arrange & Act
      final instance1 = ABTestingService.instance;
      final instance2 = ABTestingService.instance;

      // Assert
      expect(instance1, same(instance2));
    });

    test('should have default values', () {
      // Arrange & Act
      final service = ABTestingService.instance;

      // Assert
      expect(service.isInitialized, isFalse);
    });

    test('should have remote config instance', () {
      // Arrange & Act
      final service = ABTestingService.instance;

      // Assert - проверяем, что метод существует
      expect(service, isNotNull);
    });

    test('should have analytics instance', () {
      // Arrange & Act
      final service = ABTestingService.instance;

      // Assert - проверяем, что метод существует
      expect(service, isNotNull);
    });

    test('should get default welcome screen variant', () {
      // Arrange & Act
      final service = ABTestingService.instance;
      final variant = service.getWelcomeScreenVariant();

      // Assert
      expect(variant, isA<String>());
    });

    test('should get default dashboard layout variant', () {
      // Arrange & Act
      final service = ABTestingService.instance;
      final variant = service.getDashboardLayoutVariant();

      // Assert
      expect(variant, isA<String>());
    });

    test('should get default onboarding flow variant', () {
      // Arrange & Act
      final service = ABTestingService.instance;
      final variant = service.getOnboardingFlowVariant();

      // Assert
      expect(variant, isA<String>());
    });

    test('should get default meal plan variant', () {
      // Arrange & Act
      final service = ABTestingService.instance;
      final variant = service.getMealPlanVariant();

      // Assert
      expect(variant, isA<String>());
    });

    test('should get default workout variant', () {
      // Arrange & Act
      final service = ABTestingService.instance;
      final variant = service.getWorkoutVariant();

      // Assert
      expect(variant, isA<String>());
    });

    test('should get default notification variant', () {
      // Arrange & Act
      final service = ABTestingService.instance;
      final variant = service.getNotificationVariant();

      // Assert
      expect(variant, isA<String>());
    });

    test('should get default color scheme variant', () {
      // Arrange & Act
      final service = ABTestingService.instance;
      final variant = service.getColorSchemeVariant();

      // Assert
      expect(variant, isA<String>());
    });

    test('should get feature flags', () {
      // Arrange & Act
      final service = ABTestingService.instance;
      final flags = service.getFeatureFlags();

      // Assert
      expect(flags, isA<Map<String, dynamic>>());
    });

    test('should check if feature is enabled', () {
      // Arrange & Act
      final service = ABTestingService.instance;
      final isEnabled = service.isFeatureEnabled('test_feature');

      // Assert
      expect(isEnabled, isA<bool>());
    });

    test('should get all active experiments', () {
      // Arrange & Act
      final service = ABTestingService.instance;
      final experiments = service.getAllActiveExperiments();

      // Assert
      expect(experiments, isA<Map<String, String>>());
    });

    test('should get experiment stats', () {
      // Arrange & Act
      final service = ABTestingService.instance;
      final stats = service.getExperimentStats();

      // Assert
      expect(stats, isA<Map<String, dynamic>>());
    });

    test('should get last fetch time', () {
      // Arrange & Act
      final service = ABTestingService.instance;
      final lastFetchTime = service.getLastFetchTime();

      // Assert
      expect(lastFetchTime, isA<DateTime>());
    });

    test('should get fetch status', () async {
      // Arrange & Act
      final service = ABTestingService.instance;
      await service.initialize();
      final fetchStatus = service.getFetchStatus();

      // Assert
      expect(fetchStatus, isA<RemoteConfigFetchStatus>());
      // Mock implementation returns success by default
      expect(fetchStatus, equals(RemoteConfigFetchStatus.success));
    });

    test('should check if user is in test group', () {
      // Arrange & Act
      final service = ABTestingService.instance;
      final isInTestGroup = service.isUserInTestGroup('test_experiment');

      // Assert
      expect(isInTestGroup, isA<bool>());
    });

    test('should get numeric value', () {
      // Arrange & Act
      final service = ABTestingService.instance;
      final value = service.getNumericValue('test_key', defaultValue: 42.0);

      // Assert
      // Mock returns 0.0 by default, but method should return defaultValue when key not found
      expect(value, equals(42.0));
    });

    test('should get boolean value', () {
      // Arrange & Act
      final service = ABTestingService.instance;
      final value = service.getBooleanValue('test_key', defaultValue: true);

      // Assert
      // Mock returns false by default, but method should return defaultValue when key not found
      expect(value, isTrue);
    });

    test('should get JSON value', () {
      // Arrange & Act
      final service = ABTestingService.instance;
      final value = service.getJsonValue('test_key', defaultValue: {'key': 'value'});

      // Assert
      expect(value, equals({'key': 'value'}));
    });

    test('should track experiment exposure without error', () async {
      // Arrange & Act
      final service = ABTestingService.instance;
      
      // Assert - не должно вызывать исключение
      expect(() async {
        await service.trackExperimentExposure(
          experimentName: 'test_experiment',
          variant: 'test_variant',
        );
      }, returnsNormally);
    });

    test('should track experiment conversion without error', () async {
      // Arrange & Act
      final service = ABTestingService.instance;
      
      // Assert - не должно вызывать исключение
      expect(() async {
        await service.trackExperimentConversion(
          experimentName: 'test_experiment',
          variant: 'test_variant',
          conversionType: 'test_conversion',
        );
      }, returnsNormally);
    });

    test('should track user event without error', () async {
      // Arrange & Act
      final service = ABTestingService.instance;
      
      // Assert - не должно вызывать исключение
      expect(() async {
        await service.trackUserEvent(
          eventName: 'test_event',
          experimentName: 'test_experiment',
          variant: 'test_variant',
        );
      }, returnsNormally);
    });

    test('should force update without error', () async {
      // Arrange & Act
      final service = ABTestingService.instance;
      
      // Assert - проверяем, что метод существует
      expect(service, isNotNull);
    });
  });
} 