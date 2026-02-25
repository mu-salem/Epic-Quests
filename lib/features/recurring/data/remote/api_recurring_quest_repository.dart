import 'package:epicquests/core/constants/api_endpoints.dart';
import 'package:epicquests/core/network/api_client.dart';
import 'package:epicquests/features/tasks/model/recurring_quest.dart';

/// Repository for handling recurring quest API requests
class ApiRecurringQuestRepository {
  final ApiClient _apiClient;

  // Added optionally for testing
  ApiRecurringQuestRepository({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  /// Get all recurring quests for a hero
  Future<List<RecurringQuest>> getQuests(String heroId) async {
    final response = await _apiClient.get(
      ApiEndpoints.recurringQuests,
      queryParameters: {'hero_id': heroId},
    );

    final data = response.data as Map<String, dynamic>;
    if (data['success'] == true) {
      final List<dynamic> jsonList = data['recurringQuests'] ?? [];
      return jsonList
          .map((json) => RecurringQuest.fromJson(json as Map<String, dynamic>))
          .toList();
    }

    throw Exception('Failed to load recurring quests: Invalid response format');
  }

  /// Create a new recurring quest
  Future<RecurringQuest> createQuest(
    RecurringQuest quest,
    String heroId,
  ) async {
    final response = await _apiClient.post(
      ApiEndpoints.recurringQuests,
      data: quest.toCreateJson(heroId),
    );

    final data = response.data as Map<String, dynamic>;
    if (data['success'] == true) {
      return RecurringQuest.fromJson(
        data['recurringQuest'] as Map<String, dynamic>,
      );
    }

    throw Exception(
      'Failed to create recurring quest: Invalid response format',
    );
  }

  /// Update an existing recurring quest
  Future<RecurringQuest> updateQuest(RecurringQuest quest) async {
    // API uses PATCH for the general update
    final response = await _apiClient.patch(
      ApiEndpoints.recurringQuest(quest.id),
      data: quest.toUpdateJson(),
    );

    final data = response.data as Map<String, dynamic>;
    if (data['success'] == true) {
      return RecurringQuest.fromJson(
        data['recurringQuest'] as Map<String, dynamic>,
      );
    }

    throw Exception(
      'Failed to update recurring quest: Invalid response format',
    );
  }

  /// Delete a recurring quest
  Future<void> deleteQuest(String questId) async {
    await _apiClient.delete(ApiEndpoints.recurringQuest(questId));
  }
}
