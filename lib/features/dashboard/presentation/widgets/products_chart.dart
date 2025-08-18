import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../shared/theme/app_colors.dart';

class ProductsChart extends StatelessWidget {
  const ProductsChart({super.key});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 80,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipRoundedRadius: 8,
            tooltipBgColor: AppColors.dynamicSurface,
            tooltipBorder: BorderSide(color: AppColors.dynamicBorder, width: 1),
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${rod.toY.round()} шт.',
                TextStyle(
                  color: AppColors.dynamicTextPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const categories = [
                  'Злаки',
                  'Белки',
                  'Фрукты',
                  'Овощи',
                  'Молочные'
                ];
                if (value.toInt() >= 0 && value.toInt() < categories.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      categories[value.toInt()],
                      style: TextStyle(
                        color: AppColors.dynamicTextSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              getTitlesWidget: (value, meta) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    '${value.round()}',
                    style: TextStyle(
                      color: AppColors.dynamicTextSecondary,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border(
            bottom: BorderSide(color: AppColors.dynamicBorder, width: 1),
            left: BorderSide(color: AppColors.dynamicBorder, width: 1),
          ),
        ),
        gridData: FlGridData(
          show: true,
          horizontalInterval: 20,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: AppColors.dynamicBorder.withOpacity(0.3),
              strokeWidth: 1,
            );
          },
        ),
        barGroups: [
          BarChartGroupData(x: 0, barRods: [
            BarChartRodData(
                toY: 28,
                color: AppColors.dynamicGreen,
                width: 20,
                borderRadius: BorderRadius.circular(4))
          ]),
          BarChartGroupData(x: 1, barRods: [
            BarChartRodData(
                toY: 22,
                color: AppColors.dynamicYellow,
                width: 20,
                borderRadius: BorderRadius.circular(4))
          ]),
          BarChartGroupData(x: 2, barRods: [
            BarChartRodData(
                toY: 20,
                color: AppColors.dynamicOrange,
                width: 20,
                borderRadius: BorderRadius.circular(4))
          ]),
          BarChartGroupData(x: 3, barRods: [
            BarChartRodData(
                toY: 15,
                color: AppColors.dynamicSuccess,
                width: 20,
                borderRadius: BorderRadius.circular(4))
          ]),
          BarChartGroupData(x: 4, barRods: [
            BarChartRodData(
                toY: 10,
                color: AppColors.dynamicGray,
                width: 20,
                borderRadius: BorderRadius.circular(4))
          ]),
        ],
      ),
    );
  }
}
