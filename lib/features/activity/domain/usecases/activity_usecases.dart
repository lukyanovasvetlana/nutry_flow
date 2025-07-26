import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../entities/activity_session.dart';
import '../entities/activity_stats.dart';
import '../repositories/activity_repository.dart';

// Activity Session Use Cases
@injectable
class StartActivitySessionUseCase {
  final ActivityRepository repository;

  StartActivitySessionUseCase(this.repository);

  Future<Either<String, ActivitySession>> call(ActivitySession session) async {
    return await repository.startActivitySession(session);
  }
}

@injectable
class UpdateActivitySessionUseCase {
  final ActivityRepository repository;

  UpdateActivitySessionUseCase(this.repository);

  Future<Either<String, ActivitySession>> call(ActivitySession session) async {
    return await repository.updateActivitySession(session);
  }
}

@injectable
class CompleteActivitySessionUseCase {
  final ActivityRepository repository;

  CompleteActivitySessionUseCase(this.repository);

  Future<Either<String, ActivitySession>> call(String sessionId) async {
    return await repository.completeActivitySession(sessionId);
  }
}

@injectable
class GetCurrentSessionUseCase {
  final ActivityRepository repository;

  GetCurrentSessionUseCase(this.repository);

  Future<Either<String, ActivitySession?>> call(String userId) async {
    return await repository.getCurrentSession(userId);
  }
}

@injectable
class GetUserSessionsUseCase {
  final ActivityRepository repository;

  GetUserSessionsUseCase(this.repository);

  Future<Either<String, List<ActivitySession>>> call(String userId, {DateTime? from, DateTime? to}) async {
    return await repository.getUserSessions(userId, from: from, to: to);
  }
}

@injectable
class GetSessionByIdUseCase {
  final ActivityRepository repository;

  GetSessionByIdUseCase(this.repository);

  Future<Either<String, ActivitySession?>> call(String id) async {
    return await repository.getSessionById(id);
  }
}

// Activity Stats Use Cases
@injectable
class GetDailyStatsUseCase {
  final ActivityRepository repository;

  GetDailyStatsUseCase(this.repository);

  Future<Either<String, ActivityStats>> call(String userId, DateTime date) async {
    return await repository.getDailyStats(userId, date);
  }
}

@injectable
class GetWeeklyStatsUseCase {
  final ActivityRepository repository;

  GetWeeklyStatsUseCase(this.repository);

  Future<Either<String, List<ActivityStats>>> call(String userId, DateTime weekStart) async {
    return await repository.getWeeklyStats(userId, weekStart);
  }
}

@injectable
class GetMonthlyStatsUseCase {
  final ActivityRepository repository;

  GetMonthlyStatsUseCase(this.repository);

  Future<Either<String, List<ActivityStats>>> call(String userId, DateTime monthStart) async {
    return await repository.getMonthlyStats(userId, monthStart);
  }
}

@injectable
class UpdateDailyStatsUseCase {
  final ActivityRepository repository;

  UpdateDailyStatsUseCase(this.repository);

  Future<Either<String, ActivityStats>> call(ActivityStats stats) async {
    return await repository.updateDailyStats(stats);
  }
}

// Analytics Use Cases
@injectable
class GetActivityAnalyticsUseCase {
  final ActivityRepository repository;

  GetActivityAnalyticsUseCase(this.repository);

  Future<Either<String, Map<String, dynamic>>> call(String userId, {DateTime? from, DateTime? to}) async {
    return await repository.getActivityAnalytics(userId, from: from, to: to);
  }
}

@injectable
class GetTotalWorkoutsUseCase {
  final ActivityRepository repository;

  GetTotalWorkoutsUseCase(this.repository);

  Future<Either<String, int>> call(String userId) async {
    return await repository.getTotalWorkouts(userId);
  }
}

@injectable
class GetTotalDurationUseCase {
  final ActivityRepository repository;

  GetTotalDurationUseCase(this.repository);

  Future<Either<String, int>> call(String userId, {DateTime? from, DateTime? to}) async {
    return await repository.getTotalDuration(userId, from: from, to: to);
  }
}

@injectable
class GetTotalCaloriesBurnedUseCase {
  final ActivityRepository repository;

  GetTotalCaloriesBurnedUseCase(this.repository);

  Future<Either<String, int>> call(String userId, {DateTime? from, DateTime? to}) async {
    return await repository.getTotalCaloriesBurned(userId, from: from, to: to);
  }
} 