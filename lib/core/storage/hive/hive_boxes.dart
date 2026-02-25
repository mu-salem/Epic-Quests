/// Constants for Hive box names.
class HiveBoxes {
  HiveBoxes._();

  static const String heroProfiles = 'hero_profiles';
  static const String quests = 'quests';
  static const String pendingActions = 'pending_actions';
  static const String avatars = 'avatars';
  static const String cache = 'cache';
  static const String recurringQuests = 'recurring_quests';
  static const String pomodoroSessions = 'pomodoro_sessions';

  static List<String> get allBoxes => [
    heroProfiles,
    quests,
    pendingActions,
    avatars,
    cache,
    recurringQuests,
    pomodoroSessions,
  ];
}
