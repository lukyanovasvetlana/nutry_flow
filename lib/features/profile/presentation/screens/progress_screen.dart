import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../domain/entities/goal.dart';
import '../../domain/entities/progress_entry.dart';
import '../bloc/goals_bloc.dart';
import '../../../../shared/theme/app_colors.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late GoalsBloc _goalsBloc;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _goalsBloc = GetIt.instance<GoalsBloc>();
    _goalsBloc.add(const LoadGoals('demo_user'));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _goalsBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Прогресс целей'),
          backgroundColor: AppColors.green,
          foregroundColor: Colors.white,
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: const [
              Tab(text: 'Вес'),
              Tab(text: 'Активность'),
              Tab(text: 'Питание'),
            ],
          ),
        ),
        body: BlocBuilder<GoalsBloc, GoalsState>(
          builder: (context, state) {
            if (state is GoalsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is GoalsError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red[300],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Ошибка загрузки',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => _goalsBloc.add(const LoadGoals('demo_user')),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Повторить'),
                    ),
                  ],
                ),
              );
            }

            if (state is GoalsLoaded) {
              return TabBarView(
                controller: _tabController,
                children: [
                  _buildWeightTab(state.goals, state.progressEntries),
                  _buildActivityTab(state.goals, state.progressEntries),
                  _buildNutritionTab(state.goals, state.progressEntries),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildWeightTab(List<Goal> goals, List<ProgressEntry> entries) {
    final weightGoals = goals.where((g) => g.type == GoalType.weight).toList();
    final weightEntries = entries
        .where((e) => e.type == ProgressEntryType.weight)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    return RefreshIndicator(
      onRefresh: () async => _goalsBloc.add(const LoadGoals('demo_user')),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (weightGoals.isNotEmpty) ...[
            _buildGoalsSection('Активные цели по весу', weightGoals),
            const SizedBox(height: 24),
          ],
          _buildProgressChart(
            'График изменения веса',
            weightEntries,
            'кг',
            Colors.blue,
          ),
          const SizedBox(height: 24),
          _buildAddProgressCard(ProgressEntryType.weight, 'вес', 'кг'),
          const SizedBox(height: 24),
          _buildRecentEntriesSection(
            'Последние записи веса',
            weightEntries.take(5).toList(),
            'кг',
          ),
        ],
      ),
    );
  }

  Widget _buildActivityTab(List<Goal> goals, List<ProgressEntry> entries) {
    final activityGoals = goals.where((g) => g.type == GoalType.activity).toList();
    final workoutEntries = entries
        .where((e) => e.type == ProgressEntryType.workout)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    final stepsEntries = entries
        .where((e) => e.type == ProgressEntryType.steps)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    return RefreshIndicator(
      onRefresh: () async => _goalsBloc.add(const LoadGoals('demo_user')),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (activityGoals.isNotEmpty) ...[
            _buildGoalsSection('Активные цели активности', activityGoals),
            const SizedBox(height: 24),
          ],
          _buildProgressChart(
            'Тренировки в неделю',
            workoutEntries,
            'тренировок',
            Colors.orange,
          ),
          const SizedBox(height: 24),
          _buildProgressChart(
            'Шаги в день',
            stepsEntries,
            'шагов',
            Colors.green,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildAddProgressCard(
                  ProgressEntryType.workout,
                  'тренировку',
                  'мин',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildAddProgressCard(
                  ProgressEntryType.steps,
                  'шаги',
                  'шагов',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildRecentEntriesSection(
            'Последние тренировки',
            workoutEntries.take(3).toList(),
            'мин',
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionTab(List<Goal> goals, List<ProgressEntry> entries) {
    final nutritionGoals = goals.where((g) => g.type == GoalType.nutrition).toList();
    final caloriesEntries = entries
        .where((e) => e.type == ProgressEntryType.calories)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    final waterEntries = entries
        .where((e) => e.type == ProgressEntryType.water)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    return RefreshIndicator(
      onRefresh: () async => _goalsBloc.add(const LoadGoals('demo_user')),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (nutritionGoals.isNotEmpty) ...[
            _buildGoalsSection('Активные цели питания', nutritionGoals),
            const SizedBox(height: 24),
          ],
          _buildProgressChart(
            'Калории в день',
            caloriesEntries,
            'ккал',
            Colors.red,
          ),
          const SizedBox(height: 24),
          _buildProgressChart(
            'Вода в день',
            waterEntries,
            'л',
            Colors.blue,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildAddProgressCard(
                  ProgressEntryType.calories,
                  'калории',
                  'ккал',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildAddProgressCard(
                  ProgressEntryType.water,
                  'воду',
                  'л',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildRecentEntriesSection(
            'Последние записи',
            [...caloriesEntries.take(2), ...waterEntries.take(2)]
              ..sort((a, b) => b.date.compareTo(a.date)),
            '',
          ),
        ],
      ),
    );
  }

  Widget _buildGoalsSection(String title, List<Goal> goals) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        ...goals.map((goal) => _buildGoalCard(goal)),
      ],
    );
  }

  Widget _buildGoalCard(Goal goal) {
    final progress = goal.currentValue / goal.targetValue;
    final progressPercent = (progress * 100).clamp(0, 100).toInt();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        goal.title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        goal.description ?? '',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$progressPercent%',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: _getProgressColor(progress),
                          ),
                    ),
                    Text(
                      '${goal.currentValue.toStringAsFixed(1)} / ${goal.targetValue.toStringAsFixed(1)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(_getProgressColor(progress)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressChart(
    String title,
    List<ProgressEntry> entries,
    String unit,
    Color color,
  ) {
    if (entries.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.show_chart,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Нет данных для отображения',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    final recentEntries = entries.take(7).toList();
    final maxValue = recentEntries.map((e) => e.value).reduce((a, b) => a > b ? a : b);
    final minValue = recentEntries.map((e) => e.value).reduce((a, b) => a < b ? a : b);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 120,
              child: CustomPaint(
                painter: SimpleChartPainter(
                  entries: recentEntries,
                  color: color,
                  maxValue: maxValue,
                  minValue: minValue,
                ),
                child: Container(),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Мин: ${minValue.toStringAsFixed(1)} $unit',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  'Макс: ${maxValue.toStringAsFixed(1)} $unit',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddProgressCard(
    ProgressEntryType type,
    String label,
    String unit,
  ) {
    return Card(
      child: InkWell(
        onTap: () => _showAddProgressDialog(type, label, unit),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(
                Icons.add_circle_outline,
                color: AppColors.green,
                size: 32,
              ),
              const SizedBox(height: 8),
              Text(
                'Добавить $label',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentEntriesSection(
    String title,
    List<ProgressEntry> entries,
    String unit,
  ) {
    if (entries.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'Нет записей',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            ...entries.map((entry) => _buildEntryTile(entry, unit)),
          ],
        ),
      ),
    );
  }

  Widget _buildEntryTile(ProgressEntry entry, String unit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _formatDate(entry.date),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            '${entry.value.toStringAsFixed(1)} ${unit.isNotEmpty ? unit : _getUnitForType(entry.type)}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }

  Color _getProgressColor(double progress) {
    if (progress >= 1.0) return Colors.green;
    if (progress >= 0.7) return Colors.orange;
    return Colors.red;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(date.year, date.month, date.day);

    if (targetDate == today) {
      return 'Сегодня';
    } else if (targetDate == today.subtract(const Duration(days: 1))) {
      return 'Вчера';
    } else {
      return '${date.day}.${date.month.toString().padLeft(2, '0')}';
    }
  }

  String _getUnitForType(ProgressEntryType type) {
    switch (type) {
      case ProgressEntryType.weight:
        return 'кг';
      case ProgressEntryType.workout:
        return 'мин';
      case ProgressEntryType.steps:
        return 'шагов';
      case ProgressEntryType.calories:
        return 'ккал';
      case ProgressEntryType.water:
        return 'л';
      case ProgressEntryType.nutrition:
        return 'г';
      case ProgressEntryType.measurement:
        return '';
    }
  }

  void _showAddProgressDialog(
    ProgressEntryType type,
    String label,
    String unit,
  ) {
    final controller = TextEditingController();
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Добавить $label'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Значение ($unit)',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Дата'),
                subtitle: Text(_formatDate(selectedDate)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime.now().subtract(const Duration(days: 365)),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    setState(() => selectedDate = date);
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                final value = double.tryParse(controller.text);
                if (value != null && value > 0) {
                  _goalsBloc.add(AddProgressEntry(
                    userId: 'demo_user',
                    type: type,
                    value: value,
                    unit: unit,
                    date: selectedDate,
                    notes: '',
                  ));
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Добавить'),
            ),
          ],
        ),
      ),
    );
  }
}

class SimpleChartPainter extends CustomPainter {
  final List<ProgressEntry> entries;
  final Color color;
  final double maxValue;
  final double minValue;

  SimpleChartPainter({
    required this.entries,
    required this.color,
    required this.maxValue,
    required this.minValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (entries.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final pointPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final points = <Offset>[];

    for (int i = 0; i < entries.length; i++) {
      final entry = entries[i];
      final x = (i / (entries.length - 1)) * size.width;
      final normalizedValue = (entry.value - minValue) / (maxValue - minValue);
      final y = size.height - (normalizedValue * size.height);

      points.add(Offset(x, y));

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    // Draw line
    canvas.drawPath(path, paint);

    // Draw points
    for (final point in points) {
      canvas.drawCircle(point, 4, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
} 