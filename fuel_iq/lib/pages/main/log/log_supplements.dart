import 'package:flutter/material.dart';
import 'package:fuel_iq/utils/utils.dart';

class Supplements extends StatefulWidget {
  const Supplements({super.key});

  @override
  State<Supplements> createState() => _SupplementsState();
}

class _SupplementsState extends State<Supplements> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "supplements"),
      body: Padding(
        padding: EdgeInsets.all(16.0),
      ),
    );
  }
}