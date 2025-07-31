import 'package:flutter/material.dart';
import 'package:nutry_flow/shared/theme/app_colors.dart';
import 'package:nutry_flow/core/services/ab_testing_service.dart';
import 'package:nutry_flow/features/onboarding/presentation/screens/welcome_screen_variants.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    _trackExperimentExposure();
  }

  void _trackExperimentExposure() {
    final variant = ABTestingService.instance.getWelcomeScreenVariant();
    ABTestingService.instance.trackExperimentExposure(
      experimentName: 'welcome_screen',
      variant: variant,
      parameters: {
        'screen': 'welcome_screen',
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final variant = ABTestingService.instance.getWelcomeScreenVariant();
    
    // Отслеживаем показ эксперимента
    ABTestingService.instance.trackExperimentExposure(
      experimentName: 'welcome_screen',
      variant: variant,
    );

    // Возвращаем соответствующий вариант экрана
    switch (variant) {
      case 'variant_a':
        return const WelcomeScreenVariantA();
      case 'variant_b':
        return const WelcomeScreenVariantB();
      case 'control':
      default:
        return const WelcomeScreenControl();
    }
  }
} 
