import 'package:flutter/material.dart';

/// Токены тем для NutryFlow
/// Поддерживает светлую и темную тему
class ThemeTokens {
  // Prevent instantiation
  ThemeTokens._();

  /// Светлая тема
  static const _LightThemeTokens light = _LightThemeTokens();

  /// Темная тема
  static const _DarkThemeTokens dark = _DarkThemeTokens();

  /// Текущая тема (по умолчанию светлая)
  static ThemeMode currentTheme = ThemeMode.light;

  /// Переключатель темы
  static void toggleTheme() {
    currentTheme =
        currentTheme == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }

  /// Получить токены текущей темы
  static BaseThemeTokens get current =>
      currentTheme == ThemeMode.light ? light : dark;
}

/// Базовые токены темы
abstract class BaseThemeTokens {
  const BaseThemeTokens();

  // Цвета фона
  Color get background;
  Color get surface;
  Color get surfaceVariant;
  Color get surfaceContainer;

  // Цвета текста
  Color get onBackground;
  Color get onSurface;
  Color get onSurfaceVariant;
  Color get onSurfaceContainer;

  // Цвета границ
  Color get outline;
  Color get outlineVariant;

  // Цвета состояний
  Color get primary;
  Color get onPrimary;
  Color get primaryContainer;
  Color get onPrimaryContainer;

  Color get secondary;
  Color get onSecondary;
  Color get secondaryContainer;
  Color get onSecondaryContainer;

  Color get tertiary;
  Color get onTertiary;
  Color get tertiaryContainer;
  Color get onTertiaryContainer;

  // Семантические цвета
  Color get error;
  Color get onError;
  Color get errorContainer;
  Color get onErrorContainer;

  Color get success;
  Color get onSuccess;
  Color get successContainer;
  Color get onSuccessContainer;

  Color get warning;
  Color get onWarning;
  Color get warningContainer;
  Color get onWarningContainer;

  Color get info;
  Color get onInfo;
  Color get infoContainer;
  Color get onInfoContainer;

  // Цвета питания
  Color get nutritionProtein;
  Color get nutritionCarbs;
  Color get nutritionFats;
  Color get nutritionWater;
  Color get nutritionFiber;

  // Тени
  Color get shadow;
  Color get shadowScrim;

  // Градиенты
  LinearGradient get primaryGradient;
  LinearGradient get secondaryGradient;
  LinearGradient get tertiaryGradient;
  LinearGradient get errorGradient;
  LinearGradient get successGradient;
}

/// Токены светлой темы
class _LightThemeTokens extends BaseThemeTokens {
  const _LightThemeTokens();

  @override
  Color get background => const Color(0xFFF9F4F2);

  @override
  Color get surface => const Color(0xFFFFFFFF);

  @override
  Color get surfaceVariant => const Color(0xFFF8F9FA);

  @override
  Color get surfaceContainer => const Color(0xFFF0F0F0);

  @override
  Color get onBackground => const Color(0xFF1C1B1F);

  @override
  Color get onSurface => const Color(0xFF2D3748);

  @override
  Color get onSurfaceVariant => const Color(0xFF718096);

  @override
  Color get onSurfaceContainer => const Color(0xFF4A5568);

  @override
  Color get outline => const Color(0xFFE0E0E0);

  @override
  Color get outlineVariant => const Color(0xFFF1F3F4);

  @override
  Color get primary => const Color(0xFF4CAF50);

  @override
  Color get onPrimary => const Color(0xFFFFFFFF);

  @override
  Color get primaryContainer => const Color(0xFFE8F5E8);

  @override
  Color get onPrimaryContainer => const Color(0xFF1B5E20);

  @override
  Color get secondary => const Color(0xFFC2E66E);

  @override
  Color get onSecondary => const Color(0xFF1B5E20);

  @override
  Color get secondaryContainer => const Color(0xFFE8F5E8);

  @override
  Color get onSecondaryContainer => const Color(0xFF2D3748);

  @override
  Color get tertiary => const Color(0xFFFFCB65);

  @override
  Color get onTertiary => const Color(0xFF1B5E20);

  @override
  Color get tertiaryContainer => const Color(0xFFFFF3C4);

  @override
  Color get onTertiaryContainer => const Color(0xFF2D3748);

  @override
  Color get error => const Color(0xFFE53935);

  @override
  Color get onError => const Color(0xFFFFFFFF);

  @override
  Color get errorContainer => const Color(0xFFFFEBEE);

  @override
  Color get onErrorContainer => const Color(0xFFC62828);

  @override
  Color get success => const Color(0xFF4CAF50);

  @override
  Color get onSuccess => const Color(0xFFFFFFFF);

  @override
  Color get successContainer => const Color(0xFFE8F5E8);

  @override
  Color get onSuccessContainer => const Color(0xFF1B5E20);

  @override
  Color get warning => const Color(0xFFFFA000);

