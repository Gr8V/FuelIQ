import 'food_entry.dart';

class DailyDataModel {
  double calories;
  double protein;
  double carbs;
  double fats;
  double water;
  double weight;

  double calorieTarget;
  double proteinTarget;
  double carbsTarget;
  double fatsTarget;
  double waterTarget;

  List<FoodEntry> foods;

  DailyDataModel({
    this.calories = 0,
    this.protein = 0,
    this.carbs = 0,
    this.fats = 0,
    this.water = 0,
    this.weight = 0,
    this.calorieTarget = 2300,
    this.proteinTarget = 150,
    this.carbsTarget = 250,
    this.fatsTarget = 70,
    this.waterTarget = 3,
    List<FoodEntry>? foods,
  }) : foods = foods ?? [];

  Map<String, dynamic> toJson() => {
        'calories': calories,
        'protein': protein,
        'carbs': carbs,
        'fats': fats,
        'water': water,
        'weight': weight,
        'calorieTarget': calorieTarget,
        'proteinTarget': proteinTarget,
        'carbsTarget': carbsTarget,
        'fatsTarget': fatsTarget,
        'waterTarget': waterTarget,
        'foods': foods.map((f) => f.toJson()).toList(),
      };

  factory DailyDataModel.fromJson(Map<String, dynamic> json) => DailyDataModel(
        calories: (json['calories'] ?? 0).toDouble(),
        protein: (json['protein'] ?? 0).toDouble(),
        carbs: (json['carbs'] ?? 0).toDouble(),
        fats: (json['fats'] ?? 0).toDouble(),
        water: (json['water'] ?? 0).toDouble(),
        weight: (json['weight'] ?? 0).toDouble(),
        calorieTarget: (json['calorieTarget'] ?? 2300).toDouble(),
        proteinTarget: (json['proteinTarget'] ?? 150).toDouble(),
        carbsTarget: (json['carbsTarget'] ?? 250).toDouble(),
        fatsTarget: (json['fatsTarget'] ?? 70).toDouble(),
        waterTarget: (json['waterTarget'] ?? 3).toDouble(),
        foods: (json['foods'] as List? ?? [])
            .map((f) => FoodEntry.fromJson(f))
            .toList(),
      );
}
