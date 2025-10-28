import 'package:flutter/material.dart';
import 'local_storage.dart';

class DailyDataProvider extends ChangeNotifier {
  // Each date stores its own data safely
  final Map<String, Map<String, dynamic>> _dataByDate = {};

  Map<String, dynamic>? getDailyData(String date) => _dataByDate[date];

  /// Load data for a specific date
  Future<void> loadDailyData(String date) async {
    final data = await LocalStorageService.getDailyData(date);

    // Fallback if null
    _dataByDate[date] = data ?? {
      'calories': 0.0,
      'protein': 0.0,
      'carbs': 0.0,
      'fats': 0.0,
      'water': 0.0,
      'weight': 0.0,
      'foods': [],
    };

    notifyListeners();
  }

  /// Update data for a specific date
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

    final data = await LocalStorageService.getDailyData(date);

    // Same fallback here
    _dataByDate[date] = data ?? {
      'calories': 0.0,
      'protein': 0.0,
      'carbs': 0.0,
      'fats': 0.0,
      'water': 0.0,
      'weight': 0.0,
      'foods': [],
    };

    notifyListeners();
  }

  /// Add a single food entry for a specific date
  Future<void> addFood(String date, Map<String, dynamic> foodEntry) async {
    await LocalStorageService.saveDailyData(
      date: date,
      foodEntry: foodEntry,
    );

    final data = await LocalStorageService.getDailyData(date);

    // Same fallback here too
    _dataByDate[date] = data ?? {
      'calories': 0.0,
      'protein': 0.0,
      'carbs': 0.0,
      'fats': 0.0,
      'water': 0.0,
      'weight': 0.0,
      'foods': [],
    };

    notifyListeners();
  }

  //DELETE a food entry by name for a given date
  Future<void> deleteFood(String date, String foodName) async {
    await LocalStorageService.deleteFood(date: date, foodName: foodName);

    // 🔧 reload and update the specific date's data in _dataByDate
    final updatedData = await LocalStorageService.getDailyData(date);

    _dataByDate[date] = updatedData ?? {
      'calories': 0.0,
      'protein': 0.0,
      'carbs': 0.0,
      'fats': 0.0,
      'water': 0.0,
      'weight': 0.0,
      'foods': [],
    };

    notifyListeners(); // 🔔 refresh the UI
  }



}
