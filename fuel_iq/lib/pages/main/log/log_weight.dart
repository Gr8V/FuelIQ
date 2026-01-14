import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fuel_iq/globals/user_data.dart';
import 'package:fuel_iq/models/daily_data_model.dart';
import 'package:fuel_iq/providers/daily_data_provider.dart';
import 'package:fuel_iq/utils/date_utils.dart';
import 'package:fuel_iq/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';


class WeightPickerPage extends StatefulWidget {
  const WeightPickerPage({super.key});

  @override
  State<WeightPickerPage> createState() => _WeightPickerPageState();
}

class _WeightPickerPageState extends State<WeightPickerPage> {
  int? weightInt;
  int? weightDecimal;
  bool _isSaving = false;


  late FixedExtentScrollController intController;
  late FixedExtentScrollController decimalController;

  static const double itemHeight = 50;

  @override
  void initState() {
    super.initState();
    intController = FixedExtentScrollController(initialItem: 70 - 30);
    decimalController = FixedExtentScrollController(initialItem: 0);
    _getWeight();
  }

  @override
  void dispose() {
    intController.dispose();
    decimalController.dispose();
    super.dispose();
  }

  Future<void> _getWeight() async {
    final dailyProvider =
        Provider.of<DailyDataProvider>(context, listen: false);

    final double? weight =
        dailyProvider.getWeight(todaysDate);

    if (weight == null) return;

    final int newInt = weight.floor();
    final int newDecimal = ((weight * 10).round()) % 10;

    setState(() {
      weightInt = newInt;
      weightDecimal = newDecimal;
    });

    // 🔥 WAIT until the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      intController.jumpToItem(newInt - 30);
      decimalController.jumpToItem(newDecimal);
    });
  }




  Future<void> _saveWeight() async {
    if (_isSaving) return;

    if (weightInt == null || weightDecimal == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a valid weight first"),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final double newWeightValue =
          weightInt! + (weightDecimal! / 10.0);

      final dailyProvider =
          Provider.of<DailyDataProvider>(context, listen: false);

      final today = DateUtilsExt.today();

      final existing =
          dailyProvider.getDailyData(today) ?? DailyDataModel();

      existing.weight = newWeightValue;

      await dailyProvider.updateDailyData(today, existing);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Weight saved successfully!"),
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }




  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      appBar: CustomAppBar(title: "weight"),
      body: SafeArea(
        child: DefaultTextStyle(
          style: GoogleFonts.inter(
            color: CupertinoColors.label,
          ),
          child: Column(
            children: [
              SizedBox(
                height: 300,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Full-width selection overlay
                    IgnorePointer(
                      child: Container(
                        height: itemHeight,
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        decoration: BoxDecoration(
                          color: CupertinoColors.systemGrey.withOpacity(0.15),
                          border: const Border(
                            top: BorderSide(color: CupertinoColors.systemGrey4, width: 0.6),
                            bottom: BorderSide(color: CupertinoColors.systemGrey4, width: 0.6),
                          ),
                        ),
                      ),
                    ),

                    // Pickers row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Integer picker
                        SizedBox(
                          width: 90,
                          height: 300,
                          child: ListWheelScrollView.useDelegate(
                            controller: intController,
                            physics: const FixedExtentScrollPhysics(),
                            itemExtent: itemHeight,
                            onSelectedItemChanged: (i) {
                              HapticFeedback.selectionClick();
                              setState(() => weightInt = i + 30);
                            },
                            childDelegate: ListWheelChildBuilderDelegate(
                              childCount: 171,
                              builder: (context, index) {
                                return Center(
                                  child: Text(
                                    "${index + 30}",
                                    style: GoogleFonts.inter(
                                      fontSize: 26,
                                      fontWeight: FontWeight.w600,
                                      color: colorScheme.primary
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6),
                          child: Text(
                            ".",
                            style: GoogleFonts.inter(
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary
                            ),
                          ),
                        ),

                        // Decimal picker
                        SizedBox(
                          width: 70,
                          height: 300,
                          child: ListWheelScrollView.useDelegate(
                            controller: decimalController,
                            physics: const FixedExtentScrollPhysics(),
                            itemExtent: itemHeight,
                            onSelectedItemChanged: (i) {
                              HapticFeedback.selectionClick();
                              setState(() => weightDecimal = i);
                            },
                            childDelegate: ListWheelChildBuilderDelegate(
                              childCount: 10,
                              builder: (context, index) {
                                return Center(
                                  child: Text(
                                    "$index",
                                    style: GoogleFonts.inter(
                                      fontSize: 26,
                                      fontWeight: FontWeight.w600,
                                      color: colorScheme.primary
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "kg",
                          style: GoogleFonts.inter(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: colorScheme.primary
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              Text(
                "$weightInt.$weightDecimal kg",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 100,
                width: MediaQuery.of(context).size.width-32,
                child: Card(
                  color: Colors.green.withValues(alpha: 0.8),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      _saveWeight();
                    },
                    child: Center(
                      child: Text(
                        "Save",
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          fontSize: 34,
                          wordSpacing: 1.3
                        ),
                      ),
                    ),
                  ),
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}