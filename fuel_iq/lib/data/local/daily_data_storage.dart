import 'package:fuel_iq/models/daily_data_model.dart';
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
  static DailyDataModel getOrCreateDay(String date) {
  final raw = _box.get(date);
  if (raw == null) {
    final empty = DailyDataModel();
    _box.put(date, empty.toJson());
    return empty;
  }

  return DailyDataModel.fromJson(
    Map<String, dynamic>.from(raw),
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