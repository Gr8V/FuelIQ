import 'package:flutter/material.dart';
import 'package:fuel_iq/utils/utils.dart';

class Language extends StatefulWidget {
  const Language({super.key});

  @override
  State<Language> createState() => _LanguageState();
}

class _LanguageState extends State<Language> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "language"),
      body: Padding(
        padding: EdgeInsets.all(16.0),
      ),
    );
  }
}