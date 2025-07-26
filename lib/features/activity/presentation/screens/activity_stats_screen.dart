import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:fl_chart/fl_chart.dart';
import '../bloc/activity_bloc.dart';
import '../../domain/entities/activity_stats.dart';
import '../../domain/entities/activity_session.dart';
import '../widgets/stats_card.dart';
import '../widgets/activity_chart.dart';
import '../../../../shared/design/tokens/design_tokens.dart';

class ActivityStatsScreen extends StatefulWidget {
  const ActivityStatsScreen({Key? key}) : super(key: key);

  @override
  State<ActivityStatsScreen> createState() => _ActivityStatsScreenState();
}

class _ActivityStatsScreenState extends State<ActivityStatsScreen>
    with TickerProviderStateMixin {
  late ActivityBloc _activityBloc;
  late TabController _tabController;
  
  String _selectedPeriod = 'week';
  DateTime _selectedDate = DateTime.now();
  
  ActivityStats? _dailyStats;
  List<ActivityStats> _weeklyStats = [];
  List<ActivityStats> _monthlyStats = [];
  List<ActivitySession> _recentSessions = [];
  Map<String, dynamic> _analytics = {};

  @override
  void initState() {
    super.initState();
    _activityBloc = GetIt.instance.get<ActivityBloc>();
    _tabController = TabController(length: 3, vsync: this);
    _loadStats();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadStats() {
    final userId = 'current_user_id'; // TODO: Get from auth
    
    _activityBloc.add(LoadDailyStats(userId, _selectedDate));
    _activityBloc.add(LoadWeeklyStats(userId, _getWeekStart(_selectedDate)));
    _activityBloc.add(LoadMonthlyStats(userId, _getMonthStart(_selectedDate)));
    _activityBloc.add(LoadUserSessions(userId, from: _selectedDate.subtract(const Duration(days: 7))));
    _activityBloc.add(LoadActivityAnalytics(userId, from: _selectedDate.subtract(const Duration(days: 30))));
  }

  DateTime _getWeekStart(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  DateTime _getMonthStart(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.surface,
      appBar: AppBar(
        title: Text(
          'Статистика активности',
          style: context.typography.headlineSmallStyle.copyWith(
            color: context.colors.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: context.colors.surface,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: context.colors.primary,
          unselectedLabelColor: context.colors.onSurfaceVariant,
          indicatorColor: context.colors.primary,
          tabs: const [
            Tab(text: 'Обзор'),
            Tab(text: 'Графики'),
            Tab(text: 'История'),
          ],
        ),
      ),
      body: BlocProvider.value(
        value: _activityBloc,
        child: BlocListener<ActivityBloc, ActivityState>(
          listener: (context, state) {
            if (state is DailyStatsLoaded) {
              setState(() {
                _dailyStats = state.stats;
              });
            } else if (state is WeeklyStatsLoaded) {
              setState(() {
                _weeklyStats = state.stats;
              });
            } else if (state is MonthlyStatsLoaded) {
              setState(() {
                _monthlyStats = state.stats;
              });
            } else if (state is UserSessionsLoaded) {
              setState(() {
                _recentSessions = state.sessions;
              });
            } else if (state is ActivityAnalyticsLoaded) {
              setState(() {
                _analytics = state.analytics;
              });
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
              _buildPeriodSelector(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildOverviewTab(),
                    _buildChartsTab(),
                    _buildHistoryTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'week', label: Text('Неделя')),
                ButtonSegment(value: 'month', label: Text('Месяц')),
                ButtonSegment(value: 'year', label: Text('Год')),
              ],
              selected: {_selectedPeriod},
              onSelectionChanged: (Set<String> newSelection) {
                setState(() {
                  _selectedPeriod = newSelection.first;
                  _loadStats();
                });
              },
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
            onPressed: () => _selectDate(context),
            icon: Icon(
              Icons.calendar_today,
              color: context.colors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryCards(),
          const SizedBox(height: 24),
          _buildQuickStats(),
          const SizedBox(height: 24),
          _buildRecentActivity(),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        StatsCard(
          title: 'Всего тренировок',
          value: _analytics['totalWorkouts']?.toString() ?? '0',
          icon: Icons.fitness_center,
          color: context.colors.primary,
        ),
        StatsCard(
          title: 'Время тренировок',
          value: _formatDuration(_analytics['totalDuration'] ?? 0),
          icon: Icons.timer,
          color: context.colors.secondary,
        ),
        StatsCard(
          title: 'Калории',
          value: '${_analytics['totalCalories'] ?? 0}',
          icon: Icons.local_fire_department,
          color: context.colors.accent,
        ),
        StatsCard(
          title: 'Средняя оценка',
          value: '${_analytics['averageRating']?.toStringAsFixed(1) ?? '0.0'}/5',
          icon: Icons.star,
          color: context.colors.error,
        ),
      ],
    );
  }

  Widget _buildQuickStats() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Быстрая статистика',
              style: context.typography.titleMediumStyle.copyWith(
                fontWeight: FontWeight.w600,
                color: context.colors.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildStatRow('Лучший день', _analytics['bestDay'] ?? 'Нет данных'),
            _buildStatRow('Средняя продолжительность', _formatDuration(_analytics['averageDuration'] ?? 0)),
            _buildStatRow('Любимое упражнение', _analytics['favoriteExercise'] ?? 'Нет данных'),
            _buildStatRow('Дней подряд', '${_analytics['streakDays'] ?? 0}'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: context.typography.bodyMediumStyle.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: context.typography.bodyMediumStyle.copyWith(
              fontWeight: FontWeight.w600,
              color: context.colors.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Недавние тренировки',
              style: context.typography.titleMediumStyle.copyWith(
                fontWeight: FontWeight.w600,
                color: context.colors.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            
            if (_recentSessions.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.fitness_center_outlined,
                        size: 64,
                        color: context.colors.onSurfaceVariant,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Нет тренировок',
                        style: context.typography.bodyLargeStyle.copyWith(
                          color: context.colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _recentSessions.take(5).length,
                itemBuilder: (context, index) {
                  final session = _recentSessions[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: context.colors.primaryLight,
                      child: Icon(
                        Icons.fitness_center,
                        color: context.colors.primary,
                      ),
                    ),
                    title: Text(
                      session.workout?.name ?? 'Тренировка',
                      style: context.typography.bodyLargeStyle.copyWith(
                        fontWeight: FontWeight.w600,
                        color: context.colors.onSurface,
                      ),
                    ),
                    subtitle: Text(
                      _formatDate(session.startedAt),
                      style: context.typography.bodyMediumStyle.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                    trailing: Text(
                      _formatDuration((session.actualDurationMinutes ?? 0) * 60),
                      style: context.typography.bodyMediumStyle.copyWith(
                        color: context.colors.primary,
                        fontWeight: FontWeight.w600,
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

  Widget _buildChartsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildActivityChart(),
          const SizedBox(height: 24),
          _buildCaloriesChart(),
          const SizedBox(height: 24),
          _buildWorkoutTypeChart(),
        ],
      ),
    );
  }

  Widget _buildActivityChart() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Активность по дням',
              style: context.typography.titleMediumStyle.copyWith(
                fontWeight: FontWeight.w600,
                color: context.colors.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            
            SizedBox(
              height: 200,
              child: ActivityChart(
                data: _weeklyStats.map((stat) => {
                  'date': stat.date,
                  'duration': stat.totalDurationMinutes,
                  'calories': stat.totalCaloriesBurned,
                }).toList(),
                type: 'activity',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCaloriesChart() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Калории по дням',
              style: context.typography.titleMediumStyle.copyWith(
                fontWeight: FontWeight.w600,
                color: context.colors.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            
            SizedBox(
              height: 200,
              child: ActivityChart(
                data: _weeklyStats.map((stat) => {
                  'date': stat.date,
                  'calories': stat.totalCaloriesBurned,
                }).toList(),
                type: 'calories',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutTypeChart() {
    final workoutTypes = _analytics['workoutTypes'] as Map<String, dynamic>? ?? {};
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Типы тренировок',
              style: context.typography.titleMediumStyle.copyWith(
                fontWeight: FontWeight.w600,
                color: context.colors.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: workoutTypes.entries.map((entry) {
                    final total = workoutTypes.values.reduce((sum, value) => sum + value);
                    final percentage = entry.value / total;
                    return PieChartSectionData(
                      value: entry.value.toDouble(),
                      title: '${(percentage * 100).toStringAsFixed(1)}%',
                      color: _getColorForWorkoutType(entry.key),
                      radius: 80,
                      titleStyle: context.typography.bodySmallStyle.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  }).toList(),
                  centerSpaceRadius: 40,
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: workoutTypes.entries.map((entry) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _getColorForWorkoutType(entry.key),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      entry.key,
                      style: context.typography.bodySmallStyle.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _recentSessions.length,
      itemBuilder: (context, index) {
        final session = _recentSessions[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              radius: 24,
              backgroundColor: context.colors.primaryLight,
              child: Icon(
                Icons.fitness_center,
                color: context.colors.primary,
              ),
            ),
            title: Text(
              session.workout?.name ?? 'Тренировка',
              style: context.typography.titleMediumStyle.copyWith(
                fontWeight: FontWeight.w600,
                color: context.colors.onSurface,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  _formatDate(session.startedAt),
                  style: context.typography.bodyMediumStyle.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.timer,
                      size: 16,
                      color: context.colors.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatDuration((session.actualDurationMinutes ?? 0) * 60),
                      style: context.typography.bodySmallStyle.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.local_fire_department,
                      size: 16,
                      color: context.colors.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${session.caloriesBurned ?? 0} кал',
                      style: context.typography.bodySmallStyle.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: context.colors.onSurfaceVariant,
            ),
            onTap: () {
              // TODO: Navigate to session details
            },
          ),
        );
      },
    );
  }

  Color _getColorForWorkoutType(String type) {
    final colors = [
      context.colors.primary,
      context.colors.secondary,
      context.colors.accent,
      context.colors.error,
      context.colors.outline,
    ];
    
    final index = type.hashCode % colors.length;
    return colors[index];
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _loadStats();
    }
  }

  String _formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    
    if (hours > 0) {
      return '${hours}ч ${minutes}м';
    } else {
      return '${minutes}м';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    
    if (difference == 0) {
      return 'Сегодня';
    } else if (difference == 1) {
      return 'Вчера';
    } else if (difference < 7) {
      return '$difference дней назад';
    } else {
      return '${date.day}.${date.month}.${date.year}';
    }
  }
} 