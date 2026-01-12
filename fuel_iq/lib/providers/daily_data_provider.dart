import 'package:flutter/material.dart';
import 'package:fuel_iq/data/local/daily_data_storage.dart';
import '../models/daily_data.dart';
import '../models/food_entry.dart';
import '../utils/date_utils.dart';
import '../services/auto_fill_service.dart';

class DailyDataProvider extends ChangeNotifier {
  final Map<String, DailyDataModel> _cache = {};
  bool _initialized = false;

  DailyDataProvider() {
    initialize();
  }

  Future<void> initialize() async {
    if (_initialized) return;

    await _doInitialize();
    _initialized = true;
  }

  Future<void> reinitialize() async {
    _cache.clear();
    _initialized = false;

    await _doInitialize();
    _initialized = true;

    notifyListeners();
  }

  Future<void> _doInitialize() async {
    await AutoFillService.autoFillMissingDays();
    await loadDailyData(DateUtilsExt.today());
  }

  DailyDataModel? getDailyData(String date) => _cache[DateUtilsExt.normalize(date)];

  double? getWeight(String date) =>
      _cache[DateUtilsExt.normalize(date)]?.weight;

  Future<void> loadDailyData(String date) async {
    final normalized = DateUtilsExt.normalize(date);
    final json = DailyDataStorage().loadDailyData(normalized);

    _cache[normalized] = json ?? DailyDataModel();


    notifyListeners();
  }

  Future<void> updateDailyData(String date, DailyDataModel data) async {
    final normalized = DateUtilsExt.normalize(date);
    await DailyDataStorage().saveDailyData(
      date: normalized,
      data: data.toJson(),
    );
    await loadDailyData(normalized);
  }

  Future<void> updateSingleTarget(
      String date, String targetName, double value) async {
    final normalized = DateUtilsExt.normalize(date);

    final day = DailyDataStorage().loadDailyData(normalized);
    final data = day ?? DailyDataModel();

    switch (targetName) {
      case 'calorieTarget':
        data.calorieTarget = value;
        break;
      case 'proteinTarget':
        data.proteinTarget = value;
        break;
      case 'carbsTarget':
        data.carbsTarget = value;
        break;
      case 'fatsTarget':
        data.fatsTarget = value;
        break;
      case 'waterTarget':
        data.waterTarget = value;
        break;
    }

    await updateDailyData(normalized, data);
  }

  Future<void> addFood(String date, FoodEntry entry) async {
    final normalized = DateUtilsExt.normalize(date);

    final day = DailyDataStorage().loadDailyData(normalized);
    final data = day ?? DailyDataModel();

    data.foods.add(entry);

    data.calories += entry.calories;
    data.protein += entry.protein;
    data.carbs += entry.carbs;
    data.fats += entry.fats;

    await updateDailyData(normalized, data);
  }

  Future<void> deleteFood(String date, String foodId) async {
    final normalized = DateUtilsExt.normalize(date);

    final day = DailyDataStorage().loadDailyData(normalized);
    final data = day ?? DailyDataModel();

    // Find the entry
    final entryIndex = data.foods.indexWhere((f) => f.id == foodId);

    if (entryIndex == -1) {
      // Food not found — early return
      return;
    }

    final entry = data.foods[entryIndex];

    // Remove the entry
    data.foods.removeAt(entryIndex);

    // Subtract its macros
    data.calories -= entry.calories;
    data.protein -= entry.protein;
    data.carbs -= entry.carbs;
    data.fats -= entry.fats;

    // Save back
    await updateDailyData(normalized, data);
  }


  Future<void> clearAll() async {
    await DailyDataStorage().clearAllData();
    _cache.clear();
    notifyListeners();
  }
}
