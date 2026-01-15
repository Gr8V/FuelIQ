import 'package:flutter/material.dart';
import 'package:fuel_iq/pages/main/log/log_food_page.dart';
import 'package:fuel_iq/providers/saved_foods_provider.dart';
import 'package:fuel_iq/utils/utils.dart';
import 'package:provider/provider.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Dismissible(
        key: ValueKey(foodId),
        direction: DismissDirection.horizontal,
        confirmDismiss: (direction) => _handleDismiss(context, direction),
        onDismissed: (direction) => _onDismissed(context, direction),
        background: _buildSwipeBackground(
          alignment: Alignment.centerLeft,
          color: Colors.green,
          icon: Icons.add_circle_outline,
          label: 'Add',
        ),
        secondaryBackground: _buildSwipeBackground(
          alignment: Alignment.centerRight,
          color: Colors.red,
          icon: Icons.delete_outline,
          label: 'Delete',
        ),
        child: _buildCard(context),
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 2,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          _navigateToLogFood(context);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 12),
              _buildNutritionInfo(),
              const SizedBox(height: 8),
              _buildMetadata(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Text(
            foodName,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.orange.shade200, width: 1),
          ),
          child: Text(
            '${calories.toStringAsFixed(0)} cal',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.orange.shade900,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNutritionInfo() {
    return Wrap(
      spacing: 2,
      runSpacing: 4,
      children: [
        _buildNutrientChip('P', protein),
        const SizedBox(width: 8),
        _buildNutrientChip('C', carbs),
        const SizedBox(width: 8),
        _buildNutrientChip('F', fats),
      ],
    );
  }

  Widget _buildNutrientChip(String label, double value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade700,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade500, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade200,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '${value.toStringAsFixed(1)}g',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade100,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetadata() {
    return Wrap(
      spacing: 2,
      runSpacing: 4,
      children: [
        Icon(Icons.scale_outlined, size: 14, color: Colors.grey.shade600),
        const SizedBox(width: 4),
        Text(
          '${quantity.toStringAsFixed(0)}g',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 16),
        Icon(Icons.access_time, size: 14, color: Colors.grey.shade600),
        const SizedBox(width: 4),
        Text(
          time,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSwipeBackground({
    required Alignment alignment,
    required Color color,
    required IconData icon,
    required String label,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Future<bool?> _handleDismiss(BuildContext context, DismissDirection direction) async {
    if (direction == DismissDirection.endToStart) {
      return await _showDeleteDialog(context);
    }
    
    if (direction == DismissDirection.startToEnd) {
      _navigateToLogFood(context);
      return false;
    }
    
    return false;
  }

  Future<bool?> _showDeleteDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Food'),
          content: Text('Remove "$foodName" from Saved Foods?'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
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

  void _navigateToLogFood(BuildContext context) {
    pushWithSlideFade(
      context,
      LogFood(
        defaultFoodName: foodName,
        defaultCalories: calories.toStringAsFixed(1),
        defaultProtein: protein.toStringAsFixed(1),
        defaultCarbs: carbs.toStringAsFixed(1),
        defaultFats: fats.toStringAsFixed(1),
        defaultQuantity: quantity.toStringAsFixed(1),
      ),
    );
  }

  Future<void> _onDismissed(BuildContext context, DismissDirection direction) async {
    if (direction == DismissDirection.endToStart) {
      final savedFoodsProvider = Provider.of<SavedFoodsProvider>(context, listen: false);
      await savedFoodsProvider.deleteFood(foodId);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.delete, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text('$foodName deleted')),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            duration: const Duration(seconds: 2),
            action: SnackBarAction(
              label: 'UNDO',
              textColor: Colors.white,
              onPressed: () {
                // Implement undo functionality if needed
              },
            ),
          ),
        );
      }
    }
  }
}