import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fuel_iq/pages/nutrition/log_food_page.dart';
import 'package:fuel_iq/pages/nutrition/saved_foods.dart';
import 'package:fuel_iq/pages/nutrition/scan_barcode_page.dart';
import 'package:fuel_iq/pages/nutrition/water.dart';
import 'package:fuel_iq/pages/secondary/weight.dart';
import 'package:fuel_iq/utils/utils.dart';

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
    builder: (context) {
      return SizedBox(
        height: 350,
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // space evenly between cards
              children: [
                //Log Food
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 3,
                  color: colorScheme.surface,
                  child: InkWell(
                    onTap: () {
                      pushWithSlideFade(context, LogFood());
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: 100, // adjust width
                      height: 100, // adjust height
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.food_bank, size: 32, color: colorScheme.primary,),
                          SizedBox(height: 8),
                          Text('Log Food', textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  ),
                ),
                //Scan Barcode
                Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 3,
                color: colorScheme.surface,
                child: InkWell(
                  onTap: () async {

                  // Use root navigator for the next push
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
                
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.qr_code_scanner, size: 32, color: colorScheme.primary,),
                        SizedBox(height: 8),
                        Text('Scan', textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                ),
              ),
              ],
            ),
            const SizedBox( height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                            leading: Icon(Icons.bookmark, color: Colors.redAccent,),
                            title: const Text('Saved Foods')
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
                            leading: Icon(Icons.water_drop, color: Colors.blue.shade700,),
                            title: const Text('Water')
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
                            leading: Icon(FontAwesomeIcons.weightScale, color: colorScheme.primary,),
                            title: Text('Weight')
                          )
                        ),
                      ),
                    ),
                  ],
                )
          ],
        ),
      );
    },
  );
}