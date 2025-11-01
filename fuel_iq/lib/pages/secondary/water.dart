import 'package:flutter/material.dart';
import 'package:fuel_iq/globals/constants.dart';
import 'package:fuel_iq/pages/main/home_page.dart';
import 'package:provider/provider.dart';
import 'package:fuel_iq/services/daily_data_provider.dart';


class WaterPage extends StatefulWidget {
  const WaterPage({super.key});

  @override
  State<WaterPage> createState() => _WaterPageState();
}

class _WaterPageState extends State<WaterPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final dailyData = context.watch<DailyDataProvider>().getDailyData(todaysDate);
    final waterDrunk = dailyData?['water'] ?? 0.0; // in liters
    return Scaffold(
      //app bar
      appBar: AppBar(
        title:  Text(
          "Water",
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
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Card(
                elevation: 3,
                  color: colorScheme.surface,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Water Drunk',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width *0.07,
                            color: colorScheme.onSurface
                          ),
                        ),
                        CaloriesCircularChart(
                              eaten: waterDrunk,
                              goal: waterTarget,
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
              const SizedBox(height: 100,),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(), // square edges
                        padding: EdgeInsets.zero, // removes internal spacing
                        minimumSize: const Size(double.infinity, 60), // adjust height if needed
                      ),
                      onPressed: () async {
                        final provider = Provider.of<DailyDataProvider>(context, listen: false);

                        // Get current water intake
                        final currentWater = provider.getDailyData(todaysDate)?['water'] ?? 0.0;

                        // Update only water
                        final updatedData = Map<String, dynamic>.from(provider.getDailyData(todaysDate) ?? {});
                        updatedData['water'] = currentWater + 0.25; // add 250 ml

                        await provider.updateDailyData(todaysDate, updatedData);
                      },
                      child: const Text('Add 250ml'),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(), // square edges
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(double.infinity, 60),
                      ),
                      onPressed: () async {
                        final provider = Provider.of<DailyDataProvider>(context, listen: false);

                        // Get current water intake
                        final currentWater = provider.getDailyData(todaysDate)?['water'] ?? 0.0;
                        final updatedData = Map<String, dynamic>.from(provider.getDailyData(todaysDate) ?? {});

                        if (currentWater > 0) {
                          // Update only water
                          updatedData['water'] = currentWater - 0.25; // add 250 ml
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('You Have Not Drank Water Today.')),
                          );
                        }

                        await provider.updateDailyData(todaysDate, updatedData);
                      },
                      child: const Text('Remove 250ml'),
                    ),
                  ),
                ],
              )

            ],
          ),
        ),
    );
  }
}