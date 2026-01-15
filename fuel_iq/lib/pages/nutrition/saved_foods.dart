import 'package:flutter/material.dart';
import 'package:fuel_iq/globals/user_data.dart';
import 'package:fuel_iq/models/food_entry.dart';
import 'package:fuel_iq/providers/daily_data_provider.dart';
import 'package:fuel_iq/providers/saved_foods_provider.dart';
import 'package:fuel_iq/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class SavedFoods extends StatelessWidget {
  const SavedFoods({super.key});

  @override
  Widget build(BuildContext context) {
    //theme
    //final theme = Theme.of(context);
    //final colorScheme = theme.colorScheme;
    return Scaffold(
      //app bar
      appBar: CustomAppBar(title: "saved food"),
      body: Consumer<SavedFoodsProvider>(
        builder: (context, savedFoodsProvider, child) {
          final savedFoods = savedFoodsProvider.getAllSavedFoodsWithDetails();
          
          if (savedFoods.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.restaurant_menu, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No saved foods yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }
          
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: savedFoods.length,
            itemBuilder: (context, index) {
              final food = savedFoods[index];
              final foodName = food['name'];
              final foodId = food['id'];
              final calories = food['calories'] ?? 0.0;
              final protein = food['protein'] ?? 0.0;
              final carbs = food['carbs'] ?? 0.0;
              final fats = food['fats'] ?? 0.0;
              final quantity = food['quantity'] ?? 0.0;
              final time = food['time'] ?? 'Not specified';
              
              return SavedFoodWidget(foodName: foodName, foodId: foodId, calories: calories, protein: protein, carbs: carbs, fats: fats, quantity: quantity, time: time);
            },
          );
        },
      ),
    );
  }
}

class SavedFoodWidget extends StatelessWidget {

  final String foodName;
  final String foodId;
  final double calories;
  final double protein;
  final double carbs;
  final double fats;
  final double quantity;
  final String time;
  
  const SavedFoodWidget({
    super.key,
    required this.foodName,
    required this.foodId,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.quantity,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Dismissible(
            key: ValueKey(foodId),
            direction: DismissDirection.horizontal,
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.endToStart) {
                // Show confirmation dialog
                return await showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Delete Food'),
                      content: Text('Remove "$foodName" from Saved Foods?'),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                          child: const Text('Delete'),
                        ),
                      ],
                    );
                  },
                );
              }
              if (direction == DismissDirection.startToEnd) {
                // ADD FOOD
                final entry = FoodEntry(
                  id: const Uuid().v4(),
                  name: foodName,
                  calories: calories,
                  protein: protein,
                  carbs: carbs,
                  fats: fats,
                  quantity: quantity,
                  time: time
                );
        
                final dailyDataProvider = Provider.of<DailyDataProvider>(context, listen: false);
                await dailyDataProvider.addFood(todaysDate, entry);
                
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$foodName added to today')),
                  );
                }
                return false;
              }
              return false;
            },
            onDismissed: (direction) async {
              if (direction == DismissDirection.endToStart) {
                final savedFoodsProvider = Provider.of<SavedFoodsProvider>(context, listen: false);
                await savedFoodsProvider.deleteFood(foodId);
                
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$foodName deleted'),
                      duration: const Duration(milliseconds: 1500),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              }
            },
            background: Container(
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 20),
              child: const Icon(Icons.add, color: Colors.white, size: 28),
            ),
        
            secondaryBackground: Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(Icons.delete, color: Colors.white, size: 28),
            ),
            child: Card(
              margin: EdgeInsets.zero,
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(
                    foodName.substring(0, 1).toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(
                  foodName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text('Quantity: ${quantity.toStringAsFixed(0)}g'),
                    Text('Time: $time'),
                    const SizedBox(height: 4),
                    Text(
                      'Cal: ${calories.toStringAsFixed(0)} | '
                      'P: ${protein.toStringAsFixed(1)}g | '
                      'C: ${carbs.toStringAsFixed(1)}g | '
                      'F: ${fats.toStringAsFixed(1)}g',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                isThreeLine: true,
              ),
            ),
          ),
                  ),
      ],
    );
  }
}