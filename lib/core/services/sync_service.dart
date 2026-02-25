import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/pending_action.dart';
import '../network/api_client.dart';
import '../storage/hive/hive_boxes.dart';
import 'connectivity_service.dart';

/// Service to manage offline data sync - fixed version
class SyncService extends ChangeNotifier {
  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;
  SyncService._internal();

  final ApiClient _apiClient = ApiClient();
  final ConnectivityService _connectivity = ConnectivityService();

  bool _isSyncing = false;
  bool get isSyncing => _isSyncing;

  int _pendingActionsCount = 0;
  int get pendingActionsCount => _pendingActionsCount;

  DateTime? _lastSyncedAt;
  DateTime? get lastSyncedAt => _lastSyncedAt;

  Future<void> init() async {
    _connectivity.addListener(_onConnectivityChanged);
    await _updatePendingCount();
    if (_connectivity.isOnline) {
      await syncPendingActions();
    }
  }

  void _onConnectivityChanged() {
    if (_connectivity.isOnline && !_isSyncing && _pendingActionsCount > 0) {
      debugPrint('🔄 Connection restored. Starting sync...');
      syncPendingActions();
    }
  }

  Future<void> addPendingAction({
    required String endpoint,
    required String method,
    Map<String, dynamic>? data,
    String? localId,
  }) async {
    try {
      final box = await Hive.openBox<PendingAction>(HiveBoxes.pendingActions);
      final action = PendingAction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        endpoint: endpoint,
        method: method,
        data: data,
        createdAt: DateTime.now(),
        localId: localId,
      );
      await box.add(action);
      await _updatePendingCount();
      debugPrint('📝 Added pending action: $method $endpoint');
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error adding pending action: $e');
    }
  }

  /// FIXED: Sync pending actions using key-based deletion (no off-by-one)
  Future<void> syncPendingActions() async {
    if (_isSyncing || _connectivity.isOffline) return;

    try {
      _isSyncing = true;
      notifyListeners();

      final box = await Hive.openBox<PendingAction>(HiveBoxes.pendingActions);
      final keys = box.keys.toList();

      if (keys.isEmpty) {
        debugPrint('✅ No pending actions to sync');
        _isSyncing = false;
        notifyListeners();
        return;
      }

      debugPrint('🔄 Syncing ${keys.length} pending actions...');

      int successCount = 0;
      int failureCount = 0;
      final keysToDelete = <dynamic>[];

      for (final key in keys) {
        final action = box.get(key);
        if (action == null) continue;

        try {
          await _executeAction(action);
          keysToDelete.add(key);
          successCount++;
          debugPrint('✅ Synced: ${action.method} ${action.endpoint}');
        } catch (e) {
          failureCount++;
          debugPrint(
            '❌ Failed to sync: ${action.method} ${action.endpoint} - $e',
          );

          final updatedAction = action.copyWith(
            retryCount: action.retryCount + 1,
          );
          if (updatedAction.retryCount >= 3) {
            debugPrint('⚠️ Max retries reached. Removing action.');
            keysToDelete.add(key);
          } else {
            await box.put(key, updatedAction);
          }
        }
      }

      // Delete in batch after loop (no index shifting)
      for (final key in keysToDelete) {
        await box.delete(key);
      }

      _lastSyncedAt = DateTime.now();
      await _updatePendingCount();
      debugPrint(
        '🎉 Sync complete: $successCount succeeded, $failureCount failed',
      );
    } catch (e) {
      debugPrint('❌ Sync error: $e');
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }

  Future<void> _executeAction(PendingAction action) async {
    switch (action.method.toUpperCase()) {
      case 'GET':
        await _apiClient.get(action.endpoint);
        break;
      case 'POST':
        final response = await _apiClient.post(
          action.endpoint,
          data: action.data,
        );

        // Handle ID reassignment for locally created objects
        if (action.localId != null &&
            response.data != null &&
            response.data['success'] == true) {
          // New Hero Created
          if (action.endpoint.contains('/heroes') &&
              response.data['hero'] != null) {
            final newId =
                response.data['hero']['id'] ?? response.data['hero']['_id'];
            if (newId != null && newId != action.localId) {
              final heroBox = await Hive.openBox<dynamic>(
                HiveBoxes.heroProfiles,
              );
              final oldHero = heroBox.get(action.localId);

              if (oldHero != null) {
                // The generated class doesn't have copyWith by default so we might need to recreate or assume it does
                final updatedHero = oldHero.copyWith(id: newId.toString());
                await heroBox.put(newId.toString(), updatedHero);
                await heroBox.delete(action.localId);

                // Update last selected hero if it matches
                final userBox = await Hive.openBox('epic_quests_user');
                if (userBox.get('last_selected_hero_id') == action.localId) {
                  await userBox.put('last_selected_hero_id', newId.toString());
                }
                debugPrint(
                  '🔄 Reassigned local Hero ID ${action.localId} to $newId',
                );
              }
            }
          }

          // New Quest Created
          if (action.endpoint.contains('/quests') &&
              response.data['quest'] != null) {
            final newId =
                response.data['quest']['id'] ?? response.data['quest']['_id'];
            if (newId != null && newId != action.localId) {
              final questBox = await Hive.openBox<dynamic>(HiveBoxes.quests);
              final oldQuest = questBox.get(action.localId);

              if (oldQuest != null) {
                final updatedQuest = oldQuest.copyWith(id: newId.toString());
                await questBox.put(newId.toString(), updatedQuest);
                await questBox.delete(action.localId);
                debugPrint(
                  '🔄 Reassigned local Quest ID ${action.localId} to $newId',
                );
              }
            }
          }
        }
        break;
      case 'PUT':
        await _apiClient.put(action.endpoint, data: action.data);
        break;
      case 'DELETE':
        await _apiClient.delete(action.endpoint, data: action.data);
        break;
      case 'PATCH':
        await _apiClient.patch(action.endpoint, data: action.data);
        break;
      default:
        throw UnsupportedError('Unsupported method: ${action.method}');
    }
  }

  Future<void> _updatePendingCount() async {
    try {
      final box = await Hive.openBox<PendingAction>(HiveBoxes.pendingActions);
      _pendingActionsCount = box.length;
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error updating pending count: $e');
    }
  }

  Future<int> getPendingActionsCount() async {
    try {
      final box = await Hive.openBox<PendingAction>(HiveBoxes.pendingActions);
      return box.length;
    } catch (e) {
      return 0;
    }
  }

  Future<void> clearPendingActions() async {
    try {
      final box = await Hive.openBox<PendingAction>(HiveBoxes.pendingActions);
      await box.clear();
      await _updatePendingCount();
    } catch (e) {
      debugPrint('❌ Error clearing pending actions: $e');
    }
  }

  @override
  void dispose() {
    _connectivity.removeListener(_onConnectivityChanged);
    super.dispose();
  }
}
