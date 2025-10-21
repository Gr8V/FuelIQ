import 'package:flutter/material.dart';
import 'colors.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightScaffold,
    cardColor: AppColors.lightCard,
    primaryColor: AppColors.lightPrimary,
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: AppColors.lightPrimary,
      onPrimary: Colors.white,
      secondary: AppColors.lightSecondary,
      onSecondary: Colors.black,
      tertiary: AppColors.lightTertiary,
      onTertiary: Colors.white,
      surface: AppColors.lightCard,
      onSurface: AppColors.lightTextPrimary,
      error: AppColors.lightError,
      onError: Colors.white,
      outline: Colors.grey,
      shadow: Colors.black,
      surfaceTint: Colors.transparent, // disables unwanted overlay
      inverseSurface: AppColors.lightCard,
      onInverseSurface: AppColors.lightTextPrimary,
      inversePrimary: AppColors.lightPrimary,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkScaffold,
    cardColor: AppColors.darkCard,
    primaryColor: AppColors.darkPrimary,
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.darkPrimary,
      onPrimary: Colors.white,
      secondary: AppColors.darkSecondary,
      onSecondary: Colors.black,
      tertiary: AppColors.darkTertiary,
      onTertiary: Colors.white,
      surface: AppColors.darkCard,
      onSurface: AppColors.darkTextPrimary,
      error: AppColors.darkError,
      onError: Colors.white,
      outline: Colors.grey,
      shadow: Colors.black,
      surfaceTint: Colors.transparent,
      inverseSurface: AppColors.darkCard,
      onInverseSurface: AppColors.darkTextPrimary,
      inversePrimary: AppColors.darkPrimary,
    ),
  );
}
