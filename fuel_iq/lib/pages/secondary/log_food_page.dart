import 'package:flutter/material.dart';
import 'package:fuel_iq/globals/user_data.dart';
import 'package:fuel_iq/services/daily_data_provider.dart';
import 'package:fuel_iq/services/local_storage.dart';

import 'package:fuel_iq/services/utils.dart';
import 'package:provider/provider.dart';
class LogFood extends StatefulWidget {
  const LogFood({super.key});

  @override
  State<LogFood> createState() => _LogFoodState();
}

class _LogFoodState extends State<LogFood> {
  final _formKey = GlobalKey<FormState>();

  final foodNameController = TextEditingController();
  final quantityController = TextEditingController();
  final caloriesController = TextEditingController();
  final proteinController = TextEditingController();
  final carbsController = TextEditingController();
  final fatsController = TextEditingController();

  String? time;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Log Food',
          style: TextStyle(
            color: colorScheme.primary,
            fontWeight: FontWeight.w700,
            fontSize: 22,
            letterSpacing: 1.1,
            fontFamily: 'Poppins',
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorScheme.onSurface.withValues(alpha: 0.1),
                colorScheme.surface.withValues(alpha: 0.1),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              /// FOOD NAME
              TextFormField(
                controller: foodNameController,
                decoration: InputDecoration(
                  labelText: 'Food Name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Food name cannot be empty";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              /// TIME
              DropTile(
                label: "Time",
                value: time,
                options: ["Breakfast", "Lunch", "Snacks", "Dinner"],
                onChanged: (val) => setState(() => time = val),
              ),

              const SizedBox(height: 16),

              /// QUANTITY
              TextFormField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Quantity (g/ml)',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter quantity";
                  }
                  final numValue = double.tryParse(value);
                  if (numValue == null) {
                    return "Enter a number";
                  }
                  if (numValue < 0) {
                    return "Value cannot be negative";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              /// CALORIES
              TextFormField(
                controller: caloriesController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Calories',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter calories";
                  }
                  final numValue = double.tryParse(value);
                  if (numValue == null) {
                    return "Enter a number";
                  }
                  if (numValue < 0) {
                    return "Value cannot be negative";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              /// PROTEIN
              TextFormField(
                controller: proteinController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Protein (g)',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter protein";
                  }
                  final numValue = double.tryParse(value);
                  if (numValue == null) {
                    return "Enter a number";
                  }
                  if (numValue < 0) {
                    return "Value cannot be negative";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              /// CARBS
              TextFormField(
                controller: carbsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Carbs (g)',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter carbs";
                  }
                  final numValue = double.tryParse(value);
                  if (numValue == null) {
                    return "Enter a number";
                  }
                  if (numValue < 0) {
                    return "Value cannot be negative";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              /// FATS
              TextFormField(
                controller: fatsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Fats (g)',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter fats";
                  }
                  final numValue = double.tryParse(value);
                  if (numValue == null) {
                    return "Enter a number";
                  }
                  if (numValue < 0) {
                    return "Value cannot be negative";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              /// SAVE BUTTON
              ElevatedButton(
                onPressed: () async {
                  if (time == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please select time')),
                    );
                    return;
                  }
                  if (!_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please correct the errors')),
                    );
                    return;
                  }

                  final provider = Provider.of<DailyDataProvider>(context, listen: false);

                  String foodName = foodNameController.text.trim();
                  double quantity = double.parse(quantityController.text);
                  double calories = double.parse(caloriesController.text);
                  double protein = double.parse(proteinController.text);
                  double carbs = double.parse(carbsController.text);
                  double fats = double.parse(fatsController.text);
                  
                  final foodEntry = {
                    'foodName': foodName,  // Changed from 'name' to 'foodName' for consistency
                    'quantity': quantity,
                    'calories': calories,
                    'protein': protein,
                    'carbs': carbs,
                    'fats': fats,
                    'time': time,
                  };

                  // This single call handles everything:
                  // - Adds the food entry
                  // - Updates the daily totals
                  // - Saves to storage
                  await provider.addFood(todaysDate, foodEntry);
                  
                  // Save to saved foods list
                  await provider.saveFood(
                    foodName: foodName,
                    time: time ?? 'No Time',
                    quantity: quantity,
                    calories: calories,
                    protein: protein,
                    carbs: carbs,
                    fats: fats,
                  );

                  foodNameController.clear();
                  quantityController.clear();
                  caloriesController.clear();
                  proteinController.clear();
                  carbsController.clear();
                  fatsController.clear();

                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Food added successfully!')),
                  );

                  Navigator.pop(context);
                },
                child: const Text('Add Food', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
