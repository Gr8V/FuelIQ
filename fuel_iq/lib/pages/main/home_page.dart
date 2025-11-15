import 'package:flutter/material.dart';
import 'package:fuel_iq/globals/user_data.dart';
import 'package:fuel_iq/pages/main/details.dart';
import 'package:fuel_iq/pages/secondary/water.dart';
import 'package:fuel_iq/pages/secondary/weight.dart';
import 'dart:math';
import 'package:fuel_iq/services/daily_data_provider.dart';
import 'package:fuel_iq/services/notification_service.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:fuel_iq/theme/colors.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key});
  
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

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
    final dailyData = context.watch<DailyDataProvider>().getDailyData(todaysDate);
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


    final foods = context.watch<DailyDataProvider>().getDailyData(todaysDate)?['foods'] ?? [];
    

    return Scaffold(

      //body
      body: CustomScrollView(
        slivers: [
           // 🔹 Scrollable AppBar
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
                    'Fuel IQ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.3,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Performance Meets Precision',
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 12,
                    letterSpacing: 0.8,
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
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.notifications, color: colorScheme.primary),
                onPressed: () {
                  NotificationService.showNotification(
                    title: 'TEST NOTIFICATION',
                    body: 'This is a test notification.',
                    );
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    //Calories & Macros Section
                    InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        Navigator.push(
                            context,
                            //transition and page builder
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) => DailyData(dateSelected: todaysDate, showAppBar: true,),
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
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) => const WaterPage(),
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
                                ),
                              );
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
                                    fgColor: AppColors.waterColor,
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
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) => const WeightPage(),
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
                                ),
                              );
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
                                    'name': food['name'],
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
                                    'name': food['name'],
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
                                    'name': food['name'],
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
                                    'name': food['name'],
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
          ),
        ]
      )
    );
  }
}


class MacroTile extends StatefulWidget {
  final String label;
  final double eaten;
  final double goal;
  final Color bgColor;
  final Color fgColor;
  final IconData icon;
  final double size;
  final double strokeWidth;
  final Duration animationDuration;

  const MacroTile({
    super.key,
    required this.label,
    required this.eaten,
    required this.goal,
    required this.bgColor,
    required this.fgColor,
    required this.icon,
    this.size = 70,
    this.strokeWidth = 5,
    this.animationDuration = const Duration(milliseconds: 700),
  });

  @override
  State<MacroTile> createState() => _MacroTileState();
}

class _MacroTileState extends State<MacroTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _oldPercent = 0.0;
  double _targetPercent = 0.0;

  @override
  void initState() {
    super.initState();
    _oldPercent = _clampPercent(widget.eaten / max(widget.goal, 1));
    _targetPercent = _oldPercent;
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _animation = Tween<double>(begin: _oldPercent, end: _targetPercent)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut))
      ..addListener(() => setState(() {}));
  }

  @override
  void didUpdateWidget(covariant MacroTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newPercent = _clampPercent(widget.eaten / max(widget.goal, 1));
    _oldPercent = _animation.value;
    _targetPercent = newPercent;
    _animation = Tween<double>(begin: _oldPercent, end: _targetPercent)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller
      ..duration = widget.animationDuration
      ..forward(from: 0.0);
  }

  double _clampPercent(double v) => v.isFinite ? v.clamp(0.0, 1.0) : 0.0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final percent = _animation.value;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _CircularProgressPainter(
              progress: percent,
              backgroundArcColor: widget.bgColor,
              foregroundArcColor: widget.fgColor,
              strokeWidth: widget.strokeWidth,
            ),
          ),
          Icon(
            widget.icon,
            size: widget.size * 0.32,
            color: widget.fgColor,
          ),
        ],
      ),
    );
  }
}

/// Draws circular arcs for progress visualization.
class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color backgroundArcColor;
  final Color foregroundArcColor;
  final double strokeWidth;

  _CircularProgressPainter({
    required this.progress,
    required this.backgroundArcColor,
    required this.foregroundArcColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (min(size.width, size.height) - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);
    const startAngle = -pi / 2;

    final bgPaint = Paint()
      ..color = backgroundArcColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final fgPaint = Paint()
      ..color = foregroundArcColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    canvas.drawArc(rect, startAngle, 2 * pi, false, bgPaint);
    canvas.drawArc(rect, startAngle, 2 * pi * progress, false, fgPaint);
  }

  @override
  bool shouldRepaint(covariant _CircularProgressPainter old) {
    return old.progress != progress ||
        old.backgroundArcColor != backgroundArcColor ||
        old.foregroundArcColor != foregroundArcColor ||
        old.strokeWidth != strokeWidth;
  }
}