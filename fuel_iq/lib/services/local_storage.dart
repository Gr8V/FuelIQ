
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocalStorageService {
  static const String _dailyDataKey = 'daily_data';

  /// Save daily data for a given date
  static Future<void> saveDailyData({
    required String date, // e.g. "2025-10-21"
    required double calories,
    required double protein,
    required double carbs,
    required double fats,
    required double water,
    required double weight,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    // Get existing data
    final existingData = prefs.getString(_dailyDataKey);
    Map<String, dynamic> allData =
        existingData != null ? jsonDecode(existingData) : {};

    // Update this date’s data
    allData[date] = {
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fats': fats,
      'water': water,
      'weight': weight,
    };

    // Save it back
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