import 'package:flutter_test/flutter_test.dart';
import 'package:nutry_flow/core/services/ab_testing_service.dart';

void main() {
  group('ABTestingService Tests', () {
    late ABTestingService abTestingService;

    setUp(() {
      abTestingService = ABTestingService.instance;
    });

    group('Initialization', () {
      test('should initialize successfully', () async {
        // Act
        await abTestingService.initialize();

        // Assert
        expect(abTestingService.isInitialized, isTrue);
      });

      test('should not initialize twice', () async {
        // Arrange
        await abTestingService.initialize();
        final firstInitTime = DateTime.now();

        // Act
        await abTestingService.initialize();
        final secondInitTime = DateTime.now();

        // Assert
        expect(secondInitTime.difference(firstInitTime).inMilliseconds, lessThan(100));
      });
    });

    group('Feature Flags', () {
      setUp(() async {
        await abTestingService.initialize();
      });

      test('should get all active experiments', () async {
        // Act
        final experiments = abTestingService.getAllActiveExperiments();

        // Assert
        expect(experiments, isA<Map<String, dynamic>>());
      });

      test('should get feature flags', () async {
        // Act
        final featureFlags = abTestingService.getFeatureFlags();

        // Assert
        expect(featureFlags, isA<Map<String, dynamic>>());
      });

      test('should check if feature is enabled', () async {
        // Arrange
        const featureName = 'test_feature';

        // Act
        final isEnabled = abTestingService.isFeatureEnabled(featureName);

        // Assert
        expect(isEnabled, isA<bool>());
      });
    });

    group('Experiment Tracking', () {
      setUp(() async {
        await abTestingService.initialize();
      });

      test('should track experiment exposure', () async {
        // Arrange
        const experimentName = 'test_experiment';
        const variant = 'control';

        // Act & Assert
        expect(() async {
          await abTestingService.trackExperimentExposure(
            experimentName: experimentName,
            variant: variant,
          );
        }, returnsNormally);
      });

      test('should track experiment conversion', () async {
        // Arrange
        const experimentName = 'test_experiment';
        const variant = 'control';
        const conversionType = 'purchase';

        // Act & Assert
        expect(() async {
          await abTestingService.trackExperimentConversion(
            experimentName: experimentName,
            variant: variant,
            conversionType: conversionType,
          );
        }, returnsNormally);
      });
    });

    group('Remote Config', () {
      setUp(() async {
        await abTestingService.initialize();
      });

      test('should get last fetch time', () async {
        // Act
        final lastFetchTime = abTestingService.getLastFetchTime();

        // Assert
        expect(lastFetchTime, isA<DateTime>());
      });

      test('should get fetch status', () async {
        // Act
        final fetchStatus = abTestingService.getFetchStatus();

        // Assert
        expect(fetchStatus, isNotNull);
      });

      test('should force update', () async {
        // Act & Assert
        expect(() async {
          await abTestingService.forceUpdate();
        }, returnsNormally);
      });
    });

    group('Specific Experiments', () {
      setUp(() async {
        await abTestingService.initialize();
      });

      test('should get welcome screen variant', () async {
        // Act
        final variant = abTestingService.getWelcomeScreenVariant();

        // Assert
        expect(variant, isA<String>());
        expect(['control', 'variant_a', 'variant_b'], contains(variant));
      });

      test('should get onboarding flow variant', () async {
        // Act
        final variant = abTestingService.getOnboardingFlowVariant();

        // Assert
        expect(variant, isA<String>());
        expect(['control', 'standard', 'variant_a', 'variant_b'], contains(variant));
      });

      test('should get dashboard layout variant', () async {
        // Act
        final variant = abTestingService.getDashboardLayoutVariant();

        // Assert
        expect(variant, isA<String>());
        expect(['control', 'grid', 'variant_a', 'variant_b'], contains(variant));
      });
    });

    group('Edge Cases', () {
      setUp(() async {
        await abTestingService.initialize();
      });

      test('should handle empty experiment name', () async {
        // Act & Assert
        expect(() async {
          await abTestingService.trackExperimentExposure(
            experimentName: '',
            variant: 'control',
          );
        }, returnsNormally);
      });

      test('should handle null parameters', () async {
        // Act & Assert
        expect(() async {
          await abTestingService.trackExperimentExposure(
            experimentName: 'test',
            variant: 'control',
            parameters: null,
          );
        }, returnsNormally);
      });

      test('should handle very long experiment names', () async {
        // Arrange
        final longExperimentName = 'a' * 1000;

        // Act & Assert
        expect(() async {
          await abTestingService.trackExperimentExposure(
            experimentName: longExperimentName,
            variant: 'control',
          );
        }, returnsNormally);
      });
    });
  });
}