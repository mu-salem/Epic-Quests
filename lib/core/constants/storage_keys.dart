class StorageKeys {
  StorageKeys._();

  // ========================================
  // SharedPreferences Keys (Simple Settings)
  // ========================================

  // Onboarding
  static const String onboardingCompleted = 'onboarding_completed';

  // App Settings
  static const String themeMode = 'theme_mode';
  static const String languageCode = 'language_code';

  // Multi-Hero System
  static const String lastSelectedHero =
      'last_selected_hero'; // Stores the name of the last selected hero

  /// Get storage key for a specific hero's profile
  /// Example: hero_Arin, hero_Luna, etc.
  static String heroProfile(String heroName) => 'hero_$heroName';

  // ========================================
  // Secure Storage Keys (Sensitive Data)
  // ========================================

  // Auth Tokens (MUST use SecureStorageService, NOT SharedPreferences!)
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String userEmail = 'user_email';

  // Note: Hive box names are defined in HiveBoxes class
}
