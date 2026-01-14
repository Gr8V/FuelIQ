import 'package:flutter/material.dart';
import 'package:fuel_iq/data/local/daily_data_storage.dart';
import '../models/daily_data_model.dart';
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
    final json = DailyDataStorage.getOrCreateDay(normalized);
    _cache[normalized] = json;
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

    final day = DailyDataStorage.getOrCreateDay(normalized);
    final data = day;

    switch (targetName) {
      case 'calorieTarget':
        data.nutrition.targets.calories = value;
        break;
      case 'proteinTarget':
        data.nutrition.targets.protein = value;
        break;
      case 'carbsTarget':
        data.nutrition.targets.calories = value;
        break;
      case 'fatsTarget':
        data.nutrition.targets.fats = value;
        break;
      case 'waterTarget':
        data.nutrition.targets.water = value;
        break;
    }

    await updateDailyData(normalized, data);
  }

  Future<void> addFood(String date, FoodEntry entry) async {
    final normalized = DateUtilsExt.normalize(date);

    final day = DailyDataStorage.getOrCreateDay(normalized);
    final data = day;

    data.nutrition.foods.add(entry);

    data.nutrition.calories += entry.calories;
    data.nutrition.protein += entry.protein;
    data.nutrition.carbs += entry.carbs;
    data.nutrition.fats += entry.fats;

    await updateDailyData(normalized, data);
  }

  Future<void> deleteFood(String date, String foodId) async {
    final normalized = DateUtilsExt.normalize(date);

    final day = DailyDataStorage.getOrCreateDay(normalized);
    final data = day;

    // Find the entry
    final entryIndex = data.nutrition.foods.indexWhere((f) => f.id == foodId);

    if (entryIndex == -1) {
      // Food not found — early return
      return;
    }

    final entry = data.nutrition.foods[entryIndex];

    // Remove the entry
    data.nutrition.foods.removeAt(entryIndex);

    // Subtract its macros
    data.nutrition.calories -= entry.calories;
    data.nutrition.protein -= entry.protein;
    data.nutrition.carbs -= entry.carbs;
    data.nutrition.fats -= entry.fats;

    // Save back
    await updateDailyData(normalized, data);
  }


  Future<void> clearAll() async {
    await DailyDataStorage().clearAllData();
    _cache.clear();
    notifyListeners();
  }
}
