import 'package:flutter/material.dart';
import 'dart:async';
import '../../../../shared/design/tokens/design_tokens.dart';

class WorkoutTimer extends StatefulWidget {
  final int initialSeconds;
  final VoidCallback? onComplete;
  final bool autoStart;

  const WorkoutTimer({
    super.key,
    required this.initialSeconds,
    this.onComplete,
    this.autoStart = false,
  });

  @override
  State<WorkoutTimer> createState() => _WorkoutTimerState();
}

class _WorkoutTimerState extends State<WorkoutTimer>
    with TickerProviderStateMixin {
  late Timer _timer;
  late AnimationController _animationController;
  late Animation<double> _animation;

  int _remainingSeconds = 0;
  bool _isRunning = false;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.initialSeconds;

    _animationController = AnimationController(
      duration: Duration(seconds: widget.initialSeconds),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
    ));

    if (widget.autoStart) {
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _startTimer() {
    if (_isRunning || _isCompleted) return;

    setState(() {
      _isRunning = true;
    });

    _animationController.forward();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _remainingSeconds--;
      });

      if (_remainingSeconds <= 0) {
        timer.cancel();
        setState(() {
          _isRunning = false;
          _isCompleted = true;
        });
        widget.onComplete?.call();
      }
    });
  }

  void _pauseTimer() {
    if (!_isRunning) return;

    _timer.cancel();
    _animationController.stop();

    setState(() {
      _isRunning = false;
    });
  }

  void _resumeTimer() {
    if (_isRunning || _isCompleted) return;

    _animationController.forward();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _remainingSeconds--;
      });

      if (_remainingSeconds <= 0) {
        timer.cancel();
        setState(() {
          _isRunning = false;
          _isCompleted = true;
        });
        widget.onComplete?.call();
      }
    });

    setState(() {
      _isRunning = true;
    });
  }

  void _resetTimer() {
    _timer.cancel();
    _animationController.reset();

    setState(() {
      _remainingSeconds = widget.initialSeconds;
      _isRunning = false;
      _isCompleted = false;
    });
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Timer Display
            SizedBox(
              height: 120,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Circular Progress
                  SizedBox(
                    height: 120,
                    width: 120,
                    child: AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return CircularProgressIndicator(
                          value: _animation.value,
                          strokeWidth: 8,
                          backgroundColor: context.colors.surfaceVariant,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _isCompleted
                                ? context.colors.primary
                                : _isRunning
                                    ? context.colors.secondary
                                    : context.colors.outline,
                          ),
                        );
                      },
                    ),
                  ),

                  // Time Text
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _formatTime(_remainingSeconds),
                        style: context.typography.displaySmallStyle.copyWith(
                          fontWeight: FontWeight.w600,
                          color: context.colors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _isCompleted
                            ? 'Завершено'
                            : _isRunning
                                ? 'Время'
                                : 'Готово',
                        style: context.typography.bodySmallStyle.copyWith(
                          color: context.colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Control Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (!_isCompleted) ...[
                  if (_isRunning)
                    ElevatedButton.icon(
                      onPressed: _pauseTimer,
                      icon: const Icon(Icons.pause),
                      label: const Text('Пауза'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.colors.secondary,
                        foregroundColor: context.colors.onSecondary,
                      ),
                    )
                  else
                    ElevatedButton.icon(
                      onPressed: _resumeTimer,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Старт'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.colors.primary,
                        foregroundColor: context.colors.onPrimary,
                      ),
                    ),
                  ElevatedButton.icon(
                    onPressed: _resetTimer,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Сброс'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colors.surfaceVariant,
                      foregroundColor: context.colors.onSurfaceVariant,
                    ),
                  ),
                ] else ...[
                  ElevatedButton.icon(
                    onPressed: _resetTimer,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Повторить'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colors.primary,
                      foregroundColor: context.colors.onPrimary,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
