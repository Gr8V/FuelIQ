import 'package:flutter/material.dart';
import 'package:fuel_iq/pages/main/home_page.dart';
import 'package:fuel_iq/services/daily_data_provider.dart';
import 'package:fuel_iq/theme/colors.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

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
      setState(() => selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      //app bar
      appBar: AppBar(
        title:  Text(
          "Details",
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
      padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Center(
              child: InkWell(
                onTap:() {
                  _pickDate();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      selectedDate != null
                          ? "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}"
                          : todaysDate,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Divider(height: 1, color: colorScheme.onSurface),
            ),
            Expanded(
              child: DailyData(
                key: ValueKey(selectedDate),
                dateSelected: selectedDate != null
                      ? "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}"
                      : todaysDate,
                )
              )
          ],
        ),
      ),
    );
  }
}


class DailyData extends StatefulWidget {
  final String dateSelected;


  const DailyData({super.key, required this.dateSelected});
  
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              //calories eaten
              Card(
                elevation: 3,
                color: colorScheme.surface,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Calories Eaten',
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width *0.07,
                              color: colorScheme.onSurface
                            ),
                          ),
                          CaloriesCircularChart(
                            eaten: caloriesEaten,
                            goal: 1800,
                            size: 100,
                            backgroundArcColor: theme.colorScheme.onSurface,
                            foregroundArcColor: colorScheme.primary,
                            centerTextColor: colorScheme.onSurface,
                            strokeWidth: 10,
                          )
                        ],
                  ),
                ),
              ),
              //Macros
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  //protein
                  Expanded(
                    child: Card(
                      elevation: 3,
                      color: theme.cardColor,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: MacroTile(
                              label: 'Protein',
                              eaten: proteinEaten, 
                              goal: 100,
                              bgColor: colorScheme.onSurface,
                              fgColor: AppColors.proteinColor,
                              centerTextColor: colorScheme.onSurface,
                            ),
                      ),
                    ),
                  ),
                  //carbs
                  Expanded(
                    child: Card(
                      elevation: 3,
                      color: theme.cardColor,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: MacroTile(
                              label: 'Carbs',
                              eaten: carbsEaten, 
                              goal: 100,
                              bgColor: colorScheme.onSurface,
                              fgColor: AppColors.carbsColor,
                              centerTextColor: colorScheme.onSurface,
                            ),
                      ),
                    ),
                  ),
                  //fats
                  Expanded(
                    child: Card(
                      elevation: 3,
                      color: theme.cardColor,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: MacroTile(
                              label: 'Fats',
                              eaten: fatsEaten, 
                              goal: 100,
                              bgColor: colorScheme.onSurface,
                              fgColor: AppColors.fatColor,
                              centerTextColor: colorScheme.onSurface,
                            ),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  //Water
                  Expanded(
                    child: Card(
                      elevation: 3,
                      color: theme.cardColor,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: MacroTile(
                              label: 'Water',
                              eaten: waterDrunk, 
                              goal: 4,
                              bgColor: colorScheme.onSurface,
                              fgColor: AppColors.darkTertiary,
                              centerTextColor: colorScheme.onSurface,
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
                          children: [
                            Text(weightToday.toString()),
                            Text('Weight')
                          ],
                        )
                      ),
                    ),
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
                        return Card(
                          elevation: 3,
                          color: colorScheme.secondary,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            tileColor: colorScheme.surface,
                            title: Text(food['name']),
                            subtitle: Text(
                              'Qty: ${food['quantity']}g  •  Calories: ${food['calories']}  •  P: ${food['protein']}  C: ${food['carbs']}  F: ${food['fats']}',
                            ),
                            onTap:() {
                              Navigator.push(
                                context,
                                //transition and page builder
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) => FoodView(
                                    foodName: food['name'],
                                    quantity: food['quantity'],
                                    calories: food['calories'],
                                    protein: food['protein'],
                                    carbs:  food['carbs'],
                                    fats: food['fats'],
                                    dateOfFood: widget.dateSelected,
                                  ),
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
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
                                )
                              );
                            },
                          ),
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
    );
  }
}