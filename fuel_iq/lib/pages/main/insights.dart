import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fuel_iq/pages/secondary/weight.dart';
import 'package:fuel_iq/services/daily_data_provider.dart';
import 'package:provider/provider.dart';

class Insights extends StatefulWidget {
  const Insights({super.key});

  @override
  State<Insights> createState() => _InsightsState();
}

class _InsightsState extends State<Insights> {
  Map<String, double> _calories = {};
  @override
  void initState() {
    super.initState();
    _loadCalories();
  }

  // Helper to format date as dd-MM-yyyy
  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";
  }

  Future<void> _loadCalories() async {
    
    // ✅ Use listen: false in initState
    final provider = Provider.of<DailyDataProvider>(context, listen: false);
    
    // Load last 30 days of data in dd-MM-yyyy format
    final dates = List.generate(30, (i) {
      return _formatDate(DateTime.now().subtract(Duration(days: i)));
    });
    
    for (final date in dates) {
      await provider.loadDailyData(date);
    }
    
    setState(() {
      _calories = provider.getAllLoadedCalories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      //app bar
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Insights',
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
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            /* TODO the bar chart does not update when i change the data
            SimpleCalorieBarChart(
              calories: _calories
            )
            */
          ],
        ),
      ),
    );
  }
}


class SimpleCalorieBarChart extends StatelessWidget {
  final Map<String, double> calories;

  const SimpleCalorieBarChart({
    super.key,
    required this.calories,
  });

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

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Daily Calories',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 24),
          
          SizedBox(
            height: 300,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (group) => colorScheme.surface,
                    tooltipBorder: BorderSide(color: colorScheme.outline),
                    tooltipPadding: const EdgeInsets.all(8),
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final date = calories.keys.elementAt(group.x.toInt());
                      final value = rod.toY;
                      return BarTooltipItem(
                        '$date\n${value.toStringAsFixed(0)} cal',
                        TextStyle(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
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
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= calories.length) return const Text('');
                        final dateString = calories.keys.elementAt(value.toInt());
                        final date = _parseDate(dateString);
                        
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            '${date.day}/${date.month}',
                            style: TextStyle(
                              color: colorScheme.onSurface,
                              fontSize: 12,
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
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontSize: 12,
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
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: colorScheme.outline.withValues(alpha: 0.3),
                      strokeWidth: 1,
                    );
                  },
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    bottom: BorderSide(color: colorScheme.outline),
                    left: BorderSide(color: colorScheme.outline),
                  ),
                ),
                barGroups: calories.entries.toList().asMap().entries.map((entry) {
                  final index = entry.key;
                  final calorie = entry.value.value;
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: calorie,
                        color: colorScheme.primary,
                        width: 24,
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
        ],
      ),
    );
  }
}