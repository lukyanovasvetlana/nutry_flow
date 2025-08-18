import 'package:equatable/equatable.dart';

enum AchievementType {
  goalCompleted,
  streak,
  milestone,
  consistency,
  improvement,
  challenge,
}

enum AchievementCategory {
  weight,
  activity,
  nutrition,
  general,
}

class Achievement extends Equatable {
  final String id;
  final String userId;
  final String? goalId;
  final AchievementType type;
  final AchievementCategory category;
  final String title;
  final String description;
  final String iconName;
  final int points;
  final DateTime earnedDate;
  final Map<String, dynamic>? metadata;
  final bool isVisible;

  const Achievement({
    required this.id,
    required this.userId,
    this.goalId,
    required this.type,
    required this.category,
    required this.title,
    required this.description,
    required this.iconName,
    required this.points,
    required this.earnedDate,
    this.metadata,
    this.isVisible = true,
  });

  String get categoryDisplayName {
    switch (category) {
      case AchievementCategory.weight:
        return 'Вес';
      case AchievementCategory.activity:
        return 'Активность';
      case AchievementCategory.nutrition:
        return 'Питание';
      case AchievementCategory.general:
        return 'Общее';
    }
  }

  String get typeDisplayName {
    switch (type) {
      case AchievementType.goalCompleted:
        return 'Цель достигнута';
      case AchievementType.streak:
        return 'Серия';
      case AchievementType.milestone:
        return 'Веха';
      case AchievementType.consistency:
        return 'Постоянство';
      case AchievementType.improvement:
        return 'Улучшение';
      case AchievementType.challenge:
        return 'Вызов';
    }
  }

  Achievement copyWith({
    String? id,
    String? userId,
    String? goalId,
    AchievementType? type,
    AchievementCategory? category,
    String? title,
    String? description,
    String? iconName,
    int? points,
    DateTime? earnedDate,
    Map<String, dynamic>? metadata,
    bool? isVisible,
  }) {
    return Achievement(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      goalId: goalId ?? this.goalId,
      type: type ?? this.type,
      category: category ?? this.category,
      title: title ?? this.title,
      description: description ?? this.description,
      iconName: iconName ?? this.iconName,
      points: points ?? this.points,
      earnedDate: earnedDate ?? this.earnedDate,
      metadata: metadata ?? this.metadata,
      isVisible: isVisible ?? this.isVisible,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        goalId,
        type,
        category,
        title,
        description,
        iconName,
        points,
        earnedDate,
        metadata,
        isVisible,
      ];
}
