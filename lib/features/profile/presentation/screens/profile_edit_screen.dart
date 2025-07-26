import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user_profile.dart';
import '../blocs/profile_bloc.dart';
import '../widgets/profile_form_section.dart';
import '../widgets/profile_form_field.dart';
import '../widgets/profile_selection_field.dart';
import '../widgets/profile_multi_selection_field.dart';
import '../../../../shared/theme/app_colors.dart';

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
    if (!_isModified) {
      setState(() {
        _isModified = true;
      });
    }
  }

  @override
  void dispose() {
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
        backgroundColor: AppColors.background,
        appBar: _buildAppBar(),
        body: BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileUpdated) {
              setState(() {
                _isSubmitting = false;
                _isModified = false;
              });
              _showSuccessMessage();
              Navigator.of(context).pop(true);
            } else if (state is ProfileError) {
              setState(() {
                _isSubmitting = false;
              });
              _showErrorMessage(state.message);
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
                        _buildPersonalInfoSection(),
                        const SizedBox(height: 24),
                        _buildPhysicalInfoSection(),
                        const SizedBox(height: 24),
                        _buildHealthInfoSection(),
                        const SizedBox(height: 24),
                        _buildNutritionTargetsSection(),
                        const SizedBox(height: 24),
                        _buildGoalsSection(),
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
      backgroundColor: AppColors.green,
      foregroundColor: Colors.white,
      elevation: 0,
      title: const Text(
        'Редактировать профиль',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        if (_isModified && !_isSubmitting)
          TextButton(
            onPressed: _saveProfile,
            child: const Text(
              'Сохранить',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPersonalInfoSection() {
    return ProfileFormSection(
      title: 'Личная информация',
      icon: Icons.person_outline,
      children: [
        Row(
          children: [
            Expanded(
              child: ProfileFormField(
                controller: _firstNameController,
                label: 'Имя',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Введите имя';
                  }
                  if (value.trim().length < 2) {
                    return 'Имя должно содержать минимум 2 символа';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ProfileFormField(
                controller: _lastNameController,
                label: 'Фамилия',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Введите фамилию';
                  }
                  if (value.trim().length < 2) {
                    return 'Фамилия должна содержать минимум 2 символа';
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
          label: 'Email',
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
          label: 'Телефон (необязательно)',
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value != null && value.isNotEmpty) {
              if (!RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(value.replaceAll(RegExp(r'[\s\-\(\)]'), ''))) {
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
              ? '${_selectedDateOfBirth!.day.toString().padLeft(2, '0')}.${_selectedDateOfBirth!.month.toString().padLeft(2, '0')}.${_selectedDateOfBirth!.year}'
              : null,
          onTap: () => _selectDateOfBirth(context),
          validator: (value) {
            if (value == null) {
              return 'Выберите дату рождения';
            }
            final age = DateTime.now().difference(value).inDays / 365.25;
            if (age < 13 || age > 120) {
              return 'Возраст должен быть от 13 до 120 лет';
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

  Widget _buildPhysicalInfoSection() {
    return ProfileFormSection(
      title: 'Физические данные',
      icon: Icons.fitness_center_outlined,
      children: [
        Row(
          children: [
            Expanded(
              child: ProfileFormField(
                controller: _heightController,
                label: 'Рост (см)',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите рост';
                  }
                  final height = int.tryParse(value);
                  if (height == null || height < 100 || height > 250) {
                    return 'Рост должен быть от 100 до 250 см';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ProfileFormField(
                controller: _weightController,
                label: 'Вес (кг)',
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите вес';
                  }
                  final weight = double.tryParse(value);
                  if (weight == null || weight < 30 || weight > 300) {
                    return 'Вес должен быть от 30 до 300 кг';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ProfileFormField(
          controller: _targetWeightController,
          label: 'Целевой вес (кг, необязательно)',
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
          ],
          validator: (value) {
            if (value != null && value.isNotEmpty) {
              final weight = double.tryParse(value);
              if (weight == null || weight < 30 || weight > 300) {
                return 'Целевой вес должен быть от 30 до 300 кг';
              }
            }
            return null;
          },
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

  Widget _buildHealthInfoSection() {
    return ProfileFormSection(
      title: 'Здоровье и предпочтения',
      icon: Icons.health_and_safety_outlined,
      children: [
        ProfileMultiSelectionField<DietaryPreference>(
          label: 'Диетические предпочтения',
          selectedItems: _selectedDietaryPreferences,
          allItems: DietaryPreference.values,
          getDisplayText: (item) => item.displayName,
          onSelectionChanged: (items) {
            setState(() {
              _selectedDietaryPreferences = items;
              _onFormChanged();
            });
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
            setState(() {
              _allergies = items;
              _onFormChanged();
            });
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
            setState(() {
              _healthConditions = items;
              _onFormChanged();
            });
          },
          canAddCustom: true,
        ),
      ],
    );
  }

  Widget _buildNutritionTargetsSection() {
    return ProfileFormSection(
      title: 'Цели по питанию',
      icon: Icons.restaurant_outlined,
      children: [
        ProfileFormField(
          controller: _targetCaloriesController,
          label: 'Целевые калории в день',
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (value) {
            if (value != null && value.isNotEmpty) {
              final calories = int.tryParse(value);
              if (calories == null || calories < 800 || calories > 5000) {
                return 'Калории должны быть от 800 до 5000';
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
                label: 'Белки (г)',
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
                ],
                                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      final protein = double.tryParse(value);
                      if (protein == null || protein < 10 || protein > 300) {
                        return 'Белки: 10-300г';
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
                label: 'Углеводы (г)',
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
                ],
                                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      final carbs = double.tryParse(value);
                      if (carbs == null || carbs < 20 || carbs > 500) {
                        return 'Углеводы: 20-500г';
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
                label: 'Жиры (г)',
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
                ],
                                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      final fat = double.tryParse(value);
                      if (fat == null || fat < 10 || fat > 200) {
                        return 'Жиры: 10-200г';
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

  Widget _buildGoalsSection() {
    return ProfileFormSection(
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
            setState(() {
              _fitnessGoals = items;
              _onFormChanged();
            });
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
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
                onPressed: _isSubmitting ? null : () {
                  if (_isModified) {
                    _showUnsavedChangesDialog();
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                                 style: OutlinedButton.styleFrom(
                   padding: const EdgeInsets.symmetric(vertical: 16),
                   side: BorderSide(color: AppColors.green),
                 ),
                child: const Text('Отмена'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _saveProfile,
                                 style: ElevatedButton.styleFrom(
                   backgroundColor: AppColors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateOfBirth ?? DateTime.now().subtract(const Duration(days: 365 * 25)),
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 120)),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 13)),
    );
    if (picked != null && picked != _selectedDateOfBirth) {
      setState(() {
        _selectedDateOfBirth = picked;
        _onFormChanged();
      });
    }
  }

  Future<void> _selectGender(BuildContext context) async {
    final Gender? selected = await showDialog<Gender>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Выберите пол'),
        children: Gender.values.map((gender) => SimpleDialogOption(
          onPressed: () => Navigator.of(context).pop(gender),
          child: Text(gender.displayName),
        )).toList(),
      ),
    );
    if (selected != null && selected != _selectedGender) {
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
        title: const Text('Выберите уровень активности'),
        children: ActivityLevel.values.map((level) => SimpleDialogOption(
          onPressed: () => Navigator.of(context).pop(level),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                level.displayName,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
                             Text(
                 level.displayName,
                 style: const TextStyle(fontSize: 12, color: Colors.grey),
               ),
            ],
          ),
        )).toList(),
      ),
    );
    if (selected != null && selected != _selectedActivityLevel) {
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
      phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
      dateOfBirth: _selectedDateOfBirth,
      gender: _selectedGender,
      height: _heightController.text.isEmpty ? null : double.tryParse(_heightController.text),
      weight: _weightController.text.isEmpty ? null : double.tryParse(_weightController.text),
      targetWeight: _targetWeightController.text.isEmpty ? null : double.tryParse(_targetWeightController.text),
      activityLevel: _selectedActivityLevel,
      targetCalories: _targetCaloriesController.text.isEmpty ? null : int.tryParse(_targetCaloriesController.text),
      targetProtein: _targetProteinController.text.isEmpty ? null : double.tryParse(_targetProteinController.text),
      targetCarbs: _targetCarbsController.text.isEmpty ? null : double.tryParse(_targetCarbsController.text),
      targetFat: _targetFatController.text.isEmpty ? null : double.tryParse(_targetFatController.text),
      dietaryPreferences: _selectedDietaryPreferences,
      allergies: _allergies,
      healthConditions: _healthConditions,
      fitnessGoals: _fitnessGoals,
    );

    context.read<ProfileBloc>().add(UpdateProfile(updatedProfile));
  }

  void _scrollToFirstError() {
    // Scroll to the first validation error
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // Dialog methods
  void _showUnsavedChangesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Несохраненные изменения'),
        content: const Text('У вас есть несохраненные изменения. Вы действительно хотите выйти?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Выйти'),
          ),
        ],
      ),
    );
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Профиль успешно обновлен'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ошибка: $message'),
        backgroundColor: Colors.red,
      ),
    );
  }
} 