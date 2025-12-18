import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fuel_iq/services/notification_service.dart';

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
            backgroundColor: Colors.transparent,
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
                    width: 260,
                    height: 260,
                    child: CustomPaint(
                      painter: MacroRingPainter(
                        macros: const [
                          MacroRing(0.85, Colors.redAccent),   // Calories
                          MacroRing(0.65, Colors.orangeAccent),// Protein
                          MacroRing(0.45, Colors.blueAccent),  // Carbs
                          MacroRing(0.30, Colors.greenAccent), // Fats
                        ],
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Daily Macros',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '72%',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  _legendDot('Calories', Colors.redAccent),
                  _legendDot('Protein', Colors.orangeAccent),
                  _legendDot('Carbs', Colors.blueAccent),
                  _legendDot('Fats', Colors.greenAccent),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _legendDot(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
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
    const thickness = 14.0;
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
