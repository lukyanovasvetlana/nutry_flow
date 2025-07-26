import 'package:flutter/material.dart';
import 'package:nutry_flow/shared/theme/app_colors.dart';
import 'package:nutry_flow/shared/theme/app_styles.dart';
import '../../../../app.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const AppContainer()),
              (route) => false,
            );
          },
        ),
        title: const Text('Уведомления', style: AppStyles.headlineMedium),
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
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message),
            const SizedBox(height: 4),
            Text(
              time,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            // TODO: Добавить действия с уведомлением
          },
        ),
      ),
    );
  }
} 