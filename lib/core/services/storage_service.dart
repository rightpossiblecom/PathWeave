import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../constants/app_constants.dart';

class StorageService {
  Box<String> get _dataBox => Hive.box<String>(AppConstants.appDataBox);
  Box<String> get _settingsBox => Hive.box<String>(AppConstants.settingsBox);

  String getThemeMode() {
    return _settingsBox.get('theme_mode') ?? 'system';
  }

  Future<void> setThemeMode(String mode) async {
    await _settingsBox.put('theme_mode', mode);
  }

  bool getHapticsEnabled() {
    return (_settingsBox.get('haptics_enabled') ?? 'true') == 'true';
  }

  Future<void> setHapticsEnabled(bool enabled) async {
    await _settingsBox.put('haptics_enabled', enabled ? 'true' : 'false');
  }

  bool getShowStepNumbers() {
    return (_settingsBox.get('show_step_numbers') ?? 'false') == 'true';
  }

  Future<void> setShowStepNumbers(bool show) async {
    await _settingsBox.put('show_step_numbers', show ? 'true' : 'false');
  }

  Map<int, Map<String, dynamic>> getCompletedLevels() {
    final raw = _dataBox.get('completed_levels');
    if (raw == null || raw.isEmpty) return {};
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      final result = <int, Map<String, dynamic>>{};
      decoded.forEach((key, value) {
        final id = int.tryParse(key);
        if (id != null && value is Map<String, dynamic>) {
          result[id] = value;
        }
      });
      return result;
    } catch (_) {
      return {};
    }
  }

  Future<void> recordLevelCompletion({
    required int levelId,
    required int stars,
    required int seconds,
    required int hintsUsed,
  }) async {
    final current = getCompletedLevels();
    final prev = current[levelId];
    final bestStars = prev != null && (prev['stars'] as int? ?? 0) > stars
        ? (prev['stars'] as int)
        : stars;
    final bestSeconds = prev != null &&
            (prev['bestSeconds'] as int? ?? 999999) < seconds
        ? (prev['bestSeconds'] as int)
        : seconds;

    current[levelId] = {
      'stars': bestStars,
      'bestSeconds': bestSeconds,
      'hintsUsed': hintsUsed,
      'completedAt': DateTime.now().toIso8601String(),
    };

    final encoded = <String, dynamic>{};
    current.forEach((k, v) => encoded[k.toString()] = v);
    await _dataBox.put('completed_levels', jsonEncode(encoded));
  }

  Set<String> getCompletedDailyDates() {
    final raw = _dataBox.get('daily_completed');
    if (raw == null || raw.isEmpty) return {};
    try {
      final list = (jsonDecode(raw) as List<dynamic>).cast<String>();
      return list.toSet();
    } catch (_) {
      return {};
    }
  }

  Future<void> recordDailyCompletion(String dateKey) async {
    final dates = getCompletedDailyDates()..add(dateKey);
    await _dataBox.put('daily_completed', jsonEncode(dates.toList()..sort()));
  }

  int getTotalMovesPlayed() {
    return int.tryParse(_dataBox.get('total_moves') ?? '0') ?? 0;
  }

  Future<void> incrementMovesPlayed([int delta = 1]) async {
    final next = getTotalMovesPlayed() + delta;
    await _dataBox.put('total_moves', next.toString());
  }

  Future<void> clearAllProgress() async {
    await _dataBox.clear();
  }
}
