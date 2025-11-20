import 'package:flutter/material.dart';
import 'package:fuel_iq/pages/main/add_items.dart';
import 'package:fuel_iq/pages/main/insights.dart';
import 'package:fuel_iq/providers/history_provider.dart';
import 'package:fuel_iq/providers/saved_foods_provider.dart';
import 'package:fuel_iq/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//pages
import 'pages/main/home_page.dart';
import 'pages/main/details.dart';
import 'pages/main/settings.dart'; 
import 'providers/daily_data_provider.dart';
//theme
import 'globals/theme_controller.dart';
import 'theme/app_theme.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SavedFoodsProvider()),
        ChangeNotifierProvider(create: (_) => DailyDataProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
      ],
      child: const FuelIQApp(),
    ),
  );
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
          themeMode: currentMode,
          home: const SplashScreen(), // Start with loading screen
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
          HomePage(),
          DetailsPage(),
          SizedBox.shrink(),
          Insights(),
          SettingsPage(),
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart_rounded), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: ''),
        ],
      ),
    );
  }
}