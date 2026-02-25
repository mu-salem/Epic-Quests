/// API endpoint constants for the application
class ApiEndpoints {
  ApiEndpoints._();

  // ========================================
  // Authentication Endpoints
  // ========================================

  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String forgotPassword = '/auth/forgot-password';
  static const String verifyResetCode = '/auth/verify-reset-code';
  static const String resetPassword = '/auth/reset-password';

  // ========================================
  // User/Profile Endpoints
  // ========================================

  static const String getProfile = '/user/profile';
  static const String updateProfile = '/user/profile';
  static const String changePassword = '/user/change-password';
  static const String deleteAccount = '/user/delete-account';

  // ========================================
  // Hero/Avatar Endpoints
  // ========================================

  static const String getHeroes = '/heroes';
  static const String createHero = '/heroes';
  static String getHero(String heroId) => '/heroes/$heroId';
  static String updateHero(String heroId) => '/heroes/$heroId';
  static String deleteHero(String heroId) => '/heroes/$heroId';
  static String selectHero(String heroId) => '/heroes/$heroId/select';

  // ========================================
  // Quest/Task Endpoints
  // ========================================

  static const String getQuests = '/quests';
  static const String createQuest = '/quests';
  static String getQuest(String questId) => '/quests/$questId';
  static String updateQuest(String questId) => '/quests/$questId';
  static String deleteQuest(String questId) => '/quests/$questId';
  static String completeQuest(String questId) => '/quests/$questId/complete';
  static String uncompleteQuest(String questId) =>
      '/quests/$questId/uncomplete';

  // Recurring Quest Endpoints
  static const String recurringQuests = '/recurring-quests';
  static String recurringQuest(String id) => '/recurring-quests/$id';

  // Quest filtering
  static const String getActiveQuests = '/quests?status=active';
  static const String getCompletedQuests = '/quests?status=completed';
  static String getQuestsByPriority(String priority) =>
      '/quests?priority=$priority';
  static String getQuestsByHero(String heroId) => '/quests?hero_id=$heroId';

  // ========================================
  // Statistics/Analytics Endpoints
  // ========================================

  static const String getStats = '/stats';
  static String getHeroStats(String heroId) => '/stats/hero/$heroId';
  static const String getLeaderboard = '/leaderboard';

  // ========================================
  // Sync Endpoints
  // ========================================

  static const String syncData = '/sync';
  static const String getLastSync = '/sync/last';

  // ========================================
  // Settings Endpoints
  // ========================================

  static const String getSettings = '/settings';
  static const String updateSettings = '/settings';
}
