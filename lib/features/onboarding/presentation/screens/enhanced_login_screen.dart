import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;
import '../bloc/auth_bloc.dart';
import '../../di/onboarding_dependencies.dart';

class EnhancedLoginScreen extends StatefulWidget {
  const EnhancedLoginScreen({super.key});

  @override
  State<EnhancedLoginScreen> createState() => _EnhancedLoginScreenState();
}

class _EnhancedLoginScreenState extends State<EnhancedLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    try {
      developer.log('🔵 Login: Attempting login...', name: 'enhanced_login_screen');
      context.read<AuthBloc>().add(SignInRequested(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          ));
    } catch (e) {
      developer.log('🔴 Login: Error during login: \$e', name: 'enhanced_login_screen');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        developer.log('🔵 Login: Creating AuthBloc via OnboardingDependencies', name: 'enhanced_login_screen');
        final authBloc = OnboardingDependencies.instance.createAuthBloc();
        developer.log('🔵 Login: AuthBloc created: \${authBloc.runtimeType}', name: 'enhanced_login_screen');
        return authBloc;
      },
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          developer.log(
              '🔵 Login: BlocListener received state: ${state.runtimeType}', name: 'enhanced_login_screen');

          if (state is AuthAuthenticated) {
            developer.log(
                '🟢 Login: User authenticated, navigating to app', name: 'enhanced_login_screen');
            developer.log(
                '🟢 Login: User email: ${state.user.email}', name: 'enhanced_login_screen');
            developer.log(
                '🟢 Login: Context mounted: ${context.mounted}', name: 'enhanced_login_screen');
            // Используем небольшую задержку для обеспечения готовности контекста
            Future.delayed(const Duration(milliseconds: 100), () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (context.mounted) {
                  developer.log(
                      '🟢 Login: Executing navigation to /app', name: 'enhanced_login_screen');
                  try {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/app', (route) => false);
                    developer.log(
                        '🟢 Login: Navigation completed', name: 'enhanced_login_screen');
                  } catch (e) {
                    developer.log(
                        '🔴 Login: Navigation error: $e', name: 'enhanced_login_screen');
                    // Пробуем альтернативный способ навигации
                    try {
                      Navigator.of(context).pushReplacementNamed('/app');
                      developer.log(
                          '🟢 Login: Alternative navigation completed', name: 'enhanced_login_screen');
                    } catch (e2) {
                      developer.log(
                          '🔴 Login: Alternative navigation also failed: $e2', name: 'enhanced_login_screen');
                    }
                  }
                } else {
                  developer.log(
                      '🔴 Login: Context not mounted, cannot navigate', name: 'enhanced_login_screen');
                }
              });
            });
          } else if (state is AuthLoading) {
            developer.log('🟡 Login: AuthLoading received', name: 'enhanced_login_screen');
          } else if (state is AuthError) {
            developer.log('🔴 Login: AuthError received: \${state.message}', name: 'enhanced_login_screen');
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
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final isLoading = state is AuthLoading;
            return Scaffold(
              backgroundColor: const Color(0xFFF9F4F2),
              appBar: AppBar(
                backgroundColor: const Color(0xFFF9F4F2),
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
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
                          'Вход в аккаунт',
                          style: Theme.of(context).textTheme.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30),
                        Text(
                          'Войдите в свой аккаунт для доступа к приложению',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        Form(
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
                                    borderSide:
                                        BorderSide(color: Colors.green, width: 2),
                                  ),
                                  errorBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                  focusedErrorBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red, width: 2),
                                  ),
                                  prefixIcon: const Icon(Icons.email),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
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
                                    borderSide:
                                        BorderSide(color: Colors.green, width: 2),
                                  ),
                                  errorBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                  focusedErrorBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red, width: 2),
                                  ),
                                  prefixIcon: const Icon(Icons.lock),
                                  suffixIcon: IconButton(
                                    icon: Icon(_obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                    onPressed: () => setState(
                                        () => _obscurePassword = !_obscurePassword),
                                  ),
                                ),
                                obscureText: _obscurePassword,
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (_) => _login(context),
                              ),
                              const SizedBox(height: 16),
                              _buildForgotPasswordLink(),
                              const SizedBox(height: 40),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: isLoading ? null : () => _login(context),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
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
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                          ),
                                        )
                                      : const Text('Войти'),
                                ),
                              ),
                              const SizedBox(height: 30),
                              _buildDivider(),
                              const SizedBox(height: 30),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  onPressed: () {
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      if (context.mounted) {
                                        Navigator.pushReplacementNamed(
                                            context, '/registration');
                                      }
                                    });
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: Colors.green),
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: Text(
                                    'Создать аккаунт',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              _buildPrivacyPolicy(context),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildForgotPasswordLink() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              Navigator.pushNamed(context, '/forgot-password');
            }
          });
        },
        child: const Text(
          'Забыли пароль?',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 14,
            fontWeight: FontWeight.w500,
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
      child: GestureDetector(
        onTap: () {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              Navigator.pushNamed(context, '/privacy-policy');
            }
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: const Text(
            'Политика конфиденциальности',
            style: TextStyle(
              decoration: TextDecoration.underline,
              color: Colors.blue,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
