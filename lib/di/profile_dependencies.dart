import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nutry_flow/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:nutry_flow/features/profile/data/services/profile_service.dart';
import 'package:nutry_flow/features/profile/domain/repositories/profile_repository.dart';
import 'package:nutry_flow/features/profile/domain/usecases/get_user_profile_usecase.dart';
import 'package:nutry_flow/features/profile/domain/usecases/update_user_profile_usecase.dart';
import 'package:nutry_flow/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:nutry_flow/config/supabase_config.dart';
import 'package:nutry_flow/features/profile/di/goals_dependencies.dart';

/// Контейнер зависимостей для profile фичи
class ProfileDependencies {
  static ProfileDependencies? _instance;

  // Сервисы
  late final ProfileService _profileService;

  // Репозитории
  late final ProfileRepository _profileRepository;

  // Use Cases
  late final GetUserProfileUseCase _getUserProfileUseCase;
  late final UpdateUserProfileUseCase _updateUserProfileUseCase;

  bool _isInitialized = false;

  ProfileDependencies._();

  /// Получает singleton экземпляр
  static ProfileDependencies get instance {
    _instance ??= ProfileDependencies._();
    return _instance!;
  }

  /// Инициализирует все зависимости
  Future<void> initialize() async {
    if (_isInitialized) {
      return; // Уже инициализирован
    }

    // Выбираем реализацию в зависимости от конфигурации

    if (SupabaseConfig.isDemo) {
      _profileService = MockProfileService();
    } else {
      final supabaseClient = Supabase.instance.client;
      _profileService = SupabaseProfileService(supabaseClient);
    }

    // Инициализация репозиториев
    _profileRepository = ProfileRepositoryImpl(_profileService);

    // Инициализация Use Cases
    _getUserProfileUseCase = GetUserProfileUseCase(_profileRepository);
    _updateUserProfileUseCase = UpdateUserProfileUseCase(_profileRepository);

    // Инициализация зависимостей целей
    await GoalsDependencies.init();

    _isInitialized = true;
  }

  // Геттеры для доступа к зависимостям

  ProfileRepository get profileRepository => _profileRepository;
  GetUserProfileUseCase get getUserProfileUseCase => _getUserProfileUseCase;
  UpdateUserProfileUseCase get updateUserProfileUseCase =>
      _updateUserProfileUseCase;

  /// Создает новый экземпляр ProfileBloc
  static ProfileBloc createProfileBloc() {
    final instance = ProfileDependencies.instance;
    if (!instance._isInitialized) {
      throw StateError(
          'ProfileDependencies must be initialized before creating ProfileBloc');
    }
    return ProfileBloc(
      getUserProfileUseCase: instance.getUserProfileUseCase,
      updateUserProfileUseCase: instance.updateUserProfileUseCase,
    );
  }

  /// Очищает singleton для тестирования
  static void reset() {
    _instance = null;
  }
}
