import 'package:flutter/material.dart';

class ScanBarcode extends StatefulWidget {
  const ScanBarcode({super.key});

  @override
  State<ScanBarcode> createState() => _ScanBarcodeState();
}

class _ScanBarcodeState extends State<ScanBarcode> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      //app bar
      appBar: AppBar(
        title:  Text(
          "Scan Barcode",
          style: TextStyle(
            color: colorScheme.onPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.25,
            height: 1.3,
          ),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
        ),
        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              
            ],
          ),
        ),
    );
  }
}