import 'package:flutter_test/flutter_test.dart';
import 'package:nutry_flow/core/services/analytics_service.dart';

void main() {
  group('AnalyticsService Tests', () {
    late AnalyticsService analyticsService;

    setUp(() {
      analyticsService = AnalyticsService.instance;
    });

    group('Initialization', () {
      test('should initialize successfully', () async {
        // Act
        await analyticsService.initialize();

        // Assert
        expect(analyticsService.isInitialized, isTrue);
      });

      test('should not initialize twice', () async {
        // Arrange
        await analyticsService.initialize();
        final firstInitTime = DateTime.now();

        // Act
        await analyticsService.initialize();
        final secondInitTime = DateTime.now();

        // Assert
        expect(secondInitTime.difference(firstInitTime).inMilliseconds, lessThan(100));
      });
    });

    group('Screen Tracking', () {
      setUp(() async {
        await analyticsService.initialize();
      });

      test('should log screen view', () async {
        // Arrange
        const screenName = 'test_screen';
        const screenClass = 'TestScreen';

        // Act & Assert
        expect(() async {
          await analyticsService.logScreenView(
            screenName: screenName,
            screenClass: screenClass,
          );
        }, returnsNormally);
      });

      test('should log screen view without screen class', () async {
        // Arrange
        const screenName = 'test_screen';

        // Act & Assert
        expect(() async {
          await analyticsService.logScreenView(screenName: screenName);
        }, returnsNormally);
      });
    });

    group('Event Tracking', () {
      setUp(() async {
        await analyticsService.initialize();
      });

      test('should log event', () async {
        // Arrange
        const eventName = 'test_event';
        const parameters = {'value': 'test'};

        // Act & Assert
        expect(() async {
          await analyticsService.logEvent(
            name: eventName,
            parameters: parameters,
          );
        }, returnsNormally);
      });

      test('should log event without parameters', () async {
        // Arrange
        const eventName = 'simple_event';

        // Act & Assert
        expect(() async {
          await analyticsService.logEvent(name: eventName);
        }, returnsNormally);
      });
    });

    group('User Properties', () {
      setUp(() async {
        await analyticsService.initialize();
      });

      test('should set user property', () async {
        // Arrange
        const propertyName = 'test_property';
        const propertyValue = 'test_value';

        // Act & Assert
        expect(() async {
          await analyticsService.setUserProperty(
            name: propertyName,
            value: propertyValue,
          );
        }, returnsNormally);
      });
    });

    group('Authentication Tracking', () {
      setUp(() async {
        await analyticsService.initialize();
      });

      test('should log login', () async {
        // Arrange
        const method = 'email';
        const userId = 'test_user_123';

        // Act & Assert
        expect(() async {
          await analyticsService.logLogin(
            method: method,
            userId: userId,
          );
        }, returnsNormally);
      });

      test('should log sign up', () async {
        // Arrange
        const method = 'email';
        const userId = 'test_user_123';

        // Act & Assert
        expect(() async {
          await analyticsService.logSignUp(
            method: method,
            userId: userId,
          );
        }, returnsNormally);
      });
    });

    group('Edge Cases', () {
      setUp(() async {
        await analyticsService.initialize();
      });

      test('should handle empty event name', () async {
        // Act & Assert
        expect(() async {
          await analyticsService.logEvent(name: '');
        }, returnsNormally);
      });

      test('should handle null parameters', () async {
        // Act & Assert
        expect(() async {
          await analyticsService.logEvent(
            name: 'test_event',
            parameters: null,
          );
        }, returnsNormally);
      });

      test('should handle very long event names', () async {
        // Arrange
        final longEventName = 'a' * 1000;

        // Act & Assert
        expect(() async {
          await analyticsService.logEvent(name: longEventName);
        }, returnsNormally);
      });
    });
  });
}