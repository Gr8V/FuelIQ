//thememode value notifier
import 'package:flutter/material.dart';
import 'package:fuel_iq/services/local_storage.dart';

ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.system);

Future<void> loadSavedTheme() async {
  final savedTheme = await LocalStorageService.getThemeData();
  themeNotifier.value = savedTheme ?? ThemeMode.system;
}

/// Set and save theme
Future<void> setTheme(ThemeMode mode) async {
  themeNotifier.value = mode;
  await LocalStorageService.saveThemeData(currentTheme: mode);
}