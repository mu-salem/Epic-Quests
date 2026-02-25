import 'package:flutter/material.dart';
import '../../constants/storage_keys.dart';
import 'local_storage_service.dart';

class AppSettingsRepository {
  /// Get theme mode
  Future<ThemeMode> getThemeMode() async {
    final themeModeString = LocalStorageService.getString(
      StorageKeys.themeMode,
    );
    if (themeModeString == null) {
      return ThemeMode.dark; // Default to dark theme
    }

    return ThemeMode.values.firstWhere(
      (mode) => mode.name == themeModeString,
      orElse: () => ThemeMode.dark,
    );
  }

  /// Set theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    await LocalStorageService.setString(StorageKeys.themeMode, mode.name);
  }

  /// Get language code
  Future<String?> getLanguageCode() async {
    return LocalStorageService.getString(StorageKeys.languageCode);
  }

  /// Set language code
  Future<void> setLanguageCode(String languageCode) async {
    await LocalStorageService.setString(StorageKeys.languageCode, languageCode);
  }

  /// Check if onboarding is completed
  Future<bool> isOnboardingCompleted() async {
    return LocalStorageService.getBool(StorageKeys.onboardingCompleted) ??
        false;
  }

  /// Mark onboarding as completed
  Future<void> setOnboardingCompleted(bool completed) async {
    await LocalStorageService.setBool(
      StorageKeys.onboardingCompleted,
      completed,
    );
  }

  /// Clear all app settings (use with caution!)
  Future<void> clearAllSettings() async {
    await LocalStorageService.remove(StorageKeys.themeMode);
    await LocalStorageService.remove(StorageKeys.languageCode);
    await LocalStorageService.remove(StorageKeys.onboardingCompleted);
  }
}
