class Quest {
  final String id;
  final String title;
  final String? description;
  final DateTime? deadline;
  final QuestPriority priority;
  final bool isCompleted;
  final DateTime? completedAt; // Track when quest was completed

  Quest({
    required this.id,
    required this.title,
    this.description,
    this.deadline,
    this.priority = QuestPriority.medium,
    this.isCompleted = false,
    this.completedAt,
  });

  /// Create a copy of this Quest with some fields replaced
  Quest copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? deadline,
    QuestPriority? priority,
    bool? isCompleted,
    DateTime? completedAt,
  }) {
    return Quest(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      deadline: deadline ?? this.deadline,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  /// Convert to JSON (for SharedPreferences)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'deadline': deadline?.toIso8601String(),
      'priority': priority.name,
      'isCompleted': isCompleted,
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  /// Create from JSON
  factory Quest.fromJson(Map<String, dynamic> json) {
    return Quest(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      deadline: json['deadline'] != null 
          ? DateTime.parse(json['deadline'] as String)
          : null,
      priority: QuestPriority.values.firstWhere(
        (p) => p.name == json['priority'],
        orElse: () => QuestPriority.medium,
      ),
      isCompleted: json['isCompleted'] as bool? ?? false,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
    );
  }
}

/// Quest Priority Level
enum QuestPriority {
  low,
  medium,
  high;

  /// Get priority icon/emoji
  String get icon {
    switch (this) {
      case QuestPriority.low:
        return '🛡️';
      case QuestPriority.medium:
        return '⚔️';
      case QuestPriority.high:
        return '🔥';
    }
  }

  /// Get priority label
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
