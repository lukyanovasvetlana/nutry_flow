import 'package:flutter/material.dart';
import 'dart:async';
import 'package:neon_circular_timer/neon_circular_timer.dart';
import '../../domain/entities/workout.dart';
import '../../domain/entities/activity_session.dart';
import '../../../../shared/design/tokens/design_tokens.dart';
import '../../../../shared/design/tokens/theme_tokens.dart';
import '../../../analytics/presentation/utils/analytics_tracker.dart';
import '../../../../shared/theme/app_colors.dart';

class WorkoutSessionScreen extends StatefulWidget {
  final Workout workout;

  const WorkoutSessionScreen({
    super.key,
    required this.workout,
  });

  @override
  State<WorkoutSessionScreen> createState() => _WorkoutSessionScreenState();
}

class _WorkoutSessionScreenState extends State<WorkoutSessionScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  ActivitySession? _currentSession;
  int _currentExerciseIndex = 0;
  bool _isResting = false;
  bool _isPaused = false;
  bool _isWorkoutCompleteShown = false;
  int? _selectedWorkoutDurationMinutes;
  final int _restTimeTotal = 0;
  final CountDownController _restTimerController = CountDownController();
  final CountDownController _workoutTimerController = CountDownController();
  Timer? _sessionTimer;
  int _sessionDuration = 0;
  int _caloriesBurned = 0;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startWorkoutSession();
    _isPaused = true;

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

    _currentSession = session;
    _startSessionTimer();
  }

  void _startSessionTimer() {
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _sessionDuration++;
        // Примерный расчет калорий (очень упрощенный)
        _caloriesBurned =
            (_sessionDuration / 60 * 8).round(); // 8 калорий в минуту
      });
    });
  }

  void _stopSessionTimer() {
    _sessionTimer?.cancel();
    _sessionTimer = null;
  }

  @override
  void dispose() {
    _animationController.dispose();
    _sessionTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
          onPressed: _showExitDialog,
        ),
        actions: [],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              _getBackgroundAsset(),
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black.withValues(alpha: 0.6)
                  : Colors.white.withValues(alpha: 0.5),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: _buildWorkoutContent(),
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
      padding: EdgeInsets.all(DesignTokens.spacing.md),
      child: Column(
        children: [
          if (_isResting)
            _buildRestTimer()
          else
            _buildExerciseCard(currentExercise, totalSets, totalReps),
          SizedBox(height: DesignTokens.spacing.xxl),
          _buildFinishButton(),
        ],
      ),
    );
  }

  String _getBackgroundAsset() {
    if (_currentExerciseIndex >= widget.workout.exercises.length) {
      return 'assets/images/workout_backgrounds/default.jpg';
    }

    final name = widget.workout.exercises[_currentExerciseIndex].exercise.name
        .toLowerCase();
    if (name.contains('бег')) {
      return 'assets/images/workout_backgrounds/run.jpg';
    }
    if (name.contains('присед')) {
      return 'assets/images/workout_backgrounds/squat.jpg';
    }
    if (name.contains('планк')) {
      return 'assets/images/workout_backgrounds/plank.jpg';
    }
    if (name.contains('велосипед')) {
      return 'assets/images/workout_backgrounds/bike.jpg';
    }
    if (name.contains('сурья') || name.contains('йога')) {
      return 'assets/images/workout_backgrounds/yoga.jpg';
    }
    if (name.contains('пилатес')) {
      return 'assets/images/workout_backgrounds/pilates.jpg';
    }

    return 'assets/images/workout_backgrounds/default.jpg';
  }

  Widget _buildExerciseCard(
      WorkoutExercise exercise, int totalSets, int totalReps) {
    return Padding(
      padding: EdgeInsets.all(DesignTokens.spacing.lg),
      child: Column(
        children: [
          SizedBox(height: DesignTokens.spacing.lg),
          SizedBox(
            width: 220,
            height: 220,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFFCCCCCC).withValues(alpha: 0.6)
                          : const Color(0xFFCCCCCC),
                      width: DesignTokens.spacing.sm,
                    ),
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0, 2),
                  child: NeonCircularTimer(
                    key: ValueKey<int>(_getWorkoutTimerDurationSeconds()),
                    width: 220,
                    duration: _getWorkoutTimerDurationSeconds(),
                    controller: _workoutTimerController,
                    autoStart: false,
                    isReverse: false,
                    isReverseAnimation: false,
                    isTimerTextShown: true,
                    strokeWidth: DesignTokens.spacing.sm,
                    strokeCap: StrokeCap.round,
                    neumorphicEffect: false,
                    outerStrokeColor: Colors.transparent,
                    innerFillColor: Colors.transparent,
                    neonColor: context.colors.primary,
                    neon: 0,
                    textStyle: context.typography.headlineMediumStyle.copyWith(
                      fontWeight: FontWeight.w700,
                      color: context.colors.onSurface,
                    ),
                    textFormat: TextFormat.MM_SS,
                    onComplete: _handleWorkoutTimerComplete,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: DesignTokens.spacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: _goToPreviousExercise,
                icon: Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.primary
                      : context.colors.onSurface,
                ),
              ),
              IconButton(
                onPressed: _pauseWorkout,
                icon: Icon(
                  _isPaused ? Icons.play_arrow : Icons.pause,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.primary
                      : context.colors.onSurface,
                ),
              ),
              IconButton(
                onPressed: _goToNextExercise,
                icon: Icon(
                  Icons.arrow_forward,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.primary
                      : context.colors.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: DesignTokens.spacing.lg),
          _buildDurationSelector(),
          SizedBox(height: DesignTokens.spacing.lg),
          _buildTechniqueCard(exercise.exercise.description),
        ],
      ),
    );
  }

  Widget _buildTechniqueCard(String description) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(DesignTokens.spacing.cardPadding),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(DesignTokens.borders.md),
        border: Border.all(
          color: context.outline,
          width: DesignTokens.borders.thin,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Техника выполнения',
            style: context.typography.titleMediumStyle.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.dynamicTextPrimary,
            ),
          ),
          SizedBox(height: DesignTokens.spacing.sm),
          Text(
            description,
            style: context.typography.bodyMediumStyle.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDurationSelector() {
    const options = [1, 2, 3, 5, 10, 15, 20, 30, 45, 60];
    final value = _selectedWorkoutDurationMinutes ??
        (_getWorkoutTimerDurationSeconds() ~/ 60);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(DesignTokens.spacing.cardPadding),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(DesignTokens.borders.md),
        border: Border.all(
          color: context.outline,
          width: DesignTokens.borders.thin,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Длительность тренировки',
              style: context.typography.bodyMediumStyle.copyWith(
                color: AppColors.dynamicTextPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          DropdownButton<int>(
            value: options.contains(value) ? value : options.first,
            onChanged: (next) {
              if (next == null) return;
              setState(() {
                _selectedWorkoutDurationMinutes = next;
                _isPaused = true;
              });
              _workoutTimerController.restart();
              _workoutTimerController.pause();
            },
            style: context.typography.bodyMediumStyle.copyWith(
              color: AppColors.dynamicTextPrimary,
            ),
            items: options
                .map(
                  (minutes) => DropdownMenuItem<int>(
                    value: minutes,
                    child: Text(
                      '$minutes мин',
                      style: context.typography.bodyMediumStyle.copyWith(
                        color: AppColors.dynamicTextPrimary,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  int _getWorkoutTimerDurationSeconds() {
    final minutes = _selectedWorkoutDurationMinutes ??
        widget.workout.totalEstimatedDuration;
    if (minutes <= 0) return 60;
    return minutes * 60;
  }

  Widget _buildRestTimer() {
    return Card(
      elevation: 0,
      color: context.colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.borders.lg),
        side: BorderSide(
          color: context.colors.outline,
          width: DesignTokens.borders.thin,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(DesignTokens.spacing.lg),
        child: Column(
          children: [
            Icon(
              Icons.timer,
              size: 64,
              color: context.colors.secondary,
            ),
            SizedBox(height: DesignTokens.spacing.md),
            Text(
              'Отдых',
              style: context.typography.headlineSmallStyle.copyWith(
                fontWeight: FontWeight.w600,
                color: context.colors.onSurface,
              ),
            ),
            SizedBox(height: DesignTokens.spacing.sm),
            Text(
              'Подготовьтесь к следующему упражнению',
              style: context.typography.bodyMediumStyle.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: DesignTokens.spacing.lg),
            NeonCircularTimer(
              width: 140,
              duration: _restTimeTotal,
              controller: _restTimerController,
              isReverse: true,
              isReverseAnimation: true,
              autoStart: true,
              isTimerTextShown: true,
              strokeWidth: 10,
              neumorphicEffect: false,
              outerStrokeColor: context.colors.surfaceVariant,
              innerFillColor: context.colors.surface,
              neonGradient: LinearGradient(
                colors: [
                  context.colors.primary,
                  context.colors.secondary,
                ],
              ),
              textStyle: context.typography.headlineMediumStyle.copyWith(
                fontWeight: FontWeight.w700,
                color: context.colors.onSurface,
              ),
              textFormat: TextFormat.MM_SS,
              onComplete: () {
                if (mounted) {
                  setState(() {
                    _isResting = false;
                  });
                }
              },
            ),
            SizedBox(height: DesignTokens.spacing.lg),
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
          SizedBox(height: DesignTokens.spacing.lg),
          Text(
            'Тренировка завершена!',
            style: context.typography.headlineMediumStyle.copyWith(
              fontWeight: FontWeight.w600,
              color: context.colors.onSurface,
            ),
          ),
          SizedBox(height: DesignTokens.spacing.md),
          Text(
            'Отличная работа! Вы сожгли $_caloriesBurned калорий',
            style: context.typography.bodyLargeStyle.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: DesignTokens.spacing.xl),
          ElevatedButton(
            onPressed: _completeWorkout,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.button,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 2,
            ),
            child: const Text('Завершить тренировку'),
          ),
        ],
      ),
    );
  }

  Widget _buildFinishButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: DesignTokens.spacing.md),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _completeWorkout,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.button,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 2,
          ),
          child: const Text('Завершить'),
        ),
      ),
    );
  }

  void _goToNextExercise() {
    if (_currentExerciseIndex >= widget.workout.exercises.length - 1) return;
    setState(() {
      _currentExerciseIndex++;
      _isResting = false;
    });
  }

  void _goToPreviousExercise() {
    if (_currentExerciseIndex <= 0) return;
    setState(() {
      _currentExerciseIndex--;
      _isResting = false;
    });
  }

  void _skipRest() {
    _restTimerController.pause();
    setState(() {
      _isResting = false;
    });
  }

  void _pauseWorkout() {
    if (_isPaused) {
      setState(() {
        _isPaused = false;
      });
      _startSessionTimer();
      if (_isResting) {
        _restTimerController.resume();
      } else {
        _workoutTimerController.resume();
      }
      return;
    }

    setState(() {
      _isPaused = true;
    });
    _stopSessionTimer();
    if (_isResting) {
      _restTimerController.pause();
    } else {
      _workoutTimerController.pause();
    }
  }

  void _handleWorkoutTimerComplete() {
    if (_isWorkoutCompleteShown || !mounted) return;
    _isWorkoutCompleteShown = true;
    _stopSessionTimer();
    setState(() {
      _isPaused = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _completeWorkout();
      }
    });
  }

  void _completeWorkout() {
    if (_currentSession == null) return;
    // Отслеживаем завершение тренировки
    AnalyticsTracker.trackWorkoutCompleted(
      workoutName: widget.workout.name,
      duration: _sessionDuration,
      caloriesBurned: _caloriesBurned,
    );
    _showCompletionDialog();
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.colors.surface,
        title: Text(
          'Выйти из тренировки?',
          style: TextStyle(color: context.colors.onSurface),
        ),
        content: Text(
          'Весь прогресс будет потерян. Вы уверены?',
          style: TextStyle(color: context.colors.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Отмена',
              style: TextStyle(color: context.colors.onSurface),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.button,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 2,
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
        backgroundColor: context.colors.surface,
        title: Text(
          'Тренировка завершена!',
          style: TextStyle(color: context.colors.onSurface),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Отличная работа!',
              style: TextStyle(color: context.colors.onSurface),
            ),
            const SizedBox(height: 8),
            Text(
              'Время: ${_formatDuration(_sessionDuration)}',
              style: TextStyle(color: context.colors.onSurfaceVariant),
            ),
            Text(
              'Калории: $_caloriesBurned',
              style: TextStyle(color: context.colors.onSurfaceVariant),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.button,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 2,
            ),
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
