import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';


class SimpleLineChart extends StatelessWidget {
  final Map<String, double> data;

  const SimpleLineChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final xLabels = data.keys.toList();
    final yValues = data.values.toList();

    if (yValues.isEmpty) {
      return const Center(child: Text("No data available"));
    }

    // Calculate min and max
    final double minY = yValues.reduce((a, b) => a < b ? a : b);
    final double maxY = yValues.reduce((a, b) => a > b ? a : b);

    // Add padding to min/max (10% on each side)
    final double range = maxY - minY;
    final double paddedMinY = range == 0 ? minY - 5 : minY - (range * 0.1);
    final double paddedMaxY = range == 0 ? maxY + 5 : maxY + (range * 0.1);

    return AspectRatio(
      aspectRatio: 1.6,
      child: Padding(
        padding: const EdgeInsets.only(right: 16, top: 16),
        child: LineChart(
          LineChartData(
            minY: paddedMinY,
            maxY: paddedMaxY,
            borderData: FlBorderData(show: false),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: Colors.grey,
                  strokeWidth: 1,
                );
              },
            ),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 50,
                  interval: (paddedMaxY - paddedMinY) / 5, // 5 labels on Y-axis
                  getTitlesWidget: (value, meta) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        value.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  },
                ),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index < 0 || index >= xLabels.length) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        xLabels[index],
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: List.generate(
                  yValues.length,
                  (i) => FlSpot(i.toDouble(), yValues[i]),
                ),
                isCurved: true,
                color: Colors.blueAccent,
                barWidth: 3,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 4,
                      color: Colors.white,
                      strokeWidth: 2,
                      strokeColor: Colors.blueAccent,
                    );
                  },
                ),
                belowBarData: BarAreaData(
                  show: true,
                  color: Colors.blueAccent,
                ),
              ),
            ],
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((spot) {
                    final index = spot.x.toInt();
                    return LineTooltipItem(
                      '${xLabels[index]}\n${spot.y.toStringAsFixed(1)} kg',
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }).toList();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DropTile extends StatefulWidget {
  final String label;
  final String? value;
  final List<String> options;
  final void Function(String) onChanged;

  const DropTile({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  State<DropTile> createState() => _DropTileState();
}
class _DropTileState extends State<DropTile> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main dropdown container
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade800),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => setState(() => isOpen = !isOpen),

                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.value ?? widget.label,   // 👈 default placeholder
                        style: TextStyle(
                          fontSize: 16,
                          color: widget.value == null
                              ? Colors.grey.shade600
                              : Colors.white,
                        ),
                      ),
                      AnimatedRotation(
                        duration: const Duration(milliseconds: 200),
                        turns: isOpen ? 0.5 : 0,
                        child: const Icon(Icons.arrow_drop_down),
                      ),
                    ],
                  ),
                ),
              ),

              // OPTIONS
              AnimatedSize(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                child: isOpen
                    ? Column(
                        children: widget.options.map((opt) {
                          return InkWell(
                            onTap: () {
                              widget.onChanged(opt);
                              setState(() => isOpen = false);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 14),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  opt,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      )
                    : const SizedBox.shrink(),
              )
            ],
          ),
        )
      ],
    );
  }
}

class SimpleMacroBarChart extends StatefulWidget {
  final List<Map<String, dynamic>> data;
  final String title;
  final String valueKey;
  final String targetKey;
  final String unit; // e.g. "g" or "cal"
  final int barsToShow; // Number of bars visible at once

  const SimpleMacroBarChart({
    super.key,
    required this.data,
    required this.title,
    required this.valueKey,
    required this.targetKey,
    this.unit = "",
    this.barsToShow = 7,
  });

