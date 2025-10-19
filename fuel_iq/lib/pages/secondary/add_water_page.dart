import 'package:flutter/material.dart';

class LogWater extends StatefulWidget {
  const LogWater({super.key});

  @override
  State<LogWater> createState() => _LogWaterState();
}

class _LogWaterState extends State<LogWater> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      //app bar
      appBar: AppBar(
        title:  Text(
          "Log Water Intake",
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
        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              
            ],
          ),
        ),
    );
  }
}