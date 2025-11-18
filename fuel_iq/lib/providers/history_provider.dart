import 'package:flutter/material.dart';
import '../services/local_storage.dart';
import '../utils/date_utils.dart';

class HistoryProvider extends ChangeNotifier {
  Future<List<Map<String, dynamic>>> getMacroHistory(
    String key, {
    int? lastDays,
  }) async {
    final all = await LocalStorageService.getAllData();
    final List<Map<String, dynamic>> results = [];

    DateTime? cutoffDate;
    if (lastDays != null) {
      cutoffDate = DateTime.now().subtract(Duration(days: lastDays));
    }

    all.forEach((dateString, json) {
      final value = json[key];
      if (value == null) return;

      final date = DateUtilsExt.parse(dateString);

      // Apply date filter
      if (cutoffDate != null && date.isBefore(cutoffDate)) {
        return;
      }

      // Skip zero values
      if (value == 0 || value == 0.0) return;

      // Convert safely
      final doubleValue =
          value is num ? value.toDouble() : double.tryParse(value.toString()) ?? 0.0;

      results.add({
        'date': dateString,
        key: doubleValue,
      });
    });

    // Newest first
    results.sort((a, b) =>
        DateUtilsExt.parse(b['date']).compareTo(DateUtilsExt.parse(a['date'])));

    return results;
  }


  Future<Map<String, double>> getWeightHistory() async {
    final all = await LocalStorageService.getAllData();
    final map = <String, double>{};

    all.forEach((date, json) {
      if (json['weight'] != null && json['weight'] != 0) {
        map[date] = json['weight'].toDouble();
      }
    });

    return map;
  }
}
