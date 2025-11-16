import 'package:flutter/material.dart';
import 'package:fuel_iq/services/daily_data_provider.dart';
import 'package:fuel_iq/services/utils.dart';
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

    final loadedWeights = await provider.getAllWeights();
    setState(() {
      _weights = loadedWeights;
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
    
    setState(() async {
      _weights = await provider.getAllWeights();
    });
    if (!mounted) return;

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
      //app bar
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
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
