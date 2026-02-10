import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import 'dart:developer' as developer;
import 'package:nutry_flow/shared/auth/auth_session_store.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;

  AuthBloc({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
  })  : _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase,
        _logoutUseCase = logoutUseCase,
        super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<AuthCheckRequested>(_onAuthCheckRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final user = await _loginUseCase(event.email, event.password);
      AuthSessionStore.update(
        email: event.email,
        password: event.password,
      );
      emit(AuthSuccess(user));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      developer.log(r'🔐 AuthBloc: Starting registration for ${event.email}',
          name: 'auth_bloc');
      developer.log(r'🔐 AuthBloc: Password length = ${event.password.length}',
          name: 'auth_bloc');
      developer.log(
          '🔐 AuthBloc: Confirm password length = ${event.confirmPassword.length}',
          name: 'auth_bloc');

      final user = await _registerUseCase(
        event.email,
        event.password,
        event.confirmPassword,
      );
      developer.log(r'🔐 AuthBloc: Registration successful for ${event.email}',
          name: 'auth_bloc');
      AuthSessionStore.update(
        email: event.email,
        password: event.password,
      );
      emit(AuthSuccess(user));
    } catch (e) {
      developer.log(r'🔐 AuthBloc: Registration failed for ${event.email}: $e',
          name: 'auth_bloc');
      developer.log(r'🔐 AuthBloc: Error type = ${e.runtimeType}',
          name: 'auth_bloc');
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      await _logoutUseCase();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      // Здесь можно добавить проверку текущего состояния авторизации
      // Пока оставляем как есть
      emit(AuthInitial());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
