class UserModel {
  final String id;
  final String email;
  final String? name;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.email,
    this.name,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Handle both 'id' and '_id' from backend with proper null safety
    final id = json['id'] ?? json['_id'];
    if (id == null) {
      throw ArgumentError('User ID is required but was null in JSON response');
    }

    // Handle both 'createdAt' and 'created_at' from backend
    // Use current time as fallback if not provided
    final createdAtStr = json['createdAt'] ?? json['created_at'];
    final createdAt = createdAtStr != null
        ? DateTime.parse(createdAtStr as String)
        : DateTime.now();

    return UserModel(
      id: id.toString(),
      email: json['email'] as String,
      // Handle both 'name' and 'username' from backend
      name: json['name'] as String? ?? json['username'] as String?,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
