import 'package:supabase_flutter/supabase_flutter.dart';

/// Мок для Supabase Auth
class MockSupabaseAuth {
  static final MockSupabaseAuth _instance = MockSupabaseAuth._internal();
  factory MockSupabaseAuth() => _instance;
  MockSupabaseAuth._internal();

  User? _currentUser;
  Stream<AuthState>? _authStateChanges;

  User? get currentUser => _currentUser;
  
  Stream<AuthState> get authStateChanges => _authStateChanges ?? 
    Stream.value(AuthState(AuthChangeEvent.signedOut, null));

  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    // Имитируем успешную регистрацию
    _currentUser = User(
      id: 'mock-user-id',
      appMetadata: {},
      userMetadata: {},
      aud: 'authenticated',
      createdAt: DateTime.now().toIso8601String(),
    );
    
    return AuthResponse(
      user: _currentUser,
      session: Session(
        accessToken: 'mock-access-token',
        refreshToken: 'mock-refresh-token',
        expiresIn: 3600,
        expiresAt: DateTime.now().add(Duration(hours: 1)).millisecondsSinceEpoch,
        tokenType: 'bearer',
        user: _currentUser!,
      ),
    );
  }

  Future<AuthResponse> signInWithPassword({
    required String email,
    required String password,
  }) async {
    // Имитируем успешный вход
    _currentUser = User(
      id: 'mock-user-id',
      appMetadata: {},
      userMetadata: {},
      aud: 'authenticated',
      createdAt: DateTime.now().toIso8601String(),
    );
    
    return AuthResponse(
      user: _currentUser,
      session: Session(
        accessToken: 'mock-access-token',
        refreshToken: 'mock-refresh-token',
        expiresIn: 3600,
        expiresAt: DateTime.now().add(Duration(hours: 1)).millisecondsSinceEpoch,
        tokenType: 'bearer',
        user: _currentUser!,
      ),
    );
  }

  Future<void> signOut() async {
    _currentUser = null;
  }

  Future<void> resetPasswordForEmail(String email) async {
    // Имитируем сброс пароля
  }
}

/// Мок для Supabase
class MockSupabase {
  static final MockSupabase _instance = MockSupabase._internal();
  factory MockSupabase() => _instance;
  MockSupabase._internal();

  final MockSupabaseAuth _auth = MockSupabaseAuth();

  SupabaseAuth get auth => _auth as SupabaseAuth;
}

/// Расширение для MockSupabaseAuth чтобы соответствовать SupabaseAuth
extension MockSupabaseAuthExtension on MockSupabaseAuth {
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    return signUp(email: email, password: password);
  }

  Future<AuthResponse> signInWithPassword({
    required String email,
    required String password,
  }) async {
    return signInWithPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    return signOut();
  }

  Future<void> resetPasswordForEmail(String email) async {
    return resetPasswordForEmail(email);
  }
}
