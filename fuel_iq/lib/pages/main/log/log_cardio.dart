import 'package:flutter/material.dart';
import 'package:fuel_iq/utils/utils.dart';

class LogCardio extends StatefulWidget {
  const LogCardio({super.key});

  @override
  State<LogCardio> createState() => _LogCardioState();
}

class _LogCardioState extends State<LogCardio> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "log cardio"),
      body: Padding(
        padding: EdgeInsets.all(16.0),
      ),
    );
  }
}