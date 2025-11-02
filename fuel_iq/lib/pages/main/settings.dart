import 'package:flutter/material.dart';
//theme
import 'package:fuel_iq/globals/theme_controller.dart';
import 'package:fuel_iq/globals/user_data.dart';
import 'package:fuel_iq/services/daily_data_provider.dart';
import 'package:provider/provider.dart';

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
        padding: const EdgeInsets.all(0.0),
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
            ),
            ListTile(
              leading: const Icon(Icons.flag),
              title: const Text('Target'),
              subtitle: const Text('Set Targets (Calories, Macros, Water)'),
              onTap: () {
                Navigator.push(
                  context,
                  //transition and page builder
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => const TargetSelectionPage(),
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
              "Theme",
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

class TargetSelectionPage extends StatefulWidget {
  const TargetSelectionPage({super.key});

  @override
  State<TargetSelectionPage> createState() => _TargetSelectionPageState();
}

class _TargetSelectionPageState extends State<TargetSelectionPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Targets",
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
      body: ListView(
        children: [
          // Calorie Target
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Calorie Target',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  caloriesTarget.toString(),
                  style: TextStyle(
                    color: colorScheme.tertiary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            onTap: () {
              showEditTargetDialog(
                context: context,
                title: 'Calorie Target',
                initialValue: caloriesTarget,
                onSave: (newValue) async {
                  final provider = Provider.of<DailyDataProvider>(context, listen: false);
                  setState(() => caloriesTarget = newValue);
                  await provider.updateSingleTarget(getTodaysDate(), 'calorieTarget', newValue);
                },
              );
            },
          ),

          // Protein Target
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Protein Target',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  proteinTarget.toString(),
                  style: TextStyle(
                    color: colorScheme.tertiary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            onTap: () {
              showEditTargetDialog(
                context: context,
                title: 'Protein Target',
                initialValue: proteinTarget,
                onSave: (newValue) async {
                  final provider = Provider.of<DailyDataProvider>(context, listen: false);
                  setState(() => proteinTarget = newValue);
                  await provider.updateSingleTarget(getTodaysDate(), 'proteinTarget', newValue);
                },
              );
            },
          ),

          // Carbs Target
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Carbs Target',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  carbsTarget.toString(),
                  style: TextStyle(
                    color: colorScheme.tertiary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            onTap: () {
              showEditTargetDialog(
                context: context,
                title: 'Carbs Target',
                initialValue: carbsTarget,
                onSave: (newValue) async {
                  final provider = Provider.of<DailyDataProvider>(context, listen: false);
                  setState(() => carbsTarget = newValue);
                  await provider.updateSingleTarget(getTodaysDate(), 'carbsTarget', newValue);
                },
              );
            },
          ),

          // Fats Target
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Fats Target',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  fatsTarget.toString(),
                  style: TextStyle(
                    color: colorScheme.tertiary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            onTap: () {
              showEditTargetDialog(
                context: context,
                title: 'Fats Target',
                initialValue: fatsTarget,
                onSave: (newValue) async {
                  final provider = Provider.of<DailyDataProvider>(context, listen: false);
                  setState(() => fatsTarget = newValue);
                  await provider.updateSingleTarget(getTodaysDate(), 'fatsTarget', newValue);
                },
              );
            },
          ),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Water Target',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  waterTarget.toString(),
                  style: TextStyle(
                    color: colorScheme.tertiary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            onTap: () {
              showEditTargetDialog(
                context: context,
                title: 'Water Target',
                initialValue: waterTarget,
                onSave: (newValue) async {
                  final provider = Provider.of<DailyDataProvider>(context, listen: false);
                  setState(() => waterTarget = newValue);
                  await provider.updateSingleTarget(
                    getTodaysDate(), 
                    'waterTarget', 
                    newValue,
                  );
                },
              );
            },
          ),
        ],
      )
    );
  }
}

// TODO : the change in targets is not saved as targets are not stored using 
// shared prefrences.
Future<void> showEditTargetDialog({
  required BuildContext context,
  required String title,
  required double initialValue,
  required Function(double newValue) onSave,
}) async {
  final controller = TextEditingController(text: initialValue.toStringAsFixed(0));

  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Set New $title'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: title,
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newValue = double.tryParse(controller.text);
              if (newValue != null && newValue > 0) {
                onSave(newValue);
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}
