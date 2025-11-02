import 'package:flutter/material.dart';
import 'local_storage.dart';

/// Manages daily nutrition data state across the app
/// Handles loading, updating, and caching data for multiple dates
class DailyDataProvider extends ChangeNotifier {
  // Cache: Stores loaded data for quick access (key = date, value = day's data)
  final Map<String, Map<String, dynamic>> _cache = {};

  // ============================================================================
  // DATE NORMALIZATION
  // ============================================================================

  /// Ensures dates are in consistent format: dd-MM-yyyy with leading zeros
  /// Example: "2-1-2025" becomes "02-01-2025"
  String _normalizeDate(String date) {
    final parts = date.split('-');
    if (parts.length != 3) return date;
    
    final day = parts[0].padLeft(2, '0');
    final month = parts[1].padLeft(2, '0');
    final year = parts[2];
    
    return '$day-$month-$year';
  }

  // ============================================================================
  // DATA RETRIEVAL
  // ============================================================================

  /// Get cached data for a specific date
  /// Returns null if data hasn't been loaded yet
  /// 
  /// Usage: `provider.getDailyData('21-10-2025')`
  Map<String, dynamic>? getDailyData(String date) {
    final normalizedDate = _normalizeDate(date);
    return _cache[normalizedDate];
  }

  /// Get weight for a specific date
  /// Returns null if no weight recorded or data not loaded
  double? getWeight(String date) {
    final normalizedDate = _normalizeDate(date);
    return _cache[normalizedDate]?['weight'];
  }

  /// Get all loaded weights from cache
  /// Returns map where key = date, value = weight
  /// Only includes dates with non-zero weights
  Map<String, double> getAllLoadedWeights() {
    final weights = <String, double>{};
    
    _cache.forEach((date, data) {
      final weight = data['weight'];
      if (weight != null && weight != 0.0) {
        weights[date] = weight as double;
      }
    });
    
    return weights;
  }

  /// Get the most recent targets from storage
  /// Returns null if no targets have been set yet
  /// 
  /// Usage:
  /// ```dart
  /// final targets = await provider.getLastTargets();
  /// double calorieTarget = targets?['calorieTarget'] ?? 2300;
  /// ```
  Future<Map<String, double>?> getLastTargets() async {
    final allData = await LocalStorageService.getAllData();
    
    if (allData.isEmpty) return null;
    
    // Sort dates to find the most recent one with targets
    final sortedDates = allData.keys.toList()..sort((a, b) {
      final dateA = _parseDate(a);
      final dateB = _parseDate(b);
      return dateB.compareTo(dateA); // Most recent first
    });
    
    // Find the first date with non-zero targets
    for (final date in sortedDates) {
      final dayData = allData[date];
      if (dayData == null) continue;
      
      final calorieTarget = dayData['calorieTarget'] ?? 0.0;
      final proteinTarget = dayData['proteinTarget'] ?? 0.0;
      final carbsTarget = dayData['carbsTarget'] ?? 0.0;
      final fatsTarget = dayData['fatsTarget'] ?? 0.0;
      final waterTarget = dayData['waterTarget'] ?? 0.0;
      
      // If any target is set, return all targets from this date
      if (calorieTarget > 0 || proteinTarget > 0 || carbsTarget > 0 || 
          fatsTarget > 0 || waterTarget > 0) {
        return {
          'calorieTarget': calorieTarget is num ? calorieTarget.toDouble() : 0.0,
          'proteinTarget': proteinTarget is num ? proteinTarget.toDouble() : 0.0,
          'carbsTarget': carbsTarget is num ? carbsTarget.toDouble() : 0.0,
          'fatsTarget': fatsTarget is num ? fatsTarget.toDouble() : 0.0,
          'waterTarget': waterTarget is num ? waterTarget.toDouble() : 0.0,
        };
      }
    }
    
    return null; // No targets found
  }

  /// Helper to parse date string (dd-MM-yyyy) to DateTime for sorting
  DateTime _parseDate(String date) {
    try {
      final parts = date.split('-');
      if (parts.length != 3) return DateTime(1970); // Invalid date
      
      final day = int.tryParse(parts[0]) ?? 1;
      final month = int.tryParse(parts[1]) ?? 1;
      final year = int.tryParse(parts[2]) ?? 1970;
      
      return DateTime(year, month, day);
    } catch (e) {
      return DateTime(1970); // Fallback for parse errors
    }
  }

  // ============================================================================
  // DATA LOADING
  // ============================================================================

  /// Load data for a specific date from storage into cache
  /// Call this before accessing data for a new date
  /// 
  /// Example:
  /// ```dart
  /// await provider.loadDailyData('21-10-2025');
  /// final data = provider.getDailyData('21-10-2025');
  /// ```
  Future<void> loadDailyData(String date) async {
    final normalizedDate = _normalizeDate(date);
    final data = await LocalStorageService.getDailyData(normalizedDate);
    
    _cache[normalizedDate] = data ?? _createEmptyDayData();
    notifyListeners();
  }

