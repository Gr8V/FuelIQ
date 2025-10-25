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
  
}

