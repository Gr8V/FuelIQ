import 'package:flutter/material.dart';
import 'package:fuel_iq/utils/utils.dart';

class WorkoutPage extends StatefulWidget {
  const WorkoutPage({super.key});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "workout"),
      body: Padding(
        padding: EdgeInsets.all(16.0),
      ),
    );
  }
}