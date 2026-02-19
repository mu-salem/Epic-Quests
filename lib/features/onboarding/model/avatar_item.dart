/// Represents an avatar template (the base character)
class AvatarTemplate {
  final String name;
  final String asset;
  final String gender; // 'boy' or 'girl'

  const AvatarTemplate({
    required this.name,
    required this.asset,
    required this.gender,
  });
}

/// Represents a user's created avatar instance
class AvatarItem {
  final String id;
  final String templateName; // Reference to AvatarTemplate
  final String asset; // Avatar image path
  final String displayName; // Custom name or default template name
  final String? description; // Purpose/description of this avatar
  final int level;
  final int currentXP;
  final String gender; // 'boy' or 'girl'
  final DateTime createdAt;

  const AvatarItem({
    required this.id,
    required this.templateName,
    required this.asset,
    required this.displayName,
    this.description,
    this.level = 1,
    this.currentXP = 0,
    required this.gender,
    required this.createdAt,
  });

  /// Create from JSON
  factory AvatarItem.fromJson(Map<String, dynamic> json) {
    return AvatarItem(
      id: json['id'] as String,
      templateName: json['templateName'] as String,
      asset: json['asset'] as String,
      displayName: json['displayName'] as String,
      description: json['description'] as String?,
      level: json['level'] as int? ?? 1,
      currentXP: json['currentXP'] as int? ?? 0,
      gender: json['gender'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'templateName': templateName,
      'asset': asset,
      'displayName': displayName,
      'description': description,
      'level': level,
      'currentXP': currentXP,
      'gender': gender,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Copy with method for updates
  AvatarItem copyWith({
    String? id,
    String? templateName,
    String? asset,
    String? displayName,
    String? description,
    int? level,
    int? currentXP,
    String? gender,
    DateTime? createdAt,
  }) {
    return AvatarItem(
      id: id ?? this.id,
      templateName: templateName ?? this.templateName,
      asset: asset ?? this.asset,
      displayName: displayName ?? this.displayName,
      description: description ?? this.description,
      level: level ?? this.level,
      currentXP: currentXP ?? this.currentXP,
      gender: gender ?? this.gender,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
