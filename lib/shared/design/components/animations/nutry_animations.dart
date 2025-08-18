import 'package:flutter/material.dart';
import '../../tokens/design_tokens.dart';

/// Типы анимаций
enum NutryAnimationType {
  fade,
  slide,
  scale,
  rotate,
  bounce,
  pulse,
  shimmer,
  ripple,
}

/// Направления анимаций
enum NutryAnimationDirection {
  up,
  down,
  left,
  right,
  inward,
  out,
}

/// Состояния анимаций
enum NutryAnimationState {
  initial,
  animate,
  reverse,
  completed,
}

/// Универсальный компонент анимаций для NutryFlow
class NutryAnimations {
  // Prevent instantiation
  NutryAnimations._();

  /// Анимированный виджет с fade эффектом
  static Widget fade({
    required Widget child,
    required bool isVisible,
    Duration? duration,
    Curve? curve,
    VoidCallback? onComplete,
  }) {
    return AnimatedOpacity(
      opacity: isVisible ? 1.0 : 0.0,
      duration: duration ?? DesignTokens.animations.normal,
      curve: curve ?? DesignTokens.animations.easeInOut,
      onEnd: onComplete,
      child: child,
    );
  }

  /// Анимированный виджет с slide эффектом
  static Widget slide({
    required Widget child,
    required bool isVisible,
    NutryAnimationDirection direction = NutryAnimationDirection.up,
    Duration? duration,
    Curve? curve,
    VoidCallback? onComplete,
  }) {
    final offset = _getSlideOffset(direction);

    return AnimatedSlide(
      offset: isVisible ? Offset.zero : offset,
      duration: duration ?? DesignTokens.animations.normal,
      curve: curve ?? DesignTokens.animations.easeInOut,
      child: AnimatedOpacity(
        opacity: isVisible ? 1.0 : 0.0,
        duration: duration ?? DesignTokens.animations.normal,
        curve: curve ?? DesignTokens.animations.easeInOut,
        onEnd: onComplete,
        child: child,
      ),
    );
  }

  /// Анимированный виджет с scale эффектом
  static Widget scale({
    required Widget child,
    required bool isVisible,
    double? scale,
    Duration? duration,
    Curve? curve,
    VoidCallback? onComplete,
  }) {
    return AnimatedScale(
      scale: isVisible ? 1.0 : (scale ?? 0.8),
      duration: duration ?? DesignTokens.animations.normal,
      curve: curve ?? DesignTokens.animations.easeInOut,
      onEnd: onComplete,
      child: child,
    );
  }

  /// Анимированный виджет с rotate эффектом
  static Widget rotate({
    required Widget child,
    required bool isRotating,
    double? angle,
    Duration? duration,
    Curve? curve,
    VoidCallback? onComplete,
  }) {
    return AnimatedRotation(
      turns: isRotating ? (angle ?? 1.0) : 0.0,
      duration: duration ?? DesignTokens.animations.slower,
      curve: curve ?? DesignTokens.animations.easeInOut,
      onEnd: onComplete,
      child: child,
    );
  }

  /// Анимированный виджет с bounce эффектом
  static Widget bounce({
    required Widget child,
    required bool isBouncing,
    Duration? duration,
    Curve? curve,
    VoidCallback? onComplete,
  }) {
    return AnimatedScale(
      scale: isBouncing ? 1.1 : 1.0,
      duration: duration ?? DesignTokens.animations.fast,
      curve: curve ?? DesignTokens.animations.bounceOut,
      onEnd: onComplete,
      child: child,
    );
  }

  /// Анимированный виджет с pulse эффектом
  static Widget pulse({
    required Widget child,
    required bool isPulsing,
    Duration? duration,
    Curve? curve,
    VoidCallback? onComplete,
  }) {
    return AnimatedContainer(
      duration: duration ?? DesignTokens.animations.normal,
      curve: curve ?? DesignTokens.animations.easeInOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(DesignTokens.borders.md),
        boxShadow: isPulsing
            ? [
                BoxShadow(
                  color: DesignTokens.colors.primary.withValues(alpha: 0.3),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ]
            : [],
      ),
      onEnd: onComplete,
      child: child,
    );
  }

  /// Shimmer эффект для загрузки
  static Widget shimmer({
    required Widget child,
    required bool isLoading,
    Color? shimmerColor,
    Duration? duration,
  }) {
    if (!isLoading) return child;

    return _ShimmerWidget(
      shimmerColor: shimmerColor ?? DesignTokens.colors.surfaceVariant,
      duration: duration ?? DesignTokens.animations.slower,
      child: child,
    );
  }

