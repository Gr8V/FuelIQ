import 'package:flutter/material.dart';

void main() {
  runApp(FuelIQApp());
}

class FuelIQApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FuelIQ',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FuelIQ'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Welcome text
            Text(
              'Welcome to FuelIQ!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),

            // Daily Macros placeholder
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
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

            SizedBox(height: 30),

            // Scan Barcode Button
            ElevatedButton.icon(
              icon: Icon(Icons.qr_code_scanner),
              label: Text(
                'Scan Barcode',
                style: TextStyle(fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                // TODO: Navigate to barcode scanning screen
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MacroTile extends StatelessWidget {
  final String label;
  final String value;

  MacroTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(label),
      ],
    );
  }
}