  // ============================================================================
  // DATA UPDATES
  // ============================================================================

  /// Update nutrition totals and targets for a specific date
  /// 
  /// Example:
  /// ```dart
  /// await provider.updateDailyData('21-10-2025', {
  ///   'calories': 2000.0,
  ///   'protein': 150.0,
  ///   'carbs': 200.0,
  ///   'fats': 65.0,
  ///   'water': 2.5,
  ///   'weight': 75.0,
  ///   'calorieTarget': 2500.0,
  ///   'proteinTarget': 180.0,
  ///   'carbsTarget': 250.0,
  ///   'fatsTarget': 70.0,
  ///   'waterTarget': 3.0,
  /// });
  /// ```
  Future<void> updateDailyData(String date, Map<String, dynamic> newData) async {
    final normalizedDate = _normalizeDate(date);
    
    // Save to storage
    await LocalStorageService.saveDailyData(
      date: normalizedDate,
      calories: newData['calories'],
      protein: newData['protein'],
      carbs: newData['carbs'],
      fats: newData['fats'],
      water: newData['water'],
      weight: newData['weight'],
      calorieTarget: newData['calorieTarget'],
      proteinTarget: newData['proteinTarget'],
      carbsTarget: newData['carbsTarget'],
      fatsTarget: newData['fatsTarget'],
      waterTarget: newData['waterTarget'],
    );
    
    // Reload from storage to ensure cache matches
    await _reloadDateData(normalizedDate);
  }

  /// Update a single target for a specific date
  /// Useful when user changes one target at a time in settings
  /// 
  /// Example:
  /// ```dart
  /// await provider.updateSingleTarget('21-10-2025', 'calorieTarget', 2800.0);
  /// await provider.updateSingleTarget('21-10-2025', 'proteinTarget', 200.0);
  /// ```
  Future<void> updateSingleTarget(String date, String targetName, double value) async {
    final normalizedDate = _normalizeDate(date);
    
    // Get existing data or create empty
    final existingData = await LocalStorageService.getDailyData(normalizedDate);
    final dayData = existingData ?? {
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
    
    // Update the specific target
    dayData[targetName] = value;
    
    // Save to storage
    await LocalStorageService.saveDailyData(
      date: normalizedDate,
      calories: dayData['calories'],
      protein: dayData['protein'],
      carbs: dayData['carbs'],
      fats: dayData['fats'],
      water: dayData['water'],
      weight: dayData['weight'],
      calorieTarget: dayData['calorieTarget'],
      proteinTarget: dayData['proteinTarget'],
      carbsTarget: dayData['carbsTarget'],
      fatsTarget: dayData['fatsTarget'],
      waterTarget: dayData['waterTarget'],
    );
    
    // Reload from storage to ensure cache matches
    await _reloadDateData(normalizedDate);
  }

  /// Add a food entry to a specific date
  /// Automatically updates the day's totals
  /// 
  /// Example:
  /// ```dart
  /// await provider.addFood('21-10-2025', {
  ///   'name': 'Chicken Breast',
  ///   'calories': 200.0,
  ///   'protein': 40.0,
  ///   'carbs': 0.0,
  ///   'fats': 5.0,
  /// });
  /// ```
  Future<void> addFood(String date, Map<String, dynamic> foodEntry) async {
    final normalizedDate = _normalizeDate(date);
    
    // Save to storage (this also updates totals)
    await LocalStorageService.saveDailyData(
      date: normalizedDate,
      foodEntry: foodEntry,
    );
    
    // Reload from storage to get updated totals
    await _reloadDateData(normalizedDate);
  }

  /// Delete a food entry by name from a specific date
  /// Automatically recalculates the day's totals
  /// 
  /// Example:
  /// ```dart
  /// await provider.deleteFood('21-10-2025', 'Chicken Breast');
  /// ```
  Future<void> deleteFood(String date, String foodName) async {
    final normalizedDate = _normalizeDate(date);
    
    // Delete from storage (this also updates totals)
    await LocalStorageService.deleteFood(
      date: normalizedDate,
      foodName: foodName,
    );
    
    // Reload from storage to get updated data
    await _reloadDateData(normalizedDate);
  }

  // ============================================================================
  // PRIVATE HELPER METHODS
  // ============================================================================

  /// Create an empty day data structure with all fields initialized to 0
  Map<String, dynamic> _createEmptyDayData() {
    return {
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

  /// Reload data for a specific date from storage into cache
  /// Updates UI after loading
  Future<void> _reloadDateData(String normalizedDate) async {
    final data = await LocalStorageService.getDailyData(normalizedDate);
    _cache[normalizedDate] = data ?? _createEmptyDayData();
    notifyListeners();
  }
}