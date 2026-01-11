import 'package:flutter/material.dart';
import 'package:fuel_iq/data/local/settings_storage.dart';

class ThemeProvider extends ChangeNotifier {
  final SettingsStorage _storage;

  ThemeMode themeMode = ThemeMode.system;

  ThemeProvider(this._storage) {
    _loadTheme(); // safe in constructor (no notify yet)
  }

  void _loadTheme() {
    themeMode = _storage.getThemeMode();
  }

  void setTheme(ThemeMode mode) {
    if (themeMode == mode) return;

    themeMode = mode;
    _storage.saveThemeMode(mode);
    notifyListeners();
  }
}