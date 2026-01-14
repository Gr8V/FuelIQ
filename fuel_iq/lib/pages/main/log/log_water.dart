import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fuel_iq/globals/user_data.dart';
import 'package:fuel_iq/models/daily_data_model.dart';
import 'package:fuel_iq/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:fuel_iq/providers/daily_data_provider.dart';

class WaterPage extends StatefulWidget {
  const WaterPage({super.key});

  @override
  State<WaterPage> createState() => _WaterPageState();
}

class _WaterPageState extends State<WaterPage> with SingleTickerProviderStateMixin {


  @override
  void initState() {
    super.initState();

  }

  void _addWater(double amount) async {
    final provider = Provider.of<DailyDataProvider>(context, listen: false);
    DailyDataModel day = provider.getDailyData(todaysDate) ?? DailyDataModel();
    
    day.nutrition.water += amount;
    await provider.updateDailyData(todaysDate, day);
    

  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final provider = context.watch<DailyDataProvider>();
    final dailyData = provider.getDailyData(todaysDate) ?? DailyDataModel();

    final double waterDrunk = dailyData.nutrition.water;
    final double dailyWaterTarget = dailyData.nutrition.targets.water;
    final double percentage = (waterDrunk / dailyWaterTarget * 100).clamp(0, 100);

    return Scaffold(
      appBar: CustomAppBar(title: "water"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ---- ENHANCED WATER CARD ----
            Card(
              elevation: 3,
              color: colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    // Large Circular Progress Indicator
                    SizedBox(
                      height: 220,
                      width: 220,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Background Circle
                          SizedBox(
                            height: 220,
                            width: 220,
                            child: CircularProgressIndicator(
                              value: 1.0,
                              strokeWidth: 14,
                              color: Colors.blue.shade100,
                              strokeCap: StrokeCap.round,
                            ),
                          ),
                          // Progress Circle
                          SizedBox(
                            height: 220,
                            width: 220,
                            child: CircularProgressIndicator(
                              value: (waterDrunk / dailyWaterTarget).clamp(0.0, 1.0),
                              strokeWidth: 14,
                              backgroundColor: Colors.transparent,
                              color: Colors.blue,
                              strokeCap: StrokeCap.round,
                            ),
                          ),
                          // Center Content
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                FontAwesomeIcons.glassWater,
                                size: 48,
                                color: Colors.blue,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                '${(waterDrunk * 1000).toInt()}',
                                style: TextStyle(
                                  fontSize: 42,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              Text(
                                'ml',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'of ${(dailyWaterTarget * 1000).toInt()}ml',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Progress Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: (waterDrunk / dailyWaterTarget).clamp(0.0, 1.0),
                        minHeight: 8,
                        backgroundColor: Colors.blue.shade100,
                        color: Colors.blue,
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Percentage Text
                    Text(
                      '${percentage.toInt()}% Complete',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 80),

            // ---- ORIGINAL BUTTONS ROW ----
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(),
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(double.infinity, 60),
                    ),
                    onPressed: () async {
                      _addWater(0.25);
                    },
                    child: const Text("Add 250ml"),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(),
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(double.infinity, 60),
                    ),
                    onPressed: () async {
                      final provider = 
                          Provider.of<DailyDataProvider>(context, listen: false);

                      DailyDataModel day =
                          provider.getDailyData(todaysDate) ??
                              DailyDataModel();

                      if (day.nutrition.water <= 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("You have not drank water today."),
                          ),
                        );
                        return;
                      }

                      day.nutrition.water = (day.nutrition.water - 0.25).clamp(0.0, 99.0);

                      await provider.updateDailyData(todaysDate, day);
                    },
                    child: const Text("Remove 250ml"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}