  @override
  State<SimpleMacroBarChart> createState() => _SimpleMacroBarChartState();
}
class _SimpleMacroBarChartState extends State<SimpleMacroBarChart> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      setState(() {
      });
    });

    // Auto-scroll to the end (most recent data) after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients && widget.data.length > widget.barsToShow) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  DateTime _parseDate(String dateString) {
    final parts = dateString.split('-');
    final day = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    final year = int.parse(parts[2]);
    return DateTime(year, month, day);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;

    if (widget.data.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Daily ${widget.title}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No data available',
              style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.6)),
            ),
          ],
        ),
      );
    }

    final sortedData = [...widget.data]..sort((a, b) {
      return _parseDate(a['date']).compareTo(_parseDate(b['date']));
    });

    // Calculate chart width based on number of bars
    // Each bar needs approximately 50 pixels of space
    final barWidth = 40.0;
    final barSpacing = 10.0;
    final totalBars = sortedData.length;
    final chartWidth = totalBars * (barWidth + barSpacing);
    
    // Account for container padding (16*2) + scrollbar + margins
    final availableWidth = screenWidth - 64; // 32 padding + 32 margin buffer

    return Container(
      padding: const EdgeInsets.all(16),
      width: screenWidth, // Constrain to screen width
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and scroll indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Daily ${widget.title}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              if (totalBars > widget.barsToShow)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.swipe_left,
                        size: 16,
                        color: colorScheme.onPrimaryContainer,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Scroll',
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Showing $totalBars days',
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 16),
          
          // Scrollable chart container
          SizedBox(
            height: 300,
            width: availableWidth, // Constrain width
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: chartWidth > availableWidth ? chartWidth : availableWidth,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: _calculateMaxY(sortedData),
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipColor: (group) => colorScheme.surfaceContainerHighest,
                        tooltipBorder: BorderSide(color: colorScheme.outline),
                        tooltipPadding: const EdgeInsets.all(8),
                        tooltipMargin: 8,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          final item = sortedData[group.x.toInt()];
                          final date = item['date'];
                          final value = (item[widget.valueKey] ?? 0.0) as double;
                          final target = (item[widget.targetKey] ?? 0.0) as double;
                          final percentage = target > 0 ? (value / target * 100) : 0;

                          return BarTooltipItem(
                            '$date\n'
                            '${value.toStringAsFixed(0)} / ${target.toStringAsFixed(0)} ${widget.unit}\n'
                            '${percentage.toStringAsFixed(0)}% of goal\n'
                            '${value >= target ? '✅ Goal met' : '❌ Goal missed'}',
                            TextStyle(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            if (value.toInt() >= sortedData.length) {
                              return const Text('');
                            }
                            final dateString = sortedData[value.toInt()]['date'];
                            final date = _parseDate(dateString);

                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                '${date.day}/${date.month}',
                                style: TextStyle(
                                  color: colorScheme.onSurface,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 50,
                          interval: _calculateInterval(sortedData),
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toInt().toString(),
                              style: TextStyle(
                                color: colorScheme.onSurface,
                                fontSize: 11,
                              ),
                            );
                          },
                        ),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: _calculateInterval(sortedData),
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: colorScheme.outline.withValues(alpha: 0.2),
                          strokeWidth: 1,
                        );
                      },
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border(
                        bottom: BorderSide(
                          color: colorScheme.outline,
                          width: 1,
                        ),
                        left: BorderSide(
                          color: colorScheme.outline,
                          width: 1,
                        ),
                      ),
                    ),
                    barGroups: sortedData.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      final value = (item[widget.valueKey] ?? 0.0) as double;
                      final target = (item[widget.targetKey] ?? 0.0) as double;
                      final metGoal = value >= target * 0.9; // 90% threshold

                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: value,
                            gradient: LinearGradient(
                              colors: metGoal
                                  ? [Colors.green.shade400, Colors.green.shade700]
                                  : [Colors.red.shade400, Colors.red.shade700],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                            width: barWidth - 16,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(4),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _calculateMaxY(List<Map<String, dynamic>> data) {
    double maxValue = 0;
    for (final item in data) {
      final value = (item[widget.valueKey] ?? 0.0) as double;
      final target = (item[widget.targetKey] ?? 0.0) as double;
      final max = value > target ? value : target;
      if (max > maxValue) maxValue = max;
    }
    // Add 10% padding to top
    return maxValue * 1.1;
  }

  double _calculateInterval(List<Map<String, dynamic>> data) {
    final maxY = _calculateMaxY(data);
    // Try to show around 5-6 horizontal lines
    final rawInterval = maxY / 5;
    // Round to nearest nice number
    if (rawInterval < 10) return 10;
    if (rawInterval < 50) return 50;
    if (rawInterval < 100) return 100;
    if (rawInterval < 500) return 500;
    return (rawInterval / 100).ceil() * 100;
  }
}


class FilterButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isSelected;

  const FilterButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.grey.shade800,
          foregroundColor: isSelected ? Colors.white : Colors.grey.shade300,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

class MacroTile extends StatefulWidget {
  final String label;
  final double eaten;
  final double goal;
  final Color bgColor;
  final Color fgColor;
  final IconData icon;
  final double size;
  final double strokeWidth;
  final Duration animationDuration;

  const MacroTile({
    super.key,
    required this.label,
    required this.eaten,
    required this.goal,
    required this.bgColor,
    required this.fgColor,
    required this.icon,
    this.size = 70,
    this.strokeWidth = 5,
    this.animationDuration = const Duration(milliseconds: 700),
  });

  @override
  State<MacroTile> createState() => _MacroTileState();
}

class _MacroTileState extends State<MacroTile>
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
  void didUpdateWidget(covariant MacroTile oldWidget) {
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

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _CircularProgressPainter(
              progress: percent,
              backgroundArcColor: widget.bgColor,
              foregroundArcColor: widget.fgColor,
              strokeWidth: widget.strokeWidth,
            ),
          ),
          Icon(
            widget.icon,
            size: widget.size * 0.32,
            color: widget.fgColor,
          ),
        ],
      ),
    );
  }
}

/// Draws circular arcs for progress visualization.
class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color backgroundArcColor;
  final Color foregroundArcColor;
  final double strokeWidth;

  _CircularProgressPainter({
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
  bool shouldRepaint(covariant _CircularProgressPainter old) {
    return old.progress != progress ||
        old.backgroundArcColor != backgroundArcColor ||
        old.foregroundArcColor != foregroundArcColor ||
        old.strokeWidth != strokeWidth;
  }
}