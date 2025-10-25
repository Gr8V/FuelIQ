import 'package:flutter/material.dart';
import 'local_storage.dart';

class DailyDataProvider extends ChangeNotifier {
  Map<String, dynamic>? _dailyData;

  Map<String, dynamic>? get dailyData => _dailyData;

  /// Load data for today
  Future<void> loadDailyData(String date) async {
    _dailyData = await LocalStorageService.getDailyData(date);
    notifyListeners();
  }

  /// Update today's totals (calories, protein, etc.)
  Future<void> updateDailyData(String date, Map<String, dynamic> newData) async {
    await LocalStorageService.saveDailyData(
      date: date,
      calories: newData['calories'],
      protein: newData['protein'],
      carbs: newData['carbs'],
      fats: newData['fats'],
      water: newData['water'],
      weight: newData['weight'],
    );

    _dailyData = await LocalStorageService.getDailyData(date);
    notifyListeners();
  }

  /// Add a single food entry to today's foods list
  Future<void> addFood(String date, Map<String, dynamic> foodEntry) async {
    await LocalStorageService.saveDailyData(
      date: date,
      foodEntry: foodEntry,
    );

    _dailyData = await LocalStorageService.getDailyData(date);
    notifyListeners();
  }

  //-------------------- THEME FUNCTIONS --------------------

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  /// Load saved theme
  Future<void> loadTheme() async {
    final savedTheme = await LocalStorageService.getThemeData();
    _themeMode = savedTheme ?? ThemeMode.system;
    notifyListeners();
  }

  /// Set and save theme
  Future<void> setTheme(ThemeMode mode) async {
    _themeMode = mode;
    await LocalStorageService.saveThemeData(currentTheme: mode);
    notifyListeners();
  }

  /// Toggle between light and dark mode
  Future<void> toggleTheme() async {
    if (_themeMode == ThemeMode.light) {
      await setTheme(ThemeMode.dark);
    } else {
      await setTheme(ThemeMode.light);
    }
  }

}

