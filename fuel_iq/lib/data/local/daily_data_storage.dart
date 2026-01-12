import 'package:fuel_iq/models/daily_data.dart';
import 'package:hive_ce/hive.dart';

class DailyDataStorage {
  static Box get _box =>  Hive.box('dailyDataBox');

  // Write data for one date
  Future<void> saveDailyData({
    required String date,
    required Map<String, dynamic> data,
  }) async {
    await _box.put(date, data);
  }

  /// Load data for ONE date
  DailyDataModel? loadDailyData(String date) {
    final json = _box.get(date);
    if (json == null) return null;

    return DailyDataModel.fromJson(
      Map<String, dynamic>.from(json),
    );
  }

  // Read ALL days Data
  Map<String, dynamic> getAllData() {
    return Map<String, dynamic>.from(_box.toMap());
  }

  // Clear Box
  Future<void> clearAllData() async {
    await _box.clear();
  }
}