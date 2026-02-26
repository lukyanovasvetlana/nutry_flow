import 'package:flutter/material.dart';
import '../../tokens/design_tokens.dart';

/// Компонент Progress Indicator для NutryFlow
class NutryProgress extends StatelessWidget {
  /// Текущее значение (0.0 - 1.0 или 0 - maxValue)
  final double value;

  /// Максимальное значение (если используется числовое значение)
  final double? maxValue;

  /// Показывать ли процент
  final bool showPercentage;

  /// Показывать ли текст
  final bool showLabel;

  /// Текст для отображения
  final String? label;

  /// Высота индикатора
  final double? height;

  /// Цвет индикатора
  final Color? color;

  /// Цвет фона
  final Color? backgroundColor;

  /// Радиус скругления
  final double? borderRadius;

  /// Тип индикатора
  final NutryProgressType type;

  const NutryProgress({
    super.key,
    required this.value,
    this.maxValue,
    this.showPercentage = false,
    this.showLabel = false,
    this.label,
    this.height,
    this.color,
    this.backgroundColor,
    this.borderRadius,
    this.type = NutryProgressType.linear,
  });

  /// Линейный индикатор прогресса
  factory NutryProgress.linear({
    required double value,
    double? maxValue,
    bool showPercentage = false,
    bool showLabel = false,
    String? label,
    double? height,
    Color? color,
    Color? backgroundColor,
    double? borderRadius,
  }) {
    return NutryProgress(
      value: value,
      maxValue: maxValue,
      showPercentage: showPercentage,
      showLabel: showLabel,
      label: label,
      height: height,
      color: color,
      backgroundColor: backgroundColor,
      borderRadius: borderRadius,
      type: NutryProgressType.linear,
    );
  }

  /// Круговой индикатор прогресса
  factory NutryProgress.circular({
    required double value,
    double? maxValue,
    bool showPercentage = false,
    String? label,
    double? size,
    Color? color,
    Color? backgroundColor,
  }) {
    return NutryProgress(
      value: value,
      maxValue: maxValue,
      showPercentage: showPercentage,
      label: label,
      height: size,
      color: color,
      backgroundColor: backgroundColor,
      type: NutryProgressType.circular,
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case NutryProgressType.linear:
        return _buildLinearProgress(context);
      case NutryProgressType.circular:
        return _buildCircularProgress(context);
    }
  }

  Widget _buildLinearProgress(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final spacing = context.spacing;
    final borders = context.borders;

    final progressValue = maxValue != null
        ? (value / maxValue!).clamp(0.0, 1.0)
        : value.clamp(0.0, 1.0);

    final progressColor = color ?? colors.primary;
    final bgColor = backgroundColor ?? colors.surfaceVariant;
    final progressHeight = height ?? 8.0;
    final radius = borderRadius ?? borders.xs;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showLabel || showPercentage) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (showLabel && label != null)
                Text(
                  label!,
                  style: typography.bodySmallStyle.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              if (showPercentage)
                Text(
                  '${(progressValue * 100).toInt()}%',
                  style: typography.bodySmallStyle.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
            ],
          ),
          SizedBox(height: spacing.xs),
        ],
        ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: Stack(
            children: [
              Container(
                height: progressHeight,
                width: double.infinity,
                color: bgColor,
              ),
              FractionallySizedBox(
                widthFactor: progressValue,
                child: Container(
                  height: progressHeight,
                  decoration: BoxDecoration(
                    color: progressColor,
                    borderRadius: BorderRadius.circular(radius),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCircularProgress(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final spacing = context.spacing;

    final progressValue = maxValue != null
        ? (value / maxValue!).clamp(0.0, 1.0)
        : value.clamp(0.0, 1.0);

    final progressColor = color ?? colors.primary;
    final bgColor = backgroundColor ?? colors.surfaceVariant;
    final size = height ?? DesignTokens.spacing.iconXLarge;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: progressValue,
            backgroundColor: bgColor,
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            strokeWidth: 4,
          ),
          if (showPercentage || label != null)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (showPercentage)
                  Text(
                    '${(progressValue * 100).toInt()}%',
                    style: typography.labelMediumStyle.copyWith(
                      color: colors.onSurface,
                      fontWeight: DesignTokens.typography.semiBold,
                    ),
                  ),
                if (label != null) ...[
                  if (showPercentage) SizedBox(height: spacing.xs),
                  Text(
                    label!,
                    style: typography.labelSmallStyle.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
        ],
      ),
    );
  }
}

/// Тип индикатора прогресса
enum NutryProgressType {
  linear,
  circular,
}
