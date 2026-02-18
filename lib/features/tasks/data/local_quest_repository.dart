import 'dart:convert';
import '../../../core/services/local_storage_service.dart';
import '../model/quest.dart';
import 'quest_repository.dart';

class LocalQuestRepository implements QuestRepository {
  static const String _questsKey = 'quests';

  @override
  Future<List<Quest>> getQuests() async {
    final jsonString = await LocalStorageService.getString(_questsKey);
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => Quest.fromJson(json)).toList();
    } catch (e) {
      // If there's an error parsing, return empty list
      return [];
    }
  }

  @override
  Future<void> addQuest(Quest quest) async {
    final quests = await getQuests();
    quests.insert(0, quest);
    await saveQuests(quests);
  }

  @override
  Future<void> updateQuest(Quest quest) async {
    final quests = await getQuests();
    final index = quests.indexWhere((q) => q.id == quest.id);
    if (index != -1) {
      quests[index] = quest;
      await saveQuests(quests);
    }
  }

  @override
  Future<void> deleteQuest(String questId) async {
    final quests = await getQuests();
    quests.removeWhere((q) => q.id == questId);
    await saveQuests(quests);
  }

  @override
  Future<void> saveQuests(List<Quest> quests) async {
    final jsonList = quests.map((quest) => quest.toJson()).toList();
    final jsonString = json.encode(jsonList);
    await LocalStorageService.setString(_questsKey, jsonString);
  }
}
