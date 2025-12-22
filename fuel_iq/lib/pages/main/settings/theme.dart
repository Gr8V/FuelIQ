import 'package:flutter/material.dart';
import 'package:fuel_iq/globals/theme_controller.dart';
import 'package:fuel_iq/utils/utils.dart';

class ThemeSelectionPage extends StatelessWidget {
  const ThemeSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    //final theme = Theme.of(context);
    //final colorScheme = theme.colorScheme;
    
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentTheme, child) {
        return Scaffold(
          //app bar
          appBar: CustomAppBar(title: "theme"),
          body: Column(
            children: [
              RadioGroup<ThemeMode>(
                groupValue: currentTheme,
                onChanged: (ThemeMode? value) {
                  if (value != null) {
                    setTheme(value);
                  }
                },
                child: const Column(
                  children: [
                    RadioListTile(
                      value: ThemeMode.light,
                      title: Text("Light Mode"),
                    ),
                    RadioListTile(
                      value: ThemeMode.dark,
                      title: Text("Dark Mode"),
                    ),
                    RadioListTile(
                      value: ThemeMode.system,
                      title: Text("System Default"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}