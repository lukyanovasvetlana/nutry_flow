import 'package:get_it/get_it.dart';
import '../data/services/analytics_service.dart';
import '../data/repositories/analytics_repository.dart';
import '../presentation/bloc/analytics_bloc.dart';

/// Зависимости для модуля аналитики
class AnalyticsDependencies {
  static final AnalyticsDependencies _instance =
      AnalyticsDependencies._internal();
  factory AnalyticsDependencies() => _instance;
  AnalyticsDependencies._internal();

  static AnalyticsDependencies get instance => _instance;

  /// Инициализирует зависимости аналитики
  Future<void> initialize() async {
    final getIt = GetIt.instance;

    // Регистрируем сервис
    getIt.registerLazySingleton<AnalyticsService>(
      AnalyticsService.new,
    );

    // Регистрируем репозиторий
    getIt.registerLazySingleton<AnalyticsRepository>(
      AnalyticsRepository.new,
    );

    // Регистрируем BLoC
    getIt.registerFactory<AnalyticsBloc>(
      () => AnalyticsBloc(
        analyticsRepository: getIt<AnalyticsRepository>(),
      ),
    );

    // Инициализируем сервис
    await getIt<AnalyticsService>().initialize();
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
