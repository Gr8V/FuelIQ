import 'package:flutter/material.dart';
import '../models/daily_data.dart';
import '../models/food_entry.dart';
import '../services/local_storage.dart';
import '../utils/date_utils.dart';
import '../services/auto_fill_service.dart';

class DailyDataProvider extends ChangeNotifier {
  final Map<String, DailyDataModel> _cache = {};

  Future<void> initialize() async {
    await AutoFillService.autoFillMissingDays();
    await loadDailyData(DateUtilsExt.today());
  }

  DailyDataModel? getDailyData(String date) => _cache[DateUtilsExt.normalize(date)];

  double? getWeight(String date) =>
      _cache[DateUtilsExt.normalize(date)]?.weight;

  Future<void> loadDailyData(String date) async {
    final normalized = DateUtilsExt.normalize(date);
    final json = await LocalStorageService.loadDailyData(normalized);

    _cache[normalized] = json ?? DailyDataModel();


    notifyListeners();
  }

  Future<void> updateDailyData(String date, DailyDataModel data) async {
    final normalized = DateUtilsExt.normalize(date);
    await LocalStorageService.saveDailyData(
      date: normalized,
      data: data.toJson(),
    );
    await loadDailyData(normalized);
  }

  Future<void> updateSingleTarget(
      String date, String targetName, double value) async {
    final normalized = DateUtilsExt.normalize(date);

    final day = await LocalStorageService.loadDailyData(normalized);
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

    final day = await LocalStorageService.loadDailyData(normalized);
    final data = day ?? DailyDataModel();

    data.foods.add(entry);

    data.calories += entry.calories;
    data.protein += entry.protein;
    data.carbs += entry.carbs;
    data.fats += entry.fats;

    await updateDailyData(normalized, data);
  }

  Future<void> deleteFood(String date, String foodName) async {
    final normalized = DateUtilsExt.normalize(date);

    final day = await LocalStorageService.loadDailyData(normalized);
    final data = day ?? DailyDataModel();

    final entry = data.foods.firstWhere(
      (f) => f.name == foodName,
      orElse: () => FoodEntry(
        name: "",
        calories: 0,
        protein: 0,
        carbs: 0,
        fats: 0,
        quantity: 0,
        time: "No Time"
      ),
    );

    data.foods.removeWhere((f) => f.name == foodName);

    data.calories -= entry.calories;
    data.protein -= entry.protein;
    data.carbs -= entry.carbs;
    data.fats -= entry.fats;

    await updateDailyData(normalized, data);
  }

  Future<void> clearAll() async {
    await LocalStorageService.clearAllData();
    _cache.clear();
    notifyListeners();
  }
}
