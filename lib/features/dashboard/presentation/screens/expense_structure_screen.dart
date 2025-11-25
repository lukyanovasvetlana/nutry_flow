import 'package:flutter/material.dart';
import '../widgets/expense_breakdown_chart.dart';
import '../widgets/products_breakdown_chart.dart';
import '../widgets/calories_breakdown_chart.dart';
import '../widgets/stats_overview.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/design/tokens/design_tokens.dart';
import '../../../../shared/design/components/cards/nutry_card.dart';

class ExpenseStructureScreen extends StatefulWidget {
  const ExpenseStructureScreen({super.key});

  @override
  State<ExpenseStructureScreen> createState() => _ExpenseStructureScreenState();
}

class _ExpenseStructureScreenState extends State<ExpenseStructureScreen> {
  int selectedChartIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dynamicBackground,
      appBar: AppBar(
        backgroundColor: AppColors.dynamicSurface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.dynamicOnSurface,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Питание и калории',
          style: DesignTokens.typography.titleLargeStyle.copyWith(
            color: AppColors.dynamicOnSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Статистика сверху
            NutryCard(
              backgroundColor: AppColors.dynamicCard,
              child: StatsOverview(
                selectedIndex: selectedChartIndex,
                onCardTap: (index) {
                  setState(() {
                    selectedChartIndex = index;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            // Диаграмма в зависимости от выбранной карточки
            Container(
              height: 400,
              decoration: BoxDecoration(
                color: AppColors.dynamicCard,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.dynamicShadow.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: _getBreakdownChartWidget(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Возвращает виджет круговой диаграммы в зависимости от выбранной карточки
  Widget _getBreakdownChartWidget() {
    switch (selectedChartIndex) {
      case 0:
        return const ExpenseBreakdownChart();
      case 1:
        return const ProductsBreakdownChart();
      case 2:
        return const CaloriesBreakdownChart();
      default:
        return const ExpenseBreakdownChart();
    }
  }
}
