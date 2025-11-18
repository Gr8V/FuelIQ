import 'package:flutter/material.dart';
import 'package:fuel_iq/models/daily_data.dart';
import 'package:fuel_iq/providers/daily_data_provider.dart';
import 'package:fuel_iq/providers/history_provider.dart';
import 'package:fuel_iq/utils/date_utils.dart';
import 'package:fuel_iq/utils/utils.dart';
import 'package:provider/provider.dart';

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

  // Format dd-MM-yyyy
  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";
  }

  Future<void> _loadWeights() async {
    setState(() => _isLoading = true);

    final dailyProvider =
        Provider.of<DailyDataProvider>(context, listen: false);
    final historyProvider =
        Provider.of<HistoryProvider>(context, listen: false);

    // Load last 30 days efficiently (better than 30 awaits in a loop)
    final futures = <Future>[];
    for (int i = 0; i < 30; i++) {
      final date = _formatDate(DateTime.now().subtract(Duration(days: i)));
      futures.add(dailyProvider.loadDailyData(date));
    }
    await Future.wait(futures);

    // Load weight history
    final loadedWeights = await historyProvider.getWeightHistory();

    if (!mounted) return;
    setState(() {
      _weights = loadedWeights;
      _isLoading = false;
    });

    // autofill today's weight into text field
    final today = _formatDate(DateTime.now());
    if (_weights.containsKey(today) && _weights[today] != 0.0) {
      _controller.text = _weights[today]!.toString();
    }
  }

  Future<void> _saveWeight() async {
    if (_controller.text.isEmpty) {
      _showMessage("Please enter a weight");
      return;
    }

    final weight = double.tryParse(_controller.text);
    if (weight == null || weight <= 0) {
      _showMessage("Please enter a valid weight");
      return;
    }

    final dailyProvider =
        Provider.of<DailyDataProvider>(context, listen: false);
    final historyProvider =
        Provider.of<HistoryProvider>(context, listen: false);

    final today = DateUtilsExt.today();

    // Load existing day or create new
    final existing = dailyProvider.getDailyData(today) ?? DailyDataModel();
    existing.weight = weight;

    // Save to provider/storage
    await dailyProvider.updateDailyData(today, existing);

    // Reload weight history
    final newWeights = await historyProvider.getWeightHistory();

    if (!mounted) return;
    setState(() {
      _weights = newWeights;
    });

    _showMessage("Weight saved successfully!");
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final today = _formatDate(DateTime.now());
    final todaysWeight = _weights[today];

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          'Weight',
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

      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Input Card
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

                  // Today's weight
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

                  // Weight chart (already provided)
                  Expanded(
                    child: SimpleLineChart(data: _weights),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Total entries: ${_weights.length}",
                    style: TextStyle(
                      fontSize: 14,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
