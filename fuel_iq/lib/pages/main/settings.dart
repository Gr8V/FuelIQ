import 'package:flutter/material.dart';
//theme
import 'package:fuel_iq/globals/theme_controller.dart';
import 'package:fuel_iq/globals/user_data.dart';
import 'package:fuel_iq/models/daily_data.dart';
import 'package:fuel_iq/pages/main/user_profile.dart';
import 'package:fuel_iq/providers/daily_data_provider.dart';
import 'package:fuel_iq/providers/saved_foods_provider.dart';
import 'package:fuel_iq/utils/utils.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

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
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Settings',
          style: TextStyle(
            color: colorScheme.primary,
            fontWeight: FontWeight.w700,
            fontSize: 22,
            letterSpacing: 1.1,
            fontFamily: 'Poppins',
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorScheme.onSurface.withValues(alpha: 0.1),
                colorScheme.surface.withValues(alpha: 0.1),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      //body
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SettingsSection(
              title: 'General',
              children: [
                SettingsCardTile(
                  icon: Icons.notifications,
                  title: 'Notifications',
                  onTap: () {
                    
                  },
                ),
                SettingsCardTile(
                  icon: Icons.color_lens,
                  title: 'Theme',
                  onTap: () {
                    pushWithSlideFade(context, ThemeSelectionPage());
                  },
                ),
                SettingsCardTile(
                  icon: Icons.language,
                  title: 'Language',
                  onTap: () {
                    
                  },
                ),
              ],
            ),
            SettingsSection(
              title: 'Training & Nutrition',
              children: [
                SettingsCardTile(
                  icon: Icons.flag,
                  title: 'Macro Targets',
                  onTap: () {
                    pushWithSlideFade(context, TargetSelectionPage());
                  },
                ),
              ],
            ),
            SettingsSection(
              title: 'Account',
              children: [
                SettingsCardTile(
                  icon: Icons.person,
                  title: 'User Profile',
                  onTap: () {
                    pushWithSlideFade(context, UserProfile());
                  },
                ),
              ],
            ),
            SettingsSection(
              title: 'Danger Zone',
              children: [
                SettingsCardTile(
                  icon: Icons.delete_forever,
                  bgColor: Colors.red,
                  title: 'Erase All Data',
                  onTap: () {
                    showEraseDataDialog(context: context);
                  },
                ),
              ],
            ),
            SettingsSection(
              title: 'Log Out',
              children: [
                SettingsCardTile(
                  icon: Icons.logout,
                  title: 'Sign Out',
                  onTap: () {
                    
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsCardTile extends StatelessWidget {
  final IconData icon;
  final String title;

  final VoidCallback onTap;
  final Color? bgColor;

  const SettingsCardTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: bgColor ?? colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            child: Row(
              children: [
                // Icon container
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colorScheme.secondary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: colorScheme.primary,
                  ),
                ),

                const SizedBox(width: 16),

                // Title + subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(Icons.chevron_right),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
        ),
        Column(children: children),
      ],
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
          //app bar
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            centerTitle: true,
            title: Text(
              'Theme',
              style: TextStyle(
                color: colorScheme.primary,
                fontWeight: FontWeight.w700,
                fontSize: 22,
                letterSpacing: 1.1,
                fontFamily: 'Poppins',
              ),
            ),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.onSurface.withValues(alpha: 0.1),
                    colorScheme.surface.withValues(alpha: 0.1),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
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

class TargetSelectionPage extends StatefulWidget {
  const TargetSelectionPage({super.key});

  @override
  State<TargetSelectionPage> createState() => _TargetSelectionPageState();
}

class _TargetSelectionPageState extends State<TargetSelectionPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DailyDataProvider>(context, listen: false)
          .loadDailyData(todaysDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final dailyData =
        context.watch<DailyDataProvider>().getDailyData(todaysDate) ??
            DailyDataModel();

    double dailyCalorieTarget = dailyData.calorieTarget;
    double dailyProteinTarget = dailyData.proteinTarget;
    double dailyCarbsTarget = dailyData.carbsTarget;
    double dailyFatsTarget = dailyData.fatsTarget;
    double dailyWaterTarget = dailyData.waterTarget;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Targets',
          style: TextStyle(
            color: colorScheme.primary,
            fontWeight: FontWeight.w700,
            fontSize: 22,
            letterSpacing: 1.1,
            fontFamily: 'Poppins',
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorScheme.onSurface.withValues(alpha: 0.1),
                colorScheme.surface.withValues(alpha: 0.1),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),

      body: ListView(
        children: [
          _buildTargetTile(
            context: context,
            label: "Calorie Target",
            value: dailyCalorieTarget,
            onSave: (newValue) async {
              final provider =
                  Provider.of<DailyDataProvider>(context, listen: false);
              await provider.updateSingleTarget(
                todaysDate,
                'calorieTarget',
                newValue,
              );
            },
          ),

          _buildTargetTile(
            context: context,
            label: "Protein Target",
            value: dailyProteinTarget,
            onSave: (newValue) async {
              final provider =
                  Provider.of<DailyDataProvider>(context, listen: false);
              await provider.updateSingleTarget(
                todaysDate,
                'proteinTarget',
                newValue,
              );
            },
          ),

          _buildTargetTile(
            context: context,
            label: "Carbs Target",
            value: dailyCarbsTarget,
            onSave: (newValue) async {
              final provider =
                  Provider.of<DailyDataProvider>(context, listen: false);
              await provider.updateSingleTarget(
                todaysDate,
                'carbsTarget',
                newValue,
              );
            },
          ),

          _buildTargetTile(
            context: context,
            label: "Fats Target",
            value: dailyFatsTarget,
            onSave: (newValue) async {
              final provider =
                  Provider.of<DailyDataProvider>(context, listen: false);
              await provider.updateSingleTarget(
                todaysDate,
                'fatsTarget',
                newValue,
              );
            },
          ),

          _buildTargetTile(
            context: context,
            label: "Water Target",
            value: dailyWaterTarget,
            onSave: (newValue) async {
              final provider =
                  Provider.of<DailyDataProvider>(context, listen: false);
              await provider.updateSingleTarget(
                todaysDate,
                'waterTarget',
                newValue,
              );
            },
          ),
        ],
      ),
    );
  }

  // =============================
  // REUSABLE TARGET TILE
  // =============================

  Widget _buildTargetTile({
    required BuildContext context,
    required String label,
    required double value,
    required Function(double) onSave,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(
            value.toString(),
            style: TextStyle(
              color: colorScheme.secondary,
              fontSize: 15,
            ),
          ),
        ],
      ),
      onTap: () {
        showEditTargetDialog(
          context: context,
          title: label,
          initialValue: value,
          onSave: onSave,
        );
      },
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
      final colorScheme = Theme.of(context).colorScheme;

      return AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        titlePadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
        contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),

        title: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
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
        ),

        content: const Text(
          "Are you sure you want to permanently delete all your data? This action cannot be undone.",
          style: TextStyle(fontSize: 15.5),
        ),

        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ),

          // DELETE BUTTON
          ElevatedButton(
            onPressed: () async {
              final dailyProvider = Provider.of<DailyDataProvider>(
                context,
                listen: false,
              );
              final savedFoodsProvider = Provider.of<SavedFoodsProvider>(
                context,
                listen: false,
              );

              // Clear ALL user data
              await dailyProvider.clearAll();
              await savedFoodsProvider.clearAll();

              // Reinitialize daily data (autofill today)
              await dailyProvider.initialize();

              if (!context.mounted) return;

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
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
      );
    },
  );
}
