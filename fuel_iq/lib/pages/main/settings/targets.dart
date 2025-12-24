import 'package:flutter/material.dart';
import 'package:fuel_iq/globals/user_data.dart';
import 'package:fuel_iq/models/daily_data.dart';
import 'package:fuel_iq/providers/daily_data_provider.dart';
import 'package:fuel_iq/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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
    final dailyData =
        context.watch<DailyDataProvider>().getDailyData(todaysDate) ??
            DailyDataModel();

    return Scaffold(
      appBar: CustomAppBar(title: "Targets"),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionHeader(title: "Nutrition"),

          _TargetCard(
            icon: Icons.local_fire_department_rounded,
            label: "Calories",
            unit: "kcal",
            value: dailyData.calorieTarget,
            onSave: (v) => _update(context, 'calorieTarget', v),
          ),
          _TargetCard(
            icon: Icons.fitness_center_rounded,
            label: "Protein",
            unit: "g",
            value: dailyData.proteinTarget,
            onSave: (v) => _update(context, 'proteinTarget', v),
          ),
          _TargetCard(
            icon: Icons.bakery_dining_rounded,
            label: "Carbs",
            unit: "g",
            value: dailyData.carbsTarget,
            onSave: (v) => _update(context, 'carbsTarget', v),
          ),
          _TargetCard(
            icon: Icons.opacity_rounded,
            label: "Fats",
            unit: "g",
            value: dailyData.fatsTarget,
            onSave: (v) => _update(context, 'fatsTarget', v),
          ),

          const SizedBox(height: 24),

          _SectionHeader(title: "Hydration"),

          _TargetCard(
            icon: Icons.water_drop_rounded,
            label: "Water",
            unit: "ml",
            value: dailyData.waterTarget,
            onSave: (v) => _update(context, 'waterTarget', v),
          ),
        ],
      ),
    );
  }

  Future<void> _update(
    BuildContext context,
    String field,
    double value,
  ) async {
    final provider = Provider.of<DailyDataProvider>(context, listen: false);
    await provider.updateSingleTarget(todaysDate, field, value);
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: colorScheme.secondary,
        ),
      ),
    );
  }
}

class _TargetCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String unit;
  final double value;
  final Function(double) onSave;

  const _TargetCard({
    required this.icon,
    required this.label,
    required this.unit,
    required this.value,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: colorScheme.secondary.withValues(alpha: 0.5),
          child: Icon(icon, color: colorScheme.primary),
        ),
        title: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: const Text("Tap to edit"),
        trailing: Text(
          "${value.toStringAsFixed(0)} $unit",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: colorScheme.primary,
          ),
        ),
        onTap: () {
          showEditTargetDialog(
            context: context,
            title: label,
            initialValue: value,
            unit: unit,
            onSave: onSave,
          );
        },
      ),
    );
  }
}

Future<void> showEditTargetDialog({
  required BuildContext context,
  required String title,
  required String unit,
  required double initialValue,
  required Function(double) onSave,
}) async {
  final controller =
      TextEditingController(text: initialValue.toStringAsFixed(0));

  await showDialog(
    
    context: context,
    builder: (context) {
      return AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        titlePadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
        contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        title: Text(
          "Set $title Target",
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            suffixText: unit,
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final value = double.tryParse(controller.text);
              if (value != null && value > 0) {
                onSave(value);
                Navigator.pop(context);
              }
            },
            child: const Text("Save"),
          ),
        ],
      );
    },
  );
}
