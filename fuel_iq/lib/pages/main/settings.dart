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
              title: const Text('Targets'),
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
            ),
            ListTile(
              leading: const Icon(Icons.flag),
              
              title: const Text('Erase All Data'),
              subtitle: const Text(''),
              onTap: () {
                showEraseDataDialog(context: context);
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


Future<void> showEraseDataDialog({
  required BuildContext context,
}) async {
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              child: const Icon(
                Icons.warning_rounded,
                color: Colors.red,
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Delete All Data',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final provider = Provider.of<DailyDataProvider>(
                context,
                listen: false,
              );
              await provider.clearAllData();
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.white),
                        SizedBox(width: 8),
                        Text('All data cleared successfully'),
                      ],
                    ),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Delete All',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      );
    },
  );
}


