import 'package:hive_flutter/hive_flutter.dart';
import '../../models/pending_action.dart';
import '../../../features/tasks/model/hero_profile.dart';
import '../../../features/tasks/model/quest.dart';
import '../../../features/pomodoro/model/pomodoro_session.dart';
import 'hive_boxes.dart';

class HiveService {
  HiveService._();

  static bool _isInitialized = false;

  static Future<void> initHive() async {
    if (_isInitialized) return;
    await Hive.initFlutter();
    _isInitialized = true;
  }

  static void registerAdapters() {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(HeroProfileAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(QuestAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(QuestPriorityAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(PendingActionAdapter());
    }
    if (!Hive.isAdapterRegistered(7)) {
      Hive.registerAdapter(PomodoroSessionAdapter());
    }
  }

  static Future<void> openBoxes() async {
    if (!_isInitialized) {
      throw Exception('HiveService must be initialized before opening boxes');
    }
    registerAdapters();

    if (!Hive.isBoxOpen(HiveBoxes.heroProfiles)) {
      await Hive.openBox<HeroProfile>(HiveBoxes.heroProfiles);
    }
    if (!Hive.isBoxOpen(HiveBoxes.quests)) {
      await Hive.openBox<Quest>(HiveBoxes.quests);
    }
    if (!Hive.isBoxOpen(HiveBoxes.pendingActions)) {
      await Hive.openBox<PendingAction>(HiveBoxes.pendingActions);
    }
    if (!Hive.isBoxOpen(HiveBoxes.avatars)) {
      await Hive.openBox(HiveBoxes.avatars);
    }
    if (!Hive.isBoxOpen(HiveBoxes.cache)) {
      await Hive.openBox(HiveBoxes.cache);
    }
    if (!Hive.isBoxOpen(HiveBoxes.pomodoroSessions)) {
      await Hive.openBox<PomodoroSession>(HiveBoxes.pomodoroSessions);
    }
  }

  static Box getBox(String boxName) {
    if (!Hive.isBoxOpen(boxName)) {
      throw Exception('Box "$boxName" is not open. Call openBoxes() first.');
    }
    return Hive.box(boxName);
  }

  static Box<T> getTypedBox<T>(String boxName) {
    if (!Hive.isBoxOpen(boxName)) {
      throw Exception('Box "$boxName" is not open. Call openBoxes() first.');
    }
    return Hive.box<T>(boxName);
  }

  static Future<void> clearBox(String boxName) async {
    final box = getBox(boxName);
    await box.clear();
  }

  static Future<void> closeBox(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      await Hive.box(boxName).close();
    }
  }

  static Future<void> closeHive() async {
    await Hive.close();
    _isInitialized = false;
  }

  static Future<void> deleteBox(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      await Hive.box(boxName).close();
    }
    await Hive.deleteBoxFromDisk(boxName);
  }

  static Future<void> deleteAllBoxes() async {
    for (final boxName in HiveBoxes.allBoxes) {
      await deleteBox(boxName);
    }
  }
}
