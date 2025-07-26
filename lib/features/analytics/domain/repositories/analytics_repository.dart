import '../entities/analytics_event.dart';
import '../entities/analytics_data.dart';

/// Интерфейс репозитория для работы с аналитикой
abstract class AnalyticsRepository {
  /// Отправляет аналитическое событие
  Future<void> trackEvent(AnalyticsEvent event);
  
  /// Отправляет несколько событий одновременно
  Future<void> trackEvents(List<AnalyticsEvent> events);
  
  /// Получает аналитические данные для пользователя за определенный период
  Future<AnalyticsData> getUserAnalytics({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  });
  
  /// Получает аналитические данные за сегодня
  Future<AnalyticsData> getTodayAnalytics(String userId);
  
  /// Получает аналитические данные за неделю
  Future<AnalyticsData> getWeeklyAnalytics(String userId);
  
  /// Получает аналитические данные за месяц
  Future<AnalyticsData> getMonthlyAnalytics(String userId);
  
  /// Сохраняет аналитические данные локально
  Future<void> saveAnalyticsData(AnalyticsData data);
  
  /// Получает сохраненные аналитические данные
  Future<AnalyticsData?> getSavedAnalyticsData(String userId, DateTime date);
  
  /// Очищает старые аналитические данные
  Future<void> clearOldAnalyticsData(int daysToKeep);
  
  /// Инициализирует аналитику
  Future<void> initialize();
  
  /// Устанавливает пользователя для аналитики
  Future<void> setUser(String userId);
  
  /// Сбрасывает пользователя
  Future<void> resetUser();
} 