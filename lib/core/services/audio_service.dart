import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppSound {
  questComplete,
  levelUp,
  questAdd,
  questDelete,
  buttonTap,
  pomodoroComplete,
  breakComplete,
}

// Empty placeholder if needed elsewhere or completely removed.

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _sfxPlayer = AudioPlayer();

  bool _isSoundEnabled = true;
  double _sfxVolume = 0.8;

  bool get isSoundEnabled => _isSoundEnabled;
  double get sfxVolume => _sfxVolume;

  static const String _soundPrefKey = 'audio_sound_enabled';
  static const String _sfxVolPrefKey = 'audio_sfx_volume';

  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isSoundEnabled = prefs.getBool(_soundPrefKey) ?? true;
      _sfxVolume = prefs.getDouble(_sfxVolPrefKey) ?? 0.8;

      await _sfxPlayer.setVolume(_sfxVolume);
    } catch (e) {
      debugPrint('AudioService init error: $e');
    }
  }

  Future<void> playSfx(AppSound sound) async {
    if (!_isSoundEnabled) return;
    try {
      final path = _getSfxPath(sound);
      await _sfxPlayer.play(AssetSource(path));
    } catch (e) {
      debugPrint('SFX play error: $e');
    }
  }

  Future<void> toggleSound() async {
    _isSoundEnabled = !_isSoundEnabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_soundPrefKey, _isSoundEnabled);
  }

  Future<void> setSfxVolume(double volume) async {
    _sfxVolume = volume.clamp(0.0, 1.0);
    await _sfxPlayer.setVolume(_sfxVolume);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_sfxVolPrefKey, _sfxVolume);
  }

  String _getSfxPath(AppSound sound) {
    switch (sound) {
      case AppSound.questComplete:
        return 'audio/sfx/quest_complete.mp3';
      case AppSound.levelUp:
        return 'audio/sfx/level_up.mp3';
      case AppSound.questAdd:
        return 'audio/sfx/quest_add.mp3';
      case AppSound.questDelete:
        return 'audio/sfx/quest_delete.mp3';
      case AppSound.buttonTap:
        return 'audio/sfx/button_tap.mp3';
      case AppSound.pomodoroComplete:
        return 'audio/sfx/pomodoro_complete.mp3';
      case AppSound.breakComplete:
        return 'audio/sfx/break_complete.mp3';
    }
  }

  void dispose() {
    _sfxPlayer.dispose();
  }
}
