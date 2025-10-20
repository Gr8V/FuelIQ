import 'package:flutter/material.dart';
import 'package:fuel_iq/pages/secondary/water.dart';
import 'dart:math';

import 'package:fuel_iq/theme/colors.dart';

const months = [
    "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December"
  ];
String todaysDate = "${DateTime.now().day} ${months[DateTime.now().month-1]} ${DateTime.now().year}";
String appBarTitle = todaysDate;



class HomePage extends StatefulWidget {
  const HomePage({super.key});
  
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      //app bar
      appBar: AppBar(
        title:  Text(
          appBarTitle,
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
      //body
      body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                //calories eaten
                Card(
                  elevation: 3,
                  color: theme.cardColor,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Calories Eaten',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width *0.07,
                                color: colorScheme.onSurface
                              ),
                            ),
                            CaloriesCircularChart(
                              eaten: 60,
                              goal: 1800,
                              size: 100,
                              backgroundArcColor: colorScheme.surface,
                              foregroundArcColor: colorScheme.primary,
                              centerTextColor: colorScheme.onSurface,
                              strokeWidth: 10,
                            )
                          ],
                    ),
                  ),
                ),
                //Macros
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    //protein
                    Expanded(
                      child: Card(
                        elevation: 3,
                        color: theme.cardColor,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: MacroTile(
                                label: 'Protein',
                                eaten: 10, 
                                goal: 100,
                                bgColor: colorScheme.surface,
                                fgColor: AppColors.proteinColor,
                                centerTextColor: colorScheme.onSurface,
                              ),
                        ),
                      ),
                    ),
                    //carbs
                    Expanded(
                      child: Card(
                        elevation: 3,
                        color: theme.cardColor,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: MacroTile(
                                label: 'Carbs',
                                eaten: 10, 
                                goal: 100,
                                bgColor: colorScheme.surface,
                                fgColor: AppColors.carbsColor,
                                centerTextColor: colorScheme.onSurface,
                              ),
                        ),
                      ),
                    ),
                    //fats
                    Expanded(
                      child: Card(
                        elevation: 3,
                        color: theme.cardColor,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: MacroTile(
                                label: 'Fats',
                                eaten: 10, 
                                goal: 100,
                                bgColor: colorScheme.surface,
                                fgColor: AppColors.fatColor,
                                centerTextColor: colorScheme.onSurface,
                              ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                //others
                Card(
                  color: theme.cardColor,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Card(
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            ),
                            leading: CaloriesCircularChart(
                              eaten: 100,
                              goal: 200,
                              size: 40,
                              backgroundArcColor: colorScheme.surface,
                              foregroundArcColor: colorScheme.primary,
                              centerTextColor: colorScheme.onSurface,
                              strokeWidth: 2,
                              icon: Icons.water_drop,
                            ),
                            title: const Text('Water Intake'),
                            subtitle: const Text('500 ml remaining'),
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
                          )
                          ),
                      ],
                    ),
                  
                )
              ],
            ),
      )
    );
  }
}


class MacroTile extends StatelessWidget {
  final String label;
  final double eaten;
  final double goal;
  final Color bgColor;
  final Color fgColor;
  final Color centerTextColor;

  const MacroTile({super.key, required this.label, required this.eaten, required this.goal,
    required this.bgColor, required this.fgColor, required this.centerTextColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CaloriesCircularChart(
          eaten: eaten,
          goal: goal,
          size: 70,
          backgroundArcColor: bgColor,
          foregroundArcColor: fgColor,
          centerTextColor: centerTextColor,
          strokeWidth: 5,
          ),
        const SizedBox(height: 4),
        Text(label),
      ],
    );
  }
}


/// Reusable animated circular chart with optional icon in center.
class CaloriesCircularChart extends StatefulWidget {
  final double eaten;
  final double goal;
  final double size; // diameter
  final Color backgroundArcColor;
  final Color foregroundArcColor;
  final Color centerTextColor;
  final double strokeWidth;
  final Duration animationDuration;
  final IconData? icon; // 🔹 NEW optional icon field

  const CaloriesCircularChart({
    Key? key,
    required this.eaten,
    required this.goal,
    this.size = 160,
    this.backgroundArcColor = const Color(0xFF2E2E2E),
    this.foregroundArcColor = const Color(0xFF00C853),
    this.centerTextColor = Colors.white,
    this.strokeWidth = 16.0,
    this.animationDuration = const Duration(milliseconds: 700),
    this.icon, // 🔹 optional
  }) : super(key: key);

  @override
  State<CaloriesCircularChart> createState() => _CaloriesCircularChartState();
}

class _CaloriesCircularChartState extends State<CaloriesCircularChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _oldPercent = 0.0;
  double _targetPercent = 0.0;

  @override
  void initState() {
    super.initState();
    _oldPercent = _clampPercent(widget.eaten / max(widget.goal, 1));
    _targetPercent = _oldPercent;
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _animation = Tween<double>(begin: _oldPercent, end: _targetPercent)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut))
      ..addListener(() => setState(() {}));
  }

  @override
  void didUpdateWidget(covariant CaloriesCircularChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newPercent = _clampPercent(widget.eaten / max(widget.goal, 1));
    _oldPercent = _animation.value;
    _targetPercent = newPercent;
    _animation = Tween<double>(begin: _oldPercent, end: _targetPercent)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller
      ..duration = widget.animationDuration
      ..forward(from: 0.0);
  }

  double _clampPercent(double v) => v.isFinite ? v.clamp(0.0, 1.0) : 0.0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final percent = _animation.value;
    final eatenAmount = widget.eaten;
    final goalAmount = widget.goal;
    final displayedPercent = (percent * 100).round();

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background + progress arcs
          CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _DonutPainter(
              progress: percent,
              backgroundArcColor: widget.backgroundArcColor,
              foregroundArcColor: widget.foregroundArcColor,
              strokeWidth: widget.strokeWidth,
            ),
          ),

          // 🔹 Center content (text or icon)
          if (widget.icon == null)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${eatenAmount.toInt()} / ${goalAmount.toInt()}',
                  style: TextStyle(
                    color: widget.centerTextColor,
                    fontSize: widget.size * 0.14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '$displayedPercent%',
                  style: TextStyle(
                    color: widget.centerTextColor.withOpacity(0.85),
                    fontSize: widget.size * 0.18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )
          else
            Icon(
              widget.icon,
              size: widget.size * 0.45,
              color: widget.foregroundArcColor,
            ),
        ],
      ),
    );
  }
}

/// Draws circular arcs for progress visualization.
class _DonutPainter extends CustomPainter {
  final double progress;
  final Color backgroundArcColor;
  final Color foregroundArcColor;
  final double strokeWidth;

  _DonutPainter({
    required this.progress,
    required this.backgroundArcColor,
    required this.foregroundArcColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (min(size.width, size.height) - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);
    const startAngle = -pi / 2;

    final bgPaint = Paint()
      ..color = backgroundArcColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final fgPaint = Paint()
      ..color = foregroundArcColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    canvas.drawArc(rect, startAngle, 2 * pi, false, bgPaint);
    canvas.drawArc(rect, startAngle, 2 * pi * progress, false, fgPaint);
  }

  @override
  bool shouldRepaint(covariant _DonutPainter old) {
    return old.progress != progress ||
        old.backgroundArcColor != backgroundArcColor ||
        old.foregroundArcColor != foregroundArcColor ||
        old.strokeWidth != strokeWidth;
  }
}
