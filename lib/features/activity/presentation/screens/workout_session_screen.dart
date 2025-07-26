import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'dart:async';
import '../bloc/activity_bloc.dart';
import '../bloc/workout_bloc.dart';
import '../../domain/entities/workout.dart';
import '../../domain/entities/activity_session.dart';
import '../widgets/workout_timer.dart';
import '../../../../shared/design/tokens/design_tokens.dart';
import '../../../analytics/presentation/utils/analytics_tracker.dart';

class WorkoutSessionScreen extends StatefulWidget {
  final Workout workout;

  const WorkoutSessionScreen({
    Key? key,
    required this.workout,
  }) : super(key: key);

  @override
  State<WorkoutSessionScreen> createState() => _WorkoutSessionScreenState();
}

class _WorkoutSessionScreenState extends State<WorkoutSessionScreen>
    with TickerProviderStateMixin {
  late ActivityBloc _activityBloc;
  late WorkoutBloc _workoutBloc;
  late AnimationController _animationController;
  late Animation<double> _animation;
  
  ActivitySession? _currentSession;
  int _currentExerciseIndex = 0;
  int _currentSet = 1;
  int _currentRep = 1;
  bool _isResting = false;
  int _restTimeRemaining = 0;
  Timer? _restTimer;
  Timer? _sessionTimer;
  int _sessionDuration = 0;
  int _caloriesBurned = 0;

  @override
  void initState() {
    super.initState();
    _activityBloc = GetIt.instance.get<ActivityBloc>();
    _workoutBloc = GetIt.instance.get<WorkoutBloc>();
    _initializeAnimations();
    _startWorkoutSession();
    
    // Отслеживаем просмотр экрана тренировки
    AnalyticsTracker.trackScreenView(
      screenName: 'workout_session',
    );
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  void _startWorkoutSession() {
    final session = ActivitySession(
      id: '',
      userId: 'current_user_id', // TODO: Get from auth
      workoutId: widget.workout.id,
      workout: widget.workout,
      status: ActivitySessionStatus.inProgress,
      startedAt: DateTime.now(),
      createdAt: DateTime.now(),
    );

    _activityBloc.add(StartActivitySession(session));
    _startSessionTimer();
  }

  void _startSessionTimer() {
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _sessionDuration++;
        // Примерный расчет калорий (очень упрощенный)
        _caloriesBurned = (_sessionDuration / 60 * 8).round(); // 8 калорий в минуту
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _restTimer?.cancel();
    _sessionTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.surface,
      appBar: AppBar(
        title: Text(
          widget.workout.name,
          style: context.typography.headlineSmallStyle.copyWith(
            color: context.colors.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: context.colors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: context.colors.onSurface,
          ),
          onPressed: () => _showExitDialog(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.pause,
              color: context.colors.onSurface,
            ),
            onPressed: _pauseWorkout,
          ),
        ],
      ),
      body: BlocProvider.value(
        value: _activityBloc,
        child: BlocListener<ActivityBloc, ActivityState>(
          listener: (context, state) {
            if (state is ActivitySessionStarted) {
              setState(() {
                _currentSession = state.session;
              });
            } else if (state is ActivitySessionCompleted) {
              _showCompletionDialog();
            } else if (state is ActivityError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: context.colors.error,
                ),
              );
            }
          },
          child: Column(
            children: [
              _buildSessionHeader(),
              Expanded(
                child: _buildWorkoutContent(),
              ),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSessionHeader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: context.colors.primaryLight,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Время тренировки',
                  style: context.typography.bodyMediumStyle.copyWith(
                    color: context.colors.onPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDuration(_sessionDuration),
                  style: context.typography.headlineMediumStyle.copyWith(
                    color: context.colors.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Калории',
                style: context.typography.bodyMediumStyle.copyWith(
                  color: context.colors.onPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$_caloriesBurned',
                style: context.typography.headlineMediumStyle.copyWith(
                  color: context.colors.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutContent() {
    if (_currentExerciseIndex >= widget.workout.exercises.length) {
      return _buildWorkoutComplete();
    }

    final currentExercise = widget.workout.exercises[_currentExerciseIndex];
    final totalSets = currentExercise.sets ?? 1;
    final totalReps = currentExercise.reps ?? 1;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildProgressIndicator(),
          const SizedBox(height: 24),
          
          if (_isResting)
            _buildRestTimer()
          else
            _buildExerciseCard(currentExercise, totalSets, totalReps),
          
          const SizedBox(height: 24),
          _buildExerciseList(),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    final progress = (_currentExerciseIndex + 1) / widget.workout.exercises.length;
    
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Прогресс',
              style: context.typography.titleMediumStyle.copyWith(
                fontWeight: FontWeight.w600,
                color: context.colors.onSurface,
              ),
            ),
            Text(
              '${_currentExerciseIndex + 1}/${widget.workout.exercises.length}',
              style: context.typography.bodyMediumStyle.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: context.colors.surfaceVariant,
          valueColor: AlwaysStoppedAnimation<Color>(context.colors.primary),
        ),
      ],
    );
  }

  Widget _buildExerciseCard(WorkoutExercise exercise, int totalSets, int totalReps) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Icon(
              Icons.fitness_center,
              size: 64,
              color: context.colors.primary,
            ),
            const SizedBox(height: 16),
            
            Text(
              exercise.exercise.name,
              style: context.typography.headlineSmallStyle.copyWith(
                fontWeight: FontWeight.w600,
                color: context.colors.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            
            Text(
              exercise.exercise.description,
              style: context.typography.bodyMediumStyle.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSetRepCounter('Подход', _currentSet, totalSets),
                _buildSetRepCounter('Повторение', _currentRep, totalReps),
              ],
            ),
            const SizedBox(height: 24),
            
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _previousSet,
                    child: const Text('Предыдущий'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _nextSet,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colors.primary,
                      foregroundColor: context.colors.onPrimary,
                    ),
                    child: const Text('Следующий'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSetRepCounter(String label, int current, int total) {
    return Column(
      children: [
        Text(
          label,
          style: context.typography.bodySmallStyle.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$current/$total',
          style: context.typography.headlineMediumStyle.copyWith(
            fontWeight: FontWeight.w600,
            color: context.colors.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildRestTimer() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Icon(
              Icons.timer,
              size: 64,
              color: context.colors.secondary,
            ),
            const SizedBox(height: 16),
            
            Text(
              'Отдых',
              style: context.typography.headlineSmallStyle.copyWith(
                fontWeight: FontWeight.w600,
                color: context.colors.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            
            Text(
              'Подготовьтесь к следующему упражнению',
              style: context.typography.bodyMediumStyle.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            
            Text(
              _formatDuration(_restTimeRemaining),
              style: context.typography.displaySmallStyle.copyWith(
                fontWeight: FontWeight.w600,
                color: context.colors.primary,
              ),
            ),
            const SizedBox(height: 24),
            
            ElevatedButton(
              onPressed: _skipRest,
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.secondary,
                foregroundColor: context.colors.onSecondary,
              ),
              child: const Text('Пропустить отдых'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'План тренировки',
          style: context.typography.titleMediumStyle.copyWith(
            fontWeight: FontWeight.w600,
            color: context.colors.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.workout.exercises.length,
          itemBuilder: (context, index) {
            final exercise = widget.workout.exercises[index];
            final isCurrent = index == _currentExerciseIndex;
            final isCompleted = index < _currentExerciseIndex;
            
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              color: isCurrent 
                  ? context.colors.primaryLight 
                  : isCompleted 
                      ? context.colors.surfaceVariant 
                      : context.colors.surface,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: isCurrent 
                      ? context.colors.primary 
                      : isCompleted 
                          ? context.colors.onSurfaceVariant 
                          : context.colors.outline,
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: isCurrent 
                          ? context.colors.onPrimary 
                          : isCompleted 
                              ? context.colors.surface 
                              : context.colors.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                title: Text(
                  exercise.exercise.name,
                  style: context.typography.bodyLargeStyle.copyWith(
                    fontWeight: isCurrent ? FontWeight.w600 : FontWeight.normal,
                    color: isCurrent 
                        ? context.colors.onPrimary 
                        : context.colors.onSurface,
                  ),
                ),
                subtitle: Text(
                  '${exercise.sets ?? 0} x ${exercise.reps ?? 0}',
                  style: context.typography.bodyMediumStyle.copyWith(
                    color: isCurrent 
                        ? context.colors.onPrimary.withOpacity(0.7) 
                        : context.colors.onSurfaceVariant,
                  ),
                ),
                trailing: isCompleted 
                    ? Icon(
                        Icons.check_circle,
                        color: context.colors.primary,
                      )
                    : null,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildWorkoutComplete() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.celebration,
            size: 128,
            color: context.colors.primary,
          ),
          const SizedBox(height: 24),
          
          Text(
            'Тренировка завершена!',
            style: context.typography.headlineMediumStyle.copyWith(
              fontWeight: FontWeight.w600,
              color: context.colors.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          
          Text(
            'Отличная работа! Вы сожгли $_caloriesBurned калорий',
            style: context.typography.bodyLargeStyle.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          
          ElevatedButton(
            onPressed: _completeWorkout,
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colors.primary,
              foregroundColor: context.colors.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: const Text('Завершить тренировку'),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _pauseWorkout,
              child: const Text('Пауза'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: _completeWorkout,
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.error,
                foregroundColor: context.colors.onError,
              ),
              child: const Text('Завершить'),
            ),
          ),
        ],
      ),
    );
  }

  void _nextSet() {
    final currentExercise = widget.workout.exercises[_currentExerciseIndex];
    final totalSets = currentExercise.sets ?? 1;
    final totalReps = currentExercise.reps ?? 1;

    if (_currentRep < totalReps) {
      setState(() {
        _currentRep++;
      });
    } else if (_currentSet < totalSets) {
      setState(() {
        _currentSet++;
        _currentRep = 1;
        _startRest();
      });
    } else {
      _nextExercise();
    }
  }

  void _previousSet() {
    final currentExercise = widget.workout.exercises[_currentExerciseIndex];
    final totalSets = currentExercise.sets ?? 1;
    final totalReps = currentExercise.reps ?? 1;

    if (_currentRep > 1) {
      setState(() {
        _currentRep--;
      });
    } else if (_currentSet > 1) {
      setState(() {
        _currentSet--;
        _currentRep = totalReps;
      });
    }
  }

  void _nextExercise() {
    if (_currentExerciseIndex < widget.workout.exercises.length - 1) {
      setState(() {
        _currentExerciseIndex++;
        _currentSet = 1;
        _currentRep = 1;
        _startRest();
      });
    } else {
      setState(() {
        _currentExerciseIndex++;
      });
    }
  }

  void _startRest() {
    final currentExercise = widget.workout.exercises[_currentExerciseIndex];
    final restTime = currentExercise.restSeconds ?? 60;
    
    setState(() {
      _isResting = true;
      _restTimeRemaining = restTime;
    });

    _restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _restTimeRemaining--;
      });

      if (_restTimeRemaining <= 0) {
        timer.cancel();
        setState(() {
          _isResting = false;
        });
      }
    });
  }

  void _skipRest() {
    _restTimer?.cancel();
    setState(() {
      _isResting = false;
    });
  }

  void _pauseWorkout() {
    // TODO: Implement pause functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Функция паузы будет добавлена позже'),
        backgroundColor: context.colors.secondary,
      ),
    );
  }

  void _completeWorkout() {
    if (_currentSession != null) {
      // Отслеживаем завершение тренировки
      AnalyticsTracker.trackWorkoutCompleted(
        workoutName: widget.workout.name,
        duration: _sessionDuration,
        caloriesBurned: _caloriesBurned,
      );
      
      _activityBloc.add(CompleteActivitySession(_currentSession!.id));
    }
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Выйти из тренировки?'),
        content: const Text('Весь прогресс будет потерян. Вы уверены?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colors.error,
              foregroundColor: context.colors.onError,
            ),
            child: const Text('Выйти'),
          ),
        ],
      ),
    );
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Тренировка завершена!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Отличная работа!'),
            const SizedBox(height: 8),
            Text('Время: ${_formatDuration(_sessionDuration)}'),
            Text('Калории: $_caloriesBurned'),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Отлично!'),
          ),
        ],
      ),
    );
  }

  String _formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }
  }
} 