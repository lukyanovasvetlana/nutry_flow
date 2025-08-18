import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutry_flow/features/notifications/presentation/bloc/notification_bloc.dart';
import 'package:nutry_flow/features/notifications/domain/entities/scheduled_notification.dart';
import 'package:nutry_flow/shared/theme/app_colors.dart';
import 'package:nutry_flow/shared/theme/app_styles.dart';

class ScheduledNotificationsScreen extends StatefulWidget {
  const ScheduledNotificationsScreen({super.key});

  @override
  State<ScheduledNotificationsScreen> createState() =>
      _ScheduledNotificationsScreenState();
}

class _ScheduledNotificationsScreenState
    extends State<ScheduledNotificationsScreen> {
  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  void _loadNotifications() {
    context.read<NotificationBloc>().add(LoadScheduledNotifications());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Запланированные уведомления'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadNotifications,
          ),
        ],
      ),
      body: BlocListener<NotificationBloc, NotificationState>(
        listener: (context, state) {
          if (state is NotificationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            _loadNotifications();
          } else if (state is NotificationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            if (state is NotificationLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ScheduledNotificationsLoaded) {
              return _buildNotificationsList(state.notifications);
            } else if (state is NotificationError) {
              return _buildErrorWidget();
            }
            return const Center(child: Text('Загружаем уведомления...'));
          },
        ),
      ),
    );
  }

  Widget _buildNotificationsList(List<ScheduledNotification> notifications) {
    if (notifications.isEmpty) {
      return _buildEmptyState();
    }

    // Группируем уведомления по статусу
    final activeNotifications =
        notifications.where((n) => n.isActiveAndNotExpired).toList();
    final expiredNotifications =
        notifications.where((n) => n.isExpired).toList();

    return RefreshIndicator(
      onRefresh: () async {
        _loadNotifications();
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (activeNotifications.isNotEmpty) ...[
            _buildSectionHeader('Активные уведомления'),
            ...activeNotifications.map(_buildNotificationCard),
            const SizedBox(height: 24),
          ],
          if (expiredNotifications.isNotEmpty) ...[
            _buildSectionHeader('Просроченные уведомления'),
            ...expiredNotifications.map(_buildNotificationCard),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: AppStyles.headline6.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildNotificationCard(ScheduledNotification notification) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: notification.isExpired
              ? Colors.grey
              : notification.isUrgent
                  ? Colors.orange
                  : AppColors.primary,
          child: Text(
            notification.typeIcon,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        title: Text(
          notification.title,
          style: AppStyles.body1.copyWith(
            fontWeight: FontWeight.bold,
            color: notification.isExpired ? Colors.grey : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.body,
              style: AppStyles.body2.copyWith(
                color: notification.isExpired ? Colors.grey : null,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 14,
                  color:
                      notification.isExpired ? Colors.grey : AppColors.primary,
                ),
                const SizedBox(width: 4),
                Text(
                  notification.relativeTime,
                  style: AppStyles.caption.copyWith(
                    color: notification.isExpired
                        ? Colors.grey
                        : AppColors.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: notification.isExpired
                        ? Colors.grey
                        : notification.isUrgent
                            ? Colors.orange
                            : AppColors.primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    notification.typeDisplayName,
                    style: AppStyles.caption.copyWith(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: notification.isActiveAndNotExpired
            ? PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'cancel') {
                    _cancelNotification(notification.id);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'cancel',
                    child: Row(
                      children: [
                        Icon(Icons.cancel, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Отменить'),
                      ],
                    ),
                  ),
                ],
              )
            : null,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Нет запланированных уведомлений',
            style: AppStyles.headline6.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Здесь будут отображаться ваши запланированные уведомления',
            style: AppStyles.body2.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Ошибка загрузки',
            style: AppStyles.headline6.copyWith(
              color: Colors.red[600],
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _loadNotifications,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Повторить'),
          ),
        ],
      ),
    );
  }

  void _cancelNotification(int notificationId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Отменить уведомление'),
        content: const Text('Вы уверены, что хотите отменить это уведомление?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context
                  .read<NotificationBloc>()
                  .add(CancelNotification(notificationId));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Отменить уведомление'),
          ),
        ],
      ),
    );
  }
}
