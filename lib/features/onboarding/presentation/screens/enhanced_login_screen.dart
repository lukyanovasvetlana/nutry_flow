import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutry_flow/shared/theme/app_colors.dart';
import '../bloc/auth_bloc.dart';
import '../../di/onboarding_dependencies.dart';
import '../../../analytics/presentation/utils/analytics_tracker.dart';

class EnhancedLoginScreen extends StatefulWidget {
  const EnhancedLoginScreen({Key? key}) : super(key: key);

  @override
  State<EnhancedLoginScreen> createState() => _EnhancedLoginScreenState();
}

class _EnhancedLoginScreenState extends State<EnhancedLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Состояния валидации
  bool _isEmailValid = false;
  bool _isPasswordValid = false;
  bool _showEmailError = false;
  bool _showPasswordError = false;
  bool _obscurePassword = true;

  String? _emailError;
  String? _passwordError;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateEmail);
    _passwordController.addListener(_validatePassword);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateEmail() {
    final email = _emailController.text;
    setState(() {
      if (email.isEmpty) {
        _emailError = 'Введите email адрес';
        _isEmailValid = false;
        _showEmailError = false;
      } else if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
        _emailError = 'Введите корректный email адрес';
        _isEmailValid = false;
        _showEmailError = true;
      } else {
        _emailError = null;
        _isEmailValid = true;
        _showEmailError = false;
      }
    });
  }

  void _validatePassword() {
    final password = _passwordController.text;
    setState(() {
      if (password.isEmpty) {
        _passwordError = 'Введите пароль';
        _isPasswordValid = false;
        _showPasswordError = false;
      } else if (password.length < 6) {
        _passwordError = 'Пароль должен содержать минимум 6 символов';
        _isPasswordValid = false;
        _showPasswordError = true;
      } else {
        _passwordError = null;
        _isPasswordValid = true;
        _showPasswordError = false;
      }
    });
  }

  bool get _isFormValid => _isEmailValid && _isPasswordValid;

  void _login(BuildContext context) {
    if (_isFormValid) {
      // Отслеживаем попытку входа
      AnalyticsTracker.trackLogin(
        method: 'email',
        userId: _emailController.text.trim(),
      );
      
      context.read<AuthBloc>().add(SignInRequested(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ));
    } else {
      setState(() {
        _showEmailError = !_isEmailValid;
        _showPasswordError = !_isPasswordValid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardingDependencies.instance.createAuthBloc(),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            // Отслеживаем успешный вход
            AnalyticsTracker.trackLogin(
              method: 'email',
              userId: state.user?.email,
            );
            Navigator.pushReplacementNamed(context, '/main');
          } else if (state is AuthError) {
            // Отслеживаем ошибку входа
            AnalyticsTracker.trackError(
              errorType: 'login_error',
              errorMessage: state.message,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF9F4F2),
          appBar: AppBar(
            backgroundColor: const Color(0xFFF9F4F2),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pushReplacementNamed(context, '/'),
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
                      'Вход в аккаунт',
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'Войдите в свой аккаунт для доступа к приложению',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey),
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
                              // Email поле
                              _buildEmailField(isLoading),
                              const SizedBox(height: 24),
                              
                              // Пароль поле
                              _buildPasswordField(isLoading),
                              const SizedBox(height: 16),
                              
                              // Забыли пароль
                              _buildForgotPasswordLink(context, isLoading),
                              const SizedBox(height: 40),
                              
                              // Кнопка входа
                              _buildLoginButton(context, isLoading),
                              const SizedBox(height: 30),
                              
                              // Разделитель
                              _buildDivider(),
                              const SizedBox(height: 30),
                              
                              // Кнопка регистрации
                              _buildRegisterButton(context, isLoading),
                              const SizedBox(height: 20),
                              
                              // Политика конфиденциальности
                              _buildPrivacyPolicy(context),
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

  Widget _buildEmailField(bool isLoading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
              borderSide: BorderSide(color: AppColors.green, width: 2),
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
          enabled: !isLoading,
          textInputAction: TextInputAction.next,
        ),
        if (_showEmailError && _emailError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 12),
            child: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 16),
                const SizedBox(width: 4),
                Text(
                  _emailError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildPasswordField(bool isLoading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              borderSide: BorderSide(color: AppColors.green, width: 2),
            ),
            errorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2),
            ),
            prefixIcon: const Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
          ),
          obscureText: _obscurePassword,
          enabled: !isLoading,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _login(context),
        ),
        if (_showPasswordError && _passwordError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 12),
            child: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 16),
                const SizedBox(width: 4),
                Text(
                  _passwordError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildForgotPasswordLink(BuildContext context, bool isLoading) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: isLoading ? null : () {
          Navigator.pushNamed(context, '/forgot-password');
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

  Widget _buildLoginButton(BuildContext context, bool isLoading) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : () => _login(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.button,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            inherit: false,
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

  Widget _buildRegisterButton(BuildContext context, bool isLoading) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed: isLoading ? null : () {
          Navigator.pushReplacementNamed(context, '/registration');
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: AppColors.button, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          'Создать аккаунт',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: AppColors.button,
          ),
        ),
      ),
    );
  }

  Widget _buildPrivacyPolicy(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/privacy-policy');
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