import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../domain/entities/goal.dart';
import '../bloc/goals_bloc.dart';
import '../../../../shared/theme/app_colors.dart';
import 'progress_screen.dart';

class GoalsSetupScreen extends StatefulWidget {
  const GoalsSetupScreen({super.key});

  @override
  State<GoalsSetupScreen> createState() => _GoalsSetupScreenState();
}

class _GoalsSetupScreenState extends State<GoalsSetupScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();

  // Weight Goal Controllers
  final _weightGoalTitleController = TextEditingController();
  final _targetWeightController = TextEditingController();
  final _currentWeightController = TextEditingController();
  String _weightGoalType = 'lose';
  DateTime? _weightTargetDate;

  // Activity Goal Controllers
  final _activityGoalTitleController = TextEditingController();
  final _workoutsPerWeekController = TextEditingController();
  final _minutesPerWorkoutController = TextEditingController();
  DateTime? _activityTargetDate;

  // Nutrition Goal Controllers
  final _nutritionGoalTitleController = TextEditingController();
  final _waterIntakeController = TextEditingController();
  final _caloriesController = TextEditingController();
  DateTime? _nutritionTargetDate;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _initializeDefaultValues();
  }

  void _initializeDefaultValues() {
    _weightGoalTitleController.text = 'Достичь идеального веса';
    _activityGoalTitleController.text = 'Регулярные тренировки';
    _nutritionGoalTitleController.text = 'Здоровое питание';
    _workoutsPerWeekController.text = '3';
    _minutesPerWorkoutController.text = '60';
    _waterIntakeController.text = '2.0';
    _caloriesController.text = '2000';
  }

  @override
  void dispose() {
    _tabController.dispose();
    _weightGoalTitleController.dispose();
    _targetWeightController.dispose();
    _currentWeightController.dispose();
    _activityGoalTitleController.dispose();
    _workoutsPerWeekController.dispose();
    _minutesPerWorkoutController.dispose();
    _nutritionGoalTitleController.dispose();
    _waterIntakeController.dispose();
    _caloriesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.instance<GoalsBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Настройка целей'),
          backgroundColor: AppColors.green,
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/main',
                (route) => false,
              );
            },
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ProgressScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.show_chart),
              tooltip: 'Посмотреть прогресс',
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: const [
              Tab(icon: Icon(Icons.monitor_weight), text: 'Вес'),
              Tab(icon: Icon(Icons.fitness_center), text: 'Активность'),
              Tab(icon: Icon(Icons.restaurant), text: 'Питание'),
            ],
          ),
        ),
        body: BlocListener<GoalsBloc, GoalsState>(
          listener: (context, state) {
            if (state is GoalsOperationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.green,
                ),
              );
            } else if (state is GoalsError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildWeightGoalTab(),
              _buildActivityGoalTab(),
              _buildNutritionGoalTab(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeightGoalTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Цель по весу',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _weightGoalTitleController,
                      decoration: const InputDecoration(
                        labelText: 'Название цели',
                        hintText: 'Например: Сбросить 5 кг к лету',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Введите название цели';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text('Тип цели:',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(
                          value: 'lose',
                          label: Text('Похудеть'),
                          icon: Icon(Icons.trending_down),
                        ),
                        ButtonSegment(
                          value: 'gain',
                          label: Text('Набрать'),
                          icon: Icon(Icons.trending_up),
                        ),
                        ButtonSegment(
                          value: 'maintain',
                          label: Text('Поддерживать'),
                          icon: Icon(Icons.horizontal_rule),
                        ),
                      ],
                      selected: {_weightGoalType},
                      onSelectionChanged: (Set<String> newSelection) {
                        setState(() {
                          _weightGoalType = newSelection.first;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _currentWeightController,
                            decoration: const InputDecoration(
                              labelText: 'Текущий вес (кг)',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Введите текущий вес';
                              }
                              final weight = double.tryParse(value);
                              if (weight == null ||
                                  weight < 30 ||
                                  weight > 300) {
                                return 'Вес должен быть от 30 до 300 кг';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _targetWeightController,
                            decoration: const InputDecoration(
                              labelText: 'Целевой вес (кг)',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Введите целевой вес';
                              }
                              final weight = double.tryParse(value);
                              if (weight == null ||
                                  weight < 30 ||
                                  weight > 300) {
                                return 'Вес должен быть от 30 до 300 кг';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      title: Text(_weightTargetDate == null
                          ? 'Выберите целевую дату'
                          : 'Целевая дата: ${_formatDate(_weightTargetDate!)}'),
                      leading: const Icon(Icons.calendar_today),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () => _selectDate(context, (date) {
                        setState(() => _weightTargetDate = date);
                      }),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _createWeightGoal(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Создать цель по весу'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityGoalTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Цель по активности',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _activityGoalTitleController,
                    decoration: const InputDecoration(
                      labelText: 'Название цели',
                      hintText: 'Например: Тренировки 3 раза в неделю',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _workoutsPerWeekController,
                          decoration: const InputDecoration(
                            labelText: 'Тренировок в неделю',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _minutesPerWorkoutController,
                          decoration: const InputDecoration(
                            labelText: 'Минут за тренировку',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: Text(_activityTargetDate == null
                        ? 'Выберите целевую дату'
                        : 'Целевая дата: ${_formatDate(_activityTargetDate!)}'),
                    leading: const Icon(Icons.calendar_today),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () => _selectDate(context, (date) {
                      setState(() => _activityTargetDate = date);
                    }),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _createActivityGoal(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Создать цель по активности'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionGoalTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Цель по питанию',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nutritionGoalTitleController,
                    decoration: const InputDecoration(
                      labelText: 'Название цели',
                      hintText: 'Например: Пить 2 литра воды в день',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _waterIntakeController,
                          decoration: const InputDecoration(
                            labelText: 'Вода в день (л)',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _caloriesController,
                          decoration: const InputDecoration(
                            labelText: 'Калории в день',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: Text(_nutritionTargetDate == null
                        ? 'Выберите целевую дату'
                        : 'Целевая дата: ${_formatDate(_nutritionTargetDate!)}'),
                    leading: const Icon(Icons.calendar_today),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () => _selectDate(context, (date) {
                      setState(() => _nutritionTargetDate = date);
                    }),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _createNutritionGoal(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Создать цель по питанию'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(
      BuildContext context, Function(DateTime) onDateSelected) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (picked != null) {
      onDateSelected(picked);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  void _createWeightGoal(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    if (_weightTargetDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Выберите целевую дату')),
      );
      return;
    }

    final currentWeight = double.parse(_currentWeightController.text);
    final targetWeight = double.parse(_targetWeightController.text);

    context.read<GoalsBloc>().add(CreateGoal(
          userId: 'demo-user-id', // В реальном приложении получать из AuthBloc
          type: GoalType.weight,
          title: _weightGoalTitleController.text,
          targetValue: targetWeight,
          unit: 'кг',
          targetDate: _weightTargetDate,
          metadata: {
            'weightGoalType': _weightGoalType,
            'startValue': currentWeight,
            'tolerance': 1.0,
          },
        ));
  }

  void _createActivityGoal(BuildContext context) {
    final workoutsPerWeek = int.tryParse(_workoutsPerWeekController.text) ?? 3;
    final minutesPerWorkout =
        int.tryParse(_minutesPerWorkoutController.text) ?? 60;
    final totalMinutesPerWeek =
        (workoutsPerWeek * minutesPerWorkout).toDouble();

    context.read<GoalsBloc>().add(CreateGoal(
          userId: 'demo-user-id',
          type: GoalType.activity,
          title: _activityGoalTitleController.text,
          targetValue: totalMinutesPerWeek,
          unit: 'мин/неделя',
          targetDate: _activityTargetDate,
          metadata: {
            'workoutsPerWeek': workoutsPerWeek,
            'durationPerWorkout': minutesPerWorkout,
          },
        ));
  }

  void _createNutritionGoal(BuildContext context) {
    final waterIntake = double.tryParse(_waterIntakeController.text) ?? 2.0;

    context.read<GoalsBloc>().add(CreateGoal(
          userId: 'demo-user-id',
          type: GoalType.nutrition,
          title: _nutritionGoalTitleController.text,
          targetValue: waterIntake,
          unit: 'л/день',
          targetDate: _nutritionTargetDate,
          metadata: {
            'targetCalories': int.tryParse(_caloriesController.text) ?? 2000,
          },
        ));
  }
}
