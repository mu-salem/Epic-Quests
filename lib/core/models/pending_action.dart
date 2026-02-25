import 'package:hive/hive.dart';

part 'pending_action.g.dart';

/// Represents an action that needs to be synced to the server
@HiveType(typeId: 3)
class PendingAction {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String endpoint;

  @HiveField(2)
  final String method; // GET, POST, PUT, DELETE, PATCH

  @HiveField(3)
  final Map<String, dynamic>? data;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final String? localId; // Local reference ID for updates

  @HiveField(6)
  final int retryCount;

  PendingAction({
    required this.id,
    required this.endpoint,
    required this.method,
    this.data,
    required this.createdAt,
    this.localId,
    this.retryCount = 0,
  });

  /// Create a copy with updated fields
  PendingAction copyWith({
    String? id,
    String? endpoint,
    String? method,
    Map<String, dynamic>? data,
    DateTime? createdAt,
    String? localId,
    int? retryCount,
  }) {
    return PendingAction(
      id: id ?? this.id,
      endpoint: endpoint ?? this.endpoint,
      method: method ?? this.method,
      data: data ?? this.data,
      createdAt: createdAt ?? this.createdAt,
      localId: localId ?? this.localId,
      retryCount: retryCount ?? this.retryCount,
    );
  }
}
