import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fuel_iq/globals/user_data.dart';
import 'package:fuel_iq/pages/main/home_page.dart';
import 'package:fuel_iq/services/daily_data_provider.dart';
import 'package:fuel_iq/theme/colors.dart';
import 'package:provider/provider.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key});

  

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}
class _DetailsPageState extends State<DetailsPage> {

  DateTime? selectedDate;

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(), // default to today
      firstDate: DateTime(2000), // earliest date allowed
      lastDate: DateTime(2100),  // latest date allowed
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        // Check if picked date is today
        final pickedStr = "${picked.day}-${picked.month}-${picked.year}";
        if (pickedStr == todaysDate) {
          selectedDate = null; // Keep null for today
        } else {
          selectedDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Details',
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

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 8),

            //Date Picker
            InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: _pickDate,
              child: Ink(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary.withValues(alpha: 0.15),
                      colorScheme.primary.withValues(alpha: 0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: colorScheme.primary.withValues(alpha: 0.4),
                    width: 1.2,
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calendar_today_rounded,
                        color: colorScheme.primary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      selectedDate != null
                          ? "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}"
                          : todaysDate,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.expand_more_rounded,
                        color: colorScheme.primary, size: 22),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            //Page content
            Expanded(
              child: DailyData(
                showAppBar: false,
                key: ValueKey(selectedDate),
                dateSelected: selectedDate != null
                    ? "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}"
                    : todaysDate,
              ),
            ),
          ],
        ),
      ),
    );
  }

}


class DailyData extends StatefulWidget {
  final String dateSelected;
  final bool showAppBar;


  const DailyData({super.key, required this.dateSelected, required this.showAppBar});
  
  @override
  State<DailyData> createState() => _DailyDataState();
}


