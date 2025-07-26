import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';

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

  AuthBloc({
    required AuthRepository authRepository,
    required SignUpUseCase signUpUseCase,
    required SignInUseCase signInUseCase,
  })  : _authRepository = authRepository,
        _signUpUseCase = signUpUseCase,
        _signInUseCase = signInUseCase,
        super(AuthInitial()) {
    on<SignUpRequested>(_onSignUpRequested);
    on<SignInRequested>(_onSignInRequested);
    on<SignOutRequested>(_onSignOutRequested);
    on<AuthStatusChecked>(_onAuthStatusChecked);
    on<ResetPasswordRequested>(_onResetPasswordRequested);
  }

  void _onSignUpRequested(SignUpRequested event, Emitter<AuthState> emit) async {
    print('🔵 AuthBloc: SignUpRequested received - email: ${event.email}');
    emit(AuthLoading());
    
    try {
      print('🔵 AuthBloc: Calling signUpUseCase.execute');
      final result = await _signUpUseCase.execute(event.email, event.password);
      
      print('🔵 AuthBloc: SignUp result - isSuccess: ${result.isSuccess}');
      if (result.isSuccess) {
        print('🔵 AuthBloc: SignUp successful - user: ${result.user?.email}');
        emit(AuthAuthenticated(result.user!));
      } else {
        print('🔵 AuthBloc: SignUp failed - error: ${result.error}');
        emit(AuthError(result.error ?? 'Ошибка регистрации'));
      }
    } catch (e) {
      print('🔵 AuthBloc: SignUp exception: $e');
      emit(AuthError('Ошибка регистрации: ${e.toString()}'));
    }
  }

  void _onSignInRequested(SignInRequested event, Emitter<AuthState> emit) async {
    print('🔵 AuthBloc: SignInRequested received - email: ${event.email}');
    emit(AuthLoading());
    
    try {
      print('🔵 AuthBloc: Calling signInUseCase.execute');
      final result = await _signInUseCase.execute(event.email, event.password);
      
      print('🔵 AuthBloc: SignIn result - isSuccess: ${result.isSuccess}');
      if (result.isSuccess) {
        print('🔵 AuthBloc: SignIn successful - user: ${result.user?.email}');
        emit(AuthAuthenticated(result.user!));
      } else {
        print('🔵 AuthBloc: SignIn failed - error: ${result.error}');
        emit(AuthError(result.error ?? 'Ошибка входа'));
      }
    } catch (e) {
      print('🔵 AuthBloc: SignIn exception: $e');
      emit(AuthError('Ошибка входа: ${e.toString()}'));
    }
  }

  void _onSignOutRequested(SignOutRequested event, Emitter<AuthState> emit) async {
    try {
      await _authRepository.signOut();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError('Ошибка выхода: ${e.toString()}'));
    }
  }

  void _onAuthStatusChecked(AuthStatusChecked event, Emitter<AuthState> emit) async {
    try {
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthUnauthenticated());
    }
  }

  void _onResetPasswordRequested(ResetPasswordRequested event, Emitter<AuthState> emit) async {
    print('🔵 AuthBloc: ResetPasswordRequested received - email: ${event.email}');
    emit(AuthLoading());
    
    try {
      print('🔵 AuthBloc: Calling authRepository.resetPassword');
      await _authRepository.resetPassword(event.email);
      
      print('🔵 AuthBloc: Password reset successful');
      emit(PasswordResetSent(event.email));
    } catch (e) {
      print('🔵 AuthBloc: Password reset failed - error: ${e.toString()}');
      emit(AuthError('Ошибка сброса пароля: ${e.toString()}'));
    }
  }
} 