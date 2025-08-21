import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nutry_flow/shared/theme/app_colors.dart';

class WelcomeScreenRedesigned extends StatefulWidget {
  const WelcomeScreenRedesigned({super.key});

  @override
  State<WelcomeScreenRedesigned> createState() =>
      _WelcomeScreenRedesignedState();
}

class _WelcomeScreenRedesignedState extends State<WelcomeScreenRedesigned> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 80,
                height: 80,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 40),
              Text(
                'Добро пожаловать в NutryFlow',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              Text(
                'Ваш персональный помощник в мире здорового питания',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: Colors.grey),
              ),
              const SizedBox(height: 60),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.go('/registration');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.button,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('Начать'),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    context.go('/login');
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.button),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Войти',
                    style: TextStyle(color: AppColors.button),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
