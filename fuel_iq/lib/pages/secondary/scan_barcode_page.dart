import 'package:flutter/material.dart';
import 'package:fuel_iq/globals/user_data.dart';
import 'package:fuel_iq/services/daily_data_provider.dart';
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
        Navigator.pop(context, code);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Scan Barcode",
          style: TextStyle(
            color: colorScheme.onPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
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
              MobileScanner(
                controller: cameraController,
                onDetect: _onBarcodeDetect,
              ),
              // Overlay box for scan focus area
              Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: colorScheme.primary,
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              // Dimmed background outside scanning box
              ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.black,
                  BlendMode.srcOut,
                ),
                child: Stack(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        backgroundBlendMode: BlendMode.dstOut,
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 250,
                        height: 250,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ],
                ),
              )
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
                        if (foodName.isNotEmpty && calories != null) {
                          final foodEntry = {
                            'name': foodName,
                            'quantity': double.tryParse(quantityController.text.trim()) ?? 0,
                            'calories': calories,
                            'protein': double.tryParse(proteinController.text.trim()) ?? 0,
                            'carbs': double.tryParse(carbsController.text.trim()) ?? 0,
                            'fats': double.tryParse(fatsController.text.trim()) ?? 0,
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
              
                          // Optional: clear fields after adding
                          foodNameController.clear();
                          quantityController.clear();
                          caloriesController.clear();
                          proteinController.clear();
                          carbsController.clear();
                          fatsController.clear();
              
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Food added successfully!')),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please enter a valid food name and calories')),
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
