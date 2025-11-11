import 'package:flutter/material.dart';
import 'local_storage.dart';

/// Manages daily nutrition data state across the app
/// Handles loading, updating, and caching data for multiple dates
class DailyDataProvider extends ChangeNotifier {
  // Cache: Stores loaded data for quick access (key = date, value = day's data)
  final Map<String, Map<String, dynamic>> _cache = {};

  // ============================================================================
  // INITIALIZATION & AUTO-FILL
  // ============================================================================

  /// Initialize the provider and auto-fill missing days
  /// Call this when the app starts (e.g., in main.dart or home screen)
  /// 
  /// Usage:
  /// ```dart
  /// await Provider.of<DailyDataProvider>(context, listen: false).initialize(
  ///   defaultCaloriesTarget: 2300,
  ///   defaultProteinTarget: 150,
  ///   defaultCarbsTarget: 250,
  ///   defaultFatsTarget: 70,
  ///   defaultWaterTarget: 3,
  /// );
  /// ```
  Future<void> initialize({
    double defaultCaloriesTarget = 2300,
    double defaultProteinTarget = 150,
    double defaultCarbsTarget = 250,
    double defaultFatsTarget = 70,
    double defaultWaterTarget = 3,
  }) async {
    await _autoFillMissingDays(
      defaultCaloriesTarget: defaultCaloriesTarget,
      defaultProteinTarget: defaultProteinTarget,
      defaultCarbsTarget: defaultCarbsTarget,
      defaultFatsTarget: defaultFatsTarget,
      defaultWaterTarget: defaultWaterTarget,
    );
  }

  /// Automatically fill missing days between last stored date and today
  /// Copies targets from the last available day, or uses defaults if no data exists
  Future<void> _autoFillMissingDays({
    required double defaultCaloriesTarget,
    required double defaultProteinTarget,
    required double defaultCarbsTarget,
    required double defaultFatsTarget,
    required double defaultWaterTarget,
  }) async {
    final allData = await LocalStorageService.getAllData();
    final today = DateTime.now();
    
    Map<String, double> targets;
    DateTime startDate;
    
    if (allData.isEmpty) {
      // No previous data - use defaults and start from today
      targets = {
        'calorieTarget': defaultCaloriesTarget,
        'proteinTarget': defaultProteinTarget,
        'carbsTarget': defaultCarbsTarget,
        'fatsTarget': defaultFatsTarget,
        'waterTarget': defaultWaterTarget,
      };
      startDate = today;
    } else {
      // Find the most recent date in storage
      final sortedDates = allData.keys.toList()..sort((a, b) {
        final dateA = _parseDate(a);
        final dateB = _parseDate(b);
        return dateB.compareTo(dateA); // Most recent first
      });
      
      final lastStoredDate = _parseDate(sortedDates.first);
      
      // If last stored date is today or in the future, no need to fill
      if (_isSameDay(lastStoredDate, today) || lastStoredDate.isAfter(today)) {
        return;
      }
      
      // Get targets from the last stored day
      final lastDayData = allData[sortedDates.first];
      targets = {
        'calorieTarget': lastDayData?['calorieTarget'] ?? defaultCaloriesTarget,
        'proteinTarget': lastDayData?['proteinTarget'] ?? defaultProteinTarget,
        'carbsTarget': lastDayData?['carbsTarget'] ?? defaultCarbsTarget,
        'fatsTarget': lastDayData?['fatsTarget'] ?? defaultFatsTarget,
        'waterTarget': lastDayData?['waterTarget'] ?? defaultWaterTarget,
      };
      
      startDate = lastStoredDate.add(const Duration(days: 1));
    }
    
    // Fill in missing days
    DateTime currentDate = startDate;
    
    while (currentDate.isBefore(today) || _isSameDay(currentDate, today)) {
      final dateString = _formatDate(currentDate);
      
      // Check if this date already exists
      final existingData = await LocalStorageService.getDailyData(dateString);
      
      if (existingData == null) {
        // Create empty day with targets
        await LocalStorageService.saveDailyData(
          date: dateString,
          calories: 0.0,
          protein: 0.0,
          carbs: 0.0,
          fats: 0.0,
          water: 0.0,
          weight: 0.0,
          calorieTarget: targets['calorieTarget'],
          proteinTarget: targets['proteinTarget'],
          carbsTarget: targets['carbsTarget'],
          fatsTarget: targets['fatsTarget'],
          waterTarget: targets['waterTarget'],
        );
      }
      
      currentDate = currentDate.add(const Duration(days: 1));
    }
  }

  /// Check if two dates are the same day (ignoring time)
  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Format DateTime to dd-MM-yyyy string
  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day-$month-$year';
  }

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

  // Replace your existing getAllLoaded methods with these:

