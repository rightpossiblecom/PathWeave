import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../../core/constants/puzzle_levels.dart';
import '../../core/services/storage_service.dart';

class GameViewModel extends ChangeNotifier {
  final StorageService _storage;
  late PuzzleLevel _level;

  GameViewModel(this._storage, PuzzleLevel initialLevel) {
    loadLevel(initialLevel);
  }

  final List<GridCell> _path = [];
  int _elapsedSeconds = 0;
  int _hintsUsed = 0;
  bool _isSolved = false;
  String? _statusNote;
  Timer? _timer;

  PuzzleLevel get level => _level;
  List<GridCell> get path => List.unmodifiable(_path);
  int get elapsedSeconds => _elapsedSeconds;
  int get hintsUsed => _hintsUsed;
  bool get isSolved => _isSolved;
  String? get statusNote => _statusNote;

  int get remainingTiles => _level.openCount - _path.length;

  double get progress =>
      _level.openCount == 0 ? 1.0 : _path.length / _level.openCount;

  int get earnedStars {
    if (!_isSolved) return 0;
    if (_hintsUsed == 0 && _elapsedSeconds <= _level.openCount * 3) {
      return 3;
    }
    if (_hintsUsed <= 2) {
      return 2;
    }
    return 1;
  }

  void loadLevel(PuzzleLevel nextLevel) {
    _timer?.cancel();
    _level = nextLevel;
    _path
      ..clear()
      ..add(nextLevel.startCell);
    _elapsedSeconds = 0;
    _hintsUsed = 0;
    _isSolved = false;
    _statusNote = null;
    _startTimer();
    notifyListeners();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!_isSolved) {
        _elapsedSeconds++;
        notifyListeners();
      }
    });
  }

  bool isVisited(GridCell cell) => _path.contains(cell);

  int stepIndexOf(GridCell cell) => _path.indexOf(cell);

  void handleCellInput(GridCell cell, {required bool haptics}) {
    if (_isSolved) return;
    if (cell.row < 0 ||
        cell.row >= _level.rows ||
        cell.col < 0 ||
        cell.col >= _level.cols) {
      return;
    }
    if (_level.isBlocked(cell)) return;

    final existingIndex = _path.indexOf(cell);
    if (existingIndex != -1) {
      // Dragging or tapping back onto an earlier step unwinds smoothly
      if (existingIndex < _path.length - 1) {
        _path.removeRange(existingIndex + 1, _path.length);
        _statusNote = null;
        if (haptics) HapticFeedback.selectionClick();
        notifyListeners();
      }
      return;
    }

    final head = _path.last;
    if (!head.isAdjacentTo(cell)) return;

    // Checkpoint rule: if this cell is the checkpoint, step number must match
    final nextStepNumber = _path.length + 1;
    if (_level.checkpointCell != null && _level.checkpointStep != null) {
      if (cell == _level.checkpointCell &&
          nextStepNumber != _level.checkpointStep) {
        _statusNote =
            'Reach the #${_level.checkpointStep} anchor on step ${_level.checkpointStep} (currently step $nextStepNumber).';
        if (haptics) HapticFeedback.lightImpact();
        notifyListeners();
        return;
      }
      if (nextStepNumber == _level.checkpointStep &&
          cell != _level.checkpointCell) {
        _statusNote =
            'Step ${_level.checkpointStep} must pass through the #${_level.checkpointStep} anchor tile.';
        if (haptics) HapticFeedback.lightImpact();
        notifyListeners();
        return;
      }
    }

    _path.add(cell);
    _statusNote = null;
    _storage.incrementMovesPlayed(1);
    if (haptics) HapticFeedback.selectionClick();
    _checkSolved(haptics: haptics);
    notifyListeners();
  }

  void undoStep({required bool haptics}) {
    if (_isSolved || _path.length <= 1) return;
    _path.removeLast();
    _statusNote = null;
    if (haptics) HapticFeedback.selectionClick();
    notifyListeners();
  }

  void restartLevel({required bool haptics}) {
    _path
      ..clear()
      ..add(_level.startCell);
    _isSolved = false;
    _statusNote = null;
    if (haptics) HapticFeedback.mediumImpact();
    notifyListeners();
  }

  void useHint({required bool haptics}) {
    if (_isSolved) return;
    // Find longest matching prefix with canonical solution
    var matchLen = 0;
    while (matchLen < _path.length &&
        matchLen < _level.solution.length &&
        _path[matchLen] == _level.solution[matchLen]) {
      matchLen++;
    }

    if (matchLen < _path.length) {
      // Trim diverged tail back to valid solution prefix and add 1 true step
      _path.removeRange(matchLen, _path.length);
    }

    final targetSteps = (matchLen + 2).clamp(1, _level.solution.length);
    while (_path.length < targetSteps) {
      _path.add(_level.solution[_path.length]);
    }

    _hintsUsed++;
    _statusNote = 'Guided onto the true weave.';
    if (haptics) HapticFeedback.mediumImpact();
    _checkSolved(haptics: haptics);
    notifyListeners();
  }

  void _checkSolved({required bool haptics}) {
    if (_path.length == _level.openCount) {
      _isSolved = true;
      _timer?.cancel();
      if (haptics) HapticFeedback.heavyImpact();
      if (_level.isDaily && _level.dailyDateKey != null) {
        _storage.recordDailyCompletion(_level.dailyDateKey!);
      } else {
        _storage.recordLevelCompletion(
          levelId: _level.id,
          stars: earnedStars,
          seconds: _elapsedSeconds,
          hintsUsed: _hintsUsed,
        );
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
