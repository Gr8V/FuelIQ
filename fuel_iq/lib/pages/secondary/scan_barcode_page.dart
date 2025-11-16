import 'package:flutter/material.dart';
import 'package:fuel_iq/globals/user_data.dart';
import 'package:fuel_iq/services/daily_data_provider.dart';
import 'package:fuel_iq/services/notification_service.dart';
import 'package:fuel_iq/services/utils.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:fuel_iq/services/api_services.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;
class ScanBarcode extends StatefulWidget {
  const ScanBarcode({super.key});

  @override
  State<ScanBarcode> createState() => _ScanBarcodeState();
}

class _ScanBarcodeState extends State<ScanBarcode> {
  final MobileScannerController cameraController = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
  );

  bool isScanned = false;
  bool isTorchOn = false;
  bool supportsCamera = Platform.isAndroid || Platform.isIOS;

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  void _onBarcodeDetect(BarcodeCapture capture) {
    if (isScanned) return; // Prevent multiple detections

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final String? code = barcodes.first.rawValue;
    if (code != null) {
      setState(() => isScanned = true);


      // SnackBar confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Barcode detected: $code'),
          duration: const Duration(seconds: 2),
        ),
      );

      // Return scanned code
      Future.delayed(const Duration(milliseconds: 800), () {
        if (!mounted) return;
        Navigator.pop(context, code);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final screenSize = MediaQuery.of(context).size;
    const cutoutSize = Size(250, 250);

    // Centered scan window in widget coordinates (left, top, width, height)
    final scanWindow = Rect.fromCenter(
      center: Offset(screenSize.width / 2, screenSize.height / 2),
      width: cutoutSize.width,
      height: cutoutSize.height,
    );

    return Scaffold(
    appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Scan',
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
        actions: [
          // Toggle flashlight
          if (supportsCamera) 
          ...[
            IconButton(
              icon: Icon(
                isTorchOn ? Icons.flash_on : Icons.flash_off,
                color: colorScheme.onPrimary,
              ),
              onPressed: () {
                setState(() => isTorchOn = !isTorchOn);
                cameraController.toggleTorch();
              },
            ),
            // Switch camera
            IconButton(
              icon: Icon(Icons.cameraswitch, color: colorScheme.onPrimary),
              onPressed: () => cameraController.switchCamera(),
            ),
          ]
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          if (supportsCamera)
            ...[
               //Camera feed
              MobileScanner(
                controller: cameraController,
                onDetect: _onBarcodeDetect,
                scanWindow: scanWindow,
              ),

              //Dimming layer with transparent cutout
              Positioned.fill(
                child: CustomPaint(
                  painter: _ScannerOverlayPainter(),
                ),
              ),

              //Corner-only border scan area
              CustomPaint(
                size: const Size(250, 250),
                painter: _CornerBorderPainter(
                  color: colorScheme.primary,
                  strokeWidth: 4,
                  cornerLength: 28,
                  borderRadius: 16,
                ),
              ),

            ]
          else
            const Center(
              child: Text(
                "Camera not supported on this platform.",
                style: TextStyle(fontSize: 18),
              )
            ),
        ],
      ),
    );
  }
}



class BarcodeResultPage extends StatefulWidget {
  final String barcode;

  const BarcodeResultPage({super.key, required this.barcode});

  @override
  State<BarcodeResultPage> createState() => _BarcodeResultPageState();
}

class _BarcodeResultPageState extends State<BarcodeResultPage> {
  final _fooService = OpenFoodFactsService();
  ProductInfo? _productInfo;
  bool _isloading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    setState(() {
      _isloading = true;
      _error = null;
    });

