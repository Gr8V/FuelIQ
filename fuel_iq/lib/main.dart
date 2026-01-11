import 'package:flutter/material.dart';
import 'package:fuel_iq/pages/main/log/add_items.dart';
import 'package:fuel_iq/providers/history_provider.dart';
import 'package:fuel_iq/providers/saved_foods_provider.dart';
import 'package:fuel_iq/splash_screen.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//pages
import 'pages/main/home_page.dart';
import 'pages/main/details.dart';
import 'package:fuel_iq/pages/main/insights.dart';
import 'pages/main/settings.dart'; 
import 'providers/daily_data_provider.dart';
//theme
import 'globals/theme_controller.dart';
import 'theme/app_theme.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  
  await Hive.openBox('settingsBox');
  
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
    //theme
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
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
      bottomNavigationBar: SizedBox(
        height: MediaQuery.of(context).size.height * 0.09, // ~9% of screen
        child: _buildBottomNavigationBar(colorScheme),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () => showAddFoodDrawer(context),
        elevation: 2,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildBottomNavigationBar(ColorScheme colorscheme) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      elevation: 8,
      child: SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(colorscheme, Icons.home, 0),
            _buildNavItem(colorscheme, Icons.calendar_month, 1),
            const SizedBox(width: 20), // Space for FAB
            _buildNavItem(colorscheme, Icons.bar_chart_rounded, 3),
            _buildNavItem(colorscheme, Icons.settings, 4),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(ColorScheme colorscheme,IconData icon, int index) {
    final isSelected = _selectedBottomNavBarIndex == index;
    return Expanded(
      child: IconButton(
        iconSize: 32,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        icon: Icon(
          icon,
          color: isSelected 
              ? colorscheme.secondary
              : colorscheme.primary,
        ),
        onPressed: () {
          setState(() {
            _selectedBottomNavBarIndex = index;
          });
        },
      ),
    );
  }
}