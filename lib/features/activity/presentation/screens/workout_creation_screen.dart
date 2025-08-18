import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../bloc/workout_bloc.dart';
import '../../domain/entities/workout.dart';
import '../../domain/entities/exercise.dart';
import '../../../../shared/design/tokens/design_tokens.dart';

class WorkoutCreationScreen extends StatefulWidget {
  const WorkoutCreationScreen({super.key});

  @override
  State<WorkoutCreationScreen> createState() => _WorkoutCreationScreenState();
}

class _WorkoutCreationScreenState extends State<WorkoutCreationScreen> {
  late WorkoutBloc _workoutBloc;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _durationController = TextEditingController();

  WorkoutDifficulty _selectedDifficulty = WorkoutDifficulty.beginner;
  final List<WorkoutExercise> _workoutExercises = [];

  @override
  void initState() {
    super.initState();
    _workoutBloc = GetIt.instance.get<WorkoutBloc>();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.surface,
      appBar: AppBar(
        title: Text(
          'Создать тренировку',
          style: context.typography.headlineSmallStyle.copyWith(
            color: context.colors.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: context.colors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: context.colors.onSurface,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          TextButton(
            onPressed: _saveWorkout,
            child: Text(
              'Сохранить',
              style: context.typography.labelLargeStyle.copyWith(
                color: context.colors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: BlocProvider.value(
        value: _workoutBloc,
        child: BlocListener<WorkoutBloc, WorkoutState>(
          listener: (context, state) {
            if (state is WorkoutCreated) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Тренировка "${state.workout.name}" создана!'),
                  backgroundColor: context.colors.primary,
                ),
              );
              Navigator.of(context).pop();
            } else if (state is WorkoutError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: context.colors.error,
                ),
              );
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBasicInfoSection(),
                  const SizedBox(height: 24),
                  _buildExercisesSection(),
                  const SizedBox(height: 24),
                  _buildWorkoutPreview(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Основная информация',
              style: context.typography.titleMediumStyle.copyWith(
                fontWeight: FontWeight.w600,
                color: context.colors.onSurface,
              ),
            ),
            const SizedBox(height: 16),

            // Название тренировки
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Название тренировки',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(
                  Icons.fitness_center,
                  color: context.colors.onSurfaceVariant,
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Введите название тренировки';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Описание
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Описание (необязательно)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(
                  Icons.description,
                  color: context.colors.onSurfaceVariant,
                ),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),

            // Длительность
            TextFormField(
              controller: _durationController,
              decoration: InputDecoration(
                labelText: 'Примерная длительность (минуты)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(
                  Icons.timer,
                  color: context.colors.onSurfaceVariant,
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            // Сложность
            Text(
              'Сложность',
              style: context.typography.bodyMediumStyle.copyWith(
                fontWeight: FontWeight.w500,
                color: context.colors.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            SegmentedButton<WorkoutDifficulty>(
              segments: const [
                ButtonSegment(
                  value: WorkoutDifficulty.beginner,
                  label: Text('Начинающий'),
                ),
                ButtonSegment(
                  value: WorkoutDifficulty.intermediate,
                  label: Text('Средний'),
                ),
                ButtonSegment(
                  value: WorkoutDifficulty.advanced,
                  label: Text('Продвинутый'),
                ),
              ],
              selected: {_selectedDifficulty},
              onSelectionChanged: (Set<WorkoutDifficulty> selection) {
                setState(() {
                  _selectedDifficulty = selection.first;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExercisesSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Упражнения',
                  style: context.typography.titleMediumStyle.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.colors.onSurface,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _addExercise,
                  icon: const Icon(Icons.add),
                  label: const Text('Добавить'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colors.primary,
                    foregroundColor: context.colors.onPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_workoutExercises.isEmpty)
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.fitness_center_outlined,
                      size: 64,
                      color: context.colors.onSurfaceVariant,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Нет упражнений',
                      style: context.typography.bodyLargeStyle.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Добавьте упражнения для создания тренировки',
                      style: context.typography.bodyMediumStyle.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _workoutExercises.length,
                itemBuilder: (context, index) {
                  final exercise = _workoutExercises[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: context.colors.primaryLight,
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: context.colors.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      title: Text(exercise.exercise.name),
                      subtitle: Text(
                        '${exercise.sets ?? 0} x ${exercise.reps ?? 0} повторений',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _removeExercise(index),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutPreview() {
    if (_workoutExercises.isEmpty) return const SizedBox.shrink();

    final totalDuration = _workoutExercises.fold<int>(0, (sum, exercise) {
      if (exercise.duration != null) {
        final durationStr = exercise.duration!;
        if (durationStr.contains('мин')) {
          final minutes = int.tryParse(durationStr.replaceAll(' мин', ''));
          return sum + (minutes ?? 0);
        }
      }
      return sum + (exercise.sets ?? 0) * 2; // 2 минуты на подход
    });

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Предварительный просмотр',
              style: context.typography.titleMediumStyle.copyWith(
                fontWeight: FontWeight.w600,
                color: context.colors.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildPreviewItem(
                  Icons.fitness_center,
                  'Упражнений',
                  _workoutExercises.length.toString(),
                ),
                const SizedBox(width: 16),
                _buildPreviewItem(
                  Icons.timer,
                  'Длительность',
                  '$totalDuration мин',
                ),
                const SizedBox(width: 16),
                _buildPreviewItem(
                  Icons.trending_up,
                  'Сложность',
                  _getDifficultyDisplayName(_selectedDifficulty),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewItem(IconData icon, String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Icon(
            icon,
            color: context.colors.primary,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: context.typography.titleSmallStyle.copyWith(
              fontWeight: FontWeight.w600,
              color: context.colors.onSurface,
            ),
          ),
          Text(
            label,
            style: context.typography.bodySmallStyle.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  void _addExercise() async {
    // TODO: Navigate to exercise selection screen
    // For now, add a placeholder exercise
    final exercise = Exercise(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: 'Приседания',
      category: ExerciseCategory.legs,
      difficulty: ExerciseDifficulty.beginner,
      iconName: 'fitness_center',
      description: 'Базовое упражнение для ног',
      targetMuscles: ['Квадрицепсы', 'Ягодицы'],
      equipment: ['Собственный вес'],
    );

    final workoutExercise = WorkoutExercise(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      exercise: exercise,
      orderIndex: _workoutExercises.length,
      sets: 3,
      reps: 12,
      restSeconds: 60,
    );

    setState(() {
      _workoutExercises.add(workoutExercise);
    });
  }

  void _removeExercise(int index) {
    setState(() {
      _workoutExercises.removeAt(index);
      // Обновляем порядковые номера
      for (int i = 0; i < _workoutExercises.length; i++) {
        _workoutExercises[i] = _workoutExercises[i].copyWith(
          orderIndex: i,
        );
      }
    });
  }

  void _saveWorkout() {
    if (!_formKey.currentState!.validate()) return;
    if (_workoutExercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Добавьте хотя бы одно упражнение'),
          backgroundColor: context.colors.error,
        ),
      );
      return;
    }

    final workout = Workout(
      id: '',
      userId: 'current_user_id', // TODO: Get from auth
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      estimatedDurationMinutes: int.tryParse(_durationController.text),
      difficulty: _selectedDifficulty,
      exercises: _workoutExercises,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _workoutBloc.add(CreateWorkout(workout));
  }

  String _getDifficultyDisplayName(WorkoutDifficulty difficulty) {
    switch (difficulty) {
      case WorkoutDifficulty.beginner:
        return 'Начинающий';
      case WorkoutDifficulty.intermediate:
        return 'Средний';
      case WorkoutDifficulty.advanced:
        return 'Продвинутый';
    }
  }
}
