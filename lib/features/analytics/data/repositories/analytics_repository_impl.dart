import '../../domain/entities/analytics_event.dart';
import '../../domain/entities/analytics_data.dart';
import '../../domain/repositories/analytics_repository.dart';
import '../services/analytics_service.dart';
import '../models/analytics_event_model.dart';
import '../models/analytics_data_model.dart';

/// Реализация репозитория аналитики
class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final AnalyticsService _analyticsService;

  const AnalyticsRepositoryImpl(this._analyticsService);

  @override
  Future<void> trackEvent(AnalyticsEvent event) async {
    final eventModel = AnalyticsEventModel.fromEntity(event);
    await _analyticsService.trackEvent(eventModel);
  }

  @override
  Future<void> trackEvents(List<AnalyticsEvent> events) async {
    final eventModels = events.map(AnalyticsEventModel.fromEntity).toList();
    await _analyticsService.trackEvents(eventModels);
  }

  @override
  Future<AnalyticsData> getUserAnalytics({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final dataModel = await _analyticsService.getAnalyticsForPeriod(
      userId,
      startDate,
      endDate,
    );
    return dataModel;
  }

  @override
  Future<AnalyticsData> getTodayAnalytics(String userId) async {
    final dataModel = await _analyticsService.getTodayAnalytics(userId);
    return dataModel;
  }

  @override
  Future<AnalyticsData> getWeeklyAnalytics(String userId) async {
    final dataModel = await _analyticsService.getWeeklyAnalytics(userId);
    return dataModel;
  }

  @override
  Future<AnalyticsData> getMonthlyAnalytics(String userId) async {
    final dataModel = await _analyticsService.getMonthlyAnalytics(userId);
    return dataModel;
  }

  @override
  Future<void> saveAnalyticsData(AnalyticsData data) async {
    final dataModel = AnalyticsDataModel.fromEntity(data);
    await _analyticsService.saveAnalyticsData(dataModel);
  }

  @override
  Future<AnalyticsData?> getSavedAnalyticsData(
      String userId, DateTime date) async {
    final dataModel =
        await _analyticsService.getSavedAnalyticsData(userId, date);
    return dataModel;
  }

  @override
  Future<void> clearOldAnalyticsData(int daysToKeep) async {
    await _analyticsService.clearOldAnalyticsData(daysToKeep);
  }

  @override
  Future<void> initialize() async {
    await _analyticsService.initialize();
  }

  @override
  Future<void> setUser(String userId) async {
    await _analyticsService.setUser(userId);
  }

  @override
  Future<void> resetUser() async {
    await _analyticsService.resetUser();
  }
}
