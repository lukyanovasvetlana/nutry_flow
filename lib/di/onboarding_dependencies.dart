import 'package:nutry_flow/config/supabase_config.dart';
import 'package:nutry_flow/features/onboarding/data/repositories/auth_repository_impl.dart';
import 'package:nutry_flow/features/onboarding/data/repositories/mock_auth_repository.dart';
import 'package:nutry_flow/features/onboarding/data/repositories/mock_user_goals_repository.dart';
import 'package:nutry_flow/features/onboarding/data/repositories/user_goals_repository_impl.dart';
import 'package:nutry_flow/features/onboarding/data/services/local_storage_service.dart';
import 'package:nutry_flow/features/onboarding/data/services/supabase_service.dart';
import 'package:nutry_flow/features/onboarding/domain/repositories/auth_repository.dart';
import 'package:nutry_flow/features/onboarding/domain/repositories/user_goals_repository.dart';
import 'package:nutry_flow/features/onboarding/domain/usecases/get_user_goals_usecase.dart';
import 'package:nutry_flow/features/onboarding/domain/usecases/save_user_goals_usecase.dart';
import 'package:nutry_flow/features/onboarding/domain/usecases/sign_in_usecase.dart';
import 'package:nutry_flow/features/onboarding/domain/usecases/sign_up_usecase.dart';
import 'package:nutry_flow/features/onboarding/presentation/bloc/auth_bloc.dart';
import 'package:nutry_flow/features/onboarding/presentation/bloc/goals_setup_bloc.dart';
import 'dart:developer' as developer;

/// Контейнер зависимостей для onboarding фичи
/// Реализует паттерн Dependency Injection для связывания слоев Clean Architecture
class OnboardingDependencies {
  static OnboardingDependencies? _instance;

  // Сервисы
  late final SupabaseService _supabaseService;
  late final LocalStorageService _localStorageService;

  // Репозитории
  late final UserGoalsRepository _userGoalsRepository;
  late final AuthRepository _authRepository;

  // Use Cases
  late final SaveUserGoalsUseCase _saveUserGoalsUseCase;
  late final GetUserGoalsUseCase _getUserGoalsUseCase;
  late final SignUpUseCase _signUpUseCase;
  late final SignInUseCase _signInUseCase;

  OnboardingDependencies._();

  /// Получает singleton экземпляр
  static OnboardingDependencies get instance {
    _instance ??= OnboardingDependencies._();
    return _instance!;
  }

  /// Инициализирует все зависимости
  Future<void> initialize() async {
    developer.log('🔵 OnboardingDependencies: initialize called',
        name: 'onboarding_dependencies');
    developer.log(
        '🔵 OnboardingDependencies: SupabaseConfig.isDemo = ${SupabaseConfig.isDemo}',
        name: 'onboarding_dependencies');

    // Инициализация сервисов
    _supabaseService = SupabaseService.instance;
    _localStorageService = await LocalStorageService.create();

    // Выбираем реализацию репозиториев в зависимости от конфигурации

    if (SupabaseConfig.isDemo) {
      developer.log(
          '🔵 OnboardingDependencies: Using demo mode - MockAuthRepository',
          name: 'onboarding_dependencies');
      _userGoalsRepository = MockUserGoalsRepository();

      _authRepository = MockAuthRepository();
      // Создаем тестового пользователя для демонстрации
      MockAuthRepository.createTestUser();
    } else {
      developer.log(
          '🔵 OnboardingDependencies: Using production mode - AuthRepositoryImpl',
          name: 'onboarding_dependencies');
      _userGoalsRepository = UserGoalsRepositoryImpl(
        _supabaseService,
        _localStorageService,
      );

      _authRepository = AuthRepositoryImpl(_supabaseService);
    }

    // Инициализация Use Cases
    _saveUserGoalsUseCase = SaveUserGoalsUseCase(
      _userGoalsRepository,
      _authRepository,
    );

    _getUserGoalsUseCase = GetUserGoalsUseCase(
      _userGoalsRepository,
      _authRepository,
    );

    _signUpUseCase = SignUpUseCase(_authRepository);
    _signInUseCase = SignInUseCase(_authRepository);
  }

  /// Создает новый экземпляр GoalsSetupBloc с инжектированными зависимостями
  GoalsSetupBloc createGoalsSetupBloc() {
    return GoalsSetupBloc(
      _saveUserGoalsUseCase,
      _getUserGoalsUseCase,
    );
  }

  /// Создает новый экземпляр AuthBloc с инжектированными зависимостями
  AuthBloc createAuthBloc() {
    developer.log('🔵 OnboardingDependencies: createAuthBloc called',
        name: 'onboarding_dependencies');
    developer.log(
        '🔵 OnboardingDependencies: _authRepository type = ${_authRepository.runtimeType}',
        name: 'onboarding_dependencies');
    developer.log(
        '🔵 OnboardingDependencies: _signUpUseCase type = ${_signUpUseCase.runtimeType}',
        name: 'onboarding_dependencies');

    return AuthBloc(
      authRepository: _authRepository,
      signUpUseCase: _signUpUseCase,
      signInUseCase: _signInUseCase,
    );
  }

  // Геттеры для доступа к зависимостям (если нужно для тестирования)

  SupabaseService get supabaseService => _supabaseService;
  LocalStorageService get localStorageService => _localStorageService;
  UserGoalsRepository get userGoalsRepository => _userGoalsRepository;
  AuthRepository get authRepository => _authRepository;
  SaveUserGoalsUseCase get saveUserGoalsUseCase => _saveUserGoalsUseCase;
  GetUserGoalsUseCase get getUserGoalsUseCase => _getUserGoalsUseCase;
  SignUpUseCase get signUpUseCase => _signUpUseCase;
  SignInUseCase get signInUseCase => _signInUseCase;

  /// Проверяет, используется ли демо-режим
  bool get isDemo => SupabaseConfig.isDemo;

  /// Очищает singleton для тестирования
  static void reset() {
    _instance = null;
  }
}
