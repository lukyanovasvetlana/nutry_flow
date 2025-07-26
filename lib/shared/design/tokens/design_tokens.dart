import 'package:flutter/material.dart';

/// Дизайн-токены для NutryFlow
/// Создано для интеграции с дизайнером
class DesignTokens {
  // Prevent instantiation
  DesignTokens._();

  /// Цветовая палитра
  static const _ColorTokens colors = _ColorTokens();
  
  /// Типографика
  static const _TypographyTokens typography = _TypographyTokens();
  
  /// Отступы и размеры
  static const _SpacingTokens spacing = _SpacingTokens();
  
  /// Тени
  static const _ShadowTokens shadows = _ShadowTokens();
  
  /// Анимации
  static const _AnimationTokens animations = _AnimationTokens();
  
  /// Границы и радиусы
  static const _BorderTokens borders = _BorderTokens();
}

/// Цветовые токены
class _ColorTokens {
  const _ColorTokens();
  
  // Основные цвета бренда
  Color get primary => const Color(0xFF4CAF50);
  Color get primaryLight => const Color(0xFF81C784);
  Color get primaryDark => const Color(0xFF388E3C);
  
  // Вторичные цвета
  Color get secondary => const Color(0xFFC2E66E);
  Color get secondaryLight => const Color(0xFFE8F5E8);
  Color get secondaryDark => const Color(0xFF8BC34A);
  
  // Акцентные цвета
  Color get accent => const Color(0xFFFFCB65);
  Color get accentLight => const Color(0xFFFFF3C4);
  Color get accentDark => const Color(0xFFFFA000);
  
  // Семантические цвета питания
  Color get protein => const Color(0xFFE91E63);
  Color get carbs => const Color(0xFFFFC107);
  Color get fats => const Color(0xFFFF9800);
  Color get water => const Color(0xFF03A9F4);
  Color get fiber => const Color(0xFF9C27B0);
  
  // Системные цвета
  Color get background => const Color(0xFFF9F4F2);
  Color get surface => const Color(0xFFFFFFFF);
  Color get surfaceVariant => const Color(0xFFF8F9FA);
  Color get outline => const Color(0xFFE0E0E0);
  Color get outlineVariant => const Color(0xFFF1F3F4);
  
  // Текстовые цвета
  Color get onPrimary => const Color(0xFFFFFFFF);
  Color get onSecondary => const Color(0xFF1B5E20);
  Color get onSurface => const Color(0xFF2D3748);
  Color get onSurfaceVariant => const Color(0xFF718096);
  Color get onBackground => const Color(0xFF1C1B1F);
  
  // Состояния
  Color get success => const Color(0xFF4CAF50);
  Color get warning => const Color(0xFFFFA000);
  Color get error => const Color(0xFFE53935);
  Color get info => const Color(0xFF039BE5);
  
  // Цвета для текста на цветных фонах
  Color get onError => const Color(0xFFFFFFFF);
  Color get onSuccess => const Color(0xFFFFFFFF);
  Color get onWarning => const Color(0xFF1B5E20);
  Color get onInfo => const Color(0xFFFFFFFF);
  
  // Тени
  Color get shadow => const Color(0xFF000000);
  
  // Алиасы для nutrition colors
  Color get nutritionProtein => protein;
  Color get nutritionCarbs => carbs;
  Color get nutritionFats => fats;
  Color get nutritionWater => water;
  Color get nutritionFiber => fiber;
  