/// Get all calories data from storage (not just cache)
/// Optionally limit to last N days
Future<List<Map<String, dynamic>>> getAllLoadedCalories({int? lastDays}) async {
  final allData = await LocalStorageService.getAllData();
  final results = <Map<String, dynamic>>[];
  
  // Filter by date if lastDays is specified
  DateTime? cutoffDate;
  if (lastDays != null) {
    cutoffDate = DateTime.now().subtract(Duration(days: lastDays));
  }

  allData.forEach((date, data) {
    final dailyCal = data['calories'];
    final targetCal = data['calorieTarget'];
    
    // Check date filter
    if (cutoffDate != null) {
      final dateTime = _parseDate(date);
      if (dateTime.isBefore(cutoffDate)) return;
    }
    
    if (dailyCal != null && dailyCal != 0.0) {
      results.add({
        'date': date,
        'calories': dailyCal is num ? dailyCal.toDouble() : 0.0,
        'calorieTarget': targetCal is num ? targetCal.toDouble() : 0.0,
      });
    }
  });
  
  // Sort by date (most recent first)
  results.sort((a, b) {
    final dateA = _parseDate(a['date']);
    final dateB = _parseDate(b['date']);
    return dateB.compareTo(dateA);
  });
  
  return results;
}

/// Get all protein data from storage (not just cache)
Future<List<Map<String, dynamic>>> getAllLoadedProtein({int? lastDays}) async {
  final allData = await LocalStorageService.getAllData();
  final results = <Map<String, dynamic>>[];
  
  DateTime? cutoffDate;
  if (lastDays != null) {
    cutoffDate = DateTime.now().subtract(Duration(days: lastDays));
  }

  allData.forEach((date, data) {
    final dailyProtein = data['protein'];
    final targetProtein = data['proteinTarget'];
    
    if (cutoffDate != null) {
      final dateTime = _parseDate(date);
      if (dateTime.isBefore(cutoffDate)) return;
    }
    
    if (dailyProtein != null && dailyProtein != 0.0) {
      results.add({
        'date': date,
        'protein': dailyProtein is num ? dailyProtein.toDouble() : 0.0,
        'proteinTarget': targetProtein is num ? targetProtein.toDouble() : 0.0,
      });
    }
  });
  
  results.sort((a, b) {
    final dateA = _parseDate(a['date']);
    final dateB = _parseDate(b['date']);
    return dateB.compareTo(dateA);
  });
  
  return results;
}

/// Get all carbs data from storage (not just cache)
Future<List<Map<String, dynamic>>> getAllLoadedCarbs({int? lastDays}) async {
  final allData = await LocalStorageService.getAllData();
  final results = <Map<String, dynamic>>[];
  
  DateTime? cutoffDate;
  if (lastDays != null) {
    cutoffDate = DateTime.now().subtract(Duration(days: lastDays));
  }

  allData.forEach((date, data) {
    final dailyCarbs = data['carbs'];
    final targetCarbs = data['carbsTarget'];
    
    if (cutoffDate != null) {
      final dateTime = _parseDate(date);
      if (dateTime.isBefore(cutoffDate)) return;
    }
    
    if (dailyCarbs != null && dailyCarbs != 0.0) {
      results.add({
        'date': date,
        'carbs': dailyCarbs is num ? dailyCarbs.toDouble() : 0.0,
        'carbsTarget': targetCarbs is num ? targetCarbs.toDouble() : 0.0,
      });
    }
  });
  
  results.sort((a, b) {
    final dateA = _parseDate(a['date']);
    final dateB = _parseDate(b['date']);
    return dateB.compareTo(dateA);
  });
  
  return results;
}

/// Get all fats data from storage (not just cache)
Future<List<Map<String, dynamic>>> getAllLoadedFats({int? lastDays}) async {
  final allData = await LocalStorageService.getAllData();
  final results = <Map<String, dynamic>>[];
  
  DateTime? cutoffDate;
  if (lastDays != null) {
    cutoffDate = DateTime.now().subtract(Duration(days: lastDays));
  }

  allData.forEach((date, data) {
    final dailyFats = data['fats'];
    final targetFats = data['fatsTarget'];
    
    if (cutoffDate != null) {
      final dateTime = _parseDate(date);
      if (dateTime.isBefore(cutoffDate)) return;
    }
    
    if (dailyFats != null && dailyFats != 0.0) {
      results.add({
        'date': date,
        'fats': dailyFats is num ? dailyFats.toDouble() : 0.0,
        'fatsTarget': targetFats is num ? targetFats.toDouble() : 0.0,
      });
    }
  });
  
  results.sort((a, b) {
    final dateA = _parseDate(a['date']);
    final dateB = _parseDate(b['date']);
    return dateB.compareTo(dateA);
  });
  
  return results;
}

/// Get all weights from storage (not just cache)
Future<Map<String, double>> getAllWeights({int? lastDays}) async {
  final allData = await LocalStorageService.getAllData();
  final weights = <String, double>{};
  
  DateTime? cutoffDate;
  if (lastDays != null) {
    cutoffDate = DateTime.now().subtract(Duration(days: lastDays));
  }
  
  allData.forEach((date, data) {
    if (cutoffDate != null) {
      final dateTime = _parseDate(date);
      if (dateTime.isBefore(cutoffDate)) return;
    }
    
    final weight = data['weight'];
    if (weight != null && weight != 0.0) {
      weights[date] = weight is num ? weight.toDouble() : 0.0;
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

  Future<void> clearAllData() async {
    // Clear storage
    await LocalStorageService.clearAllData();
    
    // Clear cache
    _cache.clear();
    
    // Notify all listeners to update UI
    notifyListeners();
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