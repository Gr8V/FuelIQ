import 'package:flutter/material.dart';
//pages
import 'package:fuel_iq/pages/homePage.dart';
import 'package:fuel_iq/pages/details.dart';
import 'package:fuel_iq/pages/settings.dart';
import 'package:fuel_iq/pages/user_profile.dart';
//theme
import 'package:fuel_iq/globals/theme_controller.dart';
import 'package:fuel_iq/theme/app_theme.dart';

void main() {
  runApp(const FuelIQApp());
}

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
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeNotifier.value,
      home: const HomeScreen(),
      builder: (context, child) {
        return ValueListenableBuilder(
          valueListenable: themeNotifier,
          builder: (_, mode, __) {
            return MaterialApp(
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
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
          DetailsPage(),
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
