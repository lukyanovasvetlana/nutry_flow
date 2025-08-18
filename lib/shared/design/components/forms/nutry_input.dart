import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../tokens/design_tokens.dart';

/// Типы полей ввода
enum NutryInputType {
  text,
  email,
  password,
  number,
  phone,
  url,
  multiline,
  search,
}

/// Размеры полей ввода
enum NutryInputSize {
  small,
  medium,
  large,
}

/// Состояния поля ввода
enum NutryInputState {
  normal,
  focused,
  error,
  success,
  disabled,
  loading,
}

/// Универсальный компонент поля ввода для NutryFlow
class NutryInput extends StatefulWidget {
  /// Контроллер поля
  final TextEditingController? controller;

  /// Тип поля ввода
  final NutryInputType type;

  /// Размер поля
  final NutryInputSize size;

  /// Подпись поля
  final String? label;

  /// Подсказка
  final String? hint;

  /// Подсказка для ошибки
  final String? errorText;

  /// Подсказка для успеха
  final String? successText;

  /// Подсказка для помощи
  final String? helperText;

  /// Иконка слева
  final IconData? prefixIcon;

  /// Иконка справа
  final IconData? suffixIcon;

  /// Виджет справа
  final Widget? suffixWidget;

  /// Максимальное количество строк
  final int? maxLines;

  /// Максимальное количество символов
  final int? maxLength;

  /// Форматтеры ввода
  final List<TextInputFormatter>? inputFormatters;

  /// Валидатор
  final String? Function(String?)? validator;

  /// Обработчик изменения
  final ValueChanged<String>? onChanged;

  /// Обработчик отправки
  final ValueChanged<String>? onSubmitted;

  /// Обработчик нажатия
  final VoidCallback? onTap;

  /// Автофокус
  final bool autofocus;

  /// Только для чтения
  final bool readOnly;

  /// Отключено
  final bool enabled;

  /// Показывать счетчик символов
  final bool showCounter;

  /// Показывать пароль
  final bool obscureText;

  /// Ширина поля
  final double? width;

  /// Высота поля
  final double? height;

  /// Отступы
  final EdgeInsetsGeometry? padding;

  /// Отступы снаружи
  final EdgeInsetsGeometry? margin;

  const NutryInput({
    super.key,
    this.controller,
    this.type = NutryInputType.text,
    this.size = NutryInputSize.medium,
    this.label,
    this.hint,
    this.errorText,
    this.successText,
    this.helperText,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixWidget,
    this.maxLines,
    this.maxLength,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.autofocus = false,
    this.readOnly = false,
    this.enabled = true,
    this.showCounter = false,
    this.obscureText = false,
    this.width,
    this.height,
    this.padding,
    this.margin,
  });

  /// Фабричный метод для текстового поля
  factory NutryInput.text({
    required String label,
    TextEditingController? controller,
    String? hint,
    NutryInputSize size = NutryInputSize.medium,
    String? Function(String?)? validator,
    ValueChanged<String>? onChanged,
    bool enabled = true,
  }) {
    return NutryInput(
      controller: controller,
      type: NutryInputType.text,
      size: size,
      label: label,
      hint: hint,
      validator: validator,
      onChanged: onChanged,
      enabled: enabled,
    );
  }

  /// Фабричный метод для email поля
  factory NutryInput.email({
    required String label,
    TextEditingController? controller,
    String? hint,
    NutryInputSize size = NutryInputSize.medium,
    String? Function(String?)? validator,
    ValueChanged<String>? onChanged,
    bool enabled = true,
  }) {
    return NutryInput(
      controller: controller,
      type: NutryInputType.email,
      size: size,
      label: label,
      hint: hint,
      prefixIcon: Icons.email_outlined,
      validator: validator ?? _defaultEmailValidator,
      onChanged: onChanged,
      enabled: enabled,
    );
  }

  /// Фабричный метод для поля пароля
  factory NutryInput.password({
    required String label,
    TextEditingController? controller,
    String? hint,
    NutryInputSize size = NutryInputSize.medium,
    String? Function(String?)? validator,
    ValueChanged<String>? onChanged,
    bool enabled = true,
  }) {
    return NutryInput(
      controller: controller,
      type: NutryInputType.password,
      size: size,
      label: label,
      hint: hint,
      prefixIcon: Icons.lock_outlined,
      obscureText: true,
      validator: validator ?? _defaultPasswordValidator,
      onChanged: onChanged,
      enabled: enabled,
    );
  }

