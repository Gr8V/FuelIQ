import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fuel_iq/globals/user_data.dart';
import 'package:fuel_iq/services/utils.dart';
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
        final dailyCalorieTarget = 
    ((dailyData?['calorieTarget'] ?? 0).toDouble() != 0)
        ? (dailyData?['calorieTarget'] ?? 0).toDouble()
        : defaultCaloriesTarget.toDouble();

    final dailyProteinTarget = 
        ((dailyData?['proteinTarget'] ?? 0).toDouble() != 0)
            ? (dailyData?['proteinTarget'] ?? 0).toDouble()
            : defaultProteinTarget.toDouble();

    final dailyCarbsTarget = 
        ((dailyData?['carbsTarget'] ?? 0).toDouble() != 0)
            ? (dailyData?['carbsTarget'] ?? 0).toDouble()
            : defaultCaloriesTarget.toDouble();

    final dailyFatsTarget = 
        ((dailyData?['fatsTarget'] ?? 0).toDouble() != 0)
            ? (dailyData?['fatsTarget'] ?? 0).toDouble()
            : defaultFatsTarget.toDouble();

    final dailyWaterTarget = 
        ((dailyData?['waterTarget'] ?? 0).toDouble() != 0)
            ? (dailyData?['waterTarget'] ?? 0).toDouble()
            : defaultWaterTarget.toDouble();
    
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Builder(
                              builder: (context) {
                                final int difference =
                                    (dailyCalorieTarget - caloriesEaten).toInt();

                                final bool isOver = difference < 0;
                                final int displayValue = difference.abs();

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '$displayValue',
                                      style: TextStyle(
                                        fontSize: MediaQuery.of(context).size.width * 0.13,
                                        fontWeight: FontWeight.bold,
                                        color: isOver
                                            ? Colors.deepOrangeAccent // 🔥 red if over target
                                            : colorScheme.onSurface, // normal color if under
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      isOver ? ' Calories Over' : 'Calories Left',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: isOver
                                            ? Colors.deepOrangeAccent.withValues(alpha: 0.8)
                                            : colorScheme.onSurface.withValues(alpha: 0.6),
                                        fontWeight: FontWeight.w500,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          MacroTile(
                            eaten: caloriesEaten,
                            goal: dailyCalorieTarget,
                            size: 80,
                            bgColor: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                            fgColor: colorScheme.onSurface,
                            icon: FontAwesomeIcons.fireFlameCurved,
                            strokeWidth: 7,
                            label: 'Calories',
                          ),
                        ],
                      ),
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
                                  goal: dailyProteinTarget,
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
                                  '${proteinEaten.toInt()}/${dailyProteinTarget.toInt()}g',
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
                                  goal: dailyCarbsTarget,
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
                                  '${carbsEaten.toInt()}/${dailyCarbsTarget.toInt()}g',
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
                                  goal: dailyFatsTarget,
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
                                  '${fatsEaten.toInt()}/${dailyFatsTarget.toInt()}g',
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
                                goal: dailyWaterTarget,
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
                                '${waterDrunk.toInt()}/${dailyWaterTarget.toInt()}L',
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
              //breakfast foods
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ExpansionTile(
                  title: Text('Breakfast'),
                  children: [
                    Container(
                    child: foods.isEmpty
                    ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Center(child: Text('No foods logged yet')),
                    )
                      : ListView.builder(
                        shrinkWrap: true, // 🔹 allows list to fit inside scroll view
                        physics: const NeverScrollableScrollPhysics(), // 🔹 disables internal scroll
                        itemCount: foods.where((food) => food['time'] == 'Breakfast').length,
                        itemBuilder: (context, index) {
                          final food = foods[index];
                          return FoodCard(
                            food: {
                              'foodName': food['foodName'],
                              'quantity': food['quantity'],
                              'calories': food['calories'],
                              'protein': food['protein'],
                              'carbs': food['carbs'],
                              'fats': food['fats'],
                              'time': food['time']
                            },
                            todaysDate: todaysDate,
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              //lunch foods
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ExpansionTile(
                  title: Text('Lunch'),
                  children: [
                    Container(
                    child: foods.isEmpty
                    ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Center(child: Text('No foods logged yet')),
                    )
                      : ListView.builder(
                        shrinkWrap: true, // 🔹 allows list to fit inside scroll view
                        physics: const NeverScrollableScrollPhysics(), // 🔹 disables internal scroll
                        itemCount: foods.where((food) => food['time'] == 'Lunch').length,
                        itemBuilder: (context, index) {
                          final food = foods[index];
                          return FoodCard(
                            food: {
                              'foodName': food['foodName'],
                              'quantity': food['quantity'],
                              'calories': food['calories'],
                              'protein': food['protein'],
                              'carbs': food['carbs'],
                              'fats': food['fats'],
                              'time': food['time']
                            },
                            todaysDate: todaysDate,
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              //Snacks foods
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ExpansionTile(
                  title: Text('Snacks'),
                  children: [
                    Container(
                    child: foods.isEmpty
                    ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Center(child: Text('No foods logged yet')),
                    )
                      : ListView.builder(
                        shrinkWrap: true, // 🔹 allows list to fit inside scroll view
                        physics: const NeverScrollableScrollPhysics(), // 🔹 disables internal scroll
                        itemCount: foods.where((food) => food['time'] == 'Snacks').length,
                        itemBuilder: (context, index) {
                          final food = foods[index];
                          return FoodCard(
                            food: {
                              'foodName': food['foodName'],
                              'quantity': food['quantity'],
                              'calories': food['calories'],
                              'protein': food['protein'],
                              'carbs': food['carbs'],
                              'fats': food['fats'],
                              'time': food['time']
                            },
                            todaysDate: todaysDate,
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              //dinner foods
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ExpansionTile(
                  title: Text('Dinner'),
                  children: [
                    Container(
                    child: foods.isEmpty
                    ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Center(child: Text('No foods logged yet')),
                    )
                      : ListView.builder(
                        shrinkWrap: true, // 🔹 allows list to fit inside scroll view
                        physics: const NeverScrollableScrollPhysics(), // 🔹 disables internal scroll
                        itemCount: foods.where((food) => food['time'] == 'Dinner').length,
                        itemBuilder: (context, index) {
                          final food = foods[index];
                          return FoodCard(
                            food: {
                              'foodName': food['foodName'],
                              'quantity': food['quantity'],
                              'calories': food['calories'],
                              'protein': food['protein'],
                              'carbs': food['carbs'],
                              'fats': food['fats'],
                              'time': food['time']
                            },
                            todaysDate: todaysDate,
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
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
  final String time;
  final String dateOfFood;


  const FoodView({super.key,
                  required this.foodName,
                  required this.quantity,
                  required this.calories,
                  required this.protein,
                  required this.carbs,
                  required this.fats,
                  required this.time,
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
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          widget.foodName,
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
      //body
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              const SizedBox(height: 20),

              // Time
              Card(
                elevation: 3,
                child: ListTile(
                  title: const Text('Time'),
                  trailing: Text(widget.time),
                ),
              ),
              const SizedBox(height: 8),

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
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  // ===== EDIT BUTTON =====
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                      minimumSize: const Size(110, 40),
                    ),
                    icon: const Icon(Icons.edit, size: 20),
                    label: const Text(
                      "Edit",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) =>
                              EditFood(
                                foodName: widget.foodName,
                                time:  widget.time,
                                quantity: widget.quantity,
                                calories: widget.calories,
                                protein: widget.protein,
                                carbs: widget.carbs,
                                fats: widget.fats,
                                dateOfFood: widget.dateOfFood,
                              ),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(1.0, 0.0),
                                end: Offset.zero,
                              ).animate(animation),
                              child: FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                            );
                          },
                          transitionDuration: const Duration(milliseconds: 150),
                        ),
                      );
                    },
                  ),

                  const SizedBox(width: 16), // spacing between buttons

                  // ===== DELETE BUTTON =====
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                      minimumSize: const Size(110, 40),
                    ),
                    icon: const Icon(Icons.delete, size: 20),
                    label: const Text(
                      "Delete",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete Food'),
                          content: Text(
                            'Are you sure you want to delete "${widget.foodName}"?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );

                      if (!context.mounted) return;

                      if (confirm == true) {
                        final provider =
                            Provider.of<DailyDataProvider>(context, listen: false);

                        await provider.deleteFood(widget.dateOfFood, widget.foodName);

                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('${widget.foodName} deleted successfully'),
                            ),
                          );
                        }
                      }
                    },
                  ),

                ],
              )
            ],
          ),
        ),
      ),
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
      color: colorScheme.tertiary,
      shadowColor: colorScheme.shadow.withValues(alpha: 0.15),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => FoodView(
                foodName: food['foodName'],
                quantity: food['quantity'],
                calories: food['calories'],
                protein: food['protein'],
                carbs: food['carbs'],
                fats: food['fats'],
                time: food['time'],
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
                      food['foodName'],
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
                        Icon(FontAwesomeIcons.weightHanging,
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
                        Icon(FontAwesomeIcons.fireFlameCurved,
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
                            Icon(FontAwesomeIcons.drumstickBite,
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
                            Icon(FontAwesomeIcons.breadSlice,
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
                            Icon(FontAwesomeIcons.seedling,
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


class EditFood extends StatefulWidget {
    final String foodName;
  final double quantity;
  final double calories;
  final double protein;
  final double carbs;
  final double fats;
  final String time;
  final String dateOfFood;

  const EditFood({super.key,
                  required this.foodName,
                  required this.quantity,
                  required this.calories,
                  required this.protein,
                  required this.carbs,
                  required this.fats,
                  required this.time,
                  required this.dateOfFood
                  });

  @override
  State<EditFood> createState() => _EditFoodState();
}

class _EditFoodState extends State<EditFood> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    //theme
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
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
      body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Builder(
                builder: (context) {
                  // ✅ Safe to access here
                  final String foodName = widget.foodName;
                  final double quantity = widget.quantity;
                  final double calories = widget.calories;
                  final double protein = widget.protein;
                  final double carbs = widget.carbs;
                  final double fats = widget.fats;

                  final foodNameController = TextEditingController(text: foodName);
                  final quantityController = TextEditingController(text: quantity.toString());
                  final caloriesController = TextEditingController(text: calories.toString());
                  final proteinController = TextEditingController(text: protein.toString());
                  final carbsController = TextEditingController(text: carbs.toString());
                  final fatsController = TextEditingController(text: fats.toString());
                  String time = widget.time;

                  return Form(
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
                            if (!_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Please correct the errors')),
                              );
                              return;
                            }


                            // NOW your inputs are guaranteed valid
                            final provider =
                                Provider.of<DailyDataProvider>(context, listen: false);

                            final currentData = provider.getDailyData(todaysDate) ?? {
                              'calories': 0.0,
                              'protein': 0.0,
                              'carbs': 0.0,
                              'fats': 0.0,
                              'water': 0.0,
                              'weight': 0.0,
                            };

                            final foodEntry = {
                              'foodName': foodNameController.text.trim(),
                              'quantity': double.parse(quantityController.text),
                              'calories': double.parse(caloriesController.text),
                              'protein': double.tryParse(proteinController.text) ?? 0,
                              'carbs': double.tryParse(carbsController.text) ?? 0,
                              'fats': double.tryParse(fatsController.text) ?? 0,
                              'time': time,
                            };

                            final updatedData = {
                              'calories': (currentData['calories']-widget.calories)+ foodEntry['calories'],
                              'protein': (currentData['protein']-widget.protein) + foodEntry['protein'],
                              'carbs': (currentData['carbs']-widget.carbs) + foodEntry['carbs'],
                              'fats': (currentData['fats']-widget .fats) + foodEntry['fats'],
                              'water': currentData['water'],
                              'weight': currentData['weight'],
                            };

                            await provider.addFood(todaysDate, foodEntry);
                            await provider.updateDailyData(todaysDate, updatedData);

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
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Cancel',
                            style: TextStyle(fontSize: 18, color: Colors.red),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}