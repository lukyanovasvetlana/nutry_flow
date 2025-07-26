import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/analytics_event_model.dart';
import '../models/analytics_data_model.dart';

/// Сервис для работы с аналитикой
class AnalyticsService {
  static const String _eventsKey = 'analytics_events';
  static const String _dataKey = 'analytics_data';
  static const String _userIdKey = 'analytics_user_id';
  
  late SharedPreferences _prefs;
  String? _currentUserId;
  final List<AnalyticsEventModel> _pendingEvents = [];

  /// Инициализирует сервис
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    _currentUserId = _prefs.getString(_userIdKey);
  }

  /// Устанавливает пользователя для аналитики
  Future<void> setUser(String userId) async {
    _currentUserId = userId;
    await _prefs.setString(_userIdKey, userId);
  }

  /// Сбрасывает пользователя
  Future<void> resetUser() async {
    _currentUserId = null;
    await _prefs.remove(_userIdKey);
  }

  /// Отправляет событие
  Future<void> trackEvent(AnalyticsEventModel event) async {
    // Добавляем пользователя к событию, если он не установлен
    final eventWithUser = event.userId != null 
        ? event 
        : event.copyWith(userId: _currentUserId);

    // В реальном приложении здесь была бы отправка на сервер
    // Пока сохраняем локально
    await _saveEventLocally(eventWithUser);
    
    // Добавляем в очередь для отправки
    _pendingEvents.add(eventWithUser);
    
    // Логируем событие
    print('🔍 Analytics: ${eventWithUser.name} - ${eventWithUser.parameters}');
  }

  /// Отправляет несколько событий
  Future<void> trackEvents(List<AnalyticsEventModel> events) async {
    for (final event in events) {
      await trackEvent(event);
    }
  }

  /// Сохраняет событие локально
  Future<void> _saveEventLocally(AnalyticsEventModel event) async {
    final eventsJson = _prefs.getStringList(_eventsKey) ?? [];
    eventsJson.add(jsonEncode(event.toJson()));
    
    // Ограничиваем количество сохраненных событий
    if (eventsJson.length > 1000) {
      eventsJson.removeRange(0, eventsJson.length - 1000);
    }
    
    await _prefs.setStringList(_eventsKey, eventsJson);
  }

  /// Получает события из локального хранилища
  List<AnalyticsEventModel> _getLocalEvents() {
    final eventsJson = _prefs.getStringList(_eventsKey) ?? [];
    return eventsJson
        .map((json) => AnalyticsEventModel.fromJson(jsonDecode(json)))
        .toList();
  }

  /// Получает аналитические данные за сегодня
  Future<AnalyticsDataModel> getTodayAnalytics(String userId) async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    
    return getAnalyticsForPeriod(userId, startOfDay, endOfDay);
  }

  /// Получает аналитические данные за неделю
  Future<AnalyticsDataModel> getWeeklyAnalytics(String userId) async {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final startOfWeekDay = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
    final endOfWeek = startOfWeekDay.add(const Duration(days: 7));
    
    return getAnalyticsForPeriod(userId, startOfWeekDay, endOfWeek);
  }

  /// Получает аналитические данные за месяц
  Future<AnalyticsDataModel> getMonthlyAnalytics(String userId) async {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 1);
    
    return getAnalyticsForPeriod(userId, startOfMonth, endOfMonth);
  }

  /// Получает аналитические данные за период
  Future<AnalyticsDataModel> getAnalyticsForPeriod(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final events = _getLocalEvents()
        .where((event) => 
            event.userId == userId &&
            event.timestamp.isAfter(startDate) &&
            event.timestamp.isBefore(endDate))
        .toList();

    // Группируем события по дням
    final eventsByDay = <DateTime, List<AnalyticsEventModel>>{};
    for (final event in events) {
      final day = DateTime(
        event.timestamp.year,
        event.timestamp.month,
        event.timestamp.day,
      );
      eventsByDay.putIfAbsent(day, () => []).add(event);
    }

    // Создаем аналитические данные
    final analyticsData = AnalyticsDataModel(
      userId: userId,
      date: startDate,
      events: events,
    );

    // Добавляем метрики
    var updatedData = analyticsData;
    
    // Общее количество калорий
    final totalCalories = events
        .where((event) => event.name == 'food_added')
        .fold(0.0, (sum, event) => sum + (event.parameters['calories'] as double? ?? 0.0));
    updatedData = updatedData.addMetric('total_calories', totalCalories);

    // Сожженные калории
    final burnedCalories = events
        .where((event) => event.name == 'workout_completed')
        .fold(0, (sum, event) => sum + (event.parameters['calories_burned'] as int? ?? 0));
    updatedData = updatedData.addMetric('burned_calories', burnedCalories);

    // Количество тренировок
    final workoutCount = events.where((event) => event.name == 'workout_completed').length;
    updatedData = updatedData.addMetric('workout_count', workoutCount);

    // Общее время тренировок
    final totalWorkoutTime = events
        .where((event) => event.name == 'workout_completed')
        .fold(0, (sum, event) => sum + (event.parameters['duration_seconds'] as int? ?? 0));
    updatedData = updatedData.addMetric('total_workout_time', totalWorkoutTime);

    // Количество приемов пищи
    final mealCount = events.where((event) => event.name == 'food_added').length;
    updatedData = updatedData.addMetric('meal_count', mealCount);

    return updatedData as AnalyticsDataModel;
  }

  /// Сохраняет аналитические данные
  Future<void> saveAnalyticsData(AnalyticsDataModel data) async {
    final key = '${_dataKey}_${data.userId}_${data.date.toIso8601String().split('T')[0]}';
    await _prefs.setString(key, jsonEncode(data.toJson()));
  }

  /// Получает сохраненные аналитические данные
  Future<AnalyticsDataModel?> getSavedAnalyticsData(String userId, DateTime date) async {
    final key = '${_dataKey}_${userId}_${date.toIso8601String().split('T')[0]}';
    final json = _prefs.getString(key);
    
    if (json != null) {
      return AnalyticsDataModel.fromJson(jsonDecode(json));
    }
    
    return null;
  }

  /// Очищает старые аналитические данные
  Future<void> clearOldAnalyticsData(int daysToKeep) async {
    final cutoffDate = DateTime.now().subtract(Duration(days: daysToKeep));
    final events = _getLocalEvents();
    
    final filteredEvents = events
        .where((event) => event.timestamp.isAfter(cutoffDate))
        .toList();

    final eventsJson = filteredEvents
        .map((event) => jsonEncode(event.toJson()))
        .toList();

    await _prefs.setStringList(_eventsKey, eventsJson);
  }

  /// Получает количество событий в очереди
  int get pendingEventsCount => _pendingEvents.length;

  /// Очищает очередь событий
  void clearPendingEvents() {
    _pendingEvents.clear();
  }
} 