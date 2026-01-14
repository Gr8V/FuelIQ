import 'package:fuel_iq/models/nutrition_data_model.dart';
import 'package:fuel_iq/models/workout_data_model.dart';

class DailyDataModel {
  NutritionData nutrition;
  WorkoutData workout;
  CardioData cardio;

  List<String> supplements;
  double weight;

  DailyDataModel({
    NutritionData? nutrition,
    WorkoutData? workout,
    CardioData? cardio,
    List<String>? supplements,
    this.weight = 0.0,
  })  : nutrition = nutrition ?? NutritionData(),
        workout = workout ?? WorkoutData(),
        cardio = cardio ?? CardioData(),
        supplements = supplements ?? [];

  Map<String, dynamic> toJson() => {
        'nutrition': nutrition.toJson(),
        'workout': workout.toJson(),
        'cardio': cardio.toJson(),
        'supplements': supplements,
        'weight': weight,
      };

  factory DailyDataModel.fromJson(Map<String, dynamic> json) {
    return DailyDataModel(
      nutrition: NutritionData.fromJson(
        Map<String, dynamic>.from(json['nutrition'] ?? {}),
      ),
      workout: WorkoutData.fromJson(
        Map<String, dynamic>.from(json['workout'] ?? {}),
      ),
      cardio: CardioData.fromJson(
        Map<String, dynamic>.from(json['cardio'] ?? {}),
      ),
      supplements: List<String>.from(json['supplements'] ?? []),
      weight: (json['weight'] ?? 0).toDouble(),
    );
  }
}
