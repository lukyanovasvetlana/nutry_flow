import 'package:nutry_flow/core/services/supabase_service.dart';
import 'package:nutry_flow/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:nutry_flow/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:nutry_flow/features/auth/domain/repositories/auth_repository.dart';
import 'package:nutry_flow/features/auth/domain/usecases/login_usecase.dart';
import 'package:nutry_flow/features/auth/domain/usecases/register_usecase.dart';
import 'package:nutry_flow/features/auth/domain/usecases/logout_usecase.dart';
import 'package:nutry_flow/features/auth/presentation/bloc/auth_bloc.dart';

class AuthDependencies {
  static AuthDependencies? _instance;

  // Services
  late final SupabaseService _supabaseService;

  // Data Sources
  late final AuthRemoteDataSource _authRemoteDataSource;

  // Repositories
  late final AuthRepository _authRepository;

  // Use Cases
  late final LoginUseCase _loginUseCase;
  late final RegisterUseCase _registerUseCase;
  late final LogoutUseCase _logoutUseCase;

  AuthDependencies._();

  /// Получает singleton экземпляр
  static AuthDependencies get instance {
    _instance ??= AuthDependencies._();
    return _instance!;
  }

  /// Инициализирует все зависимости
  Future<void> initialize() async {
    // Инициализация сервисов
    _supabaseService = SupabaseService.instance;

    // Инициализация Data Sources
    _authRemoteDataSource = AuthRemoteDataSourceImpl();

    // Инициализация Repositories
    _authRepository = AuthRepositoryImpl(_authRemoteDataSource);

    // Инициализация Use Cases
    _loginUseCase = LoginUseCase(_authRepository);
    _registerUseCase = RegisterUseCase(_authRepository);
    _logoutUseCase = LogoutUseCase(_authRepository);
  }

  /// Создает новый экземпляр AuthBloc с инжектированными зависимостями
  AuthBloc createAuthBloc() {
    return AuthBloc(
      loginUseCase: _loginUseCase,
      registerUseCase: _registerUseCase,
      logoutUseCase: _logoutUseCase,
    );
  }

  // Геттеры для доступа к зависимостям
  SupabaseService get supabaseService => _supabaseService;
  AuthRemoteDataSource get authRemoteDataSource => _authRemoteDataSource;
  AuthRepository get authRepository => _authRepository;
  LoginUseCase get loginUseCase => _loginUseCase;
  RegisterUseCase get registerUseCase => _registerUseCase;
  LogoutUseCase get logoutUseCase => _logoutUseCase;

  /// Очищает singleton для тестирования
  static void reset() {
    _instance = null;
  }
}
