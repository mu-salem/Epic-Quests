import 'package:hive/hive.dart';

part 'recurring_quest.g.dart';

@HiveType(typeId: 5)
enum RecurrenceType {
  @HiveField(0)
  daily,
  @HiveField(1)
  weekly,
  @HiveField(2)
  monthly,
  @HiveField(3)
  custom;

  String get label {
    switch (this) {
      case RecurrenceType.daily:
        return 'Daily';
      case RecurrenceType.weekly:
        return 'Weekly';
      case RecurrenceType.monthly:
        return 'Monthly';
      case RecurrenceType.custom:
        return 'Custom';
    }
  }

  String get icon {
    switch (this) {
      case RecurrenceType.daily:
        return '🔄';
      case RecurrenceType.weekly:
        return '📅';
      case RecurrenceType.monthly:
        return '📆';
      case RecurrenceType.custom:
        return '⚙️';
    }
  }

  String get pixelIcon {
    switch (this) {
      case RecurrenceType.daily:
        return 'assets/icons/homeQuestIcon.svg';
      case RecurrenceType.weekly:
        return 'assets/icons/weeklyQuestCalendarIcon.svg';
      case RecurrenceType.monthly:
        return 'assets/icons/monthlyCalendarIcon.svg';
      case RecurrenceType.custom:
        return 'assets/icons/questScrollIcon.svg';
    }
  }
}

@HiveType(typeId: 6)
class RecurringQuest {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final String priority; // stored as string to avoid circular dependency

  @HiveField(4)
  final RecurrenceType recurrenceType;

  @HiveField(5)
  final int customIntervalDays; // Used only for RecurrenceType.custom

  @HiveField(6)
  final DateTime createdAt;

  @HiveField(7)
  final DateTime? lastGeneratedAt;

  @HiveField(8)
  final DateTime nextDueAt;

  @HiveField(9)
  final bool isActive;

  @HiveField(10)
  final String heroId;

  RecurringQuest({
    required this.id,
    required this.title,
    this.description,
    required this.priority,
    required this.recurrenceType,
    this.customIntervalDays = 1,
    DateTime? createdAt,
    this.lastGeneratedAt,
    required this.nextDueAt,
    this.isActive = true,
    required this.heroId,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Calculate the next due date from a base date
  DateTime calculateNextDue(DateTime from) {
    switch (recurrenceType) {
      case RecurrenceType.daily:
        return from.add(const Duration(days: 1));
      case RecurrenceType.weekly:
        return from.add(const Duration(days: 7));
      case RecurrenceType.monthly:
        return DateTime(from.year, from.month + 1, from.day);
      case RecurrenceType.custom:
        return from.add(Duration(days: customIntervalDays));
    }
  }

  bool get isDue {
    return DateTime.now().isAfter(nextDueAt) ||
        DateTime.now().isAtSameMomentAs(nextDueAt);
  }

  RecurringQuest copyWith({
    String? id,
    String? title,
    String? description,
    String? priority,
    RecurrenceType? recurrenceType,
    int? customIntervalDays,
    DateTime? createdAt,
    DateTime? lastGeneratedAt,
    DateTime? nextDueAt,
    bool? isActive,
    String? heroId,
  }) {
    return RecurringQuest(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      recurrenceType: recurrenceType ?? this.recurrenceType,
      customIntervalDays: customIntervalDays ?? this.customIntervalDays,
      createdAt: createdAt ?? this.createdAt,
      lastGeneratedAt: lastGeneratedAt ?? this.lastGeneratedAt,
      nextDueAt: nextDueAt ?? this.nextDueAt,
      isActive: isActive ?? this.isActive,
      heroId: heroId ?? this.heroId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority,
      'recurrence_type': recurrenceType.name,
      'custom_interval_days': customIntervalDays,
      'created_at': createdAt.toIso8601String(),
      'last_generated_at': lastGeneratedAt?.toIso8601String(),
      'next_due_at': nextDueAt.toIso8601String(),
      'is_active': isActive,
      'hero_id': heroId,
    };
  }

  factory RecurringQuest.fromJson(Map<String, dynamic> json) {
    return RecurringQuest(
      id: (json['id'] ?? json['_id']).toString(),
      title: json['title'] as String,
      description: json['description'] as String?,
      priority: json['priority'] as String? ?? 'medium',
      recurrenceType: RecurrenceType.values.firstWhere(
        (t) =>
            t.name ==
            (json['recurrence_type'] ?? json['recurrenceType'] as String?)
                ?.toLowerCase(),
        orElse: () => RecurrenceType.daily,
      ),
      customIntervalDays:
          json['custom_interval_days'] ??
          json['customIntervalDays'] as int? ??
          1,
      createdAt: json['created_at'] != null || json['createdAt'] != null
          ? DateTime.parse((json['created_at'] ?? json['createdAt']) as String)
          : DateTime.now(),
      lastGeneratedAt:
          json['last_generated_at'] != null || json['lastGeneratedAt'] != null
          ? DateTime.parse(
              (json['last_generated_at'] ?? json['lastGeneratedAt']) as String,
            )
          : null,
      nextDueAt: json['next_due_at'] != null || json['nextDueAt'] != null
          ? DateTime.parse((json['next_due_at'] ?? json['nextDueAt']) as String)
          : DateTime.now(),
      isActive: json['is_active'] ?? json['isActive'] as bool? ?? true,
      heroId: (json['hero_id'] ?? json['hero']).toString(),
    );
  }

  // Strictly maps payloads to avoid BSON payload errors by skipping metadata
  Map<String, dynamic> toCreateJson(String explicitHeroId) {
    return {
      'id': id,
      'hero': explicitHeroId,
      'title': title,
      if (description != null && description!.isNotEmpty)
        'description': description,
      'priority': priority.toLowerCase(),
      'recurrenceType': recurrenceType.name.toLowerCase(),
      'nextDueAt': nextDueAt.toIso8601String(),
    };
  }

  // Update JSON mapping (excludes id/hero parameters)
  Map<String, dynamic> toUpdateJson() {
    return {
      'title': title,
      if (description != null) 'description': description,
      'priority': priority.toLowerCase(),
      'recurrenceType': recurrenceType.name.toLowerCase(),
      'nextDueAt': nextDueAt.toIso8601String(),
    };
  }
}
