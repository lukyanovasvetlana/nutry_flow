import 'package:flutter/material.dart';
import 'app_colors_dark.dart';
import 'theme_manager.dart';

/// Основные цвета NutryFlow с поддержкой светлой и темной темы
class AppColors {
  // Основные цвета бренда
  static const primary = Color(0xFF4CAF50); // Основной цвет приложения
  static const secondary = Color(0xFF81C784); // Вторичный цвет
  static const green = Color(0xFFC2E66E);
  static const yellow = Color(0xFFFFCB65);
  static const orange = Color(0xFFFFA257);
  static const blue = Color(0xFF3B82F6); // Синий цвет
  static const purple = Color(0xFF8B5CF6); // Фиолетовый цвет
  static const teal = Color(0xFF14B8A6); // Бирюзовый цвет
  static const button = Color(0xFF4CAF50); // Цвет кнопок
  static const gray = Color(0xFFB39DDB); // Лавандовый цвет

  // Системные цвета
  static const background = Color(0xFFF9F4F2); // Основной фон
  static const surface = Color(0xFFFFFFFF); // Поверхности (карточки)
  static const surfaceVariant = Color(0xFFF8F9FA); // Альтернативный фон

  // Текстовые цвета
  static const textPrimary = Color(0xFF2D3748); // Основной текст
  static const textSecondary = Color(0xFF718096); // Вторичный текст
  static const textTertiary = Color(0xFFBDBDBD); // Третичный текст

  // Границы и разделители
  static const border = Color(0xFFE0E0E0); // Границы
  static const borderLight = Color(0xFFF1F3F4); // Светлые границы

  // Тени
  static const shadow = Color(0xFF000000); // Тень

  // Состояния
  static const success = Color(0xFF4CAF50);
  static const error = Color(0xFFE53935);
  static const warning = Color(0xFFFFA000);
  static const info = Color(0xFF039BE5);

  // Геттеры для динамического переключения тем
  static Color get dynamicPrimary =>
      _isDarkMode ? AppColorsDark.primary : primary;
  static Color get dynamicSecondary =>
      _isDarkMode ? AppColorsDark.secondary : secondary;
  static Color get dynamicGreen => _isDarkMode ? AppColorsDark.green : green;
  static Color get dynamicYellow => _isDarkMode ? AppColorsDark.yellow : yellow;
  static Color get dynamicOrange => _isDarkMode ? AppColorsDark.orange : orange;
  static Color get dynamicBlue => _isDarkMode ? AppColorsDark.blue : blue;
  static Color get dynamicPurple => _isDarkMode ? AppColorsDark.purple : purple;
  static Color get dynamicTeal => _isDarkMode ? AppColorsDark.teal : teal;
  static Color get dynamicButton => _isDarkMode ? AppColorsDark.button : button;
  static Color get dynamicGray => _isDarkMode ? AppColorsDark.gray : gray;

  static Color get dynamicBackground =>
      _isDarkMode ? AppColorsDark.background : background;
  static Color get dynamicSurface =>
      _isDarkMode ? AppColorsDark.surface : surface;
  static Color get dynamicSurfaceVariant =>
      _isDarkMode ? AppColorsDark.surfaceVariant : surfaceVariant;
  static Color get dynamicCard => _isDarkMode
      ? AppColorsDark.card
      : surface; // Для карточек используем surface в светлой теме

  static Color get dynamicTextPrimary =>
      _isDarkMode ? AppColorsDark.textPrimary : textPrimary;
  static Color get dynamicTextSecondary =>
      _isDarkMode ? AppColorsDark.textSecondary : textSecondary;
  static Color get dynamicTextTertiary =>
      _isDarkMode ? AppColorsDark.textTertiary : textTertiary;

  static Color get dynamicBorder => _isDarkMode ? AppColorsDark.border : border;
  static Color get dynamicBorderLight =>
      _isDarkMode ? AppColorsDark.borderLight : borderLight;

  static Color get dynamicSuccess =>
      _isDarkMode ? AppColorsDark.success : success;
  static Color get dynamicError => _isDarkMode ? AppColorsDark.error : error;
  static Color get dynamicWarning =>
      _isDarkMode ? AppColorsDark.warning : warning;
  static Color get dynamicInfo => _isDarkMode ? AppColorsDark.info : info;
  static Color get dynamicShadow => _isDarkMode ? AppColorsDark.shadow : shadow;

  // Дополнительные цвета для совместимости
  static Color get dynamicOnPrimary =>
      _isDarkMode ? AppColorsDark.textPrimary : Colors.white;
  static Color get dynamicOnSecondary =>
      _isDarkMode ? AppColorsDark.textPrimary : Colors.white;
  static Color get dynamicTertiary =>
      _isDarkMode ? AppColorsDark.orange : orange;
  static Color get dynamicNutritionWater =>
      _isDarkMode ? AppColorsDark.info : info;
  static Color get dynamicNutritionFiber =>
      _isDarkMode ? AppColorsDark.gray : gray;

  // Цвета для аналитики
  static Color get dynamicOnSurface =>
      _isDarkMode ? AppColorsDark.textPrimary : textPrimary;
  static Color get dynamicOnBackground =>
      _isDarkMode ? AppColorsDark.textPrimary : textPrimary;
  static Color get dynamicOnSurfaceVariant =>
      _isDarkMode ? AppColorsDark.textSecondary : textSecondary;
  static Color get dynamicNutritionProtein =>
      _isDarkMode ? AppColorsDark.primary : primary;
  static Color get dynamicNutritionCarbs =>
      _isDarkMode ? AppColorsDark.green : green;
  static Color get dynamicNutritionFats =>
      _isDarkMode ? AppColorsDark.orange : orange;

  // Проверка текущей темы
  static bool get _isDarkMode {
    try {
      return ThemeManager().isDarkMode;
    } catch (e) {
      // Если ThemeManager недоступен, возвращаем false (светлая тема)
      return false;
    }
  }
}
