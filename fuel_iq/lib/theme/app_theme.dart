import 'package:flutter/material.dart';
import 'colors.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightScaffold,
    cardColor: AppColors.lightCard,
    primaryColor: AppColors.lightPrimary,
    
    // 🔹 Add proper Material 3 color scheme
    colorScheme: const ColorScheme.light(
      primary: AppColors.lightPrimary,
      secondary: AppColors.lightSecondary,
      background: AppColors.lightScaffold,        // 🔹 important for backgrounds
      surface: AppColors.lightCard,               // 🔹 used for cards, sheets
      onPrimary: Colors.white,                    // 🔹 text/icons on primary
      onSecondary: Colors.black,                  // optional
      onBackground: AppColors.lightTextPrimary,   // 🔹 text on background
      onSurface: AppColors.lightTextPrimary,      // 🔹 text on card/surface
    ),

    // 🔹 Define text theme that adapts automatically
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 16),
      bodyMedium: TextStyle(fontSize: 14),
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ),
    useMaterial3: true, // 🔹 enables latest Material 3 behavior
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkScaffold,
    cardColor: AppColors.darkCard,
    primaryColor: AppColors.darkPrimary,

    // 🔹 Add dark mode color scheme
    colorScheme: const ColorScheme.dark(
      primary: AppColors.darkPrimary,
      secondary: AppColors.darkSecondary,
      background: AppColors.darkScaffold,
      surface: AppColors.darkCard,
      onPrimary: Colors.white,                    // 🔹 readable on dark primary
      onSecondary: Colors.white70,                // optional
      onBackground: AppColors.darkTextPrimary,
      onSurface: AppColors.darkTextPrimary,
    ),

    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 16),
      bodyMedium: TextStyle(fontSize: 14),
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ),
    useMaterial3: true,
  );
}
