import 'package:flutter/material.dart';
import '../../tokens/design_tokens.dart';

/// Типы кнопок NutryFlow
enum NutryButtonType {
  primary,
  secondary,
  tertiary,
  outline,
  text,
  destructive,
}

/// Размеры кнопок
enum NutryButtonSize {
  small,
  medium,
  large,
}

/// Современный компонент кнопки для NutryFlow
/// Создан для интеграции с дизайнером
class NutryButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final NutryButtonType type;
  final NutryButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool isEnabled;
  final double? width;
  final EdgeInsetsGeometry? padding;

  const NutryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = NutryButtonType.primary,
    this.size = NutryButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isEnabled = true,
    this.width,
    this.padding,
  });

  /// Фабричный метод для создания основной кнопки
  factory NutryButton.primary({
    required String text,
    VoidCallback? onPressed,
    NutryButtonSize size = NutryButtonSize.medium,
    IconData? icon,
    bool isLoading = false,
    double? width,
  }) {
    return NutryButton(
      text: text,
      onPressed: onPressed,
      type: NutryButtonType.primary,
      size: size,
      icon: icon,
      isLoading: isLoading,
      width: width,
    );
  }

  /// Фабричный метод для создания вторичной кнопки
  factory NutryButton.secondary({
    required String text,
    VoidCallback? onPressed,
    NutryButtonSize size = NutryButtonSize.medium,
    IconData? icon,
    bool isLoading = false,
    double? width,
  }) {
    return NutryButton(
      text: text,
      onPressed: onPressed,
      type: NutryButtonType.secondary,
      size: size,
      icon: icon,
      isLoading: isLoading,
      width: width,
    );
  }

  /// Фабричный метод для создания кнопки с контуром
  factory NutryButton.outline({
    required String text,
    VoidCallback? onPressed,
    NutryButtonSize size = NutryButtonSize.medium,
    IconData? icon,
    bool isLoading = false,
    double? width,
  }) {
    return NutryButton(
      text: text,
      onPressed: onPressed,
      type: NutryButtonType.outline,
      size: size,
      icon: icon,
      isLoading: isLoading,
      width: width,
    );
  }

  /// Фабричный метод для создания деструктивной кнопки
  factory NutryButton.destructive({
    required String text,
    VoidCallback? onPressed,
    NutryButtonSize size = NutryButtonSize.medium,
    IconData? icon,
    bool isLoading = false,
    double? width,
  }) {
    return NutryButton(
      text: text,
      onPressed: onPressed,
      type: NutryButtonType.destructive,
      size: size,
      icon: icon,
      isLoading: isLoading,
      width: width,
    );
  }

  @override
  State<NutryButton> createState() => _NutryButtonState();
}

