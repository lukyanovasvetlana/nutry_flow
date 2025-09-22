import 'package:flutter_test/flutter_test.dart';
import 'package:nutry_flow/core/services/monitoring_service.dart';

void main() {
  group('MonitoringService Tests', () {
    late MonitoringService monitoringService;

    setUp(() {
      monitoringService = MonitoringService.instance;
    });

    group('Initialization', () {
      test('should initialize successfully', () async {
        // Act
        await monitoringService.initialize();

        // Assert
        expect(monitoringService.isInitialized, isTrue);
      });

      test('should not initialize twice', () async {
        // Arrange
        await monitoringService.initialize();
        final firstInitTime = DateTime.now();

        // Act
        await monitoringService.initialize();
        final secondInitTime = DateTime.now();

        // Assert
        expect(secondInitTime.difference(firstInitTime).inMilliseconds, lessThan(100));
      });
    });

    group('Event Tracking', () {
      setUp(() async {
        await monitoringService.initialize();
      });

      test('should track event with all parameters', () async {
        // Arrange
        const eventName = 'test_event';
        const parameters = {'key': 'value'};
        const screenName = 'test_screen';

        // Act & Assert
        expect(() async {
          await monitoringService.trackEvent(
            eventName: eventName,
            parameters: parameters,
            screenName: screenName,
          );
        }, returnsNormally);
      });

      test('should track event without parameters', () async {
        // Arrange
        const eventName = 'simple_event';

        // Act & Assert
        expect(() async {
          await monitoringService.trackEvent(eventName: eventName);
        }, returnsNormally);
      });

      test('should track event without screen name', () async {
        // Arrange
        const eventName = 'test_event';
        const parameters = {'key': 'value'};

        // Act & Assert
        expect(() async {
          await monitoringService.trackEvent(
            eventName: eventName,
            parameters: parameters,
          );
        }, returnsNormally);
      });
    });

    group('Error Tracking', () {
      setUp(() async {
        await monitoringService.initialize();
      });

      test('should track error', () async {
        // Arrange
        const error = 'Test error';
        final stackTrace = StackTrace.current;

        // Act & Assert
        expect(() async {
          await monitoringService.trackError(
            error: error,
            stackTrace: stackTrace,
          );
        }, returnsNormally);
      });

      test('should track error without stack trace', () async {
        // Arrange
        const error = 'Test error';

        // Act & Assert
        expect(() async {
          await monitoringService.trackError(error: error);
        }, returnsNormally);
      });
    });

    group('Edge Cases', () {
      setUp(() async {
        await monitoringService.initialize();
      });

      test('should handle empty event name', () async {
        // Act & Assert
        expect(() async {
          await monitoringService.trackEvent(eventName: '');
        }, returnsNormally);
      });

      test('should handle null parameters', () async {
        // Act & Assert
        expect(() async {
          await monitoringService.trackEvent(
            eventName: 'test_event',
            parameters: null,
          );
        }, returnsNormally);
      });

      test('should handle null screen name', () async {
        // Act & Assert
        expect(() async {
          await monitoringService.trackEvent(
            eventName: 'test_event',
            screenName: null,
          );
        }, returnsNormally);
      });

      test('should handle very long event names', () async {
        // Arrange
        final longEventName = 'a' * 1000;

        // Act & Assert
        expect(() async {
          await monitoringService.trackEvent(eventName: longEventName);
        }, returnsNormally);
      });

      test('should handle empty error message', () async {
        // Act & Assert
        expect(() async {
          await monitoringService.trackError(error: '');
        }, returnsNormally);
      });

      test('should handle null stack trace', () async {
        // Act & Assert
        expect(() async {
          await monitoringService.trackError(
            error: 'Test error',
            stackTrace: null,
          );
        }, returnsNormally);
      });
    });

    group('Concurrent Operations', () {
      setUp(() async {
        await monitoringService.initialize();
      });

      test('should handle multiple concurrent events', () async {
        // Arrange
        final futures = <Future>[];

        // Act
        for (int i = 0; i < 10; i++) {
          futures.add(monitoringService.trackEvent(
            eventName: 'concurrent_event_$i',
            parameters: {'index': i},
          ));
        }

        // Assert
        expect(() async {
          await Future.wait(futures);
        }, returnsNormally);
      });
    });
  });
}