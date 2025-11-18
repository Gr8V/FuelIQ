class FoodEntry {
  final String name;
  final double calories;
  final double protein;
  final double carbs;
  final double fats;
  final double quantity;
  final String time;

  FoodEntry({
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.quantity,
    required this.time
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'calories': calories,
        'protein': protein,
        'carbs': carbs,
        'fats': fats,
        'quantity': quantity,
        'time':time
      };

  factory FoodEntry.fromJson(Map<String, dynamic> json) => FoodEntry(
        name: json['name'],
        calories: (json['calories'] ?? 0).toDouble(),
        protein: (json['protein'] ?? 0).toDouble(),
        carbs: (json['carbs'] ?? 0).toDouble(),
        fats: (json['fats'] ?? 0).toDouble(),
        quantity: (json['quantity'] ?? 0).toDouble(),
        time: (json['time']),
      );
}
