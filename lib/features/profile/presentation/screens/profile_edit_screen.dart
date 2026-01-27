import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import '../../domain/entities/user_profile.dart';
import '../blocs/profile_bloc.dart';
import '../widgets/profile_form_section.dart';
import '../widgets/profile_form_field.dart';
import '../widgets/profile_selection_field.dart';
import '../widgets/profile_multi_selection_field.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_styles.dart';

class ProfileEditScreen extends StatefulWidget {
  final UserProfile userProfile;

  const ProfileEditScreen({
    super.key,
    required this.userProfile,
  });

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  // Keys for scrolling to errors
  final _personalInfoKey = GlobalKey();
  final _physicalInfoKey = GlobalKey();
  final _healthInfoKey = GlobalKey();
  final _nutritionTargetsKey = GlobalKey();
  final _goalsKey = GlobalKey();

  // Validation constants
  static const int _minNameLength = 2;
  static const int _minAge = 13;
  static const int _maxAge = 120;
  static const int _minHeight = 100; // см
  static const int _maxHeight = 250; // см
  static const double _minWeight = 30.0; // кг
  static const double _maxWeight = 300.0; // кг
  static const int _minCalories = 800;
  static const int _maxCalories = 5000;
  static const double _minProtein = 10.0; // г
  static const double _maxProtein = 300.0; // г
  static const double _minCarbs = 20.0; // г
  static const double _maxCarbs = 500.0; // г
  static const double _minFat = 10.0; // г
  static const double _maxFat = 200.0; // г

  // Controllers for text fields
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _heightController;
  late final TextEditingController _weightController;
  late final TextEditingController _targetWeightController;
  late final TextEditingController _targetCaloriesController;
  late final TextEditingController _targetProteinController;
  late final TextEditingController _targetCarbsController;
  late final TextEditingController _targetFatController;

  // Focus nodes for navigation
  late final FocusNode _firstNameFocus;
  late final FocusNode _lastNameFocus;
  late final FocusNode _emailFocus;
  late final FocusNode _phoneFocus;
  late final FocusNode _heightFocus;
  late final FocusNode _weightFocus;
  late final FocusNode _targetWeightFocus;
  late final FocusNode _targetCaloriesFocus;
  late final FocusNode _targetProteinFocus;
  late final FocusNode _targetCarbsFocus;
  late final FocusNode _targetFatFocus;

  // Form values
  DateTime? _selectedDateOfBirth;
  Gender? _selectedGender;
  ActivityLevel? _selectedActivityLevel;
  List<DietaryPreference> _selectedDietaryPreferences = [];
  List<String> _allergies = [];
  List<String> _healthConditions = [];
  List<String> _fitnessGoals = [];

