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
    //final theme = Theme.of(context);
    //final colorScheme = theme.colorScheme;

    final dailyData =
        context.watch<DailyDataProvider>().getDailyData(todaysDate) ??
            DailyDataModel();

    double dailyCalorieTarget = dailyData.calorieTarget;
    double dailyProteinTarget = dailyData.proteinTarget;
    double dailyCarbsTarget = dailyData.carbsTarget;
    double dailyFatsTarget = dailyData.fatsTarget;
    double dailyWaterTarget = dailyData.waterTarget;

    return Scaffold(
      appBar: CustomAppBar(title: "Targets"),

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
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        title: Text(
          'Set New $title',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600
          ),
        ),

        content: SizedBox(
          width: 320,
          height: 60,
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: title,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final newValue = double.tryParse(controller.text);
              if (newValue != null && newValue > 0) {
                onSave(newValue);
                Navigator.pop(context);
              }
            },
            child: Text(
              'Save',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600
              ),
            ),
          ),
        ],
      );
    },
  );
}