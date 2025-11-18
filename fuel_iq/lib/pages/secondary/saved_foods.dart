import 'package:flutter/material.dart';
import 'package:fuel_iq/globals/user_data.dart';
import 'package:fuel_iq/services/daily_data_provider.dart';
import 'package:provider/provider.dart';

class SavedFoods extends StatelessWidget {
  const SavedFoods({super.key});

  @override
  Widget build(BuildContext context) {
    //theme
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final savedFoods = context.watch<DailyDataProvider>().savedFoods;
    return Scaffold(
      //app bar
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Saved Foods',
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
      body: Consumer<DailyDataProvider>(
        builder: (context, provider, child) {
          final savedFoods = provider.getAllSavedFoodsWithDetails();
          
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
              final calories = food['calories'] ?? 0.0;
              final protein = food['protein'] ?? 0.0;
              final carbs = food['carbs'] ?? 0.0;
              final fats = food['fats'] ?? 0.0;
              final quantity = food['quantity'] ?? 0.0;
              final time = food['time'] ?? 'Not specified';
              
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
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
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Quick add button
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                        tooltip: 'Add to today',
                        onPressed: () async {
                          
                          final foodEntry = {
                            'foodName': foodName,
                            'quantity': quantity,
                            'calories': calories,
                            'protein': protein,
                            'carbs': carbs,
                            'fats': fats,
                            'time': time,
                          };
                          
                          await provider.addFood(todaysDate, foodEntry);
                          
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('$foodName added to today')),
                            );
                          }
                        },
                      ),
                      // Delete button
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        tooltip: 'Delete',
                        onPressed: () async {
                          // Confirm deletion
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Food'),
                              content: Text('Delete "$foodName" from saved foods?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );
                          
                          if (confirm == true) {
                            await provider.deleteSavedFood(foodName);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('$foodName deleted')),
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}