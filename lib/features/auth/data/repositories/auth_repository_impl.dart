import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<User> signIn(String email, String password) async {
    try {
      final userModel = await _remoteDataSource.signIn(email, password);
      return userModel.toEntity();
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }

  @override
  Future<User> signUp(String email, String password) async {
    try {
      final userModel = await _remoteDataSource.signUp(email, password);
      return userModel.toEntity();
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _remoteDataSource.signOut();
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _remoteDataSource.resetPassword(email);
    } catch (e) {
      throw Exception('Failed to reset password: $e');
    }
  }

  @override
  Future<bool> isUserLoggedIn() async {
    try {
      return await _remoteDataSource.isUserLoggedIn();
    } catch (e) {
      return false;
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      final userModel = await _remoteDataSource.getCurrentUser();
      return userModel?.toEntity();
    } catch (e) {
      return null;
    }
  }

  @override
  Stream<User?> get authStateChanges {
    return _remoteDataSource.authStateChanges.map((userModel) {
      return userModel?.toEntity();
    });
  }
}
