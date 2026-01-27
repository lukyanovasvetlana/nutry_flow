import 'package:flutter/material.dart';
import '../../tokens/design_tokens.dart';

/// Компонент Tooltip для NutryFlow
/// Показывает подсказку при наведении или длительном нажатии
class NutryTooltip extends StatelessWidget {
  /// Текст подсказки
  final String message;

  /// Дочерний виджет, к которому привязана подсказка
  final Widget child;

  /// Позиция подсказки относительно виджета
  final TooltipPosition position;

  /// Показывать ли стрелку
  final bool showArrow;

  /// Задержка перед показом (в миллисекундах)
  final int waitDuration;

  /// Длительность показа (в миллисекундах)
  final int showDuration;

  /// Кастомный цвет фона
  final Color? backgroundColor;

  /// Кастомный цвет текста
  final Color? textColor;

  const NutryTooltip({
    super.key,
    required this.message,
    required this.child,
    this.position = TooltipPosition.auto,
    this.showArrow = true,
    this.waitDuration = 500,
    this.showDuration = 2000,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final spacing = context.spacing;
    final borders = context.borders;

    return Tooltip(
      message: message,
      waitDuration: Duration(milliseconds: waitDuration),
      showDuration: Duration(milliseconds: showDuration),
      preferBelow: position == TooltipPosition.below,
      textStyle: typography.bodySmallStyle.copyWith(
        color: textColor ?? colors.onSurface,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? colors.surface,
        borderRadius: BorderRadius.circular(borders.sm),
        boxShadow: context.shadows.md,
        border: Border.all(
          color: colors.outline,
          width: borders.thin,
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: spacing.md,
        vertical: spacing.sm,
      ),
      child: child,
    );
  }
}

/// Позиция tooltip
enum TooltipPosition {
  auto,
  above,
  below,
}

/// Расширение для удобного использования
extension NutryTooltipExtension on Widget {
  /// Обернуть виджет в tooltip
  Widget withTooltip(
    String message, {
    TooltipPosition position = TooltipPosition.auto,
    bool showArrow = true,
    int waitDuration = 500,
    int showDuration = 2000,
    Color? backgroundColor,
    Color? textColor,
  }) {
    return NutryTooltip(
      message: message,
      position: position,
      showArrow: showArrow,
      waitDuration: waitDuration,
      showDuration: showDuration,
      backgroundColor: backgroundColor,
      textColor: textColor,
      child: this,
    );
  }
}

