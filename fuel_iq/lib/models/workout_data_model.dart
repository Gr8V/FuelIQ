class WorkoutData {
  String name;
  List<Map<String, dynamic>> exercises;
  int duration; // minutes

  WorkoutData({
    this.name = '',
    List<Map<String, dynamic>>? exercises,
    this.duration = 0,
  }) : exercises = exercises ?? [];

  Map<String, dynamic> toJson() => {
        'name': name,
        'exercises': exercises,
        'duration': duration,
      };

  factory WorkoutData.fromJson(Map<String, dynamic> json) {
    return WorkoutData(
      name: json['name'] ?? '',
      exercises: List<Map<String, dynamic>>.from(
        json['exercises'] ?? [],
      ),
      duration: json['duration'] ?? 0,
    );
  }
}

class CardioData {
  String type;
  int steps;
  double calories;

  CardioData({
    this.type = '',
    this.steps = 0,
    this.calories = 0,
  });

  Map<String, dynamic> toJson() => {
        'type': type,
        'steps': steps,
        'calories': calories,
      };

  factory CardioData.fromJson(Map<String, dynamic> json) {
    return CardioData(
      type: json['type'] ?? '',
      steps: json['steps'] ?? 0,
      calories: (json['calories'] ?? 0).toDouble(),
    );
  }
}
