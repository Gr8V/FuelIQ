import 'package:flutter/material.dart';
import 'package:fuel_iq/main.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //app bar
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
        ),
      //body
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.color_lens),
              title: const Text('Theme'),
              subtitle: const Text('Light, Dark, System'),
              onTap: () {
                Navigator.push(
                  context,
                  //transition and page builder
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => const ThemeSelectionPage(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(1.0, 0.0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        );
                      },
                      transitionDuration: const Duration(milliseconds: 400),
                  )
                );
              },
            )
        ],
        ),
      ),
    );
  }
}

class ThemeSelectionPage extends StatefulWidget {
  const ThemeSelectionPage({super.key});

  @override
  State<ThemeSelectionPage> createState() => _ThemeSelectionPageState();
}

class _ThemeSelectionPageState extends State<ThemeSelectionPage> {
  ThemeMode? _selectedMode = themeNotifier.value;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Theme")),
      body: Column(
        children: [
          RadioListTile(
            title: const Text('Light Mode'),
            value: ThemeMode.light,
            groupValue: _selectedMode,
            onChanged: (ThemeMode? value) {
              setState(() {
                _selectedMode = value;
                themeNotifier.value = value!;
              });
            },
          ),
          RadioListTile<ThemeMode>(
            title: const Text("Dark Mode"),
            value: ThemeMode.dark,
            groupValue: _selectedMode,
            onChanged: (ThemeMode? value) {
              setState(() {
                _selectedMode = value;
                themeNotifier.value = value!;
              });
            },
          ),
          RadioListTile<ThemeMode>(
            title: const Text("System Default"),
            value: ThemeMode.system,
            groupValue: _selectedMode,
            onChanged: (ThemeMode? value) {
              setState(() {
                _selectedMode = value;
                themeNotifier.value = value!;
              });
            },
          ),
        ],
      )
    );
  }
}
