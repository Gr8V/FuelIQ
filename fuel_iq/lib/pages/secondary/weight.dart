import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';

class WeightPage extends StatefulWidget {
  const WeightPage({super.key});

  @override
  State<WeightPage> createState() => _WeightPageState();
}

class _WeightPageState extends State<WeightPage> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _weights = []; // [{date: "2025-10-23", weight: 78.5}, ...]

  @override
  void initState() {
    super.initState();
    _loadWeights();
  }

  Future<void> _loadWeights() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('weights');
    if (data != null) {
      setState(() {
        _weights = List<Map<String, dynamic>>.from(json.decode(data));
      });
    }
  }

  Future<void> _saveWeight() async {
    final input = _controller.text.trim();
    if (input.isEmpty) return;

    final double? weight = double.tryParse(input);
    if (weight == null) return;

    final today = DateTime.now();
    final dateStr = "${today.year}-${today.month}-${today.day}";

    // Replace if already exists for today
    _weights.removeWhere((w) => w['date'] == dateStr);
    _weights.add({'date': dateStr, 'weight': weight});

    _weights.sort((a, b) => a['date'].compareTo(b['date']));

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('weights', json.encode(_weights));

    setState(() {});
    _controller.clear();
  }

  List<FlSpot> _getChartSpots() {
    List<FlSpot> spots = [];
    for (int i = 0; i < _weights.length; i++) {
      spots.add(FlSpot(i.toDouble(), _weights[i]['weight']));
    }
    return spots;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input Section
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Enter today’s weight (kg)",
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
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      ),
                      child: const Text("Save"),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Chart Section
            Expanded(
              child: _weights.isEmpty
                  ? Center(
                      child: Text(
                        "No data yet. Add your weight above!",
                        style: TextStyle(color: colorScheme.onSurfaceVariant),
                      ),
                    )
                  : Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: LineChart(
                          LineChartData(
                            gridData: FlGridData(show: true),
                            titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    if (value < 0 || value >= _weights.length) return const SizedBox();
                                    return Text(
                                      _weights[value.toInt()]['date'].split('-').sublist(1).join('/'),
                                      style: const TextStyle(fontSize: 10),
                                    );
                                  },
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: true, reservedSize: 35),
                              ),
                            ),
                            borderData: FlBorderData(show: true),
                            lineBarsData: [
                              LineChartBarData(
                                isCurved: true,
                                color: colorScheme.primary,
                                barWidth: 3,
                                dotData: FlDotData(show: true),
                                spots: _getChartSpots(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
