import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../design/tokens/theme_tokens.dart';
import '../design/tokens/design_tokens.dart';

/// Глобальный менеджер тем для NutryFlow
/// Обеспечивает динамическое переключение тем во всем приложении
class ThemeManager extends ChangeNotifier {
  static final ThemeManager _instance = ThemeManager._internal();
  factory ThemeManager() => _instance;
  ThemeManager._internal() {
    // Синхронная инициализация при создании
    _initializeSync();
  }

  /// Текущая тема приложения
  ThemeMode _currentTheme = ThemeMode.light;

  /// Ключ для сохранения темы в SharedPreferences
  static const String _themeKey = 'app_theme';

  /// Получить текущую тему
  ThemeMode get currentTheme => _currentTheme;

  /// Синхронная инициализация
  void _initializeSync() {
    // Используем светлую тему по умолчанию
    _currentTheme = ThemeMode.light;
    ThemeTokens.currentTheme = _currentTheme;
    
    // Асинхронно загружаем сохраненную тему
    _loadThemeFromStorageAsync();
  }

  /// Асинхронная загрузка темы из SharedPreferences
  Future<void> _loadThemeFromStorageAsync() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeIndex = prefs.getInt(_themeKey) ?? 0;
      final savedTheme = ThemeMode.values[themeIndex];
      
      if (savedTheme != _currentTheme) {
        _currentTheme = savedTheme;
        ThemeTokens.currentTheme = _currentTheme;
        notifyListeners();
      }
    } catch (e) {
      // В случае ошибки оставляем текущую тему
    }
  }

  /// Переключение темы
  Future<void> toggleTheme() async {
    final newTheme =
        _currentTheme == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;

    // Обновляем тему напрямую
    _currentTheme = newTheme;
    ThemeTokens.currentTheme = _currentTheme;

    // Сохраняем в SharedPreferences
    await _saveThemeToStorage();

    // Уведомляем о изменении темы
    notifyListeners();
  }

  /// Установить конкретную тему
  Future<void> setTheme(ThemeMode theme) async {
    // Обновляем тему
    _currentTheme = theme;

    // Обновляем ThemeTokens
    ThemeTokens.currentTheme = _currentTheme;

    // Сохраняем в SharedPreferences
    await _saveThemeToStorage();

    // Уведомляем о изменении темы
    notifyListeners();
  }

  /// Сохранить тему в SharedPreferences
  Future<void> _saveThemeToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeKey, _currentTheme.index);
    } catch (e) {
      // Игнорируем ошибки сохранения
    }
  }

  /// Получить светлую тему из токенов
  ThemeData get lightTheme =>
      _buildThemeFromTokens(ThemeTokens.light, Brightness.light);

  /// Получить темную тему из токенов
  ThemeData get darkTheme =>
      _buildThemeFromTokens(ThemeTokens.dark, Brightness.dark);

  ThemeData _buildThemeFromTokens(
      BaseThemeTokens tokens, Brightness brightness) {
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: tokens.primary,
      onPrimary: tokens.onPrimary,
      secondary: tokens.secondary,
      onSecondary: tokens.onSecondary,
      error: tokens.error,
      onError: tokens.onError,
      surface: tokens.surface,
      onSurface: tokens.onSurface,
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Inter',
      colorScheme: colorScheme,
      scaffoldBackgroundColor: tokens.background,
      appBarTheme: AppBarTheme(
        backgroundColor: tokens.surface,
        foregroundColor: tokens.onSurface,
        elevation: 0,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: tokens.surface,
        selectedItemColor: tokens.primary,
        unselectedItemColor: tokens.onSurfaceVariant,
      ),
      cardTheme: CardThemeData(
        color: tokens.surface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.borders.cardRadius),
          side: BorderSide(color: tokens.outline, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: tokens.primary,
          foregroundColor: tokens.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(DesignTokens.borders.buttonRadius),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: tokens.surfaceContainer,
        hintStyle: TextStyle(color: tokens.onSurfaceVariant),
        labelStyle: TextStyle(color: tokens.onSurface),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.borders.inputRadius),
          borderSide: BorderSide(color: tokens.outline, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.borders.inputRadius),
          borderSide: BorderSide(color: tokens.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.borders.inputRadius),
          borderSide: BorderSide(color: tokens.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.borders.inputRadius),
          borderSide: BorderSide(color: tokens.error, width: 1.5),
        ),
      ),
      dividerColor: tokens.outlineVariant,
      dialogTheme: DialogThemeData(backgroundColor: tokens.surface),
    );
  }

  /// Проверить, является ли текущая тема темной
  bool get isDarkMode => _currentTheme == ThemeMode.dark;

  /// Получить иконку для переключения темы
  IconData get themeIcon => isDarkMode ? Icons.light_mode : Icons.dark_mode;

  /// Получить текст для описания темы
  String get themeDescription => isDarkMode ? 'Темная тема' : 'Светлая тема';
}
