import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/analytics_event.dart';
import '../entities/analytics_data.dart';
import '../repositories/analytics_repository.dart';

/// Use case для отслеживания аналитических событий
class TrackEventUseCase {
  final AnalyticsRepository _repository;

  const TrackEventUseCase(this._repository);

  /// Выполняет отслеживание события
  Future<Either<Failure, void>> call(AnalyticsEvent event) async {
    try {
      await _repository.trackEvent(event);
      return const Right(null);
    } catch (e) {
      return Left(AnalyticsFailure(e.toString()));
    }
  }
}

/// Use case для отслеживания нескольких событий
class TrackEventsUseCase {
  final AnalyticsRepository _repository;

  const TrackEventsUseCase(this._repository);

  /// Выполняет отслеживание нескольких событий
  Future<Either<Failure, void>> call(List<AnalyticsEvent> events) async {
    try {
      await _repository.trackEvents(events);
      return const Right(null);
    } catch (e) {
      return Left(AnalyticsFailure(e.toString()));
    }
  }
}

/// Use case для получения аналитических данных за сегодня
class GetTodayAnalyticsUseCase {
  final AnalyticsRepository _repository;

  const GetTodayAnalyticsUseCase(this._repository);

  /// Выполняет получение аналитических данных за сегодня
  Future<Either<Failure, AnalyticsData>> call(String userId) async {
    try {
      final data = await _repository.getTodayAnalytics(userId);
      return Right(data);
    } catch (e) {
      return Left(AnalyticsFailure(e.toString()));
    }
  }
}

/// Use case для получения аналитических данных за неделю
class GetWeeklyAnalyticsUseCase {
  final AnalyticsRepository _repository;

  const GetWeeklyAnalyticsUseCase(this._repository);

  /// Выполняет получение аналитических данных за неделю
  Future<Either<Failure, AnalyticsData>> call(String userId) async {
    try {
      final data = await _repository.getWeeklyAnalytics(userId);
      return Right(data);
    } catch (e) {
      return Left(AnalyticsFailure(e.toString()));
    }
  }
}

/// Use case для получения аналитических данных за месяц
class GetMonthlyAnalyticsUseCase {
  final AnalyticsRepository _repository;

  const GetMonthlyAnalyticsUseCase(this._repository);

  /// Выполняет получение аналитических данных за месяц
  Future<Either<Failure, AnalyticsData>> call(String userId) async {
    try {
      final data = await _repository.getMonthlyAnalytics(userId);
      return Right(data);
    } catch (e) {
      return Left(AnalyticsFailure(e.toString()));
    }
  }
}

/// Use case для получения аналитических данных за период
class GetAnalyticsForPeriodUseCase {
  final AnalyticsRepository _repository;

  const GetAnalyticsForPeriodUseCase(this._repository);

  /// Выполняет получение аналитических данных за период
  Future<Either<Failure, AnalyticsData>> call({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final data = await _repository.getUserAnalytics(
        userId: userId,
        startDate: startDate,
        endDate: endDate,
      );
      return Right(data);
    } catch (e) {
      return Left(AnalyticsFailure(e.toString()));
    }
  }
} 