import 'package:flutter/material.dart';
import 'package:fuel_iq/pages/main/home_page.dart';
import 'package:fuel_iq/services/daily_data_provider.dart';
import 'package:provider/provider.dart';

class LogFood extends StatefulWidget {
  const LogFood({super.key});

  @override
  State<LogFood> createState() => _LogFoodState();
}

class _LogFoodState extends State<LogFood> {
  final foodNameController = TextEditingController();
  final quantityController = TextEditingController();
  final caloriesController = TextEditingController();
  final proteinController = TextEditingController();
  final carbsController = TextEditingController();
  final fatsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      //app bar
      appBar: AppBar(
        title:  Text(
          "Log Food",
          style: TextStyle(
            color: colorScheme.onPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.25,
            height: 1.3,
          ),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
      ),
      body:  SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Food Name
              TextField(
                controller: foodNameController,
                decoration: InputDecoration(
                  labelText: 'Food Name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
        
              // Quantity (grams/ml)
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Quantity (g/ml)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
        
              // Calories
              TextField(
                controller: caloriesController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Calories',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
        
              // Protein
              TextField(
                controller: proteinController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Protein (g)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
        
              // Carbs
              TextField(
                controller: carbsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Carbs (g)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
        
              // Fats
              TextField(
                controller: fatsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Fats (g)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 24),
        
              // Save Button
              ElevatedButton(
                onPressed: () async {
                  final provider = Provider.of<DailyDataProvider>(context, listen: false);

                  //gets current calorie data
                  final currentData = provider.getDailyData(todaysDate) ?? {
                    'calories': 0.0,
                    'protein': 0.0,
                    'carbs': 0.0,
                    'fats': 0.0,
                    'water': 0.0,
                    'weight': 0.0,
                  };
                  final String foodName = foodNameController.text.trim();
                  final double? calories = double.tryParse(caloriesController.text.trim());
        
                  // Only add if name and calories are valid
                  if (foodName.isNotEmpty && calories != null) {
                    final foodEntry = {
                      'name': foodName,
                      'quantity': double.tryParse(quantityController.text.trim()) ?? 0,
                      'calories': calories,
                      'protein': double.tryParse(proteinController.text.trim()) ?? 0,
                      'carbs': double.tryParse(carbsController.text.trim()) ?? 0,
                      'fats': double.tryParse(fatsController.text.trim()) ?? 0,
                    };
                  // Sum the totals
                  final updatedData = {
                    'calories': (currentData['calories'] ?? 0.0) + foodEntry['calories'],
                    'protein': (currentData['protein'] ?? 0.0) + foodEntry['protein'],
                    'carbs': (currentData['carbs'] ?? 0.0) + foodEntry['carbs'],
                    'fats': (currentData['fats'] ?? 0.0) + foodEntry['fats'],
                    'water': currentData['water'],
                    'weight': currentData['weight'],
                  };
        
        
                    await provider.addFood(todaysDate, foodEntry);
                    await provider.updateDailyData(todaysDate, updatedData);
        
                    // Optional: clear fields after adding
                    foodNameController.clear();
                    quantityController.clear();
                    caloriesController.clear();
                    proteinController.clear();
                    carbsController.clear();
                    fatsController.clear();
        
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Food added successfully!')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a valid food name and calories')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Add Food',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}