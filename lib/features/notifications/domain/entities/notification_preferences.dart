import 'package:equatable/equatable.dart';

class NotificationPreferences extends Equatable {
  final bool mealRemindersEnabled;
  final bool workoutRemindersEnabled;
  final bool goalRemindersEnabled;
  final bool generalNotificationsEnabled;
  final DateTime? mealReminderTime;
  final DateTime? workoutReminderTime;
  final DateTime? goalReminderTime;

  const NotificationPreferences({
    required this.mealRemindersEnabled,
    required this.workoutRemindersEnabled,
    required this.goalRemindersEnabled,
    required this.generalNotificationsEnabled,
    this.mealReminderTime,
    this.workoutReminderTime,
    this.goalReminderTime,
  });

  @override
  List<Object?> get props => [
        mealRemindersEnabled,
        workoutRemindersEnabled,
        goalRemindersEnabled,
        generalNotificationsEnabled,
        mealReminderTime,
        workoutReminderTime,
        goalReminderTime,
      ];

  NotificationPreferences copyWith({
    bool? mealRemindersEnabled,
    bool? workoutRemindersEnabled,
    bool? goalRemindersEnabled,
    bool? generalNotificationsEnabled,
    DateTime? mealReminderTime,
    DateTime? workoutReminderTime,
    DateTime? goalReminderTime,
  }) {
    return NotificationPreferences(
      mealRemindersEnabled: mealRemindersEnabled ?? this.mealRemindersEnabled,
      workoutRemindersEnabled: workoutRemindersEnabled ?? this.workoutRemindersEnabled,
      goalRemindersEnabled: goalRemindersEnabled ?? this.goalRemindersEnabled,
      generalNotificationsEnabled: generalNotificationsEnabled ?? this.generalNotificationsEnabled,
      mealReminderTime: mealReminderTime ?? this.mealReminderTime,
      workoutReminderTime: workoutReminderTime ?? this.workoutReminderTime,
      goalReminderTime: goalReminderTime ?? this.goalReminderTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mealRemindersEnabled': mealRemindersEnabled,
      'workoutRemindersEnabled': workoutRemindersEnabled,
      'goalRemindersEnabled': goalRemindersEnabled,
      'generalNotificationsEnabled': generalNotificationsEnabled,
      'mealReminderTime': mealReminderTime?.toIso8601String(),
      'workoutReminderTime': workoutReminderTime?.toIso8601String(),
      'goalReminderTime': goalReminderTime?.toIso8601String(),
    };
  }

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    return NotificationPreferences(
      mealRemindersEnabled: json['mealRemindersEnabled'] ?? true,
      workoutRemindersEnabled: json['workoutRemindersEnabled'] ?? true,
      goalRemindersEnabled: json['goalRemindersEnabled'] ?? true,
      generalNotificationsEnabled: json['generalNotificationsEnabled'] ?? true,
      mealReminderTime: json['mealReminderTime'] != null 
          ? DateTime.parse(json['mealReminderTime'])
          : null,
      workoutReminderTime: json['workoutReminderTime'] != null 
          ? DateTime.parse(json['workoutReminderTime'])
          : null,
      goalReminderTime: json['goalReminderTime'] != null 
          ? DateTime.parse(json['goalReminderTime'])
          : null,
    );
  }

  factory NotificationPreferences.defaultPreferences() {
    return const NotificationPreferences(
      mealRemindersEnabled: true,
      workoutRemindersEnabled: true,
      goalRemindersEnabled: true,
      generalNotificationsEnabled: true,
      mealReminderTime: null,
      workoutReminderTime: null,
      goalReminderTime: null,
    );
  }
} 