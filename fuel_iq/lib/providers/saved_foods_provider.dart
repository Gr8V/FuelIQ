import 'package:flutter/material.dart';
import '../services/local_storage.dart';

class SavedFoodsProvider extends ChangeNotifier {
  Map<String, dynamic> _savedFoods = {};

  Map<String, dynamic> get savedFoods => _savedFoods;

  // LOAD all saved foods from local storage
  Future<void> loadSavedFoods() async {
    _savedFoods = await LocalStorageService.getSavedFoods();
    notifyListeners();
  }

  // SAVE or update a food
  Future<void> saveFood(Map<String, dynamic> data) async {
    final name = data['name'];
    _savedFoods[name] = data;

    await LocalStorageService.saveAllFoods(_savedFoods);
    notifyListeners();
  }

  // DELETE a food by name
  Future<void> deleteFood(String name) async {
    _savedFoods.remove(name);
    await LocalStorageService.saveAllFoods(_savedFoods);
    notifyListeners();
  }

  // CLEAR all saved foods
  Future<void> clearAll() async {
    _savedFoods.clear();
    await LocalStorageService.saveAllFoods({});
    notifyListeners();
  }

  // ======== EXTRA METHODS (your UI depends on these) ========= //

  // Return only names of saved foods
  List<String> getSavedFoodNames() {
    return _savedFoods.keys.toList();
  }

  // Get details for *one* saved food
  Map<String, dynamic>? getSavedFoodDetails(String name) {
    return _savedFoods[name];
  }

  // Get full list of saved foods with "name" added inside the map
  List<Map<String, dynamic>> getAllSavedFoodsWithDetails() {
    return _savedFoods.entries.map((entry) {
      final data = Map<String, dynamic>.from(entry.value);
      data['name'] = entry.key; // Add name to details
      return data;
    }).toList();
  }
}
