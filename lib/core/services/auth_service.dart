import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  static final _supabase = Supabase.instance.client;

  static Future<bool> isUserLoggedIn() async {
    try {
      final session = _supabase.auth.currentSession;
      return session != null;
    } catch (e) {
      return false;
    }
  }

  static Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      // Ошибка при выходе
    }
  }

  static Future<AuthResponse> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<AuthResponse> signUpWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
    } catch (e) {
      rethrow;
    }
  }
}
