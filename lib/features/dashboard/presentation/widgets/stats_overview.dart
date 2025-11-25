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
          const SizedBox(width: 8),
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
          const SizedBox(width: 8),
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
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.dynamicCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : AppColors.dynamicBorder,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.dynamicShadow.withOpacity(0.05),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: color.withOpacity(isSelected ? 0.2 : 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 16,
                  ),
                ),
                Flexible(
                  child: Container(
                    margin: const EdgeInsets.only(left: 4),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: isPositive
                          ? Colors.green.withOpacity(0.1)
                          : Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      change,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: isPositive ? Colors.green : Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 4),

            // Заголовок и значение
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.dynamicTextSecondary,
                          fontWeight: FontWeight.w500,
                          fontSize: 10,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 3),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.dynamicTextPrimary,
                          fontSize: 15,
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