    try {
      final product = await _fooService.getProductByBarcode(widget.barcode);

      if (product != null) {
        setState(() {
          _productInfo = _fooService.parseProductInfo(product);
          _isloading = false;
        });
      } else {
        setState(() {
          _error = 'Product not Found';
          _isloading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error loading product : $e';
        _isloading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scanned Result")),
      body: _isloading
        ? const Center(child: CircularProgressIndicator())
        : _error != null
          ? Center(child: Text(_error!))
          : _productInfo == null
            ? const Center(child: Text("No product info available"))
            : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Builder(
                builder: (context) {
                  // ✅ Safe to access here
                  final String foodName = _productInfo!.productName;
                  final String quantity = "100";
                  final double? calories = _productInfo!.energyKcal;
                  final double? protein = _productInfo!.proteins;
                  final double? carbs = _productInfo!.carbohydrates;
                  final double? fats = _productInfo!.fat;

                  final foodNameController = TextEditingController(text: foodName);
                  final quantityController = TextEditingController(text: quantity);
                  final caloriesController = TextEditingController(text: calories.toString());
                  final proteinController = TextEditingController(text: protein.toString());
                  final carbsController = TextEditingController(text: carbs.toString());
                  final fatsController = TextEditingController(text: fats.toString());
                  String? time;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Food Name
                      TextField(
                        controller: foodNameController,
                        decoration: InputDecoration(
                          labelText: 'Food Name',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Time
                      DropTile(
                        label: "Time",
                        value: time,
                        options: ["Breakfast", "Lunch", "Snacks", "Dinner"],
                        onChanged: (val) => setState(() => time = val),
                      ),
                      const SizedBox(height: 16),
                
                      // Quantity (grams/ml)
                      TextField(
                        controller: quantityController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Quantity (g/ml)',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 16),
                
                      // Calories
                      TextField(
                        controller: caloriesController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Calories',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 16),
                
                      // Protein
                      TextField(
                        controller: proteinController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Protein (g)',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 16),
                
                      // Carbs
                      TextField(
                        controller: carbsController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Carbs (g)',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 16),
                
                      // Fats
                      TextField(
                        controller: fatsController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Fats (g)',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 24),
                
                      // Save Button
                      ElevatedButton(
                        onPressed: () async {
                          final provider = Provider.of<DailyDataProvider>(context, listen: false);

                          //gets current calorie data
                          final currentData = provider.getDailyData(todaysDate) ?? {
                            'calories': 0.0,
                            'protein': 0.0,
                            'carbs': 0.0,
                            'fats': 0.0,
                            'water': 0.0,
                            'weight': 0.0,
                          };
                          final String foodName = foodNameController.text.trim();
                          final double? calories = double.tryParse(caloriesController.text.trim());
                
                          // Only add if name and calories are valid
                          if (foodName.isNotEmpty && calories != null && time != null) {
                            final foodEntry = {
                              'name': foodName,
                              'quantity': double.tryParse(quantityController.text.trim()) ?? 0,
                              'calories': calories,
                              'protein': double.tryParse(proteinController.text.trim()) ?? 0,
                              'carbs': double.tryParse(carbsController.text.trim()) ?? 0,
                              'fats': double.tryParse(fatsController.text.trim()) ?? 0,
                              'time': time ?? 'noTime',
                            };
                          // Sum the totals
                          final updatedData = {
                            'calories': (currentData['calories'] ?? 0.0) + foodEntry['calories'],
                            'protein': (currentData['protein'] ?? 0.0) + foodEntry['protein'],
                            'carbs': (currentData['carbs'] ?? 0.0) + foodEntry['carbs'],
                            'fats': (currentData['fats'] ?? 0.0) + foodEntry['fats'],
                            'water': currentData['water'],
                            'weight': currentData['weight'],
                          };
                
                
                            await provider.addFood(todaysDate, foodEntry);
                            await provider.updateDailyData(todaysDate, updatedData);

                            final List<Map<String, String>> notifs = [];

                            //calorie notifs
                            if ((currentData['calories'] ?? 0.0) >= currentData['calorieTarget']) {
                              notifs.add({
                              'title': 'Calories Overflow!!!',
                              'body': "You have gone ${updatedData['calories']-currentData['calorieTarget']}kcal over your calorie target."
                              });
                            } else if (updatedData['calories'] >= currentData['calorieTarget'] && currentData['calories'] != currentData['calorieTarget']) {
                              notifs.add({
                              'title': 'Calorie Goal Reached!',
                              'body': 'You have reached today\'s calorie goal.',
                              });
                            }
                            
                            //protein notifs
                            if (updatedData['protein'] >= currentData['proteinTarget'] && currentData['protein'] <= currentData['proteinTarget']) {
                              notifs.add({
                              'title': 'Protein Goal Reached!',
                              'body': 'You have reached today\'s protein goal.',
                              });
                            }
                            //carbs notifs
                            if (updatedData['carbs'] >= currentData['carbsTarget'] && currentData['carbs'] <= currentData['carbsTarget']) {
                              notifs.add({
                              'title': 'Carbs Goal Reached!',
                              'body': 'You have reached today\'s carbs goal.',
                              });
                            }
                            //protein notifs
                            if (updatedData['fats'] >= currentData['fatsTarget'] && currentData['fats'] <= currentData['fatsTarget']) {
                              notifs.add({
                              'title': 'Fats Goal Reached!',
                              'body': 'You have reached today\'s fats goal.',
                              });
                            }
                            //water notifs
                            if (updatedData['water'] >= currentData['waterTarget'] && currentData['water'] <= currentData['waterTarget']) {
                              notifs.add({
                              'title': 'Water Goal Reached!',
                              'body': 'You have reached today\'s water goal.',
                              });
                            }
                            await NotificationService.sendQueuedNotifications(notifs);
                                  
                            // Optional: clear fields after adding
                            foodNameController.clear();
                            quantityController.clear();
                            caloriesController.clear();
                            proteinController.clear();
                            carbsController.clear();
                            fatsController.clear();
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Food added successfully!')),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please enter a valid food name, calories and time')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Add Food',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(fontSize: 18, color: Colors.red),
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
    );
  }
}


/// Painter for stylish corner-only scanner borders
class _CornerBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double cornerLength;
  final double borderRadius;

  _CornerBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.cornerLength,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final rect = RRect.fromLTRBR(
      0,
      0,
      size.width,
      size.height,
      Radius.circular(borderRadius),
    );

    // Draw four corners only
    final path = Path();

    // Top-left
    path.moveTo(rect.left, rect.top + cornerLength);
    path.lineTo(rect.left, rect.top);
    path.lineTo(rect.left + cornerLength, rect.top);

    // Top-right
    path.moveTo(rect.right - cornerLength, rect.top);
    path.lineTo(rect.right, rect.top);
    path.lineTo(rect.right, rect.top + cornerLength);

    // Bottom-right
    path.moveTo(rect.right, rect.bottom - cornerLength);
    path.lineTo(rect.right, rect.bottom);
    path.lineTo(rect.right - cornerLength, rect.bottom);

    // Bottom-left
    path.moveTo(rect.left + cornerLength, rect.bottom);
    path.lineTo(rect.left, rect.bottom);
    path.lineTo(rect.left, rect.bottom - cornerLength);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


/// 🎨 Custom painter that dims the screen but leaves a transparent rectangle
class _ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;

    // Full screen dim
    final overlayRect = Rect.fromLTWH(0, 0, size.width, size.height);

    // Center transparent box
    final cutoutWidth = 250.0;
    final cutoutHeight = 250.0;
    final left = (size.width - cutoutWidth) / 2;
    final top = (size.height - cutoutHeight) / 2;
    final cutoutRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(left, top, cutoutWidth, cutoutHeight),
      const Radius.circular(16),
    );

    // Create path for the full screen
    final overlayPath = Path()..addRect(overlayRect);
    // Subtract the cutout area (transparent part)
    overlayPath.addRRect(cutoutRect);
    overlayPath.fillType = PathFillType.evenOdd;

    // Draw
    canvas.drawPath(overlayPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
