import 'package:fuel_iq/models/nutrition_data_model.dart';
import 'package:fuel_iq/models/workout_data_model.dart';

class DailyDataModel {
  NutritionData nutrition;
  WorkoutData workout;
  CardioData cardio;

  Map<String, bool> supplements;
  double weight;

  DailyDataModel({
    NutritionData? nutrition,
    WorkoutData? workout,
    CardioData? cardio,
    Map<String, bool>? supplements,
    this.weight = 0.0,
  })  : nutrition = nutrition ?? NutritionData(),
        workout = workout ?? WorkoutData(),
        cardio = cardio ?? CardioData(),
        supplements = supplements ?? {};

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
      supplements: Map<String, bool>.from(
        json['supplements'] ?? {},
      ),
      weight: (json['weight'] ?? 0).toDouble(),
    );
  }
}


/*
DAILY DATA MODAL JSON VISUALIZATION
{
  "nutrition": {
    "calories": 0.0,
    "protein": 0.0,
    "carbs": 0.0,
    "fats": 0.0,
    "water": 3.0,
    "targets": {
      "calories": 2300.0,
      "protein": 150.0,
      "carbs": 250.0,
      "fats": 70.0,
      "water": 3.0
    },
    "foods": []
  },

  "workout": {
    "name": "Push Day",
    "exercises": [],
    "duration": 0
  },

  "cardio": {
    "type": "Walking",
    "steps": 0,
    "calories": 0
  },

  "supplements": {
    "Creatine": true,
    "Whey": false,
    "Multivitamin": true
  }

  "weight": 0.0
}*/