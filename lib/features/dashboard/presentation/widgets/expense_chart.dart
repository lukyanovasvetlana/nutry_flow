import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../shared/theme/app_colors.dart';

class ExpenseChart extends StatelessWidget {
  const ExpenseChart({super.key});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 600,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipRoundedRadius: 8,
            tooltipBgColor: AppColors.dynamicSurface,
            tooltipBorder: BorderSide(color: AppColors.dynamicBorder, width: 1),
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '₽${(rod.toY * 72).round()}',
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
                const days = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
                if (value.toInt() >= 0 && value.toInt() < days.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      days[value.toInt()],
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
                    '₽${(value * 72).round()}',
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
          horizontalInterval: 100,
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
                toY: 3.5,
                color: AppColors.dynamicGreen,
                width: 20,
                borderRadius: BorderRadius.circular(4))
          ]),
          BarChartGroupData(x: 1, barRods: [
            BarChartRodData(
                toY: 4.2,
                color: AppColors.dynamicYellow,
                width: 20,
                borderRadius: BorderRadius.circular(4))
          ]),
          BarChartGroupData(x: 2, barRods: [
            BarChartRodData(
                toY: 2.8,
                color: AppColors.dynamicOrange,
                width: 20,
                borderRadius: BorderRadius.circular(4))
          ]),
          BarChartGroupData(x: 3, barRods: [
            BarChartRodData(
                toY: 5.1,
                color: AppColors.dynamicSuccess,
                width: 20,
                borderRadius: BorderRadius.circular(4))
          ]),
          BarChartGroupData(x: 4, barRods: [
            BarChartRodData(
                toY: 3.9,
                color: AppColors.dynamicGray,
                width: 20,
                borderRadius: BorderRadius.circular(4))
          ]),
          BarChartGroupData(x: 5, barRods: [
            BarChartRodData(
                toY: 4.7,
                color: AppColors.dynamicGreen,
                width: 20,
                borderRadius: BorderRadius.circular(4))
          ]),
          BarChartGroupData(x: 6, barRods: [
            BarChartRodData(
                toY: 3.2,
                color: AppColors.dynamicYellow,
                width: 20,
                borderRadius: BorderRadius.circular(4))
          ]),
        ],
      ),
    );
  }
}
