import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';

class SettingsStorage {
  final Box _box = Hive.box('settingsBox');

  // Read
  ThemeMode getThemeMode() {
    final themeStr = _box.get('theme', defaultValue: 'light');
    switch (themeStr) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.system;
    }
  }

  // Write
  Future<void> saveThemeMode(ThemeMode theme) async {
    await _box.put('theme', theme.toString());
  }

}