  // Градиенты
  LinearGradient get primaryGradient => const LinearGradient(
    colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  LinearGradient get secondaryGradient => const LinearGradient(
    colors: [Color(0xFFC2E66E), Color(0xFFE8F5E8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  LinearGradient get accentGradient => const LinearGradient(
    colors: [Color(0xFFFFCB65), Color(0xFFFFF3C4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

/// Типографические токены
class _TypographyTokens {
  const _TypographyTokens();
  
  // Семейство шрифтов
  String get fontFamily => 'Roboto';
  
  // Размеры шрифтов
  double get displayLarge => 57.0;
  double get displayMedium => 45.0;
  double get displaySmall => 36.0;
  
  double get headlineLarge => 32.0;
  double get headlineMedium => 28.0;
  double get headlineSmall => 24.0;
  
  double get titleLarge => 22.0;
  double get titleMedium => 16.0;
  double get titleSmall => 14.0;
  
  double get bodyLarge => 16.0;
  double get bodyMedium => 14.0;
  double get bodySmall => 12.0;
  
  double get labelLarge => 14.0;
  double get labelMedium => 12.0;
  double get labelSmall => 11.0;
  
  // Высота строки
  double get lineHeightTight => 1.2;
  double get lineHeightNormal => 1.4;
  double get lineHeightLoose => 1.6;
  
  // Межбуквенное расстояние
  double get letterSpacingTight => -0.5;
  double get letterSpacingNormal => 0.0;
  double get letterSpacingWide => 0.5;
  
  // Веса шрифтов
  FontWeight get light => FontWeight.w300;
  FontWeight get regular => FontWeight.w400;
  FontWeight get medium => FontWeight.w500;
  FontWeight get semiBold => FontWeight.w600;
  FontWeight get bold => FontWeight.w700;
  
  // Готовые текстовые стили
  TextStyle get displayLargeStyle => TextStyle(
    fontFamily: fontFamily,
    fontSize: displayLarge,
    fontWeight: bold,
    height: lineHeightTight,
  );
  
  TextStyle get displayMediumStyle => TextStyle(
    fontFamily: fontFamily,
    fontSize: displayMedium,
    fontWeight: bold,
    height: lineHeightTight,
  );
  
  TextStyle get displaySmallStyle => TextStyle(
    fontFamily: fontFamily,
    fontSize: displaySmall,
    fontWeight: bold,
    height: lineHeightTight,
  );
  
  TextStyle get headlineLargeStyle => TextStyle(
    fontFamily: fontFamily,
    fontSize: headlineLarge,
    fontWeight: semiBold,
    height: lineHeightNormal,
  );
  
  TextStyle get headlineMediumStyle => TextStyle(
    fontFamily: fontFamily,
    fontSize: headlineMedium,
    fontWeight: semiBold,
    height: lineHeightNormal,
  );
  
  TextStyle get headlineSmallStyle => TextStyle(
    fontFamily: fontFamily,
    fontSize: headlineSmall,
    fontWeight: semiBold,
    height: lineHeightNormal,
  );
  
  TextStyle get titleLargeStyle => TextStyle(
    fontFamily: fontFamily,
    fontSize: titleLarge,
    fontWeight: medium,
    height: lineHeightNormal,
  );
  
  TextStyle get titleMediumStyle => TextStyle(
    fontFamily: fontFamily,
    fontSize: titleMedium,
    fontWeight: medium,
    height: lineHeightNormal,
  );
  
  TextStyle get titleSmallStyle => TextStyle(
    fontFamily: fontFamily,
    fontSize: titleSmall,
    fontWeight: medium,
    height: lineHeightNormal,
  );
  
  TextStyle get bodyLargeStyle => TextStyle(
    fontFamily: fontFamily,
    fontSize: bodyLarge,
    fontWeight: regular,
    height: lineHeightNormal,
  );
  
  TextStyle get bodyMediumStyle => TextStyle(
    fontFamily: fontFamily,
    fontSize: bodyMedium,
    fontWeight: regular,
    height: lineHeightNormal,
  );
  
  TextStyle get bodySmallStyle => TextStyle(
    fontFamily: fontFamily,
    fontSize: bodySmall,
    fontWeight: regular,
    height: lineHeightNormal,
  );
  
  TextStyle get labelLargeStyle => TextStyle(
    fontFamily: fontFamily,
    fontSize: labelLarge,
    fontWeight: medium,
    height: lineHeightNormal,
    letterSpacing: letterSpacingWide,
  );
  
  TextStyle get labelMediumStyle => TextStyle(
    fontFamily: fontFamily,
    fontSize: labelMedium,
    fontWeight: medium,
    height: lineHeightNormal,
    letterSpacing: letterSpacingWide,
  );
  
  TextStyle get labelSmallStyle => TextStyle(
    fontFamily: fontFamily,
    fontSize: labelSmall,
    fontWeight: medium,
    height: lineHeightNormal,
    letterSpacing: letterSpacingWide,
  );
}

/// Токены отступов и размеров
class _SpacingTokens {
  const _SpacingTokens();
  
  // Базовые отступы
  double get xs => 4.0;
  double get sm => 8.0;
  double get md => 16.0;
  double get lg => 24.0;
  double get xl => 32.0;
  double get xxl => 40.0;
  double get xxxl => 48.0;
  
  // Специфичные размеры
  double get buttonHeight => 48.0;
  double get buttonHeightSmall => 36.0;
  double get buttonHeightLarge => 56.0;
  
  double get inputHeight => 48.0;
  double get appBarHeight => 56.0;
  double get bottomNavHeight => 80.0;
  
  double get cardPadding => 16.0;
  double get screenPadding => 24.0;
  double get sectionSpacing => 32.0;
  
  // Размеры иконок
  double get iconSmall => 16.0;
  double get iconMedium => 24.0;
  double get iconLarge => 32.0;
  double get iconXLarge => 48.0;
  
  // Размеры аватаров
  double get avatarSmall => 32.0;
  double get avatarMedium => 48.0;
  double get avatarLarge => 64.0;
  double get avatarXLarge => 96.0;
}

/// Токены теней
class _ShadowTokens {
  const _ShadowTokens();
  
  List<BoxShadow> get none => [];
  
  List<BoxShadow> get xs => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.05),
      blurRadius: 2,
      offset: const Offset(0, 1),
    ),
  ];
  
  List<BoxShadow> get sm => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.1),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];
  
  List<BoxShadow> get md => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.15),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];
  
  List<BoxShadow> get lg => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.2),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];
  
  List<BoxShadow> get xl => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.25),
      blurRadius: 24,
      offset: const Offset(0, 12),
    ),
  ];
}

