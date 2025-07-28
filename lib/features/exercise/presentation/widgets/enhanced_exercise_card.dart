import 'package:flutter/material.dart';
import '../../data/models/exercise.dart';
import '../../../../shared/design/tokens/design_tokens.dart';

class EnhancedExerciseCard extends StatefulWidget {
  final Exercise exercise;
  final VoidCallback? onTap;

  const EnhancedExerciseCard({
    Key? key,
    required this.exercise,
    this.onTap,
  }) : super(key: key);

  @override
  State<EnhancedExerciseCard> createState() => _EnhancedExerciseCardState();
}

class _EnhancedExerciseCardState extends State<EnhancedExerciseCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _elevationAnimation = Tween<double>(
      begin: 0.0,
      end: 8.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getCategoryColor() {
    switch (widget.exercise.category) {
      case 'Ноги':
        return DesignTokens.colors.nutritionProtein;
      case 'Спина':
        return DesignTokens.colors.nutritionCarbs;
      case 'Грудь':
        return DesignTokens.colors.nutritionFats;
      case 'Плечи':
        return DesignTokens.colors.nutritionCarbs;
      case 'Руки':
        return DesignTokens.colors.nutritionFats;
      case 'Пресс':
        return DesignTokens.colors.nutritionProtein;
      case 'Кардио':
        return DesignTokens.colors.nutritionWater;
      case 'Растяжка':
        return DesignTokens.colors.nutritionFiber;
      default:
        return DesignTokens.colors.nutritionProtein;
    }
  }

  IconData _getExerciseIcon() {
    switch (widget.exercise.iconName) {
      case 'directions_run':
        return Icons.directions_run;
      case 'directions_bike':
        return Icons.directions_bike;
      case 'self_improvement':
        return Icons.self_improvement;
      case 'fitness_center':
        return Icons.fitness_center;
      case 'sports_gymnastics':
        return Icons.sports_gymnastics;
      case 'sports_martial_arts':
        return Icons.sports_martial_arts;
      default:
        return Icons.fitness_center;
    }
  }

  String _getDisplayReps() {
    if (widget.exercise.duration != null) {
      return widget.exercise.duration!;
    }
    return '${widget.exercise.reps}';
  }

  String _getDisplayRest() {
    if (widget.exercise.duration != null) {
      return '—';
    }
    final minutes = widget.exercise.restSeconds ~/ 60;
    final seconds = widget.exercise.restSeconds % 60;
    if (minutes > 0) {
      return '${minutes}м ${seconds}с';
    }
    return '${seconds}с';
  }

  Color _getDifficultyColor() {
    switch (widget.exercise.difficulty) {
      case 'Beginner':
        return Colors.green;
      case 'Intermediate':
        return Colors.orange;
      case 'Advanced':
        return Colors.red;
      default:
        return DesignTokens.colors.nutritionProtein; // Розовый цвет как для ног
    }
  }

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
    _animationController.reverse();
  }

  void _onTapCancel() {
    setState(() {
      _isPressed = false;
    });
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Material(
              elevation: _elevationAnimation.value,
              borderRadius: BorderRadius.circular(16),
              color: context.colors.surface,
              shadowColor: context.colors.shadow.withValues(alpha: 0.1),
              child: InkWell(
                onTap: widget.onTap,
                onTapDown: _onTapDown,
                onTapUp: _onTapUp,
                onTapCancel: _onTapCancel,
                borderRadius: BorderRadius.circular(16),
                                  child: Container(
                    padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _isPressed 
                          ? context.colors.primary.withValues(alpha: 0.3)
                          : context.colors.outline,
                      width: _isPressed ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Exercise Icon with category color
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              _getCategoryColor(),
                              _getCategoryColor().withValues(alpha: 0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: _getCategoryColor().withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          _getExerciseIcon(),
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 20),
                      
                      // Exercise Info
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.exercise.name,
                              style: context.typography.bodyLargeStyle.copyWith(
                                fontWeight: FontWeight.w600,
                                color: context.colors.onSurface,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Flexible(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getDifficultyColor().withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      widget.exercise.difficulty == 'Beginner'
                                          ? 'Новичок'
                                          : widget.exercise.difficulty == 'Intermediate'
                                              ? 'Средний'
                                              : 'Продвинутый',
                                      style: context.typography.bodySmallStyle.copyWith(
                                        color: _getDifficultyColor(),
                                        fontWeight: FontWeight.w500,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    widget.exercise.category,
                                    style: context.typography.bodySmallStyle.copyWith(
                                      color: context.colors.onSurfaceVariant,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      // Stats columns
                      _buildStatColumn(
                        label: 'Подходы',
                        value: '${widget.exercise.sets}',
                        icon: Icons.repeat,
                      ),
                      
                      _buildStatColumn(
                        label: 'Повторения',
                        value: _getDisplayReps(),
                        icon: Icons.fitness_center,
                      ),
                      
                      _buildStatColumn(
                        label: 'Отдых',
                        value: _getDisplayRest(),
                        icon: Icons.timer,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatColumn({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Column(
          children: [
            Icon(
              icon,
              size: 16,
              color: context.colors.primary,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              textAlign: TextAlign.center,
              style: context.typography.bodySmallStyle.copyWith(
                fontWeight: FontWeight.w600,
                color: context.colors.onSurface,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
                          Text(
                label,
                textAlign: TextAlign.center,
                style: context.typography.bodySmallStyle.copyWith(
                  color: context.colors.onSurfaceVariant,
                  fontSize: 10,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
      ),
    );
  }
} 