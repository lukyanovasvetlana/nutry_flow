import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../shared/theme/app_colors.dart';

class ProductsBreakdownChart extends StatelessWidget {
  const ProductsBreakdownChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Заголовок
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Категории продуктов',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.dynamicTextPrimary,
                  ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.dynamicSurfaceVariant,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.dynamicBorder, width: 0.5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Месяц',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.dynamicTextSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 14,
                    color: AppColors.dynamicTextSecondary,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Диаграмма и легенда
        Row(
          children: [
            // Круговая диаграмма
            Expanded(
              flex: 4,
              child: SizedBox(
                height: 220, // Увеличил с 140 до 220
                child: PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        // Обработка касаний
                      },
                      enabled: true,
                    ),
                    borderData: FlBorderData(show: false),
                    sectionsSpace: 2, // Увеличил с 1 до 2
                    centerSpaceRadius: 35, // Увеличил с 25 до 35
                    sections: _getPieChartSections(),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 20), // Увеличил с 12 до 20

            // Легенда
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLegendItem('Злаки', 28, AppColors.dynamicGreen),
                  const SizedBox(height: 12),
                  _buildLegendItem('Белки', 22, AppColors.dynamicYellow),
                  const SizedBox(height: 12),
                  _buildLegendItem('Фрукты', 20, AppColors.dynamicOrange),
                  const SizedBox(height: 12),
                  _buildLegendItem('Овощи', 15, AppColors.dynamicSuccess),
                  const SizedBox(height: 12),
                  _buildLegendItem('Молочные', 10, AppColors.dynamicGray),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  List<PieChartSectionData> _getPieChartSections() {
    return [
      PieChartSectionData(
        color: AppColors.dynamicGreen,
        value: 28,
        title: '28%',
        radius: 35, // Увеличил с 25 до 35
        titleStyle: const TextStyle(
          fontSize: 12, // Увеличил с 10 до 12
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: AppColors.dynamicYellow,
        value: 22,
        title: '22%',
        radius: 35,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: AppColors.dynamicOrange,
        value: 20,
        title: '20%',
        radius: 35,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: AppColors.dynamicSuccess,
        value: 15,
        title: '15%',
        radius: 35,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: AppColors.dynamicGray,
        value: 10,
        title: '10%',
        radius: 35,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ];
  }

  Widget _buildLegendItem(String label, int percentage, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.dynamicTextPrimary,
                ),
              ),
              Text(
                '$percentage%',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.dynamicTextSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