  /// Ripple эффект для кнопок
  static Widget ripple({
    required Widget child,
    required VoidCallback? onTap,
    Color? rippleColor,
    BorderRadius? borderRadius,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius:
            borderRadius ?? BorderRadius.circular(DesignTokens.borders.md),
        splashColor:
            rippleColor ?? DesignTokens.colors.primary.withValues(alpha: 0.2),
        highlightColor:
            rippleColor ?? DesignTokens.colors.primary.withValues(alpha: 0.1),
        child: child,
      ),
    );
  }

  /// Анимированная иконка
  static Widget animatedIcon({
    required IconData icon,
    required bool isActive,
    double? size,
    Color? color,
    Duration? duration,
    Curve? curve,
  }) {
    return AnimatedContainer(
      duration: duration ?? DesignTokens.animations.fast,
      curve: curve ?? DesignTokens.animations.easeInOut,
      child: Icon(
        icon,
        size: size ?? DesignTokens.spacing.iconMedium,
        color: color ??
            (isActive
                ? DesignTokens.colors.primary
                : DesignTokens.colors.onSurfaceVariant),
      ),
    );
  }

  /// Анимированный текст
  static Widget animatedText({
    required String text,
    required bool isVisible,
    TextStyle? style,
    Duration? duration,
    Curve? curve,
  }) {
    return AnimatedDefaultTextStyle(
      duration: duration ?? DesignTokens.animations.normal,
      curve: curve ?? DesignTokens.animations.easeInOut,
      style: style ?? DesignTokens.typography.bodyMediumStyle,
      child: AnimatedOpacity(
        opacity: isVisible ? 1.0 : 0.0,
        duration: duration ?? DesignTokens.animations.normal,
        curve: curve ?? DesignTokens.animations.easeInOut,
        child: Text(text),
      ),
    );
  }

  /// Анимированная карточка
  static Widget animatedCard({
    required Widget child,
    required bool isVisible,
    Duration? duration,
    Curve? curve,
    VoidCallback? onComplete,
  }) {
    return AnimatedContainer(
      duration: duration ?? DesignTokens.animations.normal,
      curve: curve ?? DesignTokens.animations.easeInOut,
      transform: Matrix4.translationValues(
        0,
        isVisible ? 0 : 20,
        0,
      ),
      child: AnimatedOpacity(
        opacity: isVisible ? 1.0 : 0.0,
        duration: duration ?? DesignTokens.animations.normal,
        curve: curve ?? DesignTokens.animations.easeInOut,
        onEnd: onComplete,
        child: child,
      ),
    );
  }

  /// Анимированная кнопка
  static Widget animatedButton({
    required Widget child,
    required bool isPressed,
    Duration? duration,
    Curve? curve,
  }) {
    return AnimatedScale(
      scale: isPressed ? 0.95 : 1.0,
      duration: duration ?? DesignTokens.animations.fast,
      curve: curve ?? DesignTokens.animations.easeInOut,
      child: child,
    );
  }

  /// Анимированный прогресс
  static Widget animatedProgress({
    required double progress,
    required double maxProgress,
    Duration? duration,
    Curve? curve,
    Color? color,
    double? height,
  }) {
    return AnimatedContainer(
      duration: duration ?? DesignTokens.animations.normal,
      curve: curve ?? DesignTokens.animations.easeInOut,
      height: height ?? 4.0,
      decoration: BoxDecoration(
        color: color ?? DesignTokens.colors.primary,
        borderRadius: BorderRadius.circular(DesignTokens.borders.xs),
      ),
      width: (progress / maxProgress) * 100,
    );
  }

  /// Анимированный счетчик
  static Widget animatedCounter({
    required int value,
    required int previousValue,
    TextStyle? style,
    Duration? duration,
    Curve? curve,
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration ?? DesignTokens.animations.normal,
      curve: curve ?? DesignTokens.animations.easeInOut,
      tween: Tween<double>(
        begin: previousValue.toDouble(),
        end: value.toDouble(),
      ),
      builder: (context, animatedValue, child) {
        return Text(
          animatedValue.toInt().toString(),
          style: style ?? DesignTokens.typography.titleLargeStyle,
        );
      },
    );
  }

  /// Анимированный список
  static Widget animatedList({
    required List<Widget> children,
    required bool isVisible,
    Duration? duration,
    Curve? curve,
    VoidCallback? onComplete,
  }) {
    return AnimatedOpacity(
      opacity: isVisible ? 1.0 : 0.0,
      duration: duration ?? DesignTokens.animations.normal,
      curve: curve ?? DesignTokens.animations.easeInOut,
      onEnd: onComplete,
      child: Column(
        children: children.asMap().entries.map((entry) {
          final index = entry.key;
          final child = entry.value;

          return AnimatedContainer(
            duration: duration ?? DesignTokens.animations.normal,
            curve: curve ?? DesignTokens.animations.easeInOut,
            transform: Matrix4.translationValues(
              0,
              isVisible ? 0 : (20 + index * 10),
              0,
            ),
            child: AnimatedOpacity(
              opacity: isVisible ? 1.0 : 0.0,
              duration: duration ?? DesignTokens.animations.normal,
              curve: curve ?? DesignTokens.animations.easeInOut,
              child: child,
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Анимированный переход между экранами
  static Widget pageTransition({
    required Widget child,
    required bool isEntering,
    NutryAnimationDirection direction = NutryAnimationDirection.right,
    Duration? duration,
    Curve? curve,
  }) {
    final offset = _getSlideOffset(direction);

    return AnimatedSlide(
      offset: isEntering ? Offset.zero : offset,
      duration: duration ?? DesignTokens.animations.normal,
      curve: curve ?? DesignTokens.animations.easeInOut,
      child: AnimatedOpacity(
        opacity: isEntering ? 1.0 : 0.0,
        duration: duration ?? DesignTokens.animations.normal,
        curve: curve ?? DesignTokens.animations.easeInOut,
        child: child,
      ),
    );
  }

  /// Утилитарные методы
  static Offset _getSlideOffset(NutryAnimationDirection direction) {
    switch (direction) {
      case NutryAnimationDirection.up:
        return const Offset(0, -1);
      case NutryAnimationDirection.down:
        return const Offset(0, 1);
      case NutryAnimationDirection.left:
        return const Offset(-1, 0);
      case NutryAnimationDirection.right:
        return const Offset(1, 0);
      case NutryAnimationDirection.inward:
        return const Offset(0, 0);
      case NutryAnimationDirection.out:
        return const Offset(0, 0);
    }
  }
}

/// Виджет для shimmer эффекта
class _ShimmerWidget extends StatefulWidget {
  final Widget child;
  final Color shimmerColor;
  final Duration duration;

  const _ShimmerWidget({
    required this.child,
    required this.shimmerColor,
    required this.duration,
  });

  @override
  State<_ShimmerWidget> createState() => _ShimmerWidgetState();
}

class _ShimmerWidgetState extends State<_ShimmerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat();

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                Colors.transparent,
                widget.shimmerColor.withValues(alpha: 0.3),
                Colors.transparent,
              ],
              stops: [
                _animation.value - 0.3,
                _animation.value,
                _animation.value + 0.3,
              ],
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

/// Анимированный контроллер для сложных анимаций
class NutryAnimationController {
  final AnimationController controller;
  final Animation<double> animation;
  final Animation<double> reverseAnimation;

  NutryAnimationController({
    required TickerProvider vsync,
    Duration? duration,
    Curve? curve,
  })  : controller = AnimationController(
          duration: duration ?? DesignTokens.animations.normal,
          vsync: vsync,
        ),
        animation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: AnimationController(
            duration: duration ?? DesignTokens.animations.normal,
            vsync: vsync,
          ),
          curve: curve ?? DesignTokens.animations.easeInOut,
        )),
        reverseAnimation = Tween<double>(
          begin: 1.0,
          end: 0.0,
        ).animate(CurvedAnimation(
          parent: AnimationController(
            duration: duration ?? DesignTokens.animations.normal,
            vsync: vsync,
          ),
          curve: curve ?? DesignTokens.animations.easeInOut,
        ));

  void forward() => controller.forward();
  void reverse() => controller.reverse();
  void repeat() => controller.repeat();
  void stop() => controller.stop();
  void reset() => controller.reset();

  void dispose() => controller.dispose();

  bool get isAnimating => controller.isAnimating;
  bool get isCompleted => controller.isCompleted;
  bool get isDismissed => controller.isDismissed;
}