  @override
  Color get onWarning => const Color(0xFF1B5E20);

  @override
  Color get warningContainer => const Color(0xFFFFF3C4);

  @override
  Color get onWarningContainer => const Color(0xFF2D3748);

  @override
  Color get info => const Color(0xFF039BE5);

  @override
  Color get onInfo => const Color(0xFFFFFFFF);

  @override
  Color get infoContainer => const Color(0xFFE3F2FD);

  @override
  Color get onInfoContainer => const Color(0xFF0277BD);

  @override
  Color get nutritionProtein => const Color(0xFFE91E63);

  @override
  Color get nutritionCarbs => const Color(0xFFFFC107);

  @override
  Color get nutritionFats => const Color(0xFFFF9800);

  @override
  Color get nutritionWater => const Color(0xFF03A9F4);

  @override
  Color get nutritionFiber => const Color(0xFF9C27B0);

  @override
  Color get shadow => const Color(0xFF000000);

  @override
  Color get shadowScrim => const Color(0x80000000);

  @override
  LinearGradient get primaryGradient => const LinearGradient(
        colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  @override
  LinearGradient get secondaryGradient => const LinearGradient(
        colors: [Color(0xFFC2E66E), Color(0xFFE8F5E8)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  @override
  LinearGradient get tertiaryGradient => const LinearGradient(
        colors: [Color(0xFFFFCB65), Color(0xFFFFF3C4)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  @override
  LinearGradient get errorGradient => const LinearGradient(
        colors: [Color(0xFFE53935), Color(0xFFFFCDD2)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  @override
  LinearGradient get successGradient => const LinearGradient(
        colors: [Color(0xFF4CAF50), Color(0xFFE8F5E8)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
}

/// Токены темной темы
class _DarkThemeTokens extends BaseThemeTokens {
  const _DarkThemeTokens();

  @override
  Color get background =>
      const Color(0xFF0F1419); // Более мягкий темно-синий фон

  @override
  Color get surface => const Color(0xFF1A1F2E); // Темно-синий с оттенком

  @override
  Color get surfaceVariant =>
      const Color(0xFF2A3142); // Более светлый вариант поверхности

  @override
  Color get surfaceContainer =>
      const Color(0xFF3A4152); // Контейнер с хорошим контрастом

  @override
  Color get onBackground =>
      const Color(0xFFF8F9FA); // Почти белый для лучшей читаемости

  @override
  Color get onSurface => const Color(0xFFFFFFFF); // Белый текст

  @override
  Color get onSurfaceVariant => const Color(0xFFB8C5D6); // Мягкий серо-голубой

  @override
  Color get onSurfaceContainer =>
      const Color(0xFFE8EDF7); // Светлый текст на контейнерах

  @override
  Color get outline => const Color(0xFF4A5568); // Более светлые границы

  @override
  Color get outlineVariant => const Color(0xFF5A6478); // Вариант границ

  @override
  Color get primary => const Color(0xFF4ADE80); // Яркий зеленый

  @override
  Color get onPrimary => const Color(0xFF0F172A); // Темный текст на зеленом

  @override
  Color get primaryContainer =>
      const Color(0xFF166534); // Темно-зеленый контейнер

  @override
  Color get onPrimaryContainer =>
      const Color(0xFFDCFCE7); // Светло-зеленый текст

  @override
  Color get secondary => const Color(0xFF60A5FA); // Яркий синий

  @override
  Color get onSecondary => const Color(0xFF0F172A); // Темный текст на синем

  @override
  Color get secondaryContainer =>
      const Color(0xFF1E40AF); // Темно-синий контейнер

  @override
  Color get onSecondaryContainer =>
      const Color(0xFFDBEAFE); // Светло-синий текст

  @override
  Color get tertiary => const Color(0xFFFBBF24); // Яркий желтый

  @override
  Color get onTertiary => const Color(0xFF0F172A); // Темный текст на желтом

  @override
  Color get tertiaryContainer =>
      const Color(0xFFD97706); // Темно-оранжевый контейнер

  @override
  Color get onTertiaryContainer =>
      const Color(0xFFFEF3C7); // Светло-желтый текст

  @override
  Color get error => const Color(0xFFEF4444); // Яркий красный

  @override
  Color get onError => const Color(0xFFFFFFFF); // Белый текст на красном

  @override
  Color get errorContainer =>
      const Color(0xFF7F1D1D); // Темно-красный контейнер

  @override
  Color get onErrorContainer => const Color(0xFFFEE2E2); // Светло-красный текст

  @override
  Color get success => const Color(0xFF22C55E); // Яркий зеленый

  @override
  Color get onSuccess => const Color(0xFF0F172A); // Темный текст на зеленом

  @override
  Color get successContainer =>
      const Color(0xFF14532D); // Темно-зеленый контейнер

  @override
  Color get onSuccessContainer =>
      const Color(0xFFDCFCE7); // Светло-зеленый текст

  @override
  Color get warning => const Color(0xFFF59E0B); // Яркий оранжевый

  @override
  Color get onWarning => const Color(0xFF0F172A); // Темный текст на оранжевом

  @override
  Color get warningContainer =>
      const Color(0xFF92400E); // Темно-оранжевый контейнер

  @override
  Color get onWarningContainer =>
      const Color(0xFFFEF3C7); // Светло-желтый текст

  @override
  Color get info => const Color(0xFF3B82F6); // Яркий синий

  @override
  Color get onInfo => const Color(0xFFFFFFFF); // Белый текст на синем

  @override
  Color get infoContainer => const Color(0xFF1E40AF); // Темно-синий контейнер

  @override
  Color get onInfoContainer => const Color(0xFFDBEAFE); // Светло-синий текст

  @override
  Color get nutritionProtein => const Color(0xFFEC4899); // Яркий розовый

  @override
  Color get nutritionCarbs => const Color(0xFFF59E0B); // Яркий оранжевый

  @override
  Color get nutritionFats => const Color(0xFFF97316); // Яркий оранжевый

  @override
  Color get nutritionWater => const Color(0xFF06B6D4); // Яркий голубой

  @override
  Color get nutritionFiber => const Color(0xFFA855F7); // Яркий фиолетовый

  @override
  Color get shadow => const Color(0xFF000000);

  @override
  Color get shadowScrim => const Color(0x80000000);

  @override
  LinearGradient get primaryGradient => const LinearGradient(
        colors: [Color(0xFF4ADE80), Color(0xFF22C55E)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  @override
  LinearGradient get secondaryGradient => const LinearGradient(
        colors: [Color(0xFF60A5FA), Color(0xFF3B82F6)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  @override
  LinearGradient get tertiaryGradient => const LinearGradient(
        colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  @override
  LinearGradient get errorGradient => const LinearGradient(
        colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  @override
  LinearGradient get successGradient => const LinearGradient(
        colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
}

/// Удобные геттеры для быстрого доступа к текущей теме
extension ThemeTokensExtension on BuildContext {
  BaseThemeTokens get theme => ThemeTokens.current;

  // Цвета фона
  Color get background => theme.background;
  Color get surface => theme.surface;
  Color get surfaceVariant => theme.surfaceVariant;
  Color get surfaceContainer => theme.surfaceContainer;

  // Цвета текста
  Color get onBackground => theme.onBackground;
  Color get onSurface => theme.onSurface;
  Color get onSurfaceVariant => theme.onSurfaceVariant;
  Color get onSurfaceContainer => theme.onSurfaceContainer;

  // Цвета границ
  Color get outline => theme.outline;
  Color get outlineVariant => theme.outlineVariant;

  // Основные цвета
  Color get primary => theme.primary;
  Color get onPrimary => theme.onPrimary;
  Color get primaryContainer => theme.primaryContainer;
  Color get onPrimaryContainer => theme.onPrimaryContainer;

  Color get secondary => theme.secondary;
  Color get onSecondary => theme.onSecondary;
  Color get secondaryContainer => theme.secondaryContainer;
  Color get onSecondaryContainer => theme.onSecondaryContainer;

  Color get tertiary => theme.tertiary;
  Color get onTertiary => theme.onTertiary;
  Color get tertiaryContainer => theme.tertiaryContainer;
  Color get onTertiaryContainer => theme.onTertiaryContainer;

  // Семантические цвета
  Color get error => theme.error;
  Color get onError => theme.onError;
  Color get errorContainer => theme.errorContainer;
  Color get onErrorContainer => theme.onErrorContainer;

  Color get success => theme.success;
  Color get onSuccess => theme.onSuccess;
  Color get successContainer => theme.successContainer;
  Color get onSuccessContainer => theme.onSuccessContainer;

  Color get warning => theme.warning;
  Color get onWarning => theme.onWarning;
  Color get warningContainer => theme.warningContainer;
  Color get onWarningContainer => theme.onWarningContainer;

  Color get info => theme.info;
  Color get onInfo => theme.onInfo;
  Color get infoContainer => theme.infoContainer;
  Color get onInfoContainer => theme.onInfoContainer;

  // Цвета питания
  Color get nutritionProtein => theme.nutritionProtein;
  Color get nutritionCarbs => theme.nutritionCarbs;
  Color get nutritionFats => theme.nutritionFats;
  Color get nutritionWater => theme.nutritionWater;
  Color get nutritionFiber => theme.nutritionFiber;

  // Тени
  Color get shadow => theme.shadow;
  Color get shadowScrim => theme.shadowScrim;

  // Градиенты
  LinearGradient get primaryGradient => theme.primaryGradient;
  LinearGradient get secondaryGradient => theme.secondaryGradient;
  LinearGradient get tertiaryGradient => theme.tertiaryGradient;
  LinearGradient get errorGradient => theme.errorGradient;
  LinearGradient get successGradient => theme.successGradient;
}
