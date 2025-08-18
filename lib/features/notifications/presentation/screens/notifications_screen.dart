import 'package:flutter/material.dart';
import 'package:nutry_flow/shared/theme/app_colors.dart';
import 'package:nutry_flow/shared/theme/app_styles.dart';
import '../../../../app.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dynamicBackground,
      appBar: AppBar(
        backgroundColor: AppColors.dynamicBackground,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.dynamicTextPrimary),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const AppContainer()),
              (route) => false,
            );
          },
        ),
        title: Text(
          'Уведомления',
          style: AppStyles.headlineMedium.copyWith(
            color: AppColors.dynamicTextPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ваши уведомления',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.dynamicTextPrimary,
                    ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView(
                  children: [
                    _buildNotificationCard(
                      title: 'Напоминание о воде',
                      message: 'Не забудьте выпить стакан воды!',
                      time: '2 минуты назад',
                      icon: Icons.water_drop,
                      color: Colors.blue,
                    ),
                    _buildNotificationCard(
                      title: 'Время тренировки',
                      message: 'Запланированная тренировка через 30 минут',
                      time: '15 минут назад',
                      icon: Icons.fitness_center,
                      color: Colors.orange,
                    ),
                    _buildNotificationCard(
                      title: 'Приём пищи',
                      message: 'Время обеда! Не забудьте про здоровое питание',
                      time: '1 час назад',
                      icon: Icons.restaurant,
                      color: Colors.green,
                    ),
                    _buildNotificationCard(
                      title: 'Достижение',
                      message: 'Поздравляем! Вы достигли дневной цели по шагам',
                      time: '2 часа назад',
                      icon: Icons.emoji_events,
                      color: Colors.amber,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard({
    required String title,
    required String message,
    required String time,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppColors.dynamicSurface,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.dynamicTextPrimary,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: TextStyle(
                color: AppColors.dynamicTextSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: TextStyle(
                color: AppColors.dynamicTextTertiary,
                fontSize: 12,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.more_vert,
            color: AppColors.dynamicTextSecondary,
          ),
          onPressed: () {
            // TODO: Добавить действия с уведомлением
          },
        ),
      ),
    );
  }
}
