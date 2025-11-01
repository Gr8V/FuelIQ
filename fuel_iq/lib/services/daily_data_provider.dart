import 'package:flutter/material.dart';
import 'local_storage.dart';

class DailyDataProvider extends ChangeNotifier {
  // Each date stores its own data safely
  final Map<String, Map<String, dynamic>> _dataByDate = {};

  /// Helper: Normalize date format to dd-MM-yyyy with leading zeros
  String _normalizeDate(String date) {
    // Split the date
    final parts = date.split('-');
    if (parts.length != 3) return date; // Invalid format, return as-is
    
    // Pad day and month with leading zeros
    final day = parts[0].padLeft(2, '0');
    final month = parts[1].padLeft(2, '0');
    final year = parts[2];
    
    return '$day-$month-$year';
  }

  Map<String, dynamic>? getDailyData(String date) {
    final normalizedDate = _normalizeDate(date);
    return _dataByDate[normalizedDate];
  }

  /// Load data for a specific date
  Future<void> loadDailyData(String date) async {
    final normalizedDate = _normalizeDate(date);
    final data = await LocalStorageService.getDailyData(normalizedDate);

    // Fallback if null
    _dataByDate[normalizedDate] = data ?? {
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
    final normalizedDate = _normalizeDate(date);
    
    await LocalStorageService.saveDailyData(
      date: normalizedDate,
      calories: newData['calories'],
      protein: newData['protein'],
      carbs: newData['carbs'],
      fats: newData['fats'],
      water: newData['water'],
      weight: newData['weight'],
    );

    final data = await LocalStorageService.getDailyData(normalizedDate);

    // Same fallback here
    _dataByDate[normalizedDate] = data ?? {
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
    final normalizedDate = _normalizeDate(date);
    
    await LocalStorageService.saveDailyData(
      date: normalizedDate,
      foodEntry: foodEntry,
    );

    final data = await LocalStorageService.getDailyData(normalizedDate);

    // Same fallback here too
    _dataByDate[normalizedDate] = data ?? {
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
    final normalizedDate = _normalizeDate(date);
    
    await LocalStorageService.deleteFood(date: normalizedDate, foodName: foodName);

    // 🔧 reload and update the specific date's data in _dataByDate
    final updatedData = await LocalStorageService.getDailyData(normalizedDate);

    _dataByDate[normalizedDate] = updatedData ?? {
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

  /// Get weight for a specific date
  double? getWeight(String date) {
    final normalizedDate = _normalizeDate(date);
    return _dataByDate[normalizedDate]?['weight'];
  }

  /// Get all loaded weights (all dates currently in memory)
  Map<String, double> getAllLoadedWeights() {
    final Map<String, double> weights = {};
    
    _dataByDate.forEach((date, data) {
      final weight = data['weight'];
      if (weight != null && weight != 0.0) {
        weights[date] = weight as double;
      }
    });
    
    return weights;
  }
}