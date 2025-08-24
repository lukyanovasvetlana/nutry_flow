import 'package:flutter_test/flutter_test.dart';
import 'package:nutry_flow/core/services/analytics_service.dart';
import 'package:nutry_flow/core/services/firebase_service.dart';
import 'package:nutry_flow/features/analytics/presentation/utils/analytics_utils.dart';

void main() {
  group('Analytics Integration Tests', () {
    test('AnalyticsService should be initialized', () async {
      // Проверяем, что AnalyticsService доступен
      expect(AnalyticsService.instance, isNotNull);
    });

    test('AnalyticsUtils constants should be defined', () {
      // Проверяем константы экранов
      expect(AnalyticsUtils.screenDashboard, equals('dashboard'));
      expect(AnalyticsUtils.screenLogin, equals('login'));
      expect(AnalyticsUtils.screenRegistration, equals('registration'));
      
      // Проверяем константы типов элементов
      expect(AnalyticsUtils.elementTypeButton, equals('button'));
      expect(AnalyticsUtils.elementTypeInput, equals('input'));
      expect(AnalyticsUtils.elementTypeList, equals('list'));
      
      // Проверяем константы действий
      expect(AnalyticsUtils.actionTap, equals('tap'));
      expect(AnalyticsUtils.actionSelect, equals('select'));
      expect(AnalyticsUtils.actionSwipe, equals('swipe'));
    });

    test('AnalyticsUtils methods should work without errors', () {
      // Проверяем, что методы не выбрасывают исключения
      expect(() {
        AnalyticsUtils.trackButtonTap('test_button');
      }, returnsNormally);
      
      expect(() {
        AnalyticsUtils.trackNavigation(
          fromScreen: 'test_screen',
          toScreen: 'another_screen',
        );
      }, returnsNormally);
      
      expect(() {
        AnalyticsUtils.trackError(
          errorType: 'test_error',
          errorMessage: 'Test error message',
        );
      }, returnsNormally);
    });

    test('AnalyticsUtils should track performance metrics', () {
      expect(() {
        AnalyticsUtils.trackPerformance(
          metricName: 'test_metric',
          value: 100.0,
          unit: 'ms',
        );
      }, returnsNormally);
      
      expect(() {
        AnalyticsUtils.trackScreenLoadTime('test_screen', Duration(milliseconds: 500));
      }, returnsNormally);
    });

    test('AnalyticsUtils should track business events', () {
      expect(() {
        AnalyticsUtils.trackGoalAchievement(
          goalName: 'test_goal',
          goalType: 'fitness',
          progress: 75.0,
        );
      }, returnsNormally);
      
      expect(() {
        AnalyticsUtils.trackWorkout(
          workoutType: 'cardio',
          durationMinutes: 30,
          caloriesBurned: 200,
        );
      }, returnsNormally);
      
      expect(() {
        AnalyticsUtils.trackMeal(
          mealType: 'breakfast',
          calories: 400,
          protein: 20.0,
          fat: 15.0,
          carbs: 45.0,
        );
      }, returnsNormally);
    });

    test('AnalyticsUtils should track user interactions', () {
      expect(() {
        AnalyticsUtils.trackUIInteraction(
          elementType: 'button',
          elementName: 'test_button',
          action: 'tap',
        );
      }, returnsNormally);
      
      expect(() {
        AnalyticsUtils.trackSearch('test search term');
      }, returnsNormally);
      
      expect(() {
        AnalyticsUtils.trackSelectContent(
          contentType: 'article',
          itemId: 'test_article_123',
        );
      }, returnsNormally);
    });

    test('AnalyticsUtils should track authentication events', () {
      expect(() {
        AnalyticsUtils.trackLogin(
          method: 'email',
          userId: 'test_user_123',
        );
      }, returnsNormally);
      
      expect(() {
        AnalyticsUtils.trackSignUp(
          method: 'email',
          userId: 'new_user_456',
        );
      }, returnsNormally);
    });

    test('AnalyticsUtils should handle additional data', () {
      expect(() {
        AnalyticsUtils.trackButtonTap(
          'test_button',
          parameters: {
            'screen': 'test_screen',
            'user_type': 'premium',
          },
        );
      }, returnsNormally);
      
      expect(() {
        AnalyticsUtils.trackNavigation(
          fromScreen: 'test_screen',
          toScreen: 'another_screen',
          additionalData: {
            'navigation_method': 'button_tap',
            'user_action': 'intentional',
          },
        );
      }, returnsNormally);
    });

    test('AnalyticsUtils should track errors with context', () {
      expect(() {
        AnalyticsUtils.trackError(
          errorType: 'api_error',
          errorMessage: 'Network timeout',
          screenName: 'test_screen',
          additionalData: {
            'endpoint': '/api/test',
            'retry_count': 3,
          },
        );
      }, returnsNormally);
    });

    test('AnalyticsUtils should track performance with context', () {
      expect(() {
        AnalyticsUtils.trackPerformance(
          metricName: 'api_response_time',
          value: 250.0,
          unit: 'ms',
          additionalData: {
            'endpoint': '/api/data',
            'cache_hit': false,
            'user_id': 'test_user',
          },
        );
      }, returnsNormally);
    });
  });
}
