import 'package:flutter/material.dart';
import 'package:fuel_iq/user_profile.dart';

void main() {
  runApp(const FuelIQApp());
}
// Dark base colors
const Color richBlack = Color.fromARGB(255, 2, 27, 26);      // deep dark background
const Color darkGreen = Color.fromARGB(255, 0, 77, 64);      // main accent dark green
// Mid-tone vibrant colors
const Color bangladeshGreen = Color.fromARGB(255, 0, 168, 107); // vibrant green
const Color mountainMeadow = Color.fromARGB(255, 48, 213, 200); // teal-ish midtone
const Color carribbeanGreen = Color.fromARGB(255, 0, 224, 181); // lighter accent
const Color frog = Color.fromARGB(255, 23, 135, 109);
// Light color for text / highlights
const Color antiFlashWhite = Color.fromARGB(255, 242, 242, 242); // near-white for contrast


class FuelIQApp extends StatelessWidget {
  const FuelIQApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FuelIQ',
      theme: ThemeData(
        //main app bg colour
        scaffoldBackgroundColor: richBlack,
        //app bar
        appBarTheme: const AppBarTheme(
          backgroundColor: darkGreen,
          foregroundColor: antiFlashWhite
        ),
        //scan barcode button
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(carribbeanGreen),
            foregroundColor: MaterialStateProperty.all(antiFlashWhite)
          )
        ),
        //bottom nav bar
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: bangladeshGreen,
          selectedItemColor: carribbeanGreen,
          unselectedItemColor: antiFlashWhite
        ),
        cardTheme: const CardTheme(
          color: frog,
          surfaceTintColor: richBlack,
        ),
        
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //app bar
      appBar: AppBar(
        //app title
        title: const Text('FuelIQ'),

        centerTitle: true,
        //user profile icon
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_rounded),
            tooltip: 'Profile',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserProfile()),
              );
            },
          )
        ]
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          // 0 - Home
          Padding(
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
          ),
          // 1 - Scan (placeholder)
          Center(
            child: Text('Scan Barcode screen', style: TextStyle(color: antiFlashWhite)),
          ),
          // 2 - Search (placeholder)
          Center(
            child: Text('Search screen', style: TextStyle(color: antiFlashWhite)),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: 'Scan Barcode'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search'
          ),
        ],
      ),
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
