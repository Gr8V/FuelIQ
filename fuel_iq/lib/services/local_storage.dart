import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocalStorageService {
  static const String _dailyDataKey = 'daily_data';

  /// Save daily data totals AND optionally a food entry
  static Future<void> saveDailyData({
    required String date, // e.g. "2025-10-21"
    double? calories,
    double? protein,
    double? carbs,
    double? fats,
    double? water,
    double? weight,
    Map<String, dynamic>? foodEntry, // optional new food
  }) async {
    final prefs = await SharedPreferences.getInstance();

    // Get existing data
    final existingData = prefs.getString(_dailyDataKey);
    Map<String, dynamic> allData =
        existingData != null ? jsonDecode(existingData) : {};

    // Initialize the day's data if not present
    Map<String, dynamic> dayData = allData[date] ?? {
      'calories': 0.0,
      'protein': 0.0,
      'carbs': 0.0,
      'fats': 0.0,
      'water': 0.0,
      'weight': 0.0,
      'foods': [], // list of foods eaten
    };

    // Update totals if provided
    if (calories != null) dayData['calories'] = calories;
    if (protein != null) dayData['protein'] = protein;
    if (carbs != null) dayData['carbs'] = carbs;
    if (fats != null) dayData['fats'] = fats;
    if (water != null) dayData['water'] = water;
    if (weight != null) dayData['weight'] = weight;

    // Add new food if provided
    if (foodEntry != null) {
      List<dynamic> foods = dayData['foods'] ?? [];
      foods.add(foodEntry);
      dayData['foods'] = foods;
    }

    // Save back
    allData[date] = dayData;
    await prefs.setString(_dailyDataKey, jsonEncode(allData));
  }

  /// Get data for a specific date
  static Future<Map<String, dynamic>?> getDailyData(String date) async {
    final prefs = await SharedPreferences.getInstance();
    final existingData = prefs.getString(_dailyDataKey);
    if (existingData == null) return null;

    final allData = jsonDecode(existingData);
    return allData[date];
  }

  /// Get all stored data
  static Future<Map<String, dynamic>> getAllData() async {
    final prefs = await SharedPreferences.getInstance();
    final existingData = prefs.getString(_dailyDataKey);
    return existingData != null ? jsonDecode(existingData) : {};
  }

  /// Clear all stored data
  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_dailyDataKey);
  }
}