  /// Фабричный метод для числового поля
  factory NutryInput.number({
    required String label,
    TextEditingController? controller,
    String? hint,
    NutryInputSize size = NutryInputSize.medium,
    String? Function(String?)? validator,
    ValueChanged<String>? onChanged,
    bool enabled = true,
  }) {
    return NutryInput(
      controller: controller,
      type: NutryInputType.number,
      size: size,
      label: label,
      hint: hint,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: validator,
      onChanged: onChanged,
      enabled: enabled,
    );
  }

  /// Фабричный метод для поискового поля
  factory NutryInput.search({
    required String hint,
    TextEditingController? controller,
    NutryInputSize size = NutryInputSize.medium,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    bool enabled = true,
  }) {
    return NutryInput(
      controller: controller,
      type: NutryInputType.search,
      size: size,
      hint: hint,
      prefixIcon: Icons.search,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      enabled: enabled,
    );
  }

  /// Валидатор по умолчанию для email
  static String? _defaultEmailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите email';
    }
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value)) {
      return 'Некорректный email';
    }
    return null;
  }

  /// Валидатор по умолчанию для пароля
  static String? _defaultPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите пароль';
    }
    if (value.length < 6) {
      return 'Пароль должен содержать минимум 6 символов';
    }
    return null;
  }

  @override
  State<NutryInput> createState() => _NutryInputState();
}

