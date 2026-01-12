import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';

class SettingsStorage {
  final Box _box = Hive.box('settingsBox');

  //ONBOARDING SECTION
  bool hasCompletedOnboarding() {
    String statusStr =  _box.get('has_completed_onboarding', defaultValue: 'false');
    if (statusStr == 'true') {
      return true;
    }
    else{
      return false;
    }
  }
  Future<void> completeOnboarding() async {
    await _box.put('has_completed_onboarding', 'true');
  }

  // THEME SECTION
  // Read
  ThemeMode getThemeMode() {
    final themeStr = _box.get('theme', defaultValue: 'system');
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