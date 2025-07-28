import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutry_flow/features/notifications/presentation/bloc/notification_bloc.dart';
import 'package:nutry_flow/features/notifications/domain/entities/notification_preferences.dart';
import 'package:nutry_flow/shared/theme/app_colors.dart';
import 'package:nutry_flow/shared/theme/app_styles.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  late NotificationPreferences _preferences;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _preferences = NotificationPreferences.defaultPreferences();
    _loadPreferences();
  }

  void _loadPreferences() {
    context.read<NotificationBloc>().add(LoadNotificationPreferences());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки уведомлений'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocListener<NotificationBloc, NotificationState>(
        listener: (context, state) {
          if (state is NotificationPreferencesLoaded) {
            setState(() {
              _preferences = state.preferences;
              _isLoading = false;
            });
          } else if (state is NotificationLoading) {
            setState(() {
              _isLoading = true;
            });
          } else if (state is NotificationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is NotificationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('Общие настройки'),
                    _buildGeneralSettings(),
                    const SizedBox(height: 24),
                    _buildSectionHeader('Напоминания о еде'),
                    _buildMealReminderSettings(),
                    const SizedBox(height: 24),
                    _buildSectionHeader('Напоминания о тренировках'),
                    _buildWorkoutReminderSettings(),
                    const SizedBox(height: 24),
                    _buildSectionHeader('Напоминания о целях'),
                    _buildGoalReminderSettings(),
                    const SizedBox(height: 32),
                    _buildSaveButton(),
                  ],
                ),
              ),
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

  Widget _buildGeneralSettings() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Общие уведомления'),
              subtitle: const Text('Получать общие уведомления от приложения'),
              value: _preferences.generalNotificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _preferences = _preferences.copyWith(
                    generalNotificationsEnabled: value,
                  );
                });
              },
              activeColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealReminderSettings() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Напоминания о еде'),
              subtitle: const Text('Получать уведомления о времени приема пищи'),
              value: _preferences.mealRemindersEnabled,
              onChanged: (value) {
                setState(() {
                  _preferences = _preferences.copyWith(
                    mealRemindersEnabled: value,
                  );
                });
              },
              activeColor: AppColors.primary,
            ),
            if (_preferences.mealRemindersEnabled) ...[
              const Divider(),
              ListTile(
                title: const Text('Время напоминания'),
                subtitle: Text(
                  _preferences.mealReminderTime != null
                      ? '${_preferences.mealReminderTime!.hour.toString().padLeft(2, '0')}:${_preferences.mealReminderTime!.minute.toString().padLeft(2, '0')}'
                      : 'Не установлено',
                ),
                trailing: const Icon(Icons.access_time),
                onTap: () => _selectMealReminderTime(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutReminderSettings() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Напоминания о тренировках'),
              subtitle: const Text('Получать уведомления о запланированных тренировках'),
              value: _preferences.workoutRemindersEnabled,
              onChanged: (value) {
                setState(() {
                  _preferences = _preferences.copyWith(
                    workoutRemindersEnabled: value,
                  );
                });
              },
              activeColor: AppColors.primary,
            ),
            if (_preferences.workoutRemindersEnabled) ...[
              const Divider(),
              ListTile(
                title: const Text('Время напоминания'),
                subtitle: Text(
                  _preferences.workoutReminderTime != null
                      ? '${_preferences.workoutReminderTime!.hour.toString().padLeft(2, '0')}:${_preferences.workoutReminderTime!.minute.toString().padLeft(2, '0')}'
                      : 'Не установлено',
                ),
                trailing: const Icon(Icons.access_time),
                onTap: () => _selectWorkoutReminderTime(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildGoalReminderSettings() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Напоминания о целях'),
              subtitle: const Text('Получать уведомления о достижении целей'),
              value: _preferences.goalRemindersEnabled,
              onChanged: (value) {
                setState(() {
                  _preferences = _preferences.copyWith(
                    goalRemindersEnabled: value,
                  );
                });
              },
              activeColor: AppColors.primary,
            ),
            if (_preferences.goalRemindersEnabled) ...[
              const Divider(),
              ListTile(
                title: const Text('Время напоминания'),
                subtitle: Text(
                  _preferences.goalReminderTime != null
                      ? '${_preferences.goalReminderTime!.hour.toString().padLeft(2, '0')}:${_preferences.goalReminderTime!.minute.toString().padLeft(2, '0')}'
                      : 'Не установлено',
                ),
                trailing: const Icon(Icons.access_time),
                onTap: () => _selectGoalReminderTime(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _savePreferences,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Сохранить настройки',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _selectMealReminderTime() async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: _preferences.mealReminderTime != null
          ? TimeOfDay.fromDateTime(_preferences.mealReminderTime!)
          : const TimeOfDay(hour: 12, minute: 0),
    );

    if (selectedTime != null) {
      setState(() {
        final now = DateTime.now();
        _preferences = _preferences.copyWith(
          mealReminderTime: DateTime(
            now.year,
            now.month,
            now.day,
            selectedTime.hour,
            selectedTime.minute,
          ),
        );
      });
    }
  }

  void _selectWorkoutReminderTime() async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: _preferences.workoutReminderTime != null
          ? TimeOfDay.fromDateTime(_preferences.workoutReminderTime!)
          : const TimeOfDay(hour: 18, minute: 0),
    );

    if (selectedTime != null) {
      setState(() {
        final now = DateTime.now();
        _preferences = _preferences.copyWith(
          workoutReminderTime: DateTime(
            now.year,
            now.month,
            now.day,
            selectedTime.hour,
            selectedTime.minute,
          ),
        );
      });
    }
  }

  void _selectGoalReminderTime() async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: _preferences.goalReminderTime != null
          ? TimeOfDay.fromDateTime(_preferences.goalReminderTime!)
          : const TimeOfDay(hour: 9, minute: 0),
    );

    if (selectedTime != null) {
      setState(() {
        final now = DateTime.now();
        _preferences = _preferences.copyWith(
          goalReminderTime: DateTime(
            now.year,
            now.month,
            now.day,
            selectedTime.hour,
            selectedTime.minute,
          ),
        );
      });
    }
  }

  void _savePreferences() {
    context.read<NotificationBloc>().add(SaveNotificationPreferences(_preferences));
  }
} 