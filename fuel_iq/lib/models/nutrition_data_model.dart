import 'food_entry.dart';

class NutritionData {
  double calories;
  double protein;
  double carbs;
  double fats;
  double water;

  NutritionTargets targets;
  List<FoodEntry> foods;

  NutritionData({
    this.calories = 0,
    this.protein = 0,
    this.carbs = 0,
    this.fats = 0,
    this.water = 0,
    NutritionTargets? targets,
    List<FoodEntry>? foods,
  })  : targets = targets ?? NutritionTargets(),
        foods = foods ?? [];

  Map<String, dynamic> toJson() => {
        'calories': calories,
        'protein': protein,
        'carbs': carbs,
        'fats': fats,
        'water': water,
        'targets': targets.toJson(),
        'foods': foods.map((f) => f.toJson()).toList(),
      };

  factory NutritionData.fromJson(Map<String, dynamic> json) {
    return NutritionData(
      calories: (json['calories'] ?? 0).toDouble(),
      protein: (json['protein'] ?? 0).toDouble(),
      carbs: (json['carbs'] ?? 0).toDouble(),
      fats: (json['fats'] ?? 0).toDouble(),
      water: (json['water'] ?? 0).toDouble(),
      targets: NutritionTargets.fromJson(
        Map<String, dynamic>.from(json['targets'] ?? {}),
      ),
      foods: (json['foods'] as List? ?? [])
          .map((f) => FoodEntry.fromJson(
                Map<String, dynamic>.from(f),
              ))
          .toList(),
    );
  }
}

class NutritionTargets {
  double calories;
  double protein;
  double carbs;
  double fats;
  double water;

  NutritionTargets({
    this.calories = 2300,
    this.protein = 150,
    this.carbs = 250,
    this.fats = 70,
    this.water = 3,
  });

  Map<String, dynamic> toJson() => {
        'calories': calories,
        'protein': protein,
        'carbs': carbs,
        'fats': fats,
        'water': water,
      };

  factory NutritionTargets.fromJson(Map<String, dynamic> json) {
    return NutritionTargets(
      calories: (json['calories'] ?? 2300).toDouble(),
      protein: (json['protein'] ?? 150).toDouble(),
      carbs: (json['carbs'] ?? 250).toDouble(),
      fats: (json['fats'] ?? 70).toDouble(),
      water: (json['water'] ?? 3).toDouble(),
    );
  }
}
