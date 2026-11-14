import 'package:flutter/material.dart';
import '../../core/services/storage_service.dart';

class SettingsViewModel extends ChangeNotifier {
  final StorageService _storage;

  SettingsViewModel(this._storage) {
    _load();
  }

  ThemeMode _themeMode = ThemeMode.system;
  bool _hapticsEnabled = true;
  bool _showStepNumbers = false;

  ThemeMode get themeMode => _themeMode;
  bool get hapticsEnabled => _hapticsEnabled;
  bool get showStepNumbers => _showStepNumbers;

  void _load() {
    final mode = _storage.getThemeMode();
    if (mode == 'light') {
      _themeMode = ThemeMode.light;
    } else if (mode == 'dark') {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.system;
    }
    _hapticsEnabled = _storage.getHapticsEnabled();
    _showStepNumbers = _storage.getShowStepNumbers();
  }

  Future<void> updateThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    final key = mode == ThemeMode.light
        ? 'light'
        : mode == ThemeMode.dark
            ? 'dark'
            : 'system';
    await _storage.setThemeMode(key);
    notifyListeners();
  }

  Future<void> toggleHaptics(bool value) async {
    _hapticsEnabled = value;
    await _storage.setHapticsEnabled(value);
    notifyListeners();
  }

  Future<void> toggleShowStepNumbers(bool value) async {
    _showStepNumbers = value;
    await _storage.setShowStepNumbers(value);
    notifyListeners();
  }
}
