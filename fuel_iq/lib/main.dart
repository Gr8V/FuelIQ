import 'package:flutter/material.dart';
import 'package:fuel_iq/pages/main/addItems.dart';
//pages
import 'package:fuel_iq/pages/main/homePage.dart';
import 'package:fuel_iq/pages/main/details.dart';
import 'package:fuel_iq/pages/main/settings.dart';
import 'package:fuel_iq/pages/main/user_profile.dart';
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
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, child) {
        return MaterialApp(
          title: 'FuelIQ',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: currentMode, // ✅ reacts to changes
          home: const HomeScreen(),
          debugShowCheckedModeBanner: false,
        );
      },
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
          // 2 - Add Food
          SizedBox.shrink(),
          // 3 - Settings
          SettingsPage(),
          // 4 - Profile
          UserProfile()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 0,
        currentIndex: _selectedBottomNavBarIndex,
        onTap: (index) {
          if (index == 2) {
            showAddFoodDrawer(context);
          }
          else {
            setState(() {
              _selectedBottomNavBarIndex = index;
            });
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_rounded),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
      ),
    );
  }
}
