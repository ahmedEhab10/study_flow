import 'dart:async';
import 'package:flutter/foundation.dart';

/// Singleton timer service that persists across navigation.
/// The timer keeps running even when the StudySessionScreen is not visible.
/// It only stops when [pause] or [stop] is called explicitly.
class StudyTimerService extends ChangeNotifier {
  // ── Singleton ────────────────────────────────────────────────────────────
  static final StudyTimerService _instance = StudyTimerService._internal();
  factory StudyTimerService() => _instance;
  StudyTimerService._internal();

  // ── State ─────────────────────────────────────────────────────────────────
  Timer? _ticker;
  int _elapsedSeconds = 0;
  bool _isRunning = false;
  String? _currentSubject;

  // ── Goal (default: 2 hours) ───────────────────────────────────────────────
  static const int defaultGoalSeconds = 2 * 3600;
  int _goalSeconds = defaultGoalSeconds;

  // ── Getters ───────────────────────────────────────────────────────────────
  int get elapsedSeconds => _elapsedSeconds;
  bool get isRunning => _isRunning;
  bool get hasActiveSession => _currentSubject != null;
  String? get currentSubject => _currentSubject;
  int get goalSeconds => _goalSeconds;
  double get progressFraction =>
      (_elapsedSeconds / _goalSeconds).clamp(0.0, 1.0);

  String get formattedTime {
    final h = _elapsedSeconds ~/ 3600;
    final m = (_elapsedSeconds % 3600) ~/ 60;
    final s = _elapsedSeconds % 60;
    return '${h.toString().padLeft(2, '0')}:'
        '${m.toString().padLeft(2, '0')}:'
        '${s.toString().padLeft(2, '0')}';
  }

  String get formattedElapsed {
    if (_elapsedSeconds < 60) return '${_elapsedSeconds}s';
    if (_elapsedSeconds < 3600) return '${_elapsedSeconds ~/ 60}m';
    final h = _elapsedSeconds ~/ 3600;
    final m = (_elapsedSeconds % 3600) ~/ 60;
    return m > 0 ? '${h}h ${m}m' : '${h}h';
  }

  String get formattedGoal {
    final h = _goalSeconds ~/ 3600;
    final m = (_goalSeconds % 3600) ~/ 60;
    return m > 0 ? '${h}h ${m}m Goal' : '${h}h Study Goal';
  }

  // ── Control ───────────────────────────────────────────────────────────────

  /// Starts a fresh session for [subjectName].
  void start({required String subjectName, int goalSeconds = defaultGoalSeconds}) {
    _currentSubject = subjectName;
    _elapsedSeconds = 0;
    _goalSeconds = goalSeconds;
    _isRunning = true;
    _startTicking();
    notifyListeners();
  }

  void pause() {
    if (!_isRunning) return;
    _isRunning = false;
    _ticker?.cancel();
    notifyListeners();
  }

  void resume() {
    if (_isRunning) return;
    _isRunning = true;
    _startTicking();
    notifyListeners();
  }

  /// Updates the goal duration mid-session without resetting the timer.
  void setGoal(int seconds) {
    _goalSeconds = seconds;
    notifyListeners();
  }

  /// Stops and resets the session entirely.
  void stop() {
    _ticker?.cancel();
    _isRunning = false;
    _elapsedSeconds = 0;
    _currentSubject = null;
    notifyListeners();
  }

  // ── Private ───────────────────────────────────────────────────────────────
  void _startTicking() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      _elapsedSeconds++;
      notifyListeners();
    });
  }
}
