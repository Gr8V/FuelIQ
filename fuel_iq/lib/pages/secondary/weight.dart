import 'package:flutter/material.dart';
import 'package:fuel_iq/services/daily_data_provider.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

class WeightPage extends StatefulWidget {
  const WeightPage({super.key});

  @override
  State<WeightPage> createState() => _WeightPageState();
}

class _WeightPageState extends State<WeightPage> {
  final TextEditingController _controller = TextEditingController();
  Map<String, double> _weights = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWeights();
  }

  // Helper to format date as dd-MM-yyyy
  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";
  }

  Future<void> _loadWeights() async {
    setState(() => _isLoading = true);
    
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
      _weights = provider.getAllLoadedWeights();
      _isLoading = false;
    });
    
    // Set today's weight in the text field if it exists
    final todaysDate = _formatDate(DateTime.now());
    if (_weights.containsKey(todaysDate) && _weights[todaysDate] != 0.0) {
      _controller.text = _weights[todaysDate].toString();
    }
  }

  Future<void> _saveWeight() async {
    if (_controller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a weight")),
      );
      return;
    }

    final weight = double.tryParse(_controller.text);
    if (weight == null || weight <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid weight")),
      );
      return;
    }

    final provider = Provider.of<DailyDataProvider>(context, listen: false);
    final todaysDate = _formatDate(DateTime.now());
    
    // Get current day's data
    final currentData = provider.getDailyData(todaysDate) ?? {
      'calories': 0.0,
      'protein': 0.0,
      'carbs': 0.0,
      'fats': 0.0,
      'water': 0.0,
      'weight': 0.0,
      'foods': [],
    };
    
    // Update with new weight
    currentData['weight'] = weight;
    
    await provider.updateDailyData(todaysDate, currentData);
    
    setState(() {
      _weights = provider.getAllLoadedWeights();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Weight saved successfully!")),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final todaysDate = _formatDate(DateTime.now());
    final todaysWeight = _weights[todaysDate];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Daily Weight Tracker",
          style: TextStyle(
            color: colorScheme.onPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.25,
          ),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Input Section
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: "Enter today's weight (kg)",
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: _saveWeight,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                              foregroundColor: colorScheme.onPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 20,
                              ),
                            ),
                            child: const Text("Save"),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Display today's weight
                  if (todaysWeight != null && todaysWeight != 0.0)
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Today's Weight:",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              "${todaysWeight.toStringAsFixed(1)} kg",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  const SizedBox(height: 20),
                  SimpleLineChart(data: _weights,),
                  // Weight history count
                  Text(
                    "Total entries: ${_weights.length}",
                    style: TextStyle(
                      fontSize: 14,
                      color: colorScheme.onSurface
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

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