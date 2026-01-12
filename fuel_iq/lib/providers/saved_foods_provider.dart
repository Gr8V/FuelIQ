import 'package:flutter/material.dart';
import 'package:fuel_iq/data/local/quick_access_data_storage.dart';

class SavedFoodsProvider extends ChangeNotifier {
  Map<String, dynamic> _savedFoods = {};

  Map<String, dynamic> get savedFoods => _savedFoods;

  SavedFoodsProvider() {
    _loadSavedFoods();
  }

  // LOAD all saved foods from local storage
  Future<void> _loadSavedFoods() async {
    _savedFoods = QuickAccessStorage().getSavedFoods();
    notifyListeners();
  }

  // SAVE or update a food (using id as key)
  Future<void> saveFood(Map<String, dynamic> data) async {
    final id = data['id'];
    if (id == null) {
      throw Exception('Food must have an id');
    }
    _savedFoods[id] = data;

    await QuickAccessStorage().saveAllFoods(_savedFoods);
    notifyListeners();
  }

  // DELETE a food by id
  Future<void> deleteFood(String id) async {
    _savedFoods.remove(id);
    await QuickAccessStorage().saveAllFoods(_savedFoods);
    notifyListeners();
  }

  // CLEAR all saved foods
  Future<void> clearAll() async {
    _savedFoods.clear();
    await QuickAccessStorage().saveAllFoods({});
    notifyListeners();
  }

  // ======== EXTRA METHODS (updated to use id) ========= //


  // Get full list of saved foods with details
  List<Map<String, dynamic>> getAllSavedFoodsWithDetails() {
    return _savedFoods.values.map((data) {
      return Map<String, dynamic>.from(data);
    }).toList();
  }

  // HELPER: Get a saved food by name (if you need to search)
  Map<String, dynamic>? getSavedFoodByName(String name) {
    for (var food in _savedFoods.values) {
      if (food['name'] == name) {
        return Map<String, dynamic>.from(food);
      }
    }
    return null;
  }

  // HELPER: Get all foods with a specific name
  List<Map<String, dynamic>> getAllFoodsWithName(String name) {
    return _savedFoods.values
        .where((food) => food['name'] == name)
        .map((food) => Map<String, dynamic>.from(food))
        .toList();
  }
}
