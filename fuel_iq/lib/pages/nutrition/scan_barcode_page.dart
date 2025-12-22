import 'package:flutter/material.dart';
import 'package:fuel_iq/globals/user_data.dart';
import 'package:fuel_iq/models/food_entry.dart';
import 'package:fuel_iq/providers/daily_data_provider.dart';
import 'package:fuel_iq/providers/saved_foods_provider.dart';

import 'package:fuel_iq/utils/utils.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:fuel_iq/services/api_services.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;

import 'package:uuid/uuid.dart';
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
    appBar: CustomAppBar(
      title: "scan",
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
  late String? foodName = _productInfo?.productName;
  final String quantity = "100";
  late double? calories = _productInfo?.energyKcal;
  late double? protein = _productInfo?.proteins;
  late double? carbs = _productInfo?.carbohydrates;
  late double? fats = _productInfo?.fat;
  late TextEditingController foodNameController;
  late TextEditingController quantityController;
  late TextEditingController caloriesController;
  late TextEditingController proteinController;
  late TextEditingController carbsController;
  late TextEditingController fatsController;
  String? time;

  @override
  void initState() {
    super.initState();
    _loadProduct();
    foodNameController = TextEditingController(text: foodName);
    quantityController = TextEditingController(text: quantity);
    caloriesController = TextEditingController(text: calories.toString());
    proteinController = TextEditingController(text: protein.toString());
    carbsController = TextEditingController(text: carbs.toString());
    fatsController = TextEditingController(text: fats.toString());
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


  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Result"),
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

                  return Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [

                        /// FOOD NAME
                        TextFormField(
                          controller: foodNameController,
                          decoration: InputDecoration(
                            labelText: 'Food Name',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Food name cannot be empty";
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        /// TIME
                        DropTile(
                          label: "Time",
                          value: time,
                          options: ["Breakfast", "Lunch", "Snacks", "Dinner"],
                          onChanged: (val) => setState(() => time = val),
                        ),

                        const SizedBox(height: 16),

                        /// QUANTITY
                        TextFormField(
                          controller: quantityController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Quantity (g/ml)',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter quantity";
                            }
                            final numValue = double.tryParse(value);
                            if (numValue == null) {
                              return "Enter a number";
                            }
                            if (numValue < 0) {
                              return "Value cannot be negative";
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        /// CALORIES
                        TextFormField(
                          controller: caloriesController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Calories',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter calories";
                            }
                            final numValue = double.tryParse(value);
                            if (numValue == null) {
                              return "Enter a number";
                            }
                            if (numValue < 0) {
                              return "Value cannot be negative";
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        /// PROTEIN
                        TextFormField(
                          controller: proteinController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Protein (g)',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter protein";
                            }
                            final numValue = double.tryParse(value);
                            if (numValue == null) {
                              return "Enter a number";
                            }
                            if (numValue < 0) {
                              return "Value cannot be negative";
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        /// CARBS
                        TextFormField(
                          controller: carbsController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Carbs (g)',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter carbs";
                            }
                            final numValue = double.tryParse(value);
                            if (numValue == null) {
                              return "Enter a number";
                            }
                            if (numValue < 0) {
                              return "Value cannot be negative";
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        /// FATS
                        TextFormField(
                          controller: fatsController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Fats (g)',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter fats";
                            }
                            final numValue = double.tryParse(value);
                            if (numValue == null) {
                              return "Enter a number";
                            }
                            if (numValue < 0) {
                              return "Value cannot be negative";
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 24),

                        ElevatedButton(
                          onPressed: () async {
                            if (time == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please select time')),
                              );
                              return;
                            }
                            if (!_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please correct the errors')),
                              );
                              return;
                            }

                            final dailyProvider = Provider.of<DailyDataProvider>(context, listen: false);
                            final savedFoodsProvider = Provider.of<SavedFoodsProvider>(context, listen: false);

                            // Read input
                            String foodName = foodNameController.text.trim();
                            String foodId = const Uuid().v4();
                            double quantity = double.parse(quantityController.text);
                            double calories = double.parse(caloriesController.text);
                            double protein = double.parse(proteinController.text);
                            double carbs = double.parse(carbsController.text);
                            double fats = double.parse(fatsController.text);

                            // Create typed model entry
                            final entry = FoodEntry(
                              id: foodId,
                              name: foodName,
                              quantity: quantity,
                              calories: calories,
                              protein: protein,
                              carbs: carbs,
                              fats: fats,
                              time: time ?? "No Time"
                            );

                            // Add to today's food list
                            await dailyProvider.addFood(todaysDate, entry);

                            // Save to saved foods library
                            await savedFoodsProvider.saveFood({
                              'name': foodName,
                              'id': foodId,
                              'quantity': quantity,
                              'calories': calories,
                              'protein': protein,
                              'carbs': carbs,
                              'fats': fats,
                              'time': time,
                            });

                            // Clear inputs
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

                            Navigator.pop(context);
                          },
                          child: const Text('Add Food', style: TextStyle(fontSize: 18)),
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
                    ),
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
