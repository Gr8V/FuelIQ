//calories and macros change notifiers

// Add this import at the top
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fuel_iq/services/daily_data_provider.dart';

// Your existing code
String getTodaysDate() {
  final now = DateTime.now();
  final year = now.year.toString();
  final month = now.month.toString();
  final day = now.day.toString();
  return "$day-$month-$year";
}

String todaysDate = getTodaysDate();
String appBarTitle = todaysDate;

// DEFAULT values (used as fallback)
double defaultCaloriesTarget = 2300;
double defaultProteinTarget = 150;
double defaultCarbsTarget = 250;
double defaultFatsTarget = 70;
double defaultWaterTarget = 3;

// ACTUAL targets (loaded from storage or use defaults)
double caloriesTarget = 2300;
double proteinTarget = 150;
double carbsTarget = 250;
double fatsTarget = 70;
double waterTarget = 3;

// Add this method to load targets
Future<void> loadTargets(BuildContext context) async {
  final provider = Provider.of<DailyDataProvider>(context, listen: false);
  final lastTargets = await provider.getLastTargets();
  
  if (lastTargets != null) {
    // Use stored targets
    caloriesTarget = lastTargets['calorieTarget'] ?? defaultCaloriesTarget;
    proteinTarget = lastTargets['proteinTarget'] ?? defaultProteinTarget;
    carbsTarget = lastTargets['carbsTarget'] ?? defaultCarbsTarget;
    fatsTarget = lastTargets['fatsTarget'] ?? defaultFatsTarget;
    waterTarget = lastTargets['waterTarget'] ?? defaultWaterTarget;
  } else {
    // Use defaults (first time user)
    caloriesTarget = defaultCaloriesTarget;
    proteinTarget = defaultProteinTarget;
    carbsTarget = defaultCarbsTarget;
    fatsTarget = defaultFatsTarget;
    waterTarget = defaultWaterTarget;
  }
}


//update values
// When user changes calorie target in settings
Future<void> updateCalorieTarget(double newValue, BuildContext context) async {
  final provider = Provider.of<DailyDataProvider>(context, listen: false);
  
  // Update global variable (immediate effect in UI)
  caloriesTarget = newValue;
  
  // Save to storage (persists for next app launch)
  await provider.updateSingleTarget(getTodaysDate(), 'calorieTarget', newValue);
}

// When user changes protein target
Future<void> updateProteinTarget(double newValue, BuildContext context) async {
  final provider = Provider.of<DailyDataProvider>(context, listen: false);
  
  proteinTarget = newValue;
  await provider.updateSingleTarget(getTodaysDate(), 'proteinTarget', newValue);
}

// When user changes carbs target
Future<void> updateCarbsTarget(double newValue, BuildContext context) async {
  final provider = Provider.of<DailyDataProvider>(context, listen: false);
  
  carbsTarget = newValue;
  await provider.updateSingleTarget(getTodaysDate(), 'carbsTarget', newValue);
}

// When user changes fats target
Future<void> updateFatsTarget(double newValue, BuildContext context) async {
  final provider = Provider.of<DailyDataProvider>(context, listen: false);
  
  fatsTarget = newValue;
  await provider.updateSingleTarget(getTodaysDate(), 'fatsTarget', newValue);
}

// When user changes water target
Future<void> updateWaterTarget(double newValue, BuildContext context) async {
  final provider = Provider.of<DailyDataProvider>(context, listen: false);
  
  waterTarget = newValue;
  await provider.updateSingleTarget(getTodaysDate(), 'waterTarget', newValue);
}