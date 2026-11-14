import 'package:flutter/foundation.dart';
import '../../core/constants/puzzle_levels.dart';
import '../../core/services/storage_service.dart';

class HomeViewModel extends ChangeNotifier {
  final StorageService _storage;

  HomeViewModel(this._storage) {
    refresh();
  }

  Map<int, Map<String, dynamic>> _completed = {};
  Set<String> _dailyDates = {};
  int _totalMoves = 0;
  String _selectedChapter = PuzzleLevels.chapters.first;

  Map<int, Map<String, dynamic>> get completed => _completed;
  Set<String> get dailyDates => _dailyDates;
  int get totalMoves => _totalMoves;
  String get selectedChapter => _selectedChapter;

  void selectChapter(String chapter) {
    _selectedChapter = chapter;
    notifyListeners();
  }

  void refresh() {
    _completed = _storage.getCompletedLevels();
    _dailyDates = _storage.getCompletedDailyDates();
    _totalMoves = _storage.getTotalMovesPlayed();
    notifyListeners();
  }

  bool isCompleted(int levelId) => _completed.containsKey(levelId);

  int starsForLevel(int levelId) {
    return (_completed[levelId]?['stars'] as int?) ?? 0;
  }

  int? bestSecondsForLevel(int levelId) {
    return _completed[levelId]?['bestSeconds'] as int?;
  }

  bool isUnlocked(int levelId) {
    if (levelId <= 1) return true;
    return isCompleted(levelId - 1) || isCompleted(levelId);
  }

  int get nextPlayableLevelId {
    for (final level in PuzzleLevels.campaign) {
      if (!isCompleted(level.id)) return level.id;
    }
    return PuzzleLevels.campaign.last.id;
  }

  int get totalStarsEarned {
    var sum = 0;
    for (final entry in _completed.values) {
      sum += (entry['stars'] as int?) ?? 0;
    }
    return sum;
  }

  int get maxPossibleStars => PuzzleLevels.campaign.length * 3;

  bool get isTodayDailyDone =>
      _dailyDates.contains(PuzzleLevels.todayKey());

  int get dailyStreak {
    var streak = 0;
    var cursor = DateTime.now();
    if (!_dailyDates.contains(PuzzleLevels.todayKey(cursor))) {
      cursor = cursor.subtract(const Duration(days: 1));
    }
    while (_dailyDates.contains(PuzzleLevels.todayKey(cursor))) {
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
  }

  List<PuzzleLevel> get levelsForSelectedChapter {
    return PuzzleLevels.campaign
        .where((l) => l.chapter == _selectedChapter)
        .toList();
  }

  Future<void> resetAllProgress() async {
    await _storage.clearAllProgress();
    refresh();
  }
}
