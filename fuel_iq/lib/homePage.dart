import 'package:flutter/material.dart';
import 'package:fuel_iq/main.dart';

const months = [
    "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December"
  ];
String todaysDate = "${DateTime.now().day} ${months[DateTime.now().month-1]} ${DateTime.now().year}";
String appBarTitle = todaysDate;



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //app bar
      appBar: AppBar(
        title:  Text(appBarTitle),
        centerTitle: true,
        ),
      //body
      body: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Welcome to FuelIQ!',
                  style: TextStyle(
                    color: frog,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Card(
                  elevation: 3,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Today\'s Macros',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            MacroTile(label: 'Protein', value: '0g'),
                            MacroTile(label: 'Carbs', value: '0g'),
                            MacroTile(label: 'Fat', value: '0g'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
      )
    );
  }
}


class MacroTile extends StatelessWidget {
  final String label;
  final String value;

  const MacroTile({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(label),
      ],
    );
  }
}