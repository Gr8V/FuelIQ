import 'package:flutter/material.dart';
import 'package:fuel_iq/utils/utils.dart';

class CardioPage extends StatefulWidget {
  const CardioPage({super.key});

  @override
  State<CardioPage> createState() => _CardioPageState();
}

class _CardioPageState extends State<CardioPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "cardio"),
      body: Padding(
        padding: EdgeInsets.all(16.0),
      ),
    );
  }
}