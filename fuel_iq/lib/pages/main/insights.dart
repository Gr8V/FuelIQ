import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fuel_iq/services/daily_data_provider.dart';
import 'package:provider/provider.dart';

class Insights extends StatefulWidget {
  const Insights({super.key});

  @override
  State<Insights> createState() => _InsightsState();
}

class _InsightsState extends State<Insights> {
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Consumer<DailyDataProvider>(
                builder: (context, provider, _) {
                  final calories = provider.getAllLoadedCalories();
                  final protein = provider.getAllLoadedProtein();
                  final carbs = provider.getAllLoadedCarbs();
                  final fats = provider.getAllLoadedFats();
                  return Column(
                    children: [
                      SimpleMacroBarChart(
                        data: calories,
                        title: 'Calories',
                        valueKey: 'calories',
                        targetKey: 'calorieTarget',
                        unit: 'kcal',
                      ),
                      SimpleMacroBarChart(
                        data: protein,
                        title: 'Protein',
                        valueKey: 'protein',
                        targetKey: 'proteinTarget',
                        unit: 'g',
                      ),
                      SimpleMacroBarChart(
                        data: carbs,
                        title: 'Carbs',
                        valueKey: 'carbs',
                        targetKey: 'carbsTarget',
                        unit: 'g',
                      ),
                      SimpleMacroBarChart(
                        data: fats,
                        title: 'Fats',
                        valueKey: 'fats',
                        targetKey: 'fatsTarget',
                        unit: 'g',
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SimpleMacroBarChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final String title;
  final String valueKey;
  final String targetKey;
  final String unit; // e.g. "g" or "cal"

  const SimpleMacroBarChart({
    super.key,
    required this.data,
    required this.title,
    required this.valueKey,
    required this.targetKey,
    this.unit = "",
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

    final sortedData = [...data]..sort((a, b) {
      return _parseDate(a['date']).compareTo(_parseDate(b['date']));
    });

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Daily $title',
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
                      final item = sortedData[group.x.toInt()];
                      final date = item['date'];
                      final value = (item[valueKey] ?? 0.0) as double;
                      final target = (item[targetKey] ?? 0.0) as double;
                      final diff = value - target;

                      return BarTooltipItem(
                        '$date\n${value.toStringAsFixed(0)} / ${target.toStringAsFixed(0)} $unit\n'
                        '${diff >= 0 ? 'Goal met ✅' : 'Goal missed ❌'}',
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
                        if (value.toInt() >= sortedData.length) return const Text('');
                        final dateString = sortedData[value.toInt()]['date'];
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
                barGroups: sortedData.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  final value = (item[valueKey] ?? 0.0) as double;
                  final target = (item[targetKey] ?? 0.0) as double;
                  final metGoal = value >= target;

                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: value,
                        color: metGoal ? Colors.green : Colors.red,
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
