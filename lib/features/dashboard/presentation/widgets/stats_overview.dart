import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';

class StatsOverview extends StatelessWidget {
  final Function(int) onCardTap;
  final int selectedIndex;

  const StatsOverview({
    super.key,
    required this.onCardTap,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    // Используем IntrinsicHeight для правильного расчета высоты Row
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _buildStatCard(
              context,
              'Стоимость',
              '₽11,300',
              '+20%',
              AppColors.green,
              Icons.account_balance_wallet,
              0,
            ),
          ),
          const SizedBox(width: 4), // Уменьшил с 8 до 4
          Expanded(
            child: _buildStatCard(
              context,
              'Продукты',
              '40',
              '+10.2%',
              AppColors.yellow,
              Icons.shopping_basket,
              1,
            ),
          ),
          const SizedBox(width: 4), // Уменьшил с 8 до 4
          Expanded(
            child: _buildStatCard(
              context,
              'Калории',
              '21.6к',
              '-3.6%',
              AppColors.orange,
              Icons.local_fire_department,
              2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    String change,
    Color color,
    IconData icon,
    int index,
  ) {
    final isSelected = selectedIndex == index;
    final isPositive = change.startsWith('+');

    return GestureDetector(
      onTap: () => onCardTap(index),
      child: Container(
        padding: const EdgeInsets.all(8), // Уменьшил с 12 до 8
        decoration: BoxDecoration(
          color: AppColors.dynamicCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : AppColors.dynamicBorder,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.dynamicShadow.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Иконка и изменение
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(4), // Уменьшил с 6 до 4
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: isSelected ? 0.2 : 0.1),
                    borderRadius: BorderRadius.circular(6), // Уменьшил с 8 до 6
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 16, // Уменьшил с 18 до 16
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 4, vertical: 1), // Уменьшил отступы
                  decoration: BoxDecoration(
                    color: isPositive
                        ? Colors.green.withValues(alpha: 0.1)
                        : Colors.red.withValues(alpha: 0.1),
                    borderRadius:
                        BorderRadius.circular(8), // Уменьшил с 10 до 8
                  ),
                  child: Text(
                    change,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 9, // Уменьшил с 10 до 9
                      fontWeight: FontWeight.bold,
                      color: isPositive ? Colors.green : Colors.red,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 3), // Уменьшил с 4 до 3

            // Заголовок и значение
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.dynamicTextSecondary,
                        fontWeight: FontWeight.w500,
                        fontSize: 10, // Уменьшил с 11 до 10
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 2), // Уменьшил с 4 до 2

                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.dynamicTextPrimary,
                          fontSize: 14, // Уменьшил с 16 до 14
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
