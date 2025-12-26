import 'package:flutter/material.dart';
import 'package:fuel_iq/globals/user_data.dart';
import 'package:fuel_iq/models/food_entry.dart';
import 'package:fuel_iq/pages/main/details.dart';
import 'package:fuel_iq/pages/main/log/log_water.dart';
import 'package:fuel_iq/pages/main/log/log_weight.dart';
import 'package:fuel_iq/providers/daily_data_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fuel_iq/utils/utils.dart';
import 'package:fuel_iq/theme/colors.dart';



class Nutrition extends StatefulWidget {
  const Nutrition({super.key});
  
  @override
  State<Nutrition> createState() => _NutritionState();
}

class _NutritionState extends State<Nutrition> {

  @override
  void initState() {
    super.initState();
    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DailyDataProvider>(context, listen: false)
          .loadDailyData(todaysDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    //theme
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    //data
    final dailyData =
        context.watch<DailyDataProvider>().getDailyData(todaysDate);

    // ====== FIXED: Model-safe lookups ======
    final caloriesEaten = dailyData?.calories ?? 0.0;
    final proteinEaten = dailyData?.protein ?? 0.0;
    final carbsEaten = dailyData?.carbs ?? 0.0;
    final fatsEaten = dailyData?.fats ?? 0.0;
    final waterDrunk = dailyData?.water ?? 0.0;
    final weightToday = dailyData?.weight ?? 0.0;

    final dailyCalorieTarget =
        (dailyData?.calorieTarget ?? 0) != 0 ? dailyData!.calorieTarget : defaultCaloriesTarget.toDouble();

    final dailyProteinTarget =
        (dailyData?.proteinTarget ?? 0) != 0 ? dailyData!.proteinTarget : defaultProteinTarget.toDouble();

    final dailyCarbsTarget =
        (dailyData?.carbsTarget ?? 0) != 0 ? dailyData!.carbsTarget : defaultCarbsTarget.toDouble();

    final dailyFatsTarget =
        (dailyData?.fatsTarget ?? 0) != 0 ? dailyData!.fatsTarget : defaultFatsTarget.toDouble();

    final dailyWaterTarget =
        (dailyData?.waterTarget ?? 0) != 0 ? dailyData!.waterTarget : defaultWaterTarget.toDouble();

    // ====== FIXED: foods is now List<FoodEntry> ======
    final List<FoodEntry> foods = dailyData?.foods ?? [];


    return Scaffold(

      //body
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            elevation: 0,
            pinned: false,
            floating: true, // makes it scroll with content
            backgroundColor: Colors.transparent,
            centerTitle: true,
            title: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [colorScheme.primary, colorScheme.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child: Text(
                    'NUTRITION',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.3,
                    ),
                  ),
                ),
              ],
            ),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.onSurface.withValues(alpha: 0.15),
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            )
          ),
          
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DateSelectorRow(
                      onDateSelected: (index) {
                        // handle date change
                      },
                    ),

                    const SizedBox(height: 20),
                    //Calories & Macros Section
                    InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        pushWithSlideFade(
                          context,
                          DailyData(dateSelected: todaysDate, showAppBar: true)
                        );
                      },
                      child: Column(
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
                    ),
                    // Water & Weight Section
                    Column(
                      children: [
                        // Water
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              pushWithSlideFade(context, WaterPage());
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              child: Row(
                                children: [
                                  MacroTile(
                                    eaten: waterDrunk,
                                    goal: dailyWaterTarget,
                                    size: 48,
                                    bgColor: colorScheme.onSurface.withValues(alpha: 0.1),
                                    fgColor: Colors.blue,
                                    strokeWidth: 3,
                                    icon: FontAwesomeIcons.glassWater,
                                    label: 'Water',
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Water Intake',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: colorScheme.onSurface,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${(dailyWaterTarget - waterDrunk).toStringAsFixed(1)}L remaining',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    color: colorScheme.onSurface.withValues(alpha: 0.3),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Weight
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              pushWithSlideFade(context, WeightPickerPage());
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              child: Row(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: colorScheme.primary.withValues(alpha: 0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      FontAwesomeIcons.weightScale,
                                      size: 28,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Weight',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: colorScheme.onSurface,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${weightToday.toStringAsFixed(1)} kg',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    color: colorScheme.onSurface.withValues(alpha: 0.3),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    //Food Eaten
                    const SizedBox(height: 40),
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(thickness: 1.2, endIndent: 10),
                        ),
                        Text(
                          "Today's Food",
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
                          Builder(
                            builder: (context) {
                              final breakfastFoods = foods.where((food) => food.time == 'Breakfast').toList();
                              
                              return breakfastFoods.isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: const Center(child: Text('No foods logged yet')),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: breakfastFoods.length,
                                    itemBuilder: (context, index) {
                                      final food = breakfastFoods[index];  // ✅ Now correct!
                                      return FoodCard(
                                        food: {
                                          'foodName': food.name,
                                          'id': food.id,
                                          'quantity': food.quantity,
                                          'calories': food.calories,
                                          'protein': food.protein,
                                          'carbs': food.carbs,
                                          'fats': food.fats,
                                          'time': food.time
                                        },
                                        todaysDate: todaysDate,
                                      );
                                    },
                                  );
                            },
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
                          Builder(
                            builder: (context) {
                              final lunchFoods = foods.where((food) => food.time == 'Lunch').toList();
                              
                              return lunchFoods.isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: const Center(child: Text('No foods logged yet')),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: lunchFoods.length,
                                    itemBuilder: (context, index) {
                                      final food = lunchFoods[index];  // ✅ Now correct!
                                      return FoodCard(
                                        food: {
                                          'foodName': food.name,
                                          'id': food.id,
                                          'quantity': food.quantity,
                                          'calories': food.calories,
                                          'protein': food.protein,
                                          'carbs': food.carbs,
                                          'fats': food.fats,
                                          'time': food.time
                                        },
                                        todaysDate: todaysDate,
                                      );
                                    },
                                  );
                            },
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
                          Builder(
                            builder: (context) {
                              final snacksFood = foods.where((food) => food.time == 'Snacks').toList();
                              
                              return snacksFood.isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: const Center(child: Text('No foods logged yet')),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: snacksFood.length,
                                    itemBuilder: (context, index) {
                                      final food = snacksFood[index];  // ✅ Now correct!
                                      return FoodCard(
                                        food: {
                                          'foodName': food.name,
                                          'id': food.id,
                                          'quantity': food.quantity,
                                          'calories': food.calories,
                                          'protein': food.protein,
                                          'carbs': food.carbs,
                                          'fats': food.fats,
                                          'time': food.time
                                        },
                                        todaysDate: todaysDate,
                                      );
                                    },
                                  );
                            },
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
                          Builder(
                            builder: (context) {
                              final dinnerFoods = foods.where((food) => food.time == 'Dinner').toList();
                              
                              return dinnerFoods.isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: const Center(child: Text('No foods logged yet')),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: dinnerFoods.length,
                                    itemBuilder: (context, index) {
                                      final food = dinnerFoods[index];  // ✅ Now correct!
                                      return FoodCard(
                                        food: {
                                          'foodName': food.name,
                                          'id': food.id,
                                          'quantity': food.quantity,
                                          'calories': food.calories,
                                          'protein': food.protein,
                                          'carbs': food.carbs,
                                          'fats': food.fats,
                                          'time': food.time
                                        },
                                        todaysDate: todaysDate,
                                      );
                                    },
                                  );
                            },
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ]
      )
    );
  }
}