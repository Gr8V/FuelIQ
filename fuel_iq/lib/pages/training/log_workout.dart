import 'package:flutter/material.dart';
import 'package:fuel_iq/utils/utils.dart';

class LogWorkout extends StatefulWidget {
  const LogWorkout({super.key});

  @override
  State<LogWorkout> createState() => _LogWorkoutState();
}

class _LogWorkoutState extends State<LogWorkout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "log workout"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              
            ],
          ),
        ),
      ),
    );
  }
}