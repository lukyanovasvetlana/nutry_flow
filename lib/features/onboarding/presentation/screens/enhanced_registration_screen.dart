import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nutry_flow/shared/theme/app_colors.dart';
import '../bloc/auth_bloc.dart';
import '../../di/onboarding_dependencies.dart';
import 'dart:developer' as developer;

class EnhancedRegistrationScreen extends StatefulWidget {
  const EnhancedRegistrationScreen({super.key});

  @override
  State<EnhancedRegistrationScreen> createState() =>
      _EnhancedRegistrationScreenState();
}

class _EnhancedRegistrationScreenState
    extends State<EnhancedRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register(BuildContext context) async {
    developer.log('🔵 Registration: _register called', name: 'enhanced_registration_screen');
    developer.log('🔵 Registration: Form validation started', name: 'enhanced_registration_screen');

    if (!_formKey.currentState!.validate()) {
      developer.log('🔴 Registration: Form validation failed', name: 'enhanced_registration_screen');
      return;
    }

    developer.log('🔵 Registration: Form is valid, sending SignUpRequested', name: 'enhanced_registration_screen');
    developer.log('🔵 Registration: Email: \${_emailController.text.trim()}', name: 'enhanced_registration_screen');
    developer.log(
        '🔵 Registration: Password length: ${_passwordController.text.length}', name: 'enhanced_registration_screen');

    try {
      // Отправляем событие регистрации
      context.read<AuthBloc>().add(SignUpRequested(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          ));

      developer.log('🔵 Registration: SignUpRequested event sent', name: 'enhanced_registration_screen');
    } catch (e) {
      developer.log('🔴 Registration: Error during registration: \$e', name: 'enhanced_registration_screen');
    }
  }

  Future<void> _saveEmailToSharedPreferences(String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userEmail', email);
      developer.log('🔵 Registration: Email saved to SharedPreferences: $email', name: 'enhanced_registration_screen');
    } catch (e) {
      developer.log('🔴 Registration: Error saving email to SharedPreferences: $e', name: 'enhanced_registration_screen');
    }
  }

  @override
  Widget build(BuildContext context) {
    developer.log('🔵 Registration: build called', name: 'enhanced_registration_screen');
    return BlocProvider(
      create: (context) {
        developer.log('🔵 Registration: Creating AuthBloc via OnboardingDependencies', name: 'enhanced_registration_screen');
        final authBloc = OnboardingDependencies.instance.createAuthBloc();
        developer.log('🔵 Registration: AuthBloc created: \${authBloc.runtimeType}', name: 'enhanced_registration_screen');
        return authBloc;
      },
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          developer.log(
              '🔵 Registration: BlocListener received state: ${state.runtimeType}', name: 'enhanced_registration_screen');

          if (state is AuthAuthenticated) {
            developer.log(
                '🟢 Registration: User authenticated, navigating to profile setup', name: 'enhanced_registration_screen');
            // Сохраняем email в SharedPreferences
            _saveEmailToSharedPreferences(state.user.email);
            
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/profile-info', (route) => false);
              }
            });
          } else if (state is AuthLoading) {
            developer.log('🟡 Registration: AuthLoading received', name: 'enhanced_registration_screen');
          } else if (state is AuthError) {
            developer.log('🔴 Registration: AuthError received: \${state.message}', name: 'enhanced_registration_screen');
            // Улучшенная обработка ошибок
            String errorMessage = state.message;

            // Специальная обработка сетевых ошибок
            if (errorMessage.contains('Failed host lookup') ||
                errorMessage.contains('SocketException') ||
                errorMessage.contains('NetworkException')) {
              errorMessage =
                  'Ошибка подключения к серверу. Проверьте интернет-соединение и попробуйте снова.';
            } else if (errorMessage.contains('AuthRetryableFetchException')) {
              errorMessage = 'Сервер временно недоступен. Попробуйте позже.';
            } else if (errorMessage.contains('Invalid login credentials')) {
              errorMessage = 'Неверный email или пароль.';
            } else if (errorMessage.contains('User already registered')) {
              errorMessage = 'Пользователь с таким email уже зарегистрирован.';
            }

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errorMessage),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 5),
                action: SnackBarAction(
                  label: 'OK',
                  textColor: Colors.white,
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                ),
              ),
            );
          } else {
            developer.log(
                '🔵 Registration: Other state received: ${state.runtimeType}', name: 'enhanced_registration_screen');
          }
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF9F4F2),
          appBar: AppBar(
            backgroundColor: const Color(0xFFF9F4F2),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Future.microtask(() {
                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/welcome', (route) => false);
                  }
                });
              },
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 40.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 0),
                    Image.asset('assets/images/logo.png', height: 80),
                    const SizedBox(height: 20),
                    Text(
                      'Регистрация',
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'Создайте аккаунт для доступа к приложению',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        final isLoading = state is AuthLoading;
                        return Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  border: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors.green, width: 2),
                                  ),
                                  errorBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                  focusedErrorBorder:
                                      const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.red, width: 2),
                                  ),
                                  prefixIcon: const Icon(Icons.email),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                enabled: !isLoading,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Пожалуйста, введите email';
                                  }
                                  if (!RegExp(
                                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                      .hasMatch(value)) {
                                    return 'Пожалуйста, введите корректный email';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 24),
                              TextFormField(
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  labelText: 'Пароль',
                                  border: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors.green, width: 2),
                                  ),
                                  errorBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                  focusedErrorBorder:
                                      const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.red, width: 2),
                                  ),
                                  prefixIcon: const Icon(Icons.lock),
                                ),
                                obscureText: true,
                                enabled: !isLoading,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Пожалуйста, введите пароль';
                                  }
                                  if (value.length < 6) {
                                    return 'Пароль должен быть не менее 6 символов';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 24),
                              TextFormField(
                                controller: _confirmPasswordController,
                                decoration: InputDecoration(
                                  labelText: 'Подтвердите пароль',
                                  border: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors.green, width: 2),
                                  ),
                                  errorBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                  focusedErrorBorder:
                                      const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.red, width: 2),
                                  ),
                                  prefixIcon: const Icon(Icons.lock_outline),
                                ),
                                obscureText: true,
                                enabled: !isLoading,
                                validator: (value) {
                                  if (value != _passwordController.text) {
                                    return 'Пароли не совпадают';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 40),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: isLoading
                                      ? null
                                      : () => _register(context),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.button,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: isLoading
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Colors.white)))
                                      : const Text('Зарегистрироваться'),
                                ),
                              ),
                              const SizedBox(height: 30),
                              _buildDivider(),
                              const SizedBox(height: 30),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  onPressed: isLoading
                                      ? null
                                      : () {
                                          Future.microtask(() {
                                            if (context.mounted) {
                                              Navigator.pushReplacementNamed(
                                                  context, '/login');
                                            }
                                          });
                                        },
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: AppColors.button),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: Text(
                                    'Уже есть аккаунт? Войти',
                                    style: TextStyle(color: AppColors.button),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              _buildPrivacyPolicy(context),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey[400])),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'или',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey[400])),
      ],
    );
  }

  Widget _buildPrivacyPolicy(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            'Регистрируясь, вы соглашаетесь с',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: () {
              Future.microtask(() {
                if (context.mounted) {
                  Navigator.pushNamed(context, '/privacy-policy');
                }
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: const Text(
                'Политикой конфиденциальности',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.blue,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
