import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../shared/theme/app_colors.dart';

class ExpenseBreakdownChart extends StatelessWidget {
  const ExpenseBreakdownChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок с иконкой
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.dynamicInfo.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.account_balance_wallet,
                  color: AppColors.dynamicInfo,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Структура расходов',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.dynamicTextPrimary,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Row(
              children: [
                // Круговая диаграмма
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(enabled: true),
                        borderData: FlBorderData(show: false),
                        sectionsSpace: 3,
                        centerSpaceRadius: 50,
                        sections: _getPieChartSections(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                // Легенда
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLegendItem('Продукты', 45, AppColors.dynamicGreen),
                      const SizedBox(height: 16),
                      _buildLegendItem(
                          'Рестораны', 25, AppColors.dynamicYellow),
                      const SizedBox(height: 16),
                      _buildLegendItem('Доставка', 20, AppColors.dynamicOrange),
                      const SizedBox(height: 16),
                      _buildLegendItem('Прочее', 10, AppColors.dynamicGray),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _getPieChartSections() {
    return [
      PieChartSectionData(
        color: _createVolumetricColor(AppColors.dynamicGreen),
        value: 45,
        title: '45%',
        radius: 45,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [
            Shadow(
              color: Colors.black38,
              blurRadius: 3,
              offset: Offset(1, 2),
            ),
            Shadow(
              color: Colors.black12,
              blurRadius: 1,
              offset: Offset(0, 1),
            ),
          ],
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _lightenColor(AppColors.dynamicGreen, 0.3),
            AppColors.dynamicGreen,
            _darkenColor(AppColors.dynamicGreen, 0.2),
          ],
        ),
      ),
      PieChartSectionData(
        color: _createVolumetricColor(AppColors.dynamicYellow),
        value: 25,
        title: '25%',
        radius: 45,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [
            Shadow(
              color: Colors.black38,
              blurRadius: 3,
              offset: Offset(1, 2),
            ),
            Shadow(
              color: Colors.black12,
              blurRadius: 1,
              offset: Offset(0, 1),
            ),
          ],
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _lightenColor(AppColors.dynamicYellow, 0.3),
            AppColors.dynamicYellow,
            _darkenColor(AppColors.dynamicYellow, 0.2),
          ],
        ),
      ),
      PieChartSectionData(
        color: _createVolumetricColor(AppColors.dynamicOrange),
        value: 20,
        title: '20%',
        radius: 45,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [
            Shadow(
              color: Colors.black38,
              blurRadius: 3,
              offset: Offset(1, 2),
            ),
            Shadow(
              color: Colors.black12,
              blurRadius: 1,
              offset: Offset(0, 1),
            ),
          ],
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _lightenColor(AppColors.dynamicOrange, 0.3),
            AppColors.dynamicOrange,
            _darkenColor(AppColors.dynamicOrange, 0.2),
          ],
        ),
      ),
      PieChartSectionData(
        color: _createVolumetricColor(AppColors.dynamicGray),
        value: 10,
        title: '10%',
        radius: 45,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [
            Shadow(
              color: Colors.black38,
              blurRadius: 3,
              offset: Offset(1, 2),
            ),
            Shadow(
              color: Colors.black12,
              blurRadius: 1,
              offset: Offset(0, 1),
            ),
          ],
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _lightenColor(AppColors.dynamicGray, 0.3),
            AppColors.dynamicGray,
            _darkenColor(AppColors.dynamicGray, 0.2),
          ],
        ),
      ),
    ];
  }

  /// Создает объемный цвет с эффектом глубины
  Color _createVolumetricColor(Color baseColor) {
    return Color.lerp(baseColor, Colors.black, 0.1) ?? baseColor;
  }

  /// Осветляет цвет для создания градиента
  Color _lightenColor(Color color, double amount) {
    return Color.lerp(color, Colors.white, amount) ?? color;
  }

  /// Затемняет цвет для создания градиента
  Color _darkenColor(Color color, double amount) {
    return Color.lerp(color, Colors.black, amount) ?? color;
  }

  Widget _buildLegendItem(String label, int percentage, Color color) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.dynamicTextPrimary,
            ),
          ),
        ),
        Text(
          '$percentage%',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.dynamicTextSecondary,
          ),
        ),
      ],
    );
  }
}
