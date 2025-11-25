import 'package:supabase_flutter/supabase_flutter.dart';
import '../../test/mocks/mock_shared_preferences.dart';

/// Мок для Supabase в тестах
/// 
/// Предоставляет статические методы для инициализации
/// без реальной инициализации Supabase
class SupabaseTestMock {
  static bool _isInitialized = false;
  static SupabaseClient? _mockClient;

  /// Инициализация мока
  static Future<void> initialize() async {
    if (_isInitialized) return;
    // Инициализируем мок SharedPreferences
    MockSharedPreferences.initialize();

    // Создаем мок клиента
    // _mockClient = MockSupabaseClient(); // Закомментировано из-за проблем с наследованием

    _isInitialized = true;
  }

  /// Получение мок клиента
  static SupabaseClient? get client => _mockClient;

  /// Проверка инициализации
  static bool get isInitialized => _isInitialized;

  /// Очистка мока
  static void reset() {
    _isInitialized = false;
    _mockClient = null;
    MockSharedPreferences.clear();
  }
}

// Моки для Supabase классов закомментированы из-за проблем с наследованием
// Используйте MockSupabase из test/mocks/mock_supabase.dart вместо этого
/*
/// Мок для SupabaseClient
class MockSupabaseClient extends SupabaseClient {
  MockSupabaseClient() : super('', '');

  @override
  SupabaseAuth get auth => MockSupabaseAuth();

  @override
  SupabaseRealtimeClient get realtime => MockSupabaseRealtimeClient();

  @override
  SupabaseStorageClient get storage => MockSupabaseStorageClient();

  @override
  SupabasePostgrestClient get from => MockSupabasePostgrestClient();
}

/// Мок для SupabaseAuth
class MockSupabaseAuth extends SupabaseAuth {
  MockSupabaseAuth() : super(MockSupabaseClient());

  @override
  User? get currentUser => null;

  @override
  Stream<AuthState> get authStateChanges => Stream.value(AuthState(AuthChangeEvent.signedOut, null));

  @override
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? data,
  }) async {
    // Имитируем успешную регистрацию
    final user = User(
      id: 'mock-user-id',
      appMetadata: {},
      userMetadata: {},
      aud: 'authenticated',
      createdAt: DateTime.now().toIso8601String(),
    );
    
    return AuthResponse(
      user: user,
      session: Session(
        accessToken: 'mock-access-token',
        refreshToken: 'mock-refresh-token',
        expiresIn: 3600,
        tokenType: 'bearer',
        user: user,
      ),
    );
  }

  @override
  Future<AuthResponse> signInWithPassword({
    required String email,
    required String password,
  }) async {
    // Имитируем успешный вход
    final user = User(
      id: 'mock-user-id',
      appMetadata: {},
      userMetadata: {},
      aud: 'authenticated',
      createdAt: DateTime.now().toIso8601String(),
    );
    
    return AuthResponse(
      user: user,
      session: Session(
        accessToken: 'mock-access-token',
        refreshToken: 'mock-refresh-token',
        expiresIn: 3600,
        tokenType: 'bearer',
        user: user,
      ),
    );
  }

  @override
  Future<void> signOut() async {
    // Имитируем выход
  }

  @override
  Future<void> resetPasswordForEmail(String email) async {
    // Имитируем сброс пароля
  }
}

/// Мок для SupabaseRealtimeClient
class MockSupabaseRealtimeClient extends SupabaseRealtimeClient {
  MockSupabaseRealtimeClient() : super(MockSupabaseClient());
}

/// Мок для SupabaseStorageClient
class MockSupabaseStorageClient extends SupabaseStorageClient {
  MockSupabaseStorageClient() : super(MockSupabaseClient());
}

/// Мок для SupabasePostgrestClient
class MockSupabasePostgrestClient extends SupabasePostgrestClient {
  MockSupabasePostgrestClient() : super(MockSupabaseClient());
}
*/