class _DailyDataState extends State<DailyData> {
@override
  void initState() {
    super.initState();
    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DailyDataProvider>(context, listen: false)
          .loadDailyData(widget.dateSelected);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final dailyData = context.watch<DailyDataProvider>().getDailyData(widget.dateSelected);
    final caloriesEaten = (dailyData?['calories'] ?? 0).toDouble();
    final proteinEaten = (dailyData?['protein'] ?? 0).toDouble();
    final carbsEaten = (dailyData?['carbs'] ?? 0).toDouble();
    final fatsEaten = (dailyData?['fats'] ?? 0).toDouble();
    final waterDrunk = (dailyData?['water'] ?? 0).toDouble();
    final weightToday = (dailyData?['weight'] ?? 0).toDouble();
    
    final foods = context.watch<DailyDataProvider>().getDailyData(widget.dateSelected)?['foods'] ?? [];

    return Scaffold(
      //app bar
      appBar: widget.showAppBar ? AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Today\'s Data',
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
      ) : null,

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Column(
                children: [
                  //calories eaten
                  Card(
                    elevation: 3,
                    color: colorScheme.surface,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${(caloriesTarget - caloriesEaten).toInt()}',
                                    style: TextStyle(
                                      fontSize: MediaQuery.of(context).size.width * 0.13,
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.onSurface,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Calories Left',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                                      fontWeight: FontWeight.w500,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            MacroTile(
                              eaten: caloriesEaten,
                              goal: caloriesTarget,
                              size: 80,
                              bgColor: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                              fgColor: colorScheme.onSurface,
                              icon: FontAwesomeIcons.fireFlameCurved,
                              strokeWidth: 7,
                              label: 'Calories',
                            ),
                          ],
                        ),
                      )
                    ),
                  ),
                  // Macros
                  Row(
                    children: [
                      // Protein
                      Expanded(
                        child: Card(
                          elevation: 2,
                          color: theme.cardColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                            child: Column(
                              children: [
                                MacroTile(
                                  label: 'Protein',
                                  eaten: proteinEaten,
                                  goal: proteinTarget,
                                  bgColor: colorScheme.onSurface.withValues(alpha: 0.1),
                                  fgColor: AppColors.proteinColor,
                                  icon: FontAwesomeIcons.drumstickBite,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Protein',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${proteinEaten.toInt()}/${proteinTarget.toInt()}g',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Carbs
                      Expanded(
                        child: Card(
                          elevation: 2,
                          color: theme.cardColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                            child: Column(
                              children: [
                                MacroTile(
                                  label: 'Carbs',
                                  eaten: carbsEaten,
                                  goal: carbsTarget,
                                  bgColor: colorScheme.onSurface.withValues(alpha: 0.1),
                                  fgColor: AppColors.carbsColor,
                                  icon: FontAwesomeIcons.breadSlice,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Carbs',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${carbsEaten.toInt()}/${carbsTarget.toInt()}g',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Fats
                      Expanded(
                        child: Card(
                          elevation: 2,
                          color: theme.cardColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                            child: Column(
                              children: [
                                MacroTile(
                                  label: 'Fats',
                                  eaten: fatsEaten,
                                  goal: fatsTarget,
                                  bgColor: colorScheme.onSurface.withValues(alpha: 0.1),
                                  fgColor: AppColors.fatColor,
                                  icon: FontAwesomeIcons.seedling,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Fats',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${fatsEaten.toInt()}/${fatsTarget.toInt()}g',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    //Water
                    Expanded(
                      child: Card(
                        elevation: 2,
                        color: theme.cardColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                          child: Column(
                            children: [
                              MacroTile(
                                label: 'Water',
                                eaten: waterDrunk,
                                goal: waterTarget,
                                bgColor: colorScheme.onSurface.withValues(alpha: 0.1),
                                fgColor: AppColors.waterColor,
                                icon: FontAwesomeIcons.glassWater,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Water',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${waterDrunk.toInt()}/${waterTarget.toInt()}L',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    //Weight
                    Expanded(
                      child: Card(
                        elevation: 3,
                        color: theme.cardColor,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                      '${weightToday.toString()}kg',
                                      style: TextStyle(
                                        fontSize: MediaQuery.of(context).size.width * 0.07,
                                        fontWeight: FontWeight.bold,
                                        color: colorScheme.onSurface,
                                      ),
                                    ),
                              const SizedBox(height: 12),
                              Text(
                                'Weight',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ],
                          )
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  const Expanded(
                    child: Divider(thickness: 1.2, endIndent: 10),
                  ),
                  Text(
                    "Food",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.85),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const Expanded(
                    child: Divider(thickness: 1.2, indent: 10),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              foods.isEmpty
              ? const Center(child: Text('No foods logged yet'))
              : ListView.builder(
                shrinkWrap: true, // 🔹 allows list to fit inside scroll view
                physics: const NeverScrollableScrollPhysics(), // 🔹 disables internal scroll
                itemCount: foods.length,
                itemBuilder: (context, index) {
                  final food = foods[index];
                  return FoodCard(
                    food: {
                      'name': food['name'],
                      'quantity': food['quantity'],
                      'calories': food['calories'],
                      'protein': food['protein'],
                      'carbs': food['carbs'],
                      'fats': food['fats'],
                    },
                    todaysDate: todaysDate,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class FoodView extends StatefulWidget {
  
  final String foodName;
  final double quantity;
  final double calories;
  final double protein;
  final double carbs;
  final double fats;
  final String dateOfFood;


  const FoodView({super.key,
                  required this.foodName,
                  required this.quantity,
                  required this.calories,
                  required this.protein,
                  required this.carbs,
                  required this.fats,
                  required this.dateOfFood
                  });

  @override
  State<FoodView> createState() => _FoodViewState();
}

class _FoodViewState extends State<FoodView> {
  @override
  Widget build(BuildContext context) {
    //theme
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      //app bar
      appBar: AppBar(
        title:  Text(
          widget.foodName,
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
      //body
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 20),

              // Quantity
              Card(
                elevation: 3,
                child: ListTile(
                  title: const Text('Quantity'),
                  trailing: Text('${widget.quantity.toStringAsFixed(1)} g'),
                ),
              ),
              const SizedBox(height: 8),

              // Calories
              Card(
                elevation: 3,
                child: ListTile(
                  title: const Text('Calories'),
                  trailing: Text('${widget.calories.toStringAsFixed(0)} kcal'),
                ),
              ),
              const SizedBox(height: 8),

              // Protein
              Card(
                elevation: 3,
                child: ListTile(
                  title: const Text('Protein'),
                  trailing: Text('${widget.protein.toStringAsFixed(1)} g'),
                ),
              ),
              const SizedBox(height: 8),

              // Carbs
              Card(
                elevation: 3,
                child: ListTile(
                  title: const Text('Carbs'),
                  trailing: Text('${widget.carbs.toStringAsFixed(1)} g'),
                ),
              ),
              const SizedBox(height: 8),

              // Fats
              Card(
                elevation: 3,
                child: ListTile(
                  title: const Text('Fats'),
                  trailing: Text('${widget.fats.toStringAsFixed(1)} g'),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: Colors.redAccent,
        child: const Icon(Icons.delete, color: Colors.white),
        onPressed: () async {
          // ✅ Confirm deletion
          final confirm = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Delete Food'),
              content: Text('Are you sure you want to delete "$widget.foodName"?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Delete', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          );
          if (!context.mounted) return;
          if (confirm == true) {
            final provider = Provider.of<DailyDataProvider>(context, listen: false);

            // ✅ Delete the specific food
            await provider.deleteFood(widget.dateOfFood, widget.foodName);

            if (context.mounted) {
              Navigator.pop(context); // Go back after deletion
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${widget.foodName} deleted successfully')),
              );
            }
          }
        },
      )

    );
  }
}




class FoodCard extends StatelessWidget {
  final Map<String, dynamic> food;
  final String todaysDate;

  const FoodCard({
    super.key,
    required this.food,
    required this.todaysDate,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: colorScheme.surface,
      shadowColor: colorScheme.shadow.withValues(alpha: 0.15),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => FoodView(
                foodName: food['name'],
                quantity: food['quantity'],
                calories: food['calories'],
                protein: food['protein'],
                carbs: food['carbs'],
                fats: food['fats'],
                dateOfFood: todaysDate,
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: FadeTransition(opacity: animation, child: child),
                );
              },
              transitionDuration: const Duration(milliseconds: 180),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🧾 Text info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Food name (handles long names)
                    Text(
                      food['name'],
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),

                    // Quantity + Calories
                    Row(
                      children: [
                        Icon(Icons.scale_rounded,
                            size: 16,
                            color: colorScheme.onSurface.withValues(alpha: 0.6)),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            '${food['quantity']}g',
                            style: TextStyle(
                              color: colorScheme.onSurface.withValues(alpha: 0.7),
                              fontSize: 13,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Icon(Icons.local_fire_department_rounded,
                            size: 16, color: colorScheme.onSurface),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            '${food['calories']} kcal',
                            style: TextStyle(
                              color: colorScheme.onSurface.withValues(alpha: 0.7),
                              fontSize: 13,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // ⚡ Macros Row (responsive Wrap)
                    Wrap(
                      spacing: 10,
                      runSpacing: 4,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.fitness_center_rounded,
                                size: 16, color: AppColors.proteinColor),
                            const SizedBox(width: 4),
                            Text(
                              'P: ${food['protein']}g',
                              style: TextStyle(
                                color:
                                    colorScheme.onSurface.withValues(alpha: 0.8),
                                fontSize: 12.5,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.breakfast_dining_rounded,
                                size: 16, color: AppColors.carbsColor),
                            const SizedBox(width: 4),
                            Text(
                              'C: ${food['carbs']}g',
                              style: TextStyle(
                                color:
                                    colorScheme.onSurface.withValues(alpha: 0.8),
                                fontSize: 12.5,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.water_drop_rounded,
                                size: 16, color: AppColors.fatColor),
                            const SizedBox(width: 4),
                            Text(
                              'F: ${food['fats']}g',
                              style: TextStyle(
                                color:
                                    colorScheme.onSurface.withValues(alpha: 0.8),
                                fontSize: 12.5,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ➡️ Chevron
              Icon(Icons.chevron_right_rounded,
                  color: colorScheme.onSurface.withValues(alpha: 0.5)),
            ],
          ),
        ),
      ),
    );
  }
}
