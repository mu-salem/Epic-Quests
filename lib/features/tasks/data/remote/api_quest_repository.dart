import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../../model/quest.dart';
import '../repositories/quest_repository.dart';

/// API-based Quest Repository
/// Communicates with backend MongoDB database
class ApiQuestRepository implements QuestRepository {
  final ApiClient _apiClient;

  ApiQuestRepository({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  @override
  Future<List<Quest>> getQuests() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.getQuests);
      final data = response.data as Map<String, dynamic>;

      if (data['success'] == true && data['quests'] != null) {
        final questsList = data['quests'] as List;
        return questsList.map((json) => Quest.fromJson(json)).toList();
      }

      return [];
    } catch (e) {
      return [];
    }
  }

  @override
  Future<Quest> addQuest(Quest quest, String heroId) async {
    final response = await _apiClient.post(
      ApiEndpoints.createQuest,
      data: quest.toCreateJson(heroId),
    );

    final data = response.data as Map<String, dynamic>?;
    if (data != null && data['success'] == true && data['quest'] != null) {
      return Quest.fromJson(data['quest']);
    }
    return quest;
  }

  @override
  Future<void> updateQuest(Quest quest) async {
    await _apiClient.patch(
      ApiEndpoints.updateQuest(quest.id),
      data: quest.toUpdateJson(),
    );
  }

  @override
  Future<void> deleteQuest(String questId) async {
    await _apiClient.delete(ApiEndpoints.deleteQuest(questId));
  }

  @override
  Future<void> saveQuests(List<Quest> quests) async {
    // Not implemented for API - use sync endpoint instead
    throw UnimplementedError('Use sync endpoint for batch operations');
  }

  /// Get quest by ID
  Future<Quest> getQuestById(String questId) async {
    try {
      final response = await _apiClient.get(ApiEndpoints.getQuest(questId));
      final data = response.data as Map<String, dynamic>;

      if (data['success'] == true && data['quest'] != null) {
        return Quest.fromJson(data['quest']);
      }

      throw Exception('Quest not found');
    } catch (e) {
      rethrow;
    }
  }

  /// Complete a quest
  Future<void> completeQuest(String questId) async {
    await _apiClient.patch(ApiEndpoints.completeQuest(questId));
  }

  /// Uncomplete a quest
  Future<void> uncompleteQuest(String questId) async {
    await _apiClient.patch(ApiEndpoints.uncompleteQuest(questId));
  }

  /// Get quests by status (active or completed)
  Future<List<Quest>> getQuestsByStatus(bool isCompleted) async {
    final endpoint = isCompleted
        ? ApiEndpoints.getCompletedQuests
        : ApiEndpoints.getActiveQuests;
    final response = await _apiClient.get(endpoint);
    final data = response.data as Map<String, dynamic>;

    if (data['success'] == true && data['quests'] != null) {
      final questsList = data['quests'] as List;
      return questsList.map((json) => Quest.fromJson(json)).toList();
    }

    return [];
  }

  /// Get quests by priority
  Future<List<Quest>> getQuestsByPriority(QuestPriority priority) async {
    final response = await _apiClient.get(
      ApiEndpoints.getQuestsByPriority(priority.name),
    );
    final data = response.data as Map<String, dynamic>;

    if (data['success'] == true && data['quests'] != null) {
      final questsList = data['quests'] as List;
      return questsList.map((json) => Quest.fromJson(json)).toList();
    }

    return [];
  }

  /// Get quests by hero ID
  Future<List<Quest>> getQuestsByHeroId(String heroId) async {
    final response = await _apiClient.get(ApiEndpoints.getQuestsByHero(heroId));
    final data = response.data as Map<String, dynamic>;

    if (data['success'] == true && data['quests'] != null) {
      final questsList = data['quests'] as List;
      return questsList.map((json) => Quest.fromJson(json)).toList();
    }

    return [];
  }
}
