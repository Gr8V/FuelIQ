import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocalStorageService {
  static const String _dailyDataKey = 'daily_data';
  static const String _themeModeKey = 'theme_data';

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

  static Future<void> deleteFood({
  required String date,
  required String foodName,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final existingData = prefs.getString(_dailyDataKey);
    if (existingData == null) return;

    final Map<String, dynamic> allData = jsonDecode(existingData);
    if (allData[date] == null) return;

    final Map<String, dynamic> dayData = Map<String, dynamic>.from(allData[date]);
    final List<dynamic> foods = List.from(dayData['foods'] ?? []);

    // Find the food to delete
    int deleteIndex = foods.indexWhere((food) {
      final storedName = (food['name'] ?? food['foodName'] ?? '').toString().trim().toLowerCase();
      return storedName == foodName.trim().toLowerCase();
    });

    if (deleteIndex == -1) return; // not found

    // --- Subtract deleted food’s macros ---
    final food = Map<String, dynamic>.from(foods[deleteIndex]);
    double toDouble(v) =>
        v is num ? v.toDouble() : double.tryParse(v.toString()) ?? 0.0;

    dayData['calories'] = (toDouble(dayData['calories']) - toDouble(food['calories'])).clamp(0.0, double.infinity);
    dayData['protein']  = (toDouble(dayData['protein'])  - toDouble(food['protein'])).clamp(0.0, double.infinity);
    dayData['carbs']    = (toDouble(dayData['carbs'])    - toDouble(food['carbs'])).clamp(0.0, double.infinity);
    dayData['fats']     = (toDouble(dayData['fats'])     - toDouble(food['fats'])).clamp(0.0, double.infinity);

    // --- Remove the food ---
    foods.removeAt(deleteIndex);
    dayData['foods'] = foods;

    // Save updated day data
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

  /// Save theme data
  static Future<void> saveThemeData({required ThemeMode currentTheme}) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_themeModeKey, currentTheme.toString());

  }

  ///Get prev theme data
  static Future<ThemeMode?> getThemeData() async {
    final prefs = await SharedPreferences.getInstance();
    final themeString = prefs.getString(_themeModeKey);
    if (themeString == null) return null;

    switch (themeString) {
      case 'ThemeMode.light':
        return ThemeMode.light;
      case 'ThemeMode.dark':
        return ThemeMode.dark;
      case 'ThemeMode.system':
        return ThemeMode.system;
      default:
        return null;
    }
  }
}
