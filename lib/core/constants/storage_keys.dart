class StorageKeys {
  StorageKeys._();

  // Onboarding
  static const String onboardingCompleted = 'onboarding_completed';
  
  // Multi-Hero System
  static const String lastSelectedHero = 'last_selected_hero'; // Stores the name of the last selected hero
  
  /// Get storage key for a specific hero's profile
  /// Example: hero_Arin, hero_Luna, etc.
  static String heroProfile(String heroName) => 'hero_$heroName';

}

