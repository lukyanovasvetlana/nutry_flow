import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

// Data
import '../data/repositories/dashboard_repository.dart';

// Domain

/// Extension для доступа к зависимостям Dashboard
extension DashboardDependencies on GetIt {
  static GetIt get instance => GetIt.instance;

  static Future<void> initialize() async {
    // Инициализация будет выполнена через @module аннотацию
  }

  static void reset() {
    // Сброс зависимостей
  }
}

@module
abstract class DashboardModule {
  // Repositories
  @lazySingleton
  DashboardRepository get dashboardRepository => DashboardRepository();

  // Use Cases
  // TODO: GetDashboardDataUseCase требует ProfileRepository
  // Нужно зарегистрировать ProfileRepository в DI перед использованием
  // @lazySingleton
  // GetDashboardDataUseCase get getDashboardDataUseCase => GetDashboardDataUseCase(profileRepository);
}
