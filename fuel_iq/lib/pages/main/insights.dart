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
  List<Map<String, dynamic>> calories = [];
  List<Map<String, dynamic>> protein = [];
  List<Map<String, dynamic>> carbs = [];
  List<Map<String, dynamic>> fats = [];
  bool isLoading = true;
  int? daysToShow;

  @override
  void initState() {
    super.initState();
    _loadData();
    
    // Listen for provider changes
    final provider = context.read<DailyDataProvider>();
    provider.addListener(_onProviderChanged);
  }

  @override
  void dispose() {
    // Remove listener when widget is disposed
    final provider = context.read<DailyDataProvider>();
    provider.removeListener(_onProviderChanged);
    super.dispose();
  }

  void _onProviderChanged() {
    // Reload data when provider notifies changes
    _loadData();
  }
  
  void _changeDaysFilter(int? days) async {
  if (daysToShow == days) return; // Don't reload if same filter
  
  setState(() {
    daysToShow = days;
    isLoading = true; // Show loading indicator
  });
  
  await _loadData();
}

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
    });

    final provider = context.read<DailyDataProvider>();
    
    final results = await Future.wait([
      provider.getAllLoadedCalories(lastDays: daysToShow),
      provider.getAllLoadedProtein(lastDays: daysToShow),
      provider.getAllLoadedCarbs(lastDays: daysToShow),
      provider.getAllLoadedFats(lastDays: daysToShow),
    ]);
    
    if (mounted) {
      setState(() {
        calories = results[0];
        protein = results[1];
        carbs = results[2];
        fats = results[3];
        isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    double avgCalories = 0;

    if (calories.isNotEmpty) {
      avgCalories = calories
        .map((entry) => entry['calories'] as double)
        .reduce((a, b) => a + b) /
        calories.length;
    }
    double getProteinConsistency() {
    if (protein.isEmpty) return 0.0;

    int daysHit = 0;

    for (final day in protein) {
      final protein = (day['protein'] ?? 0.0) as double;
      final target = (day['proteinTarget'] ?? 0.0) as double;

      if (target > 0 && protein >= 0.9 * target) { // hit if ≥90% of target
        daysHit++;
      }
    }

    return (daysHit / protein.length) * 100; // consistency percentage
  }


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
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- Avg Calories Card ---
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                          Theme.of(context).colorScheme.secondary.withValues(alpha: 0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Avg Calories",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "${avgCalories.toStringAsFixed(1)} kcal",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // --- Protein Consistency Card ---
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
                          Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
                        ],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Protein Consistency",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${getProteinConsistency().toStringAsFixed(2)}%',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              Column(
                children: [
                  //calories chart
                  ExpansionTile(
                    title: const Text("Calories"),
                    leading: const Icon(Icons.insights),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                    childrenPadding: const EdgeInsets.all(12),
                    children: [
                      SimpleMacroBarChart(
                            data: calories,
                            title: 'Calories',
                            valueKey: 'calories',
                            targetKey: 'calorieTarget',
                            unit: 'kcal',
                          )
                    ],
                  ),
                
                  //protein chart
                  ExpansionTile(
                    title: const Text("Protein"),
                    leading: const Icon(Icons.insights),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                    childrenPadding: const EdgeInsets.all(12),
                    children: [
                      SimpleMacroBarChart(
                            data: protein,
                            title: 'Protein',
                            valueKey: 'protein',
                            targetKey: 'proteinTarget',
                            unit: 'g',
                          )
                    ],
                  ),
                
                  //carbs chart
                  ExpansionTile(
                    title: const Text("Carbs"),
                    leading: const Icon(Icons.insights),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                    childrenPadding: const EdgeInsets.all(12),
                    children: [
                      SimpleMacroBarChart(
                            data: carbs,
                            title: 'Carbs',
                            valueKey: 'carbs',
                            targetKey: 'carbsTarget',
                            unit: 'g',
                          )
                    ],
                  ),
                
                  //fats chart
                  ExpansionTile(
                    title: const Text("Fats"),
                    leading: const Icon(Icons.insights),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                    childrenPadding: const EdgeInsets.all(12),
                    children: [
                      SimpleMacroBarChart(
                            data: fats,
                            title: 'Fats',
                            valueKey: 'fats',
                            targetKey: 'fatsTarget',
                            unit: 'g',
                          )
                    ],
                  ),
                ],
              ),
              const SizedBox(height:40),
            
               // --- Filter Buttons ---
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilterButton(
                    label: "7D",
                    isSelected: daysToShow == 7,
                    onPressed: () => _changeDaysFilter(7),
                  ),
                  FilterButton(
                    label: "30D",
                    isSelected: daysToShow == 30,
                    onPressed: () => _changeDaysFilter(30),
                  ),
                  FilterButton(
                    label: "All",
                    isSelected: daysToShow == null,
                    onPressed: () => _changeDaysFilter(null),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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