class _NutryInputState extends State<NutryInput> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _isFocused = false;
  bool _isObscured = false;
  String? _errorText;
  String? _successText;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = FocusNode();
    _isObscured = widget.obscureText;

    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      margin: widget.margin ?? EdgeInsets.only(bottom: DesignTokens.spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label != null) _buildLabel(),
          _buildInputField(),
          if (_errorText != null) _buildErrorText(),
          if (_successText != null) _buildSuccessText(),
          if (widget.helperText != null) _buildHelperText(),
        ],
      ),
    );
  }

  Widget _buildLabel() {
    return Padding(
      padding: EdgeInsets.only(bottom: DesignTokens.spacing.xs),
      child: Text(
        widget.label!,
        style: DesignTokens.typography.labelLargeStyle.copyWith(
          color: DesignTokens.colors.onSurface,
          fontWeight: DesignTokens.typography.medium,
        ),
      ),
    );
  }

  Widget _buildInputField() {
    return TextFormField(
      controller: _controller,
      focusNode: _focusNode,
      keyboardType: _getKeyboardType(),
      textInputAction: _getTextInputAction(),
      obscureText: _isObscured,
      maxLines: widget.maxLines ??
          (widget.type == NutryInputType.multiline ? null : 1),
      maxLength: widget.maxLength,
      inputFormatters: widget.inputFormatters,
      validator: widget.validator,
      onChanged: (value) {
        _validateField(value);
        widget.onChanged?.call(value);
      },
      onFieldSubmitted: widget.onSubmitted,
      onTap: widget.onTap,
      autofocus: widget.autofocus,
      readOnly: widget.readOnly,
      enabled: widget.enabled,
      decoration: _buildInputDecoration(),
    );
  }

  Widget _buildErrorText() {
    return Padding(
      padding: EdgeInsets.only(top: DesignTokens.spacing.xs),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: DesignTokens.colors.error,
            size: DesignTokens.spacing.iconSmall,
          ),
          SizedBox(width: DesignTokens.spacing.xs),
          Expanded(
            child: Text(
              _errorText!,
              style: DesignTokens.typography.bodySmallStyle.copyWith(
                color: DesignTokens.colors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessText() {
    return Padding(
      padding: EdgeInsets.only(top: DesignTokens.spacing.xs),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            color: DesignTokens.colors.success,
            size: DesignTokens.spacing.iconSmall,
          ),
          SizedBox(width: DesignTokens.spacing.xs),
          Expanded(
            child: Text(
              _successText!,
              style: DesignTokens.typography.bodySmallStyle.copyWith(
                color: DesignTokens.colors.success,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelperText() {
    return Padding(
      padding: EdgeInsets.only(top: DesignTokens.spacing.xs),
      child: Text(
        widget.helperText!,
        style: DesignTokens.typography.bodySmallStyle.copyWith(
          color: DesignTokens.colors.onSurfaceVariant,
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration() {
    final state = _getCurrentState();

    return InputDecoration(
      hintText: widget.hint,
      hintStyle: DesignTokens.typography.bodyMediumStyle.copyWith(
        color: DesignTokens.colors.onSurfaceVariant,
      ),
      prefixIcon: widget.prefixIcon != null
          ? Icon(
              widget.prefixIcon,
              color: _getIconColor(state),
              size: _getIconSize(),
            )
          : null,
      suffixIcon: _buildSuffixIcon(),
      counterText: widget.showCounter ? null : '',
      contentPadding: _getContentPadding(),
      filled: true,
      fillColor: _getFillColor(state),
      border: _getBorder(state),
      enabledBorder: _getBorder(state),
      focusedBorder: _getBorder(state),
      errorBorder: _getBorder(state),
      focusedErrorBorder: _getBorder(state),
      disabledBorder: _getBorder(state),
    );
  }

  Widget? _buildSuffixIcon() {
    if (widget.suffixWidget != null) {
      return widget.suffixWidget;
    }

    if (widget.type == NutryInputType.password) {
      return IconButton(
        icon: Icon(
          _isObscured ? Icons.visibility : Icons.visibility_off,
          color: _getIconColor(_getCurrentState()),
          size: _getIconSize(),
        ),
        onPressed: () {
          setState(() {
            _isObscured = !_isObscured;
          });
        },
      );
    }

    if (widget.suffixIcon != null) {
      return Icon(
        widget.suffixIcon,
        color: _getIconColor(_getCurrentState()),
        size: _getIconSize(),
      );
    }

    return null;
  }

  NutryInputState _getCurrentState() {
    if (!widget.enabled) return NutryInputState.disabled;
    if (_errorText != null) return NutryInputState.error;
    if (_successText != null) return NutryInputState.success;
    if (_isFocused) return NutryInputState.focused;
    return NutryInputState.normal;
  }

  TextInputType _getKeyboardType() {
    switch (widget.type) {
      case NutryInputType.email:
        return TextInputType.emailAddress;
      case NutryInputType.password:
        return TextInputType.visiblePassword;
      case NutryInputType.number:
        return TextInputType.number;
      case NutryInputType.phone:
        return TextInputType.phone;
      case NutryInputType.url:
        return TextInputType.url;
      case NutryInputType.multiline:
        return TextInputType.multiline;
      case NutryInputType.search:
        return TextInputType.text;
      default:
        return TextInputType.text;
    }
  }

  TextInputAction _getTextInputAction() {
    switch (widget.type) {
      case NutryInputType.email:
      case NutryInputType.password:
        return TextInputAction.next;
      case NutryInputType.search:
        return TextInputAction.search;
      case NutryInputType.multiline:
        return TextInputAction.newline;
      default:
        return TextInputAction.done;
    }
  }

  Color _getIconColor(NutryInputState state) {
    switch (state) {
      case NutryInputState.error:
        return DesignTokens.colors.error;
      case NutryInputState.success:
        return DesignTokens.colors.success;
      case NutryInputState.focused:
        return DesignTokens.colors.primary;
      case NutryInputState.disabled:
        return DesignTokens.colors.onSurfaceVariant;
      default:
        return DesignTokens.colors.onSurfaceVariant;
    }
  }

  double _getIconSize() {
    switch (widget.size) {
      case NutryInputSize.small:
        return DesignTokens.spacing.iconSmall;
      case NutryInputSize.large:
        return DesignTokens.spacing.iconLarge;
      default:
        return DesignTokens.spacing.iconMedium;
    }
  }

  EdgeInsetsGeometry _getContentPadding() {
    final horizontal = DesignTokens.spacing.md;
    final vertical = widget.size == NutryInputSize.large
        ? DesignTokens.spacing.md
        : DesignTokens.spacing.sm;

    return EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
  }

  Color _getFillColor(NutryInputState state) {
    if (!widget.enabled) {
      return DesignTokens.colors.surfaceVariant;
    }

    switch (state) {
      case NutryInputState.error:
        return DesignTokens.colors.error.withValues(alpha: 0.05);
      case NutryInputState.success:
        return DesignTokens.colors.success.withValues(alpha: 0.05);
      case NutryInputState.focused:
        return DesignTokens.colors.primary.withValues(alpha: 0.05);
      default:
        return DesignTokens.colors.surface;
    }
  }

  InputBorder _getBorder(NutryInputState state) {
    final borderRadius =
        BorderRadius.circular(DesignTokens.borders.inputRadius);
    final borderWidth = state == NutryInputState.focused ? 2.0 : 1.0;

    Color borderColor;
    switch (state) {
      case NutryInputState.error:
        borderColor = DesignTokens.colors.error;
        break;
      case NutryInputState.success:
        borderColor = DesignTokens.colors.success;
        break;
      case NutryInputState.focused:
        borderColor = DesignTokens.colors.primary;
        break;
      case NutryInputState.disabled:
        borderColor = DesignTokens.colors.outline;
        break;
      default:
        borderColor = DesignTokens.colors.outline;
    }

    return OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(
        color: borderColor,
        width: borderWidth,
      ),
    );
  }

  void _validateField(String value) {
    if (widget.validator != null) {
      final error = widget.validator!(value);
      setState(() {
        _errorText = error;
        _successText = null;
      });
    } else {
      setState(() {
        _errorText = null;
        _successText = null;
      });
    }
  }
}
