import 'package:hive/hive.dart';
import '../../../../core/storage/hive/hive_service.dart';
import '../../../../core/storage/hive/hive_boxes.dart';
import '../../model/quest.dart';
import '../repositories/quest_repository.dart';

class LocalQuestRepository implements QuestRepository {
  /// Get the Hive box for quests
  Box<Quest> get _questBox => HiveService.getTypedBox<Quest>(HiveBoxes.quests);

  @override
  Future<List<Quest>> getQuests() async {
    return _questBox.values.toList();
  }

  @override
  Future<Quest> addQuest(Quest quest, String heroId) async {
    // Use quest.id as the key for easy retrieval and updates
    await _questBox.put(quest.id, quest);
    return quest;
  }

  @override
  Future<void> updateQuest(Quest quest) async {
    // Same as addQuest - put will overwrite if key exists
    await _questBox.put(quest.id, quest);
  }

  @override
  Future<void> deleteQuest(String questId) async {
    await _questBox.delete(questId);
  }

  @override
  Future<void> saveQuests(List<Quest> quests) async {
    // Clear existing and save all
    await _questBox.clear();
    final questMap = {for (var quest in quests) quest.id: quest};
    await _questBox.putAll(questMap);
  }
}
