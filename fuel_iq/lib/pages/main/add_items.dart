import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fuel_iq/pages/nutrition/log_food_page.dart';
import 'package:fuel_iq/pages/nutrition/saved_foods.dart';
import 'package:fuel_iq/pages/nutrition/scan_barcode_page.dart';
import 'package:fuel_iq/pages/nutrition/supplements.dart';
import 'package:fuel_iq/pages/nutrition/water.dart';
import 'package:fuel_iq/pages/secondary/weight.dart';
import 'package:fuel_iq/pages/training/log_cardio.dart';
import 'package:fuel_iq/pages/training/log_workout.dart';
import 'package:fuel_iq/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';

void showAddFoodDrawer(BuildContext context) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    
    backgroundColor: colorScheme.tertiary,
    isScrollControlled: true,
    showDragHandle: false, //alreayd have custom drag handle
    builder: (context) {
      return SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //custom drag handle
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              //content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //Log Workout
                        Expanded(
                          child: _ActionCard(
                            icon: FontAwesomeIcons.dumbbell,
                            label: 'Log Workout',
                            color: colorScheme.primary,
                            onTap: () {
                              pushWithSlideFade(context, LogWorkout());
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        //Log Cardio
                        Expanded(
                          child: _ActionCard(
                            icon: FontAwesomeIcons.personRunning,
                            label: 'Log Cardio',
                            color: colorScheme.primary,
                            onTap: () {
                              pushWithSlideFade(context, LogCardio());
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //Log Food
                        Expanded(
                          child: _ActionCard(
                            icon: Icons.restaurant_menu,
                            label: 'Log Food',
                            color: colorScheme.primary,
                            onTap: () {
                              pushWithSlideFade(context, LogFood());
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        //Scan Barcode
                        Expanded(
                          child: _ActionCard(
                            icon: Icons.qr_code_scanner,
                            label: 'Scan Food',
                            color: colorScheme.primary,
                            onTap: () async {
                              //Get the QR code from scan barcode page
                              final code = await Navigator.of(context, rootNavigator: true).push(
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) => const ScanBarcode(),
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    return SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(1.0, 0.0),
                                        end: Offset.zero,
                                      ).animate(animation),
                                      child: FadeTransition(opacity: animation, child: child),
                                    );
                                  },
                                  transitionDuration: const Duration(milliseconds: 150),
                                ),
                              );
                              if (!context.mounted) return;
                
                              //Push to barcode result page
                              if (code != null && code is String) {
                                Navigator.of(context, rootNavigator: true).push(
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) =>
                                        BarcodeResultPage(barcode: code),
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                      return SlideTransition(
                                        position: Tween<Offset>(
                                          begin: const Offset(1.0, 0.0),
                                          end: Offset.zero,
                                        ).animate(animation),
                                        child: FadeTransition(opacity: animation, child: child),
                                      );
                                    },
                                    transitionDuration: const Duration(milliseconds: 150),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    //Supplements
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 3,
                      color: colorScheme.surface,
                      child: InkWell(
                        onTap: () {
                          pushWithSlideFade(context, Supplements());
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          child: ListTile(
                            dense: true,
                            visualDensity: VisualDensity.compact,
                            leading: Icon(FontAwesomeIcons.pills, color: Colors.redAccent,),
                            title: Text(
                              'Supplements',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w400
                              ),
                            )
                          )
                        ),
                      ),
                    ),
                    //Saved Foods
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 3,
                      color: colorScheme.surface,
                      child: InkWell(
                        onTap: () {
                          pushWithSlideFade(context, SavedFoods());
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          child: ListTile(
                            dense: true,
                            visualDensity: VisualDensity.compact,
                            leading: Icon(Icons.bookmark, color: Colors.redAccent,),
                            title: Text(
                              'Saved Food',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w400
                              ),
                            )
                          )
                        ),
                      ),
                    ),
                    //Water
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 3,
                      color: colorScheme.surface,
                      child: InkWell(
                        onTap: () {
                          pushWithSlideFade(context, WaterPage());
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          child: ListTile(
                            dense: true,
                            visualDensity: VisualDensity.compact,
                            leading: Icon(Icons.water_drop, color: Colors.blue.shade700,),
                            title: Text(
                              'Water',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w400
                              ),
                            )
                          )
                        ),
                      ),
                    ),
                    //weight
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 3,
                      color: colorScheme.surface,
                      child: InkWell(
                        onTap: () {
                          pushWithSlideFade(context, WeightPage());
                        },
                        borderRadius: BorderRadius.circular(12),
                        child:  SizedBox(
                          child: ListTile(
                            dense: true,
                            visualDensity: VisualDensity.compact,
                            leading: Icon(FontAwesomeIcons.weightScale, color: colorScheme.primary,),
                            title: Text(
                              'Weight',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w400
                              ),
                            )
                          )
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      );
    },
  );
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 88,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w400
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
