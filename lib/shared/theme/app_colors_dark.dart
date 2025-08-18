import 'package:flutter/material.dart';

/// Темная версия AppColors для NutryFlow
/// Использует цвет фона #0F1419 как основу, как в экране "Меню"
class AppColorsDark {
  // Основные цвета бренда (адаптированные для темной темы)
  static const primary = Color(0xFF4ADE80); // Яркий зеленый
  static const secondary = Color(0xFF60A5FA); // Яркий синий
  static const green = Color(0xFF22C55E); // Яркий зеленый
  static const yellow = Color(0xFFFBBF24); // Яркий желтый
  static const orange = Color(0xFFF59E0B); // Яркий оранжевый
  static const button = Color(0xFF4ADE80); // Цвет кнопок (зеленый)
  static const gray = Color(0xFFA855F7); // Яркий фиолетовый (лавандовый)

  // Системные цвета (основаны на #0F1419)
  static const background =
      Color(0xFF0F1419); // Основной фон (как в экране "Меню")
  static const surface = Color(0xFF1A1F2E); // Поверхности (карточки)
  static const surfaceVariant = Color(0xFF2A3142); // Альтернативный фон
  static const card =
      Color(0xFF1E2532); // Цвет карточек (немного темнее surface)

  // Текстовые цвета
  static const textPrimary = Color(0xFFF8F9FA); // Основной текст (почти белый)
  static const textSecondary =
      Color(0xFFB8C5D6); // Вторичный текст (мягкий серо-голубой)
  static const textTertiary = Color(0xFF8B9CB0); // Третичный текст

  // Границы и разделители
  static const border = Color(0xFF4A5568); // Границы
  static const borderLight = Color(0xFF5A6478); // Светлые границы

  // Состояния
  static const success = Color(0xFF22C55E); // Успех
  static const error = Color(0xFFEF4444); // Ошибка
  static const warning = Color(0xFFF59E0B); // Предупреждение
  static const info = Color(0xFF3B82F6); // Информация

  // Тени
  static const shadow = Color(0xFF000000); // Тени
}
