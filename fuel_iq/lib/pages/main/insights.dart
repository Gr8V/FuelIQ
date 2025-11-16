import 'package:flutter/material.dart';
import 'package:fuel_iq/services/daily_data_provider.dart';
import 'package:fuel_iq/services/utils.dart';
import 'package:provider/provider.dart';

class Insights extends StatefulWidget {
  const Insights({super.key});

  @override
  State<Insights> createState() => _InsightsState();
}

class _InsightsState extends State<Insights> {
  List<Map<String, dynamic>> calories = [];
  List<Map<String, dynamic>> protein = [];
  List<Map<String, dynamic>> carbs = [];
  List<Map<String, dynamic>> fats = [];
  bool isLoading = true;
  int? daysToShow;

  @override
  void initState() {
    super.initState();
    _loadData();
    
    // Listen for provider changes
    final provider = context.read<DailyDataProvider>();
    provider.addListener(_onProviderChanged);
  }

  @override
  void dispose() {
    // Remove listener when widget is disposed
    final provider = context.read<DailyDataProvider>();
    provider.removeListener(_onProviderChanged);
    super.dispose();
  }

  void _onProviderChanged() {
    // Reload data when provider notifies changes
    _loadData();
  }
  
  void _changeDaysFilter(int? days) async {
  if (daysToShow == days) return; // Don't reload if same filter
  
  setState(() {
    daysToShow = days;
    isLoading = true; // Show loading indicator
  });
  
  await _loadData();
}

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
    });

    final provider = context.read<DailyDataProvider>();
    
    final results = await Future.wait([
      provider.getAllLoadedCalories(lastDays: daysToShow),
      provider.getAllLoadedProtein(lastDays: daysToShow),
      provider.getAllLoadedCarbs(lastDays: daysToShow),
      provider.getAllLoadedFats(lastDays: daysToShow),
    ]);
    
    if (mounted) {
      setState(() {
        calories = results[0];
        protein = results[1];
        carbs = results[2];
        fats = results[3];
        isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    double avgCalories = 0;

    if (calories.isNotEmpty) {
      avgCalories = calories
        .map((entry) => entry['calories'] as double)
        .reduce((a, b) => a + b) /
        calories.length;
    }
    double getProteinConsistency() {
    if (protein.isEmpty) return 0.0;

    int daysHit = 0;

    for (final day in protein) {
      final protein = (day['protein'] ?? 0.0) as double;
      final target = (day['proteinTarget'] ?? 0.0) as double;

      if (target > 0 && protein >= 0.9 * target) { // hit if ≥90% of target
        daysHit++;
      }
    }

    return (daysHit / protein.length) * 100; // consistency percentage
  }


    return Scaffold(
      //app bar
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Insights',
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
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- Avg Calories Card ---
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                          Theme.of(context).colorScheme.secondary.withValues(alpha: 0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Avg Calories",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "${avgCalories.toStringAsFixed(1)} kcal",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // --- Protein Consistency Card ---
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
                          Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
                        ],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Protein Consistency",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${getProteinConsistency().toStringAsFixed(2)}%',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              Column(
                children: [
                  //calories chart
                  ExpansionTile(
                    title: const Text("Calories"),
                    leading: const Icon(Icons.insights),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                    childrenPadding: const EdgeInsets.all(12),
                    children: [
                      SimpleMacroBarChart(
                            data: calories,
                            title: 'Calories',
                            valueKey: 'calories',
                            targetKey: 'calorieTarget',
                            unit: 'kcal',
                          )
                    ],
                  ),
                
                  //protein chart
                  ExpansionTile(
                    title: const Text("Protein"),
                    leading: const Icon(Icons.insights),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                    childrenPadding: const EdgeInsets.all(12),
                    children: [
                      SimpleMacroBarChart(
                            data: protein,
                            title: 'Protein',
                            valueKey: 'protein',
                            targetKey: 'proteinTarget',
                            unit: 'g',
                          )
                    ],
                  ),
                
                  //carbs chart
                  ExpansionTile(
                    title: const Text("Carbs"),
                    leading: const Icon(Icons.insights),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                    childrenPadding: const EdgeInsets.all(12),
                    children: [
                      SimpleMacroBarChart(
                            data: carbs,
                            title: 'Carbs',
                            valueKey: 'carbs',
                            targetKey: 'carbsTarget',
                            unit: 'g',
                          )
                    ],
                  ),
                
                  //fats chart
                  ExpansionTile(
                    title: const Text("Fats"),
                    leading: const Icon(Icons.insights),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                    childrenPadding: const EdgeInsets.all(12),
                    children: [
                      SimpleMacroBarChart(
                            data: fats,
                            title: 'Fats',
                            valueKey: 'fats',
                            targetKey: 'fatsTarget',
                            unit: 'g',
                          )
                    ],
                  ),
                ],
              ),
              const SizedBox(height:40),
            
               // --- Filter Buttons ---
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilterButton(
                    label: "7D",
                    isSelected: daysToShow == 7,
                    onPressed: () => _changeDaysFilter(7),
                  ),
                  FilterButton(
                    label: "30D",
                    isSelected: daysToShow == 30,
                    onPressed: () => _changeDaysFilter(30),
                  ),
                  FilterButton(
                    label: "All",
                    isSelected: daysToShow == null,
                    onPressed: () => _changeDaysFilter(null),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}