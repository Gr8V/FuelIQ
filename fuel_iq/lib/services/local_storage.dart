// ignore_for_file: unnecessary_string_escapes

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Handles all local storage operations for the fitness tracking app
/// Uses SharedPreferences to persist data across app sessions
class LocalStorageService {
  // Storage keys
  static const String _dailyDataKey = 'daily_data';
  static const String _themeModeKey = 'theme_data';
  static const String _savedFoodsKey = 'saved_foods';

  static Future<void> saveFood({
    required String foodName,
    required String time,
    required double quantity,
    required double calories,
    required double protein,
    required double carbs,
    required double fats,
  }) async   {
    final prefs = await SharedPreferences.getInstance();
    final existingFoods = prefs.getString(_savedFoodsKey);
    Map<String, dynamic> allData =  existingFoods != null ? jsonDecode(existingFoods) : {};

    Map<String, dynamic> foodInfo = {
      'time':time,
      'quantity':quantity,
      'calories':calories,
      'protein':protein,
      'carbs':carbs,
      'fats':fats
      };
    allData[foodName] = foodInfo;
    await prefs.setString(_savedFoodsKey, jsonEncode(allData));
  }
  
  static Future<Map<String, dynamic>> getSavedFoods() async {
    final prefs = await SharedPreferences.getInstance();
    final existingFoods = prefs.getString(_savedFoodsKey);

    if (existingFoods == null) {
      return {};   // return empty map if nothing saved yet
    }

    return jsonDecode(existingFoods) as Map<String, dynamic>;
  }
  static Future<void> saveAllFoods(Map<String, dynamic> foods) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_savedFoodsKey, jsonEncode(foods));
  }

  

  // ============================================================================
  // DAILY DATA OPERATIONS
  // ============================================================================
  static Future<void> saveDailyData({
    required String date,
    double? calories,
    double? protein,
    double? carbs,
    double? fats,
    double? water,
    double? weight,
    double? calorieTarget,
    double? proteinTarget,
    double? carbsTarget,
    double? fatsTarget,
    double? waterTarget,
    Map<String, dynamic>? foodEntry,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final allData = await _getAllStoredData(prefs);
    
    // Get or create today's data
    final dayData = _getOrCreateDayData(allData, date);
    
    // Update totals if provided
    _updateDayTotals(dayData, calories, protein, carbs, fats, water, weight);
    
    // Update targets if provided
    _updateDayTargets(dayData, calorieTarget, proteinTarget, carbsTarget, fatsTarget, waterTarget);
    
    // Add new food entry if provided
    if (foodEntry != null) {
      _addFoodEntry(dayData, foodEntry);
    }
    
    // Save everything back to storage
    allData[date] = dayData;
    await prefs.setString(_dailyDataKey, jsonEncode(allData));
  }

  static Future<void> saveOrUpdateFoodEntry({
    required String date,
    required Map<String, dynamic> foodEntry,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final allData = await _getAllStoredData(prefs);

    // Get or create day data
    final dayData = _getOrCreateDayData(allData, date);

    // Ensure the "foods" list exists
    dayData["foods"] ??= [];

    List foods = dayData["foods"];

    // Extract food name (unique identifier)
    final entryName = foodEntry["foodName"] ?? foodEntry["name"];

    // Helper to safely convert to double
    double toDouble(dynamic value) {
      if (value is num) return value.toDouble();
      return double.tryParse(value.toString()) ?? 0.0;
    }

    // Try to find existing index
    final idx = foods.indexWhere((f) => 
      (f["foodName"] ?? f["name"]) == entryName
    );

    if (idx != -1) {
      // Subtract old food's macros before updating
      final oldFood = foods[idx];
      dayData['calories'] = (toDouble(dayData['calories']) - toDouble(oldFood['calories']));
      dayData['protein'] = (toDouble(dayData['protein']) - toDouble(oldFood['protein']));
      dayData['carbs'] = (toDouble(dayData['carbs']) - toDouble(oldFood['carbs']));
      dayData['fats'] = (toDouble(dayData['fats']) - toDouble(oldFood['fats']));
      
      // Update existing entry
      foods[idx] = foodEntry;
    } else {
      // Add new entry
      foods.add(foodEntry);
    }

    // Add new food's macros to daily totals
    dayData['calories'] = (toDouble(dayData['calories']) + toDouble(foodEntry['calories'])).clamp(0.0, double.infinity);
    dayData['protein'] = (toDouble(dayData['protein']) + toDouble(foodEntry['protein'])).clamp(0.0, double.infinity);
    dayData['carbs'] = (toDouble(dayData['carbs']) + toDouble(foodEntry['carbs'])).clamp(0.0, double.infinity);
    dayData['fats'] = (toDouble(dayData['fats']) + toDouble(foodEntry['fats'])).clamp(0.0, double.infinity);

    // Save back to storage
    allData[date] = dayData;
    await prefs.setString(_dailyDataKey, jsonEncode(allData));
  }

  static Future<void> deleteFood({
    required String date,
    required String foodName,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final allData = await _getAllStoredData(prefs);
    
    // Check if date exists
    if (allData[date] == null) return;
    
    final dayData = Map<String, dynamic>.from(allData[date]);
    final foods = List<dynamic>.from(dayData['foods'] ?? []);
    
    // Find the food to delete (case-insensitive search)
    final deleteIndex = _findFoodIndex(foods, foodName);
    if (deleteIndex == -1) return; // Food not found
    
    // Subtract the food's macros from daily totals
    _subtractFoodMacros(dayData, foods[deleteIndex]);
    
    // Remove the food from the list
    foods.removeAt(deleteIndex);
    dayData['foods'] = foods;
    
    // Save updated data
    allData[date] = dayData;
    await prefs.setString(_dailyDataKey, jsonEncode(allData));
  }

  /// Get all data for a specific date
  /// Returns null if no data exists for that date
  static Future<Map<String, dynamic>?> getDailyData(String date) async {
    final prefs = await SharedPreferences.getInstance();
    final allData = await _getAllStoredData(prefs);
    return allData[date];
  }

  /// Get data for all dates
  /// Returns empty map if no data exists
  static Future<Map<String, dynamic>> getAllData() async {
    final prefs = await SharedPreferences.getInstance();
    return await _getAllStoredData(prefs);
  }

  /// Delete all stored daily data (use with caution!)
  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_dailyDataKey);
  }

  // ============================================================================
  // THEME OPERATIONS
  // ============================================================================

  /// Save the current theme mode
  static Future<void> saveThemeData({required ThemeMode currentTheme}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, currentTheme.toString());
  }

  /// Get the previously saved theme mode
  /// Returns null if no theme has been saved
  static Future<ThemeMode?> getThemeData() async {
    final prefs = await SharedPreferences.getInstance();
    final themeString = prefs.getString(_themeModeKey);
    
    if (themeString == null) return null;
    
    // Convert string back to ThemeMode enum
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

  // ============================================================================
  // PRIVATE HELPER METHODS
  // ============================================================================

  /// Get all stored data from SharedPreferences
  static Future<Map<String, dynamic>> _getAllStoredData(SharedPreferences prefs) async {
    final existingData = prefs.getString(_dailyDataKey);
    return existingData != null ? jsonDecode(existingData) : {};
  }

  /// Get existing day data or create new empty day data
  static Map<String, dynamic> _getOrCreateDayData(
    Map<String, dynamic> allData,
    String date,
  ) {
    return allData[date] ?? {
      'calories': 0.0,
      'protein': 0.0,
      'carbs': 0.0,
      'fats': 0.0,
      'water': 0.0,
      'weight': 0.0,
      'calorieTarget': 0.0,
      'proteinTarget': 0.0,
      'carbsTarget': 0.0,
      'fatsTarget': 0.0,
      'waterTarget': 0.0,
      'foods': [],
    };
  }

  /// Update day totals with new values (only if provided)
  static void _updateDayTotals(
    Map<String, dynamic> dayData,
    double? calories,
    double? protein,
    double? carbs,
    double? fats,
    double? water,
    double? weight,
  ) {
    if (calories != null) dayData['calories'] = calories;
    if (protein != null) dayData['protein'] = protein;
    if (carbs != null) dayData['carbs'] = carbs;
    if (fats != null) dayData['fats'] = fats;
    if (water != null) dayData['water'] = water;
    if (weight != null) dayData['weight'] = weight;
  }

  /// Update day targets with new values (only if provided)
  static void _updateDayTargets(
    Map<String, dynamic> dayData,
    double? calorieTarget,
    double? proteinTarget,
    double? carbsTarget,
    double? fatsTarget,
    double? waterTarget,
  ) {
    if (calorieTarget != null) dayData['calorieTarget'] = calorieTarget;
    if (proteinTarget != null) dayData['proteinTarget'] = proteinTarget;
    if (carbsTarget != null) dayData['carbsTarget'] = carbsTarget;
    if (fatsTarget != null) dayData['fatsTarget'] = fatsTarget;
    if (waterTarget != null) dayData['waterTarget'] = waterTarget;
  }

  /// Add a food entry to the day's food list
  static void _addFoodEntry(Map<String, dynamic> dayData, Map<String, dynamic> foodEntry) {
    final foods = List<dynamic>.from(dayData['foods'] ?? []);
    foods.add(foodEntry);
    dayData['foods'] = foods;
  }

  /// Find the index of a food by name (case-insensitive)
  static int _findFoodIndex(List<dynamic> foods, String foodName) {
    return foods.indexWhere((food) {
      final storedName = (food['foodName'] ?? food['foodName'] ?? '')
          .toString()
          .trim()
          .toLowerCase();
      return storedName == foodName.trim().toLowerCase();
    });
  }

  /// Subtract a food's macros from the day's totals
  static void _subtractFoodMacros(Map<String, dynamic> dayData, dynamic food) {
    final foodMap = Map<String, dynamic>.from(food);
    
    // Helper to safely convert to double
    double toDouble(dynamic value) {
      if (value is num) return value.toDouble();
      return double.tryParse(value.toString()) ?? 0.0;
    }
    
    // Subtract and clamp to prevent negative values
    dayData['calories'] = (toDouble(dayData['calories']) - toDouble(foodMap['calories']))
        .clamp(0.0, double.infinity);
    dayData['protein'] = (toDouble(dayData['protein']) - toDouble(foodMap['protein']))
        .clamp(0.0, double.infinity);
    dayData['carbs'] = (toDouble(dayData['carbs']) - toDouble(foodMap['carbs']))
        .clamp(0.0, double.infinity);
    dayData['fats'] = (toDouble(dayData['fats']) - toDouble(foodMap['fats']))
        .clamp(0.0, double.infinity);
  }
}