  bool _isModified = false;
  bool _isSubmitting = false;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadProfileData();
  }

  void _initializeControllers() {
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _heightController = TextEditingController();
    _weightController = TextEditingController();
    _targetWeightController = TextEditingController();
    _targetCaloriesController = TextEditingController();
    _targetProteinController = TextEditingController();
    _targetCarbsController = TextEditingController();
    _targetFatController = TextEditingController();

    // Initialize focus nodes
    _firstNameFocus = FocusNode();
    _lastNameFocus = FocusNode();
    _emailFocus = FocusNode();
    _phoneFocus = FocusNode();
    _heightFocus = FocusNode();
    _weightFocus = FocusNode();
    _targetWeightFocus = FocusNode();
    _targetCaloriesFocus = FocusNode();
    _targetProteinFocus = FocusNode();
    _targetCarbsFocus = FocusNode();
    _targetFatFocus = FocusNode();

    // Add listeners to track changes
    _firstNameController.addListener(_onFormChanged);
    _lastNameController.addListener(_onFormChanged);
    _emailController.addListener(_onFormChanged);
    _phoneController.addListener(_onFormChanged);
    _heightController.addListener(_onFormChanged);
    _weightController.addListener(_onFormChanged);
    _targetWeightController.addListener(_onFormChanged);
    _targetCaloriesController.addListener(_onFormChanged);
    _targetProteinController.addListener(_onFormChanged);
    _targetCarbsController.addListener(_onFormChanged);
    _targetFatController.addListener(_onFormChanged);
  }

  void _loadProfileData() {
    final profile = widget.userProfile;

    _firstNameController.text = profile.firstName;
    _lastNameController.text = profile.lastName;
    _emailController.text = profile.email;
    _phoneController.text = profile.phone ?? '';
    _heightController.text = profile.height?.toString() ?? '';
    _weightController.text = profile.weight?.toString() ?? '';
    _targetWeightController.text = profile.targetWeight?.toString() ?? '';
    _targetCaloriesController.text = profile.targetCalories?.toString() ?? '';
    _targetProteinController.text = profile.targetProtein?.toString() ?? '';
    _targetCarbsController.text = profile.targetCarbs?.toString() ?? '';
    _targetFatController.text = profile.targetFat?.toString() ?? '';

    _selectedDateOfBirth = profile.dateOfBirth;
    _selectedGender = profile.gender;
    _selectedActivityLevel = profile.activityLevel;
    _selectedDietaryPreferences = List.from(profile.dietaryPreferences);
    _allergies = List.from(profile.allergies);
    _healthConditions = List.from(profile.healthConditions);
    _fitnessGoals = List.from(profile.fitnessGoals);
  }

  void _onFormChanged() {
    // Отменяем предыдущий таймер, если он существует
    _debounceTimer?.cancel();
    
    // Устанавливаем новый таймер с задержкой 300ms
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (!_isModified && mounted) {
        setState(() {
          _isModified = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _targetWeightController.dispose();
    _targetCaloriesController.dispose();
    _targetProteinController.dispose();
    _targetCarbsController.dispose();
    _targetFatController.dispose();
    _firstNameFocus.dispose();
    _lastNameFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    _heightFocus.dispose();
    _weightFocus.dispose();
    _targetWeightFocus.dispose();
    _targetCaloriesFocus.dispose();
    _targetProteinFocus.dispose();
    _targetCarbsFocus.dispose();
    _targetFatFocus.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isModified,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _isModified) {
          _showUnsavedChangesDialog();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.dynamicBackground,
        appBar: _buildAppBar(),
        body: BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileUpdated) {
              if (mounted) {
                setState(() {
                  _isSubmitting = false;
                  _isModified = false;
                });
                _showSuccessMessage();
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    Navigator.of(context).pop(true);
                  }
                });
              }
            } else if (state is ProfileError) {
              if (mounted) {
                setState(() {
                  _isSubmitting = false;
                });
                _showErrorMessage(state.message);
              }
            }
          },
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPersonalInfoSection(key: _personalInfoKey),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
                _buildBottomActions(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.dynamicCard,
      elevation: 0,
      title: Text(
        'Редактировать профиль',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.dynamicTextPrimary,
        ),
      ),
      iconTheme: IconThemeData(
        color: AppColors.dynamicTextPrimary,
      ),
      actions: [
        if (_isModified && !_isSubmitting)
          TextButton(
            onPressed: _saveProfile,
            child: Text(
              'Сохранить',
              style: TextStyle(
                color: AppColors.dynamicPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPersonalInfoSection({Key? key}) {
    return ProfileFormSection(
      key: key,
      title: 'Личная информация',
      icon: Icons.person_outline,
      children: [
        Row(
          children: [
            Expanded(
              child: ProfileFormField(
                controller: _firstNameController,
                focusNode: _firstNameFocus,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => _lastNameFocus.requestFocus(),
                label: 'Имя',
                semanticLabel: 'Поле ввода имени',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Введите имя';
                  }
                  if (value.trim().length < _minNameLength) {
                    return 'Имя должно содержать минимум $_minNameLength символа';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ProfileFormField(
                controller: _lastNameController,
                focusNode: _lastNameFocus,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => _emailFocus.requestFocus(),
                label: 'Фамилия',
                semanticLabel: 'Поле ввода фамилии',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Введите фамилию';
                  }
                  if (value.trim().length < _minNameLength) {
                    return 'Фамилия должна содержать минимум $_minNameLength символа';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ProfileFormField(
          controller: _emailController,
          focusNode: _emailFocus,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) => _phoneFocus.requestFocus(),
          label: 'Email',
          semanticLabel: 'Поле ввода email адреса',
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Введите email';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Введите корректный email';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        ProfileFormField(
          controller: _phoneController,
          focusNode: _phoneFocus,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) => _heightFocus.requestFocus(),
          label: 'Телефон (необязательно)',
          semanticLabel: 'Поле ввода номера телефона, необязательное',
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value != null && value.isNotEmpty) {
              if (!RegExp(r'^\+?[1-9]\d{1,14}$')
                  .hasMatch(value.replaceAll(RegExp(r'[\s\-\(\)]'), ''))) {
                return 'Введите корректный номер телефона';
              }
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        ProfileSelectionField<DateTime>(
          label: 'Дата рождения',
          value: _selectedDateOfBirth,
          displayText: _selectedDateOfBirth != null
              ? _formatDateDDMMYYYY(_selectedDateOfBirth!)
              : null,
          onTap: () => _selectDateOfBirth(context),
          validator: (value) {
            if (value == null) {
              return 'Выберите дату рождения';
            }
            final age = DateTime.now().difference(value).inDays / 365.25;
            if (age < _minAge || age > _maxAge) {
              return 'Возраст должен быть от $_minAge до $_maxAge лет';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        ProfileSelectionField<Gender>(
          label: 'Пол',
          value: _selectedGender,
          displayText: _selectedGender?.displayName,
          onTap: () => _selectGender(context),
          validator: (value) {
            if (value == null) {
              return 'Выберите пол';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPhysicalInfoSection({Key? key}) {
    return ProfileFormSection(
      key: key,
      title: 'Физические данные',
      icon: Icons.fitness_center_outlined,
      children: [
        Row(
          children: [
            Expanded(
              child: ProfileFormField(
                controller: _heightController,
                focusNode: _heightFocus,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => _weightFocus.requestFocus(),
                label: 'Рост (см)',
                semanticLabel: 'Поле ввода роста в сантиметрах',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите рост';
                  }
                  final height = int.tryParse(value);
                  if (height == null) {
                    return 'Введите корректное значение роста';
                  }
                  if (height < _minHeight || height > _maxHeight) {
                    return 'Рост должен быть от $_minHeight до $_maxHeight см';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ProfileFormField(
                controller: _weightController,
                focusNode: _weightFocus,
                textInputAction: TextInputAction.done,
                label: 'Вес (кг)',
                semanticLabel: 'Поле ввода веса в килограммах',
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите вес';
                  }
                  final weight = double.tryParse(value);
                  if (weight == null) {
                    return 'Введите корректное значение веса';
                  }
                  if (weight < _minWeight || weight > _maxWeight) {
                    return 'Вес должен быть от $_minWeight до $_maxWeight кг';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ProfileSelectionField<ActivityLevel>(
          label: 'Уровень активности',
          value: _selectedActivityLevel,
          displayText: _selectedActivityLevel?.displayName,
          onTap: () => _selectActivityLevel(context),
          validator: (value) {
            if (value == null) {
              return 'Выберите уровень активности';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildHealthInfoSection({Key? key}) {
    return ProfileFormSection(
      key: key,
      title: 'Здоровье и предпочтения',
      icon: Icons.health_and_safety_outlined,
      children: [
        ProfileMultiSelectionField<DietaryPreference>(
          label: 'Диетические предпочтения',
          selectedItems: _selectedDietaryPreferences,
          allItems: DietaryPreference.values,
          getDisplayText: (item) => item.displayName,
          onSelectionChanged: (items) {
            if (mounted) {
              setState(() {
                _selectedDietaryPreferences = items;
                _onFormChanged();
              });
            }
          },
        ),
        const SizedBox(height: 16),
        ProfileMultiSelectionField<String>(
          label: 'Аллергии',
          selectedItems: _allergies,
          allItems: const [
            'Глютен',
            'Лактоза',
            'Орехи',
            'Морепродукты',
            'Яйца',
            'Соя',
            'Рыба',
            'Молочные продукты',
          ],
          getDisplayText: (item) => item,
          onSelectionChanged: (items) {
            if (mounted) {
              setState(() {
                _allergies = items;
                _onFormChanged();
              });
            }
          },
          canAddCustom: true,
        ),
        const SizedBox(height: 16),
        ProfileMultiSelectionField<String>(
          label: 'Заболевания',
          selectedItems: _healthConditions,
          allItems: const [
            'Диабет',
            'Гипертония',
            'Сердечные заболевания',
            'Заболевания ЖКТ',
            'Заболевания щитовидной железы',
            'Остеопороз',
          ],
          getDisplayText: (item) => item,
          onSelectionChanged: (items) {
            if (mounted) {
              setState(() {
                _healthConditions = items;
                _onFormChanged();
              });
            }
          },
          canAddCustom: true,
        ),
      ],
    );
  }

  Widget _buildNutritionTargetsSection({Key? key}) {
    return ProfileFormSection(
      key: key,
      title: 'Цели по питанию',
      icon: Icons.restaurant_outlined,
      children: [
        ProfileFormField(
          controller: _targetCaloriesController,
          focusNode: _targetCaloriesFocus,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) => _targetProteinFocus.requestFocus(),
          label: 'Целевые калории в день',
          semanticLabel: 'Поле ввода целевых калорий в день',
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (value) {
            if (value != null && value.isNotEmpty) {
              final calories = int.tryParse(value);
              if (calories == null) {
                return 'Введите корректное значение калорий';
              }
              if (calories < _minCalories || calories > _maxCalories) {
                return 'Калории должны быть от $_minCalories до $_maxCalories';
              }
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ProfileFormField(
                controller: _targetProteinController,
                focusNode: _targetProteinFocus,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => _targetCarbsFocus.requestFocus(),
                label: 'Белки (г)',
                semanticLabel: 'Поле ввода целевого количества белков в граммах',
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
                ],
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final protein = double.tryParse(value);
                    if (protein == null) {
                      return 'Введите корректное значение белков';
                    }
                    if (protein < _minProtein || protein > _maxProtein) {
                      return 'Белки: $_minProtein-${_maxProtein.toInt()}г';
                    }
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ProfileFormField(
                controller: _targetCarbsController,
                focusNode: _targetCarbsFocus,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => _targetFatFocus.requestFocus(),
                label: 'Углеводы (г)',
                semanticLabel: 'Поле ввода целевого количества углеводов в граммах',
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
                ],
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final carbs = double.tryParse(value);
                    if (carbs == null) {
                      return 'Введите корректное значение углеводов';
                    }
                    if (carbs < _minCarbs || carbs > _maxCarbs) {
                      return 'Углеводы: ${_minCarbs.toInt()}-${_maxCarbs.toInt()}г';
                    }
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ProfileFormField(
                controller: _targetFatController,
                focusNode: _targetFatFocus,
                textInputAction: TextInputAction.done,
                label: 'Жиры (г)',
                semanticLabel: 'Поле ввода целевого количества жиров в граммах',
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
                ],
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final fat = double.tryParse(value);
                    if (fat == null) {
                      return 'Введите корректное значение жиров';
                    }
                    if (fat < _minFat || fat > _maxFat) {
                      return 'Жиры: ${_minFat.toInt()}-${_maxFat.toInt()}г';
                    }
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGoalsSection({Key? key}) {
    return ProfileFormSection(
      key: key,
      title: 'Фитнес-цели',
      icon: Icons.track_changes_outlined,
      children: [
        ProfileMultiSelectionField<String>(
          label: 'Цели тренировок',
          selectedItems: _fitnessGoals,
          allItems: const [
            'Похудение',
            'Набор мышечной массы',
            'Поддержание формы',
            'Увеличение силы',
            'Повышение выносливости',
            'Улучшение гибкости',
            'Реабилитация',
            'Подготовка к соревнованиям',
          ],
          getDisplayText: (item) => item,
          onSelectionChanged: (items) {
            if (mounted) {
              setState(() {
                _fitnessGoals = items;
                _onFormChanged();
              });
            }
          },
          canAddCustom: true,
        ),
      ],
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.dynamicCard,
        boxShadow: [
          BoxShadow(
            color: AppColors.dynamicShadow.withValues(alpha: 0.1),
            offset: const Offset(0, -1),
            blurRadius: 10,
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _isSubmitting
                    ? null
                    : () {
                        if (_isModified) {
                          _showUnsavedChangesDialog();
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
                style: AppStyles.secondaryButtonStyle,
                child: const Text('Отмена'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _saveProfile,
                style: AppStyles.primaryButtonStyle,
                child: _isSubmitting
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(AppColors.dynamicOnPrimary),
                        ),
                      )
                    : const Text('Сохранить'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Selection methods
  Future<void> _selectDateOfBirth(BuildContext context) async {
    final initialDate = _selectedDateOfBirth ??
        DateTime.now().subtract(const Duration(days: 365 * 25));
    final firstDate = DateTime.now().subtract(const Duration(days: 365 * 120));
    final lastDate = DateTime.now().subtract(const Duration(days: 365 * 13));

    // Используем Bottom Picker для выбора даты
    BottomPicker.date(
      headerBuilder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Выберите дату рождения',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: AppColors.dynamicTextPrimary,
            ),
            textAlign: TextAlign.center,
          ),
        );
      },
      onSubmit: (selectedDate) {
        setState(() {
          _selectedDateOfBirth = selectedDate;
          _onFormChanged();
        });
      },
      onDismiss: (dynamic value) {},
      bottomPickerTheme: BottomPickerTheme.plumPlate,
      maxDateTime: lastDate,
      minDateTime: firstDate,
      initialDateTime: initialDate,
      buttonSingleColor: AppColors.dynamicPrimary,
      backgroundColor: AppColors.dynamicCard,
      pickerTextStyle: TextStyle(
        color: AppColors.dynamicTextPrimary,
        fontSize: 14,
      ),
    ).show(context);
  }

  /// Форматирует дату в формат dd/mm/yyyy
  String _formatDateDDMMYYYY(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  /// Парсит строку формата dd/mm/yyyy в DateTime
  DateTime? _parseDateDDMMYYYY(String dateString) {
    try {
      final parts = dateString.split('/');
      if (parts.length != 3) return null;

      final day = int.tryParse(parts[0]);
      final month = int.tryParse(parts[1]);
      final year = int.tryParse(parts[2]);

      if (day == null || month == null || year == null) return null;
      if (day < 1 || day > 31) return null;
      if (month < 1 || month > 12) return null;
      if (year < 1900 || year > 2100) return null;

      return DateTime(year, month, day);
    } catch (e) {
      return null;
    }
  }

  /// Форматирует дату для отображения (например: "Ср, 24 дек")
  String _formatDateDisplay(DateTime date) {
    const weekdays = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
    const months = [
      'янв',
      'фев',
      'мар',
      'апр',
      'май',
      'июн',
      'июл',
      'авг',
      'сен',
      'окт',
      'ноя',
      'дек'
    ];

    final weekday = weekdays[date.weekday - 1];
    final month = months[date.month - 1];
    return '$weekday, ${date.day} $month';
  }

  /// Автоматически форматирует ввод даты, добавляя "/" после 2-й и 4-й цифры
  String _autoFormatDate(String input) {
    // Удаляем все символы, кроме цифр
    final digitsOnly = input.replaceAll(RegExp(r'[^\d]'), '');
    
    // Ограничиваем до 8 цифр
    final limitedDigits = digitsOnly.length > 8 
        ? digitsOnly.substring(0, 8) 
        : digitsOnly;
    
    if (limitedDigits.isEmpty) {
      return '';
    }
    
    // Форматируем с добавлением "/"
    String formatted = '';
    for (int i = 0; i < limitedDigits.length; i++) {
      if (i == 2 || i == 4) {
        formatted += '/';
      }
      formatted += limitedDigits[i];
    }
    
    return formatted;
  }

  /// Вычисляет позицию курсора после форматирования
  int _calculateCursorPosition({
    required String oldText,
    required String newText,
    required int oldCursorPos,
  }) {
    // Подсчитываем количество цифр до курсора в старом тексте
    final oldDigitsBeforeCursor = oldText
        .substring(0, oldCursorPos.clamp(0, oldText.length))
        .replaceAll(RegExp(r'[^\d]'), '')
        .length;
    
    // Подсчитываем разделители в новом тексте до нужной позиции
    final newDigitsOnly = newText.replaceAll(RegExp(r'[^\d]'), '');
    final digitsToCount = oldDigitsBeforeCursor.clamp(0, newDigitsOnly.length);
    
    int separators = 0;
    if (digitsToCount > 2) separators++;
    if (digitsToCount > 4) separators++;
    
    return digitsToCount + separators;
  }

  Future<void> _selectGender(BuildContext context) async {
    final Gender? selected = await showDialog<Gender>(
      context: context,
      builder: (context) => SimpleDialog(
        backgroundColor: AppColors.dynamicCard,
        title: Text(
          'Выберите пол',
          style: TextStyle(color: AppColors.dynamicTextPrimary),
        ),
        children: Gender.values
            .where((gender) => gender != Gender.other)
            .map((gender) => SimpleDialogOption(
                  onPressed: () => Navigator.of(context).pop(gender),
                  child: Text(
                    gender.displayName,
                    style: TextStyle(color: AppColors.dynamicTextPrimary),
                  ),
                ))
            .toList(),
      ),
    );
    if (selected != null && selected != _selectedGender && mounted) {
      setState(() {
        _selectedGender = selected;
        _onFormChanged();
      });
    }
  }

  Future<void> _selectActivityLevel(BuildContext context) async {
    final ActivityLevel? selected = await showDialog<ActivityLevel>(
      context: context,
      builder: (context) => SimpleDialog(
        backgroundColor: AppColors.dynamicCard,
        title: Text(
          'Выберите уровень активности',
          style: TextStyle(color: AppColors.dynamicTextPrimary),
        ),
        children: ActivityLevel.values
            .map((level) => SimpleDialogOption(
                  onPressed: () => Navigator.of(context).pop(level),
                  child: Text(
                    level.displayName,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.dynamicTextPrimary,
                    ),
                  ),
                ))
            .toList(),
      ),
    );
    if (selected != null && selected != _selectedActivityLevel && mounted) {
      setState(() {
        _selectedActivityLevel = selected;
        _onFormChanged();
      });
    }
  }

  // Save and validation methods
  void _saveProfile() {
    if (!_formKey.currentState!.validate()) {
      _scrollToFirstError();
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final updatedProfile = widget.userProfile.copyWith(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim().isEmpty
          ? null
          : _phoneController.text.trim(),
      dateOfBirth: _selectedDateOfBirth,
      gender: _selectedGender,
      height: _heightController.text.isEmpty
          ? null
          : int.tryParse(_heightController.text)?.toDouble(),
      weight: _weightController.text.isEmpty
          ? null
          : double.tryParse(_weightController.text),
      targetWeight: _targetWeightController.text.isEmpty
          ? null
          : double.tryParse(_targetWeightController.text),
      activityLevel: _selectedActivityLevel,
      targetCalories: _targetCaloriesController.text.isEmpty
          ? null
          : int.tryParse(_targetCaloriesController.text),
      targetProtein: _targetProteinController.text.isEmpty
          ? null
          : double.tryParse(_targetProteinController.text),
      targetCarbs: _targetCarbsController.text.isEmpty
          ? null
          : double.tryParse(_targetCarbsController.text),
      targetFat: _targetFatController.text.isEmpty
          ? null
          : double.tryParse(_targetFatController.text),
      dietaryPreferences: _selectedDietaryPreferences,
      allergies: _allergies,
      healthConditions: _healthConditions,
      fitnessGoals: _fitnessGoals,
    );

    context.read<ProfileBloc>().add(UpdateProfile(updatedProfile));
  }

  void _scrollToFirstError() {
    // Wait for the next frame to ensure validation errors are rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Try to find the first section with an error by checking each section
      final sections = [
        _personalInfoKey,
        _physicalInfoKey,
        _healthInfoKey,
        _nutritionTargetsKey,
        _goalsKey,
      ];

      for (final sectionKey in sections) {
        final context = sectionKey.currentContext;
        if (context != null) {
          // Check if this section's context is still valid and attached
          final renderObject = context.findRenderObject();
          if (renderObject != null && renderObject.attached) {
            // Scroll to this section - this will show the first section
            // that might contain errors (form validation will show errors in order)
            Scrollable.ensureVisible(
              context,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment: 0.1, // Show section near top of viewport
            );
            return;
          }
        }
      }

      // Fallback: scroll to top if no section found
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  // Dialog methods
  void _showUnsavedChangesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.dynamicCard,
        title: Text(
          'Несохраненные изменения',
          style: TextStyle(color: AppColors.dynamicTextPrimary),
        ),
        content: Text(
          'У вас есть несохраненные изменения. Вы действительно хотите выйти?',
          style: TextStyle(color: AppColors.dynamicTextPrimary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Отмена',
              style: TextStyle(color: AppColors.dynamicPrimary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text(
              'Выйти',
              style: TextStyle(color: AppColors.dynamicError),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Профиль успешно обновлен'),
        backgroundColor: AppColors.dynamicSuccess,
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ошибка: $message'),
        backgroundColor: AppColors.dynamicError,
      ),
    );
  }
}

/// TextInputFormatter для автоматического форматирования даты в формате dd/mm/yyyy
class _DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Получаем новый текст
    String newText = newValue.text;
    
    // Удаляем все символы, кроме цифр
    final digitsOnly = newText.replaceAll(RegExp(r'[^\d]'), '');
    
    // Ограничиваем до 8 цифр
    final limitedDigits = digitsOnly.length > 8 
        ? digitsOnly.substring(0, 8) 
        : digitsOnly;

    // Если нет цифр, возвращаем пустое значение
    if (limitedDigits.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    // Форматируем с добавлением "/" после 2-й и 4-й цифры
    String formatted = '';
    for (int i = 0; i < limitedDigits.length; i++) {
      if (i == 2 || i == 4) {
        formatted += '/';
      }
      formatted += limitedDigits[i];
    }

    // Вычисляем позицию курсора
    final oldDigits = oldValue.text.replaceAll(RegExp(r'[^\d]'), '').length;
    final newDigits = limitedDigits.length;
    
    int cursorPosition;
    
    if (newDigits < oldDigits) {
      // Удаляли символы
      final oldCursorPos = oldValue.selection.baseOffset.clamp(0, oldValue.text.length);
      final oldTextBeforeCursor = oldValue.text.substring(0, oldCursorPos);
      final oldDigitsBeforeCursor = oldTextBeforeCursor.replaceAll(RegExp(r'[^\d]'), '').length;
      
      final adjustedDigits = oldDigitsBeforeCursor.clamp(0, newDigits);
      int separators = 0;
      if (adjustedDigits > 2) separators++;
      if (adjustedDigits > 4) separators++;
      
      cursorPosition = adjustedDigits + separators;
    } else {
      // Добавляли символы
      final cursorOffset = newValue.selection.baseOffset;
      // Подсчитываем количество цифр до курсора в новом тексте
      final textBeforeCursor = newText.substring(0, cursorOffset.clamp(0, newText.length));
      final digitsBeforeCursor = textBeforeCursor.replaceAll(RegExp(r'[^\d]'), '').length;
      
      int separators = 0;
      if (digitsBeforeCursor > 2) separators++;
      if (digitsBeforeCursor > 4) separators++;
      
      cursorPosition = digitsBeforeCursor + separators;
      
      // Если курсор на разделителе, перемещаем после него
      if (cursorPosition < formatted.length && formatted[cursorPosition] == '/') {
        cursorPosition++;
      }
    }

    // Ограничиваем позицию курсора
    cursorPosition = cursorPosition.clamp(0, formatted.length);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }
}
