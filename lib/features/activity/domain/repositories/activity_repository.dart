import 'package:dartz/dartz.dart';
import '../entities/activity_session.dart';
import '../entities/activity_stats.dart';

abstract class ActivityRepository {
  // Activity Sessions
  Future<Either<String, ActivitySession>> startActivitySession(
      ActivitySession session);
  Future<Either<String, ActivitySession>> updateActivitySession(
      ActivitySession session);
  Future<Either<String, ActivitySession>> completeActivitySession(
      String sessionId);
  Future<Either<String, ActivitySession?>> getCurrentSession(String userId);
  Future<Either<String, List<ActivitySession>>> getUserSessions(String userId,
      {DateTime? from, DateTime? to});
  Future<Either<String, ActivitySession?>> getSessionById(String id);

  // Activity Stats
  Future<Either<String, ActivityStats>> getDailyStats(
      String userId, DateTime date);
  Future<Either<String, List<ActivityStats>>> getWeeklyStats(
      String userId, DateTime weekStart);
  Future<Either<String, List<ActivityStats>>> getMonthlyStats(
      String userId, DateTime monthStart);
  Future<Either<String, ActivityStats>> updateDailyStats(ActivityStats stats);

  // Analytics
  Future<Either<String, Map<String, dynamic>>> getActivityAnalytics(
      String userId,
      {DateTime? from,
      DateTime? to});
  Future<Either<String, int>> getTotalWorkouts(String userId);
  Future<Either<String, int>> getTotalDuration(String userId,
      {DateTime? from, DateTime? to});
  Future<Either<String, int>> getTotalCaloriesBurned(String userId,
      {DateTime? from, DateTime? to});
}
