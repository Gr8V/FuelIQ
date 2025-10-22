import 'package:flutter/material.dart';
import 'package:fuel_iq/pages/secondary/log_food_page.dart';
import 'package:fuel_iq/pages/secondary/scan_barcode_page.dart';
import 'package:fuel_iq/pages/secondary/water.dart';
import 'package:fuel_iq/pages/secondary/weight.dart';

void showAddFoodDrawer(BuildContext context) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;
  showModalBottomSheet(
    
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: colorScheme.secondary,
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
                      Navigator.push(
                        context,
                        //transition and page builder
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => const LogFood(),
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
                    borderRadius: BorderRadius.circular(12),
                    child: const SizedBox(
                      width: 100, // adjust width
                      height: 100, // adjust height
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.food_bank, size: 32),
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
                    onTap: () {
                      Navigator.push(
                        context,
                        //transition and page builder
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => const ScanBarcode(),
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
                    borderRadius: BorderRadius.circular(12),
                    child: const SizedBox(
                      width: 100,
                      height: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.qr_code_scanner, size: 32),
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
                    //Water
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 3,
                      color: colorScheme.surface,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            //transition and page builder
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) => const WaterPage(),
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
                          Navigator.push(
                            context,
                            //transition and page builder
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) => const WeightPage(),
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
                        borderRadius: BorderRadius.circular(12),
                        child: const SizedBox(
                          child: ListTile(
                            leading: Icon(Icons.monitor_weight, color: Colors.greenAccent,),
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