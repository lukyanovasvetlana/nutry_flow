import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutry_flow/shared/theme/app_colors.dart';
import '../bloc/auth_bloc.dart';
import '../../di/onboarding_dependencies.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(SignUpRequested(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          ));
    } else {}
  }

  void _onRegistrationSuccess(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/profile-info');
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final authBloc = OnboardingDependencies.instance.createAuthBloc();
        return authBloc;
      },
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is AuthAuthenticated) {
            _onRegistrationSuccess(context);
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
                Navigator.pushReplacementNamed(context, '/welcome');
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
                    Image.asset('assets/images/Logo.png', height: 80),
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
                                enabled: state is! AuthLoading,
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
                                enabled: state is! AuthLoading,
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
                                enabled: state is! AuthLoading,
                                validator: (value) {
                                  if (value != _passwordController.text) {
                                    return 'Пароли не совпадают';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 40),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 56.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: state is AuthLoading
                                        ? null
                                        : () {
                                            _register(context);
                                          },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.button,
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      textStyle: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        inherit: false,
                                      ),
                                    ),
                                    child: state is AuthLoading
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Colors.white),
                                            ),
                                          )
                                        : const Text('Зарегистрироваться'),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),

                              // Разделитель
                              Row(
                                children: [
                                  Expanded(
                                      child: Divider(color: Colors.grey[400])),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Text(
                                      'или',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      child: Divider(color: Colors.grey[400])),
                                ],
                              ),
                              const SizedBox(height: 30),

                              // Кнопка входа
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 56.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: OutlinedButton(
                                    onPressed: state is AuthLoading
                                        ? null
                                        : () {
                                            Navigator.pushReplacementNamed(
                                                context, '/login');
                                          },
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                          color: AppColors.button, width: 1.5),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    child: Text(
                                      'Уже есть аккаунт? Войти',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.button,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Политика конфиденциальности
                              Center(
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
                                        Navigator.pushNamed(
                                            context, '/privacy-policy');
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        child: const Text(
                                          'Политикой конфиденциальности',
                                          style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            color: Colors.blue,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),
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
}
