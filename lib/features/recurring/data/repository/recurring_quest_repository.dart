import '../../../tasks/model/recurring_quest.dart';
import '../../../../core/services/recurring_quest_service.dart';

/// Thin repository wrapper around RecurringQuestService for UI usage
class RecurringQuestRepository {
  RecurringQuestRepository._();

  static List<RecurringQuest> getForHero(String heroId) =>
      RecurringQuestService.getForHero(heroId);

  static Future<void> save(RecurringQuest quest) =>
      RecurringQuestService.saveRecurring(quest);

  static Future<void> delete(String id) =>
      RecurringQuestService.deleteRecurring(id);

  static Future<void> toggleActive(String id) =>
      RecurringQuestService.toggleActive(id);
}
