import 'package:flutter/material.dart';
import 'package:nutry_flow/shared/theme/app_colors.dart';
import 'dart:math';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String _selectedPeriod = 'Неделя';
  final List<String> _periods = ['День', 'Неделя', 'Месяц', 'Год'];

  // Методы для получения данных в зависимости от периода
  List<double> _getWeightData() {
    switch (_selectedPeriod) {
      case 'День':
        return [72.5, 72.3, 72.1, 71.9, 71.7, 71.5, 71.3, 71.1, 70.9, 70.7, 70.5, 70.3, 70.1, 69.9, 69.7, 69.5, 69.3, 69.1, 68.9, 68.7, 68.5, 68.3, 68.1, 67.9];
      case 'Неделя':
        return [73.2, 72.9, 72.6, 72.3, 72.0, 71.7, 71.4];
      case 'Месяц':
        return [75.0, 74.2, 73.5, 72.8, 72.1, 71.4, 70.7, 70.0, 69.3, 68.6, 67.9, 67.2, 66.5, 65.8, 65.1, 64.4, 63.7, 63.0, 62.3, 61.6, 60.9, 60.2, 59.5, 58.8, 58.1, 57.4, 56.7, 56.0, 55.3, 54.6];
      case 'Год':
        return [80.0, 78.5, 77.0, 75.5, 74.0, 72.5, 71.0, 69.5, 68.0, 66.5, 65.0, 63.5];
      default:
        return [73.2, 72.9, 72.6, 72.3, 72.0, 71.7, 71.4];
    }
  }

  List<String> _getWeightLabels() {
    switch (_selectedPeriod) {
      case 'День':
        return List.generate(24, (index) => '${index}:00');
      case 'Неделя':
        return ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
      case 'Месяц':
        return List.generate(30, (index) => '${index + 1}');
      case 'Год':
        return ['Янв', 'Фев', 'Мар', 'Апр', 'Май', 'Июн', 'Июл', 'Авг', 'Сен', 'Окт', 'Ноя', 'Дек'];
      default:
        return ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
    }
  }

  List<double> _getCaloriesData() {
    switch (_selectedPeriod) {
      case 'День':
        return [1200, 1350, 1500, 1650, 1800, 1950, 2100, 2250, 2400, 2550, 2700, 2850, 3000, 3150, 3300, 3450, 3600, 3750, 3900, 4050, 4200, 4350, 4500, 4650];
      case 'Неделя':
        return [1650.0, 1850.0, 1750.0, 2100.0, 1950.0, 1600.0, 2000.0];
      case 'Месяц':
        return [1800, 1750, 1900, 1850, 2000, 1950, 2100, 2050, 2200, 2150, 2300, 2250, 2400, 2350, 2500, 2450, 2600, 2550, 2700, 2650, 2800, 2750, 2900, 2850, 3000, 2950, 3100, 3050, 3200, 3150];
      case 'Год':
        return [2000, 2100, 2200, 2300, 2400, 2500, 2600, 2700, 2800, 2900, 3000, 3100];
      default:
        return [1650.0, 1850.0, 1750.0, 2100.0, 1950.0, 1600.0, 2000.0];
    }
  }

  List<String> _getCaloriesLabels() {
    return _getWeightLabels(); // Используем те же метки
  }

  List<double> _getWorkoutsData() {
    switch (_selectedPeriod) {
      case 'День':
        return [10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100, 105, 110, 115, 120, 125];
      case 'Неделя':
        return [35.0, 55.0, 25.0, 85.0, 40.0, 70.0, 50.0];
      case 'Месяц':
        return [30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100, 105, 110, 115, 120, 125, 130, 135, 140, 145, 150, 155, 160, 165, 170, 175];
      case 'Год':
        return [50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150, 160];
      default:
        return [35.0, 55.0, 25.0, 85.0, 40.0, 70.0, 50.0];
    }
  }

  List<String> _getWorkoutsLabels() {
    return _getWeightLabels(); // Используем те же метки
  }

  // Методы для получения ключевых метрик в зависимости от периода
  Map<String, String> _getWeightMetrics() {
    switch (_selectedPeriod) {
      case 'День':
        return {'value': '71.2 кг', 'change': '-0.1 кг'};
      case 'Неделя':
        return {'value': '72.5 кг', 'change': '-0.3 кг'};
      case 'Месяц':
        return {'value': '70.8 кг', 'change': '-2.1 кг'};
      case 'Год':
        return {'value': '65.0 кг', 'change': '-15.0 кг'};
      default:
        return {'value': '72.5 кг', 'change': '-0.3 кг'};
    }
  }

  Map<String, String> _getCaloriesMetrics() {
    switch (_selectedPeriod) {
      case 'День':
        return {'value': '2850', 'change': '+150'};
      case 'Неделя':
        return {'value': '1850', 'change': '+150'};
      case 'Месяц':
        return {'value': '2150', 'change': '+200'};
      case 'Год':
        return {'value': '2550', 'change': '+300'};
      default:
        return {'value': '1850', 'change': '+150'};
    }
  }

  Map<String, String> _getWorkoutsMetrics() {
    switch (_selectedPeriod) {
      case 'День':
        return {'value': '8', 'change': '+2'};
      case 'Неделя':
        return {'value': '4', 'change': '+1'};
      case 'Месяц':
        return {'value': '18', 'change': '+3'};
      case 'Год':
        return {'value': '105', 'change': '+15'};
      default:
        return {'value': '4', 'change': '+1'};
    }
  }

  Map<String, String> _getWaterMetrics() {
    switch (_selectedPeriod) {
      case 'День':
        return {'value': '2.8 л', 'change': '+0.2 л'};
      case 'Неделя':
        return {'value': '2.1 л', 'change': '+0.3 л'};
      case 'Месяц':
        return {'value': '2.3 л', 'change': '+0.4 л'};
      case 'Год':
        return {'value': '2.5 л', 'change': '+0.5 л'};
      default:
        return {'value': '2.1 л', 'change': '+0.3 л'};
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F4F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F4F2),
        elevation: 0,
        title: const Text(
          'Аналитика',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.black87),
            onPressed: () {
              _showPeriodFilter();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
                child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
              // Период
              _buildPeriodHeader(),
              const SizedBox(height: 20),

              // Ключевые метрики
              _buildKeyMetrics(),
              const SizedBox(height: 24),

              // График веса
              _buildWeightChart(),
              const SizedBox(height: 24),

              // График калорий
              _buildCaloriesChart(),
              const SizedBox(height: 24),

              // График тренировок
              _buildWorkoutsChart(),
              const SizedBox(height: 24),

              // Достижения
              _buildAchievements(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        const Text(
          'Период',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        Row(
          children: _periods.map((period) {
            final isSelected = _selectedPeriod == period;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedPeriod = period;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(left: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.green : Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                  border: isSelected 
                      ? null 
                      : Border.all(color: Colors.grey[300]!),
                ),
                child: Text(
                  period,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[700],
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildKeyMetrics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ключевые метрики',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                title: 'Средний вес',
                value: _getWeightMetrics()['value']!,
                change: _getWeightMetrics()['change']!,
                isPositive: true,
                icon: Icons.monitor_weight,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                title: 'Калории',
                value: _getCaloriesMetrics()['value']!,
                change: _getCaloriesMetrics()['change']!,
                isPositive: false,
                icon: Icons.local_fire_department,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                title: 'Тренировки',
                value: _getWorkoutsMetrics()['value']!,
                change: _getWorkoutsMetrics()['change']!,
                isPositive: true,
                icon: Icons.fitness_center,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                title: 'Вода',
                value: _getWaterMetrics()['value']!,
                change: _getWaterMetrics()['change']!,
                isPositive: true,
                icon: Icons.water_drop,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String change,
    required bool isPositive,
    required IconData icon,
  }) {
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
            Row(
              children: [
                Icon(
                  icon,
                  color: AppColors.green,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  isPositive ? Icons.trending_up : Icons.trending_down,
                  color: isPositive ? Colors.green : Colors.red,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  change,
                  style: TextStyle(
                    fontSize: 12,
                    color: isPositive ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeightChart() {
    return _buildChartCard(
      title: 'Прогресс веса',
      subtitle: 'Изменение веса за $_selectedPeriod',
      child: Container(
        height: 240,
        padding: const EdgeInsets.all(16),
        child: _buildMockChart(
          data: _getWeightData(),
          labels: _getWeightLabels(),
          color: AppColors.green,
        ),
      ),
    );
  }

  Widget _buildCaloriesChart() {
    return _buildChartCard(
      title: 'Потребление калорий',
      subtitle: 'Калории за $_selectedPeriod',
      child: Container(
        height: 240,
        padding: const EdgeInsets.all(16),
        child: _buildMockChart(
          data: _getCaloriesData(),
          labels: _getCaloriesLabels(),
          color: Colors.orange,
        ),
      ),
    );
  }

  Widget _buildWorkoutsChart() {
    return _buildChartCard(
      title: 'Активность',
      subtitle: 'Активность за $_selectedPeriod',
      child: Container(
        height: 240,
        padding: const EdgeInsets.all(16),
        child: _buildMockChart(
          data: _getWorkoutsData(),
          labels: _getWorkoutsLabels(),
          color: AppColors.gray,
        ),
      ),
    );
  }

  Widget _buildChartCard({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
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
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildMockChart({
    required List<double> data,
    required List<String> labels,
    required Color color,
  }) {
    return Column(
      children: [
        Expanded(
          child: CustomPaint(
            size: Size.infinite,
            painter: LineChartPainter(
              data: data,
              color: color,
              labels: labels,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Мин: ${data.reduce((a, b) => a < b ? a : b).toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 11,
                color: Colors.grey,
              ),
            ),
            Text(
              'Макс: ${data.reduce((a, b) => a > b ? a : b).toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 11,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAchievements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Достижения',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
                _buildAchievementTile(
                  icon: Icons.emoji_events,
                  title: 'Первая неделя',
                  subtitle: 'Завершена первая неделя тренировок',
                  isCompleted: true,
                ),
                const Divider(),
                _buildAchievementTile(
                  icon: Icons.trending_down,
                  title: 'Первые результаты',
                  subtitle: 'Сброшено 2 кг',
                  isCompleted: true,
                ),
                const Divider(),
                _buildAchievementTile(
                  icon: Icons.fitness_center,
                  title: 'Активный месяц',
                  subtitle: '30 дней подряд тренировок',
                  isCompleted: false,
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildAchievementTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isCompleted,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isCompleted ? AppColors.green : Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
            child: Icon(
              icon,
          color: isCompleted ? Colors.white : Colors.grey[600],
          size: 20,
        ),
      ),
      title: Text(
                  title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: isCompleted ? Colors.black87 : Colors.grey[600],
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: isCompleted ? Colors.grey[600] : Colors.grey[500],
        ),
      ),
      trailing: isCompleted
          ? const Icon(Icons.check_circle, color: AppColors.green)
          : const Icon(Icons.lock, color: Colors.grey),
    );
  }

  void _showPeriodFilter() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Выберите период'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: _periods.map((period) {
              return ListTile(
                title: Text(period),
                trailing: _selectedPeriod == period
                    ? const Icon(Icons.check, color: AppColors.green)
                    : null,
                onTap: () {
                  setState(() {
                    _selectedPeriod = period;
                  });
                  Navigator.of(context).pop();
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class LineChartPainter extends CustomPainter {
  final List<double> data;
  final Color color;
  final List<String> labels;

  LineChartPainter({
    required this.data,
    required this.color,
    required this.labels,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = color.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final pointPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    final maxValue = data.reduce((a, b) => a > b ? a : b);
    final minValue = data.reduce((a, b) => a < b ? a : b);
    final valueRange = maxValue - minValue;

    final chartWidth = size.width;
    final chartHeight = size.height - 40; // Оставляем место для подписей
    final pointSpacing = chartWidth / (data.length - 1);

    final points = <Offset>[];
    final path = Path();

    for (int i = 0; i < data.length; i++) {
      final x = i * pointSpacing;
      final normalizedValue = valueRange > 0 ? (data[i] - minValue) / valueRange : 0.5;
      final y = chartHeight - (normalizedValue * chartHeight);
      
      points.add(Offset(x, y));
      
      if (i == 0) {
        path.moveTo(x, y);
    } else {
        path.lineTo(x, y);
      }
    }

    // Рисуем заливку под линией
    final fillPath = Path.from(path);
    fillPath.lineTo(chartWidth, chartHeight);
    fillPath.lineTo(0, chartHeight);
    fillPath.close();
    canvas.drawPath(fillPath, fillPaint);

    // Рисуем линию
    canvas.drawPath(path, paint);

    // Рисуем точки
    for (int i = 0; i < points.length; i++) {
      final point = points[i];
      canvas.drawCircle(point, 4.0, pointPaint);
      
      // Рисуем значения над точками
      textPainter.text = TextSpan(
        text: data[i].toStringAsFixed(1),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          point.dx - textPainter.width / 2,
          point.dy - textPainter.height - 8,
        ),
      );
    }

    // Рисуем подписи осей
    for (int i = 0; i < labels.length; i++) {
      final x = i * pointSpacing;
      textPainter.text = TextSpan(
        text: labels[i],
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          x - textPainter.width / 2,
          chartHeight + 8,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
} 