class _NutryButtonState extends State<NutryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: DesignTokens.animations.fast,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: DesignTokens.animations.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.isEnabled && !widget.isLoading) {
      setState(() => _isPressed = true);
      _animationController.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.isEnabled && !widget.isLoading) {
      setState(() => _isPressed = false);
      _animationController.reverse();
    }
  }

  void _onTapCancel() {
    if (widget.isEnabled && !widget.isLoading) {
      setState(() => _isPressed = false);
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final spacing = DesignTokens.spacing;
    final typography = DesignTokens.typography;
    final shadows = DesignTokens.shadows;
    final borders = DesignTokens.borders;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            onTap: widget.isEnabled && !widget.isLoading ? widget.onPressed : null,
            child: AnimatedContainer(
              duration: DesignTokens.animations.fast,
              width: widget.width,
              height: _getButtonHeight(),
              padding: widget.padding ?? _getButtonPadding(),
              decoration: _getButtonDecoration(),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.isLoading) ...[
                    SizedBox(
                      width: _getIconSize(),
                      height: _getIconSize(),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getTextColor(),
                        ),
                      ),
                    ),
                    SizedBox(width: spacing.sm),
                  ] else if (widget.icon != null) ...[
                    Icon(
                      widget.icon,
                      size: _getIconSize(),
                      color: _getTextColor(),
                    ),
                    SizedBox(width: spacing.sm),
                  ],
                  Text(
                    widget.text,
                    style: _getTextStyle(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  double _getButtonHeight() {
    final spacing = DesignTokens.spacing;
    switch (widget.size) {
      case NutryButtonSize.small:
        return spacing.buttonHeightSmall;
      case NutryButtonSize.medium:
        return spacing.buttonHeight;
      case NutryButtonSize.large:
        return spacing.buttonHeightLarge;
    }
  }

  EdgeInsetsGeometry _getButtonPadding() {
    final spacing = DesignTokens.spacing;
    switch (widget.size) {
      case NutryButtonSize.small:
        return EdgeInsets.symmetric(horizontal: spacing.md, vertical: spacing.sm);
      case NutryButtonSize.medium:
        return EdgeInsets.symmetric(horizontal: spacing.lg, vertical: spacing.md);
      case NutryButtonSize.large:
        return EdgeInsets.symmetric(horizontal: spacing.xl, vertical: spacing.lg);
    }
  }

  double _getIconSize() {
    final spacing = DesignTokens.spacing;
    switch (widget.size) {
      case NutryButtonSize.small:
        return spacing.iconSmall;
      case NutryButtonSize.medium:
        return spacing.iconMedium;
      case NutryButtonSize.large:
        return spacing.iconLarge;
    }
  }

  BoxDecoration _getButtonDecoration() {
    final colors = DesignTokens.colors;
    final shadows = DesignTokens.shadows;
    final borders = DesignTokens.borders;

    Color backgroundColor;
    Color borderColor;
    List<BoxShadow> boxShadow;
    Gradient? gradient;

    switch (widget.type) {
      case NutryButtonType.primary:
        backgroundColor = colors.primary;
        borderColor = colors.primary;
        boxShadow = _isPressed ? shadows.sm : shadows.md;
        gradient = colors.primaryGradient;
        break;
      case NutryButtonType.secondary:
        backgroundColor = colors.secondary;
        borderColor = colors.secondary;
        boxShadow = _isPressed ? shadows.sm : shadows.md;
        gradient = colors.secondaryGradient;
        break;
      case NutryButtonType.tertiary:
        backgroundColor = colors.accent;
        borderColor = colors.accent;
        boxShadow = _isPressed ? shadows.sm : shadows.md;
        gradient = colors.accentGradient;
        break;
      case NutryButtonType.outline:
        backgroundColor = Colors.transparent;
        borderColor = colors.primary;
        boxShadow = _isPressed ? shadows.sm : shadows.none;
        gradient = null;
        break;
      case NutryButtonType.text:
        backgroundColor = Colors.transparent;
        borderColor = Colors.transparent;
        boxShadow = shadows.none;
        gradient = null;
        break;
      case NutryButtonType.destructive:
        backgroundColor = colors.error;
        borderColor = colors.error;
        boxShadow = _isPressed ? shadows.sm : shadows.md;
        gradient = null;
        break;
    }

    if (!widget.isEnabled) {
      backgroundColor = backgroundColor.withValues(alpha: 0.5);
      borderColor = borderColor.withValues(alpha: 0.5);
      boxShadow = shadows.none;
      gradient = null;
    }

    return BoxDecoration(
      color: gradient == null ? backgroundColor : null,
      gradient: gradient,
      border: Border.all(
        color: borderColor,
        width: widget.type == NutryButtonType.outline ? borders.medium : 0,
      ),
      borderRadius: borders.buttonRadius,
      boxShadow: boxShadow,
    );
  }

  Color _getTextColor() {
    final colors = DesignTokens.colors;

    Color textColor;
    switch (widget.type) {
      case NutryButtonType.primary:
      case NutryButtonType.secondary:
      case NutryButtonType.tertiary:
      case NutryButtonType.destructive:
        textColor = colors.onPrimary;
        break;
      case NutryButtonType.outline:
      case NutryButtonType.text:
        textColor = colors.primary;
        break;
    }

    if (!widget.isEnabled) {
      textColor = textColor.withValues(alpha: 0.5);
    }

    return textColor;
  }

  TextStyle _getTextStyle() {
    final typography = DesignTokens.typography;
    final textColor = _getTextColor();

    double fontSize;
    FontWeight fontWeight;

    switch (widget.size) {
      case NutryButtonSize.small:
        fontSize = typography.labelSmall;
        fontWeight = typography.medium;
        break;
      case NutryButtonSize.medium:
        fontSize = typography.labelMedium;
        fontWeight = typography.medium;
        break;
      case NutryButtonSize.large:
        fontSize = typography.labelLarge;
        fontWeight = typography.semiBold;
        break;
    }

    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: textColor,
      letterSpacing: typography.letterSpacingWide,
    );
  }
}

/// Виджет для демонстрации всех типов кнопок
/// Полезен для дизайнера при создании макетов
class NutryButtonShowcase extends StatelessWidget {
  const NutryButtonShowcase({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NutryButton Showcase'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(DesignTokens.spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSection('Primary Buttons', [
              NutryButton.primary(text: 'Primary Button'),
              NutryButton.primary(text: 'With Icon', icon: Icons.add),
              NutryButton.primary(text: 'Loading', isLoading: true),
            ]),
            _buildSection('Secondary Buttons', [
              NutryButton.secondary(text: 'Secondary Button'),
              NutryButton.secondary(text: 'With Icon', icon: Icons.star),
            ]),
            _buildSection('Outline Buttons', [
              NutryButton.outline(text: 'Outline Button'),
              NutryButton.outline(text: 'With Icon', icon: Icons.favorite),
            ]),
            _buildSection('Destructive Buttons', [
              NutryButton.destructive(text: 'Delete'),
              NutryButton.destructive(text: 'Remove', icon: Icons.delete),
            ]),
            _buildSection('Sizes', [
              NutryButton.primary(text: 'Small', size: NutryButtonSize.small),
              NutryButton.primary(text: 'Medium', size: NutryButtonSize.medium),
              NutryButton.primary(text: 'Large', size: NutryButtonSize.large),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> buttons) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: DesignTokens.typography.headlineSmall,
            fontWeight: DesignTokens.typography.semiBold,
          ),
        ),
        SizedBox(height: DesignTokens.spacing.md),
        ...buttons.map((button) => Padding(
          padding: EdgeInsets.only(bottom: DesignTokens.spacing.sm),
          child: button,
        )),
        SizedBox(height: DesignTokens.spacing.lg),
      ],
    );
  }
} 