import 'package:flutter/material.dart';
import 'theme_tokens.dart';

/// Дизайн-токены для NutryFlow
/// Создано для интеграции с дизайнером
class DesignTokens {
  // Prevent instantiation
  DesignTokens._();

  /// Цветовая палитра (статические значения для градиентов и констант)
  /// Для динамических цветов в UI используйте extension через BuildContext:
  /// `context.colors.primary` вместо `DesignTokens.colors.primary`
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

  // Семейство шрифтов (унифицировано с ThemeManager)
  String get fontFamily => 'Inter';

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
  double get buttonRadius => md;
  double get cardRadius => lg;
  double get inputRadius => sm;
  double get modalRadius => xl;
}

/// Удобные геттеры для быстрого доступа
/// ВАЖНО: Используйте эти extension для получения динамических цветов,
/// которые автоматически обновляются при смене темы
extension DesignTokensExtension on BuildContext {
  /// Динамические цвета (автоматически обновляются при смене темы)
  /// Используйте вместо DesignTokens.colors для UI элементов
  _DynamicColorTokens get colors => _DynamicColorTokens();

  _TypographyTokens get typography => DesignTokens.typography;
  _SpacingTokens get spacing => DesignTokens.spacing;
  _ShadowTokens get shadows => DesignTokens.shadows;
  _AnimationTokens get animations => DesignTokens.animations;
  _BorderTokens get borders => DesignTokens.borders;
}

/// Динамические цветовые токены через BuildContext
/// Автоматически получают цвета из текущей темы
class _DynamicColorTokens {
  _DynamicColorTokens();

  // Получаем токены текущей темы
  BaseThemeTokens get _theme => ThemeTokens.current;

  // Основные цвета бренда (динамические)
  Color get primary => _theme.primary;
  Color get primaryLight => _theme.primaryContainer;
  Color get primaryDark => _theme.primary;

  // Вторичные цвета (динамические)
  Color get secondary => _theme.secondary;
  Color get secondaryLight => _theme.secondaryContainer;
  Color get secondaryDark => _theme.secondary;

  // Акцентные цвета (динамические)
  Color get accent => _theme.tertiary;
  Color get accentLight => _theme.tertiaryContainer;
  Color get accentDark => _theme.tertiary;

  // Семантические цвета питания (статические, одинаковые для обеих тем)
  Color get protein => const Color(0xFFE91E63);
  Color get carbs => const Color(0xFFFFC107);
  Color get fats => const Color(0xFFFF9800);
  Color get water => const Color(0xFF03A9F4);
  Color get fiber => const Color(0xFF9C27B0);

  // Системные цвета (динамические)
  Color get background => _theme.background;
  Color get surface => _theme.surface;
  Color get surfaceVariant => _theme.surfaceVariant;
  Color get outline => _theme.outline;
  Color get outlineVariant => _theme.outlineVariant;

  // Текстовые цвета (динамические)
  Color get onPrimary => _theme.onPrimary;
  Color get onSecondary => _theme.onSecondary;
  Color get onSurface => _theme.onSurface;
  Color get onSurfaceVariant => _theme.onSurfaceVariant;
  Color get onBackground => _theme.onBackground;

  // Состояния (динамические)
  Color get success => _theme.success;
  Color get warning => _theme.warning;
  Color get error => _theme.error;
  Color get info => _theme.info;

  // Цвета для текста на цветных фонах (динамические)
  Color get onError => _theme.onError;
  Color get onSuccess => _theme.onSuccess;
  Color get onWarning => _theme.onWarning;
  Color get onInfo => _theme.onInfo;

  // Тени (статические)
  Color get shadow => const Color(0xFF000000);

  // Алиасы для nutrition colors
  Color get nutritionProtein => protein;
  Color get nutritionCarbs => carbs;
  Color get nutritionFats => fats;
  Color get nutritionWater => water;
  Color get nutritionFiber => fiber;

  // Градиенты (динамические из текущей темы)
  LinearGradient get primaryGradient => _theme.primaryGradient;
  LinearGradient get secondaryGradient => _theme.secondaryGradient;
  LinearGradient get accentGradient => _theme.tertiaryGradient;
}
