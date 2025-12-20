import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fuel_iq/services/notification_service.dart';
import 'package:fuel_iq/theme/colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            elevation: 0,
            backgroundColor: Colors.amber,
            centerTitle: true,
            title: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [colorScheme.primary, colorScheme.secondary],
                  ).createShader(bounds),
                  child: const Text(
                    'Powerlifting App',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.3,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Performance Meets Precision',
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.notifications, color: colorScheme.primary),
                onPressed: () {
                  NotificationService.showNotification(
                    title: 'TEST NOTIFICATION',
                    body: 'This is a test notification.',
                  );
                },
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                    child: Row(
                      children: [
                        Text(
                          "Tue, 19 Dec",
                          style: TextStyle(
                            wordSpacing: 1.3,
                            fontWeight: FontWeight.w600,
                            fontSize: 24,
                            fontFamily: "roboto"
                          ),
                          )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 200,
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            // 🔹 LEFT: Text / Legend
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      'Daily Macros',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                
                                    _LegendRow('Calories', Colors.redAccent, '85%'),
                                    _LegendRow('Protein', Colors.orangeAccent, '65%'),
                                    _LegendRow('Carbs', Colors.blueAccent, '45%'),
                                    _LegendRow('Fats', Colors.greenAccent, '30%'),
                                  ],
                                ),
                              ),
                            ),

                            // 🔹 RIGHT: Circular Chart
                            SizedBox(
                              width: 140,
                              height: 140,
                              child: CustomPaint(
                                painter: MacroRingPainter(
                                  macros: [
                                    //Calories Ring
                                    MacroRing(0.85, AppColors.calorieColor),
                                    //Protein Ring
                                    MacroRing(0.65, AppColors.proteinColor),
                                    //Carbs Ring
                                    MacroRing(0.45, AppColors.carbsColor),
                                    //Fats Ring
                                    MacroRing(0.30, AppColors.fatColor),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MacroRingPainter extends CustomPainter {
  final List<MacroRing> macros;

  MacroRingPainter({required this.macros});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final startAngle = -pi / 2;
    const thickness = 7.0;
    const gap = 10.0;

    double radius = size.width / 2 - thickness;

    for (final macro in macros) {
      // Background ring
      final bgPaint = Paint()
        ..color = macro.color.withValues(alpha: 0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = thickness
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        0,
        2 * pi,
        false,
        bgPaint,
      );

      // Progress ring
      final fgPaint = Paint()
        ..color = macro.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = thickness
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        2 * pi * macro.value,
        false,
        fgPaint,
      );

      radius -= (thickness + gap);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class MacroRing {
  final double value; // 0.0 → 1.0
  final Color color;

  const MacroRing(this.value, this.color);
}

class _LegendRow extends StatelessWidget {
  final String label;
  final Color color;
  final String value;

  const _LegendRow(this.label, this.color, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
