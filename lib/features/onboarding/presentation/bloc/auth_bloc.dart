import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:developer' as developer;
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';
import '../../../../core/services/supabase_service.dart';


// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class SignUpRequested extends AuthEvent {
  final String email;
  final String password;

  const SignUpRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  const SignInRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class SignOutRequested extends AuthEvent {}

class AuthStatusChecked extends AuthEvent {}

class ResetPasswordRequested extends AuthEvent {
  final String email;

  const ResetPasswordRequested({required this.email});

  @override
  List<Object?> get props => [email];
}

// States
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

class PasswordResetSent extends AuthState {
  final String email;

  const PasswordResetSent(this.email);

  @override
  List<Object?> get props => [email];
}

// BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final SignUpUseCase _signUpUseCase;
  final SignInUseCase _signInUseCase;
  final SupabaseService _supabaseService;

  AuthBloc({
    required AuthRepository authRepository,
    required SignUpUseCase signUpUseCase,
    required SignInUseCase signInUseCase,
  })  : _authRepository = authRepository,
        _signUpUseCase = signUpUseCase,
        _signInUseCase = signInUseCase,
        _supabaseService = SupabaseService.instance,
        super(AuthInitial()) {
    on<SignUpRequested>(_onSignUpRequested);
    on<SignInRequested>(_onSignInRequested);
    on<SignOutRequested>(_onSignOutRequested);
    on<AuthStatusChecked>(_onAuthStatusChecked);
    on<ResetPasswordRequested>(_onResetPasswordRequested);
  }

  void _onSignUpRequested(SignUpRequested event, Emitter<AuthState> emit) async {
    developer.log('🔵 AuthBloc: SignUpRequested received - email: ${event.email}', name: 'AuthBloc');
    emit(AuthLoading());
    
    try {
      // Сначала пробуем Supabase
      if (_supabaseService.isAvailable) {
        developer.log('🔵 AuthBloc: Using Supabase for sign up', name: 'AuthBloc');
        final response = await _supabaseService.signUp(
          email: event.email,
          password: event.password,
        );
        
        if (response.user != null) {
          final user = User(
            id: response.user!.id,
            email: response.user!.email ?? event.email,
            name: response.user!.userMetadata?['name'] ?? '',
          );
          developer.log('🔵 AuthBloc: Supabase sign up successful', name: 'AuthBloc');
          emit(AuthAuthenticated(user));
          return;
        } else {
          developer.log('🔵 AuthBloc: Supabase sign up failed', name: 'AuthBloc');
          emit(AuthError('Ошибка регистрации через Supabase'));
          return;
        }
      }
      
      // Fallback к mock репозиторию
      developer.log('🔵 AuthBloc: Using mock repository for sign up', name: 'AuthBloc');
      final result = await _signUpUseCase.execute(event.email, event.password);
      
      developer.log('🔵 AuthBloc: SignUp result - isSuccess: ${result.isSuccess}', name: 'AuthBloc');
      if (result.isSuccess) {
        developer.log('🔵 AuthBloc: SignUp successful - user: ${result.user?.email}', name: 'AuthBloc');
        emit(AuthAuthenticated(result.user!));
      } else {
        developer.log('🔵 AuthBloc: SignUp failed - error: ${result.error}', name: 'AuthBloc');
        emit(AuthError(result.error ?? 'Ошибка регистрации'));
      }
    } catch (e) {
      developer.log('🔵 AuthBloc: SignUp exception: $e', name: 'AuthBloc');
      emit(AuthError('Ошибка регистрации: ${e.toString()}'));
    }
  }

  void _onSignInRequested(SignInRequested event, Emitter<AuthState> emit) async {
    developer.log('🔵 AuthBloc: SignInRequested received - email: ${event.email}', name: 'AuthBloc');
    emit(AuthLoading());
    
    try {
      // Сначала пробуем Supabase
      if (_supabaseService.isAvailable) {
        developer.log('🔵 AuthBloc: Using Supabase for sign in', name: 'AuthBloc');
        final response = await _supabaseService.signIn(
          email: event.email,
          password: event.password,
        );
        
        if (response.user != null) {
          final user = User(
            id: response.user!.id,
            email: response.user!.email ?? event.email,
            name: response.user!.userMetadata?['name'] ?? '',
          );
          developer.log('🔵 AuthBloc: Supabase sign in successful', name: 'AuthBloc');
          emit(AuthAuthenticated(user));
          return;
        } else {
          developer.log('🔵 AuthBloc: Supabase sign in failed', name: 'AuthBloc');
          emit(AuthError('Ошибка входа через Supabase'));
          return;
        }
      }
      
      // Fallback к mock репозиторию
      developer.log('🔵 AuthBloc: Using mock repository for sign in', name: 'AuthBloc');
      final result = await _signInUseCase.execute(event.email, event.password);
      
      developer.log('🔵 AuthBloc: SignIn result - isSuccess: ${result.isSuccess}', name: 'AuthBloc');
      if (result.isSuccess) {
        developer.log('🔵 AuthBloc: SignIn successful - user: ${result.user?.email}', name: 'AuthBloc');
        emit(AuthAuthenticated(result.user!));
      } else {
        developer.log('🔵 AuthBloc: SignIn failed - error: ${result.error}', name: 'AuthBloc');
        emit(AuthError(result.error ?? 'Ошибка входа'));
      }
    } catch (e) {
      developer.log('🔵 AuthBloc: SignIn exception: $e', name: 'AuthBloc');
      emit(AuthError('Ошибка входа: ${e.toString()}'));
    }
  }

  void _onSignOutRequested(SignOutRequested event, Emitter<AuthState> emit) async {
    try {
      // Сначала пробуем Supabase
      if (_supabaseService.isAvailable) {
        developer.log('🔵 AuthBloc: Using Supabase for sign out', name: 'AuthBloc');
        await _supabaseService.signOut();
        developer.log('🔵 AuthBloc: Supabase sign out successful', name: 'AuthBloc');
        emit(AuthUnauthenticated());
        return;
      }
      
      // Fallback к mock репозиторию
      developer.log('🔵 AuthBloc: Using mock repository for sign out', name: 'AuthBloc');
      await _authRepository.signOut();
      emit(AuthUnauthenticated());
    } catch (e) {
      developer.log('🔵 AuthBloc: Sign out exception: $e', name: 'AuthBloc');
      emit(AuthError('Ошибка выхода: ${e.toString()}'));
    }
  }

  void _onAuthStatusChecked(AuthStatusChecked event, Emitter<AuthState> emit) async {
    try {
      // Сначала пробуем Supabase
      if (_supabaseService.isAvailable) {
        developer.log('🔵 AuthBloc: Using Supabase for auth status check', name: 'AuthBloc');
        final currentUser = _supabaseService.currentUser;
        
        if (currentUser != null) {
          final user = User(
            id: currentUser.id,
            email: currentUser.email ?? '',
            name: currentUser.userMetadata?['name'] ?? '',
          );
          developer.log('🔵 AuthBloc: User authenticated via Supabase', name: 'AuthBloc');
          emit(AuthAuthenticated(user));
          return;
        } else {
          developer.log('🔵 AuthBloc: No user authenticated via Supabase', name: 'AuthBloc');
          emit(AuthUnauthenticated());
          return;
        }
      }
      
      // Fallback к mock репозиторию
      developer.log('🔵 AuthBloc: Using mock repository for auth status check', name: 'AuthBloc');
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      developer.log('🔵 AuthBloc: Auth status check exception: $e', name: 'AuthBloc');
      emit(AuthUnauthenticated());
    }
  }

  void _onResetPasswordRequested(ResetPasswordRequested event, Emitter<AuthState> emit) async {
    developer.log('🔵 AuthBloc: ResetPasswordRequested received - email: ${event.email}', name: 'AuthBloc');
    emit(AuthLoading());
    
    try {
      // Сначала пробуем Supabase
      if (_supabaseService.isAvailable) {
        developer.log('🔵 AuthBloc: Using Supabase for password reset', name: 'AuthBloc');
        await _supabaseService.resetPassword(event.email);
        developer.log('🔵 AuthBloc: Supabase password reset successful', name: 'AuthBloc');
        emit(PasswordResetSent(event.email));
        return;
      }
      
      // Fallback к mock репозиторию
      developer.log('🔵 AuthBloc: Using mock repository for password reset', name: 'AuthBloc');
      await _authRepository.resetPassword(event.email);
      
      developer.log('🔵 AuthBloc: Password reset successful', name: 'AuthBloc');
      emit(PasswordResetSent(event.email));
    } catch (e) {
      developer.log('🔵 AuthBloc: Password reset failed - error: ${e.toString()}', name: 'AuthBloc');
      emit(AuthError('Ошибка сброса пароля: ${e.toString()}'));
    }
  }
} 