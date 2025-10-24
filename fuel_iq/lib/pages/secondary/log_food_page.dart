import 'package:flutter/material.dart';
import 'package:fuel_iq/pages/main/home_page.dart';
import 'package:fuel_iq/services/daily_data_provider.dart';
import 'package:provider/provider.dart';

class LogFood extends StatefulWidget {
  const LogFood({super.key});

  @override
  State<LogFood> createState() => _LogFoodState();
}

class _LogFoodState extends State<LogFood> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      //app bar
      appBar: AppBar(
        title:  Text(
          "Log Food",
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
        body:  Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              ElevatedButton(
                onPressed:() async{
                  final newData = {
                    'calories': 1110.toDouble(),
                    'protein': 200.toDouble(),
                    'carbs': 250.toDouble(),
                    'fats': 80.toDouble(),
                    'water': 4.0.toDouble(),
                    'weight': 103.5.toDouble(),
                  };
                  await Provider.of<DailyDataProvider>(context, listen: false)
                      .updateDailyData(todaysDate, newData);
                },
                child: Icon(Icons.plus_one)
              )
            ],
          ),
        ),
    );
  }
}