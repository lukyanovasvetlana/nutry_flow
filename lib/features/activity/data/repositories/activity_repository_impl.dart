import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/activity_session.dart';
import '../../domain/entities/activity_stats.dart';
import '../../domain/repositories/activity_repository.dart';
import '../services/activity_tracking_service.dart';

@Injectable(as: ActivityRepository)
class ActivityRepositoryImpl implements ActivityRepository {
  final ActivityTrackingService _activityService;

  ActivityRepositoryImpl(this._activityService);

  // Activity Sessions

  @override
  Future<Either<String, ActivitySession>> startActivitySession(ActivitySession session) async {
    try {
      final startedSession = await _activityService.startActivitySession(session);
      return Right(startedSession);
    } catch (e) {
      return Left('Ошибка при начале сессии: $e');
    }
  }

  @override
  Future<Either<String, ActivitySession>> updateActivitySession(ActivitySession session) async {
    try {
      final updatedSession = await _activityService.updateActivitySession(session);
      return Right(updatedSession);
    } catch (e) {
      return Left('Ошибка при обновлении сессии: $e');
    }
  }

  @override
  Future<Either<String, ActivitySession>> completeActivitySession(String sessionId) async {
    try {
      final completedSession = await _activityService.completeActivitySession(sessionId);
      return Right(completedSession);
    } catch (e) {
      return Left('Ошибка при завершении сессии: $e');
    }
  }

  @override
  Future<Either<String, ActivitySession?>> getCurrentSession(String userId) async {
    try {
      final session = await _activityService.getCurrentSession(userId);
      return Right(session);
    } catch (e) {
      return Left('Ошибка при получении текущей сессии: $e');
    }
  }

  @override
  Future<Either<String, List<ActivitySession>>> getUserSessions(String userId, {DateTime? from, DateTime? to}) async {
    try {
      final sessions = await _activityService.getUserSessions(userId, from: from, to: to);
      return Right(sessions);
    } catch (e) {
      return Left('Ошибка при получении сессий: $e');
    }
  }

  @override
  Future<Either<String, ActivitySession?>> getSessionById(String id) async {
    try {
      final session = await _activityService.getSessionById(id);
      return Right(session);
    } catch (e) {
      return Left('Ошибка при получении сессии: $e');
    }
  }

  // Activity Stats

  @override
  Future<Either<String, ActivityStats>> getDailyStats(String userId, DateTime date) async {
    try {
      final stats = await _activityService.getDailyStats(userId, date);
      return Right(stats);
    } catch (e) {
      return Left('Ошибка при получении дневной статистики: $e');
    }
  }

  @override
  Future<Either<String, List<ActivityStats>>> getWeeklyStats(String userId, DateTime weekStart) async {
    try {
      final stats = await _activityService.getWeeklyStats(userId, weekStart);
      return Right(stats);
    } catch (e) {
      return Left('Ошибка при получении недельной статистики: $e');
    }
  }

  @override
  Future<Either<String, List<ActivityStats>>> getMonthlyStats(String userId, DateTime monthStart) async {
    try {
      final stats = await _activityService.getMonthlyStats(userId, monthStart);
      return Right(stats);
    } catch (e) {
      return Left('Ошибка при получении месячной статистики: $e');
    }
  }

  @override
  Future<Either<String, ActivityStats>> updateDailyStats(ActivityStats stats) async {
    try {
      final updatedStats = await _activityService.updateDailyStats(stats);
      return Right(updatedStats);
    } catch (e) {
      return Left('Ошибка при обновлении статистики: $e');
    }
  }

  // Analytics

  @override
  Future<Either<String, Map<String, dynamic>>> getActivityAnalytics(String userId, {DateTime? from, DateTime? to}) async {
    try {
      final analytics = await _activityService.getActivityAnalytics(userId, from: from, to: to);
      return Right(analytics);
    } catch (e) {
      return Left('Ошибка при получении аналитики: $e');
    }
  }

  @override
  Future<Either<String, int>> getTotalWorkouts(String userId) async {
    try {
      final total = await _activityService.getTotalWorkouts(userId);
      return Right(total);
    } catch (e) {
      return Left('Ошибка при получении общего количества тренировок: $e');
    }
  }

  @override
  Future<Either<String, int>> getTotalDuration(String userId, {DateTime? from, DateTime? to}) async {
    try {
      final duration = await _activityService.getTotalDuration(userId, from: from, to: to);
      return Right(duration);
    } catch (e) {
      return Left('Ошибка при получении общего времени: $e');
    }
  }

  @override
  Future<Either<String, int>> getTotalCaloriesBurned(String userId, {DateTime? from, DateTime? to}) async {
    try {
      final calories = await _activityService.getTotalCaloriesBurned(userId, from: from, to: to);
      return Right(calories);
    } catch (e) {
      return Left('Ошибка при получении общего количества калорий: $e');
    }
  }
} 