import 'package:flutter/material.dart';
//theme
import 'package:fuel_iq/globals/theme_controller.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      //app bar
      appBar: AppBar(
        title:  Text(
          "Settings",
          style: TextStyle(
            color: colorScheme.onPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.25,
            height: 1.3,
          ),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
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
                      transitionDuration: const Duration(milliseconds: 150),
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

class ThemeSelectionPage extends StatelessWidget {
  const ThemeSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentTheme, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Settings",
              style: TextStyle(
                color: colorScheme.onPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.25,
                height: 1.3,
              ),
            ),
            centerTitle: true,
            backgroundColor: colorScheme.primary,
          ),
          body: RadioGroup<ThemeMode>(
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
        );
      },
    );
  }
}