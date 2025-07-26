import 'package:get_it/get_it.dart';
import '../data/services/analytics_service.dart';
import '../data/repositories/analytics_repository_impl.dart';
import '../domain/repositories/analytics_repository.dart';
import '../domain/usecases/track_event_usecase.dart';
import '../presentation/bloc/analytics_bloc.dart';

/// Зависимости для модуля аналитики
class AnalyticsDependencies {
  static final AnalyticsDependencies _instance = AnalyticsDependencies._internal();
  factory AnalyticsDependencies() => _instance;
  AnalyticsDependencies._internal();

  static AnalyticsDependencies get instance => _instance;

  /// Инициализирует зависимости аналитики
  Future<void> initialize() async {
    print('🔍 AnalyticsDependencies: Initializing analytics dependencies...');

    final getIt = GetIt.instance;

    // Регистрируем сервис
    getIt.registerLazySingleton<AnalyticsService>(
      () => AnalyticsService(),
    );

    // Регистрируем репозиторий
    getIt.registerLazySingleton<AnalyticsRepository>(
      () => AnalyticsRepositoryImpl(getIt<AnalyticsService>()),
    );

    // Регистрируем use cases
    getIt.registerLazySingleton<TrackEventUseCase>(
      () => TrackEventUseCase(getIt<AnalyticsRepository>()),
    );

    getIt.registerLazySingleton<TrackEventsUseCase>(
      () => TrackEventsUseCase(getIt<AnalyticsRepository>()),
    );

    getIt.registerLazySingleton<GetTodayAnalyticsUseCase>(
      () => GetTodayAnalyticsUseCase(getIt<AnalyticsRepository>()),
    );

    getIt.registerLazySingleton<GetWeeklyAnalyticsUseCase>(
      () => GetWeeklyAnalyticsUseCase(getIt<AnalyticsRepository>()),
    );

    getIt.registerLazySingleton<GetMonthlyAnalyticsUseCase>(
      () => GetMonthlyAnalyticsUseCase(getIt<AnalyticsRepository>()),
    );

    getIt.registerLazySingleton<GetAnalyticsForPeriodUseCase>(
      () => GetAnalyticsForPeriodUseCase(getIt<AnalyticsRepository>()),
    );

    // Регистрируем BLoC
    getIt.registerFactory<AnalyticsBloc>(
      () => AnalyticsBloc(
        trackEventUseCase: getIt<TrackEventUseCase>(),
        trackEventsUseCase: getIt<TrackEventsUseCase>(),
        getTodayAnalyticsUseCase: getIt<GetTodayAnalyticsUseCase>(),
        getWeeklyAnalyticsUseCase: getIt<GetWeeklyAnalyticsUseCase>(),
        getMonthlyAnalyticsUseCase: getIt<GetMonthlyAnalyticsUseCase>(),
        getAnalyticsForPeriodUseCase: getIt<GetAnalyticsForPeriodUseCase>(),
      ),
    );

    // Инициализируем сервис
    await getIt<AnalyticsService>().initialize();

    print('🔍 AnalyticsDependencies: All analytics dependencies initialized successfully');
  }

  /// Получает AnalyticsBloc
  AnalyticsBloc getAnalyticsBloc() {
    return GetIt.instance<AnalyticsBloc>();
  }

  /// Получает AnalyticsService
  AnalyticsService getAnalyticsService() {
    return GetIt.instance<AnalyticsService>();
  }

  /// Получает AnalyticsRepository
  AnalyticsRepository getAnalyticsRepository() {
    return GetIt.instance<AnalyticsRepository>();
  }
} 