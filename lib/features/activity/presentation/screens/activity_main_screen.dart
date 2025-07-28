import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../bloc/exercise_bloc.dart';
import '../bloc/workout_bloc.dart';
import '../bloc/activity_bloc.dart';
import 'exercise_catalog_screen.dart';
import 'workout_creation_screen.dart';
import 'activity_stats_screen.dart';
import '../../../../shared/design/tokens/design_tokens.dart';

class ActivityMainScreen extends StatefulWidget {
  const ActivityMainScreen({Key? key}) : super(key: key);

  @override
  State<ActivityMainScreen> createState() => _ActivityMainScreenState();
}

class _ActivityMainScreenState extends State<ActivityMainScreen> {
  late ExerciseBloc _exerciseBloc;
  late WorkoutBloc _workoutBloc;
  late ActivityBloc _activityBloc;

  @override
  void initState() {
    super.initState();
    _exerciseBloc = GetIt.instance.get<ExerciseBloc>();
    _workoutBloc = GetIt.instance.get<WorkoutBloc>();
    _activityBloc = GetIt.instance.get<ActivityBloc>();
    
    // Загружаем данные при открытии экрана
    _loadInitialData();
  }

  void _loadInitialData() {
    _exerciseBloc.add(LoadExercises());
    _workoutBloc.add(LoadUserWorkouts(''));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.surface,
      appBar: AppBar(
        title: Text(
          'Активность',
          style: context.typography.headlineSmallStyle.copyWith(
            color: context.colors.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: context.colors.surface,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ActivityStatsScreen(),
              ),
            ),
            icon: Icon(
              Icons.analytics,
              color: context.colors.primary,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeSection(),
            const SizedBox(height: 24),
            _buildQuickActions(),
            const SizedBox(height: 24),
            _buildRecentWorkouts(),
            const SizedBox(height: 24),
            _buildExerciseCategories(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              context.colors.primary,
              context.colors.primary.withValues(alpha: 0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.fitness_center,
                  color: context.colors.onPrimary,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Готов к тренировке?',
                        style: context.typography.headlineSmallStyle.copyWith(
                          color: context.colors.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Выберите упражнение или создайте тренировку',
                        style: context.typography.bodyMediumStyle.copyWith(
                          color: context.colors.onPrimary.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Быстрые действия',
          style: context.typography.titleLargeStyle.copyWith(
            fontWeight: FontWeight.w600,
            color: context.colors.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                title: 'Каталог упражнений',
                subtitle: 'Найдите подходящие упражнения',
                icon: Icons.search,
                color: context.colors.primary,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ExerciseCatalogScreen(),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildActionCard(
                title: 'Создать тренировку',
                subtitle: 'Составьте план тренировки',
                icon: Icons.add_circle,
                color: context.colors.secondary,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WorkoutCreationScreen(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(height: 12),
              
              Text(
                title,
                style: context.typography.titleMediumStyle.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.colors.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              
              Text(
                subtitle,
                style: context.typography.bodySmallStyle.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentWorkouts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Недавние тренировки',
              style: context.typography.titleLargeStyle.copyWith(
                fontWeight: FontWeight.w600,
                color: context.colors.onSurface,
              ),
            ),
            TextButton(
              onPressed: () {
                // TODO: Navigate to all workouts
              },
              child: Text(
                'Все',
                style: context.typography.bodyMediumStyle.copyWith(
                  color: context.colors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        BlocBuilder<WorkoutBloc, WorkoutState>(
          bloc: _workoutBloc,
          builder: (context, state) {
            if (state is WorkoutLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is WorkoutLoaded) {
              final recentWorkouts = state.workouts.take(3).toList();
              
              if (recentWorkouts.isEmpty) {
                return _buildEmptyState(
                  icon: Icons.fitness_center_outlined,
                  title: 'Нет тренировок',
                  subtitle: 'Создайте свою первую тренировку',
                  actionText: 'Создать тренировку',
                  onAction: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WorkoutCreationScreen(),
                    ),
                  ),
                );
              }
              
              return Column(
                children: recentWorkouts.map((workout) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: context.colors.primaryLight,
                        child: Icon(
                          Icons.fitness_center,
                          color: context.colors.primary,
                        ),
                      ),
                      title: Text(
                        workout.name,
                        style: context.typography.bodyLargeStyle.copyWith(
                          fontWeight: FontWeight.w600,
                          color: context.colors.onSurface,
                        ),
                      ),
                      subtitle: Text(
                        '${workout.exercises.length} упражнений',
                        style: context.typography.bodyMediumStyle.copyWith(
                          color: context.colors.onSurfaceVariant,
                        ),
                      ),
                      trailing: Icon(
                        Icons.chevron_right,
                        color: context.colors.onSurfaceVariant,
                      ),
                      onTap: () {
                        // TODO: Navigate to workout details
                      },
                    ),
                  );
                }).toList(),
              );
            } else {
              return _buildEmptyState(
                icon: Icons.error_outline,
                title: 'Ошибка загрузки',
                subtitle: 'Не удалось загрузить тренировки',
                actionText: 'Повторить',
                onAction: _loadInitialData,
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildExerciseCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Категории упражнений',
          style: context.typography.titleLargeStyle.copyWith(
            fontWeight: FontWeight.w600,
            color: context.colors.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.2,
          children: [
            _buildCategoryCard(
              title: 'Кардио',
              icon: Icons.directions_run,
              color: context.colors.primary,
              onTap: () => _navigateToCategory('cardio'),
            ),
            _buildCategoryCard(
              title: 'Сила',
              icon: Icons.fitness_center,
              color: context.colors.secondary,
              onTap: () => _navigateToCategory('strength'),
            ),
            _buildCategoryCard(
              title: 'Гибкость',
              icon: Icons.accessibility_new,
              color: context.colors.accent,
              onTap: () => _navigateToCategory('flexibility'),
            ),
            _buildCategoryCard(
              title: 'Йога',
              icon: Icons.self_improvement,
              color: context.colors.error,
              onTap: () => _navigateToCategory('yoga'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 32,
                ),
              ),
              const SizedBox(height: 12),
              
              Text(
                title,
                style: context.typography.titleMediumStyle.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.colors.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
    required String actionText,
    required VoidCallback onAction,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Icon(
              icon,
              size: 48,
              color: context.colors.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            
            Text(
              title,
              style: context.typography.titleMediumStyle.copyWith(
                fontWeight: FontWeight.w600,
                color: context.colors.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            
            Text(
              subtitle,
              style: context.typography.bodyMediumStyle.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            
            ElevatedButton(
              onPressed: onAction,
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.primary,
                foregroundColor: context.colors.onPrimary,
              ),
              child: Text(actionText),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToCategory(String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExerciseCatalogScreen(
          initialCategory: category,
        ),
      ),
    );
  }
} 