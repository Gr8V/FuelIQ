import 'package:flutter/material.dart';
import 'package:fuel_iq/utils/utils.dart';

class PersonalRecordsPage extends StatefulWidget {
  const PersonalRecordsPage({super.key});

  @override
  State<PersonalRecordsPage> createState() => _PersonalRecordsPageState();
}

class _PersonalRecordsPageState extends State<PersonalRecordsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "records"),
      body: Padding(
        padding: EdgeInsets.all(16.0),
      ),
    );
  }
}