import '../../model/quest.dart';

abstract class QuestRepository {
  /// Get all quests
  Future<List<Quest>> getQuests();
  
  /// Add a new quest
  Future<void> addQuest(Quest quest);
  
  /// Update an existing quest
  Future<void> updateQuest(Quest quest);
  
  /// Delete a quest
  Future<void> deleteQuest(String questId);
  
  /// Save quests to persistent storage
  Future<void> saveQuests(List<Quest> quests);
}
