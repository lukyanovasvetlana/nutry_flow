import 'package:flutter/material.dart';
import '../../tokens/design_tokens.dart';
import 'nutry_input.dart';

/// Состояния формы
enum NutryFormState {
  normal,
  loading,
  success,
  error,
  disabled,
}

/// Универсальный компонент формы для NutryFlow
class NutryForm extends StatefulWidget {
  /// Ключ формы
  final GlobalKey<FormState>? formKey;

  /// Дочерние виджеты
  final List<Widget> children;

  /// Состояние формы
  final NutryFormState state;

  /// Сообщение об ошибке
  final String? errorMessage;

  /// Сообщение об успехе
  final String? successMessage;

  /// Сообщение о загрузке
  final String? loadingMessage;

  /// Обработчик отправки формы
  final VoidCallback? onSubmit;

  /// Обработчик сброса формы
  final VoidCallback? onReset;

  /// Отступы формы
  final EdgeInsetsGeometry? padding;

  /// Отступы снаружи
  final EdgeInsetsGeometry? margin;

  /// Ширина формы
  final double? width;

  /// Высота формы
  final double? height;

  /// Показывать ли кнопки действий
  final bool showActions;

  /// Текст кнопки отправки
  final String submitText;

  /// Текст кнопки сброса
  final String resetText;

  /// Отключить кнопки
  final bool disableActions;

  const NutryForm({
    super.key,
    this.formKey,
    required this.children,
    this.state = NutryFormState.normal,
    this.errorMessage,
    this.successMessage,
    this.loadingMessage,
    this.onSubmit,
    this.onReset,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.showActions = true,
    this.submitText = 'Отправить',
    this.resetText = 'Сбросить',
    this.disableActions = false,
  });

  /// Фабричный метод для формы входа
  factory NutryForm.login({
    required List<Widget> children,
    GlobalKey<FormState>? formKey,
    NutryFormState state = NutryFormState.normal,
    String? errorMessage,
    VoidCallback? onSubmit,
    bool disableActions = false,
  }) {
    return NutryForm(
      formKey: formKey,
      state: state,
      errorMessage: errorMessage,
      onSubmit: onSubmit,
      submitText: 'Войти',
      showActions: true,
      disableActions: disableActions,
      children: children,
    );
  }

  /// Фабричный метод для формы регистрации
  factory NutryForm.register({
    required List<Widget> children,
    GlobalKey<FormState>? formKey,
    NutryFormState state = NutryFormState.normal,
    String? errorMessage,
    VoidCallback? onSubmit,
    bool disableActions = false,
  }) {
    return NutryForm(
      formKey: formKey,
      state: state,
      errorMessage: errorMessage,
      onSubmit: onSubmit,
      submitText: 'Зарегистрироваться',
      showActions: true,
      disableActions: disableActions,
      children: children,
    );
  }

  /// Фабричный метод для формы настроек
  factory NutryForm.settings({
    required List<Widget> children,
    GlobalKey<FormState>? formKey,
    NutryFormState state = NutryFormState.normal,
    String? errorMessage,
    String? successMessage,
    VoidCallback? onSubmit,
    VoidCallback? onReset,
    bool disableActions = false,
  }) {
    return NutryForm(
      formKey: formKey,
      state: state,
      errorMessage: errorMessage,
      successMessage: successMessage,
      onSubmit: onSubmit,
      onReset: onReset,
      submitText: 'Сохранить',
      resetText: 'Отменить',
      showActions: true,
      disableActions: disableActions,
      children: children,
    );
  }

  @override
  State<NutryForm> createState() => _NutryFormState();
}

