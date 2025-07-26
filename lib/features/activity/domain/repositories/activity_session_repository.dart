import '../entities/activity_session.dart';

abstract class ActivitySessionRepository {
  /// Получить все сессии пользователя
  Future<List<ActivitySession>> getUserSessions(String userId);
  
  /// Получить сессию по ID
  Future<ActivitySession?> getSessionById(String id);
  
  /// Создать новую сессию
  Future<ActivitySession> createSession(ActivitySession session);
  
  /// Обновить сессию
  Future<ActivitySession> updateSession(ActivitySession session);
  
  /// Удалить сессию
  Future<void> deleteSession(String id);
  
  /// Получить активные сессии пользователя
  Future<List<ActivitySession>> getActiveSessions(String userId);
  
  /// Получить завершенные сессии пользователя
  Future<List<ActivitySession>> getCompletedSessions(String userId);
  
  /// Получить сессии по дате
  Future<List<ActivitySession>> getSessionsByDate(String userId, DateTime date);
  
  /// Получить сессии по периоду
  Future<List<ActivitySession>> getSessionsByPeriod(String userId, DateTime startDate, DateTime endDate);
  
  /// Получить сессии по типу тренировки
  Future<List<ActivitySession>> getSessionsByWorkoutType(String userId, String workoutType);
  
  /// Получить статистику сессий
  Future<Map<String, dynamic>> getSessionStatistics(String userId);
  
  /// Получить прогресс пользователя
  Future<Map<String, dynamic>> getUserProgress(String userId);
  
  /// Получить последние сессии
  Future<List<ActivitySession>> getRecentSessions(String userId, int limit);
} 