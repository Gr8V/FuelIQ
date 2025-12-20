import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fuel_iq/services/notification_service.dart';
import 'package:fuel_iq/theme/colors.dart';
import 'package:google_fonts/google_fonts.dart';

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
            toolbarHeight: 74,
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
                  child: Text(
                    'HOME',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.3,
                    ),
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
                  //Date and Streak
                  SizedBox(
                    height: 30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Tue, 19 Dec",
                          style: GoogleFonts.inter(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            wordSpacing: 1.3,
                            color: colorScheme.onInverseSurface
                          )
                        ),
                        Container(
                          width: 70,
                          height: 30,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 225, 194), // light orange background
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.local_fire_department_rounded,
                                size: 18,
                                color: Color(0xFFFF7A00),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "5",
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFFF7A00),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  //Today's Workout
                  SizedBox(
                    height: 270,
                    width: double.infinity,
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "TODAY'S WORKOUT",
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                wordSpacing: 1.3,
                                color: colorScheme.onInverseSurface
                              ),
                            ),
                            Center(
                              child: Column(
                                children: [
                                  Text(
                                    "Back and Biceps",
                                    style: GoogleFonts.inter(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w800,
                                      wordSpacing: 1.3
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      //Top Set
                                      Expanded(
                                        child: SizedBox(
                                          height: 100,
                                          child: Card(
                                            color: colorScheme.primary.withValues(alpha: 0.12),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  Text(
                                                    "Top Set",
                                                    style: GoogleFonts.inter(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.w600,
                                                      wordSpacing: 1.3,
                                                      color: colorScheme.onInverseSurface
                                                    ),
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text(
                                                        "Deadlift",
                                                        style: GoogleFonts.inter(
                                                          fontSize: 15,
                                                          fontWeight: FontWeight.w500,
                                                          wordSpacing: 1.3
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "210",
                                                            style: GoogleFonts.inter(
                                                              fontSize: 15,
                                                              fontWeight: FontWeight.w600,
                                                              wordSpacing: 1.3
                                                            ),
                                                          ),
                                                          Text(
                                                            "kg",
                                                            style: GoogleFonts.inter(
                                                              fontSize: 15,
                                                              fontWeight: FontWeight.w400,
                                                              wordSpacing: 1.3
                                                            ),
                                                          ),
                                                          Text(
                                                            "x3 • RPE 7",
                                                            style: GoogleFonts.inter(
                                                              fontSize: 15,
                                                              fontWeight: FontWeight.w600,
                                                              wordSpacing: 1.3
                                                            ),
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: SizedBox(
                                          height: 100,
                                          child: Card(
                                            color: Color(0xFF4CAF50).withValues(alpha: 0.3),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  Text(
                                                    "Status",
                                                    style: GoogleFonts.inter(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.w600,
                                                      wordSpacing: 1.3,
                                                      color: colorScheme.onInverseSurface
                                                    ),
                                                  ),
                                                  Text(
                                                    "Completed",
                                                    style: GoogleFonts.inter(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.w600,
                                                      wordSpacing: 1.3,
                                                      color: Color(0xFF4CAF50).withValues(alpha: 0.8)
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    height: 34,
                                    width: double.infinity,
                                    child: Card(
                                      color: colorScheme.primary.withValues(alpha: 0.12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Next Workout • ",
                                            style: GoogleFonts.inter(
                                              fontSize: 15,
                                              wordSpacing: 1.3,
                                              fontWeight: FontWeight.w600,
                                              color: colorScheme.onInverseSurface
                                            ),
                                          ),
                                          Text(
                                            "Chest & Shoulders",
                                            style: GoogleFonts.inter(
                                              fontSize: 15,
                                              wordSpacing: 1.3,
                                              fontWeight: FontWeight.w500
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  //Supplements and Weight
                  Row(
                    children: [
                      //Supplements
                      Expanded(
                        child: SizedBox(
                          height: 100,
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "3/5 Taken",
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 20,
                                    wordSpacing: 1.3
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "Supplements",
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    wordSpacing: 1.3
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      //Weight
                      Expanded(
                        child: SizedBox(
                          height: 100,
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "95.6",
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 20,
                                            wordSpacing: 1.3
                                          ),
                                        ),
                                        Text(
                                          "kg",
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20,
                                            wordSpacing: 1.3
                                          ),
                                        )
                                      ],
                                    ),
                                    Icon(Icons.north, color: Colors.green)
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "Weight",
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    wordSpacing: 1.3
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  //Macros
                  SizedBox(
                    height: 140,
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Daily Macros',
                                      style: GoogleFonts.inter(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                        color: colorScheme.onInverseSurface,
                                        wordSpacing: 1.3
                                      ),
                                    ),
                                    _LegendRow('Calories', AppColors.calorieColor, '85%'),
                                    _LegendRow('Protein', AppColors.proteinColor, '65%'),
                                    _LegendRow('Carbs', AppColors.carbsColor, '45%'),
                                    _LegendRow('Fats', AppColors.fatColor, '30%'),
                                  ],
                                ),
                            ),
                            const SizedBox(width: 30),
                            SizedBox(
                              width: 110,
                              height: 110,
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
                  const SizedBox(height: 30),
                  //Water
                  SizedBox(
                    height: 100,
                    width: double.infinity,
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Stack(
                          children: [
                            // Background (unfilled)
                            Container(
                              width: double.infinity,
                              height: double.infinity,
                              color: Colors.white,
                            ),
                            // Progress fill
                            Align(
                              alignment: Alignment.centerLeft,
                              child: FractionallySizedBox(
                                widthFactor: 0.875.clamp(0.0, 1.0),
                                heightFactor: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFCFE8F9),
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                ),
                              ),
                            ),
                            // Content on top
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                children: [
                                  Text(
                                    '3.5L',
                                    style: GoogleFonts.inter(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500,
                                      color: colorScheme.onInverseSurface,
                                    ),
                                  ),
                                  const Spacer(),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Water Intake',
                                        style: GoogleFonts.inter(
                                          fontSize: 24,
                                          wordSpacing: 1.3,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.black
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Target: 4.0L',
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          color: colorScheme.onInverseSurface,
                                          fontWeight: FontWeight.w500
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  //Performance
                  SizedBox(
                    height: 150,
                    width: double.infinity,
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Performance",
                              style: GoogleFonts.inter(
                                color: colorScheme.onInverseSurface,
                                wordSpacing: 1.3,
                                fontSize: 20,
                                fontWeight: FontWeight.w800
                              ),
                            ),
                            Center(
                              child: SizedBox(
                                height: 60,
                                width: double.maxFinite,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  color: colorScheme.secondary.withValues(alpha: 0.3),
                                  child: Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Text(
                                      "Readiness score = 94/100",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.inter(
                                        color: colorScheme.onInverseSurface,
                                        fontSize: 15,
                                        wordSpacing: 1.3,
                                        fontWeight: FontWeight.w500
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  //Personal Records and Cardio
                  Row(
                    children: [
                      //Personal Records
                      Expanded(
                        child: SizedBox(
                          height: 150,
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Personal Records",
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.clip,
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      wordSpacing: 1.3,
                                      color: colorScheme.onInverseSurface
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        "Squat",
                                        style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w500
                                          ),
                                        ),
                                      Text(
                                        "180kg",
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        "Bench",
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500
                                        ),
                                      ),
                                      Text(
                                        "120kg",
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        "Deadlift",
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500
                                        ),
                                      ),
                                      Text(
                                        "240kg",
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      //Cardio
                      Expanded(
                        child: SizedBox(
                          height: 150,
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Cardio",
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.clip,
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      wordSpacing: 1.3,
                                      color: colorScheme.onInverseSurface
                                    ),
                                  ),
                                  Text(
                                    "No Cardio Today",
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
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
    const thickness = 5.0;
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
    return Row(
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
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                wordSpacing: 1.3
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
    );
  }
}