class _NutryFormState extends State<NutryForm> {
  late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _formKey = widget.formKey ?? GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      margin: widget.margin,
      padding:
          widget.padding ?? EdgeInsets.all(DesignTokens.spacing.screenPadding),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildFormContent(),
            if (widget.showActions) _buildFormActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildFormContent() {
    return Column(
      children: [
        ...widget.children,
        if (widget.state == NutryFormState.loading) _buildLoadingState(),
        if (widget.errorMessage != null) _buildErrorMessage(),
        if (widget.successMessage != null) _buildSuccessMessage(),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Container(
      margin: EdgeInsets.only(top: DesignTokens.spacing.md),
      padding: EdgeInsets.all(DesignTokens.spacing.md),
      decoration: BoxDecoration(
        color: DesignTokens.colors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(DesignTokens.borders.md),
        border: Border.all(
          color: DesignTokens.colors.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: DesignTokens.spacing.iconMedium,
            height: DesignTokens.spacing.iconMedium,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                DesignTokens.colors.primary,
              ),
            ),
          ),
          SizedBox(width: DesignTokens.spacing.sm),
          Expanded(
            child: Text(
              widget.loadingMessage ?? 'Обработка...',
              style: DesignTokens.typography.bodyMediumStyle.copyWith(
                color: DesignTokens.colors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      margin: EdgeInsets.only(top: DesignTokens.spacing.md),
      padding: EdgeInsets.all(DesignTokens.spacing.md),
      decoration: BoxDecoration(
        color: DesignTokens.colors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(DesignTokens.borders.md),
        border: Border.all(
          color: DesignTokens.colors.error.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: DesignTokens.colors.error,
            size: DesignTokens.spacing.iconMedium,
          ),
          SizedBox(width: DesignTokens.spacing.sm),
          Expanded(
            child: Text(
              widget.errorMessage!,
              style: DesignTokens.typography.bodyMediumStyle.copyWith(
                color: DesignTokens.colors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessMessage() {
    return Container(
      margin: EdgeInsets.only(top: DesignTokens.spacing.md),
      padding: EdgeInsets.all(DesignTokens.spacing.md),
      decoration: BoxDecoration(
        color: DesignTokens.colors.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(DesignTokens.borders.md),
        border: Border.all(
          color: DesignTokens.colors.success.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            color: DesignTokens.colors.success,
            size: DesignTokens.spacing.iconMedium,
          ),
          SizedBox(width: DesignTokens.spacing.sm),
          Expanded(
            child: Text(
              widget.successMessage!,
              style: DesignTokens.typography.bodyMediumStyle.copyWith(
                color: DesignTokens.colors.success,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormActions() {
    return Container(
      margin: EdgeInsets.only(top: DesignTokens.spacing.lg),
      child: Row(
        children: [
          if (widget.onReset != null) ...[
            Expanded(
              child: _buildResetButton(),
            ),
            SizedBox(width: DesignTokens.spacing.md),
          ],
          Expanded(
            flex: widget.onReset != null ? 1 : 1,
            child: _buildSubmitButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    final isLoading = widget.state == NutryFormState.loading;
    final isDisabled = widget.disableActions || isLoading;

    return ElevatedButton(
      onPressed: isDisabled ? null : _handleSubmit,
      style: ElevatedButton.styleFrom(
        backgroundColor: DesignTokens.colors.primary,
        foregroundColor: DesignTokens.colors.onPrimary,
        padding: EdgeInsets.symmetric(
          vertical: DesignTokens.spacing.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(DesignTokens.borders.buttonRadius),
        ),
        elevation: isLoading ? 0 : 2,
      ),
      child: isLoading
          ? SizedBox(
              width: DesignTokens.spacing.iconSmall,
              height: DesignTokens.spacing.iconSmall,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  DesignTokens.colors.onPrimary,
                ),
              ),
            )
          : Text(
              widget.submitText,
              style: DesignTokens.typography.labelLargeStyle.copyWith(
                color: DesignTokens.colors.onPrimary,
                fontWeight: DesignTokens.typography.medium,
              ),
            ),
    );
  }

  Widget _buildResetButton() {
    final isDisabled =
        widget.disableActions || widget.state == NutryFormState.loading;

    return OutlinedButton(
      onPressed: isDisabled ? null : _handleReset,
      style: OutlinedButton.styleFrom(
        foregroundColor: DesignTokens.colors.primary,
        side: BorderSide(
          color: DesignTokens.colors.primary,
          width: 1,
        ),
        padding: EdgeInsets.symmetric(
          vertical: DesignTokens.spacing.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(DesignTokens.borders.buttonRadius),
        ),
      ),
      child: Text(
        widget.resetText,
        style: DesignTokens.typography.labelLargeStyle.copyWith(
          color: DesignTokens.colors.primary,
          fontWeight: DesignTokens.typography.medium,
        ),
      ),
    );
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSubmit?.call();
    }
  }

  void _handleReset() {
    _formKey.currentState?.reset();
    widget.onReset?.call();
  }
}

/// Вспомогательный класс для создания форм
class NutryFormBuilder {
  /// Создает форму входа
  static Widget buildLoginForm({
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required VoidCallback onLogin,
    GlobalKey<FormState>? formKey,
    NutryFormState state = NutryFormState.normal,
    String? errorMessage,
    bool disableActions = false,
  }) {
    return NutryForm.login(
      formKey: formKey,
      state: state,
      errorMessage: errorMessage,
      onSubmit: onLogin,
      disableActions: disableActions,
      children: [
        NutryInput.email(
          label: 'Email',
          controller: emailController,
          hint: 'Введите ваш email',
        ),
        SizedBox(height: DesignTokens.spacing.md),
        NutryInput.password(
          label: 'Пароль',
          controller: passwordController,
          hint: 'Введите ваш пароль',
        ),
      ],
    );
  }

  /// Создает форму регистрации
  static Widget buildRegisterForm({
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required TextEditingController confirmPasswordController,
    required VoidCallback onRegister,
    GlobalKey<FormState>? formKey,
    NutryFormState state = NutryFormState.normal,
    String? errorMessage,
    bool disableActions = false,
  }) {
    return NutryForm.register(
      formKey: formKey,
      state: state,
      errorMessage: errorMessage,
      onSubmit: onRegister,
      disableActions: disableActions,
      children: [
        NutryInput.email(
          label: 'Email',
          controller: emailController,
          hint: 'Введите ваш email',
        ),
        SizedBox(height: DesignTokens.spacing.md),
        NutryInput.password(
          label: 'Пароль',
          controller: passwordController,
          hint: 'Создайте пароль',
        ),
        SizedBox(height: DesignTokens.spacing.md),
        NutryInput.password(
          label: 'Подтвердите пароль',
          controller: confirmPasswordController,
          hint: 'Повторите пароль',
          validator: (value) {
            if (value != passwordController.text) {
              return 'Пароли не совпадают';
            }
            return null;
          },
        ),
      ],
    );
  }

  /// Создает форму профиля
  static Widget buildProfileForm({
    required TextEditingController firstNameController,
    required TextEditingController lastNameController,
    required TextEditingController emailController,
    required VoidCallback onSave,
    VoidCallback? onCancel,
    GlobalKey<FormState>? formKey,
    NutryFormState state = NutryFormState.normal,
    String? errorMessage,
    String? successMessage,
    bool disableActions = false,
  }) {
    return NutryForm.settings(
      formKey: formKey,
      state: state,
      errorMessage: errorMessage,
      successMessage: successMessage,
      onSubmit: onSave,
      onReset: onCancel,
      disableActions: disableActions,
      children: [
        Row(
          children: [
            Expanded(
              child: NutryInput.text(
                label: 'Имя',
                controller: firstNameController,
                hint: 'Введите ваше имя',
              ),
            ),
            SizedBox(width: DesignTokens.spacing.md),
            Expanded(
              child: NutryInput.text(
                label: 'Фамилия',
                controller: lastNameController,
                hint: 'Введите вашу фамилию',
              ),
            ),
          ],
        ),
        SizedBox(height: DesignTokens.spacing.md),
        NutryInput.email(
          label: 'Email',
          controller: emailController,
          hint: 'Введите ваш email',
        ),
      ],
    );
  }
}
