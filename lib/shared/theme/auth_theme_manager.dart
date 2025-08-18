import 'package:flutter/material.dart';
import 'package:nutry_flow/shared/design/tokens/theme_tokens.dart';

class AuthThemeManager {
  static final AuthThemeManager _instance = AuthThemeManager._internal();
  factory AuthThemeManager() => _instance;
  AuthThemeManager._internal();

  // Для экранов аутентификации всегда используем светлую тему
  ThemeData get authTheme => _buildThemeFromTokens(ThemeTokens.light);

  ThemeData _buildThemeFromTokens(BaseThemeTokens tokens) {
    return ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,

      // Цвета
      colorScheme: ColorScheme.fromSeed(
        seedColor: tokens.primary,
        brightness: Brightness.light,
      ),

      // Типография
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1A1A1A),
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1A1A1A),
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Color(0xFF1A1A1A),
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xFF1A1A1A),
        ),
      ),

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: tokens.surface,
        foregroundColor: tokens.onSurface,
        elevation: 0,
        centerTitle: false,
      ),

      // Поля ввода
      inputDecorationTheme: InputDecorationTheme(
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: tokens.outline),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: tokens.outline),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: tokens.primary,
            width: 2,
          ),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: tokens.error),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: tokens.error,
            width: 2,
          ),
        ),
        labelStyle: TextStyle(
          color: tokens.onSurfaceVariant,
          fontSize: 14,
        ),
      ),

      // Кнопки
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: tokens.primary,
          foregroundColor: tokens.onPrimary,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: tokens.primary,
            width: 1.5,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),

      // TextButton
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: tokens.primary,
        ),
      ),

      // Scaffold
      scaffoldBackgroundColor: tokens.surface,
    );
  }
}
