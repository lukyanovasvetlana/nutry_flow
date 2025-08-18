/// Экспорт компонентов анимаций для NutryFlow
///
/// Этот файл экспортирует все компоненты анимаций для удобного импорта:
///
/// ```dart
/// import 'package:nutry_flow/shared/design/components/animations/animations.dart';
///
/// // Использование
/// NutryAnimations.fade(child: widget, isVisible: true);
/// NutryAnimations.slide(child: widget, isVisible: true);
/// ```
///
/// ## Доступные анимации:
///
/// ### Базовые анимации
/// - `fade` - Появление/исчезновение
/// - `slide` - Скольжение с направлениями
/// - `scale` - Масштабирование
/// - `rotate` - Вращение
///
/// ### Эффекты
/// - `bounce` - Отскок
/// - `pulse` - Пульсация
/// - `shimmer` - Мерцание для загрузки
/// - `ripple` - Волновой эффект
///
/// ### Специализированные
/// - `animatedIcon` - Анимированная иконка
/// - `animatedText` - Анимированный текст
/// - `animatedCard` - Анимированная карточка
/// - `animatedButton` - Анимированная кнопка
/// - `animatedProgress` - Анимированный прогресс
/// - `animatedCounter` - Анимированный счетчик
/// - `animatedList` - Анимированный список
/// - `pageTransition` - Переход между экранами
library;

export 'nutry_animations.dart';
