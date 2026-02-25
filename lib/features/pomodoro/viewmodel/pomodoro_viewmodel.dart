import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../../../core/services/audio_service.dart';
import '../../../core/storage/hive/hive_boxes.dart';
import '../model/pomodoro_session.dart';

enum PomodoroPhase { work, shortBreak, longBreak }

class PomodoroViewModel extends ChangeNotifier {
  final String? questId;
  final String? heroId;

  PomodoroViewModel({this.questId, this.heroId});

  // ── Config ─────────────────────────────────────
  int workDuration = 25; // minutes
  int shortBreakDuration = 5;
  int longBreakDuration = 15;
  int sessionsBeforeLongBreak = 4;

  // ── State ──────────────────────────────────────
  PomodoroPhase _phase = PomodoroPhase.work;
  int _sessionsCompleted = 0;
  int _totalSecondsLeft = 25 * 60;
  bool _isRunning = false;
  bool _isPaused = false;
  Timer? _timer;

  PomodoroPhase get phase => _phase;
  int get sessionsCompleted => _sessionsCompleted;
  int get totalSecondsLeft => _totalSecondsLeft;
  bool get isRunning => _isRunning;
  bool get isPaused => _isPaused;

  Duration get timeLeft => Duration(seconds: _totalSecondsLeft);
  double get progress {
    final totalSec = _phaseDurationSeconds;
    if (totalSec == 0) return 0;
    return (_totalSecondsLeft / totalSec);
  }

  int get _phaseDurationSeconds {
    switch (_phase) {
      case PomodoroPhase.work:
        return workDuration * 60;
      case PomodoroPhase.shortBreak:
        return shortBreakDuration * 60;
      case PomodoroPhase.longBreak:
        return longBreakDuration * 60;
    }
  }

  String get phaseLabel {
    switch (_phase) {
      case PomodoroPhase.work:
        return 'FOCUS';
      case PomodoroPhase.shortBreak:
        return 'SHORT BREAK';
      case PomodoroPhase.longBreak:
        return 'LONG BREAK';
    }
  }

  String get formattedTime {
    final m = timeLeft.inMinutes.toString().padLeft(2, '0');
    final s = (timeLeft.inSeconds.remainder(60)).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void start() {
    if (_isRunning) return;
    _isRunning = true;
    _isPaused = false;
    _timer = Timer.periodic(const Duration(seconds: 1), _tick);
    notifyListeners();
  }

  void pause() {
    if (!_isRunning) return;
    _timer?.cancel();
    _isRunning = false;
    _isPaused = true;
    notifyListeners();
  }

  void resume() {
    if (_isRunning || !_isPaused) return;
    start();
  }

  void reset() {
    _timer?.cancel();
    _isRunning = false;
    _isPaused = false;
    _totalSecondsLeft = _phaseDurationSeconds;
    notifyListeners();
  }

  void skipPhase() {
    _timer?.cancel();
    _isRunning = false;
    _isPaused = false;
    _advancePhase();
    notifyListeners();
  }

  void _tick(Timer t) {
    if (_totalSecondsLeft > 0) {
      _totalSecondsLeft--;
      notifyListeners();
    } else {
      _timer?.cancel();
      _isRunning = false;
      _onPhaseComplete();
    }
  }

  void _onPhaseComplete() {
    if (_phase == PomodoroPhase.work) {
      _sessionsCompleted++;
      AudioService().playSfx(AppSound.pomodoroComplete);
      _saveSession();
    } else {
      AudioService().playSfx(AppSound.breakComplete);
    }
    _advancePhase();
    notifyListeners();
  }

  void _advancePhase() {
    if (_phase == PomodoroPhase.work) {
      if (_sessionsCompleted % sessionsBeforeLongBreak == 0) {
        _phase = PomodoroPhase.longBreak;
      } else {
        _phase = PomodoroPhase.shortBreak;
      }
    } else {
      _phase = PomodoroPhase.work;
    }
    _totalSecondsLeft = _phaseDurationSeconds;
  }

  Future<void> _saveSession() async {
    try {
      final box = Hive.box<PomodoroSession>(HiveBoxes.pomodoroSessions);
      final session = PomodoroSession(
        id: const Uuid().v4(),
        questId: questId,
        heroId: heroId ?? '',
        workDurationMinutes: workDuration,
        endedAt: DateTime.now(), // Added needed field
        startedAt: DateTime.now().subtract(
          Duration(minutes: workDuration),
        ), // Added needed field
        wasCompleted: true,
        xpAwarded: 5, // small bonus XP per pomodoro
      );
      await box.put(session.id, session);
    } catch (e) {
      debugPrint('PomodoroViewModel save error: $e');
    }
  }

  void updateConfig({
    int? work,
    int? shortBreak,
    int? longBreak,
    int? sessions,
  }) {
    if (_isRunning) return;
    if (work != null) workDuration = work;
    if (shortBreak != null) shortBreakDuration = shortBreak;
    if (longBreak != null) longBreakDuration = longBreak;
    if (sessions != null) sessionsBeforeLongBreak = sessions;
    _totalSecondsLeft = _phaseDurationSeconds;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