/// Токены анимаций
class _AnimationTokens {
  const _AnimationTokens();
  
  // Длительности
  Duration get fast => const Duration(milliseconds: 150);
  Duration get normal => const Duration(milliseconds: 300);
  Duration get slow => const Duration(milliseconds: 500);
  Duration get slower => const Duration(milliseconds: 1000);
  
  // Кривые анимации
  Curve get easeIn => Curves.easeIn;
  Curve get easeOut => Curves.easeOut;
  Curve get easeInOut => Curves.easeInOut;
  Curve get bounceIn => Curves.bounceIn;
  Curve get bounceOut => Curves.bounceOut;
  Curve get elasticIn => Curves.elasticIn;
  Curve get elasticOut => Curves.elasticOut;
}

/// Токены границ и радиусов
class _BorderTokens {
  const _BorderTokens();
  
  // Радиусы скругления
  double get none => 0.0;
  double get xs => 4.0;
  double get sm => 8.0;
  double get md => 12.0;
  double get lg => 16.0;
  double get xl => 24.0;
  double get xxl => 32.0;
  double get full => 9999.0;
  
  // Ширина границ
  double get thin => 1.0;
  double get medium => 2.0;
  double get thick => 4.0;
  
  // Радиусы для специфичных элементов
  BorderRadius get buttonRadius => BorderRadius.circular(md);
  BorderRadius get cardRadius => BorderRadius.circular(lg);
  BorderRadius get inputRadius => BorderRadius.circular(sm);
  BorderRadius get modalRadius => BorderRadius.circular(xl);
}

/// Удобные геттеры для быстрого доступа
extension DesignTokensExtension on BuildContext {
  _ColorTokens get colors => DesignTokens.colors;
  _TypographyTokens get typography => DesignTokens.typography;
  _SpacingTokens get spacing => DesignTokens.spacing;
  _ShadowTokens get shadows => DesignTokens.shadows;
  _AnimationTokens get animations => DesignTokens.animations;
  _BorderTokens get borders => DesignTokens.borders;
} 