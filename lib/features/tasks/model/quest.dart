import 'package:hive/hive.dart';

part 'quest.g.dart';

@HiveType(typeId: 1)
class Quest {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final DateTime? deadline;

  @HiveField(4)
  final QuestPriority priority;

  @HiveField(5)
  final bool isCompleted;

  @HiveField(6)
  final DateTime? completedAt;

  @HiveField(7)
  final DateTime createdAt;

  @HiveField(8)
  final String? recurrenceId; // Link to RecurringQuest if applicable

  @HiveField(9)
  final int pomodorosCompleted;

  Quest({
    required this.id,
    required this.title,
    this.description,
    this.deadline,
    this.priority = QuestPriority.medium,
    this.isCompleted = false,
    this.completedAt,
    DateTime? createdAt,
    this.recurrenceId,
    this.pomodorosCompleted = 0,
  }) : createdAt = createdAt ?? DateTime.now();

  /// XP reward based on priority
  int get xpReward {
    switch (priority) {
      case QuestPriority.low:
        return 10;
      case QuestPriority.medium:
        return 25;
      case QuestPriority.high:
        return 50;
    }
  }

  /// Duration to complete (only if completedAt is set)
  Duration? get completionDuration {
    if (completedAt == null) return null;
    return completedAt!.difference(createdAt);
  }

  bool get isRecurring => recurrenceId != null;

  Quest copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? deadline,
    QuestPriority? priority,
    bool? isCompleted,
    DateTime? completedAt,
    DateTime? createdAt,
    String? recurrenceId,
    int? pomodorosCompleted,
  }) {
    return Quest(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      deadline: deadline ?? this.deadline,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
      recurrenceId: recurrenceId ?? this.recurrenceId,
      pomodorosCompleted: pomodorosCompleted ?? this.pomodorosCompleted,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'due_date': deadline?.toIso8601String(),
      'priority': priority.name.toUpperCase(),
      'is_completed': isCompleted,
      'completed_at': completedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'recurrence_id': recurrenceId,
      'pomodoros_completed': pomodorosCompleted,
    };
  }

  /// Strictly mapped payload for backend POST /quests (Matches CreateQuestDto)
  Map<String, dynamic> toCreateJson(String heroId) {
    return {
      'hero': heroId,
      'title': title,
      if (description != null && description!.isNotEmpty)
        'description': description,
      'priority': priority.name.toLowerCase(),
      if (deadline != null) 'dueDate': deadline?.toIso8601String(),
      'rewardXp': xpReward,
    };
  }

  /// Strictly mapped payload for backend PUT /quests (Matches UpdateQuestDto)
  Map<String, dynamic> toUpdateJson() {
    return {
      'title': title,
      if (description != null) 'description': description,
      'priority': priority.name.toLowerCase(),
      if (deadline != null) 'dueDate': deadline?.toIso8601String(),
      'rewardXp': xpReward,
    };
  }

  factory Quest.fromJson(Map<String, dynamic> json) {
    return Quest(
      id: (json['id'] ?? json['_id']).toString(),
      title: json['title'] as String,
      description: json['description'] as String?,
      deadline: (json['deadline'] ?? json['due_date']) != null
          ? DateTime.parse((json['deadline'] ?? json['due_date']) as String)
          : null,
      priority: QuestPriority.values.firstWhere(
        (p) =>
            p.name.toLowerCase() ==
            (json['priority'] as String?)?.toLowerCase(),
        orElse: () => QuestPriority.medium,
      ),
      isCompleted:
          (json['isCompleted'] ?? json['is_completed']) as bool? ?? false,
      completedAt: (json['completedAt'] ?? json['completed_at']) != null
          ? DateTime.parse(
              (json['completedAt'] ?? json['completed_at']) as String,
            )
          : null,
      createdAt: (json['createdAt'] ?? json['created_at']) != null
          ? DateTime.parse((json['createdAt'] ?? json['created_at']) as String)
          : DateTime.now(),
      recurrenceId: json['recurrence_id'] as String?,
      pomodorosCompleted: (json['pomodoros_completed'] as int?) ?? 0,
    );
  }
}

@HiveType(typeId: 2)
enum QuestPriority {
  @HiveField(0)
  low,
  @HiveField(1)
  medium,
  @HiveField(2)
  high;

  String get icon {
    // Return SVG asset path instead of emoji
    return pixelIcon;
  }

  String get pixelIcon {
    switch (this) {
      case QuestPriority.low:
        return 'assets/icons/lowPriorityIcon.svg';
      case QuestPriority.medium:
        return 'assets/icons/mediumPriorityIcon.svg';
      case QuestPriority.high:
        return 'assets/icons/highPriorityIcon.svg';
    }
  }

  String get label {
    switch (this) {
      case QuestPriority.low:
        return 'Low';
      case QuestPriority.medium:
        return 'Medium';
      case QuestPriority.high:
        return 'High';
    }
  }
}
