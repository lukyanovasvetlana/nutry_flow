class CalendarEvent {
  final String id;
  final String userId;
  final String category;
  final String title;
  final String? description;
  final DateTime dateTime;
  final DateTime? endDateTime;
  final String? location;
  final String? note;
  final bool isCompleted;
  final bool isRecurring;
  final String? recurrenceRule;
  final List<String> tags;
  final String? color;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CalendarEvent({
    required this.id,
    required this.userId,
    required this.category,
    required this.title,
    this.description,
    required this.dateTime,
    this.endDateTime,
    this.location,
    this.note,
    this.isCompleted = false,
    this.isRecurring = false,
    this.recurrenceRule,
    this.tags = const [],
    this.color,
    required this.createdAt,
    required this.updatedAt,
  });

  CalendarEvent copyWith({
    String? category,
    String? title,
    String? description,
    DateTime? dateTime,
    DateTime? endDateTime,
    String? location,
    String? note,
    bool? isCompleted,
    bool? isRecurring,
    String? recurrenceRule,
    List<String>? tags,
    String? color,
  }) {
    return CalendarEvent(
      id: id,
      userId: userId,
      category: category ?? this.category,
      title: title ?? this.title,
      description: description ?? this.description,
      dateTime: dateTime ?? this.dateTime,
      endDateTime: endDateTime ?? this.endDateTime,
      location: location ?? this.location,
      note: note ?? this.note,
      isCompleted: isCompleted ?? this.isCompleted,
      isRecurring: isRecurring ?? this.isRecurring,
      recurrenceRule: recurrenceRule ?? this.recurrenceRule,
      tags: tags ?? this.tags,
      color: color ?? this.color,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  factory CalendarEvent.fromJson(Map<String, dynamic> json) {
    return CalendarEvent(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      category: json['category'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      dateTime: DateTime.parse(json['date_time'] as String),
      endDateTime: json['end_date_time'] != null
          ? DateTime.parse(json['end_date_time'])
          : null,
      location: json['location'] as String?,
      note: json['note'] as String?,
      isCompleted: json['is_completed'] as bool? ?? false,
      isRecurring: json['is_recurring'] as bool? ?? false,
      recurrenceRule: json['recurrence_rule'] as String?,
      tags: List<String>.from(json['tags'] ?? []),
      color: json['color'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'category': category,
      'title': title,
      'description': description,
      'date_time': dateTime.toIso8601String(),
      'end_date_time': endDateTime?.toIso8601String(),
      'location': location,
      'note': note,
      'is_completed': isCompleted,
      'is_recurring': isRecurring,
      'recurrence_rule': recurrenceRule,
      'tags': tags,
      'color': color,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Проверяет, происходит ли событие сегодня
  bool get isToday {
    final now = DateTime.now();
    return dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day;
  }

  /// Проверяет, является ли событие просроченным
  bool get isPastDue {
    return !isCompleted && dateTime.isBefore(DateTime.now());
  }

  /// Возвращает длительность события
  Duration? get duration {
    if (endDateTime == null) return null;
    return endDateTime!.difference(dateTime);
  }

  /// Проверяет, является ли событие целодневным
  bool get isAllDay {
    return endDateTime != null &&
        endDateTime!.difference(dateTime).inHours >= 24;
  }
}
