import 'package:flutter/material.dart';
import 'package:fuel_iq/homePage.dart';
import 'package:fuel_iq/scan_page.dart';
import 'package:fuel_iq/settings.dart';
import 'package:fuel_iq/user_profile.dart';


void main() {
  runApp(const FuelIQApp());
}

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: const Color(0xFFFFFFFF),
  cardColor: const Color(0xFFF5F5F5),
  primaryColor: const Color(0xFF2E7D32),
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF2E7D32),
    secondary: Color(0xFFFF9800),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Color(0xFF212121)),
    bodyMedium: TextStyle(color: Color(0xFF616161)),
  ),
);
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF121212),
  cardColor: const Color(0xFF1E1E1E),
  primaryColor: const Color(0xFF00C853),
  colorScheme:const ColorScheme.dark(
    primary: Color(0xFF00C853),
    secondary: Color(0xFFFFB300),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Color(0xFFFFFFFF)),
    bodyMedium: TextStyle(color: Color(0xFFB0B0B0)),
  ),
);
ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.system);

class FuelIQApp extends StatefulWidget {
  const FuelIQApp({super.key});
  @override
  State<FuelIQApp> createState() => _FuelIQAppState();
}

class _FuelIQAppState extends State<FuelIQApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FuelIQ',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeNotifier.value,
      home: const HomeScreen(),
      builder: (context, child) {
        return ValueListenableBuilder(
          valueListenable: themeNotifier,
          builder: (_, mode, __) {
            return MaterialApp(
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: mode,
              home: child,
            );
          }
          );
      },
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
  int _selectedBottomNavBarIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedBottomNavBarIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedBottomNavBarIndex,
        children: const [
          // 0 - Home
          HomePage(),
          // 1 - Scan
          ScanPage(),
          // 2 - Settings
          SettingsPage(),
          // 3 - Profile
          UserProfile()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 0,
        currentIndex: _selectedBottomNavBarIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: ''
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_rounded),
            label: ''
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: ''
          ),
        ],
      ),
    );
  }
}
