import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/goals_setup_bloc.dart';
import '../../domain/entities/user_goals.dart';
import '../../di/onboarding_dependencies.dart';
import 'package:nutry_flow/shared/theme/app_colors.dart';

class GoalsSetupScreen extends StatelessWidget {
  const GoalsSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const GoalsSetupView();
  }
}

class GoalsSetupView extends StatelessWidget {
  const GoalsSetupView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Настройка целей'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Шаг 2 из 2',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      '100%',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.button,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: LinearProgressIndicator(
                  value: 1.0,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.button),
                  minHeight: 4,
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
      body: BlocListener<GoalsSetupBloc, GoalsSetupState>(
        listener: (context, state) {
          if (state is GoalsSetupError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is GoalsSetupSaved) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Настройки целей сохранены!'),
                backgroundColor: Colors.green,
              ),
            );
            // Переход к дашборду
            Navigator.pushNamedAndRemoveUntil(
              context, 
              '/app', 
              (route) => false
            );
          }
        },
        child: BlocBuilder<GoalsSetupBloc, GoalsSetupState>(
          builder: (context, state) {
            if (state is GoalsSetupSaving) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Индикатор прогресса
                  _buildProgressIndicator(),
                  const SizedBox(height: 24),
                  
                  // Выбор основной цели
                  _buildGoalSelection(context),
                  const SizedBox(height: 32),
                  
                  // Целевые параметры
                  if (state is GoalsSetupLoaded && state.goals.fitnessGoals.isNotEmpty) ...[
                    _buildTargetParameters(context, state.goals),
                    const SizedBox(height: 32),
                  ],
                  
                  // Диетические предпочтения
                  _buildDietaryPreferences(context, state),
                  const SizedBox(height: 32),
                  
                  // Настройка активности
                  _buildActivitySettings(context, state),
                  const SizedBox(height: 32),
                  
                  // Кнопки навигации
                  _buildNavigationButtons(context, state),
                  const SizedBox(height: 16),
                  
                  // Кнопка пропуска
                  _buildSkipButton(context),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'Шаг 4 из 4',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const Spacer(),
            Text(
              '100%',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: 1.0,
          backgroundColor: Colors.grey[200],
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
      ],
    );
  }

  Widget _buildGoalSelection(BuildContext context) {
    final goals = [
      {
        'id': 'weight_loss',
        'title': 'Похудение',
        'description': 'Снижение веса',
        'icon': Icons.trending_down,
        'color': AppColors.green,
      },
      {
        'id': 'maintenance',
        'title': 'Поддержание веса',
        'description': 'Сохранение текущего веса',
        'icon': Icons.balance,
        'color': AppColors.yellow,
      },
      {
        'id': 'muscle_gain',
        'title': 'Набор массы',
        'description': 'Увеличение мышечной массы',
        'icon': Icons.fitness_center,
        'color': AppColors.orange,
      },
      {
        'id': 'health',
        'title': 'Улучшение здоровья',
        'description': 'Общее оздоровление',
        'icon': Icons.favorite,
        'color': AppColors.gray,
      },
    ];

    return BlocBuilder<GoalsSetupBloc, GoalsSetupState>(
      builder: (context, state) {
        final selectedGoal = state is GoalsSetupLoaded && state.goals.fitnessGoals.isNotEmpty ? state.goals.fitnessGoals.first : null;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Выберите основную цель',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.2,
              ),
              itemCount: goals.length,
              itemBuilder: (context, index) {
                final goal = goals[index];
                final isSelected = selectedGoal == goal['id'];
                
                return GestureDetector(
                  onTap: () {
                    context.read<GoalsSetupBloc>().add(GoalSelected(goal['id'] as String));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? (goal['color'] as Color).withOpacity(0.1) : Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? (goal['color'] as Color) : Colors.grey[300]!,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          goal['icon'] as IconData?,
                          size: 32,
                          color: goal['color'] as Color,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          goal['title'] as String,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isSelected ? (goal['color'] as Color) : Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          goal['description'] as String,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildTargetParameters(BuildContext context, UserGoals goals) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Параметры',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        // Рост
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Рост (см)',
            hintText: 'Введите рост',
            border: UnderlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          initialValue: goals.targetWeight?.toString(), // TODO: заменить на height, если появится
          onChanged: (value) {
            context.read<GoalsSetupBloc>().add(
              TargetWeightChanged(double.tryParse(value)),
            );
          },
        ),
        const SizedBox(height: 16),
        
        // Вес
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Вес (кг)',
            hintText: 'Введите вес',
            border: UnderlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          initialValue: goals.targetWeight?.toString(),
          onChanged: (value) {
            context.read<GoalsSetupBloc>().add(
              TargetWeightChanged(double.tryParse(value)),
            );
          },
        ),
        const SizedBox(height: 16),
        
        // Временные рамки
        Text(
          'Период достижения цели',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<int>(
          value: 3,
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
          ),
          items: List.generate(12, (index) => index + 1)
              .map((month) => DropdownMenuItem(
                    value: month,
                    child: Text('$month ${_getMonthText(month)}'),
                  ))
              .toList(),
          onChanged: (value) {
            if (value != null) {
              // context.read<GoalsSetupBloc>().add(TimeframeChanged(value));
            }
          },
        ),
      ],
    );
  }

  Widget _buildDietaryPreferences(BuildContext context, GoalsSetupState state) {
    final dietTypes = [
      'Обычное питание',
      'Вегетарианство',
      'Веганство',
      'Кето-диета',
      'Палео-диета',
      'Безглютеновая диета',
    ];

    final allergens = [
      'Глютен',
      'Лактоза',
      'Орехи',
      'Морепродукты',
      'Яйца',
      'Соя',
    ];

    if (state is! GoalsSetupLoaded) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Диетические предпочтения',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        // Тип диеты
        Text(
          'Тип диеты',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: state.goals.dietaryPreferences.isNotEmpty ? state.goals.dietaryPreferences.first : null,
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            hintText: 'Выберите тип диеты',
          ),
          items: dietTypes
              .map((diet) => DropdownMenuItem(
                    value: diet,
                    child: Text(diet),
                  ))
              .toList(),
          onChanged: (value) {
            if (value != null) {
              // context.read<GoalsSetupBloc>().add(DietTypeChanged(value));
            }
          },
        ),
        const SizedBox(height: 16),
        
        // Аллергены
        Text(
          'Пищевые аллергии',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: allergens.map((allergen) {
            final isSelected = state.goals.healthConditions.contains(allergen);
            return FilterChip(
              label: Text(allergen),
              selected: isSelected,
              selectedColor: AppColors.green,
              checkmarkColor: Colors.white,
              onSelected: (selected) {
                context.read<GoalsSetupBloc>().add(AllergenToggled(allergen));
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildActivitySettings(BuildContext context, GoalsSetupState state) {
    final workoutTypes = [
      'Кардио',
      'Силовые тренировки',
      'Йога/Стретчинг',
      'Командные виды спорта',
      'Домашние тренировки',
    ];

    if (state is! GoalsSetupLoaded) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Настройка активности',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        // Тип тренировок
        Text(
          'Тип тренировок',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Column(
          children: [
            // Первая строка
            Row(
              children: [
                Flexible(
                  flex: 1,
                  child: _buildWorkoutTypeChip(context, state, 'Кардио'),
                ),
                const SizedBox(width: 8),
                Flexible(
                  flex: 2, // Больше места для "Силовых тренировок"
                  child: _buildWorkoutTypeChip(context, state, 'Силовые тренировки'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Вторая строка
            Row(
              children: [
                Flexible(
                  flex: 1,
                  child: _buildWorkoutTypeChip(context, state, 'Йога/Стретчинг'),
                ),
                const SizedBox(width: 8),
                Flexible(
                  flex: 1,
                  child: _buildWorkoutTypeChipWithFade(context, state, 'Командные виды спорта'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Третья строка
            Row(
              children: [
                Flexible(
                  flex: 2, // Делаем этот элемент в 2 раза шире
                  child: _buildWorkoutTypeChip(context, state, 'Домашние тренировки'),
                ),
                const SizedBox(width: 8),
                const Flexible(
                  flex: 1, // Меньше места для пустого пространства
                  child: SizedBox(),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Частота тренировок
        Text(
          'Частота тренировок (раз в неделю)',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Slider(
          value: (state.goals.workoutFrequency != null && state.goals.workoutFrequency! >= 1 && state.goals.workoutFrequency! <= 7)
            ? state.goals.workoutFrequency!.toDouble()
            : 1.0,
          min: 1,
          max: 7,
          divisions: 6,
          label: '${(state.goals.workoutFrequency != null && state.goals.workoutFrequency! >= 1 && state.goals.workoutFrequency! <= 7)
            ? state.goals.workoutFrequency
            : 1}',
          activeColor: AppColors.yellow,
          onChanged: (value) {
            context.read<GoalsSetupBloc>().add(WorkoutFrequencyChanged(value.round()));
          },
        ),
        
        // Продолжительность тренировок
        Text(
          'Продолжительность тренировки (минуты)',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Slider(
          value: (state.goals.targetProtein != null && state.goals.targetProtein! >= 15 && state.goals.targetProtein! <= 120)
            ? state.goals.targetProtein!.toDouble()
            : 15.0,
          min: 15,
          max: 120,
          divisions: 7,
          label: '${(state.goals.targetProtein != null && state.goals.targetProtein! >= 15 && state.goals.targetProtein! <= 120)
            ? state.goals.targetProtein
            : 15}', // TODO: заменить на workoutDuration
          activeColor: AppColors.yellow,
          onChanged: (value) {
            context.read<GoalsSetupBloc>().add(WorkoutDurationChanged(value.round()));
          },
        ),
      ],
    );
  }

  Widget _buildNavigationButtons(BuildContext context, GoalsSetupState state) {
    final canProceed = state is GoalsSetupLoaded && state.isValid;
    
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/profile-info');
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: AppColors.button,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            child: const Text('Назад'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: canProceed ? () {
              print('🟤 GoalsSetupScreen: Завершить button pressed');
              print('🟤 GoalsSetupScreen: canProceed = $canProceed');
              print('🟤 GoalsSetupScreen: state = ${state.runtimeType}');
              if (state is GoalsSetupLoaded) {
                print('🟤 GoalsSetupScreen: state.isValid = ${state.isValid}');
              }
              context.read<GoalsSetupBloc>().add(SaveGoals());
            } : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Завершить'),
          ),
        ),
      ],
    );
  }

  Widget _buildSkipButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: TextButton(
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(
            context, 
            '/app', 
            (route) => false
          );
        },
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(
          'Пропустить настройку целей',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Widget _buildWorkoutTypeChip(BuildContext context, GoalsSetupState state, String type) {
    if (state is! GoalsSetupLoaded) {
      return const SizedBox.shrink();
    }
    
    final isSelected = state.goals.workoutTypes.contains(type); // теперь используем workoutTypes
    return FilterChip(
      label: Text(
        type,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      selected: isSelected,
      selectedColor: AppColors.green,
      checkmarkColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      onSelected: (selected) {
        context.read<GoalsSetupBloc>().add(WorkoutTypeToggled(type));
      },
    );
  }

  Widget _buildWorkoutTypeChipWithFade(BuildContext context, GoalsSetupState state, String type) {
    if (state is! GoalsSetupLoaded) {
      return const SizedBox.shrink();
    }
    
    final isSelected = state.goals.workoutTypes.contains(type); // теперь используем workoutTypes
    return FilterChip(
      label: ShaderMask(
        shaderCallback: (bounds) {
          return LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.black,
              Colors.black,
              Colors.black.withOpacity(0.3),
              Colors.transparent,
            ],
            stops: const [0.0, 0.6, 0.8, 1.0],
          ).createShader(bounds);
        },
        blendMode: BlendMode.dstIn,
        child: Text(
          type,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.clip,
        ),
      ),
      selected: isSelected,
      selectedColor: AppColors.green,
      checkmarkColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      onSelected: (selected) {
        context.read<GoalsSetupBloc>().add(WorkoutTypeToggled(type));
      },
    );
  }

  String _getMonthText(int month) {
    if (month == 1) return 'месяц';
    if (month >= 2 && month <= 4) return 'месяца';
    return 'месяцев';
  }
} 