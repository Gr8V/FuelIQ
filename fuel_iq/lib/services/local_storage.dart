import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/daily_data.dart';

class LocalStorageService {
  static const String _dailyDataKey = 'daily_data';
  static const String _themeKey = 'theme_data';
  static const String _savedFoodsKey = 'saved_foods';

  // ================================================================
  // FOOD LIBRARY (Saved Foods)
  // ================================================================

  static Future<Map<String, dynamic>> getSavedFoods() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_savedFoodsKey);
    if (jsonStr == null) return {};
    return jsonDecode(jsonStr);
  }

  static Future<void> saveAllFoods(Map<String, dynamic> foods) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_savedFoodsKey, jsonEncode(foods));
  }

  // ================================================================
  // DAILY DATA
  // ================================================================

  static Future<void> saveDailyData({
    required String date,
    required Map<String, dynamic> data,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final allData = await getAllData();

    allData[date] = data;
    await prefs.setString(_dailyDataKey, jsonEncode(allData));
  }

  static Future<DailyDataModel?> loadDailyData(String date) async {
    final all = await getAllData();
    final json = all[date];
    if (json == null) return null;
    return DailyDataModel.fromJson(json);
  }

  static Future<Map<String, dynamic>> getAllData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_dailyDataKey);
    if (jsonStr == null) return {};
    return jsonDecode(jsonStr);
  }

  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_dailyDataKey);
  }

  // ================================================================
  // THEME STORAGE
  // ================================================================

  static Future<void> saveThemeMode(ThemeMode theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, theme.toString());
  }

  static Future<ThemeMode?> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeStr = prefs.getString(_themeKey);

    switch (themeStr) {
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
