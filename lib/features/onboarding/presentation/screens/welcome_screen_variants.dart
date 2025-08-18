import 'package:flutter/material.dart';
import 'package:nutry_flow/core/services/ab_testing_service.dart';
import 'package:nutry_flow/shared/theme/app_colors.dart';
import 'package:nutry_flow/shared/theme/app_styles.dart';

/// Контрольный вариант экрана приветствия
class WelcomeScreenControl extends StatelessWidget {
  const WelcomeScreenControl({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primary, AppColors.secondary],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                // Логотип
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(60),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: const Icon(
                      Icons.restaurant_menu,
                      size: 60,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                // Заголовок
                Text(
                  'Добро пожаловать в Nutrigo',
                  style: AppStyles.headline4.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 100), // Увеличил с 16 до 40
                // Подзаголовок
                Text(
                  'Ваш персональный помощник для здорового питания и активного образа жизни',
                  style: AppStyles.body1.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 80), // Увеличил с 32 до 50
                // Кнопки
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          ABTestingService.instance.trackExperimentConversion(
                            experimentName: 'welcome_screen',
                            variant: 'control',
                            conversionType: 'registration_click',
                          );
                          Navigator.pushNamed(context, '/registration');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Начать',
                          style: AppStyles.button.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        ABTestingService.instance.trackExperimentConversion(
                          experimentName: 'welcome_screen',
                          variant: 'control',
                          conversionType: 'login_click',
                        );
                        Navigator.pushNamed(context, '/login');
                      },
                      child: Text(
                        'Уже есть аккаунт? Войти',
                        style: AppStyles.body2.copyWith(
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Вариант A экрана приветствия
class WelcomeScreenVariantA extends StatelessWidget {
  const WelcomeScreenVariantA({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Логотип с анимацией
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                  ),
                  borderRadius: BorderRadius.circular(70),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 30,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(70),
                  child: Image.asset(
                    'assets/images/nutrigo_logo.png',
                    width: 70,
                    height: 70,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // Заголовок
              Text(
                'Nutrigo',
                style: AppStyles.headline3.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // Подзаголовок
              Text(
                'Достигайте своих целей в питании и фитнесе с помощью персонализированных рекомендаций',
                style: AppStyles.body1.copyWith(
                  color: Colors.grey[600],
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                  height: 80), // Увеличил отступ между текстом и кнопками
              // Кнопки
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ABTestingService.instance.trackExperimentConversion(
                          experimentName: 'welcome_screen',
                          variant: 'variant_a',
                          conversionType: 'registration_click',
                        );
                        Navigator.pushNamed(context, '/registration');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                      ),
                      child: Text(
                        'Создать аккаунт',
                        style: AppStyles.button.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        ABTestingService.instance.trackExperimentConversion(
                          experimentName: 'welcome_screen',
                          variant: 'variant_a',
                          conversionType: 'login_click',
                        );
                        Navigator.pushNamed(context, '/login');
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'Войти',
                        style: AppStyles.button.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Вариант B экрана приветствия
class WelcomeScreenVariantB extends StatelessWidget {
  const WelcomeScreenVariantB({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary,
              AppColors.secondary,
              Colors.purple.shade400,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const Spacer(),
                // Анимированный логотип
                Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(80),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.health_and_safety,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 48),
                // Заголовок
                Text(
                  'Здоровье начинается здесь',
                  style: AppStyles.headline3.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                // Подзаголовок
                Text(
                  'Присоединяйтесь к тысячам пользователей, которые уже изменили свою жизнь с Nutrigo',
                  style: AppStyles.body1.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                    height: 150), // Увеличил отступ между текстом и кнопками
                // Кнопки
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          ABTestingService.instance.trackExperimentConversion(
                            experimentName: 'welcome_screen',
                            variant: 'variant_b',
                            conversionType: 'registration_click',
                          );
                          Navigator.pushNamed(context, '/registration');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 8,
                        ),
                        child: Text(
                          'Начать бесплатно',
                          style: AppStyles.button.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        ABTestingService.instance.trackExperimentConversion(
                          experimentName: 'welcome_screen',
                          variant: 'variant_b',
                          conversionType: 'login_click',
                        );
                        Navigator.pushNamed(context, '/login');
                      },
                      child: Text(
                        'Уже есть аккаунт?',
                        style: AppStyles.body2.copyWith(
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
