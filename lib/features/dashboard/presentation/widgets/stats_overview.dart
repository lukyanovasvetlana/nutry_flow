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
    return IntrinsicHeight(
      child: Row(
        children: [
          Flexible(
            flex: 1,
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
        Flexible(
          flex: 1,
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
          Flexible(
            flex: 1,
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
    final isPositive = change.startsWith('+');
    final isSelected = selectedIndex == index;
    
    return GestureDetector(
      onTap: () => onCardTap(index),
      child: Card(
        elevation: isSelected ? 4 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: isSelected 
            ? BorderSide(color: color, width: 2)
            : BorderSide.none,
        ),
        child: Container(
                    height: 100, // Фиксированная высота для всех карточек
            padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                isSelected 
                  ? color.withOpacity(0.1)
                  : color.withOpacity(0.05),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Иконка и изменение
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: color.withOpacity(isSelected ? 0.2 : 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: 18,
                    ),
                  ),
                                      Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isPositive 
                          ? Colors.green.withOpacity(0.1) 
                          : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        change,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: isPositive ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                ],
              ),
              
              // Заголовок и значение
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 4),
                  
                  Text(
                    value,